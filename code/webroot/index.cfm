<cfset ThisHTTPHost="#CGI.HTTP_HOST#">
<cfswitch expression="#ListFirst(ReplaceNoCase(ThisHTTPHost,'www.','','one'),'.')#">
	<cfdefaultcase>
		<cfset Page="home">
	</cfdefaultcase>
</cfswitch>

<cfinclude template="content.cfm">
