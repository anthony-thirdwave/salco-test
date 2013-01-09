<cfparam name="ATTRIBUTES.NumItems" default="">
<cfparam name="ATTRIBUTES.HomePageDisplay" default="0">
<cfparam name="ATTRIBUTES.topicID" default="0">
<cfparam name="EmployeeName" default="">
<cfparam name="EmployeeLink" default="">

<cfparam name="url.pageNum" default="1">
<cfset page_links_shown=20>
<cfset records_per_page=8>
<cfset start_record=Val(url.pageNum)*Val(records_per_page)-Val(records_per_page)+1>

<cfinvoke component="com.ContentManager.NewsHandler"
	homePageDisplay="#ATTRIBUTES.HomePageDisplay#"
	TopID="#ATTRIBUTES.topicID#"
	method="qryNews"
	returnVariable="qNewsListing">
	
<cfif qNewsListing.recordCount GT 0>
	<cfoutput query="qNewsListing" startrow="#start_record#" maxrows="#records_per_page#">
		<cfparam name="EmployeeName" default="">
		
		<cfif listlen(qNewsListing.subTitle,"&") gte 2>
			<cfset EmployeeName=listGetAt(qNewsListing.subTitle,2,"&")>
		</cfif>
		<cfset ThisClass="">
		<cfif EmergencyAlert>
			<cfif IsDefined("SESSION.EmergencyAlertDisplayed") and ListFindNoCase(SESSION.EmergencyAlertDisplayed,NewsID)>
				<cfset ThisClass="">
			<cfelse>
				<cfset ThisClass="incmWeather">
				<cfparam name="SESSION.EmergencyAlertDisplayed" default="">
				<cfset SESSION.EmergencyAlertDisplayed=ListAppend(SESSION.EmergencyAlertDisplayed,NewsID)>
			</cfif>
		</cfif>
		<div class="building-blocks #ThisClass#">
	 		<dl>
				<dt>#title#</dt>
				<dd class="name"><cfif len(EmployeeName)>#EmployeeName#</cfif></dd>
				<dd class="date">#DateFormat(publishDate,"m/dd/yyyy")#</dd>
				<dd class="blurb">
				<cfif EmergencyAlert>
					#description#
				<cfelse>
					<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#description#" NumChars="300">
				</cfif>
				<a href="#APPLICATION.utilsObj.parseCategoryUrl(link)#">Click to read more</a></dd>
				<cfif len(headerImage)>
					<dd class="image"><img alt="#title#" src="#headerImage#"></dd>
				</cfif>
			</dl>
		</div>
	</cfoutput>
<cfelse>
	<p>No news items available.</p>
</cfif>

	