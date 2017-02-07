<cfparam name="ATTRIBUTES.String" default="">
<cfparam name="ATTRIBUTES.Delimiter" default="\">
<cfparam name="Attributes.ReturnVarName" default="TheString">
<cfset TheString=ATTRIBUTES.String>
<cfset DoneString="">
<cfloop index="i" from="1" to="#Len(TheString)#" step="1">
	<cfset DoneString="#DoneString##Mid(TheString,i,1)##ATTRIBUTES.Delimiter#">
</cfloop>
<cfset SetVariable("CALLER.#Attributes.ReturnVarName#",DoneString)>