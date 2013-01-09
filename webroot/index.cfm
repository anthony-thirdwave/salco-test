<cfset ThisHTTPHost="#CGI.HTTP_HOST#">
<cfswitch expression="#ListFirst(ReplaceNoCase(ThisHTTPHost,'www.','','one'),'.')#">
	<cfcase value="intranet">
		<cfset page="home-1">
	</cfcase>
	<cfdefaultcase>
		<cfset Page="home">
	</cfdefaultcase>
</cfswitch>

<cfinclude template="/content.cfm">
