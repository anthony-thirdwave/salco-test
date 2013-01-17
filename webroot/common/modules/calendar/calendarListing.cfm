<cfparam name="keywords" default="">
<cfparam name="dateCurrent" default="#Now()#">
<cfparam name="city" default="">
<cfparam name="formSubmitted" default="">
<cfparam name="ATTRIBUTES.EventDetailURL" default="#APPLICATION.utilsObj.parseCategoryUrl('event-detail-page')#">
<cfparam name="ATTRIBUTES.Mode" default="Future">
<cfparam name="ATTRIBUTES.DisplayMode" default="Default">

<cfparam name="ATTRIBUTES.lTopicID" default="">
<cfparam name="tid" default="">
<cfparam name="displayMonth" default="0">
<cfparam name="URL.ecdm" default="">
<cfparam name="URL.ecdy" default="">
<cfparam name="URL.etid" default="">

<cfset DateStart=CreateDate(year(dateCurrent),month(dateCurrent),1)>
<cfset DateEnd=DateAdd("yyyy",1,DateStart)>
<cfset HighlightMonth="#DateFormat(DateStart,'yyyymm')#">
<cfset HighlightDate="">

<cfif Val(URL.ecdm) IS NOT "0" and Val(URL.ecdy) IS NOT "0" and IsDate("#Val(URL.ecdm)#/1/#Val(URL.ecdy)#")>
	<cfset HighlightDate="#CreateDate(Val(URL.ecdy),Val(URL.ecdm),1)#">
	<cfset HighlightMonth="#DateFormat(HighlightDate,'yyyymm')#">
	<cfset ATTRIBUTES.DisplayMode="ByMonth">
</cfif>

<cfif tid IS "" and ATTRIBUTES.lTopicID IS NOT "">
	<cfset tid=ATTRIBUTES.lTopicID>
</cfif>
<cfif tid contains "all">
	<cfset tid="">
</cfif>

<cfif tid IS NOT "">
	<cfset ATTRIBUTES.DisplayMode="ByTopic">
</cfif>

<cfset EventDetailLocation=GetToken(ATTRIBUTES.EventDetailURL,1,"?")>
<cfif ListLen(ATTRIBUTES.EventDetailURL,"?") IS "2">
	<cfset EventDetailQueryString=GetToken(ATTRIBUTES.EventDetailURL,2,"?")>
<cfelse>
	<cfset EventDetailQueryString="">
</cfif>

<!--- create this in the form scope if need be --->
<cfif not structKeyExists(form, "xmlFields")>
	<cfset form.xmlFields=structNew() />
</cfif>

<cfinvoke component="com.Taxonomy.TopicHandler" method="GetTopicQuery" returnvariable="allTopics">

<script language="JavaScript">
	<cfoutput>HighlightMonth='#HighlightMonth#';</cfoutput>
</script>

<article class="news">
<div class="inArt">
<div class="artContent">
<!--- define how these fields are dealt with in the getEvents function by the scope in which they reside --->
<cfparam name="xmlFields.eventConfig.equals.eventCategory" default="">

<!--- convert any form variables with dot notation into a struct for the event object --->
<cfset form=APPLICATION.UtilsObj.formDotNotationToStruct(form) />

