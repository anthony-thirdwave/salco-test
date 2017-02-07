<cfcomponent>
	<cffunction access="public" name="authenticate" output="0" returntype="query" hint="Return user record with corresponding username and password."><!--- security authentication function --->
		<!--- username and password required --->
		<cfargument name="Username" type="string" required="1"/>
		<cfargument name="Password" type="string" required="1"/>
		
		<!--- init variables --->
		<cfset var GetUser = "">
		
		<!--- query the SecurityDB for the passed username and password --->
		<cfquery name="GetUser" datasource="#APPLICATION.User_DSN#">
			SELECT	UserID, UserLogin, UserPassword, LocaleID
			FROM	t_User
			WHERE	UserLogin = <cfqueryparam value="#trim(arguments.Username)#" cfsqltype="cf_sql_varchar">
			AND		UserPassword = <cfqueryparam value="#trim(arguments.Password)#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<!--- return the appropriate result --->
		<!--- if no match is found, then an empty query is returned --->
		<cfreturn GetUser/>
	</cffunction>
	<cffunction access="public" name="GetBlank" output="0" returntype="query" hint="Return a blank user record."><!--- return a blank record --->
		
		<!--- init variables --->
		<cfset var GetUser = "">
		
		<cfquery name="GetUser" datasource="#APPLICATION.User_DSN#">
			SELECT	UserID, UserLogin, UserPassword, LocaleID 
			FROM	t_User
			WHERE	1=0
		</cfquery>
		<cfreturn GetUser/>
	</cffunction>
	<cffunction access="public" name="GetUserGroupID" output="0" returntype="string" hint="Return list of Group ID's of corresponding user id."><!--- return list of GroupID's that user belongs to --->
		<!--- username and password required --->
		<cfargument name="UserID" type="numeric" required="1"/>
		
		<!--- init variables --->
		<cfset var getUserGroups = "">
		
		<!--- query the SecurityDB for the passed username get all groups --->
		<cfquery name="getUserGroups" datasource="#APPLICATION.User_DSN#">
			SELECT		UserGroupID
			FROM		t_UserGroup
			WHERE		UserID = <cfqueryparam value="#Val(arguments.UserID)#" cfsqltype="cf_sql_integer">
			ORDER BY	UserGroupID
		</cfquery>		
		<!--- return the appropriate result --->
		
		<cfreturn ValueList(GetUserGroups.UserGroupID)/>
	</cffunction>
</cfcomponent>