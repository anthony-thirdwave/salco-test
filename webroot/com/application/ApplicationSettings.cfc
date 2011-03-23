<cfcomponent extends="Application" output="true">

	<!--- return this --->
	<cffunction name="init" returntype="ApplicationSettings" output="false">
		<cfreturn this />
	</cffunction>


	<!--- this function initializes the application, based upon the site type --->
	<cffunction name="initializeApplication" returntype="boolean" output="false">
		<cfargument name="pathPrefix" required="true" type="string" />

		<cfset var local = structNew() />

		<!--- get the site type - functions defined in Application.cfc, which this extends --->
		<cfinvoke method="getSiteType" returnvariable="local.siteType" />
		<cfinvoke method="getUniqueName" returnvariable="local.uniqueName" />

		<!--- set the datasources  --->
		<cfinvoke method="getDatasource" returnvariable="APPLICATION.DSN" />
		<cfset APPLICATION.USER_DSN = APPLICATION.DSN />

		<!--- this path should work for most implementations --->
		<cfset arguments.pathPrefix = replaceNoCase(arguments.pathPrefix, "\webroot", "", "all") />

		<!--- the default paths for dev, staging and production
				- only change if root path doesn't contain webroot --->
		<cfset local.devPathPrefix = arguments.pathPrefix />
		<cfset local.stagingPathPrefix = arguments.pathPrefix />
		<cfset local.productionPathPrefix = arguments.pathPrefix />

		<!--- default resource paths --->
		<cfset APPLICATION.ContentResourcesPath = "resources\content\" />
		<cfset APPLICATION.CategoryResourcesPath = "resources\category\" />
		<cfset APPLICATION.ContentPath = "content\" />
		<cfset APPLICATION.CollectionName = "#local.uniqueName#_#local.siteType#_content_locale_" />
		<cfset APPLICATION.TempMapping = "/#local.uniqueName#_www_temp/" />
		<cfset APPLICATION.RootPath=arguments.pathPrefix>

		<!--- default contact info --->
		<cfset APPLICATION.contactEmail = "contact@salcoproducts.com" />
		<cfset APPLICATION.CompanyName = "Salco Products" />
		<cfset APPLICATION.CompanyStreet = "" />
		<cfset APPLICATION.CompanyCity = "" />
		<cfset APPLICATION.CompanyState = "" />
		<cfset APPLICATION.CompanyZip = "" />
		<cfset APPLICATION.CompanyPhone = "" />
		<cfset APPLICATION.CompanySlogan = "" />

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
		<cfset APPLICATION.CategoryAlias404Page="404-page">
		<cfset APPLICATION.CategoryID404Page="5701">
		<cfset APPLICATION.defaultSiteCategoryID="1">

		<!---
			determine how content.cfm is called - default .htaccess is formatted to deal with the following permutations
			a) "/content.cfm" - non seo links (e.g. "http://www.thirdwavellc.com/content.cfm/about")
			b) "" - seo links defined purely by contentAlias (e.g. "http://www.thirdwavellc.com/about")
			c) "/yourstringhere" - any string that you want to go before the contentAlias (e.g. "http://www.thirdwavellc.com/page/about")
		--->
		<cfset APPLICATION.contentPageInUrl = "/page" />

		<!--- clean up contentPageInUrl --->
		<cfset APPLICATION.contentPageInUrl = trim(APPLICATION.contentPageInUrl) />
		<cfif len(APPLICATION.contentPageInUrl)>
			<!--- make sure contentPageInUrl has a leading slash --->
			<cfif left(APPLICATION.contentPageInUrl, 1) neq "/">
				<cfset APPLICATION.contentPageInUrl = "/" & APPLICATION.contentPageInUrl />
			</cfif>
			<!--- and no trailing slash --->
			<cfif right(APPLICATION.contentPageInUrl, 1) eq "/">
				<cfset APPLICATION.contentPageInUrl = mid(APPLICATION.contentPageInUrl, 1, len(APPLICATION.contentPageInUrl) - 1) />
			</cfif>
		</cfif>

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

			<!---	set custom httpServer and httpsServer - *both* must be set to work properly
					e.g.: http://www.mySite.com and https://secure.mySite.com --->
			<cfset APPLICATION.httpServerOverride = "" />
			<cfset APPLICATION.httpsServerOverride = "" />
			<cfset APPLICATION.httpsPortOverride = "" />

			<!--- is ssl set up for the dev site? --->
			<cfset APPLICATION.SSLConfigured = false />

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

			<!---	set custom httpServer and httpsServer - *both* must be set to work properly
					e.g.: http://www.mySite.com and https://secure.mySite.com --->
			<cfset APPLICATION.httpServerOverride = "" />
			<cfset APPLICATION.httpsServerOverride = "" />
			<cfset APPLICATION.httpsPortOverride = "" />

			<!--- is ssl set up for the staging site? --->
			<cfset APPLICATION.SSLConfigured = false />

		<cfelse>

			<cfset APPLICATION.WebRootPath = "#local.productionPathPrefix#webroot\" />
			<cfset APPLICATION.CollectionPath = "#local.productionPathPrefix#collection\" />
			<cfset APPLICATION.WorkgroupPath = "#local.productionPathPrefix#workarea\" />
			<cfset APPLICATION.ExecuteTempDir = "#local.productionPathPrefix#temp\" />
			<cfset APPLICATION.LocalePath = "#APPLICATION.WebRootPath#locale\" />
			<cfset APPLICATION.SourceDBServer = "" />
			<cfset APPLICATION.SourceLogin = "" />
			<cfset APPLICATION.SourcePassword = "" />
			<cfset APPLICATION.Production = true />
			<cfset APPLICATION.sLocation["#APPLICATION.applicationName#"] = APPLICATION.applicationName />

			<!---	set custom httpServer and httpsServer - *both* must be set to work properly
					e.g.: http://www.mySite.com and https://secure.mySite.com --->
			<cfset APPLICATION.httpServerOverride = "" />
			<cfset APPLICATION.httpsServerOverride = "" />
			<cfset APPLICATION.httpsPortOverride = "" />

			<!--- is ssl set up for the production site? --->
			<cfset APPLICATION.SSLConfigured = false />

		</cfif>


		<!--- there are *both* custom httpServer and httpsServer names --->
		<cfif len(trim(APPLICATION.httpServerOverride)) and len(trim(APPLICATION.httpsServerOverride))>
			<cfset APPLICATION.httpServer = APPLICATION.httpServerOverride />
			<cfset APPLICATION.httpsServer = APPLICATION.httpsServerOverride />
		<!--- default https and http server names --->
		<cfelse>
			<cfset APPLICATION.httpServer = "http://" & CGI.SERVER_NAME />
			<cfset APPLICATION.httpsServer = "https://" & CGI.SERVER_NAME />
		</cfif>

		<!--- if there's a port defined for https --->
		<cfif isNumeric(APPLICATION.httpsPortOverride)>
			<cfset APPLICATION.httpsPort = APPLICATION.httpsPortOverride />
		<cfelse>
			<cfset APPLICATION.httpsPort = "443" />
		</cfif>

		<cfset APPLICATION.TrashPath = "#APPLICATION.WorkgroupPath#trash\" />
		<cfset APPLICATION.UploadPath = "common\incoming\" />
		<cfset APPLICATION.FlashPath = "resources\flash\" />

		<!--- id's referring to t_Label labelId --->
		<cfset APPLICATION.SuperAdminUserGroupID = 4 />
		<cfset APPLICATION.ContentEditorUserGroupID = 3 />
		<cfset APPLICATION.AdminUserGroupID = 4 />
		<cfset APPLICATION.ContentCategoryTypeID = 60 />
		<cfset APPLICATION.lVisibleCategoryTypeID = "60,62,64,66,68,69,70,75,76,77,78" />

		<!--- id's referring to t_Label labelGroupId --->
		<cfset APPLICATION.TemplateTypeLabelGroupID = 20 />

		<!--- more parameters --->
		<cfset APPLICATION.DefaultLocaleID = 1 />
		<cfset APPLICATION.DefaultLanguageID = 100 />

		<cfset APPLICATION.ImageFileExtensionList = ".jpg;.gif;.jpeg;.jpe;.swf;.png" />
		<cfset APPLICATION.DocumentFileExtensionList = ".pdf;.txt;.eps;.doc;.hqx;.sea;.ppt;.mov;.zip;.sit;.indt;.mpg;.mp3;.mp4;.xls;.key;.vcf" />
		<cfset APPLICATION.MasterFileExtensionList = listAppend(APPLICATION.ImageFileExtensionList,APPLICATION.DocumentFileExtensionList,";") />

		<!--- This is the e-mail address to which error reports should be sent.
		 It is possible to specify more than one address by making this a
		 semicolon-delimited list. --->
		<cfset APPLICATION.ErrorMailTo = "thomas@newermedia.com" />
		<cfset APPLICATION.ErrorMailFrom = "#local.uniqueName#-Error@thirdwavellc.com" />


		<!--- create common objects in the application scope --->
		<cfobject component="com.utils.utils" name="APPLICATION.utilsObj" />
		<cfset APPLICATION.utilsObj.init() />

		<cfobject component="com.time.Time" name="APPLICATION.timeObj" />
		<cfset APPLICATION.timeObj.init() />

		<cfobject component="com.utils.Message" name="APPLICATION.messageObj" />
		<cfset APPLICATION.messageObj.init() />

		<cfobject component="com.ContentManager.CategoryHandler" name="APPLICATION.MyCategoryHandler" />
		<cfset APPLICATION.MyCategoryHandler.init() />

		<cfinvoke method="GetCategoryIDFromAlias" component="#APPLICATION.MyCategoryHandler#"
			CategoryAlias="#APPLICATION.CategoryAlias404Page#"
			returnVariable="APPLICATION.CategoryID404Page"/>

		<!--- get ssl pages --->
		<cfif APPLICATION.SSLConfigured>
			<cfinvoke method="getSSLStruct" returnvariable="APPLICATION.sslCategories" />
		</cfif>

		<!--- read the factory config xml into memory --->
		<cfif directoryExists("#APPLICATION.WebRootPath#com/factory/thirdwave")>

			<!--- create a factoryUtils object in memory --->
			<cfobject component="com.factory.thirdwave.FactoryObjectUtils" name="APPLICATION.factoryUtilsObj" />
			<cfset APPLICATION.factoryUtilsObj.init() />

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

		<cfquery name="APPLICATION.GetCountries" datasource="#APPLICATION.DSN#">
			SELECT		countryId, countryCode, countryName, priority
			FROM		t_Country
			ORDER BY	IsNull(priority, 10000), CountryName
		</cfquery>

		<cfreturn true />
	</cffunction>





	<!--- adds the factory configuration to the application scope  --->
	<cffunction name="initFactory" returntype="boolean" access="private" output="false">

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



	<!--- get a struct with the categories that use SSL --->
	<cffunction name="getSSLStruct" returntype="struct" output="false">

		<cfset var local = structNew() />
		<cfset local.returnStruct = structNew() />

		<!--- get categories that use SSL --->
		<cfquery name="local.getCategoryInfo" datasource="#APPLICATION.DSN#">
			SELECT	c.categoryId
			FROM	t_Category c
			JOIN	t_Properties p
			ON		p.propertiesId = c.propertiesId
			WHERE	CAST(p.propertiesPacket AS XML).value('(//var[@name = "useSSL"]/string[text()="1"])[1]','int') = 1
		</cfquery>

		<!--- add them to the struct --->
		<cfloop query="local.getCategoryInfo">
			<cfset local.returnStruct["ssl_" & local.getCategoryInfo.categoryId] = true />
		</cfloop>

		<cfreturn local.returnStruct />
	</cffunction>

</cfcomponent>