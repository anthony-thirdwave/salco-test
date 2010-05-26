<cfparam name="ATTRIBUTES.BlogCategoryID" default="#REQUEST.CurrentCategoryID#">
<cfparam name="URL.m" default="">
<cfparam name="URL.y" default="">

<cfinvoke component="com.ContentManager.ContentManagerHandler" method="GetBlogEntries" returnVariable="GetThesePages">
	<cfinvokeargument name="ParentID" value="#ATTRIBUTES.BlogCategoryID#">
	<cfinvokeargument name="Month" value="#Val(URL.m)#">
	<cfinvokeargument name="Year" value="#Val(URL.y)#">
</cfinvoke>

<!--- Initialize Pagination --->
<cfset SearchNum="10">
<cfparam name="StartRow" default="1">
<!--- End Initialize Pagination (why so much?)--->

<cfif GetThesePages.RecordCount gt "0">
	<cfsavecontent variable="ThisNav">
		<div class="blogListing">
		<cfoutput query="GetThesePages" group="CategoryID" maxrows="#SearchNUM#" startrow="#StartRow#">
			<h2><a href="#Link#">#CategoryNameDerived#</a></h2>
			<cfif Thumbnail IS NOT "">
				<p><a href="#Link#"><img alt="#CategoryNameDerived#" src="#Thumbnail#" width="440"></a></p>
			</cfif>
			<p class="blogAbstract">#Abstract#<br />
			<a href="#Link#" class="more">#CallToAction#</a><br />
			<span class="byline">posted by #Author# on #DateFormat(PublishDateTime,'mmmm d, yyyy')# at #TimeFormat(PublishDateTime,'hh:mm tt')#</span>
			</p>
		</cfoutput>
		</div>
		<div class="results">
			<cf_AddToQueryString QueryString="#CGI.Query_String#" name="" value="" OmitList="SearchNum,StartRow">
			<cfmodule template="/common/modules/utils/pagination.cfm"
				StartRow="#StartRow#"
				SearchNum="#SearchNum#"
				RecordCount="#GetThesePages.RecordCount#"
				FieldList="#QueryString#">
		</div>
	</cfsaveContent>
	<cfif Trim(ThisNav) IS NOT "">
		<cfoutput>#ThisNav#</cfoutput>
	</cfif>
</cfif>