<cffunction name="GetContentNoteQuery" output="false" returntype="query">
	<cfargument name="ContentID" default="-1" type="numeric" required="true">
	
	<!--- init variables --->
	<cfset var GetContentQuery = "">
	
	<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
		SELECT * FROM qry_GetContentNote
		WHERE ContentID=<cfqueryparam value="#Val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
		Order By ContentNoteDate
	</cfquery>
	<cfreturn GetContentQuery>
</cffunction>
