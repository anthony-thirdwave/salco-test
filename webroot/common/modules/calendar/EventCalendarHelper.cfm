<cfparam name="Inline" default="0">
<cfparam name="keywords" default="">
<cfparam name="dateStart" default="#now()#">
<cfparam name="city" default="">
<cfparam name="formSubmitted" default="">
<cfparam name="ATTRIBUTES.EventDetailURL" default="#APPLICATION.utilsObj.parseCategoryUrl('event-detail-page')#">
<cfparam name="ATTRIBUTES.Mode" default="Future">
<cfparam name="ATTRIBUTES.lTopicID" default="">
<cfparam name="tid" default="">
<cfparam name="displayMonth" default="0">

<cfparam name="h" default="0"><!--- Is on home page? --->
<cfif Inline IS "0">
	<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
</cfif>
<cfparam name="dateStr" default="#DateFormat(dateStart,'yyyymmdd')#">
<cfset ThisDSN="#APPLICATION.EVENT_DSN#">

<cfif Len(dateStr) IS NOT LEN("yyyymmdd")>
	<cfabort>
</cfif>
<cfif not structKeyExists(form, "xmlFields")>
	<cfset form.xmlFields = structNew() />
</cfif>
<cfset dateStart=CreateDate(Val(left(dateStr,4)),Val(Mid(dateStr,5,2)),Val(Right(dateStr,2)))>

<cfset EventDetailLocation=GetToken(ATTRIBUTES.EventDetailURL,1,"?")>
<cfif ListLen(ATTRIBUTES.EventDetailURL,"?") IS "2">
	<cfset EventDetailQueryString=GetToken(ATTRIBUTES.EventDetailURL,2,"?")>
<cfelse>
	<cfset EventDetailQueryString="">
</cfif>

<cfinvoke method="getEvents" component="#APPLICATION.eventHandlerObj#" returnvariable="theEvents">
	<cfinvokeargument name="keywords" value="#trim(lCase(urlDecode(keywords)))#">
	<cfinvokeargument name="city" value="#trim(urlDecode(city))#">
	<cfinvokeargument name="Sort" value="#ATTRIBUTES.Mode#">
	<!--- use defaults if this isn't a date --->
	<cfif displayMonth and isDate(dateStart)>
		<cfset dateStart=CreateDate(Year(dateStart),month(dateStart),1)>
		<cfinvokeargument name="dateStart" value="#dateStart#">
		<cfinvokeargument name="dateEnd" value="#DateAdd('m',1,dateStart)#">
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

<cfif tid IS "" or ListFindNoCase("6277,6276",tid)>
	<cfinvoke component="com.ContentManager.EmployeeHandler"
		method="getDates"
		returnVariable="qEmployeeEvents"
		mode="displayDay"
		SelectedDate="#dateStart#"
		topicIDList="#tid#">
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
	<cfquery name="theEvents" dbtype="query">
		select * from theEvents order by DateStart
	</cfquery>

</cfif>

<cfsavecontent variable="returnValue">
	<cfif theEvents.RecordCount GT "0">
		<cfoutput query="theEvents">
			<cfif EventType IS "employee">
				<li>
				<a href="#Alias#">#eventTitle#</a>
			    </li>
			<cfelse>
				<cf_AddToQueryString querystring="#EventDetailQueryString#" name="eid" value="#theEvents.PublicId#">
				<li>
				<a href="#EventDetailLocation#?#QueryString#">#eventTitle#</a>
			    </li>
			</cfif>
		</cfoutput>
	<cfelse>
		<cfoutput><li><em>No events on this date.</em></li></cfoutput>
	</cfif>
</cfsavecontent>
<cfoutput>
	<h3 class="eventsInlineDate">#DateFormat(dateStart, "dddd, mmmm d, yyyy")#</h3>
	<ul class="upcomingEvents">
	#Trim(returnValue)#
	</ul>
	<div id="eventsInlineSeeAll"><a href="/page/events?ecdm=#Month(dateStart)#&ecdy=#Year(dateStart)#">See all #DateFormat(dateStart, "mmmm")# Events</a></div>
</cfoutput>
