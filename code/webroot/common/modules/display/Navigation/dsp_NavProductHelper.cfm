<cfsetting showdebugoutput="No">
<cfparam name="URL.CategoryID" default="-1000">
<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetCategoryList">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(URL.CategoryID)#" null="NO">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
</cfstoredproc>
<cfif GetCategoryList.RecordCount GT "0">
	<ul>
	<cfoutput query="GetCategoryList">
		<cfset ThisUrl="" />
		<cfif len(trim(GetCategoryList.CategoryURLDerived))>
			<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetCategoryList.CategoryURLDerived)#" />
		<cfelse>
			<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetCategoryList.CategoryAlias)#" />
		</cfif>
		<li><a href="#ThisURL#" data-CategoryID="#GetCategoryList.CategoryID#" <cfif GetCategoryList.CategoryTypeID IS "62">data-HasChildren="true"<cfelse>data-HasChildren="false"</cfif>>#GetCategoryList.CategoryNameDerived#</a></li>
	</cfoutput>
	</ul>
</cfif>

