<!--- <cfmodule template="#Mapping#common/modules/Utils/TruncateText.cfm" Input="#MessageBody#" NumChars="100"> --->
<cfparam name="ATTRIBUTES.Input" default="">
<cfparam name="ATTRIBUTES.NumChars" default="">
<cfparam name="ATTRIBUTES.VarName" default="">
<cfif Len(ATTRIBUTES.Input) gte ATTRIBUTES.NumChars>
	<cfset x = find(" ", ATTRIBUTES.Input, ATTRIBUTES.NumChars)>
	<cfif x is 0><cfset x = ATTRIBUTES.NumChars></cfif>
	<cfset Result="#trim(left(ATTRIBUTES.Input, x))#">
	<cfif mid(ATTRIBUTES.Input, x-1, 1) is not "."><cfset Result="#Result#."></cfif>
	<cfset Result="#Result#..">
<cfelse>
	<cfset Result="#Trim(ATTRIBUTES.Input)#">
</cfif>
<cfif Trim(ATTRIBUTES.VarName) IS "">
	<cfoutput>#Result#</cfoutput>
<cfelse>
	<cfset DevNull=SetVariable("CALLER.#ATTRIBUTES.VarName#","#result#")>
</cfif>