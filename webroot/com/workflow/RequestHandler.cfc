<cffunction name="GetRequestTypes" output="false" returntype="query">
	
	<cfset var local = structNew() />
	
	<cfquery name="local.GetTypes" datasource="#APPLICATION.DSN#">
		SELECT		LabelID as RequestTypeID, LabelName as RequestTypeName
		FROM		t_Label
		WHERE		LabelGroupID = <cfqueryparam value="19000" cfsqltype="cf_sql_integer">
		ORDER BY	LabelPriority
	</cfquery>
	<cfreturn local.GetTypes>
</cffunction>

<cffunction name="ToggleDismiss" output="false" returntype="boolean">
	<cfargument name="Dismiss" default="-1" type="numeric" required="true">
	<cfargument name="RequestID" default="-1" type="numeric" required="true">
	
	<cfset var local = structNew() />
	
	<cfif ARGUMENTS.RequestID GT "0" and Val(ARGUMENTS.Dismiss) GTE "0">
		<cfquery name="local.processRequest" datasource="#APPLICATION.DSN#">
			UPDATE	t_WorkflowRequest
			SET		Dismissed = <cfqueryparam value="#Val(ARGUMENTS.Dismiss)#" cfsqltype="cf_sql_integer">
			WHERE	WorkflowRequestID = <cfqueryparam value="#Val(ARGUMENTS.RequestID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="OutstandingPublishRequest" output="false" returntype="query">
	<cfargument name="CategoryID" default="-1" type="numeric" required="true">
	
	<cfset var local = structNew() />
	
	<cfquery name="local.OutstandingPublishRequest" datasource="#APPLICATION.DSN#" maxrows="1">
		SELECT		* 
		FROM		qry_GetWorkflowRequest
		WHERE		WorkflowRequestTypeID = <cfqueryparam value="19001" cfsqltype="cf_sql_integer"> <!--- 19001 is a request to publish ---> 
		AND			CategoryID = <cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		AND			WorkflowStatusID <> <cfqueryparam value="18000" cfsqltype="cf_sql_integer"> <!--- 18000 is published --->
		AND			Dismissed = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
		ORDER BY	WorkFlowRequestDateTime DESC
	</cfquery>
	<cfreturn local.OutstandingPublishRequest>
</cffunction>

<cffunction name="DismissOutstandingPublishRequest" output="false" returntype="boolean">
	<cfargument name="CategoryID" default="-1" type="numeric" required="true">
	
	<cfset var local = structNew() />
	
	<cfquery name="local.OutstandingPublishRequest" datasource="#APPLICATION.DSN#" maxrows="1">
		UPDATE	t_WorkflowRequest
		SET		Dismissed=1
		WHERE	WorkflowRequestTypeID = <cfqueryparam value="19001" cfsqltype="cf_sql_integer"> <!--- 19001 is a request to publish --->
		AND		CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> 
	</cfquery>
	<cfreturn 1>
</cffunction>

<cffunction name="GetRequestByCategory" output="false" returntype="query">
	<cfargument name="CategoryID" default="-1" type="numeric" required="true">
	<cfargument name="ParamStatusID" default="0" type="numeric" required="true">
	<cfargument name="ParamTypeID" default="0" type="numeric" required="true">
	<cfargument name="ParamOrderBy" default="0" type="numeric" required="true">
	
	<cfset var local = structNew() />
	
	<cfswitch expression="#ARGUMENTS.ParamOrderBy#">
		<cfcase value="2">
			<cfset local.thisSortOrder="Order By CategoryName">
		</cfcase>
		<cfcase value="3">
			<cfset local.thisSortOrder="Order By FromLastName, FromFirstName">
		</cfcase>
		<cfcase value="4">
			<cfset local.thisSortOrder="Order By RecipientLastName, RecipientFirstName">
		</cfcase>
		<cfdefaultcase>
			<cfset local.thisSortOrder="Order By WorkflowRequestDateTime DESC">
		</cfdefaultcase>
	</cfswitch>

	<cfquery name="local.GetWF" datasource="#APPLICATION.DSN#">
		SELECT	* 
		FROM	qry_GetWorkflowRequest
		WHERE	1=1
		<cfif val(arguments.ParamStatusID) is "0">
			AND Dismissed=<cfqueryparam value="0" cfsqltype="cf_sql_integer">
		<cfelseif val(arguments.ParamStatusID) is "1">
			AND Dismissed=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
		</cfif>
		<cfif val(arguments.ParamTypeID) gt "0">
			AND WorkflowRequestTypeID=<cfqueryparam value="#Val(ARGUMENTS.ParamTypeID)#" cfsqltype="cf_sql_integer">
		</cfif>
		and CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		#local.thisSortOrder#
	</cfquery>
	<cfreturn local.GetWF>
