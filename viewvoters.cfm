<!--- This page is meant to be included as part of another page, but 
make sure that it's secure if accessed directly. --->
<cfif IsUserInRole("admin") is true>
	
	<cfparam name="URL.electionid" default="-1" type="integer">
	<cfparam name="Form.newvoter" default="AAA" type="String">
	<cfparam name="Form.deletevoter" default="-1" type="integer">
	<cfparam name="Form.addvoter" default="-1" type="integer">
		
	<cfquery name="Election"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
            SELECT electionstatus, electionname
            FROM tbelection 
            WHERE electionid = '#URL.electionid#'
	</cfquery>
	<cfif Election.RecordCount gt 0>
	<!--- If election exists: --->	
	
		<cfif (Form.newvoter is not 'AAA') and (Election.electionstatus is 'p')>
			<!--- Register a new voter, if requested.  --->
			
			<cfquery name="RegVoter"
						datasource="#Request.DSN#"
						username="#Request.username#"
						password="#Request.password#">
				INSERT INTO tbvoter values ('1','#Form.newvoter#', 'pass', 'voter')
			</cfquery>
			
			<cfquery name="getNewVoter"
						datasource="#Request.DSN#"
						username="#Request.username#"
						password="#Request.password#">
				SELECT voterid
	            FROM tbvoter
	            WHERE voterid = '#Form.newvoter#'
			</cfquery>			
		</cfif>
		
		<cfif (Form.deletevoter gt 0) and (Election.electionstatus is 'p')>
		<!--- Delete a voter, if requested.  --->
			<cfquery name="delVoter"
						datasource="#Request.DSN#"
						username="#Request.username#"
						password="#Request.password#">
				DELETE FROM tbvoteassign 
				WHERE voterid = '#Form.deletevoter#'
				AND electionid = '#URL.electionid#'
			</cfquery>
			
			
		</cfif>
		
		<cfif (Form.addvoter gt 0) and (Election.electionstatus is 'p')>
		<!--- Add a voter, if requested.  --->
			<cfquery name="addVoter"
						datasource="#Request.DSN#"
						username="#Request.username#"
						password="#Request.password#">
				INSERT INTO tbvoteassign values ('#Form.addvoter#', '#URL.electionid#')
			</cfquery>
		</cfif>
		
		<cfquery name="Voters"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
            SELECT a.voterid, a.UserID
            FROM tbvoter a, tbvoteassign b
            WHERE b.electionid = '#URL.electionid#'
			AND a.voterid = b.voterid
		</cfquery>
	
		<cfif Election.electionstatus is 'p'>
		<!--- Pending election: Display voters and allow editing of voter ranks --->
			
			<h5>Edit Voters:</h5>
			<table>
			<cfoutput query="Voters">
				<form action="editelection.cfm?electionid=#URL.electionid#" method="Post">
				<input type="hidden" name="deletevoter" value ="#voterid#">
				<tr>
					<td>#UserID#</td>
					<td><input type="submit" value="Delete Voter"></td>
				</tr>
				</form>
			</cfoutput>
			</table>
			
			<h5>Add a voter:</h5>
			<!--- Voters in the system can be assigned to this election --->
			
			<cfquery name="allVoters"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
	            SELECT voterid, UserID
	            FROM tbvoter 
			</cfquery>
			
			<cfoutput><form action="editelection.cfm?electionid=#URL.electionid#" method="Post"></cfoutput>
				<select name="addvoter">
                <cfoutput query="allVoters">
                  <option value="#voterid#">#UserID#</option>
                </cfoutput>
	            </select>
				<input type="submit" value="Add Voter">
			</form>
	
			<h5>Register a new voter: </h5>
			<cfoutput>
			<form action="editelection.cfm?electionid=#URL.electionid#" method="Post"> 	
				<input type="email" name="newvoter" placeholder="voter@domain.com">
				<input type="submit" value="Add Voter">
			</form>
			</cfoutput>
	
		<cfelse>
		<!--- Open/closed election: Display voters --->
		
			<h5>Voters</h5>
			<table>
			<cfoutput query="Voters">
				<tr>
				<td>#UserID#</td>
				</tr>
			</cfoutput>
			</table>
			
		</cfif>
	</cfif>
</cfif>