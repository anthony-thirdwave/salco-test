<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	secure="No" 
	PageHeader=""
	Page="Login"
	IncludeTopMenu="no">
	
<cfparam name="StatusMessage" default="">
<!--- The address to return to.  If it's an index, add "index.cfm".  --->
<CFSET return = CGI.SCRIPT_NAME>
<CFIF Right(return, 1) EQ "/">
	<CFSET return = return & "index.cfm">
</CFIF>

<B>Please enter your login ID</B>
<P><cfoutput>#StatusMessage#</cfoutput></P>
<table border="0" cellspacing="0" cellpadding="0">
 <tr>
  <td>
  	<cfif IsDefined("FORM") and IsStruct(FORM) and ListLen(StructKeyList(FORM)) GT "0">
		<cfoutput><form action="/common/admin/index.cfm" method="post" name="f"></cfoutput>
	<cfelse>
		<cfoutput><form action="#return#?#cgi.query_string#" method="post" name="f"></cfoutput>
	</cfif>
	<table border="0" cellspacing="0" cellpadding="0">
      <tr>
 	   <td valign="middle" nowrap>Username:</td>
  	   <td valign="middle">
        <input type="Text" name="TryUserLogin" size="20" maxlength="20">
	   </td>
 	 </tr>
     <tr>
       <td valign="TOP" nowrap>Password:&nbsp;&nbsp;</TD>
       <td valign="MIDDLE">
	    <input type="Password" name="TryUserPassword" size="20" maxlength="20"><br><P>
        <input type="Submit" name="submit" value="Go to the Administrator">
       </td>
     </tr>
     <tr>
       <td>&nbsp;</td>
       <td>&nbsp;</td>
     </tr>
    </table>
    </form>
  </td>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
 </tr>
</table>


<script language="javascript">
<!--
document.f.TryUserLogin.focus();
//-->
</script>
</cfmodule>