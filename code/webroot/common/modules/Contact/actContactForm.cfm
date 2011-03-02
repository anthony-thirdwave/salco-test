<cfparam name="ErrorMessage" default="">

<cfif Len(Trim(firstName)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter a value for first name.</li>">
</cfif>
<cfif Len(Trim(lastName)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter a value for last name.</li>">
</cfif>
<cfif Len(Trim(emai)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter a value for email.</li>">
<cfelse>
	<cfmodule name="3w.errorcheck.validateemail" email="#form.emai#">
	<cfif ValidateEmailStatus GTE "200">
		<cfset ErrorMessage= ErrorMessage & "<li>Email entered is not formatted correctly.</li>">
	<cfelse>
		<cfparam name="FORM.Mailer_FromAddress" default="#form.emai#">
	</cfif>
</cfif>

<cfif Len(Trim(email)) GT 0>
	<cfset ErrorMessage=ErrorMessage & "<li>Your request can not be processed.</li>">
</cfif>

<cfif len(trim(ErrorMessage)) EQ 0>
	<cfmail	to="#FORM.Mailer_ToAddress#" from="#FORM.Mailer_FromAddress#"
			type="html" subject="Contact Form Submission: #form.Firstname# #form.LastName#">
	<table>
		<tr>
		<td colspan="2"><b>Contact Form Submission</b><br>
		Submitted #DateFormat(Now())# #TimeFormat(Now())#</td>
	</tr>
	<tr>
		<td><b>First Name:</b></td>
		<td>#form.FirstName#</td>
	</tr>
	<tr>
		<td><b>Last Name:</b></td>
		<td>#form.LastName#</td>
	</tr>
	<cfif len(trim(form.address1))>
	<tr>
		<td><b>Address 1:</b></td>
		<td>#form.address1#</td>
	</tr>
	</cfif>
	<cfif len(trim(form.address2))>
	<tr>
		<td><b>Address 2:</b></td>
		<td>#form.address2#</td>
	</tr>
	</cfif>
	<cfif len(trim(form.city))>
	<tr>
		<td><b>City:</b></td>
		<td>#form.city#</td>
	</tr>
	</cfif>
	<cfif len(trim(form.state))>
	<tr>
		<td><b>State:</b></td>
		<td>#form.state#</td>
	</tr>
	</cfif>
	<cfif len(trim(form.zip))>
	<tr>
		<td><b>Zip / Postal Code:</b></td>
		<td>#form.zip#</td>
	</tr>
	</cfif>
	<cfif len(trim(form.country))>
	<tr>
		<td><b>Country:</b></td>
		<td>#form.country#</td>
	</tr>
	</cfif>
	<tr>
		<td><b>Email:</b></td>
		<td>#form.emai#</td>
	</tr>
	<tr>
		<td><b>message:</b></td>
		<td>#form.message#</td>
	</tr>
	</table>
</cfmail> 
</cfif>