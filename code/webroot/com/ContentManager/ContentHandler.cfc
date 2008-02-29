<cffunction name="CheckDuplicateAlias" output="false" returntype="boolean">
	<cfargument name="CandidateAlias" default="" type="string" required="true">
	<cfargument name="ContentID" default="" type="numeric" required="true">
	
	<!--- init variables --->
	<cfset var CheckAlias = "">
	
	<cfquery name="CheckAlias" datasource="#APPLICATION.DSN#">
		SELECT * FROM t_Content WHERE ContentAlias=<cfqueryparam value="#Trim(ARGUMENTS.CandidateAlias)#" cfsqltype="cf_sql_varchar"> AND ContentID <> <cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif CheckAlias.RecordCount IS NOT "0">
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>
<cffunction name="GetContentQuery" output="false" returntype="query">
	<cfargument name="CategoryID" default="-1" type="numeric" required="true">
	
	<!--- init variables --->
	<cfset var GetContentQuery = "">
	
	<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
		SELECT * FROM qry_GetContent 
		WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">
		Order By ContentPriority
	</cfquery>
	<cfreturn GetContentQuery>
</cffunction>
<cffunction name="GetContentTemplatePicker" output="false" returntype="query">
	
	<!--- init variables --->
	<cfset var GetContentQuery = "">
	
	<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
		select * from qry_GetCategoryContentPicker
		WHERE ContentTypeID = 233
		Order By DisplayOrder,ContentPriority
	</cfquery>
	<cfreturn GetContentQuery>
</cffunction>

<cffunction name="GetContentPicker" output="false" returntype="query">
	<cfargument name="ContentTypeID" default="" required="false" type="any"/>
	<cfargument name="LocaleID" default="-1" required="Yes" type="any"/>
	
	<!--- init variables --->
	<cfset var GetContentQuery = "">
	
	<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
		select * from qry_GetCategoryContentPicker
		WHERE 
		<cfif arguments.ContentTypeID eq 245><!--- Only pull up content from the "Banner Depository" type category --->
			CategoryTypeID=74 and
		</cfif>
		LocaleID =#Val(ARGUMENTS.LocaleID)# and 
		ContentTypeID not in (206,207) and ContentPositionID <> 403
		Order By DisplayOrder,ContentPriority
	</cfquery>
	<cfreturn GetContentQuery>
</cffunction>

<cffunction name="GetEventPicker" output="false" returntype="query">
	<cfargument name="LocaleID" default="" required="false" type="any"/>
	
	<!--- init variables --->
	<cfset var GetEvents = "">
	
	<cfquery name="GetEvents" datasource="#APPLICATION.DSN#">
		select * from qry_GetContentLocale
		Where LocaleID=#Val(ARGUMENTS.LocaleID)#
		and ContentTypeID=235
		order by ContentDate1 Desc
	</cfquery>
	<cfreturn GetEvents>
</cffunction>


<cffunction name="GetContentSourceID" output="false" returntype="numeric">
	<cfargument name="ContentID" required="true" type="numeric">
	
	<!--- init variables --->
	<cfset var GetContentQuery = "">
	
	<cfquery name="GetContentQuery" datasource="#APPLICATION.DSN#">
		select SourceID from t_Content
		WHERE ContentID=<cfqueryparam value="#Val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfreturn Val(GetContentQuery.SourceID)>
</cffunction>

