	<cfinclude template="header.cfm"> 

    <cfform action="index.cfm" method="post">

  <!--- j_username and j_password are automatically put in the the cflogin.name and cflogin.password variables inside the cflogin tag--->
	
    <table>
       <tr><th colspan="2" class="highlight">Please Log In</th></tr>
       <tr>
         <td>Email:</td>
         <td>
           <cfinput input type="text" name="j_username">
         </td>
       </tr>
	   <tr>
         <td>Password:</td>
         <td>
            <cfinput type="password" name="j_password">
         </td>
       </tr>
       <tr>
         <td>&nbsp;</td>
         <td><input type="submit" name="login" value="Login" /></td>
       </tr>
    </table>
    </cfform>

    <cfinclude template = "footer.cfm">