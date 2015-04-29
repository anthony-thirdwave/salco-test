<cfsetting enablecfoutputonly="Yes" showdebugoutput="0">
<cfset CRLF="#CHR(13)##CHR(10)#">
<cfinvoke component="com.suggestionBox.suggestionBoxHandler" method="getSuggestions"
	returnVariable="qSuggestions">
<cfif 1>
	<cfheader name="Content-disposition" value="attachment;filename=export#DateFormat(now(),'yyyymmdd')#.csv">
	<cfcontent type="text/csv">
</cfif>
<cfset ThisColumnList="suggestionID,employeeName,employeeEmail,suggestionText,departmentName,areaName,,DateSubmitted">
<cfoutput>suggestionID,employeeName, employeeEmail,Suggestion,DepartmentName,AreaName,DateSubmitted#CRLF#</cfoutput>
<cfoutput query="qSuggestions"><cfloop index="ThisCol" list="#ThisColumnList#">"<cfif ThisCol IS "DateSubmitted">#DateFormat(DateSubmitted)# #TimeFormat(DateSubmitted,"HH:MM")#<cfelse>#Evaluate('qSuggestions.#ThisCol#')#</cfif>"<cfif ThisCol IS ListLast("#ThisColumnList#")>#CRLF#<cfelse>,</cfif></cfloop>
</cfoutput>