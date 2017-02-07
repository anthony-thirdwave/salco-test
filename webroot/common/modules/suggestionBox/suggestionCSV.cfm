<cfsetting enablecfoutputonly="Yes" showdebugoutput="0">
<cfset CRLF="#CHR(13)##CHR(10)#">

<cfparam name="showall" default="0">
<cfif isDefined("url.showall") and val(url.showall) eq 1>
  <cfset showall = url.showall />
</cfif>  

<cfinvoke component="com.suggestionBox.suggestionBoxHandler" method="getSuggestions" showall="#val(showall)#"
  returnVariable="qSuggestions">

<cfif 1>
  <cfheader name="Content-disposition" value="attachment;filename=export#DateFormat(now(),'yyyymmdd')#.csv">
  <cfcontent type="text/csv">
</cfif>

<cfif showall eq '1'>
  <cfset ThisColumnList="suggestionID,employeeName,employeeEmail,suggestionText,departmentName,areaName,,DateSubmitted">
  <cfoutput>suggestionID,employeeName,employeeEmail,Suggestion,DepartmentName,AreaName,DateSubmitted#CRLF#</cfoutput>
<cfelse>
  <cfset ThisColumnList="suggestionID,suggestionText,departmentName,areaName,,DateSubmitted">
  <cfoutput>suggestionID,Suggestion,DepartmentName,AreaName,DateSubmitted#CRLF#</cfoutput>
</cfif>

<cfoutput query="qSuggestions">
  <cfloop index="ThisCol" list="#ThisColumnList#">"<cfif ThisCol IS "DateSubmitted">#DateFormat(DateSubmitted)# #TimeFormat(DateSubmitted,"HH:MM")#<cfelse>#APPLICATION.utilsObj.RemoveBreaks(Evaluate('qSuggestions.#ThisCol#'))#</cfif>"<cfif ThisCol IS ListLast("#ThisColumnList#")>#CRLF#<cfelse>,</cfif>
  </cfloop>
</cfoutput> 
