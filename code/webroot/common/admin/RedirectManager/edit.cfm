<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Redirect Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Redirect Manager">
	
<!--- create a urlRewrite object --->
<cfobject component="com.utils.UrlRewrite" name="urlRewriteObj">


<cfparam name="sourceUrl" default="">
<cfparam name="destinationUrl" default="">
<cfparam name="dateStart" default="">
<cfparam name="dateEnd" default="">
<cfparam name="finalize" default="">
<cfparam name="pushLive" default="">
<cfparam name="message" default="">
<cfparam name="submitted" default="0">
<cfparam name="pushed" default="0">
<cfparam name="validated" default="0">
<cfparam name="action" default="">
<cfparam name="urlId" default="">

<script type="text/javascript">
	//clears out the textbox when on focus
	function clearText(boxName)
	{
		var textElement = document.getElementById(boxName);
		textElement.value = '';
	}

</script>


<cfif isDefined("cfgridkey")>
	<cfset urlId = cfgridkey />
</cfif>

<!--- create the .htaccess file --->
<cfif trim(action) eq "finalize">

	<!--- if the form is submitted --->
	<cfif submitted eq 1 and message eq "" and pushLive eq "">
	
		<!--- create the .htaccess file --->
		<cfinvoke method="createHtaccess" component="#urlRewriteObj#" returnvariable="redirectsFinalized" />
	
		<!--- createHtaccess returns a boolean --->
		<cfif redirectsFinalized>
			<cfset message = "The redirects have been finalized. Do you want to push the redirects live?" />
		<cfelse>
			<cfset message = "Error finalizing redirects." />
		</cfif>
		
		<cfset validated = 1 />
		<cfset pushLive = "true" />
		<cfset action = "pushLive" />
	<cfelse>
		<cfset message = "Are you sure you want to finalize the redirects?" />
	</cfif>
</cfif>


<!--- push the file live --->
<cfif trim(action) eq "pushLive">

	<!--- if the form is submitted --->
	<cfif pushed eq 1 and message eq "">
	
		<!--- create the .htaccess file --->
		<cfinvoke method="pushHtaccessLive" component="#urlRewriteObj#" returnvariable="pushedLive" />
	
		<!--- if this was successful  --->
		<cfif pushedLive.success>
			<cfset message = "The file has been pushed live." />
		<cfelse>
			<cfset message = pushedLive.errorText />
		</cfif>
		
		<cfset validated = 1 />
	</cfif>
</cfif>


<!--- get the rewrite type, only one for this implementation --->
<cfinvoke method="getRewriteType" component="#urlRewriteObj#" returnvariable="theRewriteType">
	<cfinvokeargument name="alias" value="simple">
</cfinvoke>


<!--- if there's a record to edit/delete --->
<cfif trim(action) eq "delete" or trim(action) eq "edit">
	<cfinvoke method="getRewrite" component="#urlRewriteObj#" returnvariable="getRewrite">
		<cfinvokeargument name="publicId" value="#trim(urlId)#">
	</cfinvoke>
	
	<cfif getRewrite.recordcount neq 1>
		<cfset message = "There is no matching record." />
	</cfif>
</cfif>

<!--- delete a rewrite --->
<cfif trim(action) eq "delete">

	<!--- if the form is submitted --->
	<cfif submitted eq 1 and message eq "">
		<cfinvoke method="deleteRewrite" component="#urlRewriteObj#" returnvariable="deletedRewrite">
			<cfinvokeargument name="publicId" value="#trim(urlId)#">
		</cfinvoke>
	
		<cfset message = deletedRewrite.message />
		<cfset validated = 1 />
	<cfelse>
		<cfset message = "Are you sure you want to delete the url redirect below?" />
	</cfif>
</cfif>

