<cfparam name="ATTRIBUTES.VarName" default="">
<cfparam name="ATTRIBUTES.Value" default="">
<cfif Trim(ATTRIBUTES.VarName) IS NOT "">
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(150),"&##8211;","All")><!--- en dash --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(151),"&##8212;","All")><!--- em dash --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(145),"&##8216;","All")><!--- open apostrophe --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(146),"&##8217;","All")><!--- close apostrophe --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(147),"&##8220;","All")><!--- open double quote --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(148),"&##8221;","All")><!--- close double quote --->
	
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(8211),"&##8211;","All")><!--- en dash --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(8212),"&##8212;","All")><!--- em dash --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(8216),"&##8216;","All")><!--- open apostrophe --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(8217),"&##8217;","All")><!--- close apostrophe --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(8220),"&##8220;","All")><!--- open double quote --->
	<cfset ATTRIBUTES.Value=ReplaceNoCase(ATTRIBUTES.Value,chr(8221),"&##8221;","All")><!--- close double quote --->
	<cfset SetVariable("CALLER.#Trim(ATTRIBUTES.VarName)#",ATTRIBUTES.Value)>
</cfif>
