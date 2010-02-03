<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.Level" default="1">

<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetCategoryDetail" maxrows="1">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.CategoryID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
</cfstoredproc>

<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetCategoryList">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ATTRIBUTES.CategoryID#" null="NO">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
</cfstoredproc>

<cfif ATTRIBUTES.Level IS NOT "0">
	<cfoutput query="GetCategoryDetail">
		<cfif Trim(GetCategoryDetail.CategoryURLDerived) iS NOT "">
			<cfset ThisURL="#GetCategoryDetail.CategoryURLDerived#">
		<cfelse>
			<cfset ThisURL="/content.cfm/#GetCategoryDetail.CategoryAlias#">
		</cfif>
		<li><a href="#ThisURL#">#GetCategoryDetail.CategoryNameDerived#</a>
	</cfoutput>
</cfif>
<cfif GetCategoryList.recordcount GT "0">
	<ul>
	<cfoutput query="GetCategoryList">
		<cfmodule template="/common/modules/display/navigation/dsp_NavRHelper.cfm" 
			CategoryID="#GetCategoryList.CategoryID#" 
			counter="#GetCategoryList.CurrentRow#"
			Level="#ATTRIBUTES.Level+1#">
	</cfoutput>
	</ul>
</cfif>
<cfif ATTRIBUTES.Level IS NOT "0"></li></cfif>

