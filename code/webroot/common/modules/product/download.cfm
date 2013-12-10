<cfparam name="f" default="">
<cfif f IS NOT "" and FileExists(ExpandPath(f)) and Left(ExpandPath(f),Len(ExpandPath("/resources/external/downloads/"))) IS ExpandPath("/resources/external/downloads/")>
	<cfheader name="Content-Disposition" value="attachment;filename=#ListLast(f,'/')#">
	<cfcontent type="application/octet-stream" file="#expandPath(f)#">
<cfelse>
	<cfheader statusCode="404" statusText="Not Found">
	<cfinclude template="/common/error/404.html">
</cfif>
