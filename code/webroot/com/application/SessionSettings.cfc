<cfcomponent extends="Application" output="true">
	
	<!--- return this --->
	<cffunction name="init" returntype="SessionSettings">
		<cfreturn this />
	</cffunction>

	
	<!--- this function initializes the session --->
	<cffunction name="initializeSession" returntype="struct">
	
		<cfset var local = structNew() />

		<!--- if we've come here manually, then clear the session --->
		<cfif structKeyExists(session, "sessionID")>

			<!--- grab a copy of cfid and cftoken --->
			<cfset local.cfid = session.cfid />
			<cfset local.cftoken = session.cftoken />

			<!--- clear the session values --->
			<cfset structClear(session) />
			
			<!--- set the cfid and cftoken to the original values --->
			<cfset session.cfid = local.cfid />
			<cfset session.cftoken = local.cftoken />
		</cfif>
		
		<!--- this is used for session locking --->
		<cfset session.sessionID = CreateUUID()>

		<!--- Pull the browser information into session scope  --->
		<CF_BrowserCheck>
		
		<cfif BC_BROWSER CONTAINS "MSIE">
			<cfset session.CurrentBrowserApp="IE">
		<cfelse>
			<cfset session.CurrentBrowserApp="NS">
		</cfif>
		
		<cfif BC_OS CONTAINS "mac">
			<cfset session.CurrentOS="Mac">
		<cfelse>
			<cfset session.CurrentOS="PC">
		</cfif>
		
		<cfset session.CurrentBrowserVersion=BC_VERSION>

		<!--- init User ID, login and password --->
		<cfset session.UserID = "" />
		<cfset session.UserLogin = "" />
		<cfset session.UserPassword = "" />
		<cfset session.UserRolesIDList = "-1" />
		<cfset session.CurrentAdminLocaleID = "-1" />
		
		<!--- get the info for this locale --->
		<cfquery name="local.GetLang" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT LanguageID,LocaleCode,LocaleName 
			FROM t_Locale 
			WHERE LocaleID = <cfqueryparam value="#Val(session.CurrentAdminLocaleID)#" cfsqltype="cf_sql_integer" maxlength="4">
		</cfquery>
		
		<!--- defaults for admin users --->
		<cfset session.CurrentAdminLanguageID = val(local.GetLang.LanguageID)>
		<cfset session.CurrentAdminLocaleCode = trim(local.GetLang.LocaleCode)>
		<cfset session.CurrentAdminLocaleName = trim(local.GetLang.LocaleName)>
		
		<cfset session.AdminUserID = "" />
		<cfset session.AdminUserLogin = "" />
		<cfset session.AdminUserPassword = "" />
		<cfset session.AdminUserGroupIDList = "" />
		<cfset session.AdminUserLocaleID = "" />
		<cfset session.AdminCurrentAdminLocaleID = "" />
		<cfset session.lPageIDView = "" />
		
		
		<cfreturn true />
	</cffunction>

	
	
</cfcomponent>