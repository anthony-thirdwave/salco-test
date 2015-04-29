<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getSuggestions"
	returnVariable="getSuggestions">

<cfoutput query="getSuggestions" maxrows="5">
	<p><b><cfif val(anonymous)>Anonymous<cfelse>#employeeName#</cfif></b> #DateFormat(dateSubmitted)# #timeFormat(dateSubmitted)#<br/>
	#getSuggestions.suggestionText#
	</p>
</cfoutput>
<br/>
<a href="/common/admin/suggestionManager"><strong>See All Suggestions</strong></a>
