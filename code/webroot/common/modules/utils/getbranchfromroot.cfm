<cfsilent><!-- Begin getbranchfromroot.cfm -->
<cfparam name="ATTRIBUTES.AliasList" default="">
<cfset ATTRIBUTES.nextCategoryID = val(ATTRIBUTES.ThisCategoryID) + 1>
<cfquery name="GetDetailOf#ATTRIBUTES.nextCategoryID#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
	SELECT	parentid
	FROM	t_Category
	WHERE	CategoryID = <cfqueryparam value="#val(ATTRIBUTES.ThisCategoryID)#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="GetParentOf#ATTRIBUTES.nextCategoryID#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
	SELECT	CategoryName,CategoryID,CategoryAlias
	FROM	t_Category
	WHERE	CategoryID = <cfqueryparam value="#val(Evaluate("GetDetailOf#ATTRIBUTES.nextCategoryID#.parentid"))#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif variables["GetParentOf#ATTRIBUTES.nextCategoryID#"].recordcount>
	<!--- grab the parentCategoryID for the cfmodule argument --->
	<cfset ATTRIBUTES.parentCategoryID = variables["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryID>
	<cfset NameList=ListPrepend(ATTRIBUTES.NameList, application.utilsObj.RemoveHTML(Replace(variables["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryName,","," ","all")))>
	<cfset IDList=ListPrepend(ATTRIBUTES.IDList,variables["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryID)>
	<cfset AliasList=ListPrepend(ATTRIBUTES.AliasList, variables["GetParentOf#ATTRIBUTES.nextCategoryID#"].CategoryAlias)>
	<cfmodule template="getbranchfromroot.cfm" ThisCategoryID="#ATTRIBUTES.parentCategoryID#" NameList="#NameList#" IDList="#IDList#" AliasList="#AliasList#">
	<cfset CALLER.NameList=NameList>
	<cfset CALLER.IDList=IDList>
	<cfset CALLER.AliasList=AliasList>
<cfelse>
	<!--- Get out of here --->
	<cfset CALLER.NameList=ATTRIBUTES.NameList>
	<cfset CALLER.IDList=ListPrepend(ATTRIBUTES.IDList,val(variables["GetDetailOf#ATTRIBUTES.nextCategoryID#"].parentid))>
	<cfset CALLER.AliasList=ATTRIBUTES.AliasList>
</cfif>
<!-- End getbranchfromroot.cfm --></cfsilent>