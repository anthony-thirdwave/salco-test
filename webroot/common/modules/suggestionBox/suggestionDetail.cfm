<cfparam name="ATTRIBUTES.suggestionID" default="0">

<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getSuggestion"
	suggestionId="#val(ATTRIBUTES.suggestionID)#"
	returnVariable="getSuggestionResult">

<p>&nbsp;</p>
<cfif getSuggestionResult.recordCount>
	<cfoutput query="getSuggestionResult">
		<Table>
			<!--- <tr>
				<td><strong>Employee Name</strong></td>
				<td><cfif val(anonymous)>anonymous<cfelse>#employeeName# (<a href="mailto:#employeeEmail#">#employeeEmail#</a>)</cfif></td>
			</tr> --->
			<tr>
				<td><strong>Area</strong></td>
				<td>#areaName#</td>
			</tr>
			<tr>
				<td><strong>Department</strong></td>
				<td>#departmentName#</td>
			</tr>
			<tr valign="top">
				<td><strong>Suggestion</strong></td>
				<td>#APPLICATION.utilsObj.addBreaks(suggestion)#</td>
			</tr>
			<tr>
				<td><strong>Date Submitted</strong></td>
				<td>#DateFormat(dateSubmitted)# #timeFormat(dateSubmitted)#</td>
			</tr>
		</table>
	</cfoutput>
<cfelse>
	Not Found
</cfif>
<p>&nbsp;</p>
<p>&nbsp;</p>
<a href="/common/admin/suggestionManager/index.cfm">Return to List</a>