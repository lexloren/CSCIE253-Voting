<cfinclude template="header.cfm"> 
<cfif IsUserInRole("admin") is true>
								
	<cfparam name="Form.electionid" default="-1" type="integer">
	<cfparam name="Form.close" default="open" type="String">
	
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
	<cfelseif (Form.close is 'close') AND (Election.electionstatus is 'o') >

	<!--- Run closing procedures. --->
	<cfquery name="Close"
				datasource="#Request.DSN#"
				username="#Request.username#"
				password="#Request.password#">
			UPDATE tbelection 
			SET electionstatus='c' 
			WHERE electionid = '#Form.electionid#'
	</cfquery>
	
	<cfoutput>
		<p>#Election.electionname# has been closed. </p>
		<form action="viewelection.cfm" method="get"> 
			<input type="hidden" name="electionid" value ="#Form.electionid#">
			<input type="submit" value="View Election">		 
		</form>
	</cfoutput>
		
	<cfelse>
		<p>Are you sure that you want to close this election? You will not be able to reopen it.</p>

		<!--- Do it! --->
		<form action="close.cfm" method="Post"> 
			<cfoutput>
				<input type="hidden" name="electionid" value ="#Form.electionid#">
				<input type="hidden" name="close" value ="close">
				<input type="submit" value="Close Election">
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