<!--- Note: we don't let administrators vote. They can log out and log back in as a voter. --->

<cfif IsUserInRole("admin") is false>
	
	<cfoutput>
		<p>Logged in as #GetAuthUser()#</p>
	</cfoutput>
	
	<!--- Open elections --->
	<cfquery name="Open"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT DISTINCT a.electionid, a.electionname
                FROM tbelection a, tbvoter b, tbvote c, tbquestion d
                WHERE UserID = '#GetAuthUser()#'
				AND b.voterid = c.voterid
				AND c.questionid = d.questionid
				AND a.electionid = d.electionid
				AND electionstatus = 'o'
	</cfquery>

	<cfif Open.RecordCount IS 0>
		<p>There are no elections for you to vote in.</p>
	<cfelse>
		<h5>You may vote in the following elections:</h5>	
			<ul>
			<cfoutput query="Open">
				<li>
					<a href="castvotes.cfm?electionid=#electionid#">#electionname#</a>
				</li>
			</cfoutput>
			</ul>
	</cfif>

	<!--- Closed Elections --->
	<cfquery name="Closed"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT *  
                FROM tbelection 
                WHERE electionstatus = 'c' 
	</cfquery>

	<cfif Closed.RecordCount IS NOT 0>
		
		<h5>View the results of previous elections:</h5>
		<ul>
			<cfoutput query="Closed">
				<li>
					<a href="viewelection.cfm?electionid=#electionid#">#electionname#</a>
				</li>
			</cfoutput>
		</ul>
	</cfif>
</cfif>