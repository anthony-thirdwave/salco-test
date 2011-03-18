<cfparam name="ErrorMessage" default="">

<cfif Len(Trim(firstName)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your first name.</li>">
</cfif>
<cfif Len(Trim(lastName)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your last name.</li>">
</cfif>
<cfif Len(Trim(phone)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your phone number.</li>">
</cfif>
<cfif Len(Trim(Message)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your message.</li>">
</cfif>
<cfif Len(Trim(emai)) Eq 0>
	<cfset ErrorMessage= ErrorMessage & "<li>Please enter your email address.</li>">
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
	<cfmail	to="#Mailer_ToAddress#" from="#Mailer_FromAddress#"
			type="html" subject="Support Form Submission: #form.Firstname# #form.LastName#">
	<table>
		<tr>
		<td colspan="2"><b>Support Form Submission</b><br>
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
		<td>#form.CompanyName#</td>
	</tr>
	<tr>
		<td><b>Phone:</b></td>
		<td>#form.phone#</td>
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
		<td><b>Message:</b></td>
		<td>#form.Message#</td>
	</tr>
	</table>
</cfmail> 
</cfif>