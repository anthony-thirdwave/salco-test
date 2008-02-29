<cfparam name="ATTRIBUTES.ThisCategoryID" default="857">

<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
	<cfprocresult name="getdetail" maxrows="1">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ThisCategoryID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
</cfstoredproc>

<cfif getdetail.CategoryActiveDerived IS "1" >
	<cfoutput>
		<cfif Trim(getdetail.CategoryURLDerived) iS NOT "">
			<LI><a href="#GetDetail.CategoryURL#">#getdetail.CategoryNameDerived#</a></LI>
		<cfelse>
			<LI><a href="/content.cfm/#GetDetail.CategoryAlias#">#getdetail.CategoryNameDerived#</a></LI>
		</cfif>
	</cfoutput>
</cfif>

<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetcategoryList">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ATTRIBUTES.ThisCategoryID#" null="NO">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="no">
</cfstoredproc>

<cfif GetcategoryList.recordcount GT "0">
	<cfloop query="GetcategoryList">
		<UL><cfmodule template="/common/modules/sitemap/SiteMapHelper.cfm" ThisCategoryID="#CategoryID#"></UL>
	</cfloop>
</cfif>
