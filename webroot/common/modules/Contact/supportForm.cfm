<cfparam name="formsubmit" default="0">
<cfparam name="showform" default="1">
<cfparam name="FormAction" default="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
<cfparam name="form.email" default="">
<cfif APPLICATION.Production>
	<cfset Mailer_ToAddress="sales@salcoproducts.com">
<cfelse>
	<cfset Mailer_ToAddress="thomas@newermedia.com">
</cfif>
<cfset Mailer_FromAddress="noreply@salcoproducts.com">

<cfset ErrorMessage="">

<!---  set params ----> 
<cfset ReqiredformFiledList="emai,message,phone">
<cfset NonReqiredformFiledList="firstName,lastName,CompanyName">
<cfloop index="i" list="#ReqiredformFiledList#">
	<cfparam name="form.#i#" default="">
</cfloop>
<cfloop index="i" list="#NonReqiredformFiledList#">
	<cfparam name="form.#i#" default="">
</cfloop>
<cfparam name="FORM.method" default="email">

<cfif formsubmit EQ 1>
	<cfinclude template="actSupportForm.cfm">
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
			<div class="formRow">
				<label for="firstName">First Name</label>
				<cfinput name="firstName" id="firstName" maxlength="50" type="text" value="#form.firstName#" />
			</div>
			<div class="formRow">
				<label for="lastName">Last Name</label>
				<cfinput name="lastName" id="lastName" maxlength="50" type="text" value="#form.lastName#" />
			</div>
			<div class="formRow">
				<label for="CompanyName">Company</label>
				<cfinput name="CompanyName" id="CompanyName" maxlength="50" type="text" value="#form.CompanyName#" />
			</div>
			<div class="formRow<cfif formsubmit EQ 1 and len(trim(firstName)) eq 0> errorTxt</cfif>">
				<label for="phone">Phone Number *</label>
				<cfinput name="phone" id="phone" maxlength="50" type="text" value="#form.phone#" />
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
		</cfform>
	</cfoutput>
</cfif>

