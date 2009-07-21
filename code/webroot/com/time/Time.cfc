<cfcomponent hint="time functions" output="true">

	
	<cffunction name="init" returntype="Time">
		<cfreturn this />
	</cffunction>

	<cffunction name="getTimezoneIds" returntype="array" output="false">
	
		<cfset var local = structNew() />
	
		<!--- create a coldfusion array to hold the results --->
		<cfset local.returnArray = arrayNew(1) />
		
		<!--- create a java TimeZone object --->	
		<cfset local.timezoneObj = createObject("java", "java.util.TimeZone") />
		
		<!--- convert the timezone ids to a java list object --->
		<cfset local.listObj = createObject( "java", "java.util.Arrays" ).AsList(local.timezoneObj.getAvailableIds()) />
		
		<!--- add the java list object contents to the coldfusion array --->
		<cfset local.returnArray.addAll(local.listObj) />
		
		<!--- sort case insensitive --->
		<cfset arraySort(local.returnArray, "textnocase") />
		
		<!--- return the array of timezoneIds --->
		<cfreturn local.returnArray />
	</cffunction>
	
	


	<!--- mergeDateAndTime  --->
	<cffunction name="mergeDateAndTime" returntype="struct" output="false">
		<cfargument name="date" default="">
		<cfargument name="hour" default="">
		<cfargument name="minute" default="">
		<cfargument name="second" default="">
		<cfargument name="allowJustTime" default="true">
	
		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		<cfset local.returnStruct.success = true>
		<cfset local.returnStruct.message = "">
		
		<!--- set a default  - not a date yet --->
		<cfset local.returnStruct.mergedDate = "" />
		
		<!--- do some validation for hour --->
		<cfif not isNumeric(arguments.hour) or not isValid("range", arguments.hour, 0, 23)>
			<cfset arguments.hour = 0>
		</cfif>
		
		<!--- do some validation for minute --->
		<cfif not isNumeric(arguments.minute) or not isValid("range", arguments.minute, 0, 59)>
			<cfset arguments.minute = 0>
		</cfif>
		
		<!--- do some validation for second --->
		<cfif not isNumeric(arguments.second) or not isValid("range", arguments.second, 0, 59)>
			<cfset arguments.second = 0>
		</cfif>
		
		<!--- if a date is passed, use it --->
		<cfif isDate(arguments.date)>
			<cfset local.returnStruct.mergedDate = createDateTime(year(arguments.date), month(arguments.date), day(arguments.date),
														arguments.hour, arguments.minute, arguments.second) />
		<!--- else, just use the time --->
		<cfelseif arguments.allowJustTime>
			<cfset local.returnStruct.mergedDate = createTime(arguments.hour, arguments.minute, arguments.second) />
		<cfelse>
			<cfset local.returnStruct.success = false />
			<cfset local.returnStruct.message = "A valid date must be passed for this parameter." />
		</cfif>
		
		<!--- return the results --->
		<cfreturn local.returnStruct />
	</cffunction>



	<!--- convertDatetimeToStruct  --->
	<cffunction name="convertDatetimeToStruct" returntype="struct" output="false">
		<cfargument name="datetime" default="">
		<cfargument name="midnightAsNulls" default="true">
		<cfargument name="dateMask" default="mm/dd/yyyy">
		<cfargument name="hideOldDates" default="true">
	
		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		
		<!--- create the struct params --->
		<cfset local.returnStruct.date = "" />
		<cfset local.returnStruct.time = structNew() />
		<cfset local.returnStruct.time.hour = "" />
		<cfset local.returnStruct.time.minute = "" />
		<cfset local.returnStruct.time.second = "" />

		<!--- if this is a date, populate. if this isn't a date, return the structure as empty --->
		<cfif isDate(arguments.datetime)>
			
			<!--- if createTime is used, the date is set to 12/30/1899, so don't display older dates as a default --->
			<cfif arguments.hideOldDates and dateCompare(createDate(1900, 01, 01), arguments.datetime) eq -1>
				<!--- return the date --->
				<cfset local.returnStruct.date = dateFormat(arguments.datetime, arguments.dateMask) >
			</cfif>
			
			<!--- if midnightAsNulls is set and this datetime is midnight, return the time parts as nulls --->
			<cfif arguments.midnightAsNulls and toString(timeFormat(arguments.datetime, "HH:mm:ss")) eq "00:00:00">
				<cfreturn local.returnStruct />
			</cfif>
			
			<!--- set the time parts --->
			<cfset local.returnStruct.time.hour = numberformat(hour(arguments.datetime), "00") />
			<cfset local.returnStruct.time.minute = numberformat(minute(arguments.datetime), "00") />
			<cfset local.returnStruct.time.second = numberformat(second(arguments.datetime), "00") />
		</cfif>
		
		<!--- return the results --->
		<cfreturn local.returnStruct />
	</cffunction>




	<!--- outputs a pulldown for time elements based upon passed params --->
	<cffunction name="timeSelect" output="true">
		<cfargument name="selectType" default="minute">
		<cfargument name="selectName" default="">
		<cfargument name="selectId" default="">
		<cfargument name="selectClass" default="">
		<cfargument name="countTo" default="60">
		<cfargument name="stepBy" default="5">
		<cfargument name="selected" default="">
		<cfargument name="default" default="">
		
		<cfset var local = structNew() />
		
		<!--- settings for hour --->
		<cfif arguments.selectType eq "hour">
			<cfset arguments.countTo = 24 />
			<cfset arguments.stepBy = 1 />
		</cfif>
		
		<cfoutput>
		<!--- create the select dropdown --->
		<select name="#arguments.selectName#" id="#arguments.selectId#" class="#arguments.selectClass#">
				<option value="">#arguments.selectType#</option>
		
			<!--- loop through the units of time --->
			<cfloop from="1" to="#arguments.countTo#" index="local.itr" step="#arguments.stepBy#">
				
				<!--- get the val starting at 0 --->
				<cfset local.thisVal = local.itr - 1 />
				
				<!--- display each option, determining if it should be selected --->
				<option value="#local.thisVal#"<cfif (not len(arguments.selected) and local.thisVal eq arguments.default) or (len(arguments.selected) and arguments.selected eq local.thisVal)> selected="selected"</cfif>>
					
					<!--- display the values depending on selectType --->
					<cfswitch expression="#arguments.selectType#">
						<cfcase value="hour">
							#iif(yesNoFormat(local.thisVal mod 12), "local.thisVal mod 12", DE(12))# #iif(local.thisVal gte 12, DE("PM"), DE("AM"))#
						</cfcase>
						<cfdefaultcase>
							#numberFormat(local.thisVal, "00")#
						</cfdefaultcase>
					</cfswitch>
				</option>
			</cfloop>
		</select>
		</cfoutput>
	</cffunction>

</cfcomponent>