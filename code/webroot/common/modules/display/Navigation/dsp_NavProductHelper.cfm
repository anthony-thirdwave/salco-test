<cfparam name="URL.CategoryID" default="-1000">
<cfparam name="URL.CategoryThreadList" default="-1000">

<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetCategoryListPrime">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(URL.CategoryID)#" null="NO">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="62" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
</cfstoredproc>

<cfquery name="GetCategoryList" dbtype="query">
	select CategoryID,CategoryURLDerived,CategoryAlias,CategoryNameDerived from GetCategoryListPrime
	order by CategoryName
</cfquery>
<cfif GetCategoryList.RecordCount GT "0">
	<cfquery name="GetChildrenPrime" datasource="#APPLICATION.DSN#">
		select 	Count(CategoryID) as Count, ParentID from t_Category
		Where	ParentID IN (<cfqueryparam value="#ValueList(GetCategoryList.CategoryID)#" cfsqltype="cf_sql_integer" list="yes">)
		and		CategoryTypeID=<cfqueryparam value="62" cfsqltype="cf_sql_integer">
		Group By ParentID
		Order By ParentID
	</cfquery>
	<ul>
	<cfoutput query="GetCategoryList">
		<cfquery name="LOCAL.GetChildren" dbtype="query">
			select [Count],ParentID from GetChildrenPrime
			where ParentID=<cfqueryparam value="#GetCategoryList.CategoryID#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset ThisUrl="">
		<cfif len(trim(GetCategoryList.CategoryURLDerived))>
			<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetCategoryList.CategoryURLDerived)#">
		<cfelse>
			<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetCategoryList.CategoryAlias)#">
		</cfif>
		<li><a href="#ThisURL#" data-CategoryID="#GetCategoryList.CategoryID#" <cfif ListFind(URL.CategoryThreadList,GetCategoryList.CategoryID)>class="active"</cfif> data-CategoryThreadList="#URL.CategoryThreadList#" <cfif LOCAL.GetChildren.RecordCount GT "0">data-HasChildren="true"<cfelse>data-HasChildren="false"</cfif>>#GetCategoryList.CategoryNameDerived#</a></li>
	</cfoutput>
	</ul>
</cfif>

