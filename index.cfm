<cfinclude template="header.cfm"> 

<cfif IsUserInRole("admin") is true>
	<cfinclude template="admin.cfm"> 
<cfelse>
	<cfinclude template="voter.cfm"> 
</cfif>

<cfinclude template="footer.cfm"> 