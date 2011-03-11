<cfparam name="ATTRIBUTES.BlogID" default="#REQUEST.CurrentCategoryID#">
<cfparam name="URL.m" default="">
<cfparam name="URL.y" default="">
<cfparam name="URL.topic" default="">

<cfif NOT IsDefined("REQUEST.MyBlogHandler")>
	<cfobject component="com.ContentManager.BlogHandler"
		name="REQUEST.MyBlogHandler">
	<cfset REQUEST.MyBlogHandler.init()>
</cfif>

<cfinvoke component="#REQUEST.MyBlogHandler#" method="GetBlogEntries" returnVariable="REQUEST.qBlogEntries_#ATTRIBUTES.BlogID#">
	<cfinvokeargument name="BlogID" value="#ATTRIBUTES.BlogID#">
	<cfinvokeargument name="Month" value="#Val(URL.m)#">
	<cfinvokeargument name="Year" value="#Val(URL.y)#">
	<cfinvokeargument name="TopicAlias" value="#Trim(URL.topic)#">
</cfinvoke>

<!--- Initialize Pagination --->
<cfset SearchNum="10">
<cfparam name="StartRow" default="1">
<!--- End Initialize Pagination (why so much?)--->

<cfset BlogEntriesRecordCount=REQUEST["qBlogEntries_#ATTRIBUTES.BlogID#"].RecordCount>

<cfif BlogEntriesRecordCount>
	<div class="blogListing">
	<cfoutput query="REQUEST.qBlogEntries_#ATTRIBUTES.BlogID#" group="CategoryID" maxrows="#SearchNUM#" startrow="#StartRow#">
		<h2><a href="#Link#">#CategoryNameDerived#</a></h2>
		<cfif Thumbnail IS NOT "">
			<p><a href="#Link#"><img alt="#CategoryNameDerived#" src="#Thumbnail#" width="440"></a></p>
		</cfif>
		<p class="blogAbstract">#Abstract#<br />
		<a href="#Link#" class="more">#CallToAction#</a><br />
		<span class="byline">posted by #Author# on #DateFormat(PublishDateTime,'mmmm d, yyyy')# at #TimeFormat(PublishDateTime,'hh:mm tt')#</span>
		<cfif Topic IS NOT "">
			<span class="topic">posted in #Replace(Topic,",",", ","All")#</span>
		</cfif>
		</p>
	</cfoutput>
	</div>
	<div class="results">
		<cf_AddToQueryString QueryString="#CGI.Query_String#" name="" value="" OmitList="SearchNum,StartRow">
		<cfmodule template="/common/modules/utils/pagination.cfm"
			StartRow="#StartRow#"
			SearchNum="#SearchNum#"
			RecordCount="#BlogEntriesRecordCount#"
			FieldList="#QueryString#">
	</div>
</cfif>