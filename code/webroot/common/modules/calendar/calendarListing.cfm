<cfparam name="keywords" default="">
<cfparam name="dateStart" default="">
<cfparam name="city" default="">
<cfparam name="formSubmitted" default="">
<cfparam name="ATTRIBUTES.EventDetailURL" default="#APPLICATION.utilsObj.parseCategoryUrl('event-detail-page')#">
<cfparam name="ATTRIBUTES.Mode" default="Future">
<cfparam name="ATTRIBUTES.lTopicID" default="">
<cfparam name="tid" default="">
<cfparam name="displayMonth" default="0">

<cfparam name="URL.ecdm" default="">
<cfparam name="URL.ecdy" default="">
<cfparam name="URL.etid" default="">
<cfset ShowMonth=Val(URL.ecdm)>
<cfset ShowYear=Val(URL.ecdy)>

<cfif tid IS "" and ATTRIBUTES.lTopicID IS NOT "">
	<cfset tid=ATTRIBUTES.lTopicID>
</cfif>
<cfif tid contains "all">
	<cfset tid="">
</cfif>

<cfset EventDetailLocation=GetToken(ATTRIBUTES.EventDetailURL,1,"?")>
<cfif ListLen(ATTRIBUTES.EventDetailURL,"?") IS "2">
	<cfset EventDetailQueryString=GetToken(ATTRIBUTES.EventDetailURL,2,"?")>
<cfelse>
	<cfset EventDetailQueryString="">
</cfif>

<cfajaximport tags="cfdiv,cfform">

<cfif NOT IsDefined("StartRow")>
	<CFSET StartRow=1>
</cfif>
<cfif Val(StartRow) LTE "0">
	<CFSET StartRow=1>
</cfif>
<cfset SearchNum="10">

<!--- create this in the form scope if need be --->
<cfif not structKeyExists(form, "xmlFields")>
	<cfset form.xmlFields = structNew() />
</cfif>
<article class='news'>
<div class='inArt'>
<div class='artContent'>
<!--- define how these fields are dealt with in the getEvents function by the scope in which they reside --->
<cfparam name="xmlFields.eventConfig.equals.eventCategory" default="">

<!--- convert any form variables with dot notation into a struct for the event object --->
<cfset form = APPLICATION.UtilsObj.formDotNotationToStruct(form) />

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

<cfif theEvents.RecordCount IS "0">
	<p>There are no events scheduled at this time. Please check back again soon.</p>
<cfelse>
	<cfoutput>
		<cfif displayMonth and isDate(dateStart)>
			<h2>#DateFormat(dateStart,"mmmm, yyyy")#</h2>
		<cfelseif isDate(dateStart)>
			<h2>#DateFormat(dateStart,"mmmm d, yyyy")#</h2>
		<cfelseif ATTRIBUTES.Mode IS "Recent">
			<h2>Past Programs and Events</h2>
		<cfelse>
			<h2>Upcoming Programs and Events</h2>
		</cfif>
	</cfoutput>
	<ul class="eventsList">

	<cfoutput query="theEvents" maxrows="#val(searchNum)#" startrow="#val(startRow)#">
		<cfset thisEventConfig = xmlParse(theEvents.eventConfig) />
		<cfset thisEventDateConfig = xmlParse(theEvents.eventDateConfig) />
		<cf_AddToQueryString querystring="#EventDetailQueryString#" name="eid" value="#theEvents.PublicId#">
		<li>
		<h5>#dateFormat(theEvents.dateStart, "dddd, mmmm dd, yyyy")#
		<cfif isDate(theEvents.dateEnd) and dateFormat(theEvents.dateStart, "mmddyyyy") neq dateFormat(theEvents.dateEnd, "mmddyyyy")>
		- #dateFormat(theEvents.dateEnd, "dddd, mmmm dd, yyyy")#
		</cfif>

	    <!--- display time block --->
		<cfif toString(timeFormat(theEvents.dateStart, "HH:mm:ss")) neq "00:00:00">
			&middot; #timeFormat(theEvents.dateStart, "h:mm tt")#
			<cfif len(trim(theEvents.dateEnd)) and toString(timeFormat(theEvents.dateEnd, "HH:mm:ss")) neq "00:00:00">
			&mdash; #timeFormat(theEvents.dateEnd, "h:mm tt")#
			</cfif>
		</cfif>
		</h5>
		<h3><a name="Event#theEvents.publicId#" href="#EventDetailLocation#?#QueryString#">#theEvents.eventTitle#</a></h3>

		<div id="Event#theEvents.publicId#" class="EventDescription">
        <cfif structKeyExists(thisEventConfig.eventConfig, "description") and len(trim(thisEventConfig.eventConfig.description.xmlText))>
			<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#application.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.description.xmlText,"text")#" NumChars="300"> <a href="#EventDetailLocation#?#QueryString#" class="moreLink">More &raquo;</a>
		</cfif>
		</div>
		</li>
	</cfoutput>
	</ul>
	<cfoutput>
	<div class="paginationBottom">
		<cfmodule	template="/common/modules/utils/Pagination.cfm"
					StartRow="#StartRow#"
					SearchNum="#SearchNum#"
					RecordCount="#theEvents.RecordCount#"
					formName="calendarForm"
					formAction="#APPLICATION.utilsObj.parseCategoryUrl('event-calendar')#">
	</div>
	</cfoutput>
	
</cfif>
</div></div></article>
