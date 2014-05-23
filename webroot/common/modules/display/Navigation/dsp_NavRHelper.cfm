<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.Level" default="1">
<cfparam name="ATTRIBUTES.MaxLevel" default="-1">
<cfparam name="REQUEST.CategoryThreadList" default="-1">

<cfstoredproc procedure="usp_GetPage" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetCategoryDetail" maxrows="1">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#val(ATTRIBUTES.CategoryID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
</cfstoredproc>

<cfstoredproc procedure="usp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetCategoryList">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(APPLICATION.LocaleID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(ATTRIBUTES.CategoryID)#" null="NO">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
</cfstoredproc>

<cfif ATTRIBUTES.Level IS NOT "0" and GetCategoryDetail.ShowInNavigation IS "1">
	<cfoutput query="GetCategoryDetail">
		<cfset ThisUrl="">
		<cfset ThisClass="">
		<cfif len(trim(GetCategoryDetail.CategoryURLDerived))>
			<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetCategoryDetail.CategoryURLDerived)#" />
		<cfelse>
			<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(GetCategoryDetail.CategoryAlias)#" />
		</cfif>
		<cfif ATTRIBUTES.Level IS "1">
			<cfset ThisClass="sideNavLink">
		</cfif>
		<cfif ListFind(REQUEST.CategoryThreadList,GetCategoryDetail.CategoryID)>
			<cfset ThisClass="#ThisClass# navActive">
		</cfif>
		<li><a href="#ThisURL#" <cfif Trim(ThisClass) IS NOT "">class="#Trim(ThisClass)#"</cfif>><span>#GetCategoryDetail.CategoryNameDerived#</span></a>
	</cfoutput>
</cfif>

<cfset Continue="1">
<cfif Val(ATTRIBUTES.MaxLevel) GT "0" and ATTRIBUTES.Level+1 GT Val(ATTRIBUTES.MaxLevel)>
	<cfset Continue="0">
</cfif>
<cfif GetCategoryList.recordcount is "0">
	<cfset Continue="0">
</cfif>
<cfif Continue>
	<cfoutput><ul class="level-#ATTRIBUTES.Level+1#"></cfoutput>
	<cfoutput query="GetCategoryList">
		<cfmodule template="/common/modules/display/navigation/dsp_NavRHelper.cfm" 
			CategoryID="#val(GetCategoryList.CategoryID)#" 
			counter="#GetCategoryList.CurrentRow#"
			Level="#ATTRIBUTES.Level+1#"
			MaxLevel="#ATTRIBUTES.MaxLevel#">
	</cfoutput>
	</ul>
</cfif>
<cfif ATTRIBUTES.Level IS NOT "0"></li></cfif>

