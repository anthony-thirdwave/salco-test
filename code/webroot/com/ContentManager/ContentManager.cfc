<cffunction name="GetColumnOutput" output="1" returntype="string">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	<cfargument name="ContentPositionID" default="" type="numeric" required="true">
	
	<cfset VAR CategoryThreadList="">
	<cfset VAR FileContents="">
	<cfset VAR ContentCounter="1">
	<cfset VAR centerCounter=0>
	
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetCategoryBasicDetails"
		returnVariable="GetCategory"
		CategoryID="#ARGUMENTS.CategoryID#">
		
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#ARGUMENTS.CategoryID#"
		namelist="#APPLICATION.utilsObj.RemoveHTML(Replace(GetCategory.CategoryName,',',' ','all'))#"
		idlist="#ARGUMENTS.CategoryID#"
		aliaslist="#GetCategory.CategoryAlias#">
	<cfif IDList IS NOT "">
		<cfset CategoryThreadList=IDList>
	<cfelse>
		<cfset CategoryThreadList=ARGUMENTS.CategoryID>
	</cfif>
	
	<cfquery name="GetInherited" datasource="#APPLICATION.DSN#">
		SELECT		ContentID 
		FROM		qry_GetContentInherit
		WHERE		ContentPositionID = <cfqueryparam value="#Val(ARGUMENTS.ContentPositionID)#" cfsqltype="CF_SQL_INTEGER">
		AND			LocaleID = <cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
		AND			ContentActive = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
		AND			CategoryActive = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
		AND			(
						(
						CategoryID = <cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="CF_SQL_INTEGER"> 
						AND (
							InheritID <= <cfqueryparam value="1800" cfsqltype="CF_SQL_INTEGER"> 
							OR InheritID = <cfqueryparam value="" cfsqltype="CF_SQL_INTEGER" null="Yes">
							)
						)
					OR
						(
						CategoryID IN (<cfqueryparam value="#CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">)
						AND	InheritID = <cfqueryparam value="1801" cfsqltype="CF_SQL_INTEGER">
						)
					OR
						(
						CategoryID IN (<cfqueryparam value="#ListDeleteAt(CategoryThreadList,ListLen(CategoryThreadList))#" cfsqltype="cf_sql_integer" list="yes">) 
						AND InheritID=<cfqueryparam value="1802" cfsqltype="CF_SQL_INTEGER">
						)
					)
		ORDER BY	displayorder DESC, ContentLocalePriority
	</cfquery>
				
	<cfif GetInherited.RecordCount IS "0">
		<cfquery name="GetInherited" datasource="#APPLICATION.DSN#" maxrows="1">
			select ContentID from qry_GetContentInherit
			Where
			ContentPositionID=<cfqueryparam value="#Val(ARGUMENTS.ContentPositionID)#" cfsqltype="CF_SQL_INTEGER">
			AND LocaleID=<cfqueryparam value="#ARGUMENTS.LocaleID#" cfsqltype="CF_SQL_INTEGER">
			AND ContentActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
			AND CategoryActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
			AND CategoryID IN (<cfqueryparam value="#CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">)
			AND InheritID=<cfqueryparam value="1803" cfsqltype="CF_SQL_INTEGER">
			order by displayorder desc, ContentLocalePriority
		</cfquery>
	</cfif>
	
	<cfloop index="ThisContentID" list="#ValueList(GetInherited.ContentID)#">
		<cfif Isdefined("URL.prcid") and application.utilsObj.SimpleDecrypt(Val(URL.prcid)) IS ThisContentID>
			<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetContent">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(application.utilsObj.SimpleDecrypt(Val(pcid)))#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>
		<cfelse>
			<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetContent">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(ThisContentID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>
		</cfif>
		<cfoutput query="GetContent">
			<cfif ARGUMENTS.ContentPositionID IS "401">
				<cfset centerCounter = centerCounter+1>
			</cfif>
			<cfif IsWDDX(ContentBody)>
				<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
			<cfelse>
				<cfset sContentBody=StructNew()>
			</cfif>
			<cfmodule template="/common/modules/ContentManager/ContentControl.cfm"
				scontentbody="#sContentBody#"
				currentcategoryid="#ARGUMENTS.CategoryID#"
				currentcategorytypeid="#GetCategory.CategoryTypeID#"
				contenttypeid="#ContentTypeID#"
				contentid="#ContentID#"
				ContentLocaleID="#ContentLocaleID#"
				positionid="#ARGUMENTS.ContentPositionID#"
				returnvariable="TheseFileContents">
			<cfif Trim(TheseFileContents) IS NOT "">
				<cfif IsDefined("URL.ShowContentOnly") AND Val(URL.ShowContentOnly)>
					<cfset FileContents="#FileContents# #TheseFileContents#">
				<cfelse>
					<cfset Title="">
					<cfif StructKeyExists(sContentBody,"TitleTypeID")>
						<cfinclude template="/common/modules/ContentManager/TitleControl.cfm">
					</cfif>
					<cfif StructKeyExists(sContentBody,"CSSID") and sContentBody["CSSID"] IS NOT "">
						<cfset ThisCSSID=sContentBody["CSSID"]>
					<cfelse>
						<cfset ThisCSSID="ContentElement#ContentID#">
					</cfif>
					<cfswitch expression="#APPLICATION.ApplicationName#">
						<cfdefaultcase>
							<cfsavecontent variable="FileContents">
								#FileContents#
								<!-- START OF "#ContentNameDerived#" CONTENT BLOCK (#ContentID#) -->
								<div id="#ThisCSSID#" class="#lcase(application.utilsObj.scrub(ContentTypeName))# position#ContentCounter#">
									#Title# #TheseFileContents#
								</div>
								<!-- END OF "#ContentNameDerived#" CONTENT BLOCK -->
							</cfsavecontent>
						</cfdefaultcase>
					</cfswitch>
					<cfset ContentCounter=ContentCounter+1>
				</cfif>
			</cfif>
		</cfoutput>
	</cfloop>

	<cfreturn FileContents>
</cffunction>