<cfparam name="ATTRIBUTES.BreadcrumbDisplay" default="">

<cfswitch expression="#ATTRIBUTES.BreadcrumbDisplay#">
	<cfcase value="employee">
		<cfset searchPageName="employee-search">
		<cfset alphabetList="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z">
		<cfinvoke component="com.ContentManager.EmployeeHandler"
			method="GetAllEmployees"
			returnVariable="REQUEST.GetAllEmployees">
		<nav id="empl-nav">
			<div id="empl-nav-title">Search Employees:</div>
				<ul>
					<cfparam name="url.alphaListing" default="">
					<cfloop index="i" list="#alphabetList#">
						<cfquery name="qryEmployeePhoneByAlphabet" dbtype="query">
							SELECT		employeeID
							FROM		REQUEST.GetAllEmployees
							WHERE		departmentID <> <cfqueryparam value="6098" cfsqltype="cf_sql_integer">
							AND			empFirstName like <cfqueryparam value="#UCASE(Trim(i))#%" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfoutput>
							<cfif qryEmployeePhoneByAlphabet.recordCount eq 0>
								<li>#i#</li>
							<cfelse>
								<li <cfif url.alphaListing eq i>active</cfif>><a href="#APPLICATION.utilsObj.parseCategoryUrl(searchPageName)#?alphaListing=#i#">#i#</a></li>
							</cfif>
						</cfoutput>
					</cfloop>
				</ul>
		</nav>
	</cfcase>
	<cfcase value="news">
		<cfparam name="url.pageNum" default="1">
		<cfset newListingPage="news">
		<cfset page_links_shown=20>
		<cfset records_per_page=8>
		
		<cfinvoke component="com.ContentManager.NewsHandler"
		 	method="qryNews"
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
		<nav id="empl-nav">
			<div id="empl-nav-title">Search Stories:</div>
			<ul>
				<li class="newsPrevPage">
					<cfif url.pageNum gt 1>
					   <a href="#APPLICATION.utilsObj.parseCategoryUrl(newListingPage)#&pageNum=#url.pageNum-1#">Previous Page</a>
					</cfif>
				</li>
				<cfloop from="#start_page#" to="#end_page#" index="i">
				<li>
				<cfif url.pageNum EQ i>
			      	#i#
				<cfelse>
			      	<a href="#APPLICATION.utilsObj.parseCategoryUrl(newListingPage)#&pageNum=#i#">#i#</a>	
				</cfif>
				</li>
				</cfloop>
				<li class="newsNextPage">
					<cfif url.pageNum * records_per_page LT get_count.records>
					   <a href="#APPLICATION.utilsObj.parseCategoryUrl(newListingPage)#&pageNum=#url.pageNum+1#">Next Page</a>
					</cfif>
				</li>
			</ul>
		</nav>
		</cfoutput>
	</cfcase>
	<cfcase value="newsDetail">
		<cfinvoke component="com.ContentManager.NewsHandler"
		 	method="qryNews"
			newsID="#ATTRIBUTES.CategoryID#"
			returnVariable="qryNews">
		
		<cfset thisStoryRowCount=qryNews.rowNumber>
		<cfset previousStoryRowCount=thisStoryRowCount - 1>
		<cfset nextStoryRowCount=thisStoryRowCount + 1>
		<cfparam name="NextStoryLink" default="">
		<cfparam name="previousStoryLink" default="">
		
		<cfif previousStoryRowCount gt 0>
			<cfinvoke component="com.ContentManager.NewsHandler"
			 	method="qryNews"
				rowNumber="#previousStoryRowCount#"
				returnVariable="previousStory">
			<cfif previousStory.recordCount EQ 1>
				<cfset previousStoryLink=previousStory.link>
			</cfif>
		</cfif>
		
		<cfinvoke component="com.ContentManager.NewsHandler"
		 	method="qryNews"
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
	</cfcase>
</cfswitch>