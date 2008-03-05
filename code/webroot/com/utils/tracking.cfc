<cfcomponent displayname="Database">
	<cffunction name="track" returntype="boolean" access="public" output="false">
		<cfargument name="UserID" type="string" required="true">
		<cfargument name="Entity" type="string" required="true">
		<cfargument name="KeyID" type="numeric" required="true">
		<cfargument name="Operation" type="string" required="true">
		<cfargument name="EntityName" type="string" required="false">
			  
		<!--- init variables --->
		<cfset var InsertTracking = "">
		<cfset var Test = "">
		<cfset var qOperation = "">
		
		<cfif Trim(ARGUMENTS.UserID) IS "" OR ARGUMENTS.KeyID LTE "0" OR ARGUMENTS.Entity IS "" OR ARGUMENTS.Operation IS "">
			<cfreturn false>
		</cfif>
		
		<cfif 0><!--- Skip test --->
			<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
				<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
				<cfinvokeargument name="TableName" value="t_User">
				<cfinvokeargument name="FieldName" value="UserID">
				<cfinvokeargument name="FieldValue" value="#Val(ARGUMENTS.UserID)#">
				<cfinvokeargument name="SortFieldName" value="UserID">
				<cfinvokeargument name="SortOrder" value="Asc">
			</cfinvoke>
			<cfif test.recordCount IS "0">
				<cfreturn false>
			</cfif>
		</cfif>
		
		<cfif ARGUMENTS.Operation IS NOT "delete">
			<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
				<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
				<cfinvokeargument name="TableName" value="t_#ARGUMENTS.Entity#">
				<cfinvokeargument name="FieldName" value="#ARGUMENTS.Entity#ID">
				<cfinvokeargument name="FieldValue" value="#Val(ARGUMENTS.KeyID)#">
				<cfinvokeargument name="SortFieldName" value="#ARGUMENTS.Entity#ID">
				<cfinvokeargument name="SortOrder" value="Asc">
			</cfinvoke>
			<cfif test.recordCount IS "0">
				<cfreturn false>
			</cfif>
		</cfif>

		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qOperation">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_label">
			<cfinvokeargument name="FieldName" value="LabelCode">
			<cfinvokeargument name="FieldValue" value="#Trim(ARGUMENTS.Operation)#">
			<cfinvokeargument name="SortFieldName" value="LabelID">
			<cfinvokeargument name="SortOrder" value="Asc">
		</cfinvoke>
		<cfif qOperation.recordCount IS "0">
			<cfreturn false>
		</cfif>
		
		<cfquery name="InsertTracking" datasource="#APPLICATION.DSN#">
			INSERT INTO t_Tracking (
			UserID, 
			Entity, 
			KeyID, 
			TrackingDateTime, 
			OperationID,
			EntityName
			) VALUES (
			<cfqueryparam value="#ARGUMENTS.UserID#" cfsqltype="cf_sql_varchar" maxlength="10">,
			<cfqueryparam value="t_#Trim(ARGUMENTS.Entity)#" cfsqltype="cf_sql_varchar" maxlength="64">,
			<cfqueryparam value="#Val(ARGUMENTS.KeyID)#" cfsqltype="cf_sql_integer" maxlength="4">,
			getdate(),
			<cfqueryparam value="#Val(qOperation.LabelID)#" cfsqltype="cf_sql_integer" maxlength="4">,
			<cfif IsDefined("ARGUMENTS.EntityName")>
				<cfqueryparam value="#Trim(ARGUMENTS.EntityName)#" cfsqltype="cf_sql_varchar" maxlength="1000">
			<cfelse>
				NULL
			</cfif>
			)
		</cfquery>
		
		<cfreturn true/>
	</cffunction>  <!--- GenericIDLookup --->
	
	<cffunction name="GetTracking" returntype="string" access="public" output="false">
		<cfargument name="Entity" type="string" required="true">
		<cfargument name="KeyID" type="numeric" required="true">
		<cfargument name="Operation" type="string" required="true">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var qry_GetTracking = "">

		<cfquery name="qry_GetTracking" datasource="#APPLICATION.DSN#" maxrows="1">
			select * from qry_GetTracking WHERE Entity='t_#Trim(ARGUMENTS.Entity)#' and KeyID=#Val(ARGUMENTS.KeyID)# and OperationCode='#Trim(ARGUMENTS.Operation)#' order by TrackingDateTime Desc
		</cfquery>
		<cfif qry_GetTracking.recordCount IS "0">
			<cfset ReturnString="No information">
		<cfelse>
			<cfset ReturnString="#qry_GetTracking.OperationName# by #qry_GetTracking.UserLogin# on #DateFormat(qry_GetTracking.TrackingDateTime)# #TimeFormat(qry_GetTracking.TrackingDateTime)#">
		</cfif>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetTrackingDate" returntype="string" access="public" output="1">
		<cfargument name="Entity" type="string" required="true">
		<cfargument name="KeyID" type="numeric" required="true">
		<cfargument name="Operation" type="string" required="true">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var qry_GetTracking = "">
		
		<cfquery name="qry_GetTracking" datasource="#APPLICATION.DSN#" maxrows="1">
			select * from qry_GetTracking 
				WHERE Entity=<cfqueryparam value="t_#Trim(ARGUMENTS.Entity)#" cfsqltype="cf_sql_varchar" maxlength="64">
				and KeyID=<cfqueryparam value="#Val(ARGUMENTS.KeyID)#" cfsqltype="cf_sql_integer" maxlength="4">
				and OperationCode=<cfqueryparam value="#Trim(ARGUMENTS.Operation)#" cfsqltype="cf_sql_varchar">
				order by TrackingDateTime Desc
		</cfquery>
		<cfif qry_GetTracking.recordCount IS "0">
			<cfset ReturnString="No information">
		<cfelse>
			<cfset ReturnString="#qry_GetTracking.TrackingDateTime#">
		</cfif>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetLastTracking"  returntype="string" access="public" output="false">
		<cfargument name="Entity" type="string" required="true">
		<cfargument name="KeyID" type="numeric" required="true">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var qry_GetTracking = "">
		<cfset var ThisEntity = "">
		
		<cfif Left(Trim(ARGUMENTS.Entity),2) IS "t_">
			<cfset ThisEntity=Trim(ARGUMENTS.Entity)>
		<cfelse>
			<cfset ThisEntity="t_#Trim(ARGUMENTS.Entity)#">
		</cfif>
		<cfset ReturnString=""/>
		<cfquery name="qry_GetTracking" datasource="#APPLICATION.DSN#" maxrows="1">
			select * from qry_GetTracking 
				WHERE Entity=<cfqueryparam value="#ThisEntity#" cfsqltype="cf_sql_varchar"> 
				and KeyID=<cfqueryparam value="#Val(ARGUMENTS.KeyID)#" cfsqltype="cf_sql_integer"> 
				order by TrackingDateTime Desc
		</cfquery>
		<cfoutput query="qry_GetTracking">
			<cfset ReturnString="#OperationName# by #UserLogin# on #DateFormat(TrackingDateTime)# #TimeFormat(TrackingDateTime)#">
		</cfoutput>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetTrackingRecord"  returntype="string" access="public" output="false">
		<cfargument name="TrackingID" type="numeric" required="true">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var qry_GetTracking = "">
		
		<cfquery name="qry_GetTracking" datasource="#APPLICATION.DSN#" maxrows="1">
			select * from qry_GetTracking 
				WHERE TrackingID=<cfqueryparam value="#Val(ARGUMENTS.TrackingID)#" cfsqltype="cf_sql_integer"> 
				order by TrackingDateTime Desc
		</cfquery>
		<cfoutput query="qry_GetTracking">
			<cfset ReturnString="#OperationName# by #UserLogin# on #DateFormat(TrackingDateTime)# #TimeFormat(TrackingDateTime)#">
		</cfoutput>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetLastTrackingDateTime" returntype="string" access="public" output="false">
		<cfargument name="Entity" type="string" required="true">
		<cfargument name="KeyID" type="numeric" required="true">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var qry_GetTracking = "">
		
		<cfquery name="qry_GetTracking" datasource="#APPLICATION.DSN#" maxrows="1">
			select TrackingDateTime from qry_GetTracking WHERE Entity=<cfqueryparam value="t_#Trim(ARGUMENTS.Entity)#" cfsqltype="cf_sql_varchar">
				and KeyID=<cfqueryparam value="#Val(ARGUMENTS.KeyID)#" cfsqltype="cf_sql_integer"> 
				order by TrackingDateTime Desc
		</cfquery>
		<cfoutput query="qry_GetTracking">
			<cfset ReturnString="#TrackingDateTime#">
		</cfoutput>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetPageLastModified" returntype="string" access="public" output="false">
		<cfargument name="CategoryID" type="string" required="true">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var qry_GetTracking = "">
		<cfset var GetContent = "">
		
		<cfquery name="GetContent" datasource="#APPLICATION.DSN#">
			select ContentID from t_Content Where CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> 
		</cfquery>
		
		<cfquery name="qry_GetTracking" datasource="#APPLICATION.DSN#" maxrows="1">
			select * from qry_GetTracking WHERE 
			
			(
				(Entity=<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar">
				and KeyID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> )
				
				or
				(Entity=<cfqueryparam value="t_Content" cfsqltype="cf_sql_varchar">
				and KeyID IN (<cfqueryparam value="#ListAppend(ValueList(GetContent.ContentID),-1)#" cfsqltype="cf_sql_integer" list="yes">)
				)
			)
			and OperationID=<cfqueryparam value="501" cfsqltype="cf_sql_integer">	
			order by TrackingDateTime Desc
		</cfquery>
	
		<cfif qry_GetTracking.recordCount IS "0">
			<cfset ReturnString="No information">
		<cfelse>
			<cfset ReturnString="#qry_GetTracking.OperationName# by #qry_GetTracking.UserLogin# on #DateFormat(qry_GetTracking.TrackingDateTime)# #TimeFormat(qry_GetTracking.TrackingDateTime)#">
		</cfif>
		
		<cfreturn ReturnString>
	</cffunction>
	
</cfcomponent>  <!--- Database --->