<!--- edit a rewrite --->
<cfif trim(action) eq "edit">
	
	<!--- if the form is submitted --->
	<cfif submitted eq 1 and message eq "">
		<cfinvoke method="updateRewrite" component="#urlRewriteObj#" returnvariable="editedRewrite">
			<cfinvokeargument name="rewriteUrlPublicId" value="#trim(urlId)#">
			<cfinvokeargument name="sourceUrl" value="#trim(sourceUrl)#">
			<cfinvokeargument name="destinationUrl" value="#trim(destinationUrl)#">
			<cfinvokeargument name="dateStart" value="#trim(dateStart)#">
			<cfinvokeargument name="dateEnd" value="#trim(dateEnd)#">
			<cfinvokeargument name="rewriteTypePublicId" value="#trim(getRewrite.rewriteTypePublicId)#">
		</cfinvoke>
	
		<cfset message = editedRewrite.message />
		
		<cfif message eq "">
			<cfset message = "The url redirect was successfully edited." />
			<cfset validated = 1 />
		</cfif>	
	</cfif>
</cfif>


<!--- add a rewrite --->
<cfif trim(action) eq "add">
	
	<!--- if the form is submitted --->
	<cfif submitted eq 1 and message eq "" and sourceUrl neq "">
		
		<cfinvoke method="addRewrite" component="#urlRewriteObj#" returnvariable="addedRewrite">
			<cfinvokeargument name="sourceUrl" value="#trim(sourceUrl)#">
			<cfinvokeargument name="destinationUrl" value="#trim(destinationUrl)#">
			<cfinvokeargument name="dateStart" value="#trim(dateStart)#">
			<cfinvokeargument name="dateEnd" value="#trim(dateEnd)#">
			<cfinvokeargument name="rewriteTypePublicId" value="#trim(theRewriteType.publicId)#">
		</cfinvoke>
	
		<cfset message = addedRewrite.message />
		
		<cfif message eq "">
			<cfset message = "The url redirect was successfully added." />
			<cfset validated = 1 />
		</cfif>	
	</cfif>
</cfif>

<cfoutput>

