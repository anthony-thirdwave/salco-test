<cffunction name="GetResource" returntype="query" output="false">
	<cfargument name="ResourceID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<cfquery name="LOCAL.GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale 
		Where LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif LOCAL.GetLang.RecordCount IS "1">
		<cfset LOCAL.CurrentLanguageID="#Val(GetLang.LanguageID)#">
	<cfelse>
		<cfset LOCAL.CurrentLanguageID="100">
	</cfif>
	<cfquery name="LOCAL.GetResource" datasource="#APPLICATION.DSN#" maxrows="1">
		select * FROM qry_GetResource 
		WHERE 
		ResourceID=<cfqueryparam value="#Val(ARGUMENTS.ResourceID)#" cfsqltype="cf_sql_integer"> AND
		(LanguageID=<cfqueryparam value="100" cfsqltype="cf_sql_integer"> Or 
		LanguageID=<cfqueryparam value="#Val(CurrentLanguageID)#" cfsqltype="cf_sql_integer">)
		order by LanguageID DESC
	</cfquery>
	<cfquery name="LOCAL.GetResourceEnglish" datasource="#APPLICATION.DSN#" maxrows="1">
		select * FROM qry_GetResource WHERE ResourceID=<cfqueryparam value="#Val(ARGUMENTS.ResourceID)#" cfsqltype="cf_sql_integer"> AND
		LanguageID=<cfqueryparam value="100" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif LOCAL.GetResource.RecordCount GT "0">
		<cfset QuerySetCell(LOCAL.GetResource,"MainFilePath",LOCAL.GetResourceEnglish.MainFilePath)>
		<cfset QuerySetCell(LOCAL.GetResource,"ThumbnailFilePath",LOCAL.GetResourceEnglish.ThumbnailFilePath)>
	</cfif>
	<cfreturn LOCAL.GetResource>
</cffunction>

<cffunction name="GetProductResource" returntype="query" output="false">
	<cfargument name="ProductID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<cfquery name="LOCAL.GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale 
		Where LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif LOCAL.GetLang.RecordCount IS "1">
		<cfset LOCAL.CurrentLanguageID="#Val(GetLang.LanguageID)#">
	</cfif>
	<cfquery name="LOCAL.GetResource" datasource="#APPLICATION.DSN#">
		select * FROM qry_GetResource 
		WHERE 
		KeyID=<cfqueryparam value="#Val(ARGUMENTS.ProductID)#" cfsqltype="cf_sql_integer"> AND 
		Entity=<cfqueryparam value="t_category" cfsqltype="cf_sql_varchar"> AND 
		LanguageID=<cfqueryparam value="#Val(CurrentLanguageID)#" cfsqltype="cf_sql_integer">
		order by ResourcePriority, LanguageID DESC
	</cfquery>
	<cfreturn LOCAL.GetResource>
</cffunction>

<cffunction name="GetResourceOwnerName" returntype="string" output="false">
	<cfargument name="ResourceID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<cfquery name="LOCAL.GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale Where LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif LOCAL.GetLang.RecordCount IS "1">
		<cfset LOCAL.CurrentLanguageID="#Val(GetLang.LanguageID)#">
	</cfif>
	<cfquery name="LOCAL.GetResource" datasource="#APPLICATION.DSN#" maxrows="1">
		select KeyID,Entity FROM t_Resource Where ResourceID=<cfqueryparam value="#Val(ARGUMENTS.ResourceID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif LOCAL.GetResource.RecordCount IS "1">
		<cfswitch expression="#LOCAL.GetResource.Entity#">
			<cfcase value="t_Category">
				<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
					<cfprocresult name="LOCAL.GetPage">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(LOCAL.GetResource.KeyID)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
				</cfstoredproc>
				<cfreturn LOCAL.GetPage.CategoryNameDerived>
			</cfcase>
			<cfdefaultcase></cfdefaultcase>
		</cfswitch>
	</cfif>
	<cfreturn "">
</cffunction>