</cffunction>

<cffunction name="GetRequests" output="false" returntype="query">
	<cfargument name="UserID" default="0" type="numeric" required="true">
	<cfargument name="UserGroupIDList" default="0" type="string" required="true">
	<cfargument name="ParamStatusID" default="0" type="numeric" required="true">
	<cfargument name="ParamTypeID" default="0" type="numeric" required="true">
	<cfargument name="ParamOrderBy" default="0" type="numeric" required="true">
	
	<cfset var local = structNew() />
	
	<cfswitch expression="#ARGUMENTS.ParamOrderBy#">
		<cfcase value="2">
			<cfset local.thisSortOrder="Order By CategoryName">
		</cfcase>
		<cfcase value="3">
			<cfset local.thisSortOrder="Order By FromLastName, FromFirstName">
		</cfcase>
		<cfcase value="4">
			<cfset local.thisSortOrder="Order By RecipientLastName, RecipientFirstName">
		</cfcase>
		<cfdefaultcase>
			<cfset local.thisSortOrder="Order By WorkflowRequestDateTime DESC">
		</cfdefaultcase>
	</cfswitch>

	<cfquery name="local.GetWF" datasource="#APPLICATION.DSN#">
		SELECT	* 
		FROM	qry_GetWorkflowRequest
		WHERE 
		(
			RecipientUserID=<cfqueryparam value="#Val(ARGUMENTS.UserID)# " cfsqltype="cf_sql_integer">OR 
			FromUserID=<cfqueryparam value="#Val(ARGUMENTS.UserID)# " cfsqltype="cf_sql_integer"> OR 
			RecipientUserGroupID IN (<cfqueryparam value="#ARGUMENTS.UserGroupIDList#" cfsqltype="cf_sql_integer" list="yes">)
		)
		<cfif val(arguments.ParamStatusID) is "0">
			AND Dismissed=<cfqueryparam value="0" cfsqltype="cf_sql_integer">
		<cfelseif val(arguments.ParamStatusID) is "1">
			AND Dismissed=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
		</cfif>
		<cfif val(arguments.ParamTypeID) gt "0">
			AND WorkflowRequestTypeID=<cfqueryparam value="#Val(ARGUMENTS.ParamTypeID)#" cfsqltype="cf_sql_integer">
		</cfif>
		#local.thisSortOrder#
	</cfquery>
	<cfreturn local.GetWF>
</cffunction>

<cffunction name="GetRequest" output="false" returntype="query">
	<cfargument name="WorkflowRequestID" default="0" type="numeric" required="true">

	<cfset var local = structNew() />

	<cfquery name="local.GetWF" datasource="#APPLICATION.DSN#">
		SELECT	* 
		FROM	qry_GetWorkflowRequest
		WHERE	WorkflowRequestID = <cfqueryparam value="#Val(ARGUMENTS.WorkflowRequestID)# " cfsqltype="cf_sql_integer">
	</cfquery>
	<cfreturn local.GetWF>
</cffunction>
