<cfparam name="URLPrefix" default="">

<cfquery name="GetAllCategories" datasource="#APPLICATION.DSN#">
	select CategoryID,pRead,UserGroupid from qry_GetCategoryPermission
	WHERE UserGroupID IN (<cfqueryparam value="#ListAppend(SESSION.AdminUserGroupIDList, APPLICATION.SuperAdminUserGroupID)#" cfsqltype="cf_sql_integer" list="yes">)
	ORDER BY DisplayOrder
</cfquery>

<cfset sAllPermissions=StructNew()>
<cfoutput query="GetAllCategories" group="CategoryID">
	<cfset StructInsert(sAllPermissions,CategoryID,0,1)>
	<cfoutput group="UserGroupID">
		<cfif pRead><cfset StructInsert(sAllPermissions,CategoryID,1,1)></cfif>
	</cfoutput>
</cfoutput>

<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetTopCategories">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#SESSION.AdminCurrentAdminLocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
</cfstoredproc>


<table width="250"><TR><TD>
<script language="Javascript" type="text/javascript" src="/common/modules/admin/MasterView/scripts/ecms_system.js"></script>
<script language="Javascript" type="text/javascript">
ECMS_image_bullet.src = '/common/images/admin/icon_doc.gif';
ECMS_image_collapsed.src = '/common/images/admin/icon_plus.gif';
ECMS_image_expanded.src = '/common/images/admin/icon_minus.gif';
ECMS_image_bullet.alt = '';
ECMS_image_collapsed.alt = 'menu (show)';
ECMS_image_expanded.alt = 'menu (hide)';
ECMS_menu_indent = 15;
ECMS_status_display = false;
ECMS_repeat_links = true;
ECMS_collapse_on_expand = false;
ECMS_auto_expand = false;
ECMS_auto_expand_delay = 750;
<cf_addToqueryString querystring="#MVQueryString#" name="MVEid" value="#MVEid#" omitlist="MVSearchTerms,mvcid,hlid,ugid,cid,mvsla">
<cfset ThisQueryString="#QueryString#">
<cfoutput query="GetTopCategories" group="CategoryID">
<cfsilent>
	<cfset ThisPRead=sAllPermissions[CategoryID]>
	<cfset ThisOLLevel=(Len(DisplayOrder)/3)-1>
	<cfif ThisPRead>
		<cfset ThisHREF="index.cfm?#ThisQueryString#&mvcid=#URLEncodedFormat(CategoryID)#">
		<cfif Val(categoryActiveDerived)>
			<cfset ThisName="#CategoryName#">
			<cfif CategoryURL IS NOT "">
				<cfif left(CategoryURL,4) IS "java">
					<cfset ThisTitle="Active, link is javascript">
				<cfelse>
					<cfset ThisTitle="Active, redirects to #CategoryURL#">
				</cfif>
			<cfelse>
				<cfset ThisTitle="Active">
			</cfif>
			<cfset ThisClass="">
		<cfelse>
			<cfset ThisName="#CategoryName#">
			<cfset ThisTitle="Inactive">
			<cfset ThisClass="inactive">
		</cfif>
	<cfelse>
		<cfset ThisHREF="javascript:void(0);">
		<cfset ThisName="#CategoryName#">
		<cfset ThisTitle="You do not have permission to view this category.">
		<cfset ThisClass="off">
	</cfif>
	
</cfsilent>
<cfif ListFind(CategoryIDThreadList,CategoryID)>
ECMS_add_item(#ThisOLLevel#,'<b>#JSStringFormat(ThisName)#</b>','#ThisHref#','',1,'#ThisTitle#','#ThisClass#');
<cfelse>ECMS_add_item(#ThisOLLevel#,'#JSStringFormat(ThisName)#','#ThisHref#','',0,'#ThisTitle#','#ThisClass#');
</cfif></cfoutput>
ECMS_end_menu();
</script>
</TD></TR>
</table>