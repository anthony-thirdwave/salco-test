<!---
	Created by JWA on 09.21.2004
	NOTES: The following MUST exist:
		1. The destination datasource (Application.DestinationDSN)
		2. The destination SQL Login must have db_owner priv's
--->

<cfcomponent displayname="postToProduction" hint="Object representing the post to production process">
	
	<!--- Global Variables --->
	<cfset this.dsn = Application.DSN>
	<!--- <cfset destination.dsn = Application.PostToProductionDestination> --->
	
	
	<!--- ============================================================================================== --->
	<!--- FUNCTION START: Post to Production --->
	<cffunction name="postLive" returntype="numeric" output="false" hint="This function will post the data to the live environment">
		
		<!--- Required Arguments --->
		<cfargument name="valueList" type="string" required="true" default="">
		<cfargument name="columnList" type="string" required="true" default="">
		<cfargument name="tableName" type="string" required="true" default="">
		<cfargument name="sourceDatabase" type="string" required="true" default="" hint="lifefitness_development">
		<cfargument name="sourceServer" type="string" required="true" default="" hint="db02.newermedia.com">
		<cfargument name="sourceLogin" type="string" required="true" default="" hint="#APPLICATION.SourceLogin#">
		<cfargument name="sourcePassword" type="string" required="true" default="" hint="#APPLICATION.SourcePassword#">
		<cfargument name="destinationDSN" type="string" required="true" default="" hint="">
		
		<!--- init variables --->		
		<cfset var curResult = "">
		
		<!--- Run the post to production destination process stored procedure --->	
		<cfstoredproc procedure="sp_postToProduction_productionProcess" datasource="#ARGUMENTS.destinationDSN#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@valueList" value="#arguments.valueList#" null="no">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@columnList" value="#arguments.columnList#" null="no">
			<cfprocparam cfsqltype="CF_SQL_varchar" dbvarname="@tableName" value="#arguments.tableName#" null="no">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@sourceDatabase" value="#arguments.sourceDatabase#" null="no">
			<cfprocparam cfsqltype="CF_SQL_varchar" dbvarname="@sourceServer" value="#arguments.sourceServer#" null="no">
			<cfprocparam cfsqltype="CF_SQL_varchar" dbvarname="@sourceLogin" value="#arguments.sourceLogin#" null="no">
			<cfprocparam cfsqltype="CF_SQL_varchar" dbvarname="@sourcePassword" value="#arguments.sourcePassword#" null="no">
			<cfprocparam type="Out" cfsqltype="CF_SQL_BIT" variable="curResult" dbvarname="@successResult" null="no">
		</cfstoredproc>
			
		
		<cfif curResult IS 1>
			<cfreturn 1 />
		<cfelse>
			<cfreturn 0 />
		</cfif>
		
		
		
	</cffunction>
	<!--- FUNCTION END: Post to Production  --->
	<!--- ============================================================================================== --->

</cfcomponent>