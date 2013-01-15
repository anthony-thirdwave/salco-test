<cfparam name="PageAction" default="List">
<cfparam name="eventPublicId" default="">
<cfparam name="formSubmitted" default="">
<cfparam name="pageRedraw" default="false">
<cfparam name="topics" default="">

<cfajaximport tags="cfform">


<!--- comes from the cfgrid on the user manager page --->
<cfif isDefined("cfgridkey")>
	<cfset eventPublicId = cfgridkey />
</cfif>

<!--- get the event  --->
<cfinvoke method="getEvent" component="#APPLICATION.eventHandlerObj#" returnvariable="thisEvent">
	<cfinvokeargument name="publicId" value="#eventPublicId#">
	<cfinvokeargument name="getDisabledDates" value="true">
</cfinvoke>

<!--- create a struct for eventDate error handling --->
<cfset eventDateErrors = structNew() />

<!--- if the form hasn't been submitted --->
<cfif not len(trim(formSubmitted))>

	<!--- clear the eventDateStruct --->
	<cfset structDelete(session, "eventDateStruct")>

	<!--- convert the event object to a struct --->
	<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="form.event">
		<cfinvokeargument name="factoryObject" value="#thisEvent.eventObj#">
	</cfinvoke>

	<!--- convert the address object to a struct --->
	<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="form.address">
		<cfinvokeargument name="factoryObject" value="#thisEvent.addressObj#">
	</cfinvoke>

	<!--- loop through existing eventDates --->
	<cfloop query="thisEvent.dates">

		<!--- get this eventDate --->
		<cfinvoke method="getEventDate" component="#APPLICATION.eventHandlerObj#" returnvariable="thisEventDate">
			<cfinvokeargument name="eventDateId" value="#thisEvent.dates.eventDateId#">
		</cfinvoke>

		<!--- convert each event date object to a struct --->
		<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="form.eventDate.#thisEvent.dates.publicId#">
			<cfinvokeargument name="factoryObject" value="#thisEventDate#">
		</cfinvoke>
	</cfloop>

	<!--- this is a new eventDate --->
	<cfif not thisEvent.dates.recordCount or pageAction eq "addDate">

		<!--- get a blank eventDate --->
		<cfinvoke method="getEventDate" component="#APPLICATION.eventHandlerObj#" returnvariable="thisEventDate">
			<cfinvokeargument name="publicId" value="">
		</cfinvoke>

		<!--- convert the default event date object to a struct --->
		<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="form.eventDate.newEvent">
			<cfinvokeargument name="factoryObject" value="#thisEventDate#">
		</cfinvoke>
	</cfif>

	<!--- set the selected topics to the saved topics --->
	<cfset topics = valueList(thisEvent.topics.TopicID) />

	<cfswitch expression="#PageAction#">
		<cfcase value="list">
			<cflocation url="/common/admin/eventManager/index.cfm">
		</cfcase>
		<cfcase value="edit,add,addDate">
			<cfinclude template="/common/admin/EventManager/form.cfm">
		</cfcase>
		<cfcase value="Delete">
			<!--- toggle disabled status --->
			<cfif isDate(thisEvent.eventObj.getProperty("dateDisabled"))>
				<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
					UPDATE		t_Event
					SET			dateDisabled = NULL
					WHERE		publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eventPublicId#">
				</cfquery>
				<cfset thisEvent.eventObj.setProperty("dateDisabled", "NULL")>
			<cfelse>
				<!--- disable the student --->
				<cfinvoke method="disableEvent" component="#APPLICATION.eventHandlerObj#">
					<cfinvokeargument name="publicId" value="#eventPublicId#">
				</cfinvoke>
				<cfset thisEvent.eventObj.setProperty("dateDisabled", now())>
			</cfif>
			
			<!--- track the deletion --->
			<!--- <cfinvoke method="track" component="com.utils.tracking" returnvariable="deleteEvent">
				<cfinvokeargument name="userId" value="#session.adminUserID#">
				<cfinvokeargument name="entity" value="Event">
				<cfinvokeargument name="keyId" value="#thisEvent.eventObj.getProperty('EventId')#">
				<cfinvokeargument name="operation" value="delete">
				<cfinvokeargument name="entityName" value="#thisEvent.eventObj.getProperty('EventTitle')#">
			</cfinvoke> --->

