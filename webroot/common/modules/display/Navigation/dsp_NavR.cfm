<cfsetting RequestTimeOut="240">

<cfparam name="ATTRIBUTES.CategoryID" default="1">
<cfparam name="ATTRIBUTES.MaxLevel" default="2">

<cfif 0>
	<cfoutput>
		<p>CategoryIDToStart: #CategoryIDToStart#-#ThisDisplayLevel#<br>
		#ATTRIBUTES.CategoryThreadList#</p>
	</cfoutput>
</cfif>

<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#" maxrows="1">
	select displayOrder from t_Category where 
	CategoryID=<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT	MAX(CacheDateTime) AS CacheDateTime
	FROM	t_Category
	WHERE	DisplayOrder like <cfqueryparam value="#GetDisplayOrder.DisplayOrder#%" cfsqltype="CF_SQL_VARCHAR">
</cfquery>

<cfset ExecuteTempFile="#APPLICATION.LocaleID#\+Nav_#APPLICATION.LocaleID#_#ATTRIBUTES.MaxLevel#_#ATTRIBUTES.CategoryID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">

<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#")>
	<cfsavecontent variable="SiteNavigation">
	<cfmodule template="/common/modules/display/navigation/dsp_NavRHelper.cfm"
		CategoryID="#ATTRIBUTES.CategoryID#"
		Level="0"
		MaxLevel="#ATTRIBUTES.MaxLevel#">
	</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#SiteNavigation#" addnewline="Yes">
</cfif>

<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
