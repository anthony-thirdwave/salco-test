<cfinvoke component="com.suggestionBox.suggestionBoxHandler"
	method="getSuggestions"
	returnVariable="getSuggestions">

<cfoutput query="getSuggestions" maxrows="5">
	<p><b>Suggestion ###getSuggestions.suggestionID#</b><br/>
	#getSuggestions.suggestionText#
	</p>
</cfoutput>
<br/>
<a href="/common/admin/suggestionManager"><strong>See All Suggestions</strong></a>
