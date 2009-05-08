<cfparam name="ATTRIBUTES.SiteCategoryID" default="1">

<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
	select DisplayOrder from t_Category Where CategoryID=#Val(ATTRIBUTES.SiteCategoryID)#
</cfquery>

<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category
	WHERE     DisplayOrder like '#GetDisplayOrder.DisplayOrder#%'
</cfquery>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+SiteMap_#ATTRIBUTES.SiteCategoryID#_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">
<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#")>
	<cfsaveContent Variable="FileContents">
		<cfmodule template="/common/modules/sitemap/SitemapHelper.cfm" ThisCategoryID="#ATTRIBUTES.SiteCategoryID#">
	</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">