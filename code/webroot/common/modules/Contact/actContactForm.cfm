<cfparam name="ErrorMessage" default="">

<cfif Len(Trim(firstName)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your first name.</li>">
</cfif>
<cfif Len(Trim(lastName)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your last name.</li>">
</cfif>
<cfif Len(Trim(Phone)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your phone number.</li>">
</cfif>
<cfif Len(Trim(message)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter a message.</li>">
</cfif>
<cfif Len(Trim(emai)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter a value for email.</li>">
<cfelse>
	<cfmodule name="3w.errorcheck.validateemail" email="#form.emai#">
	<cfif ValidateEmailStatus GTE "200">
		<cfset ErrorMessage= ErrorMessage & "<li>Email entered is not formatted correctly.</li>">
	<cfelse>
		<cfset Mailer_FromAddress="#form.emai#">
	</cfif>
</cfif>

<cfif Len(Trim(email)) GT 0>
	<cfset ErrorMessage=ErrorMessage & "<li>Your request can not be processed.</li>">
</cfif>

<cfif len(trim(ErrorMessage)) EQ 0>
	<cfif Mailer_ToAddress IS NOT "sales@salcoproducts.com">
		<cfset Mailer_ToAddress=ListAppend(Mailer_ToAddress,"sales@salcoproducts.com")>
	</cfif>
	<cfmail	to="#Mailer_ToAddress#" from="#Mailer_FromAddress#"
			type="html" subject="#Mailer_Subject#">
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
	<tr>
		<td><b>Company:</b></td>
		<td>#form.company#</td>
	</tr>
	<tr>
		<td><b>Phone Number:</b></td>
		<td>#form.Phone#</td>
	</tr>
	<tr>
		<td><b>Email:</b></td>
		<td>#form.emai#</td>
	</tr>
	<tr>
		<td><b>Preferred method of contact:</b></td>
		<td>#form.method#</td>
	</tr>
	<tr>
		<td><b>Subject:</b></td>
		<td>#form.subject#</td>
	</tr>
	<tr>
		<td><b>Message:</b></td>
		<td>#form.message#</td>
	</tr>
	</table>
</cfmail> 
</cfif>