<cfinvoke method="getEvents" component="#APPLICATION.eventHandlerObj#" returnvariable="theEvents">
	<cfinvokeargument name="keywords" value="#trim(lCase(urlDecode(keywords)))#">
	<cfinvokeargument name="city" value="#trim(urlDecode(city))#">
	<cfinvokeargument name="Sort" value="#ATTRIBUTES.Mode#">
	<!--- use defaults if this isn't a date --->
	<cfif displayMonth and isDate(dateStart)>
		<cfset dateStart=CreateDate(Year(dateStart),month(dateStart),1)>
		<cfinvokeargument name="dateStart" value="#dateStart#">
		<cfinvokeargument name="dateEnd" value="#DateAdd('m',1,dateStart)#">
	<cfelseif isDate(dateStart) and isDate(dateEnd)>
		<cfinvokeargument name="dateStart" value="#dateStart#">
		<cfinvokeargument name="dateEnd" value="#dateEnd#">
	<cfelseif isDate(dateStart)>
		<cfinvokeargument name="dateStart" value="#dateStart#">
		<cfinvokeargument name="dateEnd" value="">
		<cfinvokeargument name="dateStartOnly" value="true">
	<cfelseif ATTRIBUTES.Mode IS "Recent">
		<cfinvokeargument name="dateStart" value="#dateAdd('m',0-APPLICATION.modules.event.EventDateRangeInMonths, now())#">
		<cfinvokeargument name="dateEnd" value="#Now()#">
	</cfif>
	<cfif tid IS NOT "">
		<cfinvokeargument name="topicIDList" value="#tid#">
	</cfif>
	<cfinvokeargument name="xmlFields" value="#xmlFields#">
	<cfinvokeargument name="getRecurringDates" value="true">
	<cfinvokeargument name="limiter" value="true">
</cfinvoke>

<cfset aBlank1=ArrayNew(1)>
<cfset aBlank2=ArrayNew(1)>
<cfloop index="i" from="1" to="#theEvents.RecordCount#" step="1">
	<cfset ArrayAppend(aBlank1,"Event")>
	<cfset ArrayAppend(aBlank2,"")>
</cfloop>

<cfset QueryAddColumn(theEvents,"EventType",aBlank1)>
<cfset QueryAddColumn(theEvents,"Alias",aBlank2)>

<!--- add employee dates for anniversary and birthdays --->
<cfif tid IS "" or ListFindNoCase("#APPLICATION.BirthdayTopicID#,#APPLICATION.AnniversaryTopicID#",tid)>
	<cfif displayMonth and isDate(dateStart)>
		<cfinvoke component="com.ContentManager.EmployeeHandler"
			method="getDates"
			returnVariable="qEmployeeEvents"
			mode="displayMonth"
			SelectedDate="#dateStart#"
			topicIDList="#tid#">
	<cfelse>
		<cfinvoke component="com.ContentManager.EmployeeHandler"
			method="getDates"
			returnVariable="qEmployeeEvents"
			mode="Future"
			SelectedDate="#dateStart#"
			topicIDList="#tid#">
	</cfif>
	<cfoutput query="qEmployeeEvents">
		<cfset QueryAddRow(theEvents)>
		<cfset QuerySetCell(theEvents,"EventType",qEmployeeEvents.EventType)>
		<cfset QuerySetCell(theEvents,"DateStart",qEmployeeEvents.DateStart)>
		<cfset QuerySetCell(theEvents,"DateEnd",qEmployeeEvents.DateStart)>
		<cfset QuerySetCell(theEvents,"DateStartYearMonth",qEmployeeEvents.DateStartYearMonth)>
		<cfset QuerySetCell(theEvents,"EventID",qEmployeeEvents.EmployeeID)>
		<cfset QuerySetCell(theEvents,"EventTitle",qEmployeeEvents.EventTitle)>
		<cfset QuerySetCell(theEvents,"Alias",qEmployeeEvents.Alias)>
	</cfoutput>
</cfif>

<cfquery name="theEvents" dbtype="query">
	select * from theEvents order by DateStart
</cfquery>

<div class="eventTitleContainer">
<cfoutput>
	<cfif ATTRIBUTES.DisplayMode IS "ByMonth">
		<h2>Events for #DateFormat(HighlightDate,"mmmm, yyyy")#</h2>
	<cfelseif ATTRIBUTES.DisplayMode IS "ByTopic">
		<cfquery name="GetTopicName" dbtype="query">
			select TopicName from allTopics where TopicID=#Tid#
		</cfquery>
		<h2>#GetTopicName.TopicName#</h2>
	<cfelse>
		<h2>Upcoming Programs and Events</h2>
	</cfif>
