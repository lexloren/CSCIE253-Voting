<cfif IsUserInRole("admin") is true>
	<a href="newelection.cfm">(create election)</a>

	<!--- Pending Elections --->
<h5>Pending Elections:</h5>
	<cfquery name="Pending"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT *  
                FROM tbelection 
                WHERE electionstatus = 'p' 
	</cfquery>

	<cfif Pending.RecordCount IS 0>
		<p>No pending elections.</p>
	<cfelse>
		<table>
			<cfoutput query="Pending">
				<tr>
					<td>#electionname#</td>
					<td><a href="editelection.cfm?electionid=#electionid#">edit election</a></td>
				</tr>
			</cfoutput> <!--- query="Pending" --->
		</table>
	</cfif>  <!--- ### Pending.RecordCount IS 0 --->
	
	<!--- Open Elections --->
<h5>Open Elections:</h5>
	<cfquery name="Open"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT *  
                FROM tbelection 
                WHERE electionstatus = 'o' 
	</cfquery>

	<cfif Open.RecordCount IS 0>
		<p>No open elections.</p>
	<cfelse>
		<table>
			<cfoutput query="Open">
				<tr>
					<td>#electionname#</td>
					<td><a href="viewelection.cfm?electionid=#electionid#">view election</a></td>
				</tr>
			</cfoutput> <!--- query="Open" --->
		</table>
	</cfif>  <!--- ### Open.RecordCount IS 0 --->
	
	
	<!--- Closed Elections --->
<h5>Closed Elections:</h5>
	<cfquery name="Closed"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT *  
                FROM tbelection 
                WHERE electionstatus = 'c' 
	</cfquery>

	<cfif Closed.RecordCount IS 0>
		<p>No closed elections.</p>
	<cfelse>
		<table>
			<cfoutput query="Closed">
				<tr>
					<td>#electionname#</td>
					<td><a href="viewelection.cfm?electionid=#electionid#">view election</a></td>
				</tr>
			</cfoutput> <!--- query="Closed" --->
		</table>
	</cfif>  <!--- ### Closed.RecordCount IS 0 --->
</cfif>