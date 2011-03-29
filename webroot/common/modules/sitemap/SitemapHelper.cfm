<cfparam name="ATTRIBUTES.ThisCategoryID" default="1">

<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
	<cfprocresult name="getdetail" maxrows="1">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#val(ATTRIBUTES.ThisCategoryID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
</cfstoredproc>

<cfif getdetail.RecordCount IS "1">
	<cfoutput>
		<cfif Trim(getdetail.CategoryURLDerived) iS NOT "">
			<li><a href="#APPLICATION.utilsObj.parseCategoryUrl(GetDetail.CategoryURL)#">#getdetail.CategoryNameDerived#</a><
		<cfelse>
			<li><a href="#APPLICATION.utilsObj.parseCategoryUrl(GetDetail.CategoryAlias)#">#getdetail.CategoryNameDerived#</a>
		</cfif>
	</cfoutput>
	
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetcategoryList">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(ATTRIBUTES.ThisCategoryID)#" null="NO">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
	</cfstoredproc>
	
	<cfif GetcategoryList.recordcount GT "0">
		<cfloop query="GetcategoryList">
			<cfif ShowInNavigation OR GetcategoryList.CategoryID IS "7">
				<ul><cfmodule template="/common/modules/sitemap/SiteMapHelper.cfm" ThisCategoryID="#val(CategoryID)#"></ul>
			</cfif>
		</cfloop>
	</cfif>
	</li>
</cfif>