</cfoutput>
<div class="eventTitleRight">
<p><strong>Type of Event</strong></p>
<div id="fancyEventTypes" class="fauxSelect">
	<div class="fauxOption"></div>
	<img class="fauxArrow" src="/common/images/Intranet/template/fauxSelectArrow.png">
</div>
<form action=""><!-- this.form.submit() -->
<select type="Select" onChange="" name="tid" id="tid" style="visibility:hidden">
<option value="All" <cfif Val(tid) is "0">selected</cfif>>All</option>
<cfoutput query="allTopics">
	<option value="#TopicID#" <cfif tid IS TopicID>selected</cfif>>#TopicName#</option>
</cfoutput>
</select>
</form>
</div>
</div>
<cfif theEvents.RecordCount IS "0">
	<p style="margin-top:24px;">There are no events scheduled at this time. Please check back again soon.</p>
<cfelse>
<style title="eventCalStyles">

<cfoutput query="theEvents" group="dateStartYearMonth">
	<cfset thisIDStyles="#ListFirst(dateStartYearMonth,'/')##ListLast(dateStartYearMonth,'/')#">
		
			##title_#thisIDStyles#:target+.calListing{
				height:auto;/*100%;*/
			}
			
			##title_#thisIDStyles#:target a:before {
				content:"- ";
				font-size: 20px;}
		
</cfoutput>
</style>

	<ul class="eventsList">

	<cfoutput query="theEvents" group="dateStartYearMonth">
		<cfset thisID="#ListFirst(dateStartYearMonth,'/')##ListLast(dateStartYearMonth,'/')#">
		<li><h3 id="title_#thisID#"><a href="##title_#thisID#">#MonthAsString(ListLast(dateStartYearMonth,"/"))#, #Left(dateStartYearMonth,4)#</a></h3>
		<dl class="calListing" id="listing_#thisID#" data-titleID="title_#thisID#">
		<cfoutput group="eventID">
			<cfif EventType IS "employee">
				<dt><a name="Employee#theEvents.eventID#" style="display:block" href="#Alias#">#dateFormat(theEvents.dateStart, "mmmm d, yyyy")#</a>
				</dt>
				<dd><a name="Employee#theEvents.eventID#" href="#Alias#">#theEvents.eventTitle#</a></dd>
			<cfelse>
				<cfset thisEventConfig=xmlParse(theEvents.eventConfig) />
				<cfset thisEventDateConfig=xmlParse(theEvents.eventDateConfig) />
				<cf_AddToQueryString querystring="#EventDetailQueryString#" name="eid" value="#theEvents.PublicId#">
				<cfif Val(tid) GT "0">
					<cf_AddToQueryString querystring="#QueryString#" name="tid" value="#Val(tid)#">
				</cfif>
				<dt><a name="Event#theEvents.publicId#" style="display:block" href="#EventDetailLocation#?#QueryString#">#dateFormat(theEvents.dateStart, "mmmm d, yyyy")#
				<cfif isDate(theEvents.dateEnd) and dateFormat(theEvents.dateStart, "mmddyyyy") neq dateFormat(theEvents.dateEnd, "mmddyyyy")>
				- #dateFormat(theEvents.dateEnd, "mmmm d, yyyy")#
				</cfif></a>
				</dt>
				<dd><a name="Event#theEvents.publicId#" href="#EventDetailLocation#?#QueryString#">#theEvents.eventTitle#</a></dd>
			</cfif>
		</cfoutput>
		</dl></li>
	</cfoutput>
	</ul>
	
</cfif>
</div></div></article>
<script type="text/javascript">
	optIDs=["tid"];
	fauxOptIDs=["fancyEventTypes"];
$(window).load(function () {
	setTimeout("calendarAccordian.init()",500);
	fauxSelects.init();
});
</script>
<style title="eventCalStyles">
article .fauxSelect{
	width:145px;
	margin-top:2px;
}
article .fauxSelect .fauxArrow {
    margin-left: 35px;
}
article .fauxSelect .fauxOption a{
	width:145px;
}
</style>