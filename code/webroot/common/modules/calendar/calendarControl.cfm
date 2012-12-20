<cfparam name="dateStart" default="#now()#">
<cfparam name="dateCurrent" default="#now()#">
<cfparam name="tid" default="">
<cfparam name="ATTRIBUTES.Mode" default="Default">
<cfparam name="ATTRIBUTES.lTopicID" default="">
<cfparam name="URL.PageActionURL" default="/page/events">
<cfparam name="URL.Inline" default="1">
<cfparam name="ThisLocationString" default="/page/#CurrentCategoryAlias#">

<cfif URL.Inline is "0">
	<!--- <cfsetting showdebugoutput="0"> --->
</cfif>

<cfif ATTRIBUTES.Mode IS "Default">
	<!--- <cfsetting showdebugoutput="0"> --->
</cfif>

<cfif tid IS "" and ATTRIBUTES.lTopicID IS NOT "">
	<cfset tid=ATTRIBUTES.lTopicID>
</cfif>
<cfif tid contains "all">
	<cfset tid="">
</cfif>
<cfset tid="">

<cfif NOT IsDate(dateCurrent)>
	<cfset dateCurrent=Now()>
</cfif>
<cfif NOT IsDate(dateStart)>
	<cfset dateStart=Now()>
</cfif>

<cfset dateCurrentPrev=DateAdd("m",-1,dateCurrent)>
<cfset dateCurrentNext=DateAdd("m",1,dateCurrent)>

<cfset PreviousMonthURL="#ThisLocationString#?dateCurrent=#DateFormat(dateCurrentPrev,'mm-dd-yyyy')#&tid=#URLEncodedFormat(tid)#&inline=0">
<cfset NextMonthURL="#ThisLocationString#?dateCurrent=#DateFormat(dateCurrentNext,'mm-dd-yyyy')#&tid=#URLEncodedFormat(tid)#&inline=0">

<cfif IsDefined("URL.eid")>
	<cfinvoke method="getEventIdByPublicId" component="com.event.eventHandler" returnvariable="eventId">
		<cfinvokeargument name="publicId" value="#trim(URL.eid)#">
	</cfinvoke>
	<cfinvoke method="getEvents" component="#APPLICATION.eventHandlerObj#" returnvariable="theEvent">
		<cfinvokeargument name="eventId" value="#val(eventId)#">
		<cfinvokeargument name="getDisabledDates" value="false">
	</cfinvoke>
	<cfset dateStart=theEvent.dateStart>
	<cfset PreviousMonthURL="#PreviousMonthURL#&eid=#URLEncodedFormat(URL.eid)#">
	<cfset NextMonthURL="#NextMonthURL#&eid=#URLEncodedFormat(URL.eid)#">
</cfif>

<div id="calendar">	
<div class="eventbox clearit">
	<cfinvoke method="DrawMonth" component="com.event.eventHandler" returnvariable="ThisMonth1"
		month="#Month(dateCurrent)#"
		year="#Year(dateCurrent)#"
		SelectedDate="#dateStart#"
		TopicIDList="#tid#"
		PageActionURL="#URL.PageActionURL#&Inline=0"
		PreviousMonthURL="#PreviousMonthURL#"
		NextMonthURL="#NextMonthURL#">
	<cfoutput>#ThisMonth1#</cfoutput>
</div>
<div id="calendarInlineEventsDisplay">
<div id="EventCalendarList">
<cfif URL.Inline>	
	<cfset Inline="1">
	<cfinclude template="/common/modules/calendar/EventCalendarHelper.cfm">
</cfif>
</div>
</div>
</div>
<!-- 
Below is the navigation for loading calendars via AJAX. 
jQuery is grabbing, via onclick, the href of these links and loading
*only* what it finds in #eventCal element in that page. 
(That's a safeguard aginst acciendtally loading the main page in its entirety.)
The CMS should therefore populate a given calendar page's next and prev links with
with urls relative to that calendar. - JPD
 -->

