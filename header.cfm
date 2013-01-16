<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>Volunteer Voting System</title>
		<link href="bootstrap.css" rel="stylesheet">
	</head>
	<body>
	
	<div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="index.cfm">Volunteer Voting System</a>
		
		<!--- ########## If user is logged in, give them a logout button. ########## --->
		
			<cfif GetAuthUser() NEQ ""> 
        	<cfoutput> 
                <form action="index.cfm" method="Post"> 
                <input type="submit" Name="Logout" value="Logout" class="btn" style="float: right"> 
            </form> 
        	</cfoutput> 
    		</cfif>

        </div>
      </div>
    </div>
	<div class="container">
	