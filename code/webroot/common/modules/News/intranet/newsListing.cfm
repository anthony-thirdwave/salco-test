<cfparam name="ATTRIBUTES.NumItems" default="">
<cfparam name="ATTRIBUTES.CategoryID" default="">
<cfparam name="ATTRIBUTES.HomePageDisplay" default="0">
<cfparam name="ATTRIBUTES.topicID" default="0">
<cfparam name="EmployeeName" default="">
<cfparam name="EmployeeLink" default="">
<cfparam name="APPLICATION.LocaleID" default="-1">

<cfparam name="url.pageNum" default="1">
<cfset url.pageNum=Val(url.pageNum)>
<cfif Val(url.pageNum) LTE "0">
	<cfset url.pageNum="1">
</cfif>

<cfset page_links_shown=20>
<cfset records_per_page=2>
<cfset start_record=Val(url.pageNum)*Val(records_per_page)-Val(records_per_page)+1>

<cfinvoke component="com.ContentManager.NewsHandler"
	homePageDisplay="#ATTRIBUTES.HomePageDisplay#"
	TopicID="#ATTRIBUTES.topicID#"
	method="GetNews"
	returnVariable="qNewsListing">
	
<cfif qNewsListing.recordCount GT 0>
	<cfoutput query="qNewsListing" startrow="#start_record#" maxrows="#records_per_page#">
		<cfset EmployeeName="">
		<cfif listlen(qNewsListing.subTitle,"&") gte 2>
			<cfset EmployeeName=listGetAt(qNewsListing.subTitle,2,"&")>
		</cfif>
		<cfset ThisClass="">
		<cfif EmergencyAlert>
			<cfset ThisClass="incmWeather">
		</cfif>
		<!--- ///// public site display ////// --->
		<cfif APPLICATION.ApplicationName IS "www.salco">
			<div class="building-blocks #ThisClass#">
		 		<dl>
					<dt>#title#</dt>
					<dd class="name"><cfif len(EmployeeName)>#EmployeeName#</cfif></dd>
					<dd class="date">#DateFormat(publishDate,"m/dd/yyyy")#</dd>
					<dd class="blurb">
					<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#description#" NumChars="90">
					<!--- 'news-detail' --->
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(link)#">Click to read more</a></dd>
					<cfif len(headerImage)>
						<dd class="image"><img alt="#title#" src="#headerImage#" /></dd>
					</cfif>
				</dl>
			</div>
		<cfelse>
			<div class="building-blocks #ThisClass#">
		 		<dl>
					<dt>#title#</dt>
					<dd class="name"><cfif len(EmployeeName)>#EmployeeName#</cfif></dd>
					<dd class="date">#DateFormat(publishDate,"m/dd/yyyy")#</dd>
					<dd class="blurb">
					<cfif EmergencyAlert>
						#description#
					<cfelse>
						<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#description#" NumChars="90">
					</cfif>
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(link)#">Click to read more</a></dd>
					<cfif len(headerImage)>
						<dd class="image"><img alt="#title#" src="#headerImage#"></dd>
					</cfif>
				</dl>
			</div>
		</cfif>
		<!--- ///// public site display ////// --->
	</cfoutput>
<cfelse>
	<p>No news items available.</p>
</cfif>

	