<cfif IsDefined("SESSION.wCurrentUser")>
	<cfset SESSION.wCurrentUser="">
</cfif>
<CFSCRIPT>
	sCurrentUser=StructNew();
	StructInsert(sCurrentUser, "CFToken", "#SESSION.CFToken#","1");
	StructInsert(sCurrentUser, "CFID", "#SESSION.CFID#","1");
	StructInsert(sCurrentUser, "UserLogin", "#SESSION.UserLogin#","1");
	StructInsert(sCurrentUser, "UserID", "-1","1");
	StructInsert(sCurrentUser, "UserLocaleID", "-1","1");
	StructInsert(sCurrentUser, "UserGroupIDList", "-1","1");
</CFSCRIPT>
<cfwddx action="CFML2WDDX" input="#sCurrentUser#" output="SESSION.wAdminCurrentUser">

<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
	<cfset SESSION.UserID="">
	<cfset SESSION.UserLogin="">
	<Cfset SESSION.UserPassword="">
	<Cfset SESSION.UserGroupIDList="">
	<cfset SESSION.UserLocaleID="">
	<cfset SESSION.UserName="">
	<cfset SESSION.UserEmailAddress="">
</cflock>

<cflocation url="http://#APPLICATION.sLocation['intranet.salco']#/" addtoken="No">
