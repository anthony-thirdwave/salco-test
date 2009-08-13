<cfparam name="ATTRIBUTES.SiteCategoryID" default="1">

<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
	SELECT	DisplayOrder
	FROM	t_Category
	WHERE	CategoryID = <cfqueryparam value="#Val(ATTRIBUTES.SiteCategoryID)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT	MAX(CacheDateTime)
	AS		CacheDateTime
	FROM	t_Category
	WHERE	DisplayOrder LIKE <cfqueryparam value="#GetDisplayOrder.DisplayOrder#%" cfsqltype="cf_sql_varchar">
</cfquery>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+SiteMap_#ATTRIBUTES.SiteCategoryID#_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">
<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#")>
	<cfsaveContent Variable="FileContents">
		<cfmodule template="/common/modules/sitemap/SitemapHelper.cfm" ThisCategoryID="#ATTRIBUTES.SiteCategoryID#">
	</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">