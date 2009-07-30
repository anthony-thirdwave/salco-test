<cfset ThisHTTPHost="#CGI.HTTP_HOST#">
<cfswitch expression="#ListFirst(ReplaceNoCase(ThisHTTPHost,'www.','','one'),'.')#">
	<cfcase value="voice,journal">
		<cfset Page="voice">
	</cfcase>
	<cfcase value="clear">
		<cfset Page="clear">
	</cfcase>
	<cfcase value="gain">
		<cfset Page="gain">
	</cfcase>
	<cfcase value="loop">
		<cfset Page="loop">
	</cfcase>
	<cfcase value="designconference2007">
		<cfset Page="dc_home">
	</cfcase>
	<cfcase value="leadershipretreat2007">
		<cfset Page="retreat07-home">
	</cfcase>
	<cfdefaultcase>
		<cfset Page="home">
	</cfdefaultcase>
</cfswitch>

<cfinclude template="content.cfm">
