<cfcomponent>
	<cffunction name="GetUserLogin" output="false" returntype="string">
		<cfargument name="UserID" default="" type="numeric" required="true">
		
		<!--- init variables --->
		<cfset var CheckAlias = "">
		
		<cfquery name="CheckAlias" datasource="#APPLICATION.DSN#">
			SELECT UserName from t_user Where UserID=#Val(ARGUMENTS.UserID)#
		</cfquery>
		<cfreturn CheckAlias.UserName>
	</cffunction>
	
</cfcomponent>