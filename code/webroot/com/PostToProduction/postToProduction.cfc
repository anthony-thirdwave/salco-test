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
		<cfargument name="valueList" type="string" required="true">
		<cfargument name="columnList" type="string" required="true">
		<cfargument name="tableName" type="string" required="true">
		<cfargument name="sourceDatabase" type="string" required="true" hint="lifefitness_development">
		<cfargument name="sourceServer" type="string" required="true" hint="db02.newermedia.com">
		<cfargument name="sourceLogin" type="string" required="true" hint="#APPLICATION.SourceLogin#">
		<cfargument name="sourcePassword" type="string" required="true" hint="#APPLICATION.SourcePassword#">
		<cfargument name="destinationDSN" type="string" required="true" hint="">
		<cfargument name="sameServer" type="string" default="1" hint="">
		
		<!--- init variables --->		
		<cfset var curResult = "">
		
		<!--- Run the post to production destination process stored procedure --->	
		<cfstoredproc procedure="sp_postToProduction_productionProcess" datasource="#ARGUMENTS.destinationDSN#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@valueList" value="#arguments.valueList#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@columnList" value="#arguments.columnList#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@tableName" value="#arguments.tableName#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@sourceDatabase" value="#arguments.sourceDatabase#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@sourceServer" value="#arguments.sourceServer#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@sourceLogin" value="#arguments.sourceLogin#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@sourcePassword" value="#arguments.sourcePassword#">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@sameServer" value="#arguments.sameServer#">
			<cfprocparam type="Out" cfsqltype="CF_SQL_BIT" variable="curResult" dbvarname="@successResult">
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