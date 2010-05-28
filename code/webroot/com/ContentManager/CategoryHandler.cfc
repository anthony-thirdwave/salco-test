<cfcomponent>

	<cffunction name="init" returntype="CategoryHandler">
		<cfreturn this>
	</cffunction>

	<cffunction name="CheckDuplicateAlias" output="false" returntype="boolean">
		<cfargument name="CandidateAlias" default="" type="string" required="true">
		<cfargument name="CategoryID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var CheckAlias = "">

		<cfquery name="CheckAlias" datasource="#APPLICATION.DSN#">
			SELECT *
			FROM t_Category
			WHERE CategoryAlias = <cfqueryparam value="#Trim(ARGUMENTS.CandidateAlias)#" cfsqltype="cf_sql_varchar">
			AND CategoryID <> <cfqueryparam value="#val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif CheckAlias.RecordCount IS NOT "0">
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="GetCategoryIDFromAlias" output="false" returntype="numeric">
		<cfargument name="CategoryAlias" default="" type="string" required="true">

		<!--- init variables --->
		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.CheckAlias" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT CategoryID
			FROM t_Category
			WHERE CategoryAlias = <cfqueryparam value="#Trim(ARGUMENTS.CategoryAlias)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif LOCAL.CheckAlias.RecordCount IS "1">
			<cfreturn LOCAL.CheckAlias.CategoryID>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>

	<cffunction name="CreateAlias" output="false" returntype="string">
		<cfargument name="Name" default="" type="string" required="true">
		<cfargument name="CategoryID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var CandidateAlias = "">
		<cfset var ReturnCandidateAlias = "">
		<cfset var FoundHighAlias = "">
		<cfset var GetRecentAlias = "">
		<cfset var ValidAlias = "">

		<!--- scrub the alias prior to checking for duplicates --->
		<cfinvoke method="scrubAlias" returnvariable="CandidateAlias">
			<cfinvokeargument name="alias" value="#ARGUMENTS.Name#" />
		</cfinvoke>

		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="CheckDuplicateAlias"
			CandidateAlias="#Trim(CandidateAlias)#"
			CategoryID="#Val(ARGUMENTS.CategoryID)#"
			returnVariable="ValidAlias">
		<cfif ValidAlias>
			<cfreturn CandidateAlias>
		<cfelse>
			<cfquery name="GetRecentAlias" datasource="#APPLICATION.DSN#">
				select CategoryAlias from t_category Where CategoryAlias like <cfqueryparam value="#CandidateAlias#%" cfsqltype="cf_sql_varchar"> order by CategoryAlias Desc
			</cfquery>
			<cfset ReturnCandidateAlias="#CandidateAlias#-1">
			<cfset FoundHighAlias="">
			<cfoutput query="GetRecentAlias">#CategoryAlias#
				<cfif IsNumeric(ListLast(CategoryAlias,"-")) and ListLast(CategoryAlias,"-") GT Val(FoundHighAlias)>
					<cfset ReturnCandidateAlias="#CandidateAlias#-#IncrementValue(ListLast(GetRecentAlias.CategoryAlias,'-'))#">
					<cfset FoundHighAlias=ListLast(CategoryAlias,"-")>
				</cfif>
			</cfoutput>
			<cfreturn ReturnCandidateAlias>
		</cfif>
	</cffunction>
	
	<cffunction name="GetAllCategoryType" output="false" returntype="query">
		
		<cfset var LOCAL=StructNew()>
		
		<cfquery name="LOCAL.GetAllCategoryType" datasource="#APPLICATION.DSN#">
			SELECT		*
			FROM		t_Label
			WHERE		LabelGroupID= <cfqueryparam value="40" cfsqltype="cf_sql_integer">
			ORDER BY	LabelName
		</cfquery>
		<cfreturn LOCAL.GetAllCategoryType>
	</cffunction>
	
	<cffunction name="GetContent" output="false" returntype="boolean">
		<cfargument name="CategoryID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var CheckAlias = "">

		<cfquery name="CheckAlias" datasource="#APPLICATION.DSN#">
			SELECT * FROM qry_GetContent WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn CheckAlias>
	</cffunction>

	<cffunction name="GetCategoryPicker" output="false" returntype="query">
		<cfargument name="CategoryTypeID" required="true" type="numeric"/>
		<cfargument name="LocaleID" required="true" type="numeric"/>

		<!--- init variables --->
		<cfset var GetCategoryQuery = "">

		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetCategoryQuery">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#ARGUMENTS.CategoryTypeID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
		</cfstoredproc>
		<cfreturn GetCategoryQuery>
	</cffunction>

	<cffunction name="GetBlog" output="false" returntype="query">
		<!--- init variables --->
		<cfset var LOCAL=StructNew()>

		<cfquery name="GetBlog" datasource="#APPLICATION.DSN#">
			SELECT	t_Category_2.CategoryName as BlogName, t_Category_2.CategoryID as BlogID, t_Category_2.CategoryAlias as BlogAlias
			FROM	t_Category AS t_Category_2
			WHERE 	t_Category_2.CategoryTypeID=<cfqueryparam value="78" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn GetBlog>
	</cffunction>
	
	<cffunction name="GetContentAndContentLocale" output="false" returntype="query">
		<cfargument name="CategoryID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var CheckAlias = "">

		<cfquery name="CheckAlias" datasource="#APPLICATION.DSN#">
			SELECT t_Content.ContentID, ContentLocaleID
			FROM         t_Content LEFT OUTER JOIN
	                      t_ContentLocale ON t_Content.ContentID = t_ContentLocale.ContentID
			WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and localeID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
			order by t_Content.contentId,ContentLocaleID
		</cfquery>
		<cfreturn CheckAlias>
	</cffunction>
	<cffunction name="GetNavCategoryQuery" output="false" returntype="query">

		<!--- init variables --->
		<cfset var GetAllCategories = "">

		<cfquery name="GetAllCategories" datasource="#APPLICATION.DSN#">
			SELECT CategoryID, CategoryName, CategoryAlias, CategoryURL, DisplayOrder,DisplayLevel
			FROM t_Category
			ORDER BY DisplayOrder
		</cfquery>
		<cfreturn GetAllCategories>
	</cffunction>
	<cffunction name="GetCategoryTypeID" returntype="numeric" output="false">
		<cfargument name="CategoryID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var CheckAlias = "">

		<cfquery name="CheckAlias" datasource="#APPLICATION.DSN#">
			SELECT CategoryTypeID from t_category WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn Val(CheckAlias.CategoryTypeID)>
	</cffunction>

	<cffunction name="UpdateCacheDateTime" returntype="boolean" output="false">
		<cfargument name="lookup" default="" type="string" required="true">
		<cfargument name="KeyID" default="" type="numeric" required="true">
		<cfargument name="Datasource" default="#APPLICATION.DSN#" type="string" required="false">

		<!--- init variables --->
		<cfset var GetCategoryID = "">
		<cfset var UpdateCache = "">

		<cfif NOT IsDefined("ARGUMENTS.Datasource") OR ARGUMENTS.Datasource IS "">
			<cfset ARGUMENTS.Datasource=APPLICATION.DSN>
		</cfif>

		<cfif ARGUMENTS.Lookup IS "Content">
			<cfquery name="GetCategoryID" datasource="#ARGUMENTS.Datasource#">
				select CategoryID from t_Content Where ContentID=<cfqueryparam value="#Val(ARGUMENTS.KeyID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetCategoryID.RecordCount IS "1">
				<cfquery name="UpdateCache" datasource="#ARGUMENTS.Datasource#">
					update t_Category set CacheDateTime=<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> where CategoryID=<cfqueryparam value="#Val(GetCategoryID.CategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfreturn true>
			</cfif>
		<cfelseif ARGUMENTS.Lookup IS "Category">
			<cfquery name="UpdateCache" datasource="#ARGUMENTS.Datasource#">
				update t_Category set CacheDateTime=<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> where CategoryID=<cfqueryparam value="#Val(ARGUMENTS.KeyID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="AdjustPriorities" returntype="boolean" output="false">
		<cfargument name="sNewPriorities" required="true">

		<!--- init variables --->
		<cfset var ThisCategoryID = "">
		<cfset var UpdateRank = "">
		<cfset var GetParentID = "">
		<cfset var GetCatsAgain = "">
		<cfset var UpdateAgain = "">
		<cfset var Success = "">

		<cfif IsStruct(ARGUMENTS.sNewPriorities) AND ListLen(StructKeyList(sNewPriorities)) GT "0">
			<cfloop index="ThisCategoryID" list="#StructKeyList(sNewPriorities)#">
				<cfquery name="UpdateRank" datasource="#APPLICATION.DSN#">
					UPDATE t_Category
					SET CategoryPriority = <cfqueryparam value="#val(sNewPriorities[ThisCategoryID])#" cfsqltype="cf_sql_integer">
					WHERE CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfloop>
			<cfquery name="GetParentID" datasource="#APPLICATION.DSN#">
				select ParentID from t_Category
				where CategoryID=<cfqueryparam value="#Val(ListFirst(StructKeyList(sNewPriorities)))#" cfsqltype="cf_sql_integer"> order by CategoryPriority
			</cfquery>
			<cfquery name="GetCatsAgain" datasource="#APPLICATION.DSN#">
				select * from t_Category where ParentID=<cfqueryparam value="#Val(GetParentID.ParentID)#" cfsqltype="cf_sql_integer"> order by CategoryPriority
			</cfquery>
			<cfoutput query="GetCatsAgain">
				<cfquery name="UpdateAgain" datasource="#APPLICATION.DSN#">
					UPDATE t_Category
					SET CategoryPriority = <cfqueryparam value="#val(evaluate('#CurrentRow#*10'))#" cfsqltype="cf_sql_integer">
					WHERE CategoryID=<cfqueryparam value="#Val(CategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfoutput>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="GenerateDisplayOrderString"
				returnVariable="Success"
				SourceParentID="#Val(GetParentID.ParentID)#"
				datasource="#APPLICATION.DSN#">
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="GenerateDisplayOrderString" returnType="boolean" output="1">
		<cfargument name="SourceParentID" required="true" type="numeric">
		<cfargument name="Datasource" required="true" type="string">
		<cfif IsDefined("APPLICATION.Migrate") AND APPLICATION.Migrate>
			<cfreturn true>
		</cfif>

		<cfquery datasource="#ARGUMENTS.Datasource#">
		EXEC sp_generateDisplayOrder #Val(ARGUMENTS.SourceParentID)#
		</cfquery>

		<cfreturn true>
	</cffunction>

	<cffunction name="GetProductionSiteInformation" returnType="any" output="false">
		<cfargument name="CategoryID" required="true" type="numeric">

		<!--- init variables --->
		<cfset var ReturnValue = "">
		<cfset var sProductionSiteInformation = "">
		<cfset var ThisProperty = "">
		<cfset var GetRootCategory = "">
		<cfset var sProperties = "">

		<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
			ThisCategoryID="#ARGUMENTS.CategoryID#" NameList="" IDList="#ARGUMENTS.CategoryID#">
		<cfquery name="GetRootCategory" datasource="#APPLICATION.DSN#">
			select * from qry_Getcategory where CategoryID=<cfqueryparam value="#Val(ListFirst(ListRest(IDList)))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset ReturnValue="">
		<cfif IsWDDX(GetRootCategory.PropertiesPacket) AND GetRootCategory.CategoryTypeID IS "65"><!--- Website type category --->
			<cfwddx action="WDDX2CFML" input="#GetRootCategory.PropertiesPacket#" output="sProperties">
			<cfloop index="ThisProperty" list="ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer,ProductionDBName,ProductionDBDSN">
				<cfif StructKeyExists(sProperties,"#ThisProperty#") AND Trim(sProperties["#ThisProperty#"]) is not "">
					<cfset SetVariable("#ThisProperty#",sProperties["#ThisProperty#"])>
				</cfif>
			</cfloop>
		</cfif>

		<cfif IsDefined("ProductionFTPHost") AND IsDefined("ProductionFTPRootPath") AND IsDefined("ProductionFTPUserLogin") AND IsDefined("ProductionFTPPassword") AND IsDefined("ProductionDBServer") AND IsDefined("ProductionDBName") AND Isdefined("ProductionDBDSN")>
			<cfset sProductionSiteInformation=StructNew()>
			<cfset StructInsert(sProductionSiteInformation,"ProductionFTPHost",ProductionFTPHost,1)>
			<cfset StructInsert(sProductionSiteInformation,"ProductionFTPRootPath",ProductionFTPRootPath,1)>
			<cfset StructInsert(sProductionSiteInformation,"ProductionFTPUserLogin",ProductionFTPUserLogin,1)>
			<cfset StructInsert(sProductionSiteInformation,"ProductionFTPPassword",ProductionFTPPassword,1)>
			<cfset StructInsert(sProductionSiteInformation,"ProductionDBServer",ProductionDBServer,1)>
			<cfset StructInsert(sProductionSiteInformation,"ProductionDBName",ProductionDBName,1)>
			<cfset StructInsert(sProductionSiteInformation,"ProductionDBDSN",ProductionDBDSN,1)>
			<cfreturn sProductionSiteInformation>
		<cfelse>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>

	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="CategoryID" required="true">
		<cfargument name="WebrootPath" required="true">

		<!--- init variables --->
		<cfset var ThisID=ARGUMENTS.CategoryID>
		<cfset var DirDone = "">
		<cfset var DirectoryToCreate = "">
		<cfset var i = "">

		<cfif Val(ARGUMENTS.CategoryID) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#ThisID#" ReturnVarName="PathFragment">
			<cfset DirDone="">
			<cfloop index="i" from="1" to="#Len(ThisID)#" step="1">
				<cfset DirectoryToCreate="#ARGUMENTS.WebRootPath##Application.CategoryResourcesPath##DirDone##Mid(ThisID,i,1)#">
				<cfset DirDone="#DirDone##Mid(ThisID,i,1)#\">
				<cftry><cfdirectory action="CREATE" directory="#DirectoryToCreate#"><cfcatch></cfcatch></cftry>
				<cftry><cfdirectory action="CREATE" directory="#DirectoryToCreate#/images/"><cfcatch></cfcatch></cftry>
				<cftry><cfdirectory action="CREATE" directory="#DirectoryToCreate#/documents/"><cfcatch></cfcatch></cftry>
				<cftry><cfdirectory action="CREATE" directory="#DirectoryToCreate#/generated/"><cfcatch></cfcatch></cftry>
			</cfloop>
			<cfreturn true>
		</cfif>
	</cffunction>
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="CategoryID" required="true">
		<cfargument name="ResourceType" required="true">

		<!--- init variables --->
		<cfset var ThisID=ARGUMENTS.CategoryID>
		<cfset var ReturnString = "">

		<cfif Val(ThisID) LTE "0" or ListFindNoCase("images,documents,generated",ARGUMENTS.ResourceType) LTE "0">
			<cfset ReturnString="/#ReplaceNoCase(APPLICATION.UploadPath,'\','/','all')#">
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm"
				String="#ThisID#"
				ReturnVarName="PathFragment"
				Delimiter="/">
			<cfset ReturnString="/#Application.CategoryResourcesPath##PathFragment#/#lcase(ARGUMENTS.ResourceType)#/">
			<cfset ReturnString=ReplaceNoCase(ReturnString,"\","/","All")>
			<cfset ReturnString=ReplaceNoCase(ReturnString,"//","/","All")>
		</cfif>
		<cfreturn ReturnString>
	</cffunction>

	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="CategoryID" required="true">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">

		<!--- init variables --->
		<cfset var ThisID=ARGUMENTS.CategoryID>
		<cfset var ReturnString = "">

		<cfif Val(ThisID) LTE "0" or ListFindNoCase("images,documents,generated",ARGUMENTS.ResourceType) LTE "0">
			<cfset ReturnString="#ARGUMENTS.WebrootPath##APPLICATION.UploadPath#">
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm"
				String="#ThisID#"
				ReturnVarName="PathFragment"
				Delimited="\">
			<cfset ReturnString="#ARGUMENTS.WebrootPath##Application.CategoryResourcesPath##PathFragment##lcase(ARGUMENTS.ResourceType)#\">
		</cfif>
		<cfreturn ReturnString>
	</cffunction>

	<cffunction name="GetCategoryBasicDetails" returntype="query" output="false">
		<cfargument name="CategoryID" required="true">

		<!--- init variables --->
		<cfset var GetCategoryBasicDetails = "">

		<cfquery name="GetCategoryBasicDetails" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT		CategoryName, CategoryTypeName, CategoryAlias, CategoryActive,
						PropertiesPacket, CategoryTypeID
			FROM		qry_GetCategory
			WHERE		CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn GetCategoryBasicDetails>
	</cffunction>

	<cffunction name="GetCategoryLocaleID" returntype="numeric" output="false">
		<cfargument name="CategoryID" required="true">
		<cfargument name="LocaleID" required="true">

		<!--- init variables --->
		<cfset var GetCategoryLocaleID = "">

		<cfquery name="GetCategoryLocaleID" datasource="#APPLICATION.DSN#">
			select CategoryLocaleID FROM t_CategoryLocale
			Where CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif GetCategoryLocaleID.RecordCount IS "1">
			<cfreturn GetCategoryLocaleID.CategoryLocaleID>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>

	<cffunction name="CreateRemoteFolders" returntype="boolean" output="1">
		<cfargument name="CategoryID" required="true">
		<cfargument name="FTPHost" required="true">
		<cfargument name="FTPRootPath" required="true">
		<cfargument name="FTPUserLogin" required="true">
		<cfargument name="FTPPassword" required="true">

		<!--- init variables --->
		<cfset var FinalPath = "">
		<cfset var CreateFolders = "">
		<cfset var DirDone = "">
		<cfset var DirectoryToCreate = "">
		<cfset var ThisDirectoryFragment = "">
		<cfset var i = "">

		<cfmodule template="/common/modules/utils/ExplodeString.cfm" Delimiter="/" String="#ARGUMENTS.CategoryID#" ReturnVarName="PathFragment">
		<cfset FinalPath=Replace("#ARGUMENTS.FTPRootPath##APPLICATION.CategoryResourcesPath##PathFragment#","\","/","All")>
		<cfset CreateFolders="no">
		<cfloop index="ThisDirectoryFragment" list="/,/images/,/documents/,/generated/">
			<cfftp action="EXISTSDIR"
				server="#ARGUMENTS.FTPHost#"
				username="#ARGUMENTS.FTPUserLogin#"
				password="#ARGUMENTS.FTPPassword#"
				stoponerror="No"
				directory="#FinalPath##ThisDirectoryFragment#"
				connection="FTP_#ReplaceNoCase(ARGUMENTS.FTPHost,'.','','all')#">
			<cfif cfftp.returnValue IS "no">
				<cfset CreateFolders="Yes">
			</cfif>
		</cfloop>
		<cfif CreateFolders>
			<cfset DirDone="">
			<cfloop index="i" from="1" to="#Len(ARGUMENTS.CategoryID)#" step="1">
				<cfset DirectoryToCreate="#ARGUMENTS.FTPRootPath#/#APPLICATION.CategoryResourcesPath##DirDone##Mid(ARGUMENTS.CategoryID,i,1)#">
				<cfset DirectoryToCreate=ReplaceNoCase(DirectoryToCreate,"\","/","All")>
				<cfset DirDone="#DirDone##Mid(ARGUMENTS.CategoryID,i,1)#/">
				<cfloop index="ThisDirectoryFragment" list="/,/images/,/documents/,/generated/">
					<cfftp action="CREATEDIR"
						directory="#DirectoryToCreate##ThisDirectoryFragment#"
						server="#ARGUMENTS.FTPHost#"
						username="#ARGUMENTS.FTPUserLogin#"
						password="#ARGUMENTS.FTPPassword#"
						stoponerror="No"
						connection="FTP_#ReplaceNoCase(ARGUMENTS.FTPHost,'.','','all')#">
					created dir: #DirectoryToCreate##ThisDirectoryFragment#<BR>
				</cfloop>
			</cfloop>
		<cfelse>
			#FinalPath# already exists skipping<BR>
		</cfif>
		<cfreturn true>
	</cffunction>
	<cffunction name="GetCategoryFrontEndPermissions" output="false" returntype="query">
		<cfargument name="CategoryID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			select * from qry_GetCategoryFrontEndPermission
			WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and PView=1
		</cfquery>
		<cfreturn Check>
	</cffunction>

	<cffunction name="GetCategoryFrontEndPermissionsList" output="false" returntype="string">
		<cfargument name="CategoryID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">
		<cfset var ReturnList = ""/>

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			select DISTINCT(UserGroupID) from qry_GetCategoryFrontEndPermission
			WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and PView=1
		</cfquery>

		<cfloop query="Check">
			<cfset ReturnList = ListAppend(ReturnList,#Check.UserGroupID#)/>
		</cfloop>
		<cfreturn ReturnList/>
	</cffunction>

	<cffunction name="GetLocaleIDByPage" output="false" returntype="boolean">
		<cfargument name="Alias" default="" type="string" required="true">
		<cfargument name="Datasource" default="" type="string" required="true">

		<!--- init variables --->
		<cfset var GetLocaleIDByPage = "">

		<cfquery name="GetLocaleIDByPage" datasource="#ARGUMENTS.Datasource#">
			SELECT * FROM qry_GetcategoryLocale WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.Alias)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif GetLocaleIDByPage.RecordCount IS "1">
			<cfreturn GetLocaleIDByPage.LocaleID>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>

	<cffunction name="GetCategoryName" output="false" returntype="string">
		<cfargument name="CategoryID" default="-1" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			select CategoryName from t_category
			WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn Check.Categoryname>
	</cffunction>

	<cffunction name="SetLocationAboveSibling" output="false" returntype="boolean">
		<cfargument name="CategoryID" type="numeric" required="true">
		<cfargument name="SiblingID" type="numeric" required="true">
		<cfargument name="LocaleID" type="numeric" default="-1" required="false">

		<!--- init variables --->
		<cfset var thisParentID = "">
		<cfset var newCategoryPriority = "">
		<cfset var ThisNewPriority = "">
		<cfset var newCategoryLocalePriority = "">
		<cfset var getParentIDs = "">
		<cfset var CheckSameParent = "">
		<cfset var getCategoryPriority = "">
		<cfset var setCategoryPriority = "">
		<cfset var getCategories = "">
		<cfset var UpdateCategoryPriority = "">
		<cfset var getLocales = "">
		<cfset var getCategoryLocalePriority = "">
		<cfset var setCategoryLocalePriority = "">
		<cfset var getCategoryLocales = "">
		<cfset var UpdateCategoryLocalePriority = "">
		<cfset var Success = "">

		<cfquery name="getParentIDs" datasource="#APPLICATION.DSN#">
			SELECT ParentID FROM t_Category
			WHERE CategoryID IN (<cfqueryparam value="#ARGUMENTS.CategoryID#,#ARGUMENTS.SiblingID#" list="yes" cfsqltype="cf_sql_integer">)
		</cfquery>
		<cfquery name="CheckSameParent" dbtype="query">
			SELECT DISTINCT ParentID FROM getParentIDs
		</cfquery>

		<!--- IF THEY BOTH EXIST AND ARE SIBLINGS --->
		<cfif getParentIDs.RecordCount EQ 2 AND CheckSameParent.RecordCount EQ 1>
			<cfset thisParentID = CheckSameParent.ParentID>
			<!--- IF locale not specified, or locale is default locale, set priority at category level --->
			<cfif ARGUMENTS.LocaleID LT 1 OR ARGUMENTS.LocaleID EQ APPLICATION.DefaultLocaleID>
				<cfquery name="getCategoryPriority" datasource="#APPLICATION.DSN#">
					SELECT CategoryPriority FROM t_Category
					WHERE CategoryID = <cfqueryparam value="#ARGUMENTS.SiblingID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset newCategoryPriority = Val(getCategoryPriority.CategoryPriority)-5>
				<cfquery name="setCategoryPriority" datasource="#APPLICATION.DSN#">
					UPDATE t_Category SET CategoryPriority = <cfqueryparam value="#newCategoryPriority#" cfsqltype="cf_sql_integer">
					WHERE CategoryID = <cfqueryparam value="#ARGUMENTS.CategoryID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="getCategories" datasource="#APPLICATION.DSN#">
					SELECT CategoryID AS thisCategoryID FROM t_Category
					WHERE ParentID = <cfqueryparam value="#thisParentID#" cfsqltype="cf_sql_integer">
					ORDER BY CategoryPriority
				</cfquery>
				<cfoutput query="getCategories">
					<cfset ThisNewPriority=10*CurrentRow>
					<cfquery name="UpdateCategoryPriority" datasource="#APPLICATION.DSN#">
						UPDATE t_Category SET CategoryPriority= <cfqueryparam value="#ThisNewPriority#" cfsqltype="cf_sql_integer">
						WHERE CategoryID = <cfqueryparam value="#thisCategoryID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfoutput>

				<cfinvoke component="com.ContentManager.CategoryHandler" method="GenerateDisplayOrderString"
					returnVariable="Success"
					SourceParentID="#thisParentID#"
					datasource="#APPLICATION.DSN#">
			</cfif>
			<!--- set priority for locale(s) --->
			<cfquery name="getLocales" datasource="#APPLICATION.DSN#">
				SELECT LocaleID AS thisLocaleID FROM t_Locale
				<cfif ARGUMENTS.LocaleID GT 0>
				WHERE LocaleID = <cfqueryparam value="#ARGUMENTS.LocaleID#" cfsqltype="cf_sql_integer">
				</cfif>
			</cfquery>
			<cfoutput query="getLocales">
				<cfquery name="getCategoryLocalePriority" datasource="#APPLICATION.DSN#">
					SELECT CategoryLocalePriority FROM t_CategoryLocaleMeta
					WHERE CategoryID = <cfqueryparam value="#ARGUMENTS.SiblingID#" cfsqltype="cf_sql_integer">
					AND LocaleID = <cfqueryparam value="#thisLocaleID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset newCategoryLocalePriority = Val(getCategoryLocalePriority.CategoryLocalePriority)-5>
				<cfquery name="setCategoryLocalePriority" datasource="#APPLICATION.DSN#">
					UPDATE t_CategoryLocaleMeta SET CategoryLocalePriority = <cfqueryparam value="#newCategoryLocalePriority#" cfsqltype="cf_sql_integer">
					WHERE CategoryID = <cfqueryparam value="#ARGUMENTS.CategoryID#" cfsqltype="cf_sql_integer">
					AND LocaleID = <cfqueryparam value="#thisLocaleID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfoutput>

			<cfoutput query="getLocales">
				<cfquery name="getCategoryLocales" datasource="#APPLICATION.DSN#">
					SELECT CategoryID AS thisCategoryID FROM t_CategoryLocaleMeta
					WHERE CategoryID IN (SELECT CategoryID FROM t_Category WHERE ParentID = <cfqueryparam value="#thisParentID#" cfsqltype="cf_sql_integer">)
					AND LocaleID = <cfqueryparam value="#thisLocaleID#" cfsqltype="cf_sql_integer">
					ORDER BY CategoryLocalePriority
				</cfquery>
				<cfloop query="getCategoryLocales">
					<cfset ThisNewPriority=10*CurrentRow>
					<cfquery name="UpdateCategoryLocalePriority" datasource="#APPLICATION.DSN#">
						UPDATE t_CategoryLocaleMeta SET CategoryLocalePriority= <cfqueryparam value="#ThisNewPriority#" cfsqltype="cf_sql_integer">
						WHERE CategoryID = <cfqueryparam value="#getCategoryLocales.thisCategoryID[getCategoryLocales.CurrentRow]#" cfsqltype="cf_sql_integer">
						AND LocaleID = <cfqueryparam value="#getLocales.thisLocaleID[getLocales.CurrentRow]#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfloop>
				<cfinvoke component="com.ContentManager.CategoryLocaleHandler" method="GenerateDisplayOrderString"
					returnVariable="Success"
					SourceParentID="#thisParentID#"
					LocaleID="#thisLocaleID#"
					datasource="#APPLICATION.DSN#">
			</cfoutput>

			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- get the number of categories --->
	<cffunction name="getCategoryCount" output="false" returntype="numeric">
		<cfargument name="parentId" type="numeric" required="false" default=0>

		<!--- init variables --->
		<cfset var Check = "">

		<!--- return the total number of categories --->
		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			SELECT COUNT(*) numCats
			FROM t_category

			<!--- limit by parentId if passed --->
			<cfif arguments.parentId neq 0>
				WHERE parentId = <cfqueryparam value="#arguments.parentId#" cfsqltype="cf_sql_integer">
			</cfif>
		</cfquery>
		<cfreturn Check.numCats>
	</cffunction>

	<cffunction name="GetBranchFromRoot" output="false" returntype="struct">
		<cfargument name="CategoryID" type="numeric" default="-1">

		<cfset LOCAL.sBranch=StructNew()>

		<cfset StructInsert(LOCAL.sBranch,"IDList","-1")>
		<cfset StructInsert(LOCAL.sBranch,"NameList","")>
		<cfset StructInsert(LOCAL.sBranch,"AliasList","")>

		<cfset LOCAL.SBranch=GetBranchFromRootHelper(ARGUMENTS.CategoryID,LOCAL.SBranch)>

		<cfreturn LOCAL.SBranch>
	</cffunction>

	<cffunction name="GetBranchFromRootHelper" output="false" returntype="struct">
		<cfargument name="CategoryID" type="numeric" default="-1">
		<cfargument name="sBranch" type="struct" default="#StructNew()#">

		<cfif StructKeyExists(ARGUMENTS.SBranch,"IDList") IS "0">
			<cfset StructInsert(ARGUMENTS.sBranch,"IDList","")>
		</cfif>
		<cfif StructKeyExists(ARGUMENTS.SBranch,"NameList") IS "0">
			<cfset StructInsert(ARGUMENTS.sBranch,"NameList","")>
		</cfif>
		<cfif StructKeyExists(ARGUMENTS.SBranch,"AliasList") IS "0">
			<cfset StructInsert(ARGUMENTS.sBranch,"AliasList","")>
		</cfif>

		<cfquery name="GetDetailOf#IncrementValue(Val(ARGUMENTS.CategoryID))#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
			SELECT	parentid,CategoryName,CategoryID,CategoryAlias
			FROM	t_Category
			WHERE	CategoryID = <cfqueryparam value="#val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif ARGUMENTS.SBranch.IDlist IS "-1">
			<cfset ARGUMENTS.SBranch.IDlist=val(Evaluate("GetDetailOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryID"))>
		</cfif>
		<cfif ARGUMENTS.SBranch.NameList IS "">
			<cfset ARGUMENTS.SBranch.NameList=Evaluate("GetDetailOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryName")>
		</cfif>
		<cfif ARGUMENTS.SBranch.AliasList IS "">
			<cfset ARGUMENTS.SBranch.AliasList=Evaluate("GetDetailOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryAlias")>
		</cfif>

		<cfquery name="GetParentOf#IncrementValue(Val(ARGUMENTS.CategoryID))#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
			SELECT	CategoryName,CategoryID,CategoryAlias
			FROM	t_Category
			WHERE	CategoryID = <cfqueryparam value="#val(Evaluate('GetDetailOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.parentid'))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif Evaluate("GetParentOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.recordcount") IS NOT "0">
			<cfset ARGUMENTS.SBranch.NameList=ListPrepend(ARGUMENTS.SBranch.NameList, application.utilsObj.RemoveHTML(Replace(Evaluate("GetParentOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryName"),","," ","all")))>
			<cfset ARGUMENTS.SBranch.IDList=ListPrepend(ARGUMENTS.SBranch.IDList, Evaluate("GetParentOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryID"))>
			<cfset ARGUMENTS.SBranch.AliasList=ListPrepend(ARGUMENTS.SBranch.AliasList, Evaluate("GetParentOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryAlias"))>
			<cfset ARGUMENTS.SBranch=GetBranchFromRootHelper("#Evaluate('GetParentOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.CategoryID')#",ARGUMENTS.SBranch)>
			<cfreturn ARGUMENTS.SBranch>
		<cfelse>
			<cfset ARGUMENTS.SBranch.IDList=ListPrepend(ARGUMENTS.SBranch.IDList,val(Evaluate("GetDetailOf#IncrementValue(Val(ARGUMENTS.CategoryID))#.parentid")))>
			<cfreturn ARGUMENTS.SBranch>
		</cfif>

	</cffunction>



	<!--- scrub an alias --->
	<cffunction name="scrubAlias" output="false" returntype="string">
		<cfargument name="alias" type="string" default="">

		<cfset arguments.alias=lcase(ReReplace(arguments.alias,"[�\!'/:"".+=;?&<>|,]","","all")) />
		<cfset arguments.alias=lcase(ReReplace(arguments.alias,"[ ]"," ","all")) />
		<cfset arguments.alias=lcase(ReReplace(arguments.alias,"[ ]","-","all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "##", "", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "$",  "", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "a", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "a", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "a", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "a", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "a", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "a", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "A", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "A", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "A", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "A", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "A", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "A", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "c", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "C", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "e", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "e", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "e", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "e", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "E", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "E", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "E", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "E", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "i", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "i", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "i", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "i", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "I", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "I", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "I", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "I", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "n", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "N", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "o", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "o", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "o", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "o", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "o", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "o", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "O", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "O", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "O", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "O", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "O", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "O", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "s", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "S", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "u", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "u", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "u", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "u", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "U", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "U", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "U", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "U", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "y", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "Y", "all")) />
		<cfset arguments.alias = lcase(replace(arguments.alias, "�",  "ss", "all")) />

		<cfreturn arguments.alias />
	</cffunction>
</cfcomponent>
