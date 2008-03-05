<cfsilent>
<!--- Begin secure.cfm --->

<!--- The session variables should be checked and edited in a CFLOCK at the
	  very top of this tag.  --PWK, 7/11/01  --->

<!--- First enter the update portion using login form --->
<cfparam name="ATTRIBUTES.AcceptGroupIDList" default="">
<cfparam name="SESSION.AdminCurrentAdminLocaleID" default="-1"/>
<CFIF IsDefined("FORM.TryUserLogin") IS "YES" AND IsDefined("FORM.TryUserPassword") IS "YES">
	<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
		<cfset SESSION.AdminUserLogin = FORM.TryUserLogin>
		<cfset SESSION.AdminUserPassword = FORM.TryUserPassword>
	</cflock>
	<cfinvoke component="com.utils.security" method="Authenticate" returnVariable="qUser">
		<cfinvokeargument name="username" value="#Trim(SESSION.AdminUserLogin)#">
		<cfinvokeargument name="password" value="#trim(SESSION.AdminUserPassword)#">
	</cfinvoke>
	<cfif qUser.RecordCount IS "0">
		<cfset FORM.TryUserPassword="">
		<cfset StatusMessage="Incorrect Login">
	<cfelse>
		<!--- If the login was successfull, cflocation to the correct page so that
					you don't get the reload form popup when you refresh or hit the back button --->
		<cflocation url="#cgi.PATH_INFO#?#cgi.QUERY_STRING#" addtoken="no">
	</cfif>
<!--- Subsequent access to other pages ---->
<CFELSEIF IsDefined("SESSION.AdminUserLogin") IS "YES" AND IsDefined("SESSION.AdminUserPassword") IS "YES" and SESSION.AdminUserPassword IS NOT "">
	<cfinvoke component="com.utils.security" method="Authenticate" returnVariable="qUser">
		<cfinvokeargument name="username" value="#Trim(SESSION.AdminUserLogin)#">
		<cfinvokeargument name="password" value="#trim(SESSION.AdminUserPassword)#">
	</cfinvoke>
<cfelse>
<!--- Try to enter the update portion by not using form --->
	<cfinvoke component="com.utils.security" method="GetBlank" returnVariable="qUser">
	</cfinvoke>
