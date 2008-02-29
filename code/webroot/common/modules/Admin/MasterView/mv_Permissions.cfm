<cfparam name="ATTRIBUTES.FormAction" default="#CGI.Path_Info#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="errorstring" default="">

<cfparam name="ParamUserGroupID" default="">
<cfparam name="ParamCategoryID" default="">

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>
<cfset CheckMark="<b style=""color:green;font-family:courier new;"">*</b>">
<cfset NoCheckMark="<b style=""color:red;"">x</b>">

<cfif Isdefined("URL.mvpa")>
	<cfswitch expression="#URL.mvpa#">
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="Modify">
		</cfcase>
	</cfswitch>
</cfif>


<cftry>
	<cfif IsDefined("FORM.ugid")>
		<cfset ParamUserGroupID=Decrypt(URLDecode(FORM.ugid),APPLICATION.Key)>
	<cfelse>
		<cfset ParamUserGroupID=Decrypt(ugid,APPLICATION.Key)>
	</cfif>
	<cfcatch><cfset ParamUserGroupID="-1"></cfcatch>
</cftry>

<cftry>
	<cfif IsDefined("FORM.cid")>
		<cfset ParamCategoryID=Decrypt(URLDecode(FORM.cid),APPLICATION.Key)>
	<cfelse>
		<cfset ParamCategoryID=Decrypt(cid,APPLICATION.Key)>
	</cfif>
	<cfcatch><cfset ParamCategoryID="-1"></cfcatch>
</cftry>

<!--- Update permission--->
<cfif ATTRIBUTES.ObjectAction IS "Modify" and ParamCategoryID GT "0">
	<cfparam name="pRead_value" default="0">
	<cfparam name="pCreate_value" default="0">
	<cfparam name="pEdit_value" default="0">
	<cfparam name="pDelete_value" default="0">
	<cfparam name="pSaveLive_value" default="0">
	<cfparam name="pManage_value" default="0">
	<cfparam name="Recurse" default="0">
	
	<cfif pManage_value>
		<cfset pRead_value="1">
		<cfset pCreate_value="1">
		<cfset pEdit_value="1">
		<cfset pDelete_value="1">
		<cfset pSaveLive_value="1">
	</cfif>
	<cfif pCreate_value>
		<cfset pEdit_Value="1">
	</cfif>
	<cfif pCreate_value OR pEdit_value OR pDelete_value OR pSaveLive_value>
		<cfset pRead_Value="1">
	</cfif>
	
	<cfif Recurse>
		<cf_GetBranch item="#ParamCategoryID#" DataSource="#Application.DSN#" 
			table="t_Category" Column="CategoryID" ParentColumn="ParentID">
	<cfelse>
		<cfset branch="#ParamCategoryID#">
	</cfif>
	<cfloop index="ThisCategoryID" list="#branch#">
		<cfquery name="Test" datasource="#Application.DSN#">
			select * from t_Permissions where UserGroupID=<cfqueryparam value="#Val(ParamUserGroupID)#" cfsqltype="cf_sql_integer"> And CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif test.Recordcount IS "0">
			<cfquery name="Test" datasource="#Application.DSN#">
				insert into t_permissions (
				UserGroupID,
				CategoryID,
				pRead,
				pCreate,
				pEdit,
				pDelete,
				pSaveLive,
				pManage
				) VALUES (
				<cfqueryparam value="#Val(ParamUserGroupID)#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Val(pRead_value)#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Val(pCreate_value)#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Val(pEdit_value)#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Val(pDelete_value)#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Val(pSaveLive_value)#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Val(pManage_value)#" cfsqltype="cf_sql_bit">
				)
			</cfquery>
		<cfelse>
			<cfquery name="Test" datasource="#Application.DSN#">
				update t_Permissions
				set
				pRead=<cfqueryparam value="#Val(pRead_value)#" cfsqltype="cf_sql_bit">, 
				pCreate=<cfqueryparam value="#Val(pCreate_value)#" cfsqltype="cf_sql_bit">, 
				pEdit=<cfqueryparam value="#Val(pEdit_value)#" cfsqltype="cf_sql_bit">, 
				pDelete=<cfqueryparam value="#Val(pDelete_value)#" cfsqltype="cf_sql_bit">, 
				pSaveLive=<cfqueryparam value="#Val(pSaveLive_value)#" cfsqltype="cf_sql_bit">, 
				pManage=<cfqueryparam value="#Val(pManage_value)#" cfsqltype="cf_sql_bit">
				where UserGroupID=<cfqueryparam value="#Val(ParamUserGroupID)#" cfsqltype="cf_sql_integer"> And CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
			</cfquery>		
		</cfif>
	</cfloop>
	<cf_AddToQueryString queryString="#FormQueryString#" Name="MVpa" value="1" Omitlist="ugid,cid">
	<cflocation url="#FormPage#?#QueryString#" addtoken="No">
