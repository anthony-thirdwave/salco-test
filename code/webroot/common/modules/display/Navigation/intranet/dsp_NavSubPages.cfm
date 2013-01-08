<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfquery name="GetThesePages" datasource="#APPLICATION.DSN#">
	SELECT		parentid, CategoryID,CategoryURL,CategoryAlias,CategoryName 
	FROM 		qry_GetCategoryMeta
	WHERE		ParentID=<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer"> 
		AND		CategoryTypeID IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">) 
		AND		ShowInNavigation = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		AND		CategoryActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		AND		ParentID <> <cfqueryparam value="1" cfsqltype="cf_sql_integer">
	ORDER BY CategoryLocalePriority
</cfquery>
<!--- <cfif GetThesePages.RecordCount GT "0">
	<cfset ThisParentID=GetThesePages.ParentID>
</cfif>
<cfif GetThesePages.RecordCount IS "0">
	<cfquery name="GetParent" datasource="#APPLICATION.DSN#">
		SELECT 		ParentID 
		FROM 		t_category
		WHERE 		CategoryID=<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer"> 
			AND 	CategoryTypeID  IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">) 
			AND		ShowInNavigation = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> 
			AND		CategoryActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		ORDER BY displayOrder
	</cfquery><cfdump var="#GetParent#">
	<cfset ThisParentID=GetParent.ParentID>
	<cfquery name="GetThesePages" datasource="#APPLICATION.DSN#">
		SELECT 		CategoryID,CategoryURL,CategoryAlias,CategoryName
		FROM 		qry_GetCategoryMeta
		WHERE 		ParentID=<cfqueryparam value="#Val(GetParent.ParentID)#" cfsqltype="cf_sql_integer">
			AND 	ParentID <> <cfqueryparam value="1" cfsqltype="cf_sql_integer">
			AND		CategoryTypeID  IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">)
			AND		ShowInNavigation = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> 
			AND		CategoryActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		ORDER BY CategoryLocalePriority
	</cfquery>
</cfif> --->


<cfif GetThesePages.RecordCount gt "0">
	<cfsavecontent variable="ThisNav">
		<cfoutput query="GetThesePages" group="CategoryID">
			<cfif ListFind(REQUEST.CategoryThreadList,CategoryID)>
				<cfset ThisClass="active">
			<cfelse>
				<cfset ThisClass="">
			</cfif>
			<cfif Trim(CategoryURL) IS "">
				<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#">
			<cfelse>
				<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryURL)#">
			</cfif>
			<li <cfif len(ThisClass)>class="active"</cfif>><a href="#ThisURL#">#CategoryName#</a></li>
		</cfoutput>
	</cfsaveContent>
	<cfif Trim(ThisNav) IS NOT "">
		<ul>
			<cfoutput>#ThisNav#</cfoutput>
		</ul>
	</cfif>
</cfif>