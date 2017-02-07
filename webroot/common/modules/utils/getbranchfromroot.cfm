<cfsilent>
<cfparam name="ATTRIBUTES.AliasList" default="">
<cfset ATTRIBUTES.nextCategoryID=val(ATTRIBUTES.ThisCategoryID) + 1>
<cfif NOT IsDefined("REQUEST.GetDetailOf#ATTRIBUTES.nextCategoryID#")>
	<cfquery name="REQUEST.GetDetailOf#ATTRIBUTES.nextCategoryID#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
		SELECT	parentid
		FROM	t_Category
		WHERE	CategoryID=<cfqueryparam value="#val(ATTRIBUTES.ThisCategoryID)#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>
<cfif NOT IsDefined("REQUEST.GetParentOf#ATTRIBUTES.nextCategoryID#")>
	<cfquery name="REQUEST.GetParentOf#ATTRIBUTES.nextCategoryID#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
		SELECT	CategoryName,CategoryID,CategoryAlias
		FROM	t_Category
		WHERE	CategoryID=<cfqueryparam value="#val(Evaluate('REQUEST.GetDetailOf#ATTRIBUTES.nextCategoryID#.parentid'))#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfif REQUEST["GetParentOf#ATTRIBUTES.nextCategoryID#"].recordcount>
	<cfset ATTRIBUTES.parentCategoryID=REQUEST["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryID>
	<cfset NameList=ListPrepend(ATTRIBUTES.NameList,application.utilsObj.RemoveHTML(Replace(REQUEST["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryName,","," ","all")))>
	<cfset IDList=ListPrepend(ATTRIBUTES.IDList,REQUEST["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryID)>
	<cfset AliasList=ListPrepend(ATTRIBUTES.AliasList,REQUEST["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryAlias)>
	<cfmodule template="getbranchfromroot.cfm" ThisCategoryID="#ATTRIBUTES.parentCategoryID#" NameList="#NameList#" IDList="#IDList#" AliasList="#AliasList#">
	<cfset CALLER.NameList=NameList>
	<cfset CALLER.IDList=IDList>
	<cfset CALLER.AliasList=AliasList>
<cfelse>
	<cfset CALLER.NameList=ATTRIBUTES.NameList>
	<cfset CALLER.IDList=ListPrepend(ATTRIBUTES.IDList,val(REQUEST["GetDetailOf#ATTRIBUTES.nextCategoryID#"].parentid))>
	<cfset CALLER.AliasList=ATTRIBUTES.AliasList>
</cfif>
</cfsilent>