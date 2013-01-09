<cfparam name="formSubmitted" default="">
<cfparam name="displayType" default="view">

<cfset errorMessage = "">

<!--- if we're coming here as an edit page, these values were passed in the url --->
<cfif len(trim(formSubmitted))>
	<cfset form = APPLICATION.UtilsObj.formDotNotationToStruct(form) />
	<cfinvoke method="getRegistrants" component="#APPLICATION.eventRegistrationObj#" returnvariable="theRegistrants">
		<cfinvokeargument name="eventRegistrationPublicId" value="#form.theRegistrants.publicId#">
	</cfinvoke>
</cfif>

<!--- if this isn't defined by now, bail to the index page --->
<cfif not isDefined("theRegistrants")>
	<cflocation url="/common/admin/eventRegistrationManager/index.cfm" addtoken="no">
</cfif>

<!--- create the registration object --->
<cfset eventRegistrationObj = createObject("component","com.factory.thirdwave.FactoryObject")>
<cfset eventRegistrationObj.init("EventRegistration")>
<cfset eventRegistrationObj.constructor(theRegistrants.eventRegistrationId)>

<!--- convert this registration object to a struct --->
<cfinvoke method="objectToStruct" component="#APPLICATION.factoryUtilsObj#" returnvariable="registration">
	<cfinvokeargument name="factoryObject" value="#eventRegistrationObj#">
</cfinvoke>

<!--- if we're saving changes to this registrant --->
<cfif len(trim(formSubmitted)) and displayType eq "save">
	<!--- convert any form variables with dot notation into a struct for the eventRegistration object --->
	<cfset form = APPLICATION.UtilsObj.formDotNotationToStruct(form) />

	<cfset eventRegistrationObj.setProperty("Registrants", form.info.registrants)>
	<cfset eventRegistrationObj.setProperty("Snapshot", form)>

	<!--- get the errorMessage from each property --->
	<cfloop collection="#eventRegistrationObj.error.errorStruct#" item="itr">
		<cfif structKeyExists(eventRegistrationObj.error.errorStruct[itr], "message")>
			<cfset errorMessage = errorMessage & eventRegistrationObj.error.errorStruct[itr].message>
		</cfif>
	</cfloop>

	<!--- if everything checks out --->
	<cfif eventRegistrationObj.isCorrect() and not len(trim(errorMessage))>

		<!--- save the registration --->
		<cfset eventRegistrationObj.save()>
		<cfset displayType = "updated">
	</cfif>
<cfelse>

	<!--- add the snapshot structs to the form --->
	<cfloop collection="#registration.snapshot#" item="itr">
		<cfset form[itr] = registration.snapshot[itr]>
	</cfloop>
</cfif>

