<cfinclude template="header.cfm"> 

<cfparam name="URL.electionid" default="-1" type="integer">


	<cfquery name="Election"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT questionid, questiontext, electionstatus, electionname
                FROM tbelection a, tbquestion b
                WHERE a.electionid = '#URL.electionid#'
				AND  a.electionid = b.electionid
	</cfquery>

	<cfif Election.RecordCount IS 0>
		Election not found.
	<cfelse>
	
		<cfoutput>
		<h4>#Election.electionname#:</h4>
		</cfoutput>
		
		<cfif #Election.electionstatus# is 'o'>
		
			<!--- Show stats about how many have voted. --->
					<cfquery name="notVoted"
							datasource="#Request.DSN#"
							username="#Request.username#"
							password="#Request.password#">
		                SELECT count(*) "count" 
		                FROM tbelection a, tbquestion b, tbvote c
                		WHERE a.electionid = '#URL.electionid#'
						AND  a.electionid = b.electionid
						AND  b.questionid = c.questionid
						AND votecast = 'x'
					</cfquery>
					
					<cfquery name="Voted"
							datasource="#Request.DSN#"
							username="#Request.username#"
							password="#Request.password#">
		                SELECT count(*) "count" 
		                FROM tbelection a, tbquestion b, tbvote c
                		WHERE a.electionid = '#URL.electionid#'
						AND  a.electionid = b.electionid
						AND  b.questionid = c.questionid
						AND votecast != 'x'
					</cfquery>
					
					<cfoutput>
					<p>#(Voted.count / (Voted.count + notVoted.count)) * 100 #% of votes have been cast.</p>
					<p>Election is still open. 
						<!--- Only show the "close election" button if the user is an admin. --->
						<cfif IsUserInRole("admin") is true>
							<form action="close.cfm" method="post"> 
								<cfoutput>
									<input type="hidden" name="electionid" value ="#URL.electionid#">
									<input type="submit" Name="nope" value="Close Election">
								</cfoutput>			 
							</form>
						</cfif> 
					</p>
					</cfoutput>
				
		<cfelseif #Election.electionstatus# is 'c'>
			<!--- Show election results. --->
			<cfoutput query="Election">
			
				<cfquery name="getYes"
							datasource="#Request.DSN#"
							username="#Request.username#"
							password="#Request.password#">
		                SELECT count(*) "count"
		                FROM tbvote
		                WHERE questionid = #questionid#
						AND votecast = 'y'
				</cfquery>
					
				<cfquery name="getNo"
							datasource="#Request.DSN#"
							username="#Request.username#"
							password="#Request.password#">
		                SELECT count(*) "count"
		                FROM tbvote
		                WHERE questionid = #questionid#
						AND votecast = 'n'
				</cfquery>			
					
				<cfquery name="getAbs"
							datasource="#Request.DSN#"
							username="#Request.username#"
							password="#Request.password#">
		                SELECT count(*) "count"
		                FROM tbvote
		                WHERE questionid = #questionid#
						AND votecast = 'a'
				</cfquery>
				
				<cfquery name="notVoted"
							datasource="#Request.DSN#"
							username="#Request.username#"
							password="#Request.password#">
		                SELECT count(*) "count" 
		                FROM tbvote
		                WHERE questionid = #questionid#
						AND votecast = 'x'
				</cfquery>	
				
				<h5>#questiontext#</h5>
				
				<cfif (getYes.count + getNo.count + getAbs.count) is 0>
					<p>Nobody voted!</p>
				<cfelse>	
					<table>
						<tr>
							<th colspan=3></th>
						</tr>
						<tr>
							<td>Yes</td>
							<td>#getYes.count#</td>
							<td>#100 * getYes.count/(getYes.count + getNo.count+ getAbs.count)#%</td>
						</tr>
						<tr>
							<td>No:</td>
							<td>#getNo.count#</td>
							<td>#100 * getNo.count/(getYes.count + getNo.count + getAbs.count)#%</td>
						</tr>
						<tr>
							<td>Abstain:</td>
							<td>#getAbs.count#</td>
							<td>#100 * getAbs.count/(getYes.count + getNo.count + getAbs.count)#%</td>
						</tr>
						<tr>
					</table>
					
					<!--- If some votes were not cast, inform the user. --->
					
					<cfif notVoted.count is not 0>
						<p>#notVoted.count# out of 
						#getYes.count + getNo.count + getAbs.count + notVoted.count# 
						votes not cast.</p>
					</cfif>	
				</cfif>		
			</cfoutput>
		</cfif>
		<cfinclude template="viewvoters.cfm">
	</cfif>
<cfinclude template="footer.cfm"> 