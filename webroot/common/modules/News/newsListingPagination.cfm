<cfset newsListingPage="news-1">
<cfparam name="url.pageNum" default="1">
<cfset url.pageNum=Val(url.pageNum)>
<cfif Val(url.pageNum) LTE "0">
	<cfset url.pageNum="1">
</cfif>

<cfset page_links_shown=20>
<cfset records_per_page=2>
<cfset start_record=Val(url.pageNum)*Val(records_per_page)-Val(records_per_page)+1>

<cfinvoke component="com.ContentManager.NewsHandler"
 	method="GetNews"
	returnVariable="News">

<cfquery name="get_count" dbtype="query">
   SELECT COUNT(newsid) AS records 
   FROM News
</cfquery>

<cfset total_pages=ceiling(get_count.records / records_per_page)>

<cfparam name="start_page" default="1">
<cfparam name="show_pages" default="#min(page_links_shown,total_pages)#">

<cfif url.pageNum + int(show_pages / 2) - 1 GTE total_pages>
	<cfset start_page=total_pages - show_pages + 1>
<cfelseif url.pageNum + 1 GT show_pages>
	<cfset start_page=url.pageNum - int(show_pages / 2)>
</cfif>

<cfset end_page=start_page + show_pages - 1>
<cfoutput>
	<div class="news-listing-pagy">
		<cfif url.pageNum gt 1>
		<dd>
		   <a href="#APPLICATION.utilsObj.parseCategoryUrl(newsListingPage)#&pageNum=#Val(url.pageNum-1)#">&lt;</a>
		</dd>
		</cfif>
		<ul>
		<cfloop from="#start_page#" to="#end_page#" index="i">
			
			<cfif Val(url.pageNum) EQ i>
		      <li class="current">#i#</li>
			<cfelse>
		      	<li><a href="#APPLICATION.utilsObj.parseCategoryUrl(newsListingPage)#&pageNum=#Val(i)#">#i#</a></li>	
			</cfif>
			
		</cfloop>
		</ul>
			<cfif url.pageNum * records_per_page LT get_count.records>
			<dd>
			   <a href="#APPLICATION.utilsObj.parseCategoryUrl(newsListingPage)#&pageNum=#Val(url.pageNum+1)#">&gt;</a>
			 </dd>
			</cfif>
	</div>
</cfoutput>