<!---
			<!--- delete the event and relationships --->
			<cfquery name="deleteEventCategory" datasource="#APPLICATION.DSN#">
				DELETE
				FROM	t_CategoryEventRelationship
				WHERE	EventID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EditEventID#" />
			</cfquery>
			<cfquery name="deleteEvent" datasource="#APPLICATION.DSN#">
				DELETE
				FROM	t_Event
				WHERE	EventID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EditEventID#" />
			</cfquery>

			<!--- if this is staging, delete from the live site as well --->
			<cfif APPLICATION.staging>
				<cfinvoke component="com.ContentManager.CategoryHandler"
					method="GetProductionSiteInformation"
					returnvariable="sProductionSiteInformation"
					CategoryID="1">

				<cfquery name="deleteEventCategory" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					DELETE
					FROM	t_CategoryEventRelationship
					WHERE	eventID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EditEventID#" />
				</cfquery>
				<cfquery name="deleteEvent" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					DELETE
					FROM	t_Event
					WHERE	eventId = <cfqueryparam cfsqltype="cf_sql_integer" value="#EditEventID#" />
				</cfquery>
			</cfif>
 --->
			<cflocation url="/common/admin/eventManager/index.cfm">
		</cfcase>
	</cfswitch>
<cfelse>

	<!--- convert any form variables with dot notation into a struct for the event object --->
	<cfset form = APPLICATION.UtilsObj.formDotNotationToStruct(form) />

	<cfif structKeyExists(form.event, "disable")>
		<!--- disable the event --->
		<cfinvoke method="disableEvent" component="#APPLICATION.eventHandlerObj#">
			<cfinvokeargument name="publicId" value="#eventPublicId#">
		</cfinvoke>
		<cfset thisEvent.eventObj.setProperty("dateDisabled", now())>
	<cfelse>
		<!--- enable the event --->
		<cfinvoke method="enableEvent" component="#APPLICATION.eventHandlerObj#">
			<cfinvokeargument name="publicId" value="#eventPublicId#">
		</cfinvoke>
		<cfset thisEvent.eventObj.setProperty("dateDisabled", "")>
	</cfif>

	<!--- loop through the properties of the event --->
	<cfloop array="#thisEvent.eventObj.propArray#" index="thisProp">

		<!--- if the property is defined in the form --->
		<cfif structKeyExists(form.event, thisProp.variableName.xmlText)>

			<!--- if this property type is "file", then pass the variable name intead of the value --->
			<cfif isDefined("thisProp.restrictions.file")>
				<cfset thisEvent.eventObj.setProperty(thisProp.variableName.xmlText, "form.event.#thisProp.variableName.xmlText#")>
			<cfelse>
				<cfset thisEvent.eventObj.setProperty(thisProp.variableName.xmlText, form.event[thisProp.variableName.xmlText])>
			</cfif>
		</cfif>
	</cfloop>


	<!--- will hold eventDates in memory for validation --->
	<cfset eventDateArray = arrayNew(1)>

	<!--- create a factory object --->
	<cfset thisEventDate = createObject("component", "com.factory.thirdwave.FactoryObject")>

	<!--- init the factory object as type eventDate --->
	<cfset thisEventDate.init("EventDate")>

	<!--- loop through the eventDates in the form --->
	<cfloop collection="#form.eventDate#" item="itr">

		<!--- get the eventDate by publicId --->
		<cfinvoke method="getEventDateIdByPublicId" component="#APPLICATION.eventHandlerObj#" returnvariable="thisEventDateId">
			<cfinvokeargument name="publicId" value="#trim(itr)#">
		</cfinvoke>

		<!--- if this is a valid id, then get the corresponding eventDate, otherwise get new eventDate --->
		<cfset thisEventDate.constructor(val(thisEventDateId))>

		<!--- loop through the eventDate properties --->
		<cfloop array="#thisEventDate.propArray#" index="dateProp">

			<!--- if this property is defined in the struct --->
			<cfif structKeyExists(form.eventDate[itr], dateProp.variableName.xmlText)>

				<!--- get the property from the struct --->
				<cfset propFromStruct = form.eventDate[itr][dateProp.variableName.xmlText]>

				<!--- set the value --->
				<cfset thisEventDate.setProperty(dateProp.variableName.xmlText, propFromStruct)>
			</cfif>
		</cfloop>

		<!--- check for a deletion --->
		<cfif structKeyExists(form.eventDate[itr], "disable")>
			<!--- disable the eventDate --->
			<cfinvoke method="disableEventDate" component="#APPLICATION.eventHandlerObj#">
				<cfinvokeargument name="publicId" value="#trim(itr)#">
			</cfinvoke>
			<cfset thisEventDate.setProperty("dateDisabled", now())>
		<cfelse>
			<!--- enable the eventDate --->
			<cfinvoke method="enableEventDate" component="#APPLICATION.eventHandlerObj#">
				<cfinvokeargument name="publicId" value="#trim(itr)#">
			</cfinvoke>
			<cfset thisEventDate.setProperty("dateDisabled", "")>
		</cfif>

		<!--- add to the returnArray - this needs to be a duplicate --->
		<cfset arrayAppend(eventDateArray, duplicate(thisEventDate))>
	</cfloop>


	<!--- will hold changed cloned event dates --->
	<cfset cloneArray = arrayNew(1)>

	<!--- loop through the event dates, checking for validity --->
	<cfloop array="#eventDateArray#" index="itr">

		<!--- set the eventId to this eventId, even if it's zero --->
		<cfset itr.setProperty("eventId", val(thisEvent.eventObj.getProperty("eventId")))>

		<!--- if no standard errors, then check for specifics --->
		<cfif itr.isCorrect()>

			<!--- make sure end dates come after matching start dates --->
			<cfif isDate(itr.getProperty("dateStart")) and isDate(itr.getProperty("dateEnd"))
					and dateCompare(itr.getProperty("dateEnd"), itr.getProperty("dateStart")) eq -1>
				<cfset itr.addError("dateEnd", itr.getProperty("dateEnd"), "The end date must occur after the start date")>
			</cfif>
			<cfif isDate(itr.getProperty("recurrenceStart")) and isDate(itr.getProperty("recurrenceEnd"))
					and dateCompare(itr.getProperty("recurrenceEnd"), itr.getProperty("recurrenceStart")) eq -1>
				<cfset itr.addError("recurrenceEnd", itr.getProperty("recurrenceEnd"), "The end date must occur after the start date")>
			</cfif>
			<cfif isDate(itr.getProperty("dateActivated")) and isDate(itr.getProperty("dateDeactivated"))
					and dateCompare(itr.getProperty("dateDeactivated"), itr.getProperty("dateActivated")) eq -1>
				<cfset itr.addError("dateDeactivated", itr.getProperty("dateDeactivated"), "The end date must occur after the start date")>
			</cfif>

			<!--- get the eventDateConfig --->
			<cfset newConfigDoc = xmlParse(itr.getProperty("eventDateConfig"))>

			<!---if registration is being used, require notification email --->
			<cfif isDefined("newConfigDoc.eventDateConfig.registration.useRegistration")
					and newConfigDoc.eventDateConfig.registration.useRegistration.xmlText
					and not (isDefined("newConfigDoc.eventDateConfig.registration.notificationEmail")
						and len(trim(newConfigDoc.eventDateConfig.registration.notificationEmail.xmlText)))>
				<cfset itr.addError("eventDateConfig", "", "If registration is used for an event date, the Notification Email field must contain an email address.")>
				<cfset itr.error.errorStruct.eventDateConfig.registration.notificationEmail = structNew()>
			</cfif>
		</cfif>


		<!--- if this event date isn't correct --->
		<cfif not itr.isCorrect()>

			<!--- if this has been saved, but is now in error, it's referenced by publicId, otherwise, by "newEvent" --->
			<cfif itr.getProperty("publicId") eq "">
				<cfset eventDateErrors.newEvent = itr />
			<cfelse>
				<cfset eventDateErrors[itr.getProperty("publicId")] = itr />
			</cfif>
		<!--- if this has cloned dates and has been modified, then update the cloned dates --->
		<cfelseif len(trim(itr.getProperty("publicId"))) and not len(trim(itr.getProperty("cloneOfPublicId")))>

			<cfinvoke method="getEventDateQuery" component="#APPLICATION.eventHandlerObj#" returnvariable="savedDate">
				<cfinvokeargument name="publicId" value="#itr.getProperty('publicId')#">
			</cfinvoke>

			<!--- use these dates --->
			<cfset savedDateStart = savedDate.dateStart>
			<cfset newDateStart = itr.getProperty("dateStart")>
			<cfset savedDateEnd = savedDate.dateEnd>
			<cfset newDateEnd = itr.getProperty("dateEnd")>
			<cfset savedConfigDoc = xmlParse(savedDate.eventDateConfig)>
			<cfset savedConfig = toString(savedConfigDoc)>
			<cfset newConfig = toString(newConfigDoc)>

			<!--- update clone function --->
			<cfif savedDateStart neq newDateStart or savedDateEnd neq newDateEnd or savedConfig neq newConfig>

				<!--- get the change in start dates ---->
				<cfset dateStartSpan = dateDiff("n", savedDateStart, newDateStart)>

				<!--- get the change between start and end dates --->
				<cfif isDate(newDateEnd)>
					<cfset dateStartToDateEndSpan = dateDiff("n", newDateStart, newDateEnd)>
				<cfelse>
					<cfset dateStartToDateEndSpan = 0>
				</cfif>

				<!--- get the clones that occur after today, since we don't want to change past events --->
				<cfinvoke method="getEventDateClonesQuery" component="#APPLICATION.eventHandlerObj#" returnvariable="savedDateClones">
					<cfinvokeargument name="cloneOfPublicId" value="#itr.getProperty('publicId')#">
					<cfinvokeargument name="dateStart" value="#now()#">
				</cfinvoke>

				<!--- loop through the clones, create as objects, then set the dates --->
				<cfloop query="savedDateClones">
					<!--- create a factory object --->
					<cfset clonedEventDate = createObject("component", "com.factory.thirdwave.FactoryObject") />

					<!--- init the factory object as type event --->
					<cfset clonedEventDate.init("EventDate") />
					<cfset clonedEventDate.constructor(val(savedDateClones.eventDateId)) />

 					<!--- set the adjusted dateStart --->
					<cfset clonedEventDate.setProperty("dateStart", dateAdd("n", dateStartSpan, savedDateClones.dateStart))>

 					<!--- set the end date relative to the new start date --->
 					<cfif not isDate(newDateEnd)>
 						<cfset clonedEventDate.setProperty("dateEnd", "")>
 					<cfelse>
						<cfset clonedEventDate.setProperty("dateEnd", dateAdd("n", dateStartToDateEndSpan, clonedEventDate.getProperty("dateStart")))>
 					</cfif>

					<!--- remove the encoding and replace the dateType in the updated eventDateConfig for the clone --->
					<cfset newConfig = replaceNoCase(newConfig, "<?xml version=""1.0"" encoding=""utf-8""?>", "")>
					<cfset newConfig = replaceNoCase(newConfig, "<dateType>event</dateType>", "<dateType>instance</dateType>")>

					<!--- update the eventDateConfig --->
					<cfset clonedEventDate.setProperty("eventDateConfig", newConfig)>

					<!--- append the changed clone to the cloneArray --->
					<cfset arrayAppend(cloneArray, clonedEventDate)>
				</cfloop>
			</cfif>
		</cfif>

		<!--- if the eventDate isCorrect, create the struct version, otherwise, the form values will be used --->
		<cfif itr.isCorrect() or not len(trim(itr.getProperty("publicId")))>
			<cfif not len(trim(itr.getProperty("publicId")))>
				<!--- convert each event date object to a struct --->
				<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="form.eventDate.newEvent">
					<cfinvokeargument name="factoryObject" value="#itr#">
				</cfinvoke>
			<cfelse>
				<!--- convert each event date object to a struct --->
				<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="form.eventDate.#itr.getProperty('publicId')#">
					<cfinvokeargument name="factoryObject" value="#itr#">
				</cfinvoke>
			</cfif>
		</cfif>
	</cfloop>

	<!--- if this isn't a page redraw, attempt to save, otherwise, redraw the page --->
	<cfif not pageRedraw>

		<!--- if the event object is properly formatted, save  --->
		<cfif thisEvent.eventObj.isCorrect() and thisEvent.addressObj.isCorrect() and structIsEmpty(eventDateErrors)>

			<!--- save the address object --->
			<cfset thisEvent.addressObj.save()>

			<!--- set the eventAddressId --->
			<cfset thisEvent.eventObj.setProperty("eventAddressId", thisEvent.addressObj.getProperty("addressId")) />

			<!--- save the event object --->
			<cfset thisEvent.eventObj.save()>

			<!--- set the eventPublicId --->
			<cfset eventPublicId = thisEvent.eventObj.getProperty("publicId") />

			<!--- use this variable to determine if there's an error in an event date --->
			<cfset eventDateError = false />

			<!--- loop through the eventDate objects and check if each is valid --->
			<cfloop array="#eventDateArray#" index="itr">

				<!--- if this eventDate is properly formatted, save --->
				<cfif itr.isCorrect()>

					<!--- set the eventId --->
					<cfset itr.setProperty("eventId", thisEvent.eventObj.getProperty("eventId"))>
					<cfset itr.save() />
				<cfelse>

					<!--- if we can't save an eventDate --->
					<cfset eventDateError = true />

					<!--- if this has been saved, but is now in error, it's referenced by publicId, otherwise, by "newEvent" --->
					<cfif itr.getProperty("publicId") eq "">
						<cfset eventDateErrors.newEvent = itr />
					<cfelse>
						<cfset eventDateErrors[itr.getProperty("publicId")] = itr />
					</cfif>
				</cfif>
			</cfloop>

			<!--- only if all the event dates pan out --->
			<cfif structIsEmpty(eventDateErrors)>
				<!--- loop through the cloned eventDate objects, check if each is valid and save --->
				<cfloop array="#cloneArray#" index="inr">

					<!--- if this cloned eventDate is properly formatted, save --->
					<cfif inr.isCorrect()>
						<cfset inr.save() />
					</cfif>
				</cfloop>
			</cfif>

			<!--- update the t_topicEntity table for this event --->
			<cfinvoke component="com.Taxonomy.TopicHandler" method="InsertRelatedTopics">
				<cfinvokeargument name="entityId" value="#val(thisEvent.eventObj.getProperty("eventId"))#" />
				<cfinvokeargument name="entityName" value="t_Event" />
				<cfinvokeargument name="lTopicID" value="#topics#" />
			</cfinvoke>

	<!---

			<!--- determine tracking --->
			<cfswitch expression="#PageAction#">

				<!--- edit --->
				<cfcase value="edit">
					<!--- track the edit --->
					<cfinvoke method="track" component="com.utils.tracking" returnvariable="success">
						<cfinvokeargument name="userId" value="#session.adminUserID#">
						<cfinvokeargument name="entity" value="Event">
						<cfinvokeargument name="keyId" value="#thisEvent.eventObj.getProperty('EventId')#">
						<cfinvokeargument name="operation" value="modify">
						<cfinvokeargument name="entityName" value="#thisEvent.eventObj.getProperty('EventTitle')#">
					</cfinvoke>
				</cfcase>

				<!--- add --->
				<cfcase value="add">

					<!--- track the creation --->
					<cfinvoke method="track" component="com.utils.tracking" returnvariable="success">
						<cfinvokeargument name="userId" value="#session.adminUserID#">
						<cfinvokeargument name="entity" value="Event">
						<cfinvokeargument name="keyId" value="#thisEvent.eventObj.getProperty('EventId')#">
						<cfinvokeargument name="operation" value="create">
						<cfinvokeargument name="entityName" value="#thisEvent.eventObj.getProperty('EventTitle')#">
					</cfinvoke>
				</cfcase>
			</cfswitch>

			<cflocation url="/common/admin/eventManager/index.cfm?message=#PageAction#">--->

			<!--- if there were no errors in the eventDates, return to the index page --->
			<cfif not eventDateError>
				<cflocation url="/common/admin/eventManager/index.cfm?message=#PageAction#">
			<!--- else, return to the form to display errors --->
			<cfelse>
				<cfinclude template="/common/admin/EventManager/form.cfm">
			</cfif>
		<!--- otherwise display the errors --->
		<cfelse>
			<cfinclude template="/common/admin/EventManager/form.cfm">
		</cfif>
	<cfelse>
		<cfset formSubmitted = "">
		<cfinclude template="/common/admin/EventManager/form.cfm">
	</cfif>
</cfif>

<!--- clear the variables scope to slow coldfusion memory leak --->
<cfset structClear(variables)>