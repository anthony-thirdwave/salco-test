
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
				<cfif len(NextStoryLink)>
					<li><a class="next" href="#APPLICATION.utilsObj.parseCategoryUrl(NextStoryLink)#">previous story</a></li>
				</cfif>
				<cfif len(previousStoryLink)>
					<li><a class="prev" href="#APPLICATION.utilsObj.parseCategoryUrl(previousStoryLink)#">next story</a></li>
				</cfif>
			</ul>
		</nav>
	</cfoutput>