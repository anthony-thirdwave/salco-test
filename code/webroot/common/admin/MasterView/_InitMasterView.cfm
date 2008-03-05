<cfset sMVEntity=StructNew()>

<cfset sMVEntityElt=StructNew()>
<cfset sMVEntityElt.Name="Content">
<cfset sMVEntityElt.Entity="Content">
<cfset sMVEntityElt.SearchQuery="">
<cfset sMVEntityElt.SearchQueryColTitle="">
<cfset sMVEntityElt.MVEid="1">
<cfset sMVEntityElt.CRUDLink="">
<cfset sMVEntity[1]=sMVEntityElt>

<cfset sMVEntityElt=StructNew()>
<cfset sMVEntityElt.Name="Sub Pages">
<cfset sMVEntityElt.Entity="Category">
<cfset sMVEntityElt.SearchQuery="">
<cfset sMVEntityElt.SearchQueryColTitle="">
<cfset sMVEntityElt.MVEid="2">
<cfset sMVEntityElt.CRUDLink="">
<cfset sMVEntity[2]=sMVEntityElt>

<cfset sMVEntityElt=StructNew()>
<cfset sMVEntityElt.Name="Save Live">
<cfset sMVEntityElt.Entity="savelive">
<cfset sMVEntityElt.SearchQuery="">
<cfset sMVEntityElt.SearchQueryColTitle="">
<cfset sMVEntityElt.MVEid="3">
<cfset sMVEntityElt.CRUDLink="">
<cfset sMVEntity[3]=sMVEntityElt>

<!--- <cfset sMVEntityElt=StructNew()>
<cfset sMVEntityElt.Name="Permissions">
<cfset sMVEntityElt.Entity="Permissions">
<cfset sMVEntityElt.SearchQuery="">
<cfset sMVEntityElt.SearchQueryColTitle="">
<cfset sMVEntityElt.MVEid="4">
<cfset sMVEntityElt.CRUDLink="">
<cfset sMVEntity[4]=sMVEntityElt> --->

<cfset MVPage="#REQUEST.CGIPathInfo#">
<cfset MVQueryString="#REQUEST.CGIQueryString#">
<cfset MVIndex="/common/admin/MasterView/index.cfm">
<cfset MVSearch="/common/admin/MasterView/search.cfm">
<cfparam name="MVMode" default="MasterView">
<cfparam name="MVEid" default="1">
<cfparam name="MVCid" default="1"><!--- CategoryID of site --->
<cfparam name="MVSearchTerms" default="">
<cfmodule Template="/common/modules/utils/GetBranchFromRoot.cfm" 
	ThisCategoryID="#MVCid#" NameList="" IDList="#MVCid#">
<cfset CategoryIDThreadList=IDList>

<cfif SESSION.AdminUserLocaleID IS "1"><!--- User is admin --->
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qLocale">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Locale">
		<cfinvokeargument name="FieldName" value="">
		<cfinvokeargument name="FieldValue" value="">
		<cfinvokeargument name="SortFieldName" value="LocaleName">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
<cfelse>
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qLocale">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Locale">
		<cfinvokeargument name="FieldName" value="LocaleID">
		<cfinvokeargument name="FieldValue" value="#Val(SESSION.AdminUserLocaleID)#">
		<cfinvokeargument name="SortFieldName" value="LocaleName">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
</cfif>
