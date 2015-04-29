<link rel="stylesheet" type="text/css" href="/common/modules/suggestionBox/suggestionGrid.css">
<cfparam name="ATTRIBUTES.Mode" default="Default">

<cfparam name="suggestionID" default="">
<cfparam name="employeeName" default="">
<cfparam name="suggestion" default="">
<cfparam name="departmentName" default="">
<cfparam name="areaName" default="">
<cfparam name="anonymous" default="">

<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getDepartments"
	returnVariable="getDepartmentsResult">

<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getSuggestionAreas"
	returnVariable="getSuggestionAreasResult">

<cfoutput>
	<cfform action="#CGI.SCRIPT_NAME#" method="post" name="productSearchForm">
		<!--- <h4>Search By</h4> --->
		<table style="padding:8px;" width="90%" align="center">
			<thead>
			<tr>
				<th align="center" valign="middle"><b>Employee Name</b></th>
				<th align="center" valign="middle"><b>Suggestion</b></th>
				<th align="center" valign="middle"><b>Department Name</b></th>
				<th align="center" valign="middle"><b>Area Name</b></th>
				<th align="center" valign="middle"><b>Group</b></th>
			</tr>
			<tr>
				<th align="left" valign="middle"><cfinput type="text" name="employeeName" value="#employeeName#" style="width:179px;"></th>
				<th align="center" valign="middle"><cfinput type="text" name="suggestion" value="#suggestion#" style="width:96px;"> </th>

				<!--- <th align="center" valign="middle"><cfinput type="text" name="departmentName" value="#departmentName#" style="width:196px;"></th> --->

				<th align="center" valign="middle">
					<cfselect type="text" name="departmentName">
							<option value=""<cfif departmentName eq ''>selected</cfif>>--None--</option>
						<cfloop query="getDepartmentsResult">
							<option value="#getDepartmentsResult.departmentName#">#getDepartmentsResult.departmentName#</option>
						</cfloop>
					</cfselect>
				</th>

				<!--- <th align="center" valign="middle"><cfinput type="text" name="areaName" value="#areaName#" style="width:200px;"></th> --->

				<th align="center" valign="middle">
					<cfselect type="text" name="areaName">
							<option value=""<cfif areaName eq ''>selected</cfif>>--None--</option>
						<cfloop query="getSuggestionAreasResult">
							<option value="#getSuggestionAreasResult.areaName#">#getSuggestionAreasResult.areaName#</option>
						</cfloop>
					</cfselect>
				</th>

				<th align="center" valign="middle">
					<cfselect type="text" name="anonymous">
						<option value="" <cfif anonymous eq ''>selected</cfif>>All</option>
						<option value="0">Non Anonymous</option>
						<option value="1">Anonymous</option>
					</cfselect>
				</th>

			</tr>
			<cfif ATTRIBUTES.Mode IS "admin">
			<tr><td colspan="4" height="10">&nbsp;&nbsp;</td></tr>
			</cfif>
			</thead>
		</table>
		<table class="grid" width="90%" align="center">
			<tr><td colspan="2" height="10">
				<strong>Results</strong>
				<div style="float:right">
					<a class="button-blue" href="/common/modules/suggestionBox/suggestionCSV.cfm">Export All to Excel</a>
				</div>
			</td></tr>
			<tr><td colspan="4" height="10">&nbsp;&nbsp;</td></tr>
			<tr><td>
			<!--- display the users in a cfgrid tag - this is bound both to the cfgrid
			controls and the form controls above --->
			<cfif ATTRIBUTES.Mode IS "admin">
				<cfgrid format="html" name="suggestionsReport" gridLines="yes"
						selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
						appendKey="true"
						bind="cfc:com.suggestionBox.suggestionBoxHandler.getSuggestions({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn}, 
							{cfgridsortdirection}, {employeeName@keyup}, {suggestion@keyup}, {departmentName@change}, {areaName@change}, {anonymous@change})">
					<cfgridcolumn name="suggestionID" header="Id" />
					<cfgridcolumn name="employeeName" header="Employee" />
					<cfgridcolumn name="employeeEmail" header="Email" />
					<cfgridcolumn name="suggestionText" header="Suggestion" />
					<cfgridcolumn name="departmentName" header="Department Name" />
					<cfgridcolumn name="areaName" header="Area Name"/>
					<cfgridcolumn name="anonymous" header="Anonymous"/>
					<cfgridcolumn name="dateSubmitted" header="Date Submitted"/>
					<cfgridcolumn name="edit" header="" width="24" href="/common/admin/suggestionManager/index.cfm" hrefKey="suggestionID"/>
				</cfgrid>
			</cfif>
			</td></tr>
		</table>
	</cfform>
</cfoutput>