<cfoutput>
<cfdiv id="div_#theRegistrants.publicId#">

	<cfform name="form_#theRegistrants.publicId#" action="/common/admin/EventRegistrationManager/registrationForm.cfm" id="form_#theRegistrants.publicId#" enctype="multipart/form-data" method="post">
		<input type="hidden" name="formSubmitted" value="true">
	<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<cfif len(trim(errorMessage))>
			<tr>
				<td>
					<span class="errorTxt">Errors<br /></span>
					<ul class="errorTxt">
						#errorMessage#
					</ul>
				</td>
			</tr>
		</cfif>
		<tr>
			<td>
				<cfswitch expression="#displayType#">
					<cfcase value="view">
						<table border="0" cellspacing="0" cellpadding="10" width="100%" style="background-color:##FFF">
							<tr class="tableHead">
								<td width="200">
									<strong>Name</strong>
								</td>
								<td>
									<strong>Contact Info</strong>
								</td>
								<td width="250">
									<strong>Address</strong>
								</td>
								<td width="100">
									<strong>Registrants</strong>
								</td>
								<td width="300">
									<strong>Notes</strong>
								</td>
							</tr>
							<tr>
								<td valign="top" width="200">
									#APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.info.lastName)#, #APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.info.firstName)#<br />
								</td>
								<td valign="top">
									#APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.info.email)#
									<cfif len(trim(registration.snapshot.info.phone))>
										<br />#APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.info.phone)#
									</cfif>
								</td>
								<td valign="top" width="250">
									#APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.address.address1)#<br />
									 #APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.address.city)#, #registration.snapshot.address.stateProvinceID# #APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.address.postalCode)#
								</td>
								<td valign="top" width="100">
									#theRegistrants.registrants#
								</td>
								<td valign="top" width="300">
									#APPLICATION.factoryUtilsObj.xmlUnformat(registration.snapshot.info.notes)#
									<input type="hidden" name="theRegistrants.eventDatePublicId" value="#theRegistrants.eventDatePublicId#">
									<input type="hidden" name="theRegistrants.publicId" value="#theRegistrants.publicId#">
									<input type="hidden" name="displayType" value="edit">
								</td>
							</tr>
                            <tr>
								<td width="300" colspan="5">
                                    <p><a href="javascript:ColdFusion.navigate('/common/admin/EventRegistrationManager/registrationForm.cfm', 'div_#theRegistrants.publicId#', '', '', 'POST', 'form_#theRegistrants.publicId#');">
                                    <img src="/common/images/admin/button_edit.png" width="58" height="19" border="0">
                                    </a></p>
								</td>
                            </tr>
						</table>
					</cfcase>
					<cfcase value="edit,save">

						<div class="ModuleBody1">
						<table border=0 cellspacing=2 cellpadding=2 width="100%">
							<tr>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.info.firstName"), DE("class=""red"""), "")#>
										First Name:
									</div>
								</td>
								<td>
									<cfinput type="text" name="info.firstName" value="#form.info.firstName#" size="30">
								</td>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.info.lastName"), DE("class=""red"""), "")#>
										Last Name:
									</div>
								</td>
								<td>
									<cfinput type="text" name="info.lastName" value="#form.info.lastName#" size="30">
								</td>
								<td align="center" colspan="2">
									<input type="hidden" name="displayType" value="save">
									<input type="hidden" name="theRegistrants.eventDatePublicId" value="#theRegistrants.eventDatePublicId#">
									<input type="hidden" name="theRegistrants.publicId" value="#theRegistrants.publicId#">
								</td>
							</tr>
							<tr>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.info.email"), DE("class=""red"""), "")#>
										Email:
									</div>
								</td>
								<td>
									<cfinput type="text" name="info.email" value="#form.info.email#" size="30">
								</td>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.info.phone"), DE("class=""red"""), "")#>
										Phone:
									</div>
								</td>
								<td>
									<cfinput type="text" name="info.phone" value="#form.info.phone#" size="30">
								</td>
							</tr>
							<tr>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.address.address1"), DE("class=""red"""), "")#>
										Address1:
									</div>
								</td>
								<td>
									<cfinput type="text" name="address.address1" value="#form.address.address1#" size="30">
								</td>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.address.city"), DE("class=""red"""), "")#>
										City:
									</div>
								</td>
								<td>
									<cfinput type="text" name="address.city" value="#form.address.city#" size="30">
								</td>
							</tr>
							<tr>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.address.stateProvinceID"), DE("class=""red"""), "")#>
										State:
									</div>
								</td>
								<td>
									<cfselect 	name="address.stateProvinceId" id="stateProvinceCode" query="APPLICATION.GetStateProvinces" selected="#form.address.stateProvinceId#"
										queryposition="below" value="stateProvinceCode" display="stateProvinceCode">
									</cfselect>
								</td>
								<td>
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.address.postalCode"), DE("class=""red"""), "")#>
										Zip Code:
									</div>
								</td>
								<td>
									<cfinput type="text" name="address.postalCode" value="#form.address.postalCode#" size="30">
								</td>
							</tr>
							<tr>
								<td valign="top">
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.info.registrants"), DE("class=""red"""), "")#>
										Registrants:
									</div>
								</td>
								<td valign="top">
									<cfinput type="text" name="info.registrants" value="#form.info.registrants#" size="30">
								</td>
								<td valign="top">
									<!--- if this is inError, display the red background --->
									<div #iif(len(trim(formSubmitted)) and isDefined("eventRegistrationObj.error.errorStruct.snapshot.info.notes"), DE("class=""red"""), "")#>
										Notes:
									</div>
								</td>
								<td valign="top">
									<cftextarea type="textarea" name="info.notes">
										#form.info.notes#
									</cftextarea>
								</td>
							</tr>
						</table>
						<a href="javascript:ColdFusion.navigate('/common/admin/EventRegistrationManager/registrationForm.cfm', 'div_#theRegistrants.publicId#', '', '', 'POST', 'form_#theRegistrants.publicId#');">
							<img src="/common/images/admin/button_submit.png" width="75" height="19" border="0">
						</a>
                    </div>
					</cfcase>
					<cfcase value="updated">
						<table border=0 cellspacing=2 cellpadding=2 width="100%">
							<tr>
								<td>
									Registrant Updated. Click submit to return to index page.
								</td>
								<td>
									<a href="/common/admin/eventRegistrationManager/index.cfm">
										<img src="/common/images/admin/button_submit.png" width="75" height="19" border="0">
									</a>
								</td>
							</tr>
						</table>
					</cfcase>
				</cfswitch>
			</td>
		</tr>
	</table>
	</cfform>
</cfdiv>
</cfoutput>