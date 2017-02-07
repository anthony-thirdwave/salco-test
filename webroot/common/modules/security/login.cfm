<cfparam name="ATTRIBUTES.ReturnURL" default="#CGI.Path_Info#?#CGI.Query_String#">
<cfparam name="REQUEST.sm" default="0">
<cfparam name="REQUEST.SecurityMessage" default="">
<!--- The address to return to.  If it's an index, add "index.cfm".  --->
<CFSET return=CGI.Path_Info>
<cfif CGI.Query_String NEQ "">
	<CFSET return=return & "?" & CGI.Query_String>
</cfif>
<article class="news">
<div class="inArt">
<h1>Salco Login</h1>
<div class="loginForm">

<cfif IsDefined("FORM") and IsStruct(FORM) and ListLen(StructKeyList(FORM)) GT "0">
	<cfoutput><form action="#return###a" method="post" name="f"></cfoutput>
	<!--- <cfoutput><form action="/common/admin/index.cfm" method="post" name="f"></cfoutput> --->
<cfelseif isdefined("rp")>
	<cfoutput><form action="#rp###a" method="post" name="f"></cfoutput>
<cfelse>
	<cfoutput><form action="#return###a" method="post" name="f"></cfoutput>
</cfif>
	<div class="loginRow">
		<div class="label">
			<label>&nbsp;</label>
		</div>
		<cfif REQUEST.SecurityMessage IS NOT "">
		<p class="errorText"><cfoutput>#REQUEST.SecurityMessage#</cfoutput></p>
		</cfif>
	</div>
	<div class="loginRow">
		<div class="label">
			<label>Username</label>
		</div>
		<input type="text" name="TryUserLogin" class="forms" />
	</div>
	
	<div class="loginRow">
		<div class="label">
			<label>Password</label>
		</div>
		<input type="password" name="TryUserPassword" class="forms" />
		<input type="submit" name="Submit" value="Login" class="loginButton">
	</div>
</form>



<div class="loginRow">
	<div class="label">&nbsp;</div>
	<div class="loginFormRight">
		<p class="loginTitle">Questions? Problems?<br />Forgot your password?</p>
		<p><a href="mailto:intranet@salcoproducts.com">Click here</a> to contact the site administrator.</p>
	</div>
</div>
<script language="javascript" type="text/javascript">
<!--
document.f.TryUserLogin.focus();
//-->
</script>
<cfset REQUEST.LoginFormDisplayed=1>
</div>
</div>
</article>