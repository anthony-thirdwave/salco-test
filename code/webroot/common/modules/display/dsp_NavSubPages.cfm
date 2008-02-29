<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ThisParentID" default="-1">
<cfquery name="GetThesePages" datasource="#APPLICATION.DSN#">
	select parentid, CategoryID,CategoryURL,CategoryAlias,CategoryName from qry_GetCategoryMeta
	Where ParentID=<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer"> and 
		CAtegoryTypeID  IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">) AND
		ShowInNavigation = 1 AND
		CategoryActive =1 and ParentID <> 1
	order by CategoryLocalePriority
</cfquery>
<cfif GetThesePages.RecordCount GT "0">
	<cfset ThisParentID=GetThesePages.ParentID>
</cfif>
<cfif GetThesePages.RecordCount IS "0">
	<cfquery name="GetParent" datasource="#APPLICATION.DSN#">
		select ParentID from t_category
		Where CategoryID=<cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer"> and 
			CAtegoryTypeID  IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">) AND
			ShowInNavigation = 1 AND
			CategoryActive = 1
		order by displayOrder
	</cfquery>
	<cfset ThisParentID=GetParent.ParentID>
	<cfquery name="GetThesePages" datasource="#APPLICATION.DSN#">
		select CategoryID,CategoryURL,CategoryAlias,CategoryName from qry_GetCategoryMeta
		Where ParentID=<cfqueryparam value="#Val(GetParent.ParentID)#" cfsqltype="cf_sql_integer"> and ParentID <> 1 and
			CAtegoryTypeID  IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">) AND
			ShowInNavigation = 1 AND
			CategoryActive =1
		order by CategoryLocalePriority
	</cfquery>
</cfif>

<!---
<cfif GetThesePages.RecordCount gt "0">
	<cfset ThisListToTest=ListAppend(ValueList(GetThesePages.CategoryID),REQUEST.CategoryThreadList)>
	<cfquery Name="GetSecurity" datasource="#APPLICATION.DSN#">
		select CategoryID,SecurityID,ParentID from qry_GetCategorySecurity 
		where CategoryID IN (<cfqueryparam value="#ThisListToTest#" cfsqltype="cf_sql_integer" list="yes">)
		order by displayLevel, DisplayOrder
	</cfquery>
	<cfmodule template="/common/modules/security/GetCurrentUser.cfm">
	<Cfset lMemberActivityList="">
	<cfloop index="i" from="1" to="#ArrayLen(aMemberActivity)#" step="1">
		<cfset lMemberActivityList=ListAppend(lMemberActivityList,"#aMemberActivity[i].ProductCode#")>
	</cfloop>
	SECURITY <cfset sSecurity=StructNew()>
	<cfoutput query="GetSecurity">
		<cfif Val(SecurityID) GT "0">
			<cfset StructInsert(sSecurity,CategoryID,SecurityID,1)>
		<cfelseif ListFindNoCase(StructKeyList(sSecurity),ParentID)>
			<cfset StructInsert(sSecurity,CategoryID,sSecurity[ParentID],1)>
		</cfif>
	</cfoutput>
	
	<cfsavecontent variable="ThisNav">
		<cfoutput query="GetThesePages" group="CategoryID">
			<cfif StructKeyExists(sSecurity,CategoryID) and  sSecurity[CategoryID] GT "0" and REQUEST.SecurityDenyAccess>
			<cfelse>
				<cfif Trim(CategoryURL) IS "">
					<cfset ThisURL="#REQUEST.GlobalNavURLPrefix#/content.cfm/#CategoryAlias#">
				<cfelse>
					<cfset ThisURL="#CategoryURL#">
				</cfif>
				<li><a href="#ThisURL#"><cfif ListFind("#ThisParentID#,#ATTRIBUTES.CategoryID#",categoryID)><strong>#CategoryName#</strong><cfelse>#CategoryName#</cfif></a></li>
			</cfif>
		</cfoutput>
	</cfsaveContent>
	<cfif Trim(ThisNav) IS NOT "">
		<ul class="list">
			<cfoutput>#ThisNav#</cfoutput>
		</ul>
	</cfif>
</cfif>--->