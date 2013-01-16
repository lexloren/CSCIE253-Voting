<cfinclude template="header.cfm">

<!--- Note: we don't let administrators vote. They can log out and log back in as a voter. --->

<cfif IsUserInRole("admin") is false>

	<cfparam name="URL.electionid" default="-1" type="integer">
	<cfparam name="Form.questionid" default="-1" type="integer">
	<cfparam name="Form.vote" default="AAA" type="String">
	
	<cfquery name="Election"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT electionstatus, electionname
                FROM tbelection a
                WHERE a.electionid = '#URL.electionid#'
	</cfquery>
	
	<!--- Update response --->
	<cfif (Form.vote is 'y' 
		OR Form.vote is 'n' 
		OR Form.vote is 'a') 
		AND (Election.electionstatus is 'o')>
		
		<cfquery name="getVoter"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT voterid
                FROM tbvoter
				WHERE UserID = '#GetAuthUser()#'
		</cfquery>
		
		<cfquery name="UpdateQuestion"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
               	UPDATE tbvote
				SET votecast = '#Form.vote#' 
				WHERE questionid = '#Form.questionid#'
				AND voterid = '#getVoter.voterid#'
		</cfquery>	
	</cfif>

	<cfquery name="Questions"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT d.questionid, d.questiontext, a.electionname, c.votecast
                FROM tbelection a, tbvoter b, tbvote c, tbquestion d
				WHERE UserID = '#GetAuthUser()#'
                AND a.electionid = '#URL.electionid#'
				AND b.voterid = c.voterid
				AND c.questionid = d.questionid
				AND a.electionid = d.electionid
				AND electionstatus = 'o'
	</cfquery>

	<cfif Questions.RecordCount gt 0>

		<cfoutput>
		<h4>#Questions.electionname#</h4>
		</cfoutput>
			
			<cfoutput query="Questions">
			<div 
				<cfif votecast IS 'x'>
					class="alert"
				<cfelse>
					class="alert alert-success"
				</cfif>
				>
				<h5>#questiontext#</h5>	
				<form action="castvotes.cfm?electionid=#electionid#" method="Post">					
					<input type="hidden" name="questionid" value ="#questionid#">
					<label class="radio">
						<input type="radio" name="vote" value='y'
							<cfif votecast IS 'y'>
								checked
							</cfif>
							>
						Yes
					</label>
					<label class="radio">
						<input type="radio" name="vote" value='n'
							<cfif votecast IS 'n'>
								checked
							</cfif>
							>
						No
					</label>
					<label class="radio">
						<input type="radio" name="vote" value='a'
							<cfif votecast IS 'a'>
								checked
							</cfif>
							>
						Abstain
					</label>
					<input type="submit" value="Cast Vote">
				</form>
			</div>	
			</cfoutput>
	</cfif>
</cfif>

<cfinclude template="footer.cfm"> 