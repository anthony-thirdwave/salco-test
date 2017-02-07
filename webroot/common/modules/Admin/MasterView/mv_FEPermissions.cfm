<cfparam name="ATTRIBUTES.FormAction" default="#CGI.SCRIPT_NAME#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="errorstring" default="">

<cfparam name="ParamUserGroupID" default="">
<cfparam name="ParamCategoryID" default="">
<cfparam name="form.recurse" default=0/>

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>
<cfset CheckMark="<b style=""color:green;font-family:courier new;"">*</b>">
<cfset NoCheckMark="<b style=""color:red;"">x</b>">

<cfif Isdefined("form.mvpa")>
	<cfswitch expression="#form.mvpa#">
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="Modify">
		</cfcase>
	</cfswitch>
</cfif>


<!--- <cftry>
	<cfif IsDefined("FORM.ugid")>
		<cfset ParamUserGroupID=Decrypt(URLDecode(FORM.ugid),APPLICATION.Key)>
	<cfelse>
		<cfset ParamUserGroupID=Decrypt(ugid,APPLICATION.Key)>
	</cfif>
	<cfcatch><cfset ParamUserGroupID="-1"></cfcatch>
</cftry> --->

<!--- <cftry>
	<cfif IsDefined("FORM.cid")>
		<cfset ParamCategoryID=Decrypt(URLDecode(FORM.cid),APPLICATION.Key)>
	<cfelse>
		<cfset ParamCategoryID=Decrypt(cid,APPLICATION.Key)>
	</cfif>
	<cfcatch><cfset ParamCategoryID="-1"></cfcatch>
</cftry> --->

<!--- Update permission
<cfif ATTRIBUTES.ObjectAction IS "Modify">--->
	<!---
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
			select * from t_Permissions where UserGroupID=#Val(ParamUserGroupID)# And CategoryID=#Val(ThisCategoryID)#
		</cfquery>
		<cfif test.Recordcount IS "0">
			<cfquery name="Test" datasource="#Application.DSN#">
				insert into t_permissions 
				(UserGroupID, CategoryID, pRead, pCreate, pEdit, pDelete, pSaveLive, pManage)
				VALUES
				(#Val(ParamUserGroupID)#, #Val(ThisCategoryID)#,#Val(pRead_value)#,#Val(pCreate_value)#,#Val(pEdit_value)#,#Val(pDelete_value)#,#Val(pSaveLive_value)#,#Val(pManage_value)#)
			</cfquery>
		<cfelse>
			<cfquery name="Test" datasource="#Application.DSN#">
				update t_Permissions
				set
				pRead=#Val(pRead_value)#, 
				pCreate=#Val(pCreate_value)#, 
				pEdit=#Val(pEdit_value)#, 
				pDelete=#Val(pDelete_value)#, 
				pSaveLive=#Val(pSaveLive_value)#, 
				pManage=#Val(pManage_value)#
				where UserGroupID=#Val(ParamUserGroupID)# And CategoryID=#Val(ThisCategoryID)#
			</cfquery>		
		</cfif>
	</cfloop>
	<cf_AddToQueryString queryString="#FormQueryString#" Name="MVpa" value="1" Omitlist="ugid,cid">
	--->
	
	

	<cfif isDefined("form.ChangeFEPermissions") and form.ChangeFEPermissions eq 1>

		<!--- ok, we should have a list of all the group id's --->
		<!--- first we should delete all permissions from the db for this category --->
		<cfif form.CategoryId neq "" and form.categoryID gt 0>
			<!--- set the subcategory list --->
			<cfset catList = form.categoryID/>
			<cfif form.recurse>
				<cf_GetBranch item="#mvcid#" DataSource="#Application.DSN#" 
				table="t_Category" Column="CategoryID" ParentColumn="ParentID">
				<cfset catList = #branch#/>
			</cfif>
			<cfquery name="deleteFEPErmissions" datasource="#application.dsn#">
				DELETE FROM t_FrontEndPermissions
				WHERE categoryId IN (<cfqueryparam value="#catList#" cfsqltype="cf_sql_integer" list="yes">)
			</cfquery>
			<!--- now we need to insert the new ones --->
			<cfloop list="#form.LabelID#" index="i">
				<cfset thisVis = 0/>
				<cfset thisVis = #evaluate("form.#i#")#/>
				<cfif #i# gt 0>
					<!--- now need to loop catlist --->
					<cfloop list="#catlist#" index="j">
					<cfquery name="InsertFrontEndPermission" datasource="#application.dsn#">
							INSERT INTO t_FrontEndPermissions (
							CategoryID, 
							UserGroupID, 
							pView
							) VALUES (
							<cfqueryparam value="#j#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#i#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#thisVis#">
							)
						</cfquery>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	
	<!--- <cflocation url="#FormPage#?#QueryString#" addtoken="No"> 
</cfif>--->

<cfquery name="GetGroups" datasource="#application.dsn#">
	SELECT LabelName, LabelID, LabelPriority
	FROM t_Label
	WHERE LabelGroupID = 240
	ORDER BY LabelName
</cfquery>

<!--- NEW TABLE --->
<table width="100%">
	<tr valign="top" bgcolor="BAC0C9">
		<TD width="50%"><b>User Group</b></TD>
		<td valign="bottom" align="center" colspan="2"><strong>Visible</strong></td>
	</tr>
	<cfoutput><form action="#ATTRIBUTES.FormAction#" method="post" name="form_permissions"></cfoutput>
	<input type="hidden" name="CategoryId" value="<cfoutput>#mvcid#</cfoutput>"/>
	<input type="hidden" name="MVps" value="2"/>
	<input type="hidden" name="MVEid" value="3"/>
	<input type="hidden" name="ChangeFEPermissions" value="1"/>
	<!--- begin the loop of groups --->
	<cfoutput query="GetGroups">
		<cfset isVisible = 0/>
		<cfquery name="getVisible" datasource="#application.dsn#">
			SELECT pView FROM t_FrontEndPermissions
			WHERE CategoryID = <cfqueryparam value="#mvcid#" cfsqltype="cf_sql_integer">
			AND UserGroupId = <cfqueryparam value="#LabelID#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif getVisible.pView eq 1>
			<cfset isVisible = 1/>
		</cfif>
		<tr bgcolor="EAEAEA">
			<td width="50%" bgcolor="bac0c9">#LabelName#</td>
			<input type="hidden" name="LabelID" value="#LabelID#"/>
			<TD align="center"><input name="#LabelID#" type="radio" value="0" <cfif isVisible eq 0>checked</cfif>/>No</TD>
			<TD align="center"><input name="#LabelID#" type="radio" value="1" <cfif isVisible eq 1>checked</cfif>/>Yes</TD>
		</tr>
	</cfoutput>
	<!--- end loop --->
	<tr bgcolor="EAEAEA">
		<td bgcolor="bac0c9">&nbsp;</td>
		<TD colspan="2" align="center"><input name="recurse" type="checkbox" value="1"> Recursive?</TD>
	</tr>
	<tr bgcolor="EAEAEA">
		<td bgcolor="bac0c9">&nbsp;</td>
		<TD colspan="2" align="center"><input type="submit" value="UPDATE"></TD>
	</tr>
	</form>
</table>


