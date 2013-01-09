<cfcomponent hint="Handles event registrations">

	<cffunction name="init" returntype="EventRegistration">
		<cfreturn this>
	</cffunction>



	<!--- checks registration status --->
	<cffunction name="checkRegistration" returntype="struct" output="false">
		<cfargument name="eventDatePublicId" required="true" type="string">
		<cfargument name="registrantsToAdd" default="">

		<!--- init variables --->
		<cfset var local = structNew()>
		<cfset local.returnStruct.maxExceeded = false>
		<cfset local.returnStruct.maxReached = false>

		<!--- get the number of registrants --->
		<cfquery name="local.getNumRegistrants" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	sum(registrants) AS registrants
			FROM	t_EventRegistration
			WHERE	eventDatePublicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventDatePublicId#">
		</cfquery>

		<!--- get the max number of registrants --->
		<cfquery name="local.getMaxRegistrants" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	eventDateConfig.value('(//registration/maxRegistrants[text()!="0"])[1]','int') AS maxRegistrants
			FROM	t_EventDate
			WHERE	publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventDatePublicId#">
		</cfquery>

		<!--- return the registrants, maxRegistrants, and whether or not the max is exceeded --->
		<cfset local.returnStruct.registrants = val(local.getNumRegistrants.registrants)>
		<cfset local.returnStruct.maxRegistrants = val(local.getMaxRegistrants.maxRegistrants)>

		<cfif val(registrantsToAdd) + local.returnStruct.registrants gt local.returnStruct.maxRegistrants>
			<cfset local.returnStruct.maxExceeded = true>
		</cfif>

		<cfif local.returnStruct.registrants gte local.returnStruct.maxRegistrants>
			<cfset local.returnStruct.maxReached = true>
		</cfif>

		<!--- return the results --->
		<cfreturn local.returnStruct>
	</cffunction>




	<!--- get eventDates with registered users --->
	<cffunction name="getEventDatesWithRegistrants" output="false" access="remote" returntype="any">
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
		<cfset var local = structNew() />

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT		ed.publicId, e.eventTitle, CONVERT(VARCHAR(10), ed.dateStart, 101) AS dateStart,
						CONVERT(VARCHAR(10), ed.dateEnd, 101) AS dateEnd, registrants,
						eventDateConfig.value('/eventDateConfig[1]/registration[1]/maxRegistrants[1]', 'integer') as maxRegistrants,
						edit = '<img src="/common/images/admin/icon_edit.gif" width="12" height="12" />',
						CASE
							WHEN eventDateConfig.value('/eventDateConfig[1]/registration[1]/maxRegistrants[1]', 'integer') = 0
							THEN ''
							WHEN eventDateConfig.value('/eventDateConfig[1]/registration[1]/maxRegistrants[1]', 'integer') > 0
							THEN '/' + eventDateConfig.value('/eventDateConfig[1]/registration[1]/maxRegistrants[1]', 'varchar(10)')
						END AS maxRegistrantsDisplay
			FROM		t_Event e
			JOIN		t_EventDate ed
			ON			ed.eventId = e.eventId
			JOIN		t_EventRegistration er
			ON			er.eventDatePublicId = ed.publicId

			WHERE		er.registrants > 0
			AND			er.dateCancelled IS NULL


			<cfif len(trim(arguments.eventTitle))>
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



			<!--- if ordered by the grid --->
			<cfif len(trim(arguments.cfgridsortcolumn))>
				ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#
			<!--- otherwise order by dateStart and eventTitle --->
			<cfelse>
				ORDER BY CONVERT(VARCHAR(10), ed.dateStart, 101), e.eventTitle
			</cfif>
		</cfquery>

		<!--- we can't do a group by on entities with xml functions, so we do the group by here --->
		<cfquery name="local.getResults" dbtype="query">
			SELECT publicId, eventTitle, dateStart, dateEnd, edit,
			CAST(SUM(registrants) AS VARCHAR) + maxRegistrantsDisplay as registrants
			FROM [local].getResults
			GROUP BY publicId, eventTitle, dateStart, dateEnd, edit, maxRegistrantsDisplay
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




	<!--- get the registrants for a particular eventDate --->
	<cffunction name="getRegistrants" returntype="query" output="false">
		<cfargument name="eventRegistrationPublicId" type="string" default="">
		<cfargument name="eventDatePublicId" type="string" default="">
		<cfargument name="getCancelledRegistrants" default="false">

		<!--- init variables --->
		<cfset var local = structNew()>

		<!--- get the number of registrants --->
		<cfquery name="local.getResults" datasource="#APPLICATION.EVENT_DSN#">
			SELECT	eventRegistrationId, eventDatePublicId, paymentPublicId, registrants, snapshot, publicId, dateCancelled,
					dateAdded,dateModified, dateDisabled
			FROM	t_EventRegistration
			WHERE

			<!--- if we're getting a particular registration --->
			<cfif len(trim(arguments.eventRegistrationPublicId))>
				publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventRegistrationPublicId#">
			<cfelseif len(trim(arguments.eventDatePublicId))>
				eventDatePublicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventDatePublicId#">
			<cfelse>
				1=0
			</cfif>

			<!--- if we want to exclude cancelled registrants --->
			<cfif not arguments.getCancelledRegistrants>
				AND	dateCancelled IS NULL
			</cfif>

			ORDER BY	snapshot.value('(//snapshot/info/lastName[text()])[1]','varchar(20)'),
						snapshot.value('(//snapshot/info/firstName[text()])[1]','varchar(20)')
		</cfquery>

		<!--- return the results --->
		<cfreturn local.getResults>
	</cffunction>


</cfcomponent>