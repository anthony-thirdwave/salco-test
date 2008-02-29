<cfsetting showdebugoutput="no"><cfif NOT IsDefined("SESSION.adminuserpassword") OR (IsDefined("SESSION.adminuserpassword") AND SESSION.adminuserpassword EQ "")>session timeout<cfelse>
<cfsilent>
	<!--- BEGIN param ATTRIBUTES variables --->
	<cfparam name="ATTRIBUTES.thisCatIDInitList" default="">
	<cfparam name="ATTRIBUTES.isAutoCollapse" default="1">
	<cfparam name="ATTRIBUTES.MVEid" default="1">
	<cfparam name="ATTRIBUTES.JSFunctionName" default="">
	<cfparam name="ATTRIBUTES.isNewPage" default="0">
	<cfparam name="ATTRIBUTES.idPrefix" default="">
	<cfparam name="ATTRIBUTES.isTopLevel" default="0">
	<cfparam name="ATTRIBUTES.ParentChooserInitID" default="none">
	<!--- if variables in querystring(from ajax call), set ATTRIBUTES scope --->
	<cfif IsDefined("URL.thisCatID")>
		<cfset ATTRIBUTES.thisCatID = URL.thisCatID>
	</cfif>
	<cfif IsDefined("URL.isAutoCollapse")>
		<cfset ATTRIBUTES.isAutoCollapse = URL.isAutoCollapse>
	</cfif>
	<cfif IsDefined("URL.MVEid")>
		<cfset ATTRIBUTES.MVEid = URL.MVEid>
	</cfif>
	<cfif IsDefined("URL.JSFunctionName") AND URL.JSFunctionName NEQ "">
		<cfset ATTRIBUTES.JSFunctionName = URL.JSFunctionName>
	</cfif>
	<cfif IsDefined("URL.idPrefix")>
		<cfset ATTRIBUTES.idPrefix = URL.idPrefix>
	</cfif>
	<cfset thisIdPrefix = ATTRIBUTES.idPrefix>
	<cfif IsDefined("URL.isNewPage")>
		<cfset ATTRIBUTES.isNewPage = URL.isNewPage>
	</cfif>
	<!--- END param ATTRIBUTES variables --->
	
	<!--- include struct file, defines struct that holds image icon paths --->
	<cfinclude template="menuAjaxIconStructInc.cfm">
	
	<cfquery name="GetParentName" datasource="#APPLICATION.DSN#">
		SELECT CategoryName FROM t_Category WHERE CategoryID = #ATTRIBUTES.thisCatID#
	</cfquery>
	<cfset thisParentName = GetParentName.CategoryName>
	
	<cfquery name="GetCategories" datasource="#APPLICATION.DSN#">
		SELECT c.CategoryID, c.CategoryActive, c.CategoryName, c.CategoryAlias, c.CategoryTypeID, clm.CategoryLocalePriority, cl.CategoryLocaleActive
		FROM t_Category c
		INNER JOIN t_CategoryLocaleMeta clm ON (c.CategoryID = clm.CategoryID AND clm.LocaleID = #Val(SESSION.AdminCurrentAdminLocaleID)#)
		LEFT OUTER JOIN t_CategoryLocale cl ON (c.CategoryID = cl.CategoryID AND cl.LocaleID = #Val(SESSION.AdminCurrentAdminLocaleID)#)
		WHERE c.ParentID = #ATTRIBUTES.thisCatID#
		<cfif IsNumeric(ATTRIBUTES.ParentChooserInitID)>
		AND c.CategoryID <> #ATTRIBUTES.ParentChooserInitID#
		</cfif>
		ORDER BY clm.CategoryLocalePriority
	</cfquery>
	<cfset lCatIDs = ValueList(GetCategories.CategoryID)>
	<cfif ListLen(lCatIDs) EQ 0>
		<cfset lCatIDs = 0>
	</cfif>
	
	<!--- BEGIN set permission struct --->
	<cfquery name="GetAllCategories" datasource="#APPLICATION.DSN#">
		select CategoryID,pRead,UserGroupid from qry_GetCategoryPermission
		WHERE UserGroupID IN (<cfqueryparam value="#ListAppend(SESSION.AdminUserGroupIDList, APPLICATION.SuperAdminUserGroupID)#" cfsqltype="cf_sql_integer" list="yes">)
		AND CategoryID IN (<cfqueryparam value="#lCatIDs#" cfsqltype="cf_sql_integer" list="yes">)
		ORDER BY DisplayOrder
	</cfquery>
	
	<cfset sAllPermissions=StructNew()>
	<cfoutput query="GetAllCategories" group="CategoryID">
		<cfset StructInsert(sAllPermissions,CategoryID,0,1)>
		<cfoutput group="UserGroupID">
			<cfif pRead><cfset StructInsert(sAllPermissions,CategoryID,1,1)></cfif>
		</cfoutput>
	</cfoutput>
	<!--- END set permission struct --->
	
	<!--- BEGIN set querystring --->
	<cf_addToqueryString querystring="#REQUEST.CGIQueryString#" name="MVEid" value="#ATTRIBUTES.MVEid#" omitlist="MVEid,thisCatID,isAutoCollapse,MVSearchTerms,mvcid,hlid,ugid,cid,mvsla">
	<cfset ThisQueryString="#QueryString#">
	<!--- END set querystring --->
	
	<!--- set variable if this is the initial page load (not ajax call) --->
	<cfif ATTRIBUTES.thisCatIDInitList NEQ "">
		<cfset isInitial = 1>
	<cfelse>
		<cfset isInitial = 0>
	</cfif>
</cfsilent>
<cfoutput query="GetCategories">
	<cfsilent>
		<!--- BEGIN set active flag --->
		<cfif CategoryActive EQ 0>
			<cfset IsActive = 0>
		<cfelseif CategoryLocaleActive NEQ "">
			<cfset IsActive = CategoryLocaleActive>
		<cfelse>
			<cfset IsActive = CategoryActive>
		</cfif>
		<!--- END set active flag --->
		
		<!--- IF is initial page load, set flag if this category is in the path of the initial category --->
		<cfif isInitial AND ListFind(ATTRIBUTES.thisCatIDInitList,CategoryID)>
			<cfset isInitPath = 1>
		<cfelse>
			<cfset isInitPath = 0>
		</cfif>
		
		<!--- BEGIN set vars based on security and active status --->
		<cfif sAllPermissions[CategoryID]>
			<cfif ATTRIBUTES.JSFunctionName EQ "">
				<cfset thisHREF="index.cfm?#ThisQueryString#&mvcid=#CategoryID#">
			<cfelse>
				<cfset thisHREF="javascript:#ATTRIBUTES.JSFunctionName#(#CategoryID#,'#CategoryName#');">
			</cfif>
			<cfif IsActive>
				<cfset thisTitle = "Active">
				<cfset thisClass="">
			<cfelse>
				<cfset thisTitle = "Inactive">
				<cfset thisClass="inactive">
			</cfif>
		<cfelse>
			<cfset ThisHREF="javascript:void(0);">
			<cfset ThisTitle="You do not have permission to view this category.">
			<cfset thisClass="off">
		</cfif>
		<!--- END set vars based on security and active status --->
		
		<!--- check to see if this category has any child categories --->
		<cfquery name="checkChildren" datasource="#APPLICATION.DSN#">
			SELECT categoryID FROM t_Category WHERE ParentID = #CategoryID#
		</cfquery>
	</cfsilent>
	<div id="#thisIdPrefix#categoryLink_#CategoryID#">
		<!--- 'add page here' link --->
		<cfif ATTRIBUTES.isNewPage AND ATTRIBUTES.JSFunctionName NEQ "" AND ATTRIBUTES.isTopLevel EQ 0>
			<a href="javascript:#ATTRIBUTES.JSFunctionName#_sibling(#ATTRIBUTES.thisCatID#,#CategoryID#,'#thisParentName#');" title="insert page here"><img src="/common/images/admin/new_page_here.gif" vspace="2" border="0" alt="insert here"></a><br>
		</cfif>
		<!--- if child categories, icon will be link --->
		<cfif checkChildren.RecordCount GT 0>
			<!--- if initial page load and in initial path, initialize JS array values --->
			<cfif isInitPath>
				<script language="javascript" type="text/javascript">
					#thisIdPrefix#hrefCloseArray[#CategoryID#] = "javascript:#thisIdPrefix#closeThisDiv('#CategoryID#');";
					#thisIdPrefix#hrefOpenArray[#CategoryID#] = "javascript:#thisIdPrefix#openThisDiv('#CategoryID#');<cfif ATTRIBUTES.isAutoCollapse EQ 1>#thisIdPrefix#collapse('#lCatIDs#','#CategoryID#');</cfif>";
					#thisIdPrefix#typeIDArray[#CategoryID#] = #CategoryTypeID#;
				</script>
			</cfif>
			<!--- expand/collapse icon link --->
			<a id="#thisIdPrefix#catagoryAnchor_#CategoryID#" href="javascript:<cfif isInitPath>#thisIdPrefix#closeThisDiv('#CategoryID#');<cfelse>#thisIdPrefix#doChildCategories('#CategoryID#','#CategoryTypeID#');<cfif ATTRIBUTES.isAutoCollapse EQ 1>#thisIdPrefix#collapse('#lCatIDs#','#CategoryID#');</cfif></cfif>">
				<cfif isInitPath>
					<img id="#thisIdPrefix#catagoryBullet_#CategoryID#" src="<cfif StructKeyExists(sIconsExpanded,CategoryTypeID)>#StructFind(sIconsExpanded,CategoryTypeID)#<cfelse>#StructFind(sIconsExpanded,"default")#</cfif>" border="0">
				<cfelse>
					<img id="#thisIdPrefix#catagoryBullet_#CategoryID#" src="<cfif StructKeyExists(sIconsCollapsed,CategoryTypeID)>#StructFind(sIconsCollapsed,CategoryTypeID)#<cfelse>#StructFind(sIconsCollapsed,"default")#</cfif>" border="0">
				</cfif>
			</a>
		<cfelse>
			<!--- NON-expand/collapse icon link (no children) --->
			<img src="<cfif StructKeyExists(sIconsNoChild,CategoryTypeID)>#StructFind(sIconsNoChild,CategoryTypeID)#<cfelse>#StructFind(sIconsNoChild,"default")#</cfif>" border="0">
		</cfif>
		<!--- link to category MV --->
		<a href="#thisHREF#" title="#thisTitle#"><span<cfif thisClass NEQ ""> class="#thisClass#"</cfif><cfif isInitPath> style="font-weight:bold;"</cfif>>#CategoryName#</span></a>
		<!--- if has child categories, add child category container --->
		<cfif checkChildren.RecordCount GT 0>
		<div id="#thisIdPrefix#categoryChildContainer_#CategoryID#" class="childContent" style="display:<cfif isInitPath AND ListLen(ATTRIBUTES.thisCatIDInitList) GT 0>block<cfelse>none</cfif>; ">
			<!--- if in initial path and not last page, get child categories --->
			<cfif isInitPath AND ListLen(ATTRIBUTES.thisCatIDInitList) GT 0>
				<cfmodule template="menuAjaxGetChildCategories.cfm" ParentChooserInitID="#ATTRIBUTES.ParentChooserInitID#" thisCatID="#ListFirst(ATTRIBUTES.thisCatIDInitList)#" thisCatIDInitList="#ListRest(ATTRIBUTES.thisCatIDInitList)#" isAutoCollapse="#ATTRIBUTES.isAutoCollapse#" JSFunctionName="#ATTRIBUTES.JSFunctionName#" idPrefix="#thisIdPrefix#">
			</cfif>
		</div>
		</cfif>
	</div>
</cfoutput>
<cfoutput>
<cfif ATTRIBUTES.isNewPage AND ATTRIBUTES.JSFunctionName NEQ "" AND ATTRIBUTES.isTopLevel EQ 0>
<div><a href="javascript:#ATTRIBUTES.JSFunctionName#(#ATTRIBUTES.thisCatID#,'#thisParentName#');" title="insert page here"><img src="/common/images/admin/new_page_here.gif" vspace="2" border="0" alt="insert here"></a></div>
</cfif>
</cfoutput>
</cfif>