<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="Event Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Event Manager">

<script type="text/javascript">
	setPageRedrawValue = function(value){

		// set the value of this hidden input
		document.getElementById('pageRedraw').value = value;
	}
</script>

<!--- reset this value - may get changed by javascript --->
<cfset pageRedraw = false>

<!--- the parameters for event are initialized by the values of the event object --->
<cfoutput>
<p class="SubTitle">
	<cfif PageAction is "add">
	<b>New Event</b>
	<cfelseif listFindNoCase("edit,addDate", PageAction)>
	<b>Update Event</b>
	</cfif>
</p>

<cfif formSubmitted neq "">

	<cfif not thisEvent.eventObj.isCorrect() or not structIsEmpty(eventDateErrors)>
		<br>
		<div class="red">
			<b>

			<!--- event errors --->
			<cfif not thisEvent.eventObj.isCorrect()>
				<!--- loop through the errorStruct to display properties in error --->
				<cfloop collection="#thisEvent.eventObj.error.errorStruct#" item="itr">
					-- #thisEvent.eventObj.error.errorStruct[itr].message#<br>
				</cfloop>
				<br>
			</cfif>

			<!--- event date errors --->
			<cfif not structIsEmpty(eventDateErrors)>
				Event Date Errors:<br>
				<cfloop collection="#eventDateErrors#" item="ede">
					<!--- loop through each date's errorStruct to display properties in error --->
					<cfloop collection="#eventDateErrors[ede].error.errorStruct#" item="inr">
						-- #eventDateErrors[ede].error.errorStruct[inr].message#<br>
					</cfloop>
					<br>
				</cfloop>
			</cfif>
			</b>
		</div>
	</cfif>
</cfif>
<cfform name="EventModifyForm" action="#cgi.request_uri#?#cgi.query_string#" id="EventModifyForm" enctype="multipart/form-data" method="post">


	<div class="box1">
		<div class="boxtop1"><div></div></div>
		<div class="ModuleTitle1">Event Information</div></div>
	<div class="ModuleBody1">
	<table border="0" cellspacing="1" cellpadding="1" width="100%"<cfif structKeyExists(form.event, "disable") or (structKeyExists(form.event, "dateDisabled") and isDate(form.event.dateDisabled))> class="red"</cfif>>
		<tr>
			<td>
				Disabled?
			</td>
			<td>
				<cfinput type="checkbox" name="event.disable" value="true" checked="#structKeyExists(form.event, "disable") or (structKeyExists(form.event, "dateDisabled") and isDate(form.event.dateDisabled))#">
			</td>
		</tr>
		<tr>
			<td>
				<!--- if this is inError, display the red background --->
				<div #iif(formSubmitted neq "" and thisEvent.eventObj.isInError("eventTitle"), DE("class=""red"""), "")#>
					* Event Title:
				</div>
			</td>
			<td>
				<cfinput type="text" name="event.eventTitle" value="#form.event.eventTitle#" size="63">
			</td>
		</tr>
		<tr valign="top">
			<td>
				<!--- if this is inError, display the red background --->
				<div #iif(formSubmitted neq "" and thisEvent.eventObj.isInError("event.eventConfig.description"), DE("class=""red"""), "")#>
					Event Description:
				</div>
			</td>
			<td>
				<cfmodule template="/common/modules/utils/fckeditor.cfm"
					fieldname="event.eventConfig.description"
					fileURL="/resources/events/"
					height="400" width="800"
					Content="#form.event.eventConfig.description#">
			</td>
		</tr>
    </table>
    </div>

    <br />
	<cfinput type="hidden" name="event.eventConfig.visibility" value="everyScope">
	<cfinput type="hidden" name="event.eventConfig.eventType" value="overview">
	<cfinput type="hidden" name="eventPublicId" value="#eventPublicId#">
	<cfinput type="hidden" name="formSubmitted" value="true">
	<cfinput type="hidden" name="pageRedraw" value="#pageRedraw#" id="pageRedraw">

	<div class="box1">
		<div class="boxtop1"><div></div></div>
		<div class="ModuleTitle1">Event Dates</div>
    </div>
	<div class="ModuleBody1">
	<table border="0" cellspacing="1" cellpadding="1" width="100%">
		<tr>
			<td colspan="2">
				 <a href="/common/admin/EventManager/eventModify.cfm?pageAction=addDate&eventPublicId=#eventPublicId#" class="largeLink">+ Add A Date</a>
				<div class="RuleDotted1"></div>
			</td>
		</tr>

		<!--- else, display the added dates --->
		<cfif thisEvent.dates.recordcount>
			<!--- loop through the dates --->
			<cfloop query="thisEvent.dates">
				<cfset config = xmlParse(thisEvent.dates.eventDateConfig)>

				<cfif config.eventDateConfig.dateType.xmlText eq "event">
					<tr>
						<td colspan="2">
							<cfmodule template="/common/admin/EventManager/displayDateBlock.cfm" datePublicId="#thisEvent.dates.publicId#">
						</td>
					</tr>
				</cfif>
			</cfloop>
		</cfif>

		<!--- if there are no dates associated with this event or we're adding an event --->
		<cfif not thisEvent.dates.recordcount or pageAction eq "addDate">

			<!--- display the date fields for a new eventDate --->
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<cfmodule template="/common/admin/EventManager/displayDateBlock.cfm" datePublicId="newEvent">
				</td>
			</tr>
		</cfif>

		<tr valign="top">
			<td>
				<div>
					Topics:
				</div>
			</td>
			<td>
				<!--- get the topic hierarchy and display in a multi-select --->
				<cfinvoke component="com.Taxonomy.TopicHandler" method="GetTopicQuery" returnvariable="allTopics">
				<cfset TopicList="">
				<cfloop query="allTopics">
					<cfset TopicList=ListAppend(TopicList,"{#allTopics.TopicID#|" & RepeatString("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", allTopics.DisplayLevel-3) & "-#allTopics.TopicName#}","^^")>
				</cfloop>

				<select name="topics" multiple size="#allTopics.RecordCount#">
					<cfloop index="i" list="#TopicList#" delimiters="}^^{"><option value="#GetToken(i,1,'|')#" <cfif ListFindNoCase(topics,GetToken(i,1,'|'))>selected</cfif>>#GetToken(i,2,'|')#</option></cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input name="submit" value="submit" type="image" src="/common/images/admin/button_save.png">
			</td>
		</tr>
	</table>
</cfform>
</div>
</cfoutput>
</cfmodule>