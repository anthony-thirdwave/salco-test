<link rel="stylesheet" type="text/css" href="/common/modules/suggestionBox/suggestionBox.css">
<script src="/common/modules/suggestionBox/suggestionBox.js"></script>
<!--- Declare values --->
<cfparam name="ATTRIBUTES.ThankYouPage" default="/page/thank-you">

<cfparam name="ATTRIBUTES.ToAddress" default="lisa_moffat@salcoproducts.com">
<cfparam name="ATTRIBUTES.FromAddress" default="noreply@salcoproducts.com">

<cfparam name="formsubmit" default="0">
<cfparam name="FormAction" default="#CGI.REQUEST_URI#?#CGI.QUERY_STRING#">
<cfparam name="form.email" default="">
<cfparam name="suggestionID" default="10">

<cfset ErrorMessage="">

<cfset lSubject="Hopper Cars,Intermodal Containers,Rail/Yard Accessories,Tank Cars,Other">

<!---  set params ----> 
<cfset formFieldList="employeeName,missive,salcoDepartment,suggestionArea,message">
<cfloop index="i" list="#formFieldList#">
	<cfparam name="form.#i#" default="">
</cfloop>
<cfparam name="form.anonymousSuggestion" default="0">

<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getDepartments"
	returnVariable="getDepartmentsResult">

<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getSuggestionAreas"
	returnVariable="getSuggestionAreasResult">

<cfset Mailer_Subject="Contact Form Submission: #form.EmployeeName# ">

<cfif APPLICATION.Production>
	<!--- live site --->
<cfelse>
	<cfset Mailer_Subject="#Mailer_Subject# TESTING ONLY!">
	<cfset ATTRIBUTES.ToAddress="notifications@dev01.thirdwavellc.com">
	<cfif 0>
		<cfset ATTRIBUTES.ToAddress="lisa_moffat@salcoproducts.com">
	</cfif>
</cfif>

<cfif formsubmit EQ 1>
	<!--- Form is submitted so lets process it --->
	<cfif Len(Trim(employeeName)) Eq 0>
		<cfset ErrorMessage=ErrorMessage & "<li>Please enter your full name.</li>">
	</cfif>
	<!--- Missive == user submitted email --->
	<cfif Len(Trim(missive)) Eq 0>
		<cfset ErrorMessage=ErrorMessage & "<li>Please enter a value for email.</li>">
	<cfelse>
		<cfmodule name="3w.errorcheck.validateemail" email="#form.missive#">
		<cfif ValidateEmailStatus GTE "200">
			<cfset ErrorMessage=ErrorMessage & "<li>Email entered is not formatted correctly.</li>">
		</cfif>
	</cfif>

	<cfif Len(Trim(salcoDepartment)) Eq 0>
		<cfset ErrorMessage=ErrorMessage & "<li>Please enter a department.</li>">
	</cfif>
	<cfif Len(Trim(suggestionArea)) Eq 0>
		<cfset ErrorMessage=ErrorMessage & "<li>Please enter a suggestion area.</li>">
	</cfif>
	<cfif Len(Trim(message)) Eq 0>
		<cfset ErrorMessage=ErrorMessage & "<li>Please enter a message.</li>">
	</cfif>

	<cfif len(trim(ErrorMessage)) EQ 0>
		<cfif Len(Trim(email)) GT 0>
			<!--- Honeypot fail, do not echo error message --->
		<cfelse>
			<!--- save to db via handler --->
			<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
				method="insertSuggestion"
				returnVariable="suggestionID"
				suggestionFormValue="#FORM#">

			<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
				method="getDepartmentName"
				returnVariable="departmentName"
				nameId="#form.salcoDepartment#">

			<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
				method="getAreaName"
				returnVariable="areaName"
				areaId="#form.suggestionArea#">

			<!--- get label name associated with ID here --->

			
			<cfmail	to="#form.missive#" from="#ATTRIBUTES.FromAddress#" bcc="#ATTRIBUTES.ToAddress#" type="html" subject="#Mailer_Subject#">
				<table>
					<tr>
						<td colspan="2">
							<p>Thank you for submitting your suggestion to our Innovation Program!</p>
							<p>Salco Products&rsquo; long term strategy and core values include using innovation to continually enhance our products, strengthen relationships with our customers and business partners as well as encourage employee participation and development.</p>
							<p>
							All suggestions are carefully evaluated by our Innovation Team.  While not every suggestion may be selected for implementation, all suggestions are important and valued by the leadership of Salco Products.</p>
							<p>
							As soon as a decision is made, you will be notified via email regarding the status of your submission.</p></td>
					</tr>
					<tr>
						<td colspan="2"><b>Contact Form Submission</b><br>
						Submitted #DateFormat(Now())# #TimeFormat(Now())#</td>
					</tr>
				<!--- 	<tr>
						<td style="width: 20%;"><b>Full Name:</b></td>
						<td>#form.employeeName#</td>
					</tr> --->
					<!--- <tr>
						<td><b>Email:</b></td>
						<td>#form.missive#</td>
					</tr> --->
					<tr>
						<td><b>Salco Department:</b></td>
						<!--- use label name here --->
						<td>#departmentName.name#</td>
					</tr>
					<tr>
						<td><b>Suggestion Area:</b></td>
						<td>#areaName.name#</td>
					</tr>
					<tr>
						<td><b>Message:</b></td>
						<td>#form.message#</td>
					</tr>
					<tr>
						<td><b>Confirmation Number:</b></td>
						<td>#NumberFormat(suggestionID, "00000_")#</td>
					</tr>
				</table>
			</cfmail>
		

			<!--- redirect to thank you page --->
			<cflocation url="#ATTRIBUTES.ThankYouPage#&sid=#suggestionID#" addtoken="No">
		</cfif>
	</cfif>
	<cfif len(trim(ErrorMessage)) gt 0>
		<div class="red">
			<ul>
				<cfoutput>#ErrorMessage#</cfoutput>
			</ul>
		</div>
	</cfif>
