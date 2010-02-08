<div id="breadcrumb">
<cfif ListLen(CategoryThreadList) GTE "3">
	<cfquery name="GetBC" datasource="#APPLICATION.DSN#">
		SELECT		CategoryID,CategoryURL,CategoryAlias,CategoryName 
		FROM		qry_GetCategoryFrontEndPermissionExtended
		WHERE 		CategoryID IN (<cfqueryparam value="#ListRest(ListRest(CategoryThreadList))#" cfsqltype="cf_sql_integer" list="yes" />)
		AND			CategoryTypeID IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes" />) 
		AND			ShowInNavigation = 1
		AND			CategoryActive = 1
		AND			UserGroupID IN (<cfqueryparam value="#SESSION.UserRolesIDList#" cfsqltype="cf_sql_integer">)
		AND			pview = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
		ORDER BY	displayOrder
	</cfquery>
	<cfif GetBC.RecordCount GT "0">
		<cfoutput query="GetBC" group="CategoryID">
			<cfif Trim(CategoryURL) IS "">
				<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#">
			<cfelse>
				<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryURL)#">
			</cfif>
			<cfif CurrentRow IS NOT GetBC.RecordCount><a href="#ThisURL#"></cfif>#CategoryName#</A> <cfif CurrentRow IS NOT GetBC.RecordCount>&gt;</cfif>
		</cfoutput>
	</cfif>
<cfelse>&nbsp;
</cfif>
</div>
