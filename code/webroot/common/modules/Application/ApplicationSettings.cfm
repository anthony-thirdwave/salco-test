<cfcontent type="text/html; charset=UTF-8">
<cfscript>
setEncoding("Form", "UTF-8");
setEncoding("URL", "UTF-8");
</cfscript>

<cfset REQUEST.CGIPathInfo=CGI.script_name>
<cfset REQUEST.CGIQueryString=CGI.Query_string>
<cfset REQUEST.CGIHTTPHost=CGI.HTTP_Host>
<cfset REQUEST.CGIRequestURI=CGI.REQUEST_URI>
<cfset REQUEST.BaseDomainName=CGI.SERVER_NAME>

<cfparam name="REQUEST.ContentGenerateMode" default="DYNAMIC">
<cfparam name="REQUEST.ReCache" default="1">

<!--- make sure pages aren't caching in browser --->
<cfheader name="Expires" value="Mon, 06 Jan 1990 00:00:01 GMT"> 
<cfheader name="Pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache">

<!--- <cfsetting showdebugoutput="No"> --->

<cfset MustResetAppVars = FALSE>
<cfif IsDefined("URL.ResetApplication")>
	<cfif URL.ResetApplication EQ "r3s3t">
		<cfset MustResetAppVars = TRUE>
	</cfif>  <!--- password was correct  --->
</cfif>  <!--- we are to reset the application variables  --->
<cfif NOT MustResetAppVars>
	<!--- Have the variables been set yet?  The presence of the variable
		  Application.AppVarsSet as a true value signifies that the variables do not
		  need to be set again.  --->
	<cflock type="ReadOnly" name="#Application.ApplicationName#" timeout="1">
		<cfset MustResetAppVars = (NOT IsDefined("Application.AppVarsSet"))>
	</cflock>
</cfif>
<!--- Post-condition:  MustResetAppVars is a Boolean which tells us whether or
	  not we have to reset the application scope variables.  --->

<!--- If we have to reset the application scope, do so.  Exception:  In debug
	  mode, the application scope is ALWAYS reset with every hit.  --->