</cfif>
	
<cfset Location=GetToken(FormAction,1,"?")>
<cfset querystring=GetToken(FormAction,2,"?")>

<cfoutput>	
<div class="news">	
	<h2>Salco Suggestion Box</h2>
	<form action="#Location#?#querystring#" method="post" name="applicationForm" id="applicationForm" enctype="multipart/form-data">
	<input type="hidden" name="formsubmit" value="1" />
	<input name="email" type="text" class="hpfield" value="" style="display: none;"/>
	<!--- ====================================================--->
	<!--- enter form fields here --->

		<div class="formRow<cfif formsubmit EQ 1 and len(trim(employeeName)) eq 0> errorTxt</cfif> wide">
			<input name="employeeName" id="employeeName" maxlength="50" type="text" value="#HTMLEditFormat(form.employeeName)#" placeholder="Employee Name">
		</div>


		<div class="formRow<cfif formsubmit EQ 1 and len(trim(missive)) eq 0> errorTxt</cfif>">
			<input name="missive" id="email" maxlength="50" type="text" value="#HTMLEditFormat(form.missive)#" placeholder="Email Address" >
		</div>
<!--- <div class="fauxSelect"> --->
		<div class="formRow">
			<select name="salcoDepartment">
				<option value="">Salco Department</option>
				<cfloop query="getDepartmentsResult">
					<option value="#getDepartmentsResult.departmentID#" <cfif FORM.salcoDepartment IS getDepartmentsResult.departmentID> selected</cfif>>#getDepartmentsResult.departmentName#</option>
				</cfloop>
	<!--- <cfloop index="ThisSubject" list="#lSubject#">
					<option value="#ThisSubject#">#ThisSubject#</option>
				</cfloop> --->
			</select>
		</div>
<!--- </div> --->

		<div class="formRow">
			<select name="suggestionArea">
				<option value="">Suggestion Area</option>
				<cfloop query="getSuggestionAreasResult">
					<option value="#getSuggestionAreasResult.areaID#" <cfif FORM.suggestionArea IS getSuggestionAreasResult.areaID> selected</cfif>>#getSuggestionAreasResult.areaName#</option>
				</cfloop>
			</select>
		</div>

		<div class="formRow memo<cfif formsubmit EQ 1 and len(trim(email)) eq 0> errorTxt</cfif>">
			<textarea name="message" placeholder="Enter text...">#HTMLEditFormat(FORM.message)#</textarea>
			<div class="img_container hidden"><img class="center_img" src="/common/images/loader.gif" alt="loader"></div>
		</div>
		
		<!--- ====================================================--->
		
		<div class="formRow submit rightSubmit">
			<p id='footerText'>Please remember that your suggestion will be entered into our annual drawing. In addition, select winners will also become members of our Innovation Comittee!<br><br>*Anonymous suggestions are not eligible for prize considerations.</p>
			<cfset someStr="Submit your" & Chr(10) & "Suggestion" />
			<input type="submit" name="submit" value="#someStr#" title="Send Suggestion"/>
		</div>

	</form></div>
</cfoutput>
