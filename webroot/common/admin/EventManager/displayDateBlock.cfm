<cfparam name="datePublicId" default="newEvent">
<cfparam name="recurrence" default="">
<cfparam name="formSubmitted" default="">

<cfset dateBlock = structNew()>
<cfset recurrenceDateBlock = structNew()>

<cfif isDefined("attributes") and structKeyExists(attributes, "datePublicId")>
	<cfset datePublicId = attributes.datePublicId>
</cfif>

<cfset dateBlock.dateTypeArray =  arrayNew(1)>
<cfset dateBlock.ctr = 1>
<cfset recurrenceDateBlock.dateTypeArray =  arrayNew(1)>
<cfset recurrenceDateBlock.ctr = 1>

<!--- grab this eventDate --->
<cfset dateBlock.dateStruct = form.eventDate[datePublicId]>

<cfset dateBlock.recurrence = dateBlock.dateStruct.eventDateConfig.repeatConfig.repeatType>

<!--- add date fields to array --->
<cfset dateBlock.startDate.name = "Start Date/Time">
<cfset dateBlock.startDate.type = "dateStart">
<cfset arrayAppend(dateBlock.dateTypeArray, dateBlock.startDate)>

<cfset dateBlock.dateEnd.name = "End Date/Time">
<cfset dateBlock.dateEnd.type = "dateEnd">
<cfset arrayAppend(dateBlock.dateTypeArray, dateBlock.dateEnd)>


<cfset recurrenceDateBlock.recurrenceEnd.name = "Recurrence End Date">
<cfset recurrenceDateBlock.recurrenceEnd.type = "recurrenceEnd">
<cfset arrayAppend(recurrenceDateBlock.dateTypeArray, recurrenceDateBlock.recurrenceEnd)>


