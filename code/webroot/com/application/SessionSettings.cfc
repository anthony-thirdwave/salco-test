<cfcomponent extends="Application" output="true">

	<!--- return this --->
	<cffunction name="init" returntype="SessionSettings" output="false">
		<cfreturn this />
	</cffunction>


	<!--- this function initializes the session --->
	<cffunction name="initializeSession" returntype="boolean" output="false">

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
		<cftry>
			<CF_BrowserCheck>
			<cfcatch>
			</cfcatch>
		</cftry>

		<cfif isDefined("BC_BROWSER")>
			<cfif BC_BROWSER contains "MSIE">
				<cfset session.CurrentBrowserApp="IE" />
			<cfelse>
				<cfset session.CurrentBrowserApp="NS" />
			</cfif>
		<cfelse>
			<cfset session.CurrentBrowserApp = "Unknown" />
		</cfif>

		<cfif isDefined("BC_OS")>
			<cfif BC_OS contains "mac">
				<cfset session.CurrentOS="Mac">
			<cfelse>
				<cfset session.CurrentOS="PC">
			</cfif>
		<cfelse>
			<cfset session.CurrentOS = "Unknown" />
		</cfif>

		<cfif isDefined("BC_BROWSER")>
			<cfset session.CurrentBrowserVersion=BC_VERSION>
		<cfelse>
			<cfset session.CurrentBrowserVersion="0">
		</cfif>

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