</CFIF>
<cfdump var="#qUser#">
<cfif qUser.RecordCount IS NOT 0>
	<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
		<cfset SESSION.AdminUserID="#qUser.UserID#">
		<cfinvoke component="com.utils.security" 
			method="GetUserGroupID"
			returnVariable="lUserGroupID"
			UserID="#Val(SESSION.AdminUserID)#">
		<cfset SESSION.AdminUserLogin="#qUser.UserLogin#">
		<Cfset SESSION.AdminUserPassword="#qUser.UserPassword#">
		<cfif ListFind(lUserGroupID,APPLICATION.SuperAdminUserGroupID)>
			<Cfset SESSION.AdminUserLocaleID="1">
			<cfif Val(SESSION.AdminCurrentAdminLocaleID) LTE "0">
				<cfset SESSION.AdminCurrentAdminLocaleID="#APPLICATION.DefaultLocaleID#">
			<cfelse>
				<cfparam name="SESSION.AdminCurrentAdminLocaleID" default="#APPLICATION.DefaultLocaleID#">
			</cfif>
		<cfelse>
			<cfquery name="GetLocale" datasource="#APPLICATION.DSN#">
				select LocaleID from t_locale Where LocaleID=<cfqueryparam value="#Trim(qUser.LocaleID)#" cfsqltype="cf_sql_integer" maxlength="16">
			</cfquery>
			<cfset SESSION.AdminUserLocaleID="#GetLocale.LocaleID#">
			<cfset SESSION.AdminCurrentAdminLocaleID="#GetLocale.LocaleID#">
		</cfif>
		<cfif SESSION.CurrentAdminLocaleName IS "">
			<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
				select LanguageID,LocaleCode,LocaleName from t_Locale Where LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer" maxlength="4">
			</cfquery>
			<cfset SESSION.CurrentAdminLanguageID="#Val(GetLang.LanguageID)#">
			<cfset SESSION.CurrentAdminLocaleCode="#Trim(GetLang.LocaleCode)#">
			<cfset SESSION.CurrentAdminLocaleName="#Trim(GetLang.LocaleName)#">
		</cfif>
		<cfset SESSION.DisableRichControls=0>
	</cflock>
	<cfif IsDefined("CLIENT.wAdminCurrentUser")>
		<!--- <cfa_dump var="#Client.wCurrentUser#"> --->
		<CFWDDX action="wddx2cfml" input="#CLIENT.wAdminCurrentUser#" output="sCurrentUser">
		<cfif StructKeyExists(sCurrentUser,"UserLogin") AND sCurrentUser.UserLogin IS SESSION.AdminUserLogin AND sCurrentUser.UserID IS qUser.UserID AND sCurrentUser.CFToken IS SESSION.CFToken AND sCurrentUser.CFID IS SESSION.CFID>
			<cfset CreateNew=0>
		<cfelse>
			<cfset CreateNew=1>
		</cfif>
	<cfelse>
		<cfset CreateNew=1>
	</cfif>
	
	
	<cfif CreateNew><!--- Instantiate new Client stucture --->
		<CFSCRIPT>
			sCurrentUser=StructNew();
			StructInsert(sCurrentUser, "CFToken", "#SESSION.CFToken#","1");
			StructInsert(sCurrentUser, "CFID", "#SESSION.CFID#","1");
			StructInsert(sCurrentUser, "UserID", qUser.UserID,"1");
			StructInsert(sCurrentUser, "UserLogin", qUser.UserLogin,"1");
			StructInsert(sCurrentUser, "UserLocaleID", SESSION.AdminUserLocaleID,"1");
			StructInsert(sCurrentUser, "UserGroupIDList", lUserGroupID,"1");
		</CFSCRIPT>
	</cfif>
	<cfwddx action="CFML2WDDX" input="#sCurrentUser#" output="CLIENT.wAdminCurrentUser">
	<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
		<cfset SESSION.AdminUserGroupIDList="#lUserGroupID#">
	</cflock>
	<cfset CALLER.UserID="#qUser.UserID#">
	<cfset CALLER.UserLogin="#qUser.UserLogin#">
	<cfset CALLER.UserGroupIDList="#lUserGroupID#">
	<cfif ListLen(ATTRIBUTES.AcceptGroupIDList) GTE "1">
		<cfset DenyAccess="1">
		<cfloop index="ThisGroupID" list="#ATTRIBUTES.AcceptGroupIDList#">
			<cfif ListFind(lUserGroupID,ThisGroupID)>
				<cfset DenyAccess="0">
			</cfif>
		</cfloop>
	<cfelse>
		<cfset DenyAccess="0">
	</cfif>
<cfelse>
	<cfset DenyAccess="1">
</cfif>
</cfsilent>
<cfif DenyAccess>
	<cfset CALLER.UserID="">
	<cfset CALLER.UserLogin="">
	<cfset CALLER.UserGroupIDList="">
	<cfparam name="ATTRIBUTES.RelocateOnError" default="Yes">
	<cfif Left(CGI.SCRIPT_NAME,LEN("/common/admin/")) IS "/common/admin/">
		<cfinclude template="/common/admin/login.cfm">
		<cfabort>
	<cfelse>
		<cfif ATTRIBUTES.RelocateOnError>
			<cfparam name="ATTRIBUTES.LoginPage" default="/">
			<cflocation url="#ATTRIBUTES.LoginPage#" addtoken="No">
		</cfif>
	</cfif>
</cfif>
<Cfset CALLER.DenyAccess=DenyAccess>
