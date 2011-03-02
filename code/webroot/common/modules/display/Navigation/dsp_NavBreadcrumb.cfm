<cfif ListLen(CategoryThreadList) GTE "4">
	<cfset ThisList=ListRest(CategoryThreadList)>
	
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetBreadCrumbPrime">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="#ThisList#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
	</cfstoredproc>

	<cfif GetBreadCrumbPrime.RecordCount GT "0">
		<cfquery name="GetBreadCrumb" dbtype="query">
			select * from GetBreadCrumbPrime order by DisplayOrder
		</cfquery>
		<div class="breadCrumbs">
		<cfoutput query="GetBreadCrumb" group="CategoryID">
			<cfif Trim(GetBreadCrumb.CategoryURL) IS "">
				<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetBreadCrumb.CategoryAlias)#">
			<cfelse>
				<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetBreadCrumb.CategoryURL)#">
			</cfif>
			<a href="#ThisURL#">#GetBreadCrumb.CategoryNameDerived#</a> <cfif CurrentRow IS NOT GetBreadCrumb.RecordCount>&gt;</cfif>
		</cfoutput>
		</div>
	</cfif>
</cfif>