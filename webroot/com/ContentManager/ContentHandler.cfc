<cfcomponent output="false">

	<cffunction name="init" returntype="CategoryHandler">
		<cfreturn this>
	</cffunction>

	<cffunction name="GetContentQuery" output="false" returntype="query">
		<cfargument name="CategoryID" default="-1" type="numeric" required="true">

		<!--- init variables --->
		<cfset var GetContentQuery = "">

		<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
			SELECT		*
			FROM		qry_GetContent
			WHERE		CategoryID = <cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
			ORDER BY	ContentPriority
		</cfquery>
		<cfreturn GetContentQuery>
	</cffunction>

	<cffunction name="GetAllContentType" output="false" returntype="query">

		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.GetAllContentTypeID" datasource="#APPLICATION.DSN#">
			SELECT		*
			FROM		t_Label
			WHERE		LabelGroupID= <cfqueryparam value="70" cfsqltype="cf_sql_integer">
			ORDER BY	LabelName
		</cfquery>
		<cfreturn LOCAL.GetAllContentTypeID>
	</cffunction>

	<cffunction name="GetContentTemplatePicker" output="false" returntype="query">

		<!--- init variables --->
		<cfset var GetContentQuery = "">

		<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
			SELECT		*
			FROM		qry_GetCategoryContentPicker
			WHERE		ContentTypeID = <cfqueryparam value="233" cfsqltype="cf_sql_integer">
			ORDER BY	DisplayOrder,ContentPriority
		</cfquery>
		<cfreturn GetContentQuery>
	</cffunction>

	<cffunction name="GetContentPicker" output="false" returntype="query">
		<cfargument name="ContentTypeID" default="" required="false" type="any"/>
		<cfargument name="LocaleID" default="-1" required="Yes" type="any"/>

		<!--- init variables --->
		<cfset var GetContentQuery = "">

		<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
			SELECT	*
			FROM	qry_GetCategoryContentPicker
			WHERE	1=1
			<cfif arguments.ContentTypeID eq 245><!--- Only pull up content from the "Banner Depository" type category --->
				AND		CategoryTypeID = <cfqueryparam value="74" cfsqltype="cf_sql_integer">
			</cfif>
			AND			LocaleID = <cfqueryparam value="#val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
			AND 		ContentTypeID not in (<cfqueryparam value="206,207" cfsqltype="cf_sql_integer" list="true">)
			AND			ContentPositionID <> <cfqueryparam value="403" cfsqltype="cf_sql_integer">
			ORDER BY	DisplayOrder,ContentPriority
		</cfquery>
		<cfreturn GetContentQuery>
	</cffunction>

	<cffunction name="GetEventPicker" output="false" returntype="query">
		<cfargument name="LocaleID" default="" required="false" type="any"/>

		<!--- init variables --->
		<cfset var GetEvents = "">

		<cfquery name="GetEvents" datasource="#APPLICATION.DSN#">
			SELECT		*
			FROM		qry_GetContentLocale
			WHERE		LocaleID= <cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
			AND			ContentTypeID = <cfqueryparam value="235" cfsqltype="cf_sql_integer">
			ORDER BY	ContentDate1 Desc
		</cfquery>
		<cfreturn GetEvents>
	</cffunction>

	<cffunction name="GetContentSourceID" output="false" returntype="numeric">
		<cfargument name="ContentID" required="true" type="numeric">

		<!--- init variables --->
		<cfset var GetContentQuery = "">

		<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
			SELECT	SourceID
			FROM	t_Content
			WHERE	ContentID = <cfqueryparam value="#Val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn Val(GetContentQuery.SourceID)>
	</cffunction>

	<cffunction name="GetContentTypeQuery" output="false" returntype="query">

		<!--- init variables --->
		<cfset var Test = "">

		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Label">
			<cfinvokeargument name="FieldName" value="LabelGroupID">
			<cfinvokeargument name="FieldValue" value="70">
			<cfinvokeargument name="SortFieldName" value="LabelPriority">
			<cfinvokeargument name="SortOrder" value="Asc">
		</cfinvoke>
		<cfreturn Test>
	</cffunction>

	<cffunction name="GetPositionQuery" output="false" returntype="query">

		<!--- init variables --->
		<cfset var Test = "">

		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Label">
			<cfinvokeargument name="FieldName" value="LabelGroupID">
			<cfinvokeargument name="FieldValue" value="90">
			<cfinvokeargument name="SortFieldName" value="LabelPriority">
			<cfinvokeargument name="SortOrder" value="Asc">
		</cfinvoke>
		<cfreturn Test>
	</cffunction>

	<cffunction name="AdjustPriorities" returntype="boolean" output="false">
		<cfargument name="sNewPriorities" required="true">

		<!--- init variables --->
		<cfset var ThisContentID = "">
		<cfset var UpdateRank = "">
		<cfset var GetParentID = "">
		<cfset var GetCatsAgain = "">
		<cfset var UpdateAgain = "">

		<cfif IsStruct(ARGUMENTS.sNewPriorities) AND ListLen(StructKeyList(sNewPriorities)) GT "0">
			<cfloop index="ThisContentID" list="#StructKeyList(sNewPriorities)#">
				<cfquery name="UpdateRank" datasource="#APPLICATION.DSN#">
					UPDATE t_Content
					SET ContentPriority = <cfqueryparam value="#val(sNewPriorities[ThisContentID])#" cfsqltype="cf_sql_integer">
					WHERE ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfloop>
			<cfquery name="GetParentID" datasource="#APPLICATION.DSN#">
				select CategoryID from t_ContentCategory
				where ContentID=<cfqueryparam value="#Val(ListFirst(StructKeyList(sNewPriorities)))#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="GetCatsAgain" datasource="#APPLICATION.DSN#">
				select ContentID,ContentPriority from qry_GetContent
				where CategoryID=<cfqueryparam value="#Val(GetParentID.CategoryID)#" cfsqltype="cf_sql_integer"> order by ContentPriority
			</cfquery>
			<cfoutput query="GetCatsAgain">
				<cfquery name="UpdateAgain" datasource="#APPLICATION.DSN#">
					UPDATE t_Content
					SET ContentPriority = <cfqueryparam value="#val(CurrentRow * 10)#" cfsqltype="cf_sql_integer">
					WHERE ContentID=<cfqueryparam value="#Val(ContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfoutput>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="ContentActiveBitUpdate" returntype="boolean" output="false">
		<cfargument name="ContentID" required="true">
		<cfargument name="ContentActive" required="true">

		<!--- init variables --->
		<cfset var UpdateShowContent = "">

		<cfif ARGUMENTS.ContentID GT "0">
			<cfquery name="UpdateShowContent" datasource="#Application.DSN#">
				UPDATE	t_Content
				SET		ContentActive = <cfqueryparam value="#ARGUMENTS.ContentActive#" cfsqltype="cf_sql_bit">
				WHERE	contentid = <cfqueryparam value="#ARGUMENTS.ContentID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="ContentID" required="true">
		<cfargument name="WebrootPath" required="true">

		<!--- init variables --->
		<cfset var ThisID=ARGUMENTS.ContentID>
		<cfset var DirDone = "">
		<cfset var DirectoryToCreate = "">
		<cfset var i = "">

		<cfif Val(ARGUMENTS.ContentID) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#ThisID#" ReturnVarName="PathFragment">
			<cfset DirDone="">
			<cfloop index="i" from="1" to="#Len(ThisID)#" step="1">
				<cfset DirectoryToCreate="#ARGUMENTS.WebRootPath##Application.ContentResourcesPath##DirDone##Mid(ThisID,i,1)#">
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
		<cfargument name="ContentID" required="true">
		<cfargument name="ResourceType" required="true">

		<!--- init variables --->
		<cfset var ThisID=ARGUMENTS.ContentID>
		<cfset var ReturnString="">

		<cfif Val(ThisID) LTE "0" or ListFindNoCase("images,documents,generated,root",ARGUMENTS.ResourceType) LTE "0">
			<cfset ReturnString="/#ReplaceNoCase(APPLICATION.UploadPath,'\','/','all')#">
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm"
				String="#ThisID#"
				ReturnVarName="PathFragment"
				Delimiter="/">

			<!--- check if this is the root level --->
			<cfif ARGUMENTS.ResourceType IS "root">
				<cfset ReturnString="/#Application.ContentResourcesPath##PathFragment#/">
			<cfelse>
				<cfset ReturnString="/#Application.ContentResourcesPath##PathFragment#/#lcase(ARGUMENTS.ResourceType)#/">
			</cfif>
			<cfset ReturnString=ReplaceNoCase(ReturnString,"\","/","All")>
			<cfset ReturnString=ReplaceNoCase(ReturnString,"//","/","All")>
		</cfif>
		<cfreturn ReturnString>
	</cffunction>

	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ContentID" required="true">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">

		<!--- init variables --->
		<cfset var ThisID=ARGUMENTS.ContentID>
		<cfset var ReturnString="">

		<cfif Val(ThisID) LTE "0" or ListFindNoCase("images,documents,generated,root",ARGUMENTS.ResourceType) LTE "0">
			<cfset ReturnString="#ARGUMENTS.WebrootPath##APPLICATION.UploadPath#">
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm"
				String="#ThisID#"
				ReturnVarName="PathFragment"
				Delimited="\">
			<cfif ARGUMENTS.ResourceType IS "root">
				<cfset ReturnString="#ARGUMENTS.WebrootPath##Application.ContentResourcesPath##PathFragment#\">
			<cfelse>
				<cfset ReturnString="#ARGUMENTS.WebrootPath##Application.ContentResourcesPath##PathFragment##lcase(ARGUMENTS.ResourceType)#\">
			</cfif>
		</cfif>
		<cfreturn ReturnString>
	</cffunction>

	<cffunction name="CreateRemoteFolders" returntype="boolean" output="true">
		<cfargument name="ContentID" required="true">
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
		<cfset var connectionName = APPLICATION.utilsObj.createUniqueId()>
		<cfset var ftpResult = structNew()>

		<cfmodule template="/common/modules/utils/ExplodeString.cfm" Delimiter="/" String="#ARGUMENTS.ContentID#" ReturnVarName="PathFragment">
		<cfset FinalPath=Replace("#ARGUMENTS.FTPRootPath##APPLICATION.ContentResourcesPath##PathFragment#","\","/","All")>
		<cfset CreateFolders="no">

		<!--- open the ftp connection to the production site --->
		<cfftp	action="open"
				username="#ARGUMENTS.FTPUserLogin#"
				password="#ARGUMENTS.FTPPassword#"
				server="#ARGUMENTS.FTPHost#"
				stoponerror="NO"
				connection="#connectionName#">

		<cfloop index="ThisDirectoryFragment" list="/,/images,/documents,/generated">
			<cfftp action="EXISTSDIR"
					stoponerror="NO"
					result="ftpResult"
					directory="#FinalPath##ThisDirectoryFragment#"
					connection="#connectionName#">
			<cfif ftpResult.returnValue IS "no">
				<cfset CreateFolders="Yes">
			</cfif>
		</cfloop>
		<cfif CreateFolders>
			<cfset DirDone="">
			<cfloop index="i" from="1" to="#Len(ARGUMENTS.ContentID)#" step="1">
				<cfset DirectoryToCreate="#ARGUMENTS.FTPRootPath#/#APPLICATION.ContentResourcesPath##DirDone##Mid(ARGUMENTS.ContentID,i,1)#">
				<cfset DirectoryToCreate=ReplaceNoCase(DirectoryToCreate,"\","/","All")>
				<cfset DirDone="#DirDone##Mid(ARGUMENTS.ContentID,i,1)#/">
				<cfloop index="ThisDirectoryFragment" list="/,/images/,/documents/,/generated/">
					<cfftp action="CREATEDIR"
							directory="#DirectoryToCreate##ThisDirectoryFragment#"
							stoponerror="NO"
							connection="#connectionName#">
					created dir: #DirectoryToCreate##ThisDirectoryFragment#<BR>
				</cfloop>
			</cfloop>
		<cfelse>
			#FinalPath# already exists skipping<BR>
		</cfif>

		<!--- close the connection --->
		<cfftp	action="close"
				stopOnError="NO"
				connection="#connectionName#">

		<cfreturn true>
	</cffunction>

	<cffunction name="GetCategoryID" output="false" returntype="numeric">
		<cfargument name="ContentID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			SELECT	CategoryID
			FROM	t_Content
			WHERE	ContentID = <cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif Check.RecordCount IS "1">
			<cfreturn Check.CategoryID>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>

	<cffunction name="GetContentLocaleID" output="false" returntype="numeric">
		<cfargument name="ContentID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			SELECT ContentLocaleID FROM t_ContentLocale WHERE ContentID=<cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer"> And LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif Check.RecordCount IS "1">
			<cfreturn Check.ContentLocaleID>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>

	<cffunction name="GetOtherContentLocale" output="false" returntype="query">
		<cfargument name="ContentID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			SELECT		*
			FROM		t_ContentLocale
			INNER JOIN	t_Locale
			ON 			t_ContentLocale.LocaleID = t_Locale.LocaleID
			WHERE 		ContentID = <cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
			ORDER BY	LocaleName
		</cfquery>
		<cfreturn Check>
	</cffunction>

	<cffunction name="GetTokenList" returntype="string" output="false">
		<cfargument name="ContentID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var local = structNew() />

		<cfinvoke component="com.ContentManager.ContentHandler"
			method="GetContentLocaleID"
			returnVariable="local.EditContentLocaleID"
			ContentID="#Val(ARGUMENTS.ContentID)#"
			LocaleID="#Val(ARGUMENTS.LocaleID)#">
		<cfset local.MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
		<cfset local.MyContentLocale.Constructor(Val(local.EditContentLocaleID))>

		<cfset local.StringToTest=local.MyContentLocale.GetProperty("HTMLTemplate")>
		<cfinvoke component="com.utils.utils"
			method="extractByToken"
			content="#local.StringToTest#"
			startToken="[["
			endToken="]]"
			returnvariable="local.lExtracted">
		<cfreturn local.lExtracted>
	</cffunction>

	<cffunction name="UpdatePriorityByContentDate" returntype="boolean" output="false">
		<cfargument name="CategoryID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">

		<!--- init variables --->
		<cfset var GetEvents = "">
		<cfset var update = "">

		<cfquery name="GetEvents" datasource="#APPLICATION.DSN#">
			SELECT		ContentDate1,ContentID
			FROM		t_Content
			WHERE		CategoryID = <cfqueryparam value="#val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
			ORDER BY	ContentDate1 DESC
		</cfquery>
		<cfoutput query="GetEvents">
			<cfquery name="update" datasource="#APPLICATION.DSN#">
				UPDATE	t_ContentLocaleMeta
				SET		ContentLocalePriority = <cfqueryparam value="#val(CurrentRow*10)#" cfsqltype="cf_sql_integer">
				WHERE	ContentID = <cfqueryparam value="#val(ContentID)#" cfsqltype="cf_sql_integer">
				AND		LocaleID = <cfqueryparam value="#val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfoutput>
		<cfreturn true>
	</cffunction>

	<cffunction name="GetContentIDByEventID" returntype="boolean" output="false">
		<cfargument name="EventID" required="true" default="0">

		<!--- init variables --->
		<cfset var selectContentID = "">

		<cfquery name="selectContentID" datasource="#Application.DSN#">
			SELECT	ContentID
			FROM	t_Content
			WHERE	SourceID = <cfqueryparam value="#val(ARGUMENTS.EventID)#" cfsqltype="cf_sql_integer">
			AND		ContentTypeID = <cfqueryparam value="235" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn Val(selectContentID.ContentID)>
	</cffunction>

	<cffunction name="attachDiscussionEntry" returntype="boolean" output="false">
		<cfargument name="contentID" type="numeric" required="yes">
		<cfargument name="entryID" type="numeric" required="yes">

		<!--- init variables --->
		<cfset var update = "">

		<cftry>
			<cfquery name="update" datasource="#APPLICATION.DSN#">
				UPDATE	t_Content
				SET		entryID = <cfqueryparam value="#val(ARGUMENTS.entryId)#" cfsqltype="cf_sql_integer">
				WHERE	ContentID = <cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfcatch>
				<cfreturn false>
			</cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>

	<cffunction name="GetContentName" output="false" returntype="string">
		<cfargument name="ContentID" default="-1" type="numeric" required="true">

		<!--- init variables --->
		<cfset var Check = "">

		<cfquery name="Check" datasource="#APPLICATION.DSN#">
			SELECT	ContentName
			FROM	t_Content
			WHERE	ContentID = <cfqueryparam value="#Val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn Check.ContentName>
	</cffunction>

	<cffunction name="getVideos" output="false" returntype="query">
		
		<cfset var LOCAL=StructNew()>

		<cfdirectory action="list" directory="#APPLICATION.videoSourceDirectory#" filter="*.mp4" name="LOCAL.qReturn">

		<cfreturn LOCAL.qReturn>
		
	</cffunction>

	<cffunction name="TestAndTouchIfRepeated" output="false" returntype="string">
		<cfargument name="ContentID" default="-1" type="numeric" required="true">
		<cfargument name="Datasource" default="#APPLICATION.DSN#" type="String" required="true">

		<!--- init variables --->
		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.TestIfIamRepeated" datasource="#ARGUMENTS.Datasource#">
			select categoryID from qry_GetContent
			where
			ContentTypeID=<cfqueryparam value="206" cfsqltype="cf_sql_integer"> and
			SourceID=<cfqueryparam value="#Val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif LOCAL.TestIfIamRepeated.RecordCount GT "0">
			<cfquery name="UpdateCacheDateTimeofRepeated" datasource="#ARGUMENTS.Datasource#">
				update t_Category set CacheDateTime=GetDate()
				Where CategoryID IN (<cfqueryparam value="#ValueList(LOCAL.TestIfIamRepeated.CategoryID)#" cfsqltype="cf_sql_integer" List="yes">)
			</cfquery>
		</cfif>

		<cfreturn LOCAL.TestIfIamRepeated.RecordCount>
	</cffunction>
</cfcomponent>