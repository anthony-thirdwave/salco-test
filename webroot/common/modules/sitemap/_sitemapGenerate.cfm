<cfsetting showdebugoutput="No" RequestTimeOut="60000">

<cfparam name="ATTRIBUTES.SiteCategoryID" default="1">

<cfset SitemapFile="/common/modules/sitemap/sitemap.cfm">

<cfsaveContent Variable="FileContents">
	<ul><cfmodule template="/common/modules/sitemap/SitemapHelper.cfm" ThisCategoryID="#ATTRIBUTES.SiteCategoryID#"></ul>
</cfsavecontent>
<cffile action="WRITE" file="#ExpandPath(SitemapFile)#" output="#FileContents#" addnewline="Yes">
DONE!