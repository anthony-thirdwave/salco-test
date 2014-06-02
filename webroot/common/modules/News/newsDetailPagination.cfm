<cfparam name="ATTRIBUTES.NewsListingPage" default="/page/news-1">

<cfinvoke component="com.ContentManager.NewsHandler"
 	method="GetNews"
	newsID="#currentCategoryID#"
	returnVariable="qryNews">

<cfset thisStoryRowCount=qryNews.rowNumber>
<cfset previousStoryRowCount=thisStoryRowCount - 1>
<cfset nextStoryRowCount=thisStoryRowCount + 1>
<cfparam name="NextStoryLink" default="">
<cfparam name="previousStoryLink" default="">

<cfif previousStoryRowCount gt 0>
	<cfinvoke component="com.ContentManager.NewsHandler"
	 	method="GetNews"
		rowNumber="#previousStoryRowCount#"
		returnVariable="previousStory">
	<cfif previousStory.recordCount EQ 1>
		<cfset previousStoryLink=previousStory.link>
	</cfif>
</cfif>

<cfinvoke component="com.ContentManager.NewsHandler"
 	method="GetNews"
	rowNumber="#nextStoryRowCount#"
	returnVariable="nextStory">

<cfif nextStory.recordCount EQ 1>
	<cfset NextStoryLink=nextStory.link>
</cfif>
<cfoutput>
	<nav id="newsStoryNav">
		<ul>
			<cfif len(previousStoryLink)>
				<li><a class="next" href="#APPLICATION.utilsObj.parseCategoryUrl(previousStoryLink)#">Previous Story</a></li>
			</cfif>
			<li class="newsListing"><a href="#APPLICATION.utilsObj.parseCategoryUrl(ATTRIBUTES.NewsListingPage)#">News Listing</a></li>
			<cfif len(NextStoryLink)>
				<li><a class="prev" href="#APPLICATION.utilsObj.parseCategoryUrl(NextStoryLink)#">Next Story</a></li>
			</cfif>
			
		</ul>
	</nav>
</cfoutput>