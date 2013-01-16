<cfinclude template="header.cfm"> 
<cfif IsUserInRole("admin") is true>
								
	<cfparam name="Form.electionid" default="-1" type="integer">
	<cfparam name="Form.open" default="close" type="String">
	
	<cfquery name="Election"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
            SELECT electionstatus, electionname
            FROM tbelection a
            WHERE a.electionid = '#Form.electionid#'
	</cfquery>

	<cfif Election.RecordCount IS 0>
		Election not found.
	<cfelseif (Form.open is 'open') AND (Election.electionstatus is 'p') >
	<!--- Run opening procedures. --->
		
		<!--- Get all voters, questions for this election --->
		<cfquery name="VoteAndQ"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
			SELECT a.voterid, b.questionid
			FROM tbvoteassign a, tbquestion b
			WHERE b.electionid = '#Form.electionid#'
			AND a.electionid = b.electionid
		</cfquery>
		
		<!--- Insert question-voter pairs into tbvote --->	
		<cfoutput query="VoteAndQ">
			<cfquery name="makeVotes"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
				INSERT INTO tbvote values ('#voterid#', '#questionid#', 'x')
			</cfquery>
		</cfoutput>
			
		<!--- Send emails to voters --->
		<cfquery name="Emails"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
			SELECT DISTINCT c.UserID, c.Password
			FROM tbvoteassign a, tbquestion b, tbvoter c
			WHERE b.electionid = '#Form.electionid#'
			AND a.electionid = b.electionid
			AND a.voterid = c.voterid
		</cfquery>
			
		<cfoutput query="Emails">
			<cfmail to="#UserID#"
			from="Volunteer Voting System <lloren@fas.harvard.edu>"
			username = "#Request.emailuname#"
			password = "#Request.emailpwd#"
			server = "#Request.emailserver#"
			subject="Please Vote">
You have been invited to vote in an election.

Please go to http://cscie253.dce.harvard.edu/~lloren/vvs/index.cfm
and log in with the following credentials:
Email: #UserID#
Password: #Password#
			</cfmail>
		</cfoutput>

		
		<cfquery name="Election"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
			UPDATE tbelection
            SET electionstatus = 'o'
            WHERE electionid = '#Form.electionid#'
		</cfquery>
		
		<h5>
		Election opened.
		<form action="viewelection.cfm" method="get"> 
			<cfoutput>
				<input type="hidden" name="electionid" value ="#Form.electionid#">
				<input type="submit" value="View Election">
			</cfoutput>			 
		</form>
		</h5>
		
	<cfelse>
	
	<p>Are you sure that you want to open this election? 
		You will not be able to edit the questions or add additional voters once 
		the election is open.</p>

		<!--- Do it! --->
		<form action="open.cfm" method="Post"> 
			<cfoutput>
				<input type="hidden" name="electionid" value ="#Form.electionid#">
				<input type="hidden" name="open" value ="open">
				<input type="submit" value="Open Election">
			</cfoutput>			
		</form>

		<!--- Don't do it! --->
		<form action="viewelection.cfm" method="get"> 
			<cfoutput>
				<input type="hidden" name="electionid" value ="#Form.electionid#">
				<input type="submit" value="Cancel">
			</cfoutput>			 
		</form>
	</cfif>
</cfif>
<cfinclude template="footer.cfm"> 