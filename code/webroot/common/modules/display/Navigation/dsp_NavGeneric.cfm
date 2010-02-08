<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category
</cfquery>

<cfset lInActiveCategory="">
<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetAllCategories">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="YES">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
</cfstoredproc>

<table><TR><TD nowrap>
<script language="Javascript" type="text/javascript" src="/common/scripts/outline/ecms_system.js"></script>
<script language="Javascript" type="text/javascript">

	ECMS_image_bullet.src = '/common/images/ECMS_bullet.gif';
	ECMS_image_collapsed.src = '/common/images/ECMS_collapsed.gif';
	ECMS_image_expanded.src = '/common/images/ECMS_expanded.gif';
	
	ECMS_image_bullet.alt = '';
	ECMS_image_collapsed.alt = 'menu (show)';
	ECMS_image_expanded.alt = 'menu (hide)';
	
	ECMS_menu_indent = 15;
	
	ECMS_status_display = false;
	ECMS_repeat_links = true;
	
	ECMS_collapse_on_expand = true;
	ECMS_auto_expand = false;
	ECMS_auto_expand_delay = 750;
		
		
	<cfoutput query="GetAllCategories" group="CategoryID">
		<cfif NOT Val(CategoryActiveDerived)>
			<cfset lInActiveCategory=ListAppend(lInActiveCategory,CategoryID)>
		<cfelseif ListFindNoCase(lInActiveCategory,ParentID) GT "0">
			<cfset lInActiveCategory=ListAppend(lInActiveCategory,CategoryID)>
		<cfelse>
			<cfsilent>
				<cfif Trim(CategoryURLDerived) IS NOT "">
					<cfset ThisHREF = APPLICATION.utilsObj.parseCategoryUrl(Replace(CategoryURLDerived,"'","\'","All")) />
					<!--- <cfset ThisHREF="javascript:clickit(\'sdsd\');"> --->
				<cfelse>
					<cfset ThisHref = APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias) />
				</cfif>
				<cfset ThisOLLevel=(Len(DisplayOrder)/3)-2>
			</cfsilent>
			<cfif ListFind(CategoryThreadList,CategoryID)>
				ECMS_add_item(#ThisOLLevel#, '<b>#JSStringFormat(lcase(CategoryNameDerived))#</b>','#ThisHref#','',true);
			<cfelse>
				ECMS_add_item(#ThisOLLevel#, '#JSStringFormat(lcase(CategoryNameDerived))#','#ThisHref#');
			</cfif>
		</cfif>
	</cfoutput>
	ECMS_end_menu();
</script>
</TD></TR>
</table>



