<cfparam name="ATTRIBUTES.CategoryID" default="-1">

<cfquery name="GetFirstHTML" datasource="#APPLICATION.DSN#" maxrows="1">
	select ContentID from qry_GetContentLocaleMeta
	Where
	ContentPositionID=<cfqueryparam value="401" cfsqltype="CF_SQL_INTEGER">
	AND LocaleID=<cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
	AND ContentTypeID=<cfqueryparam value="201" cfsqltype="CF_SQL_INTEGER">
	AND ContentActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
	AND CategoryID=(<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer" list="yes">)
	order by ContentLocalePriority
</cfquery>
<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetContent">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(GetFirstHTML.ContentID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
</cfstoredproc>

<cfset ThisBio="">
<cfif IsWDDX(GetContent.ContentBody)>
	<cfwddx action="WDDX2CFML" input="#GetContent.ContentBody#" output="sContentBody">
	<cfif StructKeyExists(sContentBody,"HTML") and sContentBody.HTML is NOT "">
		<cfset ThisBio=sContentBody.HTML>
	</cfif>
</cfif>

<cfinvoke component="com.ContentManager.EmployeeHandler"
	method="qryEmployees"
	employeeID = "#val(ATTRIBUTES.CategoryID)#"
	returnVariable="employee">

<cfoutput query="employee">
	<cfset thisName=empFirstName & " " & empLastName>
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
					<dd class="empl-about">#ThisBio#</dd>
				</dl>
			</div>
		</div>
	</article>
</cfoutput>

