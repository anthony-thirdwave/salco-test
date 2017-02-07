<link rel="stylesheet" type="text/css" href="/common/modules/suggestionBox/thankYou.css">
<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getSuggestion"
	suggestionId="#url.sid#"
	returnVariable="getSuggestionResult">

<div class="faux-form-container">
	<div class='faux-form
		<cfif getSuggestionResult.anonymous EQ 1>
			 disabled
		</cfif>
		'
	> 
		<cfoutput>#getSuggestionResult.employeeName#</cfoutput>
	</div>
	<div class='faux-form
		<cfif getSuggestionResult.anonymous EQ 1>
			 disabled
		</cfif>
		'
	>
		<cfoutput>#getSuggestionResult.employeeEmail#</cfoutput>
	</div>
	<div class='faux-form'><cfoutput>#getSuggestionResult.departmentName#</cfoutput></div>
	<div class='faux-form'><cfoutput>#getSuggestionResult.areaName#</cfoutput></div>
</div>
<div class="image-container">
	<p><img src="/common/images/Intranet/template/success-checkmark.png"></p>
</div>
<div class="confirmation-messages">
	<p><b>Your suggestion has been successfully submitted!</b> </p>
	<hr>
	<p>Please check your inbox for email confirmation.</p>
	<br>
	<p class='red'><b>We are dedicated to engaged employees!</b></p>
</div>