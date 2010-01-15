<cfcomponent extends="Application" output="true">
	
	<!--- return this --->
	<cffunction name="init" returntype="ApplicationSettings">
		<cfreturn this />
	</cffunction>


	<!--- this function initializes the application, based upon the site type --->
	<cffunction name="initializeApplication" returntype="boolean">
	
		<cfset var local = structNew() />
		
		<!--- get the site type --->
		<cfinvoke method="getSiteType" returnvariable="local.siteType" />
		<cfinvoke method="getUniqueName" returnvariable="local.uniqueName" />
		
		<!--- set the datasources  --->
		<cfinvoke method="getDatasource" returnvariable="APPLICATION.DSN" />
		<cfset APPLICATION.USER_DSN = APPLICATION.DSN />
			
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
		<cfset APPLICATION.CollectionName = "#local.uniqueName#_content_locale_" />
		<cfset APPLICATION.TempMapping = "/#local.uniqueName#_www_temp/" />

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
		<cfset APPLICATION.uniqueName = local.uniqueName />
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
			<cfset APPLICATION.SourceDBServer = "#local.uniqueName#.thirdwavellc.com" />
			<cfset APPLICATION.SourceLogin = "cfmx" />
			<cfset APPLICATION.SourcePassword = "st34l1n" />
			<cfset APPLICATION.sLocation["#APPLICATION.applicationName#"] = APPLICATION.applicationName />
			
			<!--- only used if dev --->
			<cfset APPLICATION.StagingURL = "http://staging.#local.uniqueName#.com" />

		<cfelseif local.siteType eq "staging">
			
			<cfset APPLICATION.WebRootPath = "#local.stagingPathPrefix#webroot\" />
			<cfset APPLICATION.CollectionPath = "#local.stagingPathPrefix#collection\" />
			<cfset APPLICATION.WorkgroupPath = "#local.stagingPathPrefix#workarea\" />
			<cfset APPLICATION.ExecuteTempDir = "#local.stagingPathPrefix#temp\" />
			<cfset APPLICATION.LocalePath = "#APPLICATION.WebRootPath#locale\" />
			<cfset APPLICATION.SourceDBServer = "staging.#local.uniqueName#.com" />
			<cfset APPLICATION.SourceLogin = "cfmx" />
			<cfset APPLICATION.SourcePassword = "st34l1n" />
			<cfset APPLICATION.Staging = "yes" />
			<cfset APPLICATION.sLocation["#APPLICATION.applicationName#"] = "staging.#local.uniqueName#.com" />
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
			<cfset APPLICATION.sLocation["#APPLICATION.applicationName#"] = APPLICATION.applicationName />
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
		<cfset APPLICATION.MasterFileExtensionList = listAppend(APPLICATION.ImageFileExtensionList,APPLICATION.DocumentFileExtensionList,";") />

		<!--- This is the e-mail address to which error reports should be sent.
		 It is possible to specify more than one address by making this a
		 semicolon-delimited list. --->
		<cfset APPLICATION.ErrorMailTo = "application.errors@thirdwavellc.com" />
		<cfset APPLICATION.ErrorMailFrom = "#local.uniqueName#-Error@thirdwavellc.com" />
		
		
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
	<cffunction name="initFactory" returntype="boolean" access="private">

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
	
	
	
</cfcomponent>