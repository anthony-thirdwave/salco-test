<cfparam name="ATTRIBUTES.EventPublicID" default="-1">

<cfif IsDefined("URL.eid")>
	<cfset ATTRIBUTES.EventPublicID=URL.eid>
</cfif>

<cfinvoke method="getEventIdByPublicId" component="#APPLICATION.eventHandlerObj#" returnvariable="eventId">
	<cfinvokeargument name="publicId" value="#trim(ATTRIBUTES.EventPublicID)#">
</cfinvoke>

<!--- get the event and "event" type eventDate in query form --->
<cfinvoke method="getEvents" component="#APPLICATION.eventHandlerObj#" returnvariable="theEvent">
	<cfinvokeargument name="eventId" value="#val(eventId)#">
	<cfinvokeargument name="getDisabledDates" value="false">
</cfinvoke>
<article class='news'><div class='inArt'><div class='artContent'>
<article class="event-detail">
	<cfif theEvent.RecordCount IS "0">
		<p>There are no events scheduled at this time. Please check back again soon.</p>
	<cfelse>
		<cfoutput query="theEvent">
			<cfset thisEventConfig = xmlParse(theEvent.eventConfig) />
			<cfset thisEventDateConfig = xmlParse(theEvent.eventDateConfig) />
			<h2>#APPLICATION.factoryUtilsObj.xmlUnformat(theEvent.eventTitle)#</h2>
			<h3>#dateFormat(theEvent.dateStart, "dddd, mmmm dd, yyyy")#
			<cfif isDate(theEvent.dateEnd) and dateFormat(theEvent.dateStart, "mmddyyyy") neq dateFormat(theEvent.dateEnd, "mmddyyyy")>
			- #dateFormat(theEvent.dateEnd, "dddd, mmmm dd, yyyy")#
			</cfif>
	
			<!--- display time block --->
			<cfif toString(timeFormat(theEvent.dateStart, "HH:mm:ss")) neq "00:00:00">
				&middot; #timeFormat(theEvent.dateStart, "h:mm tt")#
				<cfif len(trim(theEvent.dateEnd)) and toString(timeFormat(theEvent.dateEnd, "HH:mm:ss")) neq "00:00:00">
				&mdash; #timeFormat(theEvent.dateEnd, "h:mm tt")#
				</cfif>
			</cfif>
			</h3>
	
			<!--- event location --->
			<cfif	(isDefined("thisEventConfig.eventConfig.locationName")
					and len(trim(thisEventConfig.eventConfig.locationName.xmlText)))
					or
					len(trim(theEvent.address1))
					or
					len(trim(theEvent.city))
					or
					len(trim(theEvent.stateProvinceId))
					or
					(len(trim(theEvent.countryId)) and trim(theEvent.countryId) neq "US")>
				<h3>
				<!--- location name --->
				<cfif isDefined("thisEventConfig.eventConfig.locationName")
							and len(trim(thisEventConfig.eventConfig.locationName.xmlText))>
				#APPLICATION.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.locationName.xmlText)#<br />
				</cfif>
	
				<!--- location address --->
				<cfif len(trim(theEvent.address1))>
					#APPLICATION.factoryUtilsObj.xmlUnformat(theEvent.address1)#
				</cfif>
				<cfif len(trim(theEvent.city))>
					#APPLICATION.factoryUtilsObj.xmlUnformat(theEvent.city)#,
				</cfif>
				<cfif len(trim(theEvent.stateProvinceId))>
					#theEvent.stateProvinceId#
				</cfif>
	
				<!--- display country if not US --->
				<cfif len(trim(theEvent.countryId)) and trim(theEvent.countryId) neq "US">
	
					<cfquery name="getThisCountry" datasource="#APPLICATION.DSN#">
						SELECT	countryName
						FROM	t_Country
						WHERE	countryCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(theEvent.countryId)#">
					</cfquery>
	
					<cfif getThisCountry.recordcount eq 1>
						#getThisCountry.countryName#
					</cfif>
				</cfif>
				</h3>
			</cfif>
	
			<div id="Event#theEvent.publicId#" class="EventDescription">
			<cfif structKeyExists(thisEventConfig.eventConfig, "description") and len(trim(thisEventConfig.eventConfig.description.xmlText))>
				<p>#APPLICATION.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.description.xmlText,"text")#</p>
			</cfif>
	
			<!--- event contact --->
			<cfif	(structKeyExists(thisEventConfig.eventConfig, "contactName")
					and len(trim(thisEventConfig.eventConfig.contactName.xmlText)))
					or
					(structKeyExists(thisEventConfig.eventConfig, "contactEmail")
					and len(trim(thisEventConfig.eventConfig.contactEmail.xmlText)))
					or
					(structKeyExists(thisEventConfig.eventConfig, "contactPhone")
					and len(trim(thisEventConfig.eventConfig.contactPhone.xmlText)))
					or
					(structKeyExists(thisEventConfig.eventConfig, "contactExtraInfo")
					and len(trim(thisEventConfig.eventConfig.contactExtraInfo.xmlText)))>
				<div class="eventContact">
				<h3>For more information, contact:</h3>
				<!--- contact name --->
				<p>
				<cfif structKeyExists(thisEventConfig.eventConfig, "contactName") and len(trim(thisEventConfig.eventConfig.contactName.xmlText))>
					#APPLICATION.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.contactName.xmlText)#<br />
				</cfif>
				<cfif structKeyExists(thisEventConfig.eventConfig, "contactExtraInfo") and len(trim(thisEventConfig.eventConfig.contactExtraInfo.xmlText))>
					#APPLICATION.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.contactExtraInfo.xmlText)#
				</cfif>
				<cfif structKeyExists(thisEventConfig.eventConfig, "contactPhone") and len(trim(thisEventConfig.eventConfig.contactPhone.xmlText))>
					#APPLICATION.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.contactPhone.xmlText)#<br />
				</cfif>
				<cfif structKeyExists(thisEventConfig.eventConfig, "contactEmail") and len(trim(thisEventConfig.eventConfig.contactEmail.xmlText))>
					<a href="mailto:#thisEventConfig.eventConfig.contactEmail.xmlText#">#APPLICATION.factoryUtilsObj.xmlUnformat(thisEventConfig.eventConfig.contactEmail.xmlText)#</a>
				</cfif>
				</p>
				</div>
			</cfif>
			</div>
			</li>
		</cfoutput>
	</cfif>
</article>
</div></div></article>