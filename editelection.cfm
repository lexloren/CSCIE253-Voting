<cfinclude template="header.cfm">
<cfif IsUserInRole("admin") is true>

	<cfparam name="URL.electionid" default="-1" type="integer">
	<cfparam name="Form.questionid" default="-1" type="integer">
	<cfparam name="Form.questiontext" default="AAA" type="String">
	<cfparam name="Form.newtext" default="AAA" type="String">

	<cfquery name="Election"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT electionstatus, electionname
                FROM tbelection a
                WHERE a.electionid = '#URL.electionid#'
	</cfquery>

	<!--- Update question --->
	<cfif (Form.questiontext is not 'AAA') and (Election.electionstatus is 'p')>
		<cfif Form.questiontext is "">
			<cfquery name="DeleteQuestion"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
               	DELETE FROM tbquestion
				WHERE questionid = '#Form.questionid#'
			</cfquery>	
		<cfelse>		
			<cfquery name="UpdateQuestion"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
               	UPDATE tbquestion a
				SET questiontext = '#Form.questiontext#' 
				WHERE questionid = '#Form.questionid#'
			</cfquery>	
		</cfif>
	</cfif>

	<!--- Add new question --->
	<cfif (Form.newtext is not 'AAA') and (Election.electionstatus is 'p')>
			<cfquery name="UpdateQuestion"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
				INSERT INTO tbquestion 
				VALUES ('0', '#URL.electionid#', '#Form.newtext#')
			</cfquery>	
	</cfif>

	<cfquery name="Questions"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT questionid, questiontext
                FROM tbquestion
                WHERE electionid = '#URL.electionid#'
	</cfquery>
	
	<cfif Election.RecordCount IS 0>
		Election not found.
	<cfelseif Election.electionstatus is not 'p'>
		Election cannot currently be edited.
	<cfelse>
		<table>
		<cfoutput query="Questions">		
			<tr>
				<td>Question:</td>
				<form action="editelection.cfm?electionid=#electionid#" method="Post"> 
					<input type="hidden" name="questionid" value ="#questionid#">
					<td><input type="text" name="questiontext" value ="#questiontext#"></td>
					<td><input type="submit" value="Update Question"></td>
				</form>
				
				<!--- To delete a question, we simply send the question text as a 
				String with length 0. --->
				
				<form action="editelection.cfm?electionid=#electionid#" method="Post"> 
					<input type="hidden" name="questionid" value ="#questionid#">
					<input type="hidden" name="questiontext" value ="">
					<td><input type="submit" value="Delete Question"></td>
				</form>
			</tr>
			</form>
		</cfoutput>
		</table>
		
		<!--- Add a new question: --->
		<cfoutput>
			<form action="editelection.cfm?electionid=#electionid#" method="Post"> 	
				<h5>New Question:</h5>
				<input type="text" name="newtext" value ="">
				<input type="submit" value="Add">
			</form>
		</cfoutput>
		
		
		<cfinclude template="viewvoters.cfm">
		
		<form action="open.cfm" method="Post"> 
			<cfoutput>
				<input type="hidden" name="electionid" value ="#URL.electionid#">
				<input type="submit" value="Open Election">
			</cfoutput>			
		</form>
		
	</cfif>
</cfif>
<cfinclude template="footer.cfm"> 