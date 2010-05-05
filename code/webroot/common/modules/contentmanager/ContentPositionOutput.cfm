<cfif REQUEST.ContentGenerateMode IS "FLAT">
	<cfoutput>#CALLER.sContent[ATTRIBUTES.PositionID]#</cfoutput>
<cfelseif CALLER.sIncludeFile[ATTRIBUTES.PositionID] IS NOT "">
	<cfinclude template="#CALLER.sIncludeFile[ATTRIBUTES.PositionID]#">
</cfif>