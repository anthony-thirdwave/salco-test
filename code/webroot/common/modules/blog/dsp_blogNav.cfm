<cfparam name="ATTRIBUTES.BlogCategoryID" default="#REQUEST.CurrentCategoryID#">

<cfinvoke component="com.ContentManager.CategoryHandler"
	method="GetCategoryBasicDetails"
	CategoryID="#ATTRIBUTES.BlogCategoryID#"
	returnVariable="qGetCategoryBasicDetails">
<cfif qGetCategoryBasicDetails.RecordCount IS NOT "0">
	
	<cfset PageAction="#APPLICATION.utilsObj.parseCategoryUrl(qGetCategoryBasicDetails.CategoryAlias)#">
	
	<cfset PagePath=ListFirst(PageAction,"?")>
	<cfset PageQueryString="">
	<cfif ListLen(PageAction,"?") IS "2">
		<cfset PageQueryString=ListLast(PageAction,"?")>
	</cfif>
	
	<cfinvoke component="com.ContentManager.ContentManagerHandler" method="GetBlogEntries" returnVariable="GetThesePagesPrime">
		<cfinvokeargument name="ParentID" value="#ATTRIBUTES.BlogCategoryID#">
	</cfinvoke>
	<cfquery name="GetThesePages" dbtype="query">
		select * from GetThesePagesPrime order by Groupdate Desc
	</cfquery>
	
	<ul class="blogNav">
	<cfoutput query="GetThesePages" group="GroupDate">
		<cf_AddToQueryString queryString="#PageQueryString#" Name="m" value="#Month(GroupDate)#">
		<cf_AddToQueryString queryString="#QueryString#" Name="y" value="#Year(GroupDate)#">
	 	<li><a href="#PagePath#?#QueryString#">#lcase(DateFormat(GroupDate,"mmmm yyyy"))#</a></li>
	</cfoutput>
	</ul>
</cfif>
