<cfparam name="ATTRIBUTES.ThankYouPage" default="/page/thank-you">
<cfparam name="formsubmit" default="0">
<cfparam name="showform" default="1">
<cfparam name="LabelTo" default="">
<cfparam name="FormAction" default="#CGI.REQUEST_URI#?#CGI.QUERY_STRING#">
<cfparam name="form.email" default="">
<cfparam name="form.To" default="">
<cfset LabelTo="Customer Service">

<cfset Mailer_ToAddress="sales@salcoproducts.com">
<cfset Mailer_FromAddress="noreply@salcoproducts.com">

<cfset ErrorMessage="">

<cfset lSubject="Hopper Cars,Intermodal Containers,Rail/Yard Accessories,Tank Cars,Other">

<!---  set params ----> 
<cfset RequiredFormFieldList="firstName,lastName,emai,message,company,subject,phone">
<cfset NonRequiredFormFieldList="address2">
<cfloop index="i" list="#RequiredFormFieldList#">
	<cfparam name="form.#i#" default="">
</cfloop>
<cfloop index="i" list="#NonRequiredFormFieldList#">
	<cfparam name="form.#i#" default="">
</cfloop>
<cfparam name="FORM.method" default="email">

<cfif IsDefined("ATTRIBUTES.sContact") and isStruct(ATTRIBUTES.sContact) and isDefined("contact")>
	<cfif StructKeyExists(ATTRIBUTES.sContact,contact)>
		<cfset Mailer_ToAddress=ATTRIBUTES.sContact[contact]>
		<cfset LabelTo=HTMLEditFormat(Replace(contact,"_"," ","All"))>
	</cfif>
</cfif>

<cfset Mailer_Subject="Contact Form Submission: #form.Firstname# #form.LastName#">
<cfif APPLICATION.Production>
<cfelse>
	<cfset Mailer_Subject="#Mailer_Subject# TESTING ONLY!">
	<cfif 1>
		<cfset Mailer_ToAddress="thomas@newermedia.com">
	</cfif>
</cfif>

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
		<cflocation url="#ATTRIBUTES.ThankYouPage#" addtoken="No">
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
			<cfif LabelTo IS NOT "">
				<div class="formRow">
					<label>To</label>
					<strong>#LabelTo#</strong>
				</div>
			</cfif>
			<div class="formRow">
				<label for="subject">Subject</label>
				<select name="subject">
					<option value="">Select...</option>
				<cfloop index="ThisSubject" list="#lSubject#">
					<option value="#ThisSubject#"<cfif subject IS ThisSubject> selected</cfif>>#ThisSubject#</option>
				</cfloop>
				</select>
			</div>
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(firstName)) eq 0> errorTxt</cfif>">
				<label for="firstName">First Name *</label>
				<cfinput name="firstName" id="firstName" maxlength="50" type="text" value="#form.firstName#" />
			</div>
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(lastName)) eq 0> errorTxt</cfif>">
				<label for="lastName">Last Name *</label>
				<cfinput name="lastName" id="lastName" maxlength="50" type="text" value="#form.lastName#" />
			</div>
			<div class="formRow">
				<label for="company">Company</label>
				<cfinput name="company" id="company" maxlength="50" type="text" value="#form.company#" />
			</div>
			<div class="formRow">
				<label for="Phone">Phone Number *</label>
				<cfinput name="Phone" id="Phone" maxlength="20" type="text" value="#form.Phone#" />
			</div>
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(email)) eq 0> errorTxt</cfif>">
				<label for="emai">Email *</label>
				<cfinput name="emai" id="emai" maxlength="50" type="text" value="#form.emai#" />
			</div>
			<div class="formRow">
				<label for="state">Preferred method of contact</label>
				<input type="radio" name="method" value="email"<cfif method IS NOT "Phone"> checked</cfif>> Email 
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="method" value="phone"<cfif method IS "Phone"> checked</cfif>> Phone<br>
			</div>
			<div class="formRow memo<cfif formsubmit EQ 1 and len(trim(email)) eq 0> errorTxt</cfif>">
				<label for="message">Message *</label>
				<cftextarea name="message">#FORM.message#</cftextarea>
			</div>
			
			<!--- ==================================================== --->
			
			<div class="formRow submit rightSubmit">
				<input type="submit" name="submit" value="" title=" Send Inquiry " />
			</div>
			<p>Note that * indicates a required field.</p>
		</cfform>
	</cfoutput>
</cfif>