</cfif>

<cfquery name="GetUserGroups" datasource="#Application.DSN#">
	select * from t_Label where labelgroupID=10 AND 
	(LabelCode='UGRP' OR LabelID=<cfqueryparam value="#Val(APPLICATION.SuperAdminUserGroupID)#" cfsqltype="cf_sql_integer"> OR labelID=<cfqueryparam value="#Val(APPLICATION.ContentEditorUserGroupID)#" cfsqltype="cf_sql_integer">) 
	order by labelpriority
</cfquery>

<!--- Select Owners --->
<cfquery name="SelectOwners" datasource="#Application.DSN#">
	SELECT	* 
	FROM	qry_GetPermissions
	WHERE		CategoryID=<cfqueryparam value="#val(attributes.currentcategoryid)#" cfsqltype="cf_sql_integer">
	ORDER BY	UserGroupName
</cfquery>

<script>
	function setRead(input) {
		inputStr="document.form_permissions." + input +".checked";
		if (eval(inputStr)) {
			if (!document.form_permissions.pRead_value.checked) {
				document.form_permissions.pRead_value.click()
			}
		}
	}
	function setEdit(input) {
		inputStr="document.form_permissions." + input +".checked";
		if (eval(inputStr)) {
			if (!document.form_permissions.pEdit_value.checked) {
				document.form_permissions.pEdit_value.click();
			}
		}
	}
	function setAll(input) {
		inputStr="document.form_permissions." + input +".checked";
		if (eval(inputStr)) {
			if (!document.form_permissions.pRead_value.checked) {
				document.form_permissions.pRead_value.click();
			}
			if (!document.form_permissions.pCreate_value.checked) {
				document.form_permissions.pCreate_value.click();
			}
			if (!document.form_permissions.pEdit_value.checked) {
				document.form_permissions.pEdit_value.click();
			}
			if (!document.form_permissions.pDelete_value.checked) {
				document.form_permissions.pDelete_value.click();
			}
			if (!document.form_permissions.pSaveLive_value.checked) {
				document.form_permissions.pSaveLive_value.click();
			}
			if (!document.form_permissions.pManage_value.checked) {
				document.form_permissions.pManage_value.click();
			}
		}
	}
	
	function assertPermissions() {
		if (!document.form_permissions.pRead_value.checked) {
			if (document.form_permissions.pCreate_value.checked) {
				document.form_permissions.pRead_value.click();
			}
			else if (document.form_permissions.pEdit_value.checked) {
				document.form_permissions.pRead_value.click();
			}
			else if (document.form_permissions.pDelete_value.checked) {
				document.form_permissions.pRead_value.click();
			}
			else if (document.form_permissions.pSaveLive_value.checked) {
				document.form_permissions.pRead_value.click();
			}
			else if (document.form_permissions.pManage_value.checked) {
				document.form_permissions.pRead_value.click();
			}
		}
		if (document.form_permissions.pCreate_value.checked) {
			setEdit('pCreate_value');
		}
		if (document.form_permissions.pManage_value.checked) {
			setAll('pManage_value');
		}
	}
</script>

