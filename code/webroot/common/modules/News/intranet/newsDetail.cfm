<cfparam name="ATTRIBUTES.CategoryID" default="">
<cfparam name="ATTRIBUTES.newsContent" default="">
<cfparam name="ATTRIBUTES.newsImage" default="">
<cfparam name="ATTRIBUTES.newsImagesLarge" default="">
<cfparam name="EmployeeName" default="">
<cfparam name="EmployeeLink" default="">
			
<cfinvoke component="com.ContentManager.NewsHandler"
 	method="qryNews"
	newsID="#ATTRIBUTES.CategoryID#"
	returnVariable="qryNews">

<cfif len(qryNews.SubTitle)>					
	<cfif listlen(qryNews.subTitle,"&") gte 2>
		<cfset EmployeeName=listGetAt(qryNews.subTitle,2,"&")>
		<cfset EmployeeLink=listGetAt(qryNews.subTitle,1,"&")>
	</cfif>
</cfif>				
	
<cfoutput query="qryNews">
	<article class="news">
		<div class="inArt">
			<cfif len(ATTRIBUTES.newsImage)>
				<div class="alignLeft">
					#ATTRIBUTES.newsImage#
				</div>
			</cfif>
			<h1 style="">#qryNews.title#</h1>
			<div class="byline"><cfif len(EmployeeName)><a href="#APPLICATION.utilsObj.parseCategoryUrl(EmployeeLink)#">#EmployeeName#</a></cfif></div>
			<div class="date">#DateFormat(qryNews.publishDate,"m/dd/yyyy")#</div>
			<cfif len(ATTRIBUTES.newsContent)>
				<div class="artContent">
					#ATTRIBUTES.newsContent#
				</div>
			</cfif>
			<div class="clearit"></div>
		</div>
	</article>
</cfoutput>
<div class="lrgImgs">
	<cfoutput>
		#ATTRIBUTES.newsImagesLarge#
	</cfoutput>
</div>