<cfif MustResetAppVars or IsDebugMode()>
	<cflock type="Exclusive" name="#Application.ApplicationName#" timeout="1">
		<cfscript>
		
		// This variable dictates the naming constructs for site defaults - set in ApplicationSetup.cfm
		APPLICATION.UniqueName = ThisUniqueName;
		
		// Basic settings
		Application.DirectorySeparator="\";
		APPLICATION.SiteName="#APPLICATION.UniqueName#_www";
		APPLICATION.TempMapping="/#APPLICATION.UniqueName#_www_temp/";
		APPLICATION.SaveToProductionDSN="";
		APPLICATION.CRLF=Chr(13) & Chr(10);
		APPLICATION.Key="ER08R~!90E(@ajmlWE@$)(s";
		APPLICATION.DSN=ThisDSN;
		APPLICATION.USER_DSN=APPLICATION.DSN;
		APPLICATION.ContactEmail="info@thirdwavellc.com";

		// CMS info
		APPLICATION.CMSVersion="5";
		APPLICATION.GeneratorMeta="Thirdwave MasterView";
		APPLICATION.GeneratorContentMeta="MasterView by Thirdwave, LLC 312.329.1960";
		
		// Resource paths
		APPLICATION.ContentResourcesPath="resources\content\";
		APPLICATION.CategoryResourcesPath="resources\category\";
		APPLICATION.ContentPath="content\";
		APPLICATION.CollectionName="#APPLICATION.UniqueName#_content_locale_";
		
		// Server-specific settings
		APPLICATION.Production="no";
		APPLICATION.Staging="no";
		
		// the site title
		APPLICATION.SiteTitle=APPLICATION.UniqueName;
		
		// company info
		APPLICATION.CompanyName="Thirdwave, LLC";
		APPLICATION.CompanyStreet="15 W. Hubbard, ##300";
		APPLICATION.CompanyCity="Chicago";
		APPLICATION.CompanyState="IL";
		APPLICATION.CompanyZip="60654";
		APPLICATION.CompanyPhone="312.329.1960";
		APPLICATION.CompanySlogan="Put your slogan here";
		

		if (ThisSiteType IS "dev") {
			
			// PathPrefix is a default - replace this with the path to the site
			APPLICATION.PathPrefix="C:\work\currentCore\";
			APPLICATION.WebRootPath="#APPLICATION.PathPrefix#webroot\";
			APPLICATION.CollectionPath="#APPLICATION.PathPrefix#collection\";
			APPLICATION.WorkgroupPath="#APPLICATION.PathPrefix#workarea\";
			APPLICATION.ExecuteTempDir="#APPLICATION.PathPrefix#temp\";
			APPLICATION.LocalePath="#APPLICATION.WebRootPath#locale";
			APPLICATION.SourceDBServer="#APPLICATION.UniqueName#.thirdwavellc.com";
			APPLICATION.SourceLogin="cfmx";
			APPLICATION.SourcePassword="st34l1n";
			
			// only used if dev
			APPLICATION.StagingURL="http://www.staging.thirdwavellc.com";

			APPLICATION.sLocation["www.#APPLICATION.UniqueName#.com"]="#APPLICATION.UniqueName#.mca.thirdwave.local";

		}
		else if (ThisSiteType IS "staging") {
			
			// PathPrefix is a default - replace this with the path to the site
			APPLICATION.PathPrefix="E:\websites\#APPLICATION.UniqueName#\staging.#APPLICATION.UniqueName#.com\";
			APPLICATION.WebRootPath="#APPLICATION.PathPrefix#webroot\";
			APPLICATION.CollectionPath="#APPLICATION.PathPrefix#collection\";
			APPLICATION.WorkgroupPath="#APPLICATION.PathPrefix#workarea\";
			APPLICATION.ExecuteTempDir="#APPLICATION.PathPrefix#temp\";
			APPLICATION.LocalePath="#APPLICATION.WebRootPath#locale";
			APPLICATION.SourceDBServer="staging.#APPLICATION.UniqueName#.com";
			APPLICATION.SourceLogin="cfmx";
			APPLICATION.SourcePassword="st34l1n";
			APPLICATION.Staging="yes";
			APPLICATION.sLocation["www.#APPLICATION.UniqueName#.com"]="staging.#APPLICATION.UniqueName#.com";
		}
		else {
			
			// PathPrefix is a default - replace this with the path to the site
			APPLICATION.PathPrefix="E:\websites\#APPLICATION.UniqueName#\www.#APPLICATION.UniqueName#.com\";
			APPLICATION.WebRootPath="#APPLICATION.PathPrefix#webroot\";
			APPLICATION.CollectionPath="#APPLICATION.PathPrefix#collection\";
			APPLICATION.WorkgroupPath="#APPLICATION.PathPrefix#workarea\";
			APPLICATION.ExecuteTempDir="#APPLICATION.PathPrefix#temp\";
			APPLICATION.LocalePath="#APPLICATION.WebRootPath#locale";
			APPLICATION.Production="yes";
			APPLICATION.SourceDBServer="";
			APPLICATION.SourceLogin="";
			APPLICATION.SourcePassword="";
			APPLICATION.Production="yes";
			APPLICATION.sLocation["www.#APPLICATION.UniqueName#.com"]="www.#APPLICATION.UniqueName#.com";
		}

		// FTP parameters
		APPLICATION.TrashPath="#APPLICATION.WorkgroupPath#trash\";

		// Group ID's (referring to t_Label)
		APPLICATION.SuperAdminUserGroupID=4;  // value ties to t_Label.LabelID
		APPLICATION.ContentEditorUserGroupID=3;  // value ties to t_Label.LabelID
		APPLICATION.AdminUserGroupID=4;  // value ties to t_Label.LabelID
		APPLICATION.ContentCategoryTypeID=60;	// value ties to t_Label.LabelID
		APPLICATION.TemplateTypeLabelGroupID=20; // value ties to t_Label.LabelGroupID
		APPLICATION.lVisibleCategoryTypeID="60,62,64,66,68,69,70,75,76";

		// More parameters.
		APPLICATION.DefaultLocaleID=1;
		APPLICATION.UploadPath="common\incoming\";
		
		// UserFilesPath is the same as upload path, but with the slashes in the opposite
		// direction and a slash as the prefix
		APPLICATION.UserFilesPath= replace(APPLICATION.UploadPath, "\", "/", "all");
		
		// add the prefix "/" if it doesn't exist
		if (left(APPLICATION.UserFilesPath, 1) neq "/") {
			APPLICATION.UserFilesPath = "/" & APPLICATION.UserFilesPath;
		}
		
		APPLICATION.FlashPath="resources\flash\";
		

		APPLICATION.ImageFileExtensionList=".jpg;.gif;.jpeg;.jpe;.swf;.png";
		APPLICATION.DocumentFileExtensionList=".pdf;.txt;.eps;.doc;.hqx;.sea;.ppt;.mov;.zip;.sit;.indt;.mpg;.mp3;.mp4;.xls;.key";

		APPLICATION.MasterFileExtensionList=ListAppend(APPLICATION.ImageFileExtensionList,APPLICATION.DocumentFileExtensionList,";");

		// This is the e-mail address to which error reports should be sent.
		// It is possible to specify more than one address by making this a
		// semicolon-delimited list.
		Application.ErrorMailTo="thomas@newermedia.com";
		Application.ErrorMailFrom="#APPLICATION.UniqueName#-Error@thirdwavellc.com";

		</cfscript>
		
		<!--- create a utils object --->
		<cfobject component="com.utils.utils" name="APPLICATION.utilsObj">
		<cfset APPLICATION.utilsObj.init()>
		
		<!--- create a time object --->
		<cfobject component="com.time.Time" name="APPLICATION.timeObj">
		<cfset APPLICATION.timeObj.init()>
		
		<!--- read the factory config xml into memory --->
		<cfif ThisSiteType neq "dev"
				or MustResetAppVars
				or not isDefined("APPLICATION.FACTORYCONFIGSTATUS")>
			<cfinclude template="/config/factory/thirdwave/createConfig.cfm" />
			<cfinclude template="/config/factory/thirdwave/createTemplateConfig.cfm" />
		</cfif>
	</cflock>
</cfif>

<!--- TODO - get this out of APPLICATION scope --->
<cfif MustResetAppVars OR NOT APPLICATION.Production>
	<cflock type="Exclusive" name="#Application.ApplicationName#" timeout="1">
		<cfquery name="GetAllLocale" datasource="#APPLICATION.DSN#">
			select * from t_Locale order by LocaleName
		</cfquery>
		<cfset Application.GetAllLocale = Duplicate(GetAllLocale)>
		<cfquery name="GetThisLocale" dbtype="query">
			select * from GetAllLocale Where LocaleID=#Val(APPLICATION.LocaleID)#
		</cfquery>
		<cfoutput query="GetThisLocale">
			<cfset APPLICATION.LocaleName=LocaleName>
			<cfset APPLICATION.LocaleAlias=LocaleAlias>
			<cfset APPLICATION.LocaleCode=LocaleCode>
		</cfoutput>
	</cflock>
</cfif>


<cfif NOT IsDefined("Application.AppVarsSet")>
<!---	<cftry>
		<CFSEARCH NAME="ContentSearch"
		    COLLECTION="#Application.CollectionName##APPLICATION.DefaultLocaleID#"
		    TYPE="Simple"
		    CRITERIA="smoking kills">
		<cfcatch>
			verity does not exist
			<cfinclude template="/common/process/verityupdate.cfm">
		</cfcatch>
	</cftry> --->
	<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
		select * from t_Locale order by LocaleID
	</cfquery>
	<cfoutput query="GetLocales">
		<cftry>
			<cfdirectory action="CREATE" directory="#APPLICATION.ExecuteTempDir##LocaleID#\">
			<cfcatch>
			</cfcatch>
		</cftry>
	</cfoutput>

	<cflock type="Exclusive" name="#Application.ApplicationName#" timeout="1">
		<!--- Cache the t_StateProvince table  --->
		<cfquery name="APPLICATION.GetStateProvinces" datasource="#APPLICATION.DSN#" dbtype="ODBC">
			SELECT stateProvinceId, stateProvinceCode, stateProvinceName, countryCode, priority
		    FROM  t_StateProvince
			WHERE countrycode = 'us'
			ORDER BY Priority
		</cfquery>
	
		<!--- Cache the t_Country table  --->
		<!--- As it stands, we order this query by country code.  However, some of the
			  codes don't start with the same letters as the country's full name, as
			  expressed in English.  Do we want to order the country query in strict
			  alphabetical order instead?  Also, should these have a priority too, so as
			  to put the USA at the top?  For example:
			    ORDER BY IsNull(priority, 10000), Country
			  Note that this query puts everything without a priority at the end, and
			  orders it alphabetically.  We don't care about speed, because we're
			  caching the query.  --PWK, 7/11/01
			  NOTE TO THOMAS:  This query assumes the CountryID's other than the USA
			  and Canada are in alphabetical order; in the past, they haven't always
			  been.  --->
		<!--- <cfquery name="GetCountries" datasource="#APPLICATION.DSN#" dbtype="ODBC">
			SELECT * FROM t_Country
			ORDER BY IsNull(priority, 10000), CountryName
		</cfquery>
		<cfset Application.GetCountries = Duplicate(GetCountries)> --->

		<!--- Cache the t_Mime table  --->
		<cfquery name="GetMimes" datasource="#APPLICATION.DSN#" dbtype="ODBC">
			SELECT *
			FROM qry_GetMime
			ORDER BY MimeID
		</cfquery>
		<cfset Application.GetMimes = Duplicate(GetMimes)>
		<cfset APPLICATION.sMimeIconPath=StructNew()>
		<cfoutput query="GetMimes" group="mimeID">
			<cfset StructInsert(APPLICATION.sMimeIconPath,MimeID,MimeIconPath)>
		</cfoutput>

		<!--- This variable is set at the very end to signify that the application
			  scope has been fully configured. --->
		<cfset Application.AppVarsSet=TRUE>
	</cflock>
</cfif>

<!--- Our error template.  In debug mode, the error page will not be displayed
	  so as to facilitate debugging.  --->
<cfif IsDebugMode() OR NOT APPLICATION.Production><cfelse>
	<cferror type="Exception" exception="Any" template="/common/error/errorhandler.cfm">
</cfif>

<!--- Now, set up the session scope, if it hasn't already been.  Similar to the
	  Application scope, the presence of the variable Session.SessionVarsSet as
	  a true value signifies that the variables do not need to be set again.  --->
  <cfparam name="Session.SessionID" default="#CreateUUID()#">

<cflock type="ReadOnly" name="#Session.SessionID#" timeout="1">
	<cfset MustResetSessionVars = (NOT IsDefined("Session.SessionVarsSet"))>
</cflock>
<cfif MustResetSessionVars>
	<cflock type="Exclusive" name="#Session.SessionID#" timeout="1">
		<!--- Pull the browser information into session scope  --->
		<CF_BrowserCheck>
		<cfif BC_BROWSER CONTAINS "MSIE">
			<cfset SESSION.CurrentBrowserApp="IE">

		<cfelse>
			<cfset SESSION.CurrentBrowserApp="NS">
		</cfif>
		<cfif BC_OS CONTAINS "mac">
			<cfset SESSION.CurrentOS="Mac">
		<cfelse>
			<cfset SESSION.CurrentOS="PC">
		</cfif>
		<cfset SESSION.CurrentBrowserVersion=BC_VERSION>

		<cfscript>
		// User ID, login and password
		SESSION.UserID="";
		SESSION.UserLogin="";
		SESSION.UserPassword="";
		SESSION.UserRolesIDList="-1";
		// This variable is set at the very end to signify that the session
		// scope has been fully configured.
		SESSION.SessionVarsSet=TRUE;

		</cfscript>
	</cflock>
</cfif>
<cfparam name="SESSION.CurrentAdminLocaleID" default="-1"/>
<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
	SELECT LanguageID,LocaleCode,LocaleName 
	FROM t_Locale 
	WHERE LocaleID = <cfqueryparam value="#Val(SESSION.CurrentAdminLocaleID)#" cfsqltype="cf_sql_integer" maxlength="4">
</cfquery>
<cfset SESSION.CurrentAdminLanguageID="#Val(GetLang.LanguageID)#">
<cfset SESSION.CurrentAdminLocaleCode="#Trim(GetLang.LocaleCode)#">
<cfset SESSION.CurrentAdminLocaleName="#Trim(GetLang.LocaleName)#">

<cfparam name="SESSION.AdminUserID" default="">
<cfparam name="SESSION.AdminUserLogin" default="">
<cfparam name="SESSION.AdminUserPassword" default="">
<cfparam name="SESSION.AdminUserGroupIDList" default="">
<cfparam name="SESSION.AdminUserLocaleID" default="">
<cfparam name="SESSION.AdminCurrentAdminLocaleID" default="">
<cfparam name="SESSION.lPageIDView" default="">
<!--- <cfsetting showdebugoutput="No"> --->

<cfinclude template="/Common/modules/CommonFunctions.cfm">

<!--- if in secure, make sure nav links exit secure --->
<cfset REQUEST.GlobalNavURLPrefix = "">

<cfif (CGI.SERVER_PORT EQ 443 or REQUEST.CGIHTTPHost IS NOT "#REQUEST.BaseDomainName#") and APPLICATION.Production>
	<cfset REQUEST.GlobalNavURLPrefix = "http://#REQUEST.BaseDomainName#">
</cfif>