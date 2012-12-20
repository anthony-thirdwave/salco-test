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

<cfif Val(URL.ecdm) IS NOT "0" and Val(URL.ecdy) IS NOT "0" and IsDate("#Val(URL.ecdm)#/1/#Val(URL.ecdy)#")>
	<cfset DateStart=CreateDate(Val(URL.ecdy),Val(URL.ecdm),1)>
	<cfset DateEnd=DateAdd("m",1,DateStart)>
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


<cfoutput>
	<cfif ATTRIBUTES.DisplayMode IS "ByMonth">
		<h2>Events for #DateFormat(DateStart,"mmmm, yyyy")#</h2>
	<cfelseif ATTRIBUTES.DisplayMode IS "ByTopic">
		<cfquery name="GetTopicName" dbtype="query">
			select TopicName from allTopics where TopicID=#Tid#
		</cfquery>
		<h2>#GetTopicName.TopicName#</h2>
	<cfelse>
		<h2>Upcoming Programs and Events</h2>
	</cfif>
</cfoutput>

<p>Type of Event</p>
<form action="">
<select type="Select" onChange="this.form.submit()" name="tid">
<option value="All" <cfif Val(tid) is "0">selected</cfif>>All</option>
<cfoutput query="allTopics">
	<option value="#TopicID#" <cfif tid IS TopicID>selected</cfif>>#TopicName#</option>
</cfoutput>
</select>
</form>
<hr>
<cfif theEvents.RecordCount IS "0">
	<p>There are no events scheduled at this time. Please check back again soon.</p>
<cfelse>
	<ul class="eventsList">

	<cfoutput query="theEvents" group="dateStartYearMonth">
		<li><h3>#MonthAsString(ListLast(dateStartYearMonth,"/"))#, #Left(dateStartYearMonth,4)#</h3></li>
		<dl>
		<cfoutput group="eventID">
			<cfset thisEventConfig=xmlParse(theEvents.eventConfig) />
			<cfset thisEventDateConfig=xmlParse(theEvents.eventDateConfig) />
			<cf_AddToQueryString querystring="#EventDetailQueryString#" name="eid" value="#theEvents.PublicId#">
			<dt>#dateFormat(theEvents.dateStart, "mmmm dd, yyyy")#
			<cfif isDate(theEvents.dateEnd) and dateFormat(theEvents.dateStart, "mmddyyyy") neq dateFormat(theEvents.dateEnd, "mmddyyyy")>
			- #dateFormat(theEvents.dateEnd, "mmmm dd, yyyy")#
			</cfif>
	
		    <!--- display time block --->
			<cfif toString(timeFormat(theEvents.dateStart, "HH:mm:ss")) neq "00:00:00">
				&middot; #timeFormat(theEvents.dateStart, "h:mm tt")#
				<cfif len(trim(theEvents.dateEnd)) and toString(timeFormat(theEvents.dateEnd, "HH:mm:ss")) neq "00:00:00">
				&mdash; #timeFormat(theEvents.dateEnd, "h:mm tt")#
				</cfif>
			</cfif>
			</dt>
			<dd><a name="Event#theEvents.publicId#" href="#EventDetailLocation#?#QueryString#">#theEvents.eventTitle# #theEvents.dateStartYearMonth#</a></dd>
		</cfoutput>
		</dl>
	</cfoutput>
	</ul>
	
</cfif>
</div></div></article>
