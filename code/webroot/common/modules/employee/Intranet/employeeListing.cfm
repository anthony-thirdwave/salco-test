
<cfif REQUEST.currentCategoryID eq 6065>
	<cfparam name="ATTRIBUTES.CategoryID" default="">
<cfelse>
	<cfparam name="ATTRIBUTES.CategoryID" default="#REQUEST.currentCategoryID#">
</cfif>

<cfparam name="ATTRIBUTES.PageStatus" default="">
<cfparam name="url.alphaListing" default="">

<cfif len(ATTRIBUTES.PageStatus) and ATTRIBUTES.PageStatus is "search">
	<cfquery name="employees" dbtype="query">
		SELECT		*
		FROM		REQUEST.GetAllEmployees
		WHERE		departmentID <> <cfqueryparam value="6098" cfsqltype="cf_sql_integer">
		<cfif Len(Trim(url.alphaListing))>
		AND			empFirstName like <cfqueryparam value="#UCASE(Trim(url.alphaListing))#%" cfsqltype="cf_sql_varchar">
		</cfif>
		ORDER BY	empFirstName,empLastName
	</cfquery>
<cfelse>
	<cfquery name="employees" dbtype="query">
		SELECT		*
		FROM		REQUEST.GetAllEmployees
		WHERE		departmentID <> <cfqueryparam value="6098" cfsqltype="cf_sql_integer">
		<cfif val(ATTRIBUTES.CategoryID) gt 0>
		AND		departmentID = <cfqueryparam value="#val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfif>
		ORDER BY	empFirstName,empLastName
	</cfquery>
</cfif>
<cfif employees.recordCount GT 0>
	<div class="employees">
	 <cfoutput query="employees">
	 	<a href="#employees.empAlias#">
			<span><strong>#employees.empFirstName#</strong> #employees.empLastName#
			<img src="#employees.empImagethumb#">
			</span>
		</a>
	 </cfoutput>
	</div>
	<!--- Loop over keys in the struct. --->
<cfelse>
	No Employee Display
</cfif>