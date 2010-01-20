<cfif IsDefined("SESSION.wAdminCurrentUser")>
	<cfset SESSION.wAdminCurrentUser="">
</cfif>
<CFSCRIPT>
	sCurrentUser=StructNew();
	StructInsert(sCurrentUser, "CFToken", "#SESSION.CFToken#","1");
	StructInsert(sCurrentUser, "CFID", "#SESSION.CFID#","1");
	StructInsert(sCurrentUser, "UserLogin", "#SESSION.AdminUserLogin#","1");
	StructInsert(sCurrentUser, "UserID", "-1","1");
	StructInsert(sCurrentUser, "UserLocaleID", "-1","1");
	StructInsert(sCurrentUser, "UserGroupIDList", "-1","1");
</CFSCRIPT>
<cfwddx action="CFML2WDDX" input="#sCurrentUser#" output="SESSION.wAdminCurrentUser">

<!--- Need CFLOCK.  --PWK, 7/11/01  --->
<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
	<cfset SESSION.AdminUserID="">
	<cfset SESSION.AdminUserLogin="">
	<Cfset SESSION.AdminUserPassword="">
	<Cfset SESSION.AdminUserGroupIDList="">
	<cfset SESSION.AdminUserLocaleID="">
	<cfset SESSION.AdminCurrentAdminLocaleID="">
	<cfset StructDelete(SESSION,"qUserDashboard")>
	<cfset StructDelete(SESSION,"sGlobalSearch")>	
</cflock>
<cflocation url="/common/admin/" addtoken="No">
