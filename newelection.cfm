<cfinclude template="header.cfm"> 
<cfif IsUserInRole("admin") is true>

	<cfparam name="Form.newelect" default="AAA" type="String">
	
	<cfif Form.newelect is not 'AAA'>
	<!--- Make it an election! --->
		<cfquery name="NewElection"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
			INSERT INTO tbelection 
			VALUES ('0','p', '#Form.newelect#')
		</cfquery>
		
		<h5>Election created.</h5>

	<cfelse>
		<h5>Election Name:</h5>
		<form action="newelection.cfm" method="Post"> 	
			<input type="text" name="newelect">
			<input type="submit" value="Create Election">
		</form>
	</cfif>

</cfif>
<cfinclude template="footer.cfm"> 