<cffunction name="SaveResource" returntype="boolean" output="false">
	<cfargument name="aResource" default="" type="array" required="true">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	<cfargument name="LanguageID" default="" type="numeric" required="true">
	<cfargument name="ResourceTypeID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<!--- Start of save of product family views --->
	<cfquery name="LOCAL.GetPrev" datasource="#APPLICATION.DSN#">
		select * from qry_GetResource
		WHERE KeyID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and 
		Entity=<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar"> and 
		languageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer"> and 
		ResourceTypeID=<cfqueryparam value="#Val(ARGUMENTS.ResourceTypeID)#" cfsqltype="cf_sql_integer">
		Order by ResourcePriority
	</cfquery>
	<cfset LOCAL.OriginalList=ValueList(GetPrev.ResourceID)>
	<cfset LOCAL.NewList="">
	<cfloop index="LOCAL.r" from="1" to="#ArrayLen(ARGUMENTS.aResource)#">
		<cfif ARGUMENTS.aResource[LOCAL.r].ResourceID GT "0">
			<cfset LOCAL.NewList=ListAppend(LOCAL.NewList,ARGUMENTS.aResource[LOCAL.r].ResourceID)>
		</cfif>
	</cfloop>
	
	<CF_Venn
		ListA="#LOCAL.OriginalList#"
		ListB="#LOCAL.NewList#"
		AnotB="LOCAL.ListToDelete">
	
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetResourcePath"
		returnVariable="DestinationDirectoryImages"
		CategoryID="#ARGUMENTS.CategoryID#"
		ResourceType="images">
		
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetResourcePath"
		returnVariable="DestinationDirectoryDocuments"
		CategoryID="#ARGUMENTS.CategoryID#"
		ResourceType="documents">
		
	<cfloop index="LOCAL.r" from="1" to="#ArrayLen(ARGUMENTS.aResource)#">
		<cfset LOCAL.ThisPriority=r*10>
		<cfset LOCAL.ThisSpecificationSetID=ARGUMENTS.aResource[LOCAL.r].SpecificationSetID>
		<cfif ARGUMENTS.aResource[LOCAL.r].ResourceID GT "0">
			<cfset LOCAL.ThisResourceID=ARGUMENTS.aResource[LOCAL.r].ResourceID>
			<cfquery name="LOCAL.update" datasource="#APPLICATION.DSN#">
				update t_Resource Set
				ResourcePriority=<cfqueryparam value="#Val(LOCAL.ThisPriority)#" cfsqltype="cf_sql_integer">,
				SpecificationSetID=<cfqueryparam value="#Val(LOCAL.ThisSpecificationSetID)#" cfsqltype="cf_sql_integer">
				WHERE ResourceID=<cfqueryparam value="#Val(LOCAL.ThisResourceID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="LOCAL.Test" datasource="#APPLICATION.DSN#">
				select * from t_ResourceLanguage 
				WHERE ResourceID=<cfqueryparam value="#Val(LOCAL.ThisResourceID)#" cfsqltype="cf_sql_integer"> and 
				LanguageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif LOCAL.Test.RecordCount IS "0">
				<cfquery name="LOCAL.insert" datasource="#APPLICATION.DSN#">
					Insert into t_ResourceLanguage 
					(ResourceName, ResourceText, MainFilePath, ThumbnailFilePath, ResourceID, LanguageID)
					VALUES
					(<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ResourceName)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ResourceText)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].MainFilePath)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ThumbnailFilePath)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Val(LOCAL.ThisResourceID)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value=">#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">)
				</cfquery>
			<cfelse>
				<cfquery name="LOCAL.update" datasource="#APPLICATION.DSN#">
					update t_ResourceLanguage Set
					ResourceName=<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ResourceName)#" cfsqltype="cf_sql_varchar">,
					ResourceText=<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ResourceText)#" cfsqltype="cf_sql_varchar">,
					MainFilePath=<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].MainFilePath)#" cfsqltype="cf_sql_varchar">,
					ThumbnailFilePath=<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ThumbnailFilePath)#" cfsqltype="cf_sql_varchar">
					WHERE ResourceID=<cfqueryparam value="#Val(LOCAL.ThisResourceID)#" cfsqltype="cf_sql_integer"> and 
					LanguageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		<Cfelse>
			<cfquery name="LOCAL.insert" datasource="#APPLICATION.DSN#">
				SET NOCOUNT ON
				INSERT INTO t_Resource 
				(Entity, KeyID, ResourcePriority, SpecificationSetID, ResourceTypeID)
				VALUES
				(<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Val(LOCAL.ThisPriority)#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Val(LOCAL.ThisSpecificationSetID)#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Val(ARGUMENTS.ResourceTypeID)#" cfsqltype="cf_sql_integer">)
				SELECT NewID=@@Identity
			</cfquery>
			<cfset LOCAL.ThisResourceID=insert.NewID>
			<cfquery name="insert" datasource="#APPLICATION.DSN#">
				Insert into t_ResourceLanguage 
				(ResourceName, ResourceText, MainFilePath, ThumbnailFilePath, ResourceID, LanguageID)
				VALUES
				(<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ResourceName)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ResourceText)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].MainFilePath)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Trim(ARGUMENTS.aResource[LOCAL.r].ThumbnailFilePath)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Val(LOCAL.ThisResourceID)#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">)
			</cfquery>
		</cfif>
		
		<cfloop index="LOCAL.ThisFileType" list="MainFilePath,ThumbnailFilePath">
			<cfif StructFind(ARGUMENTS.aResource[LOCAL.r],LOCAL.ThisFileType IS NOT "" AND left(StructFind(ARGUMENTS.aResource[LOCAL.r],LOCAL.ThisFileType),len("/common/incoming")) IS "/common/incoming">
				<cfset LOCAL.SourceFile=ExpandPath(StructFind(ARGUMENTS.aResource[LOCAL.r],LOCAL.ThisFileType))>
				<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast(LOCAL.SourceFile,'.')#",";") GT "0">
					<cfset ThisDestinationDirectory="#DestinationDirectoryImages#">
				<cfelse>
					<cfset ThisDestinationDirectory="#DestinationDirectoryDocuments#">
				</cfif>
				<cffile action="move" source="#LOCAL.SourceFile#" destination="#ExpandPath(ThisDestinationDirectory)#">
				<cfquery name="LOCAL.update" datasource="#APPLICATION.DSN#">
					update t_ResourceLanguage Set
					#LOCAL.ThisFileType#=<cfqueryparam value="#ThisDestinationDirectory##GetFileFromPath(LOCAL.SourceFile)#" cfsqltype="cf_sql_varchar">
					WHERE ResourceID=<cfqueryparam value="#Val(LOCAL.ThisResourceID)#" cfsqltype="cf_sql_integer"> and 
					LanguageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfloop>
	</cfloop>
	
	<cfloop index="LOCAL.ThisID" list="#LOCAL.ListToDelete#">
		<!--- Add file delete routines here --->
		<cfquery name="LOCAL.DeleteOthers2" datasource="#APPLICATION.DSN#">
			DELETE FROM t_ResourceLanguage
			WHERE ResourceID=<cfqueryparam value="#Val(LOCAL.ThisID)#" cfsqltype="cf_sql_integer"> AND 
			LanguageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfloop>

	<cfreturn true>
</cffunction>