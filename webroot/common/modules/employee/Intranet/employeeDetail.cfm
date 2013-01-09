<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.EmpBio" default="-1">

<cfinvoke component="com.ContentManager.EmployeeHandler"
	method="qryEmployees"
	employeeID = "#val(ATTRIBUTES.CategoryID)#"
	returnVariable="employee">

<cfoutput query="employee">
	<cfset thisName=empFirstName & ' ' & empLastName>
	<article class="employee">
	    <div class="inArt">
		 	<div class="empl-left">
				<img src="#EmpImage#" alt="#thisName#">
			</div>
			<div class="empl-right">
				<dl>
					<dt class="empl-name">#thisName#</dt>
					<dd class="empl-title">#EmpTitle#</dd>
					<dt class="emp-phone-title">Phone:</dt>
					<dd class="empl-phone">#EmpPhone#</dd>
					<dt class="empl-ext-title">Ext:</dt>
					<dd class="empl-ext">#EmpPhoneExt#</dd>
					
					<cfif empCellPhone IS NOT "">
						<dd class="clearit"></dd>
						<dt class="empl-cell-title">Cell:</dt>
						<dd class="empl-cell">#empCellPhone#</dd>
					</cfif>
					<dd class="clearit"></dd>
					<dt class="empl-email-title">Email:</dt>
					<dd class="empl-email"><a href="mailto:#empEmail#">#empEmail#</a></dd>
					<dt class="empl-bday-title">Birthday:</dt>
					<dd class="empl-bday">#dateformat(EmpBirthdate,"mm/dd")#</dd>
					<dt class="empl-hiredate-title">Hire Date:</dt>
					<dd class="empl-hiredate">#dateformat(EmpJoindate,"mm/dd/yyyy")#</dd>
					<dt class="empl-about-title">About Me:</dt>
					<dd class="empl-about">#ATTRIBUTES.EmpBio#</dd>
				</dl>
			</div>
		</div>
	</article>
</cfoutput>

