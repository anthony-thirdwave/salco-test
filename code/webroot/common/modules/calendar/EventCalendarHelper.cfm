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

<cfif Inline IS "1">
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
	<!--- <cfquery name="GetEvents0" datasource="#ThisDSN#" maxrows="1">
		select EventDateStart FROM qry_GetEvent
		where
		EventDateStart>=<cfqueryparam value="#CreateODBCDate(now())#" cfsqltype="cf_sql_date"> AND
		EventStatusID IN (<cfqueryparam value="#APPLICATION.AllowedEventStatus#" cfsqltype="cf_sql_integer" list="yes">)
		Order by EventDateStart
	</cfquery>
	<cfif GetEvents0.RecordCount IS "1">
		<cfset theDate=GetEvents0.EventDateStart>
	<cfelse>
		<cfset theDate=Now()>
	</cfif>
	<cfquery name="GetEvents" datasource="#ThisDSN#">
		select * FROM qry_GetEvent
		where
		year(EventDateStart)=<cfqueryparam value="#year(theDate)#" cfsqltype="cf_sql_integer"> AND
		month(EventDateStart)=<cfqueryparam value="#month(theDate)#" cfsqltype="cf_sql_integer"> AND
		day(EventDateStart)=<cfqueryparam value="#day(theDate)# " cfsqltype="cf_sql_integer"> and
		EventDateStart>=<cfqueryparam value="#DateAdd('h',0,Now())#" cfsqltype="cf_sql_timestamp"><!--- Events that are 1 hour in the past (eastern) still  show up. ---> AND
		EventStatusID IN (<cfqueryparam value="#APPLICATION.AllowedEventStatus#" cfsqltype="cf_sql_integer" list="yes">)
		Order by EventDateStart
	</cfquery> --->
<cfelse>
	<!--- <cfquery name="theEvents" datasource="#ThisDSN#">
		select * FROM qry_GetEvent
		where
		year(EventDateStart)=<cfqueryparam value="#year(theDate)#" cfsqltype="cf_sql_integer"> AND
		month(EventDateStart)=<cfqueryparam value="#month(theDate)#" cfsqltype="cf_sql_integer"> AND
		day(EventDateStart)=<cfqueryparam value="#day(theDate)#" cfsqltype="cf_sql_integer"> AND
		EventStatusID IN (<cfqueryparam value="#APPLICATION.AllowedEventStatus#" cfsqltype="cf_sql_integer" list="yes">)
		Order by EventDateStart
	</cfquery> --->
	
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
</cfif>

<cfsavecontent variable="returnValue">
	<cfif theEvents.RecordCount GT "0">
		<cfoutput query="theEvents">
			<cf_AddToQueryString querystring="#EventDetailQueryString#" name="eid" value="#theEvents.PublicId#">
			<li>
			<a href="#EventDetailLocation#?#QueryString#">#eventTitle#</a>
		    </li>
		</cfoutput>
	<cfelse>
		<cfoutput><li><em>No events on this date.</em></li></cfoutput>
	</cfif>
</cfsavecontent>
<cfoutput>
	<h3 class="eventsInlineDate"><cfoutput>#DateFormat(dateStart, "ddd, mmmm dd, yyyy")#</cfoutput></h3>
	<ul class="upcomingEvents">
	#Trim(returnValue)#
	</ul>
	<div id="eventsInlineSeeAll"><a href="/page/events?ecdm=#Month(dateStart)#&ecdy=#Year(dateStart)#">See all <cfoutput>#DateFormat(dateStart, "mmmm")#</cfoutput> Events</a></div>
</cfoutput>
