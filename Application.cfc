<!--- Adopted from Adobe's Coldfusion 10 documentation 
(http://help.adobe.com/en_US/ColdFusion/10.0/Developing/WSc3ff6d0ea77859461172e0811cbec22c24-7c30.html)
and Maria Garcia's Application.cfc. --->

<cfcomponent output="false">

   <!--- Oracle Variables --->

   <cfparam name="Request.DSN" default="cscie253">
   <cfparam name="Request.username" default="lloren">
   <cfparam name="Request.password" default="0691">

	<!--- Email Variables --->
	<cfparam name="Request.emailuname" default="lloren">
	<cfparam name="Request.emailpwd" default="Sil88ver">
	<cfparam name="Request.emailserver" default="smtp.fas.harvard.edu">

   <!--- Name this application --->
   
   <cfset this.name="VotingSystem">
   
   <!--- Turn on Session Management --->

   <cfset this.sessionManagement=true>
   <cfset This.loginstorage="session">

   <!--- Protect the whole application --->
   
 <cffunction name="OnRequestStart"> 
    <!--- <cfargument name = "request" required="true"/> --->
	
	<!--- If user has asked to be logged out, log them out. --->
		
   <cfif IsDefined("Form.logout")> 
        <cflogout> 
    </cfif>
 
    <cflogin> 
	
		<!--- If user hasn't been given the opportunity to log in, do that. --->
	
        <cfif NOT IsDefined("cflogin")> 
            <cfinclude template="login.cfm"> 
            <cfabort> 
			
		<!--- Otherwise, check the database for their info. --->
			
        <cfelse> 
            <cfquery name="loginQuery"
					datasource="#Request.DSN#"
					username="#Request.username#"
					password="#Request.password#">
                SELECT UserID, Roles
				FROM tbvoter 
                WHERE UserID = '#cflogin.name#' 
                AND Password = '#cflogin.password#' 
            </cfquery> 
			
            <cfif loginQuery.Roles NEQ ""> 
                    <cfloginuser name="#cflogin.name#" Password = "#cflogin.password#" 
                        roles="#loginQuery.Roles#"> 
            <cfelse> 
                <cfoutput> 
					<H2>Your login information is not valid.<br> 
					Please Try again</H2> 
				</cfoutput>     
				<cfinclude template="login.cfm"> 
				<cfabort> 
			</cfif>   <!--- loginQuery.Roles NEQ "" --->
        </cfif> <!--- NOT IsDefined("cflogin") --->
    </cflogin> 
</cffunction> 
</cfcomponent>
