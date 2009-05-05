<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.ParentCategoryID" default="-1">
<cfparam name="ATTRIBUTES.CategoryThreadList" default="-1">

<cfif ATTRIBUTES.CategoryThreadList IS "-1">
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#ATTRIBUTES.CategoryID#"
		namelist=""
		idlist="#ATTRIBUTES.CategoryID#"
		aliaslist="">
	<cfset ATTRIBUTES.CategoryThreadList=idlist>
</cfif>

<cfset ATTRIBUTES.ParentCategoryID=ListGetAt(ATTRIBUTES.CategoryThreadList,ListFind(ATTRIBUTES.CategoryThreadList,ATTRIBUTES.CategoryID)-1)>

<cfquery name="GetParentType" datasource="#APPLICATION.DSN#">
	select CategoryTypeID from t_category 
	Where CategoryID=<cfqueryparam value="#ATTRIBUTES.ParentCategoryID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset lCategoryTypeIDToDisplay="#APPLICATION.lVisibleCategoryTypeID#">

<cfquery name="GetChildren" datasource="#APPLICATION.DSN#">
	select parentid, CategoryID,CategoryURL,CategoryAlias,CategoryName,DisplayLevel,CategoryLocaleName,CategoryTypeName from qry_GetCategoryLocaleMeta
	Where ParentID=<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer"> and 
		CategoryTypeID IN (<cfqueryparam value="#lCategoryTypeIDToDisplay#" cfsqltype="cf_sql_integer" list="yes">) AND
		ShowInNavigation=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> AND
		CategoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> and 
		ParentID <> <cfqueryparam value="857" cfsqltype="cf_sql_integer">
	order by CategoryLocalePriority
</cfquery>

<cfif GetChildren.RecordCount IS "0">
	<cfset ThisSourceCategoryID=ATTRIBUTES.ParentCategoryID>
	<cfquery name="GetChildren" datasource="#APPLICATION.DSN#">
		select parentid, CategoryID,CategoryURL,CategoryAlias,CategoryName,DisplayLevel,CategoryLocaleName,CategoryTypeName from qry_GetCategoryLocaleMeta
		Where ParentID=<cfqueryparam value="#Val(ThisSourceCategoryID)#" cfsqltype="cf_sql_integer"> and 
			CategoryTypeID IN (<cfqueryparam value="#lCategoryTypeIDToDisplay#" cfsqltype="cf_sql_integer" list="yes">) AND
			ShowInNavigation=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> AND
			CategoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> and 
			ParentID <> <cfqueryparam value="857" cfsqltype="cf_sql_integer">
		order by CategoryLocalePriority
	</cfquery>
<cfelse>
	<cfset ThisSourceCategoryID=ATTRIBUTES.CategoryID>
</cfif>

<cfquery name="GetParent" datasource="#APPLICATION.DSN#">
	select ParentID,DisplayLevel from t_category
	Where CategoryID=<cfqueryparam value="#Val(ThisSourceCategoryID)#" cfsqltype="cf_sql_integer"> and 
		CategoryTypeID IN (<cfqueryparam value="#lCategoryTypeIDToDisplay#" cfsqltype="cf_sql_integer" list="yes">) AND
		ShowInNavigation=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> AND
		CategoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
	order by displayOrder
</cfquery>
<cfquery name="GetThesePages" datasource="#APPLICATION.DSN#">
	select CategoryID,CategoryURL,CategoryAlias,CategoryName,CategoryLocaleName,CategoryTypeName from qry_GetCategoryLocaleMeta
	Where 
		ParentID=<cfqueryparam value="#Val(GetParent.ParentID)#" cfsqltype="cf_sql_integer"> and 
		ParentID <> <cfqueryparam value="857" cfsqltype="cf_sql_integer"> and
		CategoryTypeID IN (<cfqueryparam value="#lCategoryTypeIDToDisplay#" cfsqltype="cf_sql_integer" list="yes">) AND
		ShowInNavigation=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> AND
		CategoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
	order by CategoryLocalePriority
</cfquery>

<cfif GetThesePages.RecordCount IS "0">
	<cfif ListFind(ATTRIBUTES.CategoryThreadList,ATTRIBUTES.CategoryID) IS "3">
		<cfset GetThesePages=GetChildren>
	<cfelse>
		<cfset GetThesePages=GetChildren>
		<cfquery name="GetChildren" datasource="#APPLICATION.DSN#">
			select parentid, CategoryID,CategoryURL,CategoryAlias,CategoryName,DisplayLevel,CategoryLocaleName,CategoryTypeName from qry_GetCategoryLocaleMeta
			Where 1=0
			order by CategoryLocalePriority
		</cfquery>
	</cfif>
</cfif>

<cfif GetThesePages.RecordCount gt "0">
	<cfset ThisListToTest=ListAppend(ValueList(GetThesePages.CategoryID),ATTRIBUTES.CategoryThreadList)>
	
	<cfsavecontent variable="ThisNav">
		<cfoutput query="GetThesePages" group="CategoryID">
			<cfif Trim(CategoryURL) IS "">
				<cfset ThisURL="#REQUEST.GlobalNavURLPrefix#/content.cfm/#CategoryAlias#">
			<cfelse>
				<cfset ThisURL="#CategoryURL#">
			</cfif>
			<cfif Trim(CategoryLocaleName) IS NOT "">
				<cfset ThisName="#CategoryLocaleName#">
			<cfelse>
				<cfset ThisName="#CategoryName#">
			</cfif>
			<cfif ListFind("#ATTRIBUTES.CategoryThreadList#",categoryID)>
				<li class="#REQUEST.Scrub(CategoryTypeName)# Active"><a href="#ThisURL#" title="#CategoryName#"><strong>#ThisName#</strong></a>
				<cfif GetChildren.RecordCount GT "0">
					<ul>
					<cfloop query="GetChildren">
						<cfif Trim(GetChildren.CategoryURL) IS "">
							<cfset ThisURL2="#REQUEST.GlobalNavURLPrefix#/content.cfm/#GetChildren.CategoryAlias#">
						<cfelse>
							<cfset ThisURL2="#GetChildren.CategoryURL#">
						</cfif>
						<cfif Trim(GetChildren.CategoryLocaleName) IS NOT "">
							<cfset ThisChildName="#GetChildren.CategoryLocaleName#">
						<cfelse>
							<cfset ThisChildName="#GetChildren.CategoryName#">
						</cfif>
						<cfif ListFind("#ATTRIBUTES.CategoryThreadList#",GetChildren.categoryID)>
							<li class="#REQUEST.Scrub(GetChildren.CategoryTypeName)# Active"><a href="#ThisURL2#" title="#GetChildren.CategoryName#">#ThisChildName#</a></li>
						<cfelse>
							<li class="#REQUEST.Scrub(GetChildren.CategoryTypeName)#"><a href="#ThisURL2#" title="#GetChildren.CategoryName#">#ThisChildName#</a></li>
						</cfif>
					</cfloop>
					</ul>
				</cfif>
				</li>
			<cfelse>
				<li class="#REQUEST.Scrub(CategoryTypeName)#"><a href="#ThisURL#" title="#CategoryName#">#ThisName#</a></li>
			</cfif>
		</cfoutput>
	</cfsaveContent>
	<cfif Trim(ThisNav) IS NOT "">
		<ul class="subNav">
			<cfoutput>#ThisNav#</cfoutput>
		</ul>
	</cfif>
</cfif>