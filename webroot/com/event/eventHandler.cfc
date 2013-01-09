<cfcomponent hint="Handles event management.">

	<cffunction name="init" returntype="EventHandler">
		<cfreturn this>
	</cffunction>
	
		<!--- get an event   --->
	<cffunction name="getEvent" output="false" returntype="struct">
		<cfargument name="eventId" default="">
		<cfargument name="publicId" default="">
		<cfargument name="getDisabledDates" default="false">
		<cfargument name="getDisabledChildren" default="false">
		<cfargument name="getDisabledAddresses" default="false">
		<cfargument name="getRecurringDates" default="false">
		<cfargument name="eventObjName" default="Event">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- init the return struct --->
		<cfset local.returnStruct=structNew()>

		<!--- get an addressHandler --->
		<cfinvoke method="init" component="com.address.AddressHandler" returnvariable="local.addressHandler">

		<!--- if a publicId is passed, set arguments.eventId--->
		<cfif trim(arguments.publicId) neq "">
			<cfinvoke method="getEventIdByPublicId" returnvariable="arguments.eventId">
				<cfinvokeargument name="publicId" value="#trim(arguments.publicId)#">
			</cfinvoke>
		</cfif>

		<!--- create a factory object --->
		<cfset local.returnStruct.eventObj=createObject("component", "com.factory.thirdwave.FactoryObject")>

		<!--- init the factory object as type event --->
		<cfset local.returnStruct.eventObj.init(arguments.eventObjName)>

		<!--- if this is a valid id, then get the corresponding event object --->
		<cfset local.returnStruct.eventObj.constructor(val(arguments.eventId))>

		<!--- get the event and "event" type eventDate in query form --->
		<cfinvoke method="getEvents" returnvariable="local.returnStruct.eventQry">
			<cfinvokeargument name="eventId" value="#val(arguments.eventId)#">
			<cfinvokeargument name="getDisabledDates" value="#arguments.getDisabledDates#">
		</cfinvoke>

		<!--- get the dates for this event --->
		<cfinvoke method="getEventDates" returnvariable="local.returnStruct.dates">
			<cfinvokeargument name="eventId" value="#val(arguments.eventId)#">
			<cfinvokeargument name="getDisabled" value="#arguments.getDisabledDates#">
			<cfinvokeargument name="getRecurringDates" value="#arguments.getRecurringDates#">
		</cfinvoke>

		<!--- get children events --->
		<cfinvoke method="getChildrenEvents" returnvariable="local.returnStruct.children">
			<cfinvokeargument name="eventId" value="#val(arguments.eventId)#">
			<cfinvokeargument name="getDisabled" value="#arguments.getDisabledChildren#">
		</cfinvoke>

		<!--- get the addressId from t_eventAddress if one exists --->
		<cfinvoke method="getEventAddressId" returnvariable="local.addressId">
			<cfinvokeargument name="eventId" value="#val(arguments.eventId)#">
		</cfinvoke>

		<!--- get the address object if one exists for this event --->
		<cfinvoke method="getAddress" component="#local.addressHandler#" returnvariable="local.returnStruct.addressObj">
			<cfinvokeargument name="addressId" value="#local.addressId#">
		</cfinvoke>

		<!--- get the topics for this event --->
		<cfinvoke component="com.Taxonomy.TopicHandler" method="GetRelatedTopics" returnvariable="local.returnStruct.topics">
			<cfinvokeargument name="entityId" value="#val(arguments.eventId)#" />
			<cfinvokeargument name="entityName" value="t_Event" />
		</cfinvoke>

		<!--- return the results --->
		<cfreturn local.returnStruct>
	</cffunction>






	<!--- get an eventDate   --->
	<cffunction name="getEventDate" output="false">
		<cfargument name="eventDateId" default="">
		<cfargument name="publicId" default="">
		<cfargument name="eventDateObjName" default="EventDate">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- if a publicId is passed, set arguments.eventId--->
		<cfif len(trim(arguments.publicId))>
			<cfinvoke method="getEventDateIdByPublicId" returnvariable="arguments.eventDateId">
				<cfinvokeargument name="publicId" value="#trim(arguments.publicId)#">
			</cfinvoke>
		</cfif>

		<!--- create a factory object --->
		<cfset local.eventDate=createObject("component", "com.factory.thirdwave.FactoryObject")>

		<!--- init the factory object as type event --->
		<cfset local.eventDate.init(arguments.eventDateObjName)>

		<!--- if this is a valid id, then get the corresponding event --->
		<cfset local.eventDate.constructor(val(arguments.eventDateId))>

		<!--- return the results --->
		<cfreturn local.eventDate>
	</cffunction>


	<!--- get an eventDate in a query form   --->
	<cffunction name="getEventDateQuery" output="false">
		<cfargument name="eventDateId" default="">
		<cfargument name="publicId" default="">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	eventDateId, eventId, cloneOfPublicId, eventDateConfig, dateStart, dateEnd, recurrenceStart, recurrenceEnd,
					dateActivated, dateDeactivated, publicId as eventDatePublicId, dateAdded, dateModified, dateDisabled
			FROM	t_EventDate
			WHERE
					<cfif val(arguments.eventDateId)>
						eventDateId=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.eventDateId)#">
					<cfelseif len(trim(arguments.publicId))>
						publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.publicId)#">
					<cfelse>
						1=0
					</cfif>
		</cfquery>

		<!--- return the results --->
		<cfreturn local.getResults>
	</cffunction>

	<!--- get an eventDateClones in a query   --->
	<cffunction name="getEventDateClonesQuery" output="false">
		<cfargument name="cloneOfPublicId" default="">
		<cfargument name="dateStart" default="">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	eventDateId, eventId, cloneOfPublicId, eventDateConfig, dateStart, dateEnd, recurrenceStart, recurrenceEnd,
					dateActivated, dateDeactivated, publicId as eventDatePublicId, dateAdded, dateModified, dateDisabled
			FROM	t_EventDate
			WHERE	cloneOfPublicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.cloneOfPublicId)#">
			<cfif isDate(arguments.dateStart)>
				AND	CONVERT(VARCHAR(10), dateStart, 101) >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
			</cfif>
		</cfquery>

		<!--- return the results --->
		<cfreturn local.getResults>
	</cffunction>



	<!--- get an instance of a date --->
	<cffunction name="getEventDateInstance" output="false">
		<cfargument name="publicId" type="string" required="true">
		<cfargument name="cloneOfPublicId" type="string" default="">
		<cfargument name="dateStart" type="string" default="">
		<cfargument name="addIfMissing" type="boolean" default="false">
		<cfargument name="eventDateObjName" type="string" default="EventDate">

		<cfset var local=structNew()>
		<cfset local.returnStruct=structNew()>

		<!--- check if this eventDate exists in the t_eventDate table --->
		<cfinvoke method="getEventDateQuery" returnvariable="local.thisEventDate">
			<cfinvokeargument name="publicId" value="#trim(arguments.publicId)#">
		</cfinvoke>

		<!--- if addIfMissing is true, we'll attempt add the missing recurrence --->
		<cfif not local.thisEventDate.recordcount and len(trim(arguments.cloneOfPublicId))
				and arguments.addIfMissing and isDate(arguments.dateStart)>

			<!--- get the eventDate being cloned --->
			<cfinvoke method="getEventDateQuery" returnvariable="local.parentEventDate">
				<cfinvokeargument name="publicId" value="#trim(arguments.cloneOfPublicId)#">
			</cfinvoke>

			<!--- this will return the specs for the instance --->
			<cfinvoke method="addRecurringDates" returnvariable="local.eventDateInstance">
				<cfinvokeargument name="eventDateQuery" value="#local.parentEventDate#">
				<cfinvokeargument name="dateStart" value="#arguments.dateStart#">
				<cfinvokeargument name="dateStartOnly" value="true">
				<!--- set this to date start - we just want a matching instance for today --->
				<cfinvokeargument name="dateEnd" value="#local.parentEventDate.dateStart#">
			</cfinvoke>

			<!--- if a matching eventDateInstance is returned --->
			<cfif local.eventDateInstance.recordcount>

				<!--- create a factory object --->
				<cfset local.eventDateObj=createObject("component", "com.factory.thirdwave.FactoryObject")>

				<!--- init the factory object as type event --->
				<cfset local.eventDateObj.init(arguments.eventDateObjName)>

				<!--- default constructor --->
				<cfset local.eventDateObj.constructor()>

				<!--- loop through and set the properties in the object --->
				<cfloop list="#local.eventDateInstance.columnList#" index="local.itr">
					<!--- skip some properties that will be set upon save --->
					<cfif not listFindNoCase("eventDateId,eventDatePublicId,dateAdded,dateModified,eventDateConfig", local.itr)>
						<cfset local.eventDateObj.setProperty(local.itr, local.eventDateInstance[local.itr])>
					<!--- remove the repeatConfig from the cloned eventDateConfig --->
					<cfelseif local.itr eq "eventDateConfig">
						<cfset local.thisEventDateConfig=local.eventDateInstance[local.itr]>
						<!--- change the type from event to instance --->
						<cfset local.thisEventDateConfig=replaceNoCase(local.thisEventDateConfig, "<dateType>event</dateType>", "<dateType>instance</dateType>")>
						<cfset local.thisEventDateConfig=xmlParse(local.thisEventDateConfig)>
						<cfset local.eventDateObj.setProperty(local.itr, toString(local.thisEventDateConfig))>
					</cfif>
				</cfloop>

				<!--- if this is formatted correctly --->
				<cfif local.eventDateObj.isCorrect()>

					<!--- lock this to prevent simultaneous additions --->
					<cflock name="eventDateInstanceAdd" timeout="10" type="exclusive">
						<!--- make this hasn't been added by another request --->
						<cfquery name="checkInstance" datasource="#APPLICATION.EVENT_DSN#">
							SELECT	eventDateId
							FROM	t_eventDate
							WHERE	cloneOfPublicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.eventDateInstance.cloneOfPublicId#">
							AND		dateStart=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.eventDateInstance.dateStart#">
						</cfquery>

						<!--- if there's no record, save --->
						<cfif not checkInstance.recordcount>
							<cfset local.eventDateObj.save()>
						</cfif>
					</cflock>

					<!--- we can do this outside the lock - get the eventDate if it was added by a different request --->
					<cfif checkInstance.recordcount>
						<cfset local.eventDateObj.constructor(checkInstance.eventDateId)>
					</cfif>
				</cfif>

				<!--- get the newly added eventDate as a query --->
				<cfinvoke method="getEventDateQuery" returnvariable="local.thisEventDate">
					<cfinvokeargument name="eventDateId" value="#local.eventDateObj.getProperty("eventDateId")#">
				</cfinvoke>
			</cfif>
		</cfif>
		<cfreturn local.thisEventDate>
	</cffunction>





	<!--- get an eventId by publicId  --->
	<cffunction name="getEventIdByPublicId" returntype="string" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	eventId
			FROM	t_Event
			WHERE	publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
		</cfquery>

		<!--- return the results --->
		<cfreturn val(local.getResults.eventId)>
	</cffunction>



	<!--- get an eventDateId by publicId  --->
	<cffunction name="getEventDateIdByPublicId" returntype="numeric" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	eventDateId
			FROM	t_EventDate
			WHERE	publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
		</cfquery>

		<!--- return the results --->
		<cfreturn val(local.getResults.eventDateId)>
	</cffunction>



	<!--- disable an event  --->
	<cffunction name="disableEvent" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- disable event dates --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			UPDATE		t_Event
			SET			dateDisabled=CURRENT_TIMESTAMP
			WHERE		(
							publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
						)
			AND			dateDisabled IS NULL
		</cfquery>
	</cffunction>

	<!--- enable an event  --->
	<cffunction name="enableEvent" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- disable event dates --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			UPDATE		t_Event
			SET			dateDisabled=NULL
			WHERE		publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
		</cfquery>
	</cffunction>



	<!--- disable an event date  --->
	<cffunction name="disableEventDate" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- disable event dates --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			UPDATE		t_EventDate
			SET			dateDisabled=CURRENT_TIMESTAMP
			WHERE		(
							publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
							OR	cloneOfPublicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
						)
			AND			dateDisabled IS NULL
		</cfquery>
	</cffunction>

	<!--- enable an event date  --->
	<cffunction name="enableEventDate" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- disable event dates --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			UPDATE		t_EventDate
			SET			dateDisabled=NULL
			WHERE		(
							publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
							OR	cloneOfPublicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
						)
			AND			dateDisabled IS NOT NULL
		</cfquery>
	</cffunction>



	<!--- get an event's dates  --->
	<cffunction name="getEventDates" returntype="query" output="false">
		<cfargument name="eventId" required="true" type="numeric">
		<cfargument name="getDisabled" default="false">
		<cfargument name="getRecurringDates" default="false">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT		eventDateId, eventId, eventDateConfig, dateStart, dateEnd, recurrenceStart, recurrenceEnd,
						dateActivated, dateDeactivated, publicId, dateAdded, dateModified, dateDisabled
			FROM		t_EventDate
			WHERE		eventId=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventId#">

			<!--- getRecurringDates --->
			<cfif not arguments.getRecurringDates>
				AND 	cloneOfPublicId IS NULL
			</cfif>

			<!--- getDisabled --->
			<cfif not arguments.getDisabled>
				AND 	dateDisabled IS NULL
			</cfif>

			ORDER BY	dateStart, dateActivated
		</cfquery>

		<!--- return the results --->
		<cfreturn local.getResults>
	</cffunction>




	<!--- get an event's children events  --->
	<cffunction name="getChildrenEvents" returntype="query" output="false">
		<cfargument name="eventId" required="true" type="numeric">
		<cfargument name="getDisabled" default="false">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT		eventId, eventTitle, eventConfig, publicId, parentId, timezoneId, dateAdded, dateModified, dateDisabled
			FROM		t_Event
			WHERE		parentId=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventId#">

			<!--- if getDisabled --->
			<cfif not arguments.getDisabled>
				AND 	dateDisabled IS NULL
			</cfif>

			ORDER BY	dateAdded
		</cfquery>

		<!--- return the results --->
		<cfreturn local.getResults>
	</cffunction>





	<!--- get an event addressId  --->
	<cffunction name="getEventAddressId" returntype="numeric" output="false">
		<cfargument name="eventId" required="true" type="numeric">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>
		<cfset local.addressId=0>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT		addressId
			FROM		t_EventAddress
			WHERE		eventId=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventId#">
		</cfquery>

		<!--- if there's a record returned for this event --->
		<cfif local.getResults.recordcount eq 1>
			<cfset local.addressId=local.getResults.addressId>
		</cfif>

		<!--- return the results --->
		<cfreturn local.addressId>
	</cffunction>






	<!--- get events --->
	<cffunction name="getEvents" output="false">
		<cfargument name="eventId" default="">
		<cfargument name="eventDatePublicId" default="">
		<cfargument name="eventTitle" type="string" default="">
		<cfargument name="city" type="string" default="">
		<cfargument name="dateStart" type="string" default="#now()#">
		<cfargument name="dateStartOnly" type="boolean" default="false">
		<cfargument name="dateEnd" type="string" default="">
		<cfargument name="dateEndOnly" type="boolean" default="false">
		<cfargument name="parentId" type="string" default="">
		<cfargument name="keywords" type="string" default="">
		<cfargument name="topicIDList" type="string" default="">
		<cfargument name="xmlFields" type="struct" default="#structNew()#">
		<cfargument name="getDisabledEvents" type="boolean" default="false">
		<cfargument name="getDisabledDates" type="boolean" default="false">
		<cfargument name="getDisabledAddresses" type="boolean" default="false">
		<cfargument name="getRecurringDates" type="boolean" default="false">
		<cfargument name="Sort" type="string" default="Future">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- create a struct matching xmlFields with tableAliases - quotes preserve case --->
		<cfset "local.tableInfo.eventConfig.tableAlias"="e">
		<cfset "local.tableInfo.eventDateConfig.tableAlias"="ed">

		<cfif ARGUMENTS.topicIDList IS NOT "">
			<cfquery name="local.getResultsPrime" datasource="#APPLICATION.EVENT_DSN#">
				select 				EventID
				FROM				t_event e
				LEFT OUTER JOIN		t_TopicRelated AS tr
				ON					(tr.EntityID=e.EventID AND tr.EntityName=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Event">)
				LEFT OUTER JOIN	t_Category AS t
				ON					t.CategoryID=tr.TopicID
				WHERE CategoryID IN (<cfqueryparam value="#ARGUMENTS.topicIDList#" cfsqltype="cf_sql_integer" list="yes">)
				Group by EventID
				Having Count( * ) >= <cfqueryparam value="#ListLen(ARGUMENTS.topicIDList)#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT				e.eventId, e.publicId, e.eventTitle, e.eventConfig, e.parentId, e.thumbnailFile,
								e.timezoneId, e.dateDisabled, ed.cloneOfPublicId, ed.eventDateId, ed.eventDateConfig,
								ed.dateStart, ed.dateEnd, ed.recurrenceStart, ed.recurrenceEnd,
								ed.publicId AS eventDatePublicId, ed.dateDisabled AS eventDateDateDisabled,
								a.address1, a.address2, a.address3, a.city, a.stateProvinceId, a.stateProvinceOther,
								a.countryId, a.countrySubdivisionId, a.postalCode, a.publicId AS addressPublicId,
								a.dateDisabled AS addressDateDisabled, c.countryName,
								Left(CONVERT(char(10),ed.dateStart,111),7) as dateStartYearMonth
								
			FROM				t_Event e
			JOIN				t_EventDate ed
			ON					ed.eventId=e.eventId
			LEFT OUTER JOIN	t_EventAddress ea
			ON					ea.eventId=e.eventId
			LEFT OUTER JOIN	t_Address a
			ON					a.addressId=ea.addressId
			LEFT OUTER JOIN	t_Country c
			ON					c.countryCode=a.countryID
			<cfif not arguments.getDisabledAddresses>
				AND 			a.dateDisabled IS NULL
			</cfif>
			WHERE 1=1
			<cfif ARGUMENTS.topicIDList IS NOT "">
				<cfif local.getResultsPrime.RecordCount GT "0">
					AND e.EventID IN (<cfqueryparam value="#ValueList(local.getResultsPrime.EventID)#" cfsqltype="cf_sql_integer" list="yes">)
				<cfelse>
					AND e.EventID IS NULL
				</cfif>
			</cfif>
			<!--- only get active events --->
			AND ( ed.dateActivated IS NULL  OR ed.dateActivated < CURRENT_TIMESTAMP)
			AND ( ed.dateDeactivated IS NULL OR ed.dateDeactivated > CURRENT_TIMESTAMP)

			<!--- if eventId is numeric, use it, otherwise, pass the other params --->
			<cfif isNumeric(arguments.eventId)>
				AND e.eventId=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventId#">
			<cfelseif len(trim(arguments.eventDatePublicId))>
				AND ed.publicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventDatePublicId#">
			<cfelse>

				<!--- if parentID is numeric, get the children events --->
				<cfif isNumeric(trim(arguments.parentId))>
					AND e.parentId=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentId#">
				<!--- else, get the top level events --->
				<cfelse>
					AND e.parentId IS NULL
				</cfif>

				<cfif trim(arguments.eventTitle) neq "">
					AND e.eventTitle LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.eventTitle)#%">
				</cfif>

				<!--- if a city is passed --->
				<cfif trim(arguments.city) neq "">

					<!--- if this is from an autosuggest, it will have two parts --->
					<cfif listLen(city, ",") eq 2>
						AND a.city=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getToken(arguments.city, 1, ","))#">
						AND (a.stateProvinceID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getToken(arguments.city, 2, ","))#">
							OR c.countryName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getToken(arguments.city, 2, ","))#">
							)
					<cfelse>
						AND a.city=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.city)#">
					</cfif>
				</cfif>

				<!--- dateStart --->
				<cfif isDate(arguments.dateStart)>
					AND (
						<cfif not arguments.dateStartOnly>
							CONVERT(VARCHAR(10), ed.dateStart, 101) >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
						<cfelse>
							CONVERT(VARCHAR(10), ed.dateStart, 101)=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
						</cfif>
						<!--- get recurring dates that started prior to the start date --->
						<cfif arguments.getRecurringDates>
							OR (
									CONVERT(VARCHAR(10), ed.dateStart, 101) < <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
									AND ed.eventDateConfig.exist('/eventDateConfig/repeatConfig')=1
								)
						</cfif>
					)
				</cfif>

				<!--- dateEnd --->
				<cfif isDate(arguments.dateEnd)>
					AND (
						<cfif not arguments.dateEndOnly>
							CONVERT(VARCHAR(10), ed.dateStart, 101) <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateEnd#">
						<cfelse>
							CONVERT(VARCHAR(10), ed.dateStart, 101)=<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateEnd#">
							AND ed.dateEnd IS NOT NULL
						</cfif>
					)
				</cfif>

				<!--- loop through the form elements looking for structs --->
				<cfloop collection="#arguments.xmlFields#" item="local.args">

					<!--- if this is a struct, check for filters --->
					<cfif isStruct(arguments.xmlFields[local.args])>

						<!--- check for "boolean" form elements in this passed struct
								* elements in this scope will limit the query to
									a) only records with this element set to "true" if the argument is "true"
									b) everything but records with this element set to "true" if the argument is "false" --->
						<cfif structKeyExists(arguments.xmlFields[local.args], "boolean")>

							<!--- loop through the form elements to be queried as "boolean" --->
							<cfloop collection="#arguments.xmlFields[local.args].boolean#" item="local.itr">
								<cfif arguments.xmlFields[local.args].boolean[local.itr]>
									AND #local.tableInfo[local.args].tableAlias#.#local.args#.value('(#local.args#/#local.itr#)[1]', 'varchar(2000)')=<cfqueryparam cfsqltype="cf_sql_varchar" value="true">
								<cfelse>
									AND (
										#local.tableInfo[local.args].tableAlias#.#local.args#.exist('/#local.args#/#local.itr#')=0
										OR #local.tableInfo[local.args].tableAlias#.#local.args#.value('(#local.args#/#local.itr#)[1]', 'varchar(2000)')=<cfqueryparam cfsqltype="cf_sql_varchar" value="false">
									)
								</cfif>
							</cfloop>
						</cfif>

						<!--- check for "includeIfTrue" form elements in this passed struct
								* elements in this scope will limit the query to
									a) records with this element set to "true", plus any other matching criteria if the argument is "true"
									b) no records with this element set to "true", but any other matching criteria if the argument is "false" --->
						<cfif structKeyExists(arguments.xmlFields[local.args], "includeIfTrue")>

							<!--- loop through the form elements to be queried as "includeIfTrue" --->
							<cfloop collection="#arguments.xmlFields[local.args].includeIfTrue#" item="local.itr">
								<cfif not arguments.xmlFields.eventConfig.includeIfTrue[local.itr]>
									AND NOT #local.tableInfo[local.args].tableAlias#.#local.args#.value('(#local.args#/#local.itr#)[1]', 'varchar(2000)')=<cfqueryparam cfsqltype="cf_sql_varchar" value="true">
								</cfif>
							</cfloop>
						</cfif>

						<!--- check for "includeIfFalse" form elements in this passed struct
								* elements in this scope will limit the query to
									a) no records with this element set to "true", but all other matching criteria if the argument is true
									b) records with this element set to "true", plus any other matching criteria if the argument is "false" --->
						<cfif structKeyExists(arguments.xmlFields[local.args], "excludeIfTrue")>
							<cfloop collection="#arguments.xmlFields[local.args].excludeIfTrue#" item="local.itr">
								<cfif arguments.xmlFields[local.args].excludeIfTrue[local.itr]>
									AND NOT #local.tableInfo[local.args].tableAlias#.#local.args#.value('(#local.args#/#local.itr#)[1]', 'varchar(2000)')=<cfqueryparam cfsqltype="cf_sql_varchar" value="true">
								</cfif>
							</cfloop>
						</cfif>


						<!--- check for "equals" form elements in this passed struct
								* elements in this scope will limit the query to
									a) records with this element and a matching value --->
						<cfif structKeyExists(arguments.xmlFields[local.args], "equals")>
							<cfset local.thisXmlField=arguments.xmlFields[local.args]>

							<cfloop collection="#local.thisXmlField.equals#" item="local.itr">
								<!--- get the value --->
								<cfset local.thisVal=local.thisXmlField.equals[local.itr]>

								<!--- if the value is not "" --->
								<cfif len(local.thisVal)>
									AND #local.tableInfo[local.args].tableAlias#.#local.args#.value('(#local.args#/#local.itr#)[1]', 'varchar(2000)')=<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.thisVal#">
								</cfif>
							</cfloop>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>

			<!--- return disabled events? --->
			<cfif not arguments.getDisabledEvents>
				AND e.dateDisabled IS NULL
			</cfif>

			<!--- return disabled event dates? --->
			<cfif not arguments.getDisabledDates>
				AND ed.dateDisabled IS NULL
			</cfif>

			ORDER BY ed.dateStart
		</cfquery>

		<!--- add recurring dates --->
		<cfif arguments.getRecurringDates>

			<!--- add recurring dates to the return query --->
			<cfinvoke method="addRecurringDates" returnvariable="local.getResults">
				<cfinvokeargument name="eventDateQuery" value="#local.getResults#">
				<cfinvokeargument name="dateStart" value="#arguments.dateStart#">
				<cfinvokeargument name="dateStartOnly" value="#arguments.dateStartOnly#">
				<cfif isDate(arguments.dateEnd)>
					<cfinvokeargument name="dateEnd" value="#arguments.dateEnd#">
				</cfif>
			</cfinvoke>
		</cfif>

		<cfif ARGUMENTS.Sort IS "Recent">
			<cfquery name="local.getResults" dbtype="query">
				select * from [local].getResults order by DateStart Desc
			</cfquery>
		</cfif>

		<cfreturn local.getResults>
	</cffunction>

	<cffunction name="DrawMonth" returntype="string" output="false">
		<cfargument name="month" type="numeric" required="yes">
		<cfargument name="year" type="numeric" required="yes">
		<cfargument name="SelectedDate" type="date" required="No">
		<cfargument name="topicIDList" type="string" default="">
		<cfargument name="PageActionURL" type="string" default="#CGI.Path_Info#?#CGI.Query_String#">
		<cfargument name="PreviousMonthURL" type="string" default="">
		<cfargument name="NextMonthURL" type="string" default="">

		<cfset var local=structNew()>
		<cfset LOCAL.DateValue=createDate(arguments.year, arguments.month, 1)>
		<cfset LOCAL.aEvents=GetMonthEvents(arguments.month,arguments.year,ARGUMENTS.topicIDList)>
		<cfset LOCAL.sEvent=StructNew()>

		<cfloop index="LOCAL.i" from="1" to="#ArrayLen(LOCAL.aEvents)#" step="1">
			<cfset StructInsert(LOCAL.sEvent,LOCAL.aEvents[LOCAL.i],"1","Yes")>
		</cfloop>

		<cfset LOCAL.ThisPage="#ARGUMENTS.PageActionURL#">
		<cfset LOCAL.ThisLocation=GetToken(LOCAL.ThisPage,1,"?")>
		<cfif ListLen(LOCAL.ThisPage,"?") IS "2">
			<cfset LOCAL.ThisQueryString=GetToken(LOCAL.ThisPage,2,"?")>
		<cfelse>
			<cfset LOCAL.ThisQueryString="">
		</cfif>


		<cfsavecontent variable="LOCAL.ReturnValue">
			<div class="event_calendar">
				<div class="calendar-head clearit">
					<cfoutput>
						<div class="calendar-nav">
							<div><cfif PreviousMonthURL IS NOT ""><a href="#PreviousMonthURL#">&laquo;</a></cfif></div>
							<div class="monthYr"><cf_AddToQueryString querystring="#LOCAL.ThisQueryString#" name="dateStart" value="#ARGUMENTS.Month#-01-#ARGUMENTS.Year#" omitlist="eid"><cf_AddToQueryString querystring="#QueryString#" name="PageActionURL" value="#ARGUMENTS.PageActionURL#"><cf_AddToQueryString querystring="#QueryString#" name="displayMonth" value="1"><a href="#LOCAL.ThisLocation#?#queryString#" class="month">#DateFormat(LOCAL.DateValue,"mmmm yyyy")#</a></div>
							<div><cfif NextMonthURL IS NOT ""><a href="#NextMonthURL#">&raquo;</a></cfif></div>
						</div>
					</cfoutput>
					<div class="calendar-days">
						<div>Su</div> <div>M</div> <div>T</div> <div>W</div> <div>Th</div> <div>F</div> <div class="last-day">Sa</div>
					</div>
				</div>
				<cfset LOCAL.DisplayDays=DaysInMonth(LOCAL.DateValue)+DecrementValue(DayOfWeek(LOCAL.DateValue))>
				<cfset LOCAL.DisplayWeeks=Ceiling(DisplayDays/7)>
				<cfset LOCAL.Counter="0">
				<cfloop index="LOCAL.i" from="1" to="#LOCAL.DisplayWeeks#" step="1">
					<div class="calendar-row">
						<cfloop index="LOCAL.j" from="1" to="7" step="1">
							<cfset LOCAL.ThisClass="">
							<cfset LOCAL.ThisDay=LOCAL.j+LOCAL.Counter>
							<cfif LOCAL.ThisDay LTE LOCAL.DisplayDays-DaysInMonth(LOCAL.DateValue)>
								<div>&nbsp;</div>
							<cfelseif LOCAL.ThisDay GT DaysInMonth(LOCAL.DateValue)+(LOCAL.DisplayDays-DaysInMonth(LOCAL.DateValue))>
								<div>&nbsp;</div>
							<cfelse>
								<cfset LOCAL.ThisDate=CreateDate(Year(LOCAL.DateValue),Month(LOCAL.DateValue),LOCAL.ThisDay-(LOCAL.DisplayDays-DaysInMonth(LOCAL.DateValue)))>
								<cfif DateDiff("d",LOCAL.ThisDate,CreateDate(Year(now()),month(now()),day(now()))) IS "0">
									<cfset LOCAL.ThisClass="today">
								</cfif>
								<cfif ARGUMENTS.SelectedDate IS NOT "" and IsDate(ARGUMENTS.SelectedDate) and DateDiff("d",LOCAL.ThisDate,CreateDate(Year(ARGUMENTS.SelectedDate),month(ARGUMENTS.SelectedDate),day(ARGUMENTS.SelectedDate))) IS "0">
									<cfset LOCAL.ThisClass="#LOCAL.ThisClass# eventSelected">
								</cfif>
								<cfif StructKeyExists(LOCAL.sEvent,day(LOCAL.ThisDate))>
									<cfset LOCAL.ThisClass="#LOCAL.ThisClass# eventDate">
								</cfif><!--- <a href="#LOCAL.ThisLocation#?#queryString#"> --->
								<cfoutput><div <cfif Trim(LOCAL.ThisClass) IS NOT "">class="#Trim(LOCAL.ThisClass)#"</cfif>><cfif StructKeyExists(LOCAL.sEvent,day(LOCAL.ThisDate))><cf_AddToQueryString querystring="#LOCAL.ThisQueryString#" name="dateStart" value="#DateFormat(LOCAL.ThisDate,'mm-dd-yyyy')#" omitlist="eid"><cf_AddToQueryString querystring="#QueryString#" name="PageActionURL" value="#ARGUMENTS.PageActionURL#"><a href="javascript:showDate('#DateFormat(LOCAL.ThisDate,'yyyymmdd')#')">#day(LOCAL.ThisDate)#</a><cfelse>#day(LOCAL.ThisDate)#</cfif></div></cfoutput>
							</cfif>
						</cfloop>
						<cfset LOCAL.Counter=LOCAL.Counter+7>
					</div>
				</cfloop>
			</div>
		</cfsavecontent>

		<cfreturn LOCAL.ReturnValue>
	</cffunction>

	<cffunction name="addRecurringDates" returntype="query" output="false">
		<cfargument name="eventDateQuery" required="true" type="query">
		<cfargument name="dateStart" required="true" type="date">
		<cfargument name="dateStartOnly" type="boolean" default="false">
		<cfargument name="dateEnd" type="string" default="#dateAdd('m', APPLICATION.modules.event.EventDateRangeInMonths, now())#">

		<cfset var local=structNew()>

		<!--- create a copy of the results --->
		<cfset local.recurrenceQuery=duplicate(arguments.eventDateQuery)>

		<!--- loop through the results --->
		<cfloop query="arguments.eventDateQuery">

			<!--- get the eventDateConfig --->
			<cfset local.thisEventDateConfig=xmlParse(arguments.eventDateQuery.eventDateConfig)>

			<!--- if this has a repeatConfig and isn't a clone --->
			<cfif structKeyExists(local.thisEventDateConfig.eventDateConfig, "repeatConfig")
					and structKeyExists(local.thisEventDateConfig.eventDateConfig.repeatConfig, "repeatType")
					and len(trim(local.thisEventDateConfig.eventDateConfig.repeatConfig.repeatType.xmlText))
					and not len(trim(arguments.eventDateQuery.cloneOfPublicId))>

				<!--- if there's a recurrenceStart and it's later than the dateStart, use the recurrenceStart --->
				<cfif isDate(arguments.eventDateQuery.recurrenceStart) and dateCompare(arguments.dateStart, arguments.eventDateQuery.recurrenceStart, "d") eq -1>
					<cfset local.recurrenceDateStart=arguments.eventDateQuery.recurrenceStart>
				<cfelse>
					<cfset local.recurrenceDateStart=arguments.dateStart>
				</cfif>

				<!--- if this is dateStartOnly, then recurrence ends on the same day --->
				<cfif arguments.dateStartOnly>
					<cfset local.recurrenceDateEnd=arguments.dateStart>
				<cfelse>

					<!--- if there's a recurrenceEnd and it's before the dateEnd, use the recurrenceEnd --->
					<cfif isDate(arguments.eventDateQuery.recurrenceEnd) and dateCompare(arguments.dateEnd, arguments.eventDateQuery.recurrenceEnd, "d") eq 1>
						<cfset local.recurrenceDateEnd=arguments.eventDateQuery.recurrenceEnd>
					<cfelse>
						<cfset local.recurrenceDateEnd=arguments.dateEnd>
					</cfif>
				</cfif>

				<!--- don't start recurrence before an event starts --->
				<cfif local.recurrenceDateStart lt arguments.eventDateQuery.dateStart>
					<cfset local.recurrenceDateStart=arguments.eventDateQuery.dateStart>
				</cfif>

				<!--- determine the step, start and end date for the date loop --->
				<cfinvoke method="getRecurrenceSettings" returnvariable="local.recurrenceSettings">
					<cfinvokeargument name="repeatConfig" value="#local.thisEventDateConfig.eventDateConfig.repeatConfig#">
					<cfinvokeargument name="recurrenceDateStart" value="#local.recurrenceDateStart#">
					<cfinvokeargument name="recurrenceDateEnd" value="#local.recurrenceDateEnd#">
					<cfinvokeargument name="dateStart" value="#arguments.eventDateQuery.dateStart#">
				</cfinvoke>

				<!--- if these aren't dates, there's not a valid recurrence with the passed info --->
				<cfif len(trim(local.recurrenceSettings.recurrenceDateStart)) and len(trim(local.recurrenceSettings.recurrenceDateEnd))>

					<!--- loop from the first recurrence to the recurrence end date using the specified step --->
					<cfloop from="#local.recurrenceSettings.recurrenceDateStart#" to="#local.recurrenceSettings.recurrenceDateEnd#" index="local.itr" step="#local.recurrenceSettings.recurrenceDateStep#">

						<!--- add this recurrence by default --->
						<cfset local.addRecurrence=true>

						<!--- don't show weekends if repeat type is weekday --->
						<cfif local.thisEventDateConfig.eventDateConfig.repeatConfig.repeatType.xmlText eq "weekday" and listFind("1,7", dayOfWeek(local.itr))>
							<cfset local.addRecurrence=false>
						</cfif>

						<cfif local.addRecurrence>
							<!--- the dateStart for this recurrence --->
							<cfset local.thisRecurringDateStart=createDateTime(year(local.itr), month(local.itr), day(local.itr), hour(arguments.eventDateQuery.dateStart), minute(arguments.eventDateQuery.dateStart), second(arguments.eventDateQuery.dateStart))>

							<!--- check if this recurrence exists in the event dates in the database --->
							<cfquery name="local.checkExists" dbtype="query">
								SELECT	eventDateId
								FROM	arguments.eventDateQuery
								WHERE	(
											eventDatePublicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventDateQuery.eventDatePublicId#">
											OR cloneOfPublicId=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventDateQuery.eventDatePublicId#">
										)
								AND		dateStart=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.thisRecurringDateStart#">
							</cfquery>

							<!--- if there's no matching record of this date in the db --->
							<cfif not local.checkExists.recordcount>

								<!--- add the date to the query results --->
								<cfset queryAddRow(local.recurrenceQuery)>
								<cfloop list="#arguments.eventDateQuery.columnList#" index="local.inr">
										<cfset querySetCell(local.recurrenceQuery, local.inr, arguments.eventDateQuery[local.inr][arguments.eventDateQuery.currentrow])>
								</cfloop>

								<!--- calculate and set the dateEnd --->
								<cfif not isDate(arguments.eventDateQuery.dateEnd)>
									<cfset querySetCell(local.recurrenceQuery, "dateEnd", "")>
								<cfelse>
									<!--- use the timespan between the original dateStart and date End to figure dateEnd --->
									<cfset local.thisTimeSpan=arguments.eventDateQuery.dateEnd - arguments.eventDateQuery.dateStart>
									<cfset querySetCell(local.recurrenceQuery, "dateEnd", local.thisRecurringDateStart + local.thisTimeSpan)>
								</cfif>

								<!--- set the dateStart --->
								<cfset querySetCell(local.recurrenceQuery, "dateStart", local.thisRecurringDateStart)>

								<!--- create a publicId (prefix with "R" so we know it's a recurrence) --->
								<cfset querySetCell(local.recurrenceQuery, "eventDatePublicId", APPLICATION.utilsObj.createUniqueId("R"))>

								<!--- add cloneOfPublicId --->
								<cfset querySetCell(local.recurrenceQuery, "cloneOfPublicId", arguments.eventDateQuery.eventDatePublicId)>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>

		<!--- order the results by date, don't include dates which were included for recurrence if they're in the past --->
		<cfquery dbtype="query" name="local.getResults">
			SELECT	DISTINCT #arguments.eventDateQuery.columnList#
			FROM	[local].recurrenceQuery
			WHERE	dateStart >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
			ORDER BY dateStart
		</cfquery>

		<cfreturn local.getResults>
	</cffunction>

	<!--- get events for the admin interface --->
	<cffunction name="getEventsAdmin" output="false" access="remote" returntype="any">
		<cfargument name="page" default="">
		<cfargument name="pageSize" default="">
		<cfargument name="cfgridsortcolumn" default="">
		<cfargument name="cfgridsortdirection" default="">
		<cfargument name="eventTitle" type="string" default="">
		<cfargument name="dateStart" type="string" default="">
		<cfargument name="dateEnd" type="string" default="">
		<cfargument name="status" type="string" default="">
		<cfargument name="parentId" type="string" default="">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT		e.publicId, e.eventTitle, CONVERT(VARCHAR(10), ed.dateStart, 101) AS dateStart,
						CONVERT(VARCHAR(10), ed.dateEnd, 101) AS dateEnd,
						CASE
							WHEN (e.dateDisabled is not Null)
							THEN 'Disabled'
							WHEN (e.dateDisabled is Null AND (ed.DateEnd > CURRENT_TIMESTAMP) or (ed.DateStart > CURRENT_TIMESTAMP))
							THEN 'Currrent / Future Events (Active)'
							ELSE 'Past Events'
							END AS status,
						CASE
							WHEN (e.dateDisabled IS NOT NULL)
							THEN '<img src="/common/images/admin/icon_plus.gif" width="12" height="10" /> Enable'
							WHEN (e.dateDisabled IS NULL)
							THEN '<img src="/common/images/admin/icon_delete.gif" width="12" height="12" /> Disable'
							END AS delUser,
						edit='<img src="/common/images/admin/icon_edit.gif" width="12" height="12" />'
			FROM		t_Event e
			JOIN		t_EventDate ed
			ON			ed.eventDateId=(
							<!--- there should be exactly one record of 'event' dateType per event --->
							SELECT TOP 1 ed2.eventDateId
							FROM	t_EventDate ed2
							WHERE	ed2.eventDateConfig.value('/eventDateConfig[1]/dateType[1]','varchar(50)')=<cfqueryparam cfsqltype="cf_sql_varchar" value="event">
							AND		ed2.eventId=e.eventId
						)

			WHERE 1=1

			<!--- if parentID is numeric, get the children events --->
			<cfif isNumeric(trim(arguments.parentId))>
				AND e.parentId=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parentId#">
			<!--- else, get the top level events --->
			<cfelse>
				AND e.parentId IS NULL
			</cfif>

			<cfif trim(arguments.eventTitle) neq "">
				AND e.eventTitle LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.eventTitle#%">
			</cfif>

			<!--- dateStart --->
			<cfif isDate(arguments.dateStart)>
				AND CONVERT(VARCHAR(10), ed.dateStart, 101) >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
			</cfif>

			<!--- dateEnd --->
			<cfif isDate(arguments.dateEnd)>
				AND CONVERT(VARCHAR(10), ed.dateEnd, 101) <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateEnd#">
			</cfif>

			<cfif len(arguments.status)>
				<cfswitch expression="#arguments.status#">
					<cfcase value="1">
						AND e.dateDisabled IS NULL
						AND ((ed.DateEnd > CURRENT_TIMESTAMP) OR (ed.DateStart > CURRENT_TIMESTAMP))
					</cfcase>
					<cfcase value="2">
						AND e.dateDisabled IS NULL
						AND	ed.DateEnd < CURRENT_TIMESTAMP 
					</cfcase>
					<cfcase value="3">
						AND e.dateDisabled IS NOT NULL
					</cfcase>
				</cfswitch>
			</cfif>

			<!--- if ordered by the grid --->
			<cfif trim(arguments.cfgridsortcolumn) neq "">
				ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#
			<!--- otherwise order by dateStart and eventTitle --->
			<cfelse>
				ORDER BY ed.dateStart, e.eventTitle
			</cfif>
		</cfquery>


		<!--- if page and pageSize are numeric then return for cfgrid --->
		<cfif isNumeric(arguments.page) and isNumeric(arguments.pageSize)>
			<!--- return the results --->
			<cfreturn queryConvertForGrid(local.getResults, arguments.page, arguments.pageSize)>

		<!--- else, return the query  --->
		<cfelse>
			<cfreturn local.getResults>
		</cfif>
	</cffunction>






	<!--- push an event live --->
	<cffunction name="pushLive" returntype="struct" output="false">
		<cfargument name="publicId" required="true">
		<cfargument name="eventDateObjName" type="string" default="EventDate">

		<!--- keep scope local to function --->
		<cfset var local=structNew()>
		<cfset local.returnStruct=structNew()>

		<cfset local.postToProdObj=createObject("component", "com.PostToProduction.postToProduction")>

		<!--- set some return defaults --->
		<cfset local.returnStruct.source="">
		<cfset local.returnStruct.destination="">
		<cfset local.returnStruct.pushedLive=true>

		<!--- create an array for results --->
		<cfset local.returnStruct.uploadResults=arrayNew(1)>
		<cfset local.returnStruct.uploadResults[1]=structNew()>
		<cfset local.returnStruct.uploadResults[1].success="no">
		<cfset local.returnStruct.uploadResults[1].errorCode="-1">
		<cfset local.returnStruct.uploadResults[1].errorText="Events can only be pushed live from the staging server.">
		<cfset local.returnStruct.uploadResults[1].fileName="">

		<!--- get this event --->
		<cfinvoke method="getEvent" returnvariable="local.thisEvent">
			<cfinvokeargument name="publicId" value="#trim(arguments.publicId)#">
		</cfinvoke>

		<!--- get the production site info --->
		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="GetProductionSiteInformation"
			returnvariable="local.sProductionSiteInformation"
			CategoryID="1">

		<!--- only push from staging --->
		<cfif APPLICATION.Staging and IsStruct(local.sProductionSiteInformation)>

			<!--- push the objects --->
			<cftry>

				<!--- push this event live --->
				<cfset local.returnStruct.eventPushedLive=local.thisEvent.eventObj.pushLive()>

				<!--- push this address live --->
				<cfset local.returnStruct.addressPushedLive=local.thisEvent.addressObj.pushLive()>

				<!--- loop through this event's dates --->
				<cfloop query="local.thisEvent.dates">

					<!--- get this eventDate --->
					<cfinvoke method="getEventDate" returnvariable="local.thisEventDate">
						<cfinvokeargument name="eventDateId" value="#local.thisEvent.dates.eventDateId#">
						<cfinvokeargument name="eventDateObjName" value="#arguments.eventDateObjName#">
					</cfinvoke>

					<!--- push this eventDate live --->
					<cfset local.returnStruct.datesPushedLive[local.thisEvent.dates.publicId]=local.thisEventDate.pushLive()>
				</cfloop>

				<!--- loop through this event's children --->
				<cfloop query="local.thisEvent.children">

					<!--- get this child event --->
					<cfinvoke method="getEvent" returnvariable="local.thisChildEvent">
						<cfinvokeargument name="eventId" value="#local.thisEvent.children.eventId#">
					</cfinvoke>

					<!--- push this child event live --->
					<cfset local.returnStruct.childrenPushedLive[local.thisEvent.children.publicId]=local.thisChildEvent.pushLive()>
				</cfloop>

				<!--- sync the topics --->
				<cfinvoke component="#local.postToProdObj#" method="postLive">
				     <cfinvokeargument name="valueList" value="t_Event,#local.thisEvent.eventQry.eventId#">
				     <cfinvokeargument name="columnList" value="entityName,entityId">
				     <cfinvokeargument name="tableName" value="t_TopicEntity">
					 <cfinvokeargument name="DestinationDSN" value="#local.sProductionSiteInformation.ProductionDBDSN#">
				     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
				     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
				     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
				     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				</cfinvoke>

				<cfcatch>

					<!--- if there are any errors, don't indicate that this facility was pushed live --->
					<cfif not arrayLen(local.returnStruct.uploadResults)>
							<cfset local.returnStruct.uploadResults[1]=structNew()>
					</cfif>
					<cfset local.returnStruct.pushedLive=false>
					<cfset local.returnStruct.uploadResults[1].errorText="An error occurred while synching data from staging to the live site.">
					<cfset local.returnStruct.uploadResults[1].success="false">
					<cfset local.returnStruct.uploadResults[1].errorCode="-1">
					<cfset local.returnStruct.uploadResults[1].fileName="">
					<cfreturn local.returnStruct>
				</cfcatch>
			</cftry>

			<!--- indicate success --->
			<cfset local.returnStruct.uploadResults[1].errorText="Push live completed">
			<cfset local.returnStruct.uploadResults[1].success="true">
			<cfset local.returnStruct.uploadResults[1].errorCode="">
			<cfset local.returnStruct.uploadResults[1].fileName="">
		<cfelse>
			<!--- if this isn't staging --->
			<cfset local.returnStruct.pushedLive=false>
		</cfif>

		<!--- return the results --->
		<cfreturn local.returnStruct>
	</cffunction>


	<!--- this function was ripped from commonFunctions.cfm - used for ftp connection --->
	<cffunction name="scrub" returntype="string" output="false">
		<cfargument name="strInput" type="string" required="yes">

		<cfset var local=structNew()>

		<cfset local.ReturnValue=lcase(ReReplace(arguments.strInput,"[�\!'/:"".+=;?&<>|,]","","all"))>
		<cfset local.ReturnValue=lcase(ReReplace(local.ReturnValue,"[ ]"," ","all"))>
		<cfset local.ReturnValue=lcase(ReReplace(local.ReturnValue,"[ ]","-","all"))>
		<cfreturn local.ReturnValue>
	</cffunction>

	<!--- get an array of all of the events for the month --->
	<cffunction name="GetMonthEvents" access="remote" returntype="array" output="false">
		<cfargument name="month" type="numeric" required="yes">
		<cfargument name="year" type="numeric" required="yes">
		<cfargument name="topicIDList" type="string" default="">

		<!--- init variables --->
		<cfset var local=structNew()>
		<cfset local.returnArray=ArrayNew(1)>
		<cfset local.dateStart=createDate(arguments.year, arguments.month, 1)>

		<cfif ARGUMENTS.topicIDList IS NOT "">
			<cfquery name="local.getResultsPrime" datasource="#APPLICATION.EVENT_DSN#">
				select 				EventID
				FROM				t_event e
				LEFT OUTER JOIN		t_TopicRelated AS tr
				ON					(tr.EntityID=e.EventID AND tr.EntityName=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Event">)
				LEFT OUTER JOIN	t_Category AS t
				ON					t.CategoryID=tr.TopicID
				WHERE CategoryID IN (<cfqueryparam value="#ARGUMENTS.topicIDList#" cfsqltype="cf_sql_integer" list="yes">)
				Group by EventID
				Having Count( * ) >= <cfqueryparam value="#ListLen(ARGUMENTS.topicIDList)#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>

		<cfquery name="local.GetMonthEvents" datasource="#APPLICATION.EVENT_DSN#">
			SELECT 		ed.eventDateConfig, ed.dateStart, ed.dateEnd, ed.publicId AS eventDatePublicId,
						ed.cloneOfPublicId, ed.eventDateId, ed.recurrenceStart, ed.recurrenceEnd
			FROM		t_eventdate ed
			JOIN		t_event e ON e.eventId=ed.eventId
			WHERE		ed.dateStart IS NOT NULL
			<cfif ARGUMENTS.topicIDList IS NOT "">
				<cfif local.getResultsPrime.RecordCount GT "0">
					AND e.EventID IN (<cfqueryparam value="#ValueList(local.getResultsPrime.EventID)#" cfsqltype="cf_sql_integer" list="yes">)
				<cfelse>
					AND e.EventID IS NULL
				</cfif>
			</cfif>
			AND			(
							(
								MONTH(dateStart)=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.month)#">
								AND	YEAR(dateStart)=<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.year)#">
							)
							<!--- get recurring dates that started prior to the start date --->
							OR (
									CONVERT(VARCHAR(10), dateStart, 101) < <cfqueryparam cfsqltype="cf_sql_date" value="#local.dateStart#">
									AND eventDateConfig.exist('/eventDateConfig/repeatConfig')=1
								)
						)

			AND			e.dateDisabled IS NULL
			AND 		( ed.dateActivated IS NULL  OR ed.dateActivated < CURRENT_TIMESTAMP)
			AND 		( ed.dateDeactivated IS NULL OR ed.dateDeactivated > CURRENT_TIMESTAMP)

			ORDER BY	dateStart
		</cfquery>

		<!--- add recurring dates to the return query --->
		<cfinvoke method="addRecurringDates" returnvariable="local.GetMonthEvents">
			<cfinvokeargument name="eventDateQuery" value="#local.GetMonthEvents#">
			<cfinvokeargument name="dateStart" value="#local.dateStart#">
			<cfinvokeargument name="dateEnd" value="#createDate(arguments.year, arguments.month, daysInMonth(local.dateStart))#">
		</cfinvoke>

		<!--- Add Employee Dates --->
		<cfinvoke component="com.ContentManager.EmployeeHandler"
			method="getDates"
			returnVariable="LOCAL.qEmployeeEvents"
			mode="displayMonth"
			SelectedDate="#CreateDate(ARGUMENTS.Year,ARGUMENTS.Month,1)#"
			topicIDList="#ARGUMENTS.topicIDList#">
			
		<cfoutput query="LOCAL.qEmployeeEvents">
			<cfset QueryAddRow(local.GetMonthEvents)>
			<cfset QuerySetCell(local.GetMonthEvents,"DateStart",LOCAL.qEmployeeEvents.DateStart)>
			<cfset QuerySetCell(local.GetMonthEvents,"DateEnd",LOCAL.qEmployeeEvents.DateStart)>
		</cfoutput>

		<cfquery name="local.GetMonthEvents" dbtype="query">
			select * from [local].GetMonthEvents order by DateStart
		</cfquery>
		
		<cfoutput query="local.GetMonthEvents" group="dateStart">
			<cfset ArrayAppend(local.returnArray, day(local.GetMonthEvents.dateStart))>
		</cfoutput>
		
		<cfreturn local.returnArray>
	</cffunction>


	<cffunction name="getRecurrenceSettings" returntype="struct" output="false">
		<cfargument name="repeatConfig" default="">
		<cfargument name="recurrenceDateStart" required="true" type="date">
		<cfargument name="recurrenceDateEnd" required="true" type="date">
		<cfargument name="dateStart" required="true" type="date">

		<cfset var local=structNew()>
		<cfset local.returnStruct=structNew()>
		<cfset local.returnStruct.recurrenceDateStart="">
		<cfset local.returnStruct.recurrenceDateEnd=arguments.recurrenceDateEnd>

		<cfset local.dateDayOfWeek=dayOfWeek(arguments.dateStart)>
		<cfset local.dateDayOfMonth=day(arguments.dateStart)>

		<!--- figure out the step timespan --->
		<cfswitch expression="#arguments.repeatConfig.repeatType.xmlText#">
			<cfcase value="week">
				<!--- set the step to 7 days --->
				<cfset local.returnStruct.recurrenceDateStep=createTimeSpan(7,0,0,0)>
			</cfcase>
			<cfcase value="month">
				<!--- set the step to a month --->
				<cfset local.returnStruct.recurrenceDateStep=createTimeSpan(daysInMonth(arguments.dateStart),0,0,0)>
			</cfcase>
			<!--- if this is a patterned repeatType --->
			<cfcase value="everyday,weekday">
				<!--- set the step to a day --->
				<cfset local.returnStruct.recurrenceDateStep=createTimeSpan(1,0,0,0)>
			</cfcase>
		</cfswitch>

		<!--- if the start and recurrence start are the same date, change the first recurrence to one step after the startDate --->
		<cfif arguments.dateStart eq arguments.recurrenceDateStart>
			<cfset local.returnStruct.recurrenceDateStart=arguments.recurrenceDateStart + local.returnStruct.recurrenceDateStep>
		<!--- else if recurrenceDateStart isn't a weekday, but this is a weekday repeatType --->
		<cfelseif arguments.repeatConfig.repeatType.xmlText eq "weekday" and listFind("1,7", dayOfWeek(arguments.recurrenceDateStart))>
			<cfset local.returnStruct.recurrenceDateStart=dateAdd("w", 1, arguments.recurrenceDateStart)>
		<!--- else, loop day by day to find the first recurrence --->
		<cfelseif listFindNoCase("week,month", arguments.repeatConfig.repeatType.xmlText)>
			<!--- determine the first recurrence --->
			<cfloop from="#arguments.recurrenceDateStart#" to="#arguments.recurrenceDateEnd#" index="local.itr">
				<!--- if this repeatType is week and the day of the week matches, or month and the day of month matches --->
				<cfif (arguments.repeatConfig.repeatType.xmlText eq "week" and dayOfWeek(local.itr) eq local.dateDayOfWeek)
						or (arguments.repeatConfig.repeatType.xmlText eq "month" and day(local.itr) eq local.dateDayOfMonth)>
					<cfset local.returnStruct.recurrenceDateStart=local.itr>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.returnStruct>
	</cffunction>

</cfcomponent>