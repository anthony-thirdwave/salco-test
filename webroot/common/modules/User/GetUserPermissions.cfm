<cfparam name="ATTRIBUTES.UserGroupID" default="-1">
<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.Action" default="">

<cfset CALLER.PermissionAllowed="No">
<cfif ATTRIBUTES.UserGroupID LTE "0" OR ATTRIBUTES.CategoryID LTE "0" OR ATTRIBUTES.Action IS "">
	<!--- Do nothing --->
<cfelse>
	<cfif ATTRIBUTES.UserGroupID IS "#APPLICATION.SuperAdminUserGroupID#">
		<cfset CALLER.PermissionAllowed="Yes">
	<cfelse>
		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			select * from t_permissions
			Where 
			userGroupID IN (<cfqueryparam value="#ATTRIBUTES.UserGroupID#" cfsqltype="cf_sql_integer" list="yes">) AND 
			CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.CategoryID#">
		</cfquery>
		<cfoutput query="Check">
			<cfswitch expression="#ATTRIBUTES.Action#">
				<cfcase value="Read">
					<cfif Check.pRead>
						<cfset CALLER.PermissionAllowed="Yes">
					</cfif>
				</cfcase>
				<cfcase value="Create">
					<cfif Check.pCreate>
						<cfset CALLER.PermissionAllowed="Yes">
					</cfif>
				</cfcase>
				<cfcase value="Edit">
					<cfif Check.pEdit>
						<cfset CALLER.PermissionAllowed="Yes">
					</cfif>
				</cfcase>
				<cfcase value="Delete">
					<cfif Check.pDelete>
						<cfset CALLER.PermissionAllowed="Yes">
					</cfif>
				</cfcase>
				<cfcase value="SaveLive">
					<cfif Check.pSaveLive>
						<cfset CALLER.PermissionAllowed="Yes">
					</cfif>
				</cfcase>
				<cfcase value="Manage">
					<cfif Check.pManage>
						<cfset CALLER.PermissionAllowed="Yes">
					</cfif>
				</cfcase>
			</cfswitch>
		</cfoutput>
	</cfif>
</cfif>