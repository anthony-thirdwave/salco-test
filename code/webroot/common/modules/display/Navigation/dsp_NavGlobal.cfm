<cfset ThisCategoryID=1>
<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category where ParentID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+GlobalNav_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">

<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetTopCategories">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ThisCategoryID#" null="NO">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
	</cfstoredproc>
	<cfsaveContent Variable="FileContents">
		<cfif GetTopCategories.RecordCount GT "0">
			<div id="mainNavigation"><!-- Start of Main Navigation Elements -->
				<ul id="nav-main" class="menuCSS menu-#CategoryAlias#">
                   <cfoutput query="GetTopCategories" group="CategoryID">
                       <cfif Trim(CategoryURLDerived) IS "">
                           <cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#">
                       <cfelse>
                           <cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryURLDerived)#">
                       </cfif>
                       <li><a href="#ThisURL#">#CategoryNameDerived#</a></li>
                   </cfoutput>
				</ul>
			</div><!-- End of Main Navigation Elements -->
		</cfif>
	</cfsaveContent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">

