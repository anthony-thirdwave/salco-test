<cfcomponent displayname="Application">

	<!--- this variable will override any server defined siteType
			* for cf8 sites, this is where the site type is set, leaving blank creates "dev" site type
			* for cf9 sites, if server.siteType is set, if this should be "" unless 
				a site type override is needed --->
	<cfset this.overrideSiteType="">


	<!--- TODO - may be better to import settings such as "this.uniqueName" from outside Application.cfc --->

	<!--- the unique name used in database and directory defaults --->
	<cfset this.uniqueName = "cmsdemo" />
	
	<!--- default application settings --->
	<cfset this.name = "www.#this.uniqueName#.com" />
	<cfset this.applicationTimeout = createTimeSpan(1,0,0,0) />
	<cfset this.clientManagement = true />
	<cfset this.setClientCookies = true />
	<cfset this.sessionManagement = true />
	<cfset this.sessiontimeout = createTimeSpan(0,1,0,0) />
	
		
		
	<!--- this function gets the site type --->
	<cffunction name="getSiteType" returntype="string">
		
		<cfset var local = structNew() />
		
		<cfif this.overrideSiteType eq "production"
				or (trim(this.overrideSiteType) eq ""
					and structKeyExists(server, "siteType")
					and server.siteType eq "production")>
			<cfset local.siteType = "production" />
		
		<!--- else if staging --->
		<cfelseif this.overrideSiteType eq "staging"
				or (trim(this.overrideSiteType) eq ""
					and structKeyExists(server, "siteType")
					and server.siteType eq "staging")>
			<cfset local.siteType = "staging" />
		
		<!--- default to dev --->
		<cfelse>
			<cfset local.siteType = "dev" />
		</cfif>
		
		<cfreturn local.siteType />
	</cffunction>
	
	
	

	<!--- called when the application is created --->
	<cffunction name="onApplicationStart" returntype="boolean">
		
		<cfset var local = structNew() />

		<!--- initialize the application based upon the site type --->
		<cfinvoke method="initializeApplication" returnvariable="local.initializeSuccess">
		
		<!--- make sure the application is initialized --->
		<cfif not local.initializeSuccess>
			<cfreturn false />
		</cfif>
			
		<cfreturn true />
	</cffunction>
	
	
		
	
	<!--- this function initializes the application, based upon the site type --->
	<cffunction name="initializeApplication" returntype="boolean">
	
		<cfset var local = structNew() />

		<!--- figure out the siteType --->
		<cfinvoke method="getSiteType" returnvariable="local.siteType" />
		
		<!--- set the datasources (this.datasource for CF9) --->
		<cfset APPLICATION.DSN = "#this.uniqueName#_cms_#local.siteType#" />
		<cfset this.datasource = APPLICATION.DSN />
		<cfset APPLICATION.USER_DSN = APPLICATION.DSN />
		
		<!--- set the application's clientStorage name --->
		<cfset this.clientStorage="#this.uniqueName#_cms_#local.siteType#" />

			
		<!--- this path should work for most implementations --->
		<cfset local.pathPrefix = replaceNoCase(expandPath("."), "\webroot", "\", "all") />
		
		<!--- the default paths for dev, staging and production 
				- only change if root path doesn't contain webroot --->
		<cfset local.devPathPrefix = local.pathPrefix />
		<cfset local.stagingPathPrefix = local.pathPrefix />
		<cfset local.productionPathPrefix = local.pathPrefix />


		<!--- default resource paths --->
		<cfset APPLICATION.ContentResourcesPath = "resources\content\" />
		<cfset APPLICATION.CategoryResourcesPath = "resources\category\" />
		<cfset APPLICATION.ContentPath = "content\" />
		<cfset APPLICATION.CollectionName = "#this.uniqueName#_content_locale_" />
		<cfset APPLICATION.TempMapping = "/#this.uniqueName#_www_temp/" />

		<!--- default contact info --->
		<cfset APPLICATION.contactEmail = "info@thirdwavellc.com" />
		<cfset APPLICATION.CompanyName = "Thirdwave, LLC" />
		<cfset APPLICATION.CompanyStreet = "15 W. Hubbard, ##300" />
		<cfset APPLICATION.CompanyCity = "Chicago" />
		<cfset APPLICATION.CompanyState = "IL" />
		<cfset APPLICATION.CompanyZip = "60654" />
		<cfset APPLICATION.CompanyPhone = "312.329.1960" />
		<cfset APPLICATION.CompanySlogan = "Put your slogan here" />

		<!--- default misc. cms application scope variables --->
		<cfset APPLICATION.uniqueName = this.uniqueName />
		<cfset APPLICATION.SiteTitle = APPLICATION.uniqueName />
		<cfset APPLICATION.Staging = false />
		<cfset APPLICATION.Production = false />
		<cfset APPLICATION.crlf = chr(13) & chr(10) />
		<cfset APPLICATION.key = "ER08R~!90E(@ajmlWE@$)(s" />
		<cfset APPLICATION.localeID = 1 />
		<cfset APPLICATION.languageID = 100 />
		<cfset APPLICATION.CMSVersion = "5" />
		<cfset APPLICATION.GeneratorMeta = "Thirdwave MasterView" />
		<cfset APPLICATION.GeneratorContentMeta = "MasterView by Thirdwave, LLC 312.329.1960" />
		
		
		
		<cfif local.siteType eq "dev">
		
			<cfset APPLICATION.WebRootPath = "#local.devPathPrefix#webroot\" />
			<cfset APPLICATION.CollectionPath = "#local.devPathPrefix#collection\" />
			<cfset APPLICATION.WorkgroupPath = "#local.devPathPrefix#workarea\" />
			<cfset APPLICATION.ExecuteTempDir = "#local.devPathPrefix#temp\" />
			<cfset APPLICATION.LocalePath = "#APPLICATION.WebRootPath#locale\" />
			<cfset APPLICATION.SourceDBServer = "#this.uniqueName#.thirdwavellc.com" />
			<cfset APPLICATION.SourceLogin = "cfmx" />
			<cfset APPLICATION.SourcePassword = "st34l1n" />
			<cfset APPLICATION.sLocation["#this.name#"] = this.name />
			
			<!--- only used if dev --->
			<cfset APPLICATION.StagingURL = "http://staging.#this.uniqueName#.com" />

		<cfelseif local.siteType eq "staging">
			
			<cfset APPLICATION.WebRootPath = "#local.stagingPathPrefix#webroot\" />
			<cfset APPLICATION.CollectionPath = "#local.stagingPathPrefix#collection\" />
			<cfset APPLICATION.WorkgroupPath = "#local.stagingPathPrefix#workarea\" />
			<cfset APPLICATION.ExecuteTempDir = "#local.stagingPathPrefix#temp\" />
			<cfset APPLICATION.LocalePath = "#APPLICATION.WebRootPath#locale\" />
			<cfset APPLICATION.SourceDBServer = "staging.#this.uniqueName#.com" />
			<cfset APPLICATION.SourceLogin = "cfmx" />
			<cfset APPLICATION.SourcePassword = "st34l1n" />
			<cfset APPLICATION.Staging = "yes" />
			<cfset APPLICATION.sLocation["#this.name#"] = "staging.#this.uniqueName#.com" />
		<cfelse>

			<cfset APPLICATION.WebRootPath = "#local.productionPathPrefix#webroot\" />
			<cfset APPLICATION.CollectionPath = "#local.productionPathPrefix#collection\" />
			<cfset APPLICATION.WorkgroupPath = "#local.productionPathPrefix#workarea\" />
			<cfset APPLICATION.ExecuteTempDir = "#local.productionPathPrefix#temp\" />
			<cfset APPLICATION.LocalePath = "#APPLICATION.WebRootPath#locale\" />
			<cfset APPLICATION.SourceDBServer = "" />
			<cfset APPLICATION.SourceLogin = "" />
			<cfset APPLICATION.SourcePassword = "" />
			<cfset APPLICATION.Production = "yes" />
			<cfset APPLICATION.sLocation["#this.name#"] = this.name />
		</cfif>
		
		<cfset APPLICATION.TrashPath = "#APPLICATION.WorkgroupPath#trash\" />
		<cfset APPLICATION.UploadPath = "common\incoming\" />
		<cfset APPLICATION.FlashPath = "resources\flash\" />
		
		<!--- id's referring to t_Label labelId --->
		<cfset APPLICATION.SuperAdminUserGroupID = 4 /> 
		<cfset APPLICATION.ContentEditorUserGroupID = 3 />
		<cfset APPLICATION.AdminUserGroupID = 4 />
		<cfset APPLICATION.ContentCategoryTypeID = 60 />
		<cfset APPLICATION.lVisibleCategoryTypeID = "60,62,64,66,68,69,70,75,76" />
		
		<!--- id's referring to t_Label labelGroupId --->
		<cfset APPLICATION.TemplateTypeLabelGroupID = 20 />
		
		<!--- more parameters --->
		<cfset APPLICATION.DefaultLocaleID = 1 />

		<!--- UserFilesPath is the same as upload path, but with the slashes in the opposite
		direction and a slash as the prefix --->
		<cfset APPLICATION.UserFilesPath = replace(APPLICATION.UploadPath, "\", "/", "all") />
		
		<!--- add the prefix "/" if it doesn't exist --->
		<cfif left(APPLICATION.UserFilesPath, 1) neq "/">
			<cfset APPLICATION.UserFilesPath = "/" & APPLICATION.UserFilesPath />
		</cfif>
		
		<cfset APPLICATION.ImageFileExtensionList = ".jpg;.gif;.jpeg;.jpe;.swf;.png" />
		<cfset APPLICATION.DocumentFileExtensionList = ".pdf;.txt;.eps;.doc;.hqx;.sea;.ppt;.mov;.zip;.sit;.indt;.mpg;.mp3;.mp4;.xls;.key" />
		<cfset APPLICATION.MasterFileExtensionList = ListAppend(APPLICATION.ImageFileExtensionList,APPLICATION.DocumentFileExtensionList,";") />

		<!--- This is the e-mail address to which error reports should be sent.
		 It is possible to specify more than one address by making this a
		 semicolon-delimited list. --->
		<cfset APPLICATION.ErrorMailTo = "application.errors@thirdwavellc.com" />
		<cfset APPLICATION.ErrorMailFrom = "#this.uniqueName#-Error@thirdwavellc.com" />
		
		
		<!--- create common objects in the application scope --->
		<cfobject component="com.utils.utils" name="APPLICATION.utilsObj" />
		<cfset APPLICATION.utilsObj.init() />
		
		<cfobject component="com.time.Time" name="APPLICATION.timeObj" />
		<cfset APPLICATION.timeObj.init() />
		
		
		<!--- read the factory config xml into memory --->
		<cfif not isDefined("APPLICATION.FACTORYCONFIGSTATUS") and directoryExists(expandPath("/com/factory/thirdwave"))>
			
			<cfinvoke method="initFactory" returnvariable="local.factorySuccess" />
		</cfif>
		
		<!--- get all locales --->
		<cfquery name="APPLICATION.GetAllLocale" datasource="#APPLICATION.DSN#">
			SELECT		localeId, localeActive, localeName, localeAlias, localeCode, languageId,
						GMTOffset, DSTStartDateTime, DSTEndDateTime 
			FROM		t_Locale 
			ORDER BY	LocaleName
		</cfquery>
		
		<!--- create a temp dir for each locale if one doesn't exist --->
		<cfoutput query="APPLICATION.GetAllLocale">
			<cftry>
				<cfdirectory action="CREATE" directory="#APPLICATION.ExecuteTempDir##APPLICATION.GetAllLocale.LocaleID#\" />
				<cfcatch>
				</cfcatch>
			</cftry>
		</cfoutput>
		
		<cfquery name="local.GetThisLocale" dbtype="query">
			SELECT	localeId, localeActive, localeName, localeAlias, localeCode, languageId, GMTOffset,
					DSTStartDateTime, DSTEndDateTime 
			FROM	APPLICATION.GetAllLocale
			WHERE	LocaleID= <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(APPLICATION.LocaleID)#">
		</cfquery>
		
		<cfoutput query="local.GetThisLocale">
			<cfset APPLICATION.LocaleName = local.GetThisLocale.LocaleName />
			<cfset APPLICATION.LocaleAlias = local.GetThisLocale.LocaleAlias />
			<cfset APPLICATION.LocaleCode = local.GetThisLocale.LocaleCode />
		</cfoutput>
		
		
		<cfquery name="APPLICATION.GetStateProvinces" datasource="#APPLICATION.DSN#">
			SELECT		stateProvinceId, stateProvinceCode, stateProvinceName, countryCode, priority
		    FROM 		t_StateProvince
			WHERE		countrycode = <cfqueryparam cfsqltype="cf_sql_varchar" value="us">
			ORDER BY 	priority
		</cfquery>
		
		
		<cfreturn true />
	</cffunction>





	<!--- adds the factory configuration to the application scope  --->
	<cffunction name="initFactory" returntype="boolean">

		<cfset var local = structNew() />
		
		<cftry>
		
			<!--- create a factoryHelper object  --->
			<cfobject component="com.factory.thirdwave.factoryObjectUtils" name="local.factoryObjectUtilsObj">
			<cfset local.factoryObjectUtilsObj.init()>
			
			<!--- create the factory config and factory xml template configs --->
			<cfinvoke method="createFactoryConfig" returnVariable="local.factoryConf" component="#local.factoryObjectUtilsObj#" />
			<cfinvoke method="createFactoryTemplateConfig" returnVariable="local.templateConf" component="#local.factoryObjectUtilsObj#" />
			
			<!--- add the factory config and config status to the application scope --->
			<cfset "APPLICATION.FACTORYCONFIGSTATUS" = local.factoryConf.factoryConfigStatus />
			<cfset "APPLICATION.FACTORYCONFIG" = local.factoryConf.factoryConfig />
			
			<!--- add the factory template config and template config status to the application scope --->
			<cfset "APPLICATION.XMLTEMPLATECONFIGSTATUS" = local.templateConf.xmlTemplateConfigStatus />
			<cfset "APPLICATION.XMLTEMPLATECONFIG" = local.templateConf.xmlTemplateConfig />
			
			<cfcatch>
				<cfreturn false />
			</cfcatch>
		</cftry>
		
		<cfreturn true />
	</cffunction>





	<!--- called when session is created --->
	<cffunction name="OnSessionStart" returntype="void">

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

		<cfreturn />
	</cffunction>






	<!--- called before request is processed --->
	<cffunction name="OnRequestStart" returntype="boolean">
		<cfargument name="targetPage" type="string" required="true" />

		<!--- check for an application reset --->
		<cfif structKeyExists(url, "resetApplication") and url.resetApplication eq "r3s3t">
			<cfset onApplicationStart() />
		</cfif>
		
		<!--- check for a session reset --->
		<cfif structKeyExists(url, "resetSession") and url.resetSession eq "r3s3t">
			<cfset onSessionStart() />
		</cfif>
		
		<!--- if in secure, make sure nav links exit secure --->
		<cfif (CGI.SERVER_PORT EQ 443 or CGI.HTTP_Host neq CGI.SERVER_NAME) and APPLICATION.Production>
			<cfset REQUEST.GlobalNavURLPrefix = "http://#CGI.SERVER_NAME#">
		</cfif>
		
		<!--- if this request is a .cfc, then delete the onRequest method from this instance
				- fixes a bug in CF8, not necessary for CF9 --->
		<cfif listLast(arguments.targetPage,".") eq "cfc">
			<cfset structDelete(this, "onRequest") />
			<cfset structDelete(variables,"onRequest") />
		</cfif>
		
		<cfreturn true />
	</cffunction>



	<!--- called after OnRequestStart, but before request is processed
			* see Application.cfc in /com for handing of webservices, flash remoting and event gateways --->
	<cffunction name="OnRequest" returntype="void">
		<cfargument name="targetPage" type="string" required="true" />

		<!--- set encoding for form and url variables --->
		<cfset setEncoding("Form", "UTF-8") />
		<cfset setEncoding("URL", "UTF-8") />
		
		<!--- some default values --->
		<cfparam name="REQUEST.ContentGenerateMode" default="DYNAMIC">
		<cfparam name="REQUEST.ReCache" default="1">
		
		<!--- make sure pages aren't caching in browser --->
		<cfheader name="Expires" value="Mon, 06 Jan 1990 00:00:01 GMT">
		<cfheader name="Pragma" value="no-cache">
		<cfheader name="cache-control" value="no-cache">

		<!--- Include the requested page. --->
		<cfinclude template="#arguments.targetPage#" />

		<cfreturn />
	</cffunction>


	<!--- called at end of request, after processing --->
	<cffunction name="OnRequestEnd" returntype="void">

		<cfreturn />
	</cffunction>

	
	
	<!--- called at the end of a session --->
	<cffunction name="OnSessionEnd" returntype="void">
		<cfargument name="sessionScope" type="struct" required="true" />
		<cfargument name="applicationScope" type="struct" default="#StructNew()#" />

		<cfreturn />
	</cffunction>




	<!--- called at the end of the application --->
	<cffunction name="OnApplicationEnd" returntype="void">
		<cfargument name="applicationScope" type="struct" default="#StructNew()#" />

		<cfreturn />
	</cffunction>

	
	
	
	<!--- called when an uncaught exception occurs --->
	<cffunction name="OnError" returntype="void">
		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" default="" />
		
		<cfset var local = structNew() />

		<!--- only email and go to error handling page from production --->
		<cfif not isDebugMode() and APPLICATION.production>

			<!--- Get the current time.  --->
			<cfset local.ts = Now()>
			<cfif findNoCase("slurp",CGI.HTTP_USER_AGENT,1) IS "0">
				
				<cfoutput>
				
					<!--- Send the error message to each address.  --->
					<cfloop list="#APPLICATION.ErrorMailTo#" index="local.toAddress" delimiters=";">
						
						<cfmail to="#Trim(local.toAddress)#"
								from="#APPLICATION.ErrorMailFrom#"
								subject="#CGI.HTTP_HOST# Error on #DateFormat(local.ts)#, #TimeFormat(local.ts)#."
								type="HTML">
							<p>
							There was an error that occurred on the #CGI.HTTP_HOST# website on #DateFormat(local.ts)#, #TimeFormat(local.ts)#.
							</p>
							
							<p>
							Browser - #CGI.HTTP_USER_AGENT#<br>
							IP Address - #CGI.REMOTE_HOST#<br>
							Referring Page - #CGI.HTTP_REFERER#<br>
							Page - #CGI.CF_TEMPLATE_PATH#<br>
							PATH_INFO - #CGI.SCRIPT_NAME#<br>
							Query String - #CGI.QUERY_STRING#<br>
							</p>
							
							<p>
							#ARGUMENTS.exception#
							<p>
		
						</cfmail>
					</cfloop>
				</cfoutput>
			</cfif>
		
			<!--- display the error page --->
			<cflocation url="/common/error/errorhandler.cfm" addtoken="false" />
		</cfif>
		<cfreturn />
	</cffunction>

</cfcomponent>