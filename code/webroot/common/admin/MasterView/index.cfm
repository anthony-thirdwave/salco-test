<cfinclude template="/common/admin/MasterView/_InitMasterView.cfm">
<cfquery name="GetCategoryDetails" datasource="#Application.DSN#">
	SELECT		CategoryName,qry_GetCategoryWithCategoryLocale.CategoryID,CategoryAlias, CategoryTypeName,
				CategoryActive, ParentID, CategoryTypeID, t_permissions.*, CategoryURL,
				CategoryPropertiesID, CategoryPropertiesPacket, CategoryLocaleName,
				categoryLocaleActive, CategoryLocaleID, LocaleID, TemplateID
	FROM		qry_GetCategoryWithCategoryLocale
	INNER JOIN	t_Permissions
	ON			qry_GetCategoryWithCategoryLocale.CategoryID = t_Permissions.CategoryID
	WHERE		qry_GetCategoryWithCategoryLocale.CategoryID = <cfqueryparam value="#Val(MVCid)#" cfsqltype="cf_sql_integer">
	AND 		UserGroupID IN (<cfqueryparam value="#ListAppend(SESSION.AdminUserGroupIDList, APPLICATION.SuperAdminUserGroupID)#" cfsqltype="cf_sql_integer" list="true">)
</cfquery>

<cfif GetCategoryDetails.RecordCount GT "0">
	<cfset PageTitle="Content Manager : #GetCategoryDetails.CategoryName#">
<cfelse>
	<cfset PageTitle="Content Manager">
</cfif>

<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="#PageTitle#"
	PageHeader="<a href=""/common/admin/"" class=""white"">Main Menu</A> | Content Manager">

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
<table width="940" cellpadding="0" cellspacing="0" border="0">
<tr valign="top"><td width="275">
<div class="dashModuleNormal">

	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">SITE</div>
		<div class="ModuleBody2">
			<cfmodule template="/common/modules/admin/menu/menuAjax.cfm" isAutoCollapse="1" MVEid="#MVEid#"/>

			<!--- get the number of top level "site" categories --->
			<cfinvoke component="com.ContentManager.CategoryHandler" method="getCategoryCount" returnvariable="catCount">
				<cfinvokeargument name="parentId" value="-1">
			</cfinvoke>

			<!--- if there are no categories, then give a link so they can create a site --->
			<cfif catCount eq 0>
				<a href="/common/admin/MasterView/CategoryModify.cfm?PageAction=Add">Create Site</a>
			</cfif>
		</div>
		<div class="boxbottom2"><div></div></div>
	</div>

</div>
</td><td width="665" style="padding-left:10px;">

<div class="tablist">
	<div class="tab1">
		<div class="box1">
			<div class="boxtop1"><div></div></div>
			<div class="ModuleTitle1">PAGE</div>
		</div>
	</div>

</div>
<cfif sPermissions["pRead"] is "0" and GetCategoryDetails.RecordCount GT "0">
	<div style="background-color:white"><P>You do not have permissions to view this category.</P></div>
<cfelseif GetCategoryDetails.RecordCount IS "0">
	<div style="background-color:white"><p>Please select a category.</p></div>
