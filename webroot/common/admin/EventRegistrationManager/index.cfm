
<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="Event Registration Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Event Registration Manager">



<cfparam name="eventTitle" default="">
<cfparam name="dateStart" default="#dateFormat(now(), "mm/dd/yyyy")#">
<cfparam name="dateEnd" default="">
<cfparam name="status" default="">

<script type="text/javascript">

	//clears out the textbox when on focus
	function clearText(boxName)
	{
		var textElement = document.getElementById(boxName);
		textElement.value = '';
		ColdFusion.Grid.refresh('showRegistrations', true);
	}
</script>

<cfoutput>
<table width="100%">
	<tr>
		<td>

			<cfform action="#CGI.SCRIPT_NAME#" method="post" name="eventForm">
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
								<th>&nbsp;</th>
								<th>Event Title</th>
								<th>Start Date</th>
								<th>End Date</th>
							</tr>
							<tr bgcolor="##666666">
								<td>
									<font color="##FFFFFF"><strong>Search By:</strong></font>
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
							</tr>
							<tr>
								<td colspan="4">
									<table width="100%" cellspacing="0px" cellpadding="3px">
										<tr>
											<td align="left">
												<h2>Results</h2>
											</td>
										</tr>
									</table>
								</td>
							</tr>

							<tr>
								<td colspan="4">
									<!--- display the events in a cfgrid tag - this is bound both to the cfgrid
									controls and the form controls above --->
									<cfgrid format="html" name="showRegistrations" gridLines="yes"
											selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
											appendKey="true"
											bind="cfc:com.event.EventRegistration.getEventDatesWithRegistrants({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn},
												{cfgridsortdirection}, {eventTitle@keyup}, {dateStart@change}, {dateEnd@change})">
										<cfgridcolumn name="publicId" display="no" />
										<cfgridcolumn name="eventTitle" header="Event Title" width="200" />
										<cfgridcolumn name="dateStart" header="Start Date" width="100" />
										<cfgridcolumn name="dateEnd" header="End Date" width="100" />
										<cfgridcolumn name="registrants" header="Registrants" width="150" />
										<cfgridcolumn name="edit" header="" width="24" href="/common/admin/EventRegistrationManager/registrationModify.cfm?pageAction=edit" hrefKey="publicId" />
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