<cfoutput>
	<table width="100%"<cfif structKeyExists(dateBlock.dateStruct, "disable") or (structKeyExists(dateBlock.dateStruct, "dateDisabled") and isDate(dateBlock.dateStruct.dateDisabled))> class="red"</cfif>>
		<tr>
			<td>
				<!--- if this is a new event or the "event" eventDate, then the first date must be of eventDateType "event" --->
				<cfif datePublicId eq "newEvent"
						or dateBlock.dateStruct.eventDateConfig.dateType eq "event">
					<cfinput type="hidden" name="eventDate.#datePublicId#.eventDateConfig.dateType" value="event">
				</cfif>

				<cfinput type="hidden" name="eventDate.#datePublicId#.eventDateConfig.visibility" value="everyScope">
			</td>
		</tr>

		<tr>
			<td>
				<strong>Event Date </strong>
			</td>
			<td colspan="2">
				Disabled? <cfinput type="checkbox" name="eventDate.#datePublicId#.disable" value="true" checked="#structKeyExists(dateBlock.dateStruct, "disable") or (structKeyExists(dateBlock.dateStruct, "dateDisabled") and isDate(dateBlock.dateStruct.dateDisabled))#">
			</td>
			<td align="right">

			</td>
		</tr>

		<!--- loop through the date fields --->
		<cfloop array="#dateBlock.dateTypeArray#" index="dateBlock.itr">

			<cfset dateBlock.dateError = false>

			<!--- new row every two tds --->
			<cfif dateBlock.ctr mod 2>
				<tr>
			</cfif>

			<td valign="top">

				<!--- check for error on this eventDate part --->
				<cfif structKeyExists(caller.eventDateErrors, datePublicId)
						and caller.eventDateErrors[datePublicId].isInError("#dateBlock.itr.type#")
						and formSubmitted neq "">
					<cfset dateBlock.dateError = true>
				</cfif>

				<div #iif(dateBlock.dateError, DE("class=""red"""), "")#>
					#dateBlock.itr.name#:
				</div>
			</td>
			<td>
				<!--- this creates the date field for this eventDate --->
				<cfinput id="eventDate.#datePublicId#.#dateBlock.itr.type#.date"
						name="eventDate.#datePublicId#.#dateBlock.itr.type#.date"
						value="#dateBlock.dateStruct[dateBlock.itr.type].date#"
						type="datefield">

				<!--- the hour and minute fields --->
				<cfinvoke method="timeSelect" component="#APPLICATION.timeObj#" returnvariable="hourSelect">
					<cfinvokeargument name="selectType" value="hour">
					<cfinvokeargument name="selectName" value="eventDate.#datePublicId#.#dateBlock.itr.type#.time.hour">
					<cfinvokeargument name="selectId" value="eventDate.#datePublicId#.#dateBlock.itr.type#.time.hour">
					<cfinvokeargument name="selected" value="#dateBlock.dateStruct[dateBlock.itr.type].time.hour#">
				</cfinvoke>
				#hourSelect#
				<cfinvoke method="timeSelect" component="#APPLICATION.timeObj#" returnvariable="minuteSelect">
					<cfinvokeargument name="selectType" value="minute">
					<cfinvokeargument name="selectName" value="eventDate.#datePublicId#.#dateBlock.itr.type#.time.minute">
					<cfinvokeargument name="selectId" value="eventDate.#datePublicId#.#dateBlock.itr.type#.time.minute">
					<cfinvokeargument name="selected" value="#dateBlock.dateStruct[dateBlock.itr.type].time.minute#">
				</cfinvoke>
				#minuteSelect#
			</td>

			<!--- end row every 2 tds --->
			<cfif not dateBlock.ctr mod 2 or dateBlock.ctr eq arrayLen(dateBlock.dateTypeArray)>
				</tr>
			</cfif>

			<!--- increment the counter --->
			<cfset dateBlock.ctr = dateBlock.ctr + 1>
		</cfloop>
		<tr>
			<td>
				Date/Time notes:
			</td>
			<td colspan="3">
				<cfinput type="text" name="eventDate.#datePublicId#.eventDateConfig.dateNote" value="#dateBlock.dateStruct.eventDateConfig.dateNote#" size="140">
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<strong>Recurrence</strong>
			</td>
			<td>
				<cfselect name="eventDate.#datePublicId#.eventDateConfig.repeatConfig.repeatType" id="eventDate.#datePublicId#.eventDateConfig.repeatConfig.repeatType"
					onChange="setPageRedrawValue('true');form.submit();">
					<option value=""<cfif not len(trim(dateBlock.recurrence))> selected</cfif>>None</option>
					<option value="week"<cfif dateBlock.recurrence eq "week"> selected</cfif>>Weekly</option>
				</cfselect>
			</td>
		</tr>

		<!--- loop through the date fields --->
		<cfloop array="#recurrenceDateBlock.dateTypeArray#" index="recurrenceDateBlock.itr">

			<cfif len(trim(dateBlock.recurrence))>

				<cfset recurrenceDateBlock.dateError = false>

				<!--- new row every two tds --->
				<cfif recurrenceDateBlock.ctr mod 2>
					<tr>
				</cfif>

				<td valign="top">

					<!--- check for error on this eventDate part --->
					<cfif structKeyExists(caller.eventDateErrors, datePublicId)
							and caller.eventDateErrors[datePublicId].isInError("#recurrenceDateBlock.itr.type#")
							and formSubmitted neq "">
						<cfset recurrenceDateBlock.dateError = true>
					</cfif>

					<div #iif(recurrenceDateBlock.dateError, DE("class=""red"""), "")#>
						#recurrenceDateBlock.itr.name#:
					</div>
				</td>
				<td>
					<!--- this creates the date field for this eventDate --->
					<cfinput id="eventDate.#datePublicId#.#recurrenceDateBlock.itr.type#"
							name="eventDate.#datePublicId#.#recurrenceDateBlock.itr.type#"
							value="#dateFormat(dateBlock.dateStruct[recurrenceDateBlock.itr.type], "yyyy-mm-dd")#"
							type="datefield">
				</td>

				<!--- end row every 2 tds --->
				<cfif not recurrenceDateBlock.ctr mod 2 or recurrenceDateBlock.ctr eq arrayLen(recurrenceDateBlock.dateTypeArray)>
					</tr>
				</cfif>

				<!--- increment the counter --->
				<cfset recurrenceDateBlock.ctr = recurrenceDateBlock.ctr + 1>
			<cfelse>
				<cfinput	id="eventDate.#datePublicId#.#recurrenceDateBlock.itr.type#"
							name="eventDate.#datePublicId#.#recurrenceDateBlock.itr.type#"
							value="#dateBlock.dateStruct[recurrenceDateBlock.itr.type]#"
							type="hidden">

				<cfset recurrenceDateBlock.ctr = recurrenceDateBlock.ctr + 1>
			</cfif>
		</cfloop>
		<tr>
			<td colspan="4">
				<div class="RuleDotted1"></div>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfoutput>