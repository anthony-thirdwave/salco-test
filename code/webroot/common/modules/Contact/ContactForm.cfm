<cfparam name="formsubmit" default="0">
<cfparam name="showform" default="1">
<cfparam name="FormAction" default="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
<cfparam name="form.email" default="">
<cfparam name="form.To" default="">

<cfif APPLICATION.Production>
	<cfset Mailer_ToAddress="sales@salcoproducts.com">
<cfelse>
	<cfset Mailer_ToAddress="thomas@newermedia.com">
</cfif>
<cfset Mailer_FromAddress="noreply@salcoproducts.com">

<cfset ErrorMessage="">

<!---  set params ----> 
<cfset ReqiredformFiledList="firstName,lastName,emai,message">
<cfset NonReqiredformFiledList="address1,address2,city,state,zip,country">
<cfloop index="i" list="#ReqiredformFiledList#">
	<cfparam name="form.#i#" default="">
</cfloop>
<cfloop index="i" list="#NonReqiredformFiledList#">
	<cfparam name="form.#i#" default="">
</cfloop>

<cfif formsubmit EQ 1>
	<cfinclude template="actContactForm.cfm">
	<cfif len(trim(ErrorMessage)) gt 0>
		<div class="red">
			<ul>
				<cfoutput>#ErrorMessage#</cfoutput>
			</ul>
		</div>
	<cfelse>
		<cfset showform="0">
		<div class="formSuccess"><b>Your request has been sent.</b> Thank you!<br /><br /> 
	</cfif>
</cfif>

<cfset Location=GetToken(FormAction,1,"?")>
<cfset querystring=GetToken(FormAction,2,"?")>

<cfif showform EQ 1>
	<cfoutput>
		<cfform action="#FormAction#" method="post" name="applicationForm" id="applicationForm" enctype="multipart/form-data">
			<input type="hidden" name="formsubmit" value="1" />
			<input name="email" type="text" class="hpfield" value=""/>
			<!--- ==================================================== --->
			<!--- enter form fields here --->
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(firstName)) eq 0> errorTxt</cfif>">
				<label for="firstName">First Name *</label>
				<cfinput name="firstName" id="firstName" maxlength="50" type="text" value="#form.firstName#" />
			</div>
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(lastName)) eq 0> errorTxt</cfif>">
				<label for="lastName">Last Name *</label>
				<cfinput name="lastName" id="lastName" maxlength="50" type="text" value="#form.lastName#" />
			</div>
			<div class="formRow">
				<label for="address1">Address Line 1</label>
				<cfinput name="address1" id="address1" maxlength="50" type="text" value="#form.address1#" />
			</div>
			<div class="formRow">
				<label for="address2">Address Line 2</label>
				<cfinput name="address2" id="address2" maxlength="50" type="text" value="#form.address2#" />
			</div>
			<div class="formRow">
				<label for="city">City</label>
				<cfinput name="city" id="city" maxlength="20" type="text" value="#form.city#" />
			</div>
			<div class="formRow">
				<label for="state">State</label>
				<cfselect name="state" id="state" query="APPLICATION.GetStateProvinces" selected="#form.state#"
					queryposition="below" value="stateprovinceName" display="stateprovinceName">
					<option value="" selected="selected"></option>
				</cfselect>
			</div>
			<div class="formRow">
				<label for="zip">Zip</label>
				<cfinput name="zip" id="zip" maxlength="20" type="text" value="#form.zip#" />
			</div>
			<div class="formRow">
				<label for="country">Country</label>
				<cfselect name="country" id="country" query="APPLICATION.GetCountries" selected="#form.country#"
						queryposition="below" value="CountryName" display="CountryName">
						<option value="" selected="selected"></option>
				</cfselect>
			</div>
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(email)) eq 0> errorTxt</cfif>">
				<label for="emai">Email *</label>
				<cfinput name="emai" id="emai" maxlength="50" type="text" value="#form.emai#" />
			</div>
			
			<div class="formRow memo<cfif formsubmit EQ 1 and len(trim(email)) eq 0> errorTxt</cfif>">
				<label for="message">Message *</label>
				<cftextarea name="message">#FORM.message#</cftextarea>
			</div>
			
			<!--- ==================================================== --->
			
			<div class="formRow submit">
				<input type="submit" name="submit" value="" title=" Send Inquiry " />
			</div>
		</cfform>
	</cfoutput>
</cfif>

