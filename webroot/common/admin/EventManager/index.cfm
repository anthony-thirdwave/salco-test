
<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="Event Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Event Manager">

<cfparam name="eventTitle" default="">
<cfparam name="dateStart" default="">
<cfparam name="dateEnd" default="">
<cfparam name="status" default="1">

<script type="text/javascript">

	//clears out the textbox when on focus
	function clearText(boxName)
	{
		var textElement = document.getElementById(boxName);
		textElement.value = '';
		ColdFusion.Grid.refresh('showEvents', true);
	}
</script>

<cfoutput>
<table width="100%">
	<tr>
		<td>

			<cfform action="/common/admin/EventManager/eventModify.cfm.cfm?pageAction=add" method="post" name="eventForm">
			<table>

				<cfif isDefined("message") and len(trim(message))>
					<tr>
						<td>
							<cfswitch expression="#trim(message)#">
								<cfcase value="pushLive">
									<h3>The event was successfully pushed to production.</h3>
								</cfcase>
								<cfcase value="edit">
									<h3>The event was successfully edited.</h3>
								</cfcase>
								<cfcase value="add">
									<h3>The event was successfully added.</h3>
								</cfcase>
							</cfswitch>
						</td>
					</tr>
				</cfif>

				<tr>
					<td>
						<table cellspacing="0px" cellpadding="3px">
							<tr>
								<td>
									<table cellpadding="5px" cellspacing="5px" >
										<tr>
											<th>&nbsp;</th>
											<th>Event Title</th>
											<th>Start Date</th>
											<th>End Date</th>
											<th>Status</th>
										</tr>
										<tr>
											<td>
												<strong>Search By:</strong>
											</td>
											<td>
												<cfinput type="text" name="eventTitle" value="#eventTitle#">
											</td>
											<td>
												<!--- this creates the date field for this eventDate --->
												<cfinput id="dateStart"
													name="dateStart"
													value="#dateStart#"
													type="datefield"
													onclick="clearText(this.name);">
											</td>
											<td>
												<cfinput id="dateEnd"
													name="dateEnd"
													value="#dateEnd#"
													type="datefield"
													onclick="clearText(this.name);">
											</td>
											<td>
												<cfselect name="status">
													<option value="" <cfif len(status) eq 0>selected</cfif>>All Events</option>
													<option value="1" <cfif status eq 1>selected</cfif>>Currrent / Future Events</option>
													<option value="2" <cfif status eq 2>selected</cfif>>Past Events</option>
													<option value="3" <cfif status eq 3>selected</cfif>>Disabled Events</option>
												</cfselect>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<tr>
								<td height="20">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="4">
									<table width="100%" cellspacing="0px" cellpadding="3px">
										<tr>
											<td align="left">
												<h2>Results</h2>
											</td>
										</tr>
										<tr>
											<td align="right">
												<a href="/common/admin/EventManager/EventModify.cfm?pageAction=add" class="largeLink">+ Add New Event</a>
											</td>
										</tr>
									</table>
								</td>
							</tr>

							<tr>
								<td colspan="4">
									<!--- display the events in a cfgrid tag - this is bound both to the cfgrid
									controls and the form controls above --->
									<cfgrid format="html" name="showEvents" gridLines="yes"
											selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
											appendKey="true" width="900" hSpace="0"
											bind="cfc:com.event.EventHandler.getEventsAdmin({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn},
												{cfgridsortdirection}, {eventTitle@keyup}, {dateStart@change}, {dateEnd@change}, {status@change})">
										<cfgridcolumn name="publicId" display="no" />
										<cfgridcolumn name="eventTitle" header="Event Title" width="300" />
										<cfgridcolumn name="dateStart" header="Start Date" width="100" />
										<cfgridcolumn name="dateEnd" header="End Date" width="100" />
										<cfgridcolumn name="status" header="Status" width="180" />
										<cfgridcolumn name="delUser" header="Disable/Enable" width="100" href="/common/admin/EventManager/eventModify.cfm?pageAction=delete" hrefKey="publicID"/>
										<cfgridcolumn name="edit" header="Edit" width="50" href="/common/admin/EventManager/eventModify.cfm?pageAction=edit" hrefKey="publicID" />
									</cfgrid>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
</table>
</cfoutput>

</cfmodule>