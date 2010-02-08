<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category where ParentID=897
</cfquery>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+UtilityNav_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">

<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetTopCategories">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="897" null="no">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
	</cfstoredproc>
	<!--- <cfdump var="#GetTopCategories#"> --->
	<cfsaveContent Variable="FileContents">
		<cfif GetTopCategories.RecordCount GT "0">
			<cfquery name="GetTopCategories2" dbtype="query">
				select * from GetTopCategories order by DisplayOrder Desc
			</cfquery>
			<cfoutput query="GetTopCategories2" group="CategoryID">
				<cfif Trim(CategoryURLDerived) IS "">
					<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#">
				<cfelse>
					<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryURLDerived)#">
				</cfif>
				<div class="utilitynavigationmenu"><a href="#ThisURL#">#CategoryNameDerived#</a></div>
			</cfoutput>
		</cfif>
	</cfsaveContent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">


