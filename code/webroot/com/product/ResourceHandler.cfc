<cffunction name="GetResource" returntype="query" output="false">
	<cfargument name="ResourceID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale Where LocaleID=#Val(ARGUMENTS.LocaleID)#
	</cfquery>
	<cfif GetLang.RecordCount IS "1">
		<cfset CurrentLanguageID="#Val(GetLang.LanguageID)#">
	<cfelse>
		<cfset CurrentLanguageID="100">
	</cfif>
	<cfquery name="GetResource" datasource="#APPLICATION.DSN#" maxrows="1">
		select * FROM qry_GetResource WHERE ResourceID=#Val(ARGUMENTS.ResourceID)# AND
		(LanguageID =100 Or LanguageID=#Val(CurrentLanguageID)#)
		order by LanguageID DESC
	</cfquery>
	<cfquery name="GetResourceEnglish" datasource="#APPLICATION.DSN#" maxrows="1">
		select * FROM qry_GetResource WHERE ResourceID=#Val(ARGUMENTS.ResourceID)# AND
		LanguageID=100
	</cfquery>
	<cfif GetResource.RecordCount GT "0">
		<cfset QuerySetCell(GetResource,"MainFilePath",GetResourceEnglish.MainFilePath)>
		<cfset QuerySetCell(GetResource,"ThumbnailFilePath",GetResourceEnglish.ThumbnailFilePath)>
	</cfif>
	<cfreturn GetResource>
</cffunction>

<cffunction name="GetProductResource" returntype="query" output="false">
	<cfargument name="ProductID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale Where LocaleID=#Val(ARGUMENTS.LocaleID)#
	</cfquery>
	<cfif GetLang.RecordCount IS "1">
		<cfset CurrentLanguageID="#Val(GetLang.LanguageID)#">
	</cfif>
	<cfquery name="GetResource" datasource="#APPLICATION.DSN#">
		select * FROM qry_GetResource WHERE KeyID=#Val(ARGUMENTS.ProductID)# AND Entity='t_category' AND 
		LanguageID=#Val(CurrentLanguageID)#
		order by ResourcePriority, LanguageID DESC
	</cfquery>
	<cfreturn GetResource>
</cffunction>

<cffunction name="GetResourceOwnerName" returntype="string" output="false">
	<cfargument name="ResourceID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale Where LocaleID=#Val(ARGUMENTS.LocaleID)#
	</cfquery>
	<cfif GetLang.RecordCount IS "1">
		<cfset CurrentLanguageID="#Val(GetLang.LanguageID)#">
	</cfif>
	<cfquery name="GetResource" datasource="#APPLICATION.DSN#" maxrows="1">
		select KeyID,Entity FROM t_Resource Where ResourceID=#Val(ARGUMENTS.ResourceID)#
	</cfquery>
	<cfif GetResource.RecordCount IS "1">
		<cfswitch expression="#GetResource.Entity#">
			<cfcase value="t_Category">
				<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetPage">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetResource.KeyID)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
				</cfstoredproc>
				<cfreturn GetPage.CategoryNameDerived>
			</cfcase>
			<cfdefaultcase></cfdefaultcase>
		</cfswitch>
	</cfif>
	<cfreturn "">
</cffunction>