<table width="100%">
	<cfif trim(message) neq "">
		<tr>
			<td>
				<span style="color:##ff0000">#message#</span>
			</td>
		</tr>
		
		<cfif validated>

			<!--- if this was an add, give the option for another add --->
			<cfif trim(action) eq "add">
				<tr>
					<td>
						<a href="/common/admin/RedirectManager/edit.cfm?action=add">Add Another Url Redirect</a>
					</td>
				</tr>
			</cfif>

			<tr>
				<td>
					<a href="/common/admin/RedirectManager/index.cfm">Return to Redirect Manager</a>
				</td>
			</tr>
			
			<!--- if this is finalized, the option to push the page live should show up --->
			<cfif trim(pushLive) eq "" or trim(pushed) eq 1>
				<!--- stop drawing the page here --->
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- display the rules for this rewriteType ---->
	<cfif theRewriteType.recordcount eq 1 and (trim(action) eq "edit" or trim(action) eq "add")>
		<tr>
			<td>
				<p>
				<strong>#theRewriteType.name#: </strong>
				#theRewriteType.description#</p>
				The following rules apply:<br />
				<ul>
					<cfif theRewriteType.allowSource>
						<li>The source url is allowed<cfif theRewriteType.sourceNotNull> and required</cfif></li>
					</cfif>
					<cfif theRewriteType.sourceMustBeUnique>
						<li>The source url must be unique</li>
					</cfif>
					<cfif theRewriteType.sourceIsPath>
						<li>The source url must start with a "/"</li>
					</cfif>
					<br>
					<cfif theRewriteType.allowDestination>
						<li>The destination url is allowed<cfif theRewriteType.destinationNotNull> and required</cfif></li>
					</cfif>
					<cfif theRewriteType.destinationMustBeUnique>
						<li>The destination url must be unique</li>
					</cfif>
					<cfif theRewriteType.destinationIsPath>
						<li>The destination url must start with a "/"</li>
					</cfif>
				</ul>
			</td>
		</tr>
	</cfif>
	<tr>
		<td>
			<cfform name="bindingForm" id="urlForm" action="#cgi.request_uri#" method="post">

				<!--- keep the action --->
				<input type="hidden" name="action" value="#action#">
				<table cellspacing="0px" cellpadding="0px">
					<tr>
						<td>
							<table cellspacing="0px" cellpadding="0px" bgcolor="white">
								
								<cfif trim(action) neq "finalize" and trim(pushLive) eq "">
								<tr bgcolor="##F1F2E8">
									<th><strong>Source Url</strong></th>
									<th><strong>Destination Url</strong></th>
									<th><strong>Start Date</strong></th>
									<th><strong>End Date</strong></th>
									<td valign="top" align="center" nowrap>&nbsp;</td>
								</tr>
								</cfif>
							
								<!--- depending on what type of page this is, take different actions --->
								<cfif trim(action) eq "edit" and trim(urlId) neq "">
									
									<tr bgcolor="##666666">
										<td class="padded">
											<input type="text" name="sourceUrl" id="sourceUrl" value="#getRewrite.sourceUrl#" size="50" />
										</td>
										<td class="padded">
											<input type="text" name="destinationUrl" id="destinationUrl" value="#getRewrite.destinationUrl#" size="50" />
										</td>
										<td class="padded">
											<cfinput id="dateStart" 
											name="dateStart" 
											value="#trim(dateFormat(getRewrite.dateStart, 'mm/dd/yyyy'))#"
											type="datefield"
											onclick="clearText(this.name);">
										</td>
										<td class="padded">
											<cfinput id="dateEnd" 
											name="dateEnd" 
											value="#trim(dateFormat(getRewrite.dateEnd, 'mm/dd/yyyy'))#"
											type="datefield"
											onclick="clearText(this.name);">
										</td>
										<td class="padded">
											<input type="hidden" name="urlId" value="#urlId#">
											<input name="edit" type="submit" value="edit" />
										</td>
									</tr>
								<cfelseif trim(action) eq "delete" and trim(urlId) neq "">
									<tr>
										<td width="285" class="paddedLikeSearch">
											#getRewrite.sourceUrl#					
										</td>
										<td width="285" class="paddedLikeSearch">
											#getRewrite.destinationUrl#
										</td>

										<td width="150" class="paddedLikeSearch">
											<cfif isDate(getRewrite.dateStart)>
												#dateFormat(getRewrite.dateStart, "mm/dd/yyyy")#
											<cfelse>
												&nbsp;
											</cfif>
										</td>

										<td width="150" class="paddedLikeSearch">
											<cfif isDate(getRewrite.dateEnd)>
												#dateFormat(getRewrite.dateEnd, "mm/dd/yyyy")#
											<cfelse>
												&nbsp;
											</cfif>
										</td>

										<td class="paddedLikeSearch">
											<input type="hidden" name="urlId" value="#urlId#">
											<input name="delete" type="submit" value="delete" />
										</td>
									</tr>
									
									
								<cfelseif trim(action) eq "add">
									<tr bgcolor="##666666">
										<td class="padded">
											<input type="text" name="sourceUrl" id="sourceUrl" value="#sourceUrl#" size="50" />
										</td>
										<td class="padded">
											<input type="text" name="destinationUrl" id="destinationUrl" value="#destinationUrl#" size="50" />
										</td>
										<td class="padded">
											<cfinput id="dateStart" 
											name="dateStart" 
											value="#trim(dateFormat(dateStart, 'mm/dd/yyyy'))#"
											type="datefield"
											onclick="clearText(this.name);">
										</td>
										<td class="padded">
											<cfinput id="dateEnd" 
											name="dateEnd" 
											value="#trim(dateFormat(dateEnd, 'mm/dd/yyyy'))#"
											type="datefield"
											onclick="clearText(this.name);">
										</td>
										<td class="padded">
											<input name="add" type="submit" value="Add Redirect" />
										</td>
									</tr>
								<cfelseif trim(action) eq "finalize">
									<tr>
										<td>
											<input type="hidden" name="finalize" value="true">
											<input name="finalize" type="submit" value="finalize" />
										</td>
									</tr>
								<cfelseif trim(action) eq "pushLive">
									<tr>
										<td>
											<input type="hidden" name="pushed" value="1">
											<input name="Push Live" type="submit" value="Push Live" />
										</td>
									</tr>
								</cfif>
							</table>
						</td>
					</tr>
				</table>
				<input type="hidden" name="submitted" value="1">
			</cfform>
		</td>
	</tr>
</table>
</cfoutput>