<table width="100%">
	<tr valign="top" bgcolor="BAC0C9">
		<TD width="50%"><b>User Group</b></TD>
		<td valign="bottom"><img src="/common/images/contentManager/pread.gif"></td>
		<TD valign="bottom"><img src="/common/images/contentManager/pcreate.gif"></TD>
		<TD valign="bottom"><img src="/common/images/contentManager/pEdit.gif"></TD>
		<TD valign="bottom"><img src="/common/images/contentManager/pDelete.gif"></TD>
		<TD valign="bottom"><img src="/common/images/contentManager/pSaveLive.gif"></TD>
		<TD valign="bottom"><img src="/common/images/contentManager/pManage.gif"></TD>
		<TD width="50%"></TD>
	</tr>
	<cfif SelectOwners.recordcount GT 0>	
		<cfoutput query="SelectOwners">
			<cfif ParamUserGroupID IS UserGroupID and ParamCategoryID IS CategoryID>
				<cf_AddToQueryString queryString="#FormQueryString#" Name="MVpa" value="2">
				<cf_AddToQueryString queryString="#QueryString#" Name="ugid" value="#Encrypt(UserGroupID,APPLICATION.Key)#">
				<cf_AddToQueryString queryString="#QueryString#" Name="cid" value="#Encrypt(CategoryID,APPLICATION.Key)#">
				<form action="#FormPage#?#QueryString#" method="post" name="form_permissions">
				<tr valign="top" bgcolor="EAEAEA">
					<td width="50%">#UserGroupname#</td>
					<TD align="center"><input type="checkbox" name="pRead_value" value="1" onBlur="assertPermissions()" #iif(pRead,DE("checked"),de(""))#></TD>
					<TD align="center"><input type="checkbox" name="pCreate_value" value="1" onBlur="assertPermissions()" #iif(pCreate,DE("checked"),de(""))#></TD>
					<TD align="center"><input type="checkbox" name="pEdit_value" value="1" onBlur="assertPermissions()" #iif(pEdit,DE("checked"),de(""))#></TD>
					<TD align="center"><input type="checkbox" name="pDelete_value" value="1" onBlur="assertPermissions()" #iif(pDelete,DE("checked"),de(""))#></TD>
					<TD align="center"><input type="checkbox" name="pSaveLive_value" value="1" onBlur="assertPermissions()" #iif(pSaveLive,DE("checked"),de(""))#></TD>
					<TD align="center"><input type="checkbox" name="pManage_value" value="1" onBlur="assertPermissions()" #iif(pManage,DE("checked"),de(""))#></TD>
					<td width="50%"><input type="submit" value="save"><P>
					<select name="recurse">
						<option value="0"></option>
						<option value="1">Set recursively</option>
					</select></td>
				</tr></form>
			<cfelse>
				<tr bgcolor="EAEAEA">
					<td width="50%">#UserGroupname#</td>
					<TD align="center">#iif(pRead,DE(CheckMark),DE(NoCheckMark))#</TD>
					<TD align="center">#iif(pCreate,DE(CheckMark),DE(NoCheckMark))#</TD>
					<TD align="center">#iif(pEdit,DE(CheckMark),DE(NoCheckMark))#</TD>
					<TD align="center">#iif(pDelete,DE(CheckMark),DE(NoCheckMark))#</TD>
					<TD align="center">#iif(pSaveLive,DE(CheckMark),DE(NoCheckMark))#</TD>
					<TD align="center">#iif(pManage,DE(CheckMark),DE(NoCheckMark))#</TD>
					<td width="50%">
					<cfmodule template="/common/modules/user/GetUserPermissions.cfm" UserGroupID="#SESSION.AdminUserGroupIDList#" CategoryID="#CategoryID#" Action="Manage">
					<cfif PermissionAllowed and Val(ParamUserGroupID) lte "0">
						<cf_AddToQueryString queryString="#FormQueryString#" Name="MVpa" value="1">
						<cf_AddToQueryString queryString="#QueryString#" Name="ugid" value="#Encrypt(UserGroupID,APPLICATION.Key)#">
						<cf_AddToQueryString queryString="#QueryString#" Name="cid" value="#Encrypt(CategoryID,APPLICATION.Key)#">
						<a href="#FormPage#?#QueryString#">modify</a>
					</cfif>
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfif>
	<cfmodule template="/common/modules/user/GetUserPermissions.cfm" UserGroupID="#SESSION.AdminUserGroupIDList#" CategoryID="#attributes.currentcategoryid#" Action="Manage">
	<cfif PermissionAllowed and Val(ParamUserGroupID) lte "0" AND GetuserGroups.RecordCount is not SelectOwners.recordcount>
		<cf_AddToQueryString queryString="#FormQueryString#" Name="MVpa" value="2">
		<cf_AddToQueryString queryString="#QueryString#" Name="cid" value="#Encrypt(attributes.currentcategoryid,APPLICATION.Key)#">
		<cfoutput><form action="#FormPage#?#QueryString#" method="post" name="form_permissions"></cfoutput>
		<tr valign="top" bgcolor="EAEAEA">
		<td>
		<select name="ugid">
			<cfoutput query="GetuserGroups">
				<cfif ListFindNoCase(ValueList(SelectOwners.UserGroupID),LabelID) IS "0">
					<option value="#URLEncodedFormat(Encrypt(LabelID,APPLICATION.Key))#">#LabelName# <cfif LabelCode IS "UGRP_S">(system)</cfif></option>
				</cfif>
			</cfoutput>
		</select></td>
		<TD align="center"><input type="checkbox" name="pRead_value" value="1" onBlur="assertPermissions()"></TD>
		<TD align="center"><input type="checkbox" name="pCreate_value" value="1" onBlur="assertPermissions()"></TD>
		<TD align="center"><input type="checkbox" name="pEdit_value" value="1" onBlur="assertPermissions()"></TD>
		<TD align="center"><input type="checkbox" name="pDelete_value" value="1" onBlur="assertPermissions()"></TD>
		<TD align="center"><input type="checkbox" name="pSaveLive_value" value="1" onBlur="assertPermissions()"></TD>
		<TD align="center"><input type="checkbox" name="pManage_value" value="1" onBlur="assertPermissions()"></TD>
		<td><input type="submit" value="add"><P>
		<select name="recurse">
			<option value="0"></option>
			<option value="1">Set recursively</option>
		</select>
		</td></tr>
		</form>
	</cfif>
</table>
