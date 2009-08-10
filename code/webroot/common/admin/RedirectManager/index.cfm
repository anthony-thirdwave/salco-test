<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Redirect Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Redirect Manager">
	
<!--- create a urlRewrite object --->
<cfobject component="com.utils.UrlRewrite" name="urlRewriteObj">


<cfparam name="sourceUrl" default="">
<cfparam name="destinationUrl" default="">
<cfparam name="dateStart" default="">
<cfparam name="dateEnd" default="">
<cfparam name="message" default="">

<cfoutput>
	
<script type="text/javascript">
	//clears out the textbox when on focus
	function clearText(boxName)
	{
		var textElement = document.getElementById(boxName);
		textElement.value = '';
	}
	
	//change action and submitted for finalize button - we want finalize confirmation page to show up
	function finalizeActions()
	{
		document.urlForm.action.value = 'finalize';
		document.urlForm.submitted.value = '0';
		document.urlForm.submit();
	}
</script>

<table>
	<tr>
		<td>
			<cfform name="urlForm" id="urlForm" action="/common/admin/RedirectManager/edit.cfm" method="post">
				<table cellspacing="0px" cellpadding="3px">
					<tr>
						<td>
							<table cellspacing="0px" cellpadding="3px">
								<tr>
									<th><strong>Source Url</strong></th>
									<th><strong>Destination Url</strong></th>
									<th><strong>Start Date</strong></th>
									<th><strong>End Date</strong></th>
								</tr>
							
								<tr bgcolor="##666666">
									<td>
										<input type="text" name="sourceUrl" id="sourceUrl" value="#sourceUrl#" size="50" />
									</td>
									<td>
										<input type="text" name="destinationUrl" id="destinationUrl" value="#destinationUrl#" size="50" />
									</td>
									<td>
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
									<td colspan="2" align="left">	
										<input name="submitted" type="hidden" value="1" />
										<input name="action" type="hidden" value="add" />
										<input name="submit" type="submit" value="Add Redirect" />
									</td>
									<td colspan="2" align="right">
										<input name="Finalize" type="submit" value="Finalize Redirects" onClick="finalizeActions()" />
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td colspan="4">
										<!--- display the urls in a cfgrid tag - this is bound both to the cfgrid
										controls and the form controls above --->
										<cfgrid format="html" name="rewriteGrid" gridLines="yes"
												selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
												appendKey="true"
												bind="cfc:com.utils.UrlRewrite.getRewrites({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn}, 
													{cfgridsortdirection}, 'htaccess', {sourceUrl@keyup}, {destinationUrl@keyup}, 
													{dateStart@change}, {dateEnd@change})">
											<cfgridcolumn name="rewriteUrlPublicId" display="no" />
											<cfgridcolumn name="sourceUrl" header="Source Url" width="285" />
											<cfgridcolumn name="destinationUrl" header="Destination Url" width="292" />
											<cfgridcolumn name="dateStart" header="Start Date" width="113" />
											<cfgridcolumn name="dateEnd" header="End Date" width="113" />
											<cfgridcolumn name="editUrl" header="Edit" width="38" href="/common/admin/RedirectManager/edit.cfm?action=edit" hrefKey="rewriteUrlPublicId"/>
											<cfgridcolumn name="deleteUrl" header="Delete" width="50" href="/common/admin/RedirectManager/edit.cfm?action=delete" hrefKey="rewriteUrlPublicId"/>
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