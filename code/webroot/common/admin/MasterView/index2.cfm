<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Content Manager"
	PageHeader="<a href=""/common/admin/"" class=""white"">Main Menu</A> | Content Manager">
<cfinclude template="//common/admin/MasterView/_InitMasterView.cfm">



<cfquery name="GetCategoryDetails" datasource="#Application.DSN#">
	SELECT CategoryName,qry_GetCategoryWithCategoryLocale.CategoryID,CategoryAlias, CategoryTypeName,
	CategoryActive, ParentID, CategoryTypeID,
	t_permissions.*, CategoryURL, CategoryPropertiesID, CategoryPropertiesPacket, CategoryLocaleName, categoryLocaleActive, CategoryLocaleID, LocaleID, TemplateID
	FROM
	qry_GetCategoryWithCategoryLocale
	INNER JOIN t_Permissions ON qry_GetCategoryWithCategoryLocale.CategoryID = t_Permissions.CategoryID
	WHERE qry_GetCategoryWithCategoryLocale.CategoryID=#Val(MVCid)# AND UserGroupID IN (#ListAppend(SESSION.AdminUserGroupIDList, APPLICATION.SuperAdminUserGroupID)#)
</cfquery>

<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" ThisCategoryID="#MVCid#" NameList="" IDList="#MVCid#">

<cfset sPermissions=StructNew()>
<cfset lPermissionActions="pRead,pCreate,pEdit,pDelete,pSaveLive,pManage">
<cfloop index="ThisAction" list="#lPermissionActions#">
	<cfset StructInsert(sPermissions,"#ThisAction#","0","1")>
</cfloop>
<cfoutput query="GetCategoryDetails">
	<cfloop index="ThisAction" list="#lPermissionActions#">
		<cfif evaluate("#ThisAction#")>
			<cfset StructInsert(sPermissions,"#ThisAction#","#evaluate('#ThisAction#')#","1")>
		</cfif>
	</cfloop>
</cfoutput>

<cfset lid=Encrypt(SESSION.AdminCurrentAdminLocaleID,APPLICATION.Key)>
<table width="780" cellpadding="2" cellspacing="0" border="0">
 <tr valign="top"><cfoutput><form action="#MVSearch#?#MVQueryString#" method="get">
    <TD nowrap bgcolor="white" style="border-top:2px solid silver; border-left:2px solid silver; border-right:2px solid silver;">
		<input type="text" name="MVSearchTerms" value="#MVSearchTerms#">
        <input type="submit" value="Search">
   </TD></form></cfoutput>
    <TD bgcolor="white" style="border-bottom:2px solid silver;">&nbsp;
    </TD>
  </TR>
<tr valign="top">
<TD width="250" bgcolor="white" style="border-left:2px solid silver; border-bottom:2px solid silver;">

<cfinclude template="/common/modules/admin/masterview/dsp_Nav.cfm">
<cfif ListFind(UserGroupIDList,"#APPLICATION.AdminUserGroupID#") OR ListFind(UserGroupIDList,"#APPLICATION.ContentEditorUserGroupID#")>
	<p><a href="/common/admin/MasterView/CategoryModify.cfm?PageAction=Add"><b>Add New Page</b></A></P>
</cfif>


</TD><TD style="border-bottom:2px solid silver; border-right:2px solid silver;">

<table width="100%" border="0" cellpadding="3" bgcolor="white">
<TR><TD bgcolor="bac0c9" colspan="4"><b>Master Details</b></TD></TR>
<cfif sPermissions["pRead"] is "0" and GetCategoryDetails.RecordCount GT "0">
	<TR><TD colspan="4" bgcolor="EAEAEA">You do not have permissions to view this category.</TD></TR>
