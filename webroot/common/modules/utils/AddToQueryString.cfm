<!--- <cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="GoToForm"> --->
<cfparam name="ATTRIBUTES.QueryString" default="">
<cfparam name="ATTRIBUTES.Name" default="">
<cfparam name="ATTRIBUTES.Value" default="">
<cfparam name="ATTRIBUTES.OmitList" default=""><!--- Delete these fields from the query string. --->
<cfif isDefined("ATTRIBUTES.VarName")>
	<cfset ATTRIBUTES.Name="#ATTRIBUTES.VarName#">
</cfif>
<cfset NewQueryString="">
<cfloop index="ThisField" list="#ATTRIBUTES.QueryString#" delimiters="&">
	<cfif ATTRIBUTES.Name IS NOT GetToken(ThisField,"1","=") AND ListFindNoCase(ATTRIBUTES.OmitList,GetToken(ThisField,"1","=")) IS "0">
		<cfset NewQueryString=ListAppend(NewQueryString,"#ThisField#","&")>
	</cfif>
</cfloop>
<cfif ATTRIBUTES.Name IS NOT "">
	<cfset NewQueryString=ListAppend(NewQueryString,"#ATTRIBUTES.Name#=#URLEncodedFormat(ATTRIBUTES.Value)#","&")>
</cfif>
<cfset CALLER.QueryString=NewQueryString>