<cfelseif GetCategoryDetails.RecordCount GT "0">
	<cfoutput query="GetCategoryDetails" group="CategoryID">
		<div class="actionlist1">
			<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0"> Preview</a>

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
				<a href="#Location#?#querystring#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"> Edit</a>
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
					<a href="javascript:void(0);" title="You may not delete this category, since this is saved on production."><img src="/common/images/admin/icon_delete.gif" border="0"> Delete</A>
				<cfelse>
					<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="ValidateDelete">
					<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">

					<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
					<a href="#Location#?#querystring#" title="Delete"><img src="/common/images/admin/icon_delete.gif" border="0"> Delete</A>
				</cfif>
			</cfif>
			<cfif sPermissions["pCreate"]>
				<cf_AddToQueryString querystring="#MVQueryString#" name="PageAction" value="Add">
				<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#cid#" OmitList="Cid">
				<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
				<a href="#Location#?#querystring#"  title="Add Sub Page"><img src="/common/images/admin/icon_add.gif" border="0"> Add Sub Page</A>
			</cfif>
			<a href="mailto:?subject=#CategoryName#&body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#CGI.HTTP_Host##APPLICATION.contentPageInUrl#/#CategoryAlias#%0AEdit: http://#CGI.HTTP_Host##CGI.Path_Info#?#URLEncodedFormat(CGI.Query_String)#" Title="Email This Page"><img src="/common/images/admin/icon_email.gif" border="0"/> Email This Page</A>
		</div>
		<div style="background-color:white">&nbsp;
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
        <tr>
        	<td valign="top">
            <table  border="0" cellspacing="0" cellpadding="0" bgcolor="white">
        <tr valign="top" align="left" class="firstC">
			<td class="datatitle1" style="text-align:right;">Page:</td>
			<td class="datacontent1">#CategoryName#</td>
		</tr>

		<cfif CategoryAlias IS NOT "">
			<tr valign="top">
				<td class="datatitle1">Alias:</td>
				<td class="datacontent1">#CategoryAlias#</td>
			</tr>
		</cfif>
		<tr valign="top">
			<td class="datatitle1">Type:</td>
			<td class="datacontent1">#CategoryTypeName#</td>
		</tr>

		<tr valign="top">
			<td class="datatitle1">Active:</td>
			<td class="datacontent1">#YesNoFormat(CategoryActive)#</td>
		</tr>
		<cfif CategoryURL IS NOT "">
			<tr valign="top">
				<td class="datatitle1">Override URL:</td>
				<td class="datacontent1">#CategoryURL#</td>
			</tr>
		</cfif>

		<cfif 0>
			<tr valign="top">
				<td class="datatitle1"><strong>LOCAL DETAILS</strong></td>
				<td class="datacontent1"></td>
			</tr>
			<cfset LocaleCategoryPresent="0">
			<cfoutput group="CategoryLocaleID">
				<cfif LocaleID IS SESSION.AdminCurrentAdminLocaleID>
					<cfset LocaleCategoryPresent="1">
					<tr valign="top">
						<td class="datatitle1">Page Name:</td>
						<td class="datacontent1"><cfif CategoryLocaleName IS "">#CategoryName# (using same as Master)<cfelse>#CategoryLocaleName#</cfif></td>
					</tr>
					<tr valign="top">
						<td class="datatitle1">Name:</td>
						<td class="datacontent1">#YesNoFormat(CategoryLocaleActive)#</td>
					</tr>
				</cfif>
			</cfoutput>
			<cfif LocaleCategoryPresent is "0">
				<tr valign="top">
					<td class="datatitle1">Page Name:</td>
					<td class="datacontent1">no localized details present</td>
				</tr>
				<tr valign="top">
					<td class="datatitle1">Name:</td>
					<td class="datacontent1">no localized details present</td>
				</tr>
			</cfif>
		</cfif>
        </table>
        
        <table  border="0" cellspacing="0" cellpadding="0" bgcolor="white">
        <!-- second column -->
		<cfinvoke component="com.utils.tracking" method="GetTracking" returnVariable="ReturnString"
			Entity="Category"
			KeyID="#CategoryID#"
			Operation="create">

		<tr valign="top">
			<td class="datatitle1">Created:</td>
			<td class="datacontent1 sdatacontent1">#ReturnString#</td>
		</tr>

		<cfinvoke component="com.utils.tracking" method="GetPageLastModified" returnVariable="ReturnString"
			CategoryID="#CategoryID#">

		<tr valign="top">
			<td class="datatitle1">Last Updated:</td>
			<td class="datacontent1 sdatacontent1">#ReturnString#</td>
		</tr>

		<cfinvoke component="com.utils.tracking" method="GetTracking" returnVariable="ReturnString"
			Entity="Category"
			KeyID="#CategoryID#"
			Operation="savelive">

		<tr valign="top">
			<td class="datatitle1">Last Saved Live:</td>
			<td class="datacontent1 sdatacontent1">#ReturnString#</td>
		</tr>
		<!-- end second column -->
        </table>
        </td>

	</cfoutput>




	</table>
	&nbsp;
	</div>
	&nbsp;
	<div style="background-color:white;clear:left;">
	<cfif sPermissions["pRead"] is "1" and GetCategoryDetails.RecordCount gt "0">
		<cfoutput>
			<div class="tablist">
			<cfloop index="ThisMVEid" from="1" to="#ListLen(StructKeyList(sMVEntity))#" step="1">
				<cfif sMVEntity[ThisMVEid].Entity is "Permissions" AND sPermissions["pManage"] is "0">
					<!--- User does not have permissions to manage permissions --->
				<cfelseif sMVEntity[ThisMVEid].Entity is "SaveLive" AND (sPermissions["pSaveLive"] is "0" or SESSION.AdminUserGroupIDList IS "3")>
					<!--- User does not have permissions to savelive --->
				<cfelse>
					<cf_addToqueryString querystring="#MVQueryString#" name="MVEid" value="#ThisMVEid#" Omitlist="mvsla">
					<cf_addToqueryString querystring="#QueryString#" name="MVCid" value="#MVCid#">
					<cfif MVEid IS ThisMVEid>
						<div class="tab1">
							<div class="box1">
								<div class="boxtop1"><div></div></div>
								<div class="ModuleTitle1">#ucase(sMVEntity[ThisMVEid].Name)#</div>
							</div>
						</div>
					<cfelse>
						<div class="tab1">
							<div class="box2">
								<div class="boxtop2"><div></div></div>
								<div class="ModuleTitle2"><a href="#MVPage#?#queryString#">#sMVEntity[ThisMVEid].Name#</A></div>
							</div>
						</div>
					</cfif>
				</cfif>
			</cfloop>
			</div>
		</cfoutput>
		&nbsp;
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfoutput>
		<tr><td>
		<cfswitch expression="#MVEid#">
			<cfcase value="1">
				<cfif ListFind("71,73,67",GetCategoryDetails.CategoryTypeID)>
					<cfset ThisMode="OneColumn">
				<cfelse>
					<cfset ThisMode="TwoColumn">
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
		</td></tr></table>
		</cfoutput>
	</cfif>
	</div>
</cfif>

</td></tr>
</table>

</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>

<cfmodule template="/common/modules/admin/dsp_Admin.cfm">