<cfelseif GetCategoryDetails.RecordCount GT "0">
	<cfoutput query="GetCategoryDetails" group="CategoryID">
		<TR>
		<TD bgcolor="bac0c9" width="25%"><b>Page</b></TD><td bgcolor="eaeaea" colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0"><TR><TD>[ <span title="[ #CategoryID# ]">#CategoryName#</span> ]</TD><td align="right">
<a href="/content.cfm/#CategoryAlias#">Preview</A><a href="/content.cfm/#CategoryAlias#" target="_blank" title="Preview in new window">+</A>


		
		<!--- CRUD --->
		<cf_AddToQueryString querystring="#MVQueryString#" name="MVCid" value="#Val(ParentID)#">
		<cfset ReturnURL="#MVPage#?#QueryString#">
		<cfset Location="/common/admin/MasterView/CategoryModify.cfm">
		<cfset querystring="">
		<cfset cid=encrypt(CategoryID,APPLICATION.KEY)>
		<cfif sPermissions["pEdit"]>
			<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="Edit">
			<a href="#Location#?#querystring#">Edit</a>
		</cfif>
		<cfif sPermissions["pDelete"]>
			<cfset SavedToProduction="No">
			<cfif isWddx(CategoryPropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#CategoryPropertiesPacket#" output="sProperties">
				<cfif StructKeyExists(sProperties,"SaveToProductionKey") and sProperties.SaveToProductionKey IS "0">
					<cfset SavedToProduction="Yes">
				</cfif>
			</cfif>
			<cfif SavedToProduction and NOT sPermissions["pSaveLive"]>
				<a href="javascript:void(0);" title="You may not delete this category, since this is saved on production.">Delete</A>
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="ValidateDelete">
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">

				<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
				<a href="#Location#?#querystring#">Delete</A>
			</cfif>
		</cfif>
		<cfif sPermissions["pCreate"]>
			<cf_AddToQueryString querystring="#MVQueryString#" name="PageAction" value="Add">
			<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#cid#" OmitList="Cid">
			<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
			<a href="#Location#?#querystring#">Add Sub Page</A>
		</cfif>
		
		
		</td></tr></table></TD>
		</TR>
		<TR>
		<TD bgcolor="bac0c9"><b>Alias</b></TD><td bgcolor="eaeaea" colspan="3"><cfif CategoryAlias IS "">[ none ]<cfelse>[ #CategoryAlias# ]</cfif></TD>
		</TR>
		
		<TR>
		<TD bgcolor="bac0c9"><b>Type</b></TD><td bgcolor="eaeaea" colspan="3">[ #CategoryTypeName# ]</TD>
		</TR>
		<TR>
		<TD bgcolor="bac0c9"><b>Active</b></TD><td bgcolor="eaeaea" colspan="3">[ #YesNoFormat(CategoryActive)# ]</TD>
		<cfif CategoryURL IS NOT "">
			<TR><TD bgcolor="bac0c9"><b>Override URL</b></TD><td bgcolor="eaeaea" colspan="3"><cfif CategoryURL IS "">[ none ]<cfelse>[ #CategoryURL# ]</cfif></TD></TR>
		</cfif>
		
		<TR>
		<TD bgcolor="bac0c9"><b>Created</b></TD><td bgcolor="eaeaea" colspan="3">
			<cfinvoke component="/com/utils/tracking" method="GetTracking" returnVariable="ReturnString"
				Entity="Category"
				KeyID="#CategoryID#"
				Operation="create">[ #ReturnString# ]
		</TD>
		</TR>
		<TR>
		<TD bgcolor="bac0c9"><b>Last Updated</b></TD><td bgcolor="eaeaea" colspan="3"><cfinvoke component="/com/utils/tracking" method="GetTracking" returnVariable="ReturnString"
				Entity="Category"
				KeyID="#CategoryID#"
				Operation="modify">[ #ReturnString# ]</TD>
		</TR>
		<TR>
		<TD bgcolor="bac0c9"><b>Last Saved Live</b></TD><td bgcolor="eaeaea" colspan="3"><cfinvoke component="/com/utils/tracking" method="GetTracking" returnVariable="ReturnString"
				Entity="Category"
				KeyID="#CategoryID#"
				Operation="savelive">[ #ReturnString# ]</TD>
		</TR>
		<cfif 0>
			<TR><TD colspan="4" bgcolor="bac0c9"><strong>Local Details</strong></TD></TR>
			<cfset LocaleCategoryPresent="0">
			<cfoutput group="CategoryLocaleID">
				<cfif LocaleID IS SESSION.AdminCurrentAdminLocaleID>
					<cfset LocaleCategoryPresent="1">
					<TR>
					<TD bgcolor="bac0c9"><b>Page Name</b></TD><td bgcolor="eaeaea" colspan="3"><cfif CategoryLocaleID IS "">[none]<cfelseif CategoryLocaleName IS "">#CategoryName# (using same as Master)<cfelse>#CategoryLocaleName#</cfif></TD></TR>
					<TR><TD bgcolor="bac0c9"><b>Active</b></TD><td bgcolor="eaeaea" colspan="3"><cfif CategoryLocaleID IS "">[none]<cfelse>#YesNoFormat(CategoryLocaleActive)#</cfif></TD>
					</TR>
				</cfif>
			</cfoutput>
			<cfif LocaleCategoryPresent is "0">
				<TR>
				<TD bgcolor="bac0c9"><b>Page Name</b></TD><td bgcolor="eaeaea" colspan="3">[no localized details present]</TD></TR>
				<TR><TD bgcolor="bac0c9"><b>Active</b></TD><td bgcolor="eaeaea" colspan="3">[no localized details present]</TD>
				</TR>
			</cfif>
		</cfif>
	</cfoutput>
<cfelse>
	<TR><TD colspan="4" bgcolor="EAEAEA" align="center">Please select a category.</TD></TR>
</cfif>
</table>
&nbsp;
<cfif sPermissions["pRead"] is "1" and GetCategoryDetails.RecordCount gt "0">
	<table width="530" border="0" cellspacing="0" cellpadding="0">
	<TR bgcolor="EAEAEA"><TD><img src="/common/images/spacer.gif"></TD>
	<cfoutput>
		<cfloop index="ThisMVEid" from="1" to="#ListLen(StructKeyList(sMVEntity))#" step="1">
			<cfif sMVEntity[ThisMVEid].Entity is "Permissions" AND sPermissions["pManage"] is "0">
				<!--- User does not have permissions to manage permissions --->
			<cfelseif sMVEntity[ThisMVEid].Entity is "SaveLive" AND sPermissions["pSaveLive"] is "0">
				<!--- User does not have permissions to savelive --->
			<cfelse>
				<cf_addToqueryString querystring="#MVQueryString#" name="MVEid" value="#ThisMVEid#" Omitlist="mvsla">
				<cf_addToqueryString querystring="#QueryString#" name="MVCid" value="#MVCid#">
				<cfif MVEid IS ThisMVEid>
					<TD bgcolor="BAC0C9"><table><TR><TD><b>#sMVEntity[ThisMVEid].Name#</b></TD></TR></table></TD><TD><img src="/common/images/spacer.gif"></TD>
				<cfelse>
					<TD><a href="#MVPage#?#queryString#">#sMVEntity[ThisMVEid].Name#</A></TD><TD><img src="/common/images/spacer.gif"></TD>
				</cfif>
			</cfif>
		</cfloop>
	</cfoutput>
	</TR>
	<cfset Colspan=(ListLen(StructKeyList(sMVEntity))*2)+1>
	<cfoutput>
	<TR bgcolor="bac0c9"><TD colspan="#Colspan#">
	<table width="100%"><TR><TD bgcolor="white">
	<cfswitch expression="#MVEid#">
		<cfcase value="1">
			<cfif ListFind("71,73,67",GetCategoryDetails.CategoryTypeID)>
				<cfset ThisMode="OneColumn">
			<cfelse>
				<cfset ThisMode="ThreeColumn">
			</cfif>
			<cfmodule template="/common/modules/admin/MasterView/mv_Content.cfm" 
				CurrentCategoryID="#MVCid#" ObjectMode="#ThisMode#"
				sCurrentCategoryPermissions="#sPermissions#">
		</cfcase>
		<cfcase value="2">
			<cfmodule template="/common/modules/admin/MasterView/mv_SubCategory.cfm" 
				CurrentCategoryID="#MVCid#"
				sCurrentCategoryPermissions="#sPermissions#">
		</cfcase>
		<cfcase value="3">
			<cfmodule template="/common/modules/admin/MasterView/mv_SaveLive.cfm" 
				CurrentCategoryID="#MVCid#"
				sCurrentCategoryPermissions="#sPermissions#">
		</cfcase>
		<cfcase value="4">
			<cfmodule template="/common/modules/admin/MasterView/mv_Permissions.cfm"
				CurrentCategoryID="#MVCid#">
		</cfcase>
		<!--- <cfcase value="5">
			<cfmodule template="/common/modules/admin/MasterView/mv_LocalizationDetails.cfm" SiteType="#ThisSiteType#"
				CurrentCategoryID="#MVCid#">
		</cfcase> --->
		<cfdefaultcase>
			<p>Please select a category from the left.</p>
		</cfdefaultcase>
	</cfswitch>
	</TD></TR></table>
	</TD></TR></table>
	</cfoutput>
</cfif>




</TD></TR></table>

</cfmodule>