<cffunction name="GetContentTypeQuery" output="false" returntype="query">
	
	<!--- init variables --->
	<cfset var Test = "">
	
	<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
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
	
	<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
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
				SET ContentPriority = <cfqueryparam value="#val(evaluate('#CurrentRow#*10'))#" cfsqltype="cf_sql_integer">
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
			UPDATE t_Content SET ContentActive=<cfqueryparam value="#ARGUMENTS.ContentActive#" cfsqltype="cf_sql_bit"> WHERE contentid = <cfqueryparam value="#ARGUMENTS.ContentID#" cfsqltype="cf_sql_integer">
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
	
	<cfmodule template="/common/modules/utils/ExplodeString.cfm" Delimiter="/" String="#ARGUMENTS.ContentID#" ReturnVarName="PathFragment">
	<cfset FinalPath=Replace("#ARGUMENTS.FTPRootPath##APPLICATION.ContentResourcesPath##PathFragment#","\","/","All")>
	<cfset CreateFolders="no">
	<cfloop index="ThisDirectoryFragment" list="/,/images,/documents,/generated">
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
		<cfftp action="CLOSE" connection="FTP_#ReplaceNoCase(ARGUMENTS.FTPHost,'.','','all')#">
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

<cffunction name="GetCategoryID" output="false" returntype="numeric">
	<cfargument name="ContentID" default="" type="numeric" required="true">
	
	<!--- init variables --->
	<cfset var Check = "">
	
	<cfquery name="Check" datasource="#APPLICATION.DSN#">
		SELECT CategoryID FROM t_Content WHERE ContentID=<cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
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
		SELECT * FROM  t_ContentLocale INNER JOIN
        t_Locale ON t_ContentLocale.LocaleID = t_Locale.LocaleID WHERE ContentID=<cfqueryparam value="#val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer"> Order by LocaleNAme
	</cfquery>
	<cfreturn Check>
</cffunction>

<cffunction name="GetTokenList" returntype="string" output="false">
	<cfargument name="ContentID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	
	<!--- init variables --->
	<cfset var EditContentLocaleID = "">
	<cfset var MyContentLocale = "">
	<cfset var StringToTest = "">
	
	<cfinvoke component="/com/ContentManager/ContentHandler" 
		method="GetContentLocaleID" 
		returnVariable="EditContentLocaleID"
		ContentID="#Val(ARGUMENTS.ContentID)#"
		LocaleID="#Val(ARGUMENTS.LocaleID)#">
	<cfset MyContentLocale=CreateObject("component","//com/ContentManager/ContentLocale")>
	<cfset MyContentLocale.Constructor(Val(EditContentLocaleID))>

	<cfset StringToTest=MyContentLocale.GetProperty("HTMLTemplate")>
	<cfinvoke	component="/com/utils/utils"
		method="extractByToken"
		content="#StringToTest#"
		startToken="[["
		endToken="]]"
		returnvariable="lExtracted">
	<cfreturn lExtracted>
	
</cffunction>

<cffunction name="UpdatePriorityByContentDate" returntype="boolean" output="false">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	
	<!--- init variables --->
	<cfset var GetEvents = "">
	<cfset var update = "">
	
	<cfquery name="GetEvents" datasource="#APPLICATION.DSN#">
		select ContentDate1,ContentID from t_Content 
		Where CategoryID=#Val(ARGUMENTS.CategoryID)# order by ContentDate1 desc
	</cfquery>
	<cfoutput query="GetEvents">
		<cfquery name="update" datasource="#APPLICATION.DSN#">
			update t_ContentLocaleMeta 
			Set ContentLocalePriority=#CurrentRow*10# where 
			ContentID = #ContentID# and LocaleID=#Val(ARGUMENTS.LocaleID)#
		</cfquery>
	</cfoutput>
	<cfreturn true>
</cffunction>

<cffunction name="GetContentIDByEventID" returntype="boolean" output="false">
	<cfargument name="EventID" required="true" default="0">
	
	<!--- init variables --->
	<cfset var selectContentID = "">
	
	<cfquery name="selectContentID" datasource="#Application.DSN#">
		select ContentID from t_Content Where SourceID=#Val(ARGUMENTS.EventID)# and ContentTypeID=235
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
			SET		entryID=#ARGUMENTS.entryID#
			WHERE	ContentID = #ARGUMENTS.ContentID#
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
		select ContentName from t_Content
		WHERE ContentID=<cfqueryparam value="#Val(ARGUMENTS.ContentID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfreturn Check.ContentName>
</cffunction>