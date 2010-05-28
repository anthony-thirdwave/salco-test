<cfparam name="ATTRIBUTES.BlogID" default="#REQUEST.CurrentCategoryID#">
	
<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
	<cfprocresult name="qGetCategoryBasicDetails" maxrows="1">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.BlogID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
</cfstoredproc>

<cfif qGetCategoryBasicDetails.RecordCount IS NOT "0">
	
	<cfset PageAction="#APPLICATION.utilsObj.parseCategoryUrl(qGetCategoryBasicDetails.CategoryAlias)#">
	<cfhtmlhead text="<link rel=""alternate"" title=""#qGetCategoryBasicDetails.CategoryNameDerived#"" href=""/resources/syndication/#qGetCategoryBasicDetails.CategoryAlias#.rss"" type=""application/rss+xml"" />">
	
	<cfset PagePath=ListFirst(PageAction,"?")>
	<cfset PageQueryString="">
	<cfif ListLen(PageAction,"?") IS "2">
		<cfset PageQueryString=ListLast(PageAction,"?")>
	</cfif>
	
	<cfinvoke component="com.ContentManager.ContentManagerHandler" method="GetBlogEntries" returnVariable="qBlogEntries">
		<cfinvokeargument name="BlogID" value="#ATTRIBUTES.BlogID#">
	</cfinvoke>
	
	<cfquery name="GetThesePages" dbtype="query">
		select * from qBlogEntries order by Groupdate Desc
	</cfquery>
	
	<ul class="blogNavDate">
	<cfoutput query="GetThesePages" group="GroupDate">
		<cfquery name="GetCount" dbtype="query">
			select Count(CategoryID) as TheCount from qBlogEntries
			Where GroupDate=#GroupDate#
		</cfquery>
		<cf_AddToQueryString queryString="#PageQueryString#" Name="m" value="#Month(GroupDate)#">
		<cf_AddToQueryString queryString="#QueryString#" Name="y" value="#Year(GroupDate)#">
	 	<li><a href="#PagePath#?#QueryString#">#lcase(DateFormat(GroupDate,"mmmm yyyy"))# (#GetCount.TheCount#)</a></li>
	</cfoutput>
	</ul>
	
	<cfinvoke component="com.ContentManager.ContentManagerHandler" method="GetBlogEntriesByTopic" returnVariable="qGetBlogEntriesByTopic">
		<cfinvokeargument name="BlogID" value="#ATTRIBUTES.BlogID#">
	</cfinvoke>
	
	<cfif qGetBlogEntriesByTopic.RecordCount GT "0">
		<ul class="blogNavTopic">
		<cfoutput query="qGetBlogEntriesByTopic" group="TopicID">
			<cfquery name="GetCount" dbtype="query">
				select Count(CategoryID) as TheCount from qGetBlogEntriesByTopic
				Where TopicID=#TopicID#
			</cfquery>
			<cf_AddToQueryString queryString="#PageQueryString#" Name="topic" value="#TopicAlias#">
		 	<li><a href="#PagePath#?#QueryString#">#TopicName# (#GetCount.TheCount#)</a></li>
			<cfhtmlhead text="<link rel=""alternate"" title=""#qGetCategoryBasicDetails.CategoryNameDerived#: #TopicName#"" href=""/resources/syndication/#qGetCategoryBasicDetails.CategoryAlias#-#TopicAlias#.rss"" type=""application/rss+xml"" />">
		</cfoutput>
		</ul>
	</cfif>
</cfif>
