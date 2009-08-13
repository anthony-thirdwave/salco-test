<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#">
<cfparam name="ATTRIBUTES.EditAction" default="/common/admin/masterview/index.cfm?MVEid=1">
<cfparam name="ATTRIBUTES.RequestAction" default="/common/admin/workflow/request.cfm">
<cfparam name="ATTRIBUTES.ObjectAction" default="SearchResults">
<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="ParamCascade" default="0">
<cfparam name="ParamTitle" default="">
<cfparam name="ParamStatusID" default="-1">
<cfparam name="ParamOrderBy" default="DisplayOrder">
<cfparam name="ShowOnlyCategoryTypeID" default="#APPLICATION.lVisibleCategoryTypeID#">
<cfparam name="DismissAll" default="0">

<cfparam name="SearchNum" default="10">
<cfif IsDefined("StartRow")>
	<CFSET StartRow = (StartRow + SearchNum)>
<cfelse>
	<CFSET StartRow = 1>
</cfif>

<cfif IsDefined("FORM.ParamCascade")>
	<cfset SESSION.dmv_ParamCascade=FORM.ParamCascade>
<cfelseif IsDefined("SESSION.dmv_ParamCascade")>
	<cfset ParamCascade=SESSION.dmv_ParamCascade>
</cfif>

<cfset QueryString="">
<cfloop index="ThisParam" list="ParamTitle,ParamStatusID,ParamOrderBy,ParamCascade">
	<cf_AddToQueryString queryString="#QueryString#" Name="#ThisParam#" value="#Evaluate(ThisParam)#">
</cfloop>
<cf_AddToQueryString queryString="#QueryString#" Name="mvca" value="1">
<cf_AddToQueryString queryString="#QueryString#" Name="MVMode" value="publish">
<cf_AddToQueryString queryString="#QueryString#" Name="mvcid" value="#ATTRIBUTES.CategoryID#">
<cfset ThisPageQueryString="#querystring#">

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString="">
<cfif ListLen(ATTRIBUTES.FormAction,"?") IS "2">
	<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>
</cfif>

<cfset EditPage=ListFirst(ATTRIBUTES.EditAction,"?")>
<cfset EditQueryString="">
<cfif ListLen(ATTRIBUTES.EditAction,"?") IS "2">
	<cfset EditQueryString=ListLast(ATTRIBUTES.EditAction,"?")>
</cfif>

<cfset RequestPage=ListFirst(ATTRIBUTES.RequestAction,"?")>
<cfset RequestQueryString="">
<cfif ListLen(ATTRIBUTES.RequestAction,"?") IS "2">
	<cfset RequestQueryString=ListLast(ATTRIBUTES.RequestAction,"?")>
</cfif>

<cfparam name="HighlightID" default="-1">
<cfif IsDefined("URL.hlid")>
	<cfset HighlightID=REQUEST.SimpleDecrypt(URL.hlid)>
</cfif>

<!--- Pull production information --->
<cfinvoke component="/com/ContentManager/CategoryHandler"
	method="GetProductionSiteInformation"
	returnVariable="sProductionSiteInformation"
	CategoryID="#ATTRIBUTES.CategoryID#">
<cfif IsStruct(sProductionSiteInformation) and StructKeyExists(sProductionSiteInformation,"ProductionDBDSN") and sProductionSiteInformation["ProductionDBDSN"] IS NOT "">
	<cfset ProductionDBDSN=sProductionSiteInformation["ProductionDBDSN"]>
<cfelse>
	<cfset ProductionDBDSN="">
</cfif>

<!--- Query for domains of search options --->

<cfset sStatus=StructNew()>
<cfquery name="GetStatus" datasource="#APPLICATION.DSN#">
	select * from t_label where LabelGroupID=<cfqueryparam value="18000" cfsqltype="cf_sql_integer">
	Order by LabelPriority
</cfquery>
<cfoutput query="GetStatus">
	<cfset StructInsert(sStatus,LabelID,LabelName)>
</cfoutput>

<cfquery name="GetBranchDO" datasource="#APPLICATION.DSN#">
	select DisplayOrder from t_category where
	CategoryID=<cfqueryparam value="#ATTRIBUTES.CategoryID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset sOrderBy=StructNew()>
<cfset StructInsert(sOrderBy,"Title","CategoryName")>
<cfset StructInsert(sOrderBy,"Type","CategoryTypeName")>
<cfset StructInsert(sOrderBy,"Status","StatusName")>
<cfset StructInsert(sOrderBy,"DisplayOrder","CategoryLocaleDisplayOrder")>
<cfset StructInsert(sOrderBy,"Last Updated","TrackingDateTime desc")>

<cfif Isdefined("URL.mvca")>
	<cfswitch expression="#URL.mvca#">
		<cfcase value="1">
			<cfset ATTRIBUTES.ObjectAction="SearchResults">
		</cfcase>
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="UpdateStatus">
		</cfcase>
	</cfswitch>
</cfif>

<cfswitch expression="#ATTRIBUTES.ObjectAction#">
	<cfcase value="UpdateStatus">
		<cfset lCategoryLocaleIDToDeactivate="">
		<cfset lCategoryLocaleIDToPublish="">
		<cfloop index="i" from="1" to="#NumItems#" step="1">
			<cftry>
				<cfset ThisCategoryLocaleID=REQUEST.SimpleDecrypt(URLDecode(Evaluate("EditCategoryLocaleID#i#")))>
				<cfcatch>
					<cfset ThisCategoryLocaleID="-1">
				</cfcatch>
			</cftry>
			<cftry>
				<cfset ThisCategoryID=REQUEST.SimpleDecrypt(URLDecode(Evaluate("EditCategoryID#i#")))>
				<cfcatch>
					<cfset ThisCategoryID="-1">
				</cfcatch>
			</cftry>
			<cfparam name="WorkflowStatusID_#i#" default="0">
			<cfparam name="SaveLive_#i#" default="0">
			<cfparam name="RequestSaveLive_#i#" default="0">
			<cfif ThisCategoryLocaleID GT "0" and ThisCategoryID GT "0">
				<cfif Evaluate("SaveLive_#i#")>
					<!--- Add this page to the list of pages to publish live --->
					<cfset lCategoryLocaleIDToPublish=ListAppend(lCategoryLocaleIDToPublish,ThisCategoryLocaleID)>
					<!--- Set status to live --->
					<cfset SetVariable("WorkflowStatusID_#i#",18000)><!--- 18000 is "live" --->
					<cfif Evaluate("WorkflowStatusID_#i#") GT "0">
						<cfquery name="UpdateWorkflowStatusID" datasource="#APPLICATION.DSN#">
							update t_CategoryLocale Set
							WorkflowStatusID=<cfqueryparam value="#Evaluate('WorkflowStatusID_#i#')#" cfsqltype="cf_sql_integer">
							WHERE
							CategoryLocaleID=<cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif DismissAll IS "1">
							<cfinvoke component="/com/workflow/RequestHandler"
								method="DismissOutstandingPublishRequest"
								returnVariable="qOutstandingPublishRequest"
								CategoryID="#ThisCategoryID#">
						</cfif>
					</cfif>
					<cfif Evaluate("WorkflowStatusID_#i#") IS "18002"><!--- If article is changed to archive --->
						<!--- Mark it on live too --->
						<cfset lCategoryLocaleIDToDeactivate=ListAppend(lCategoryLocaleIDToDeactivate,ThisCategoryLocaleID)>
					</cfif>
					<cfif 1>
						<cfinvoke component="/com/ContentManager/CategoryHandler"
							method="GetCategoryBasicDetails"
							returnVariable="qCategory"
							CategoryID="#Val(ThisCategoryID)#">
						<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
							UserID="#SESSION.AdminUserID#"
							Entity="Category"
							KeyID="#Val(ThisCategoryID)#"
							Operation="revisioncreate"
							EntityName="#qCategory.CategoryName#">
					</cfif>
				</cfif>

				<cfif Evaluate("RequestSaveLive_#i#")>
					<cfset MyWorkflowRequest=CreateObject("component","/com/workflow/request")>
					<cfset MyWorkflowRequest.Constructor(-1)>
					<cfset MyWorkflowRequest.SetProperty("FromUserID",SESSION.AdminUserID)>
					<cfset MyWorkflowRequest.SetProperty("CategoryID",ThisCategoryID)>
					<cfset MyWorkflowRequest.SetProperty("WorkflowRequestTypeID",19001)><!--- Request to save live --->
					<cfinvoke component="/com/user/userhandler" method="GetCategoryOwnerEditorUserGroups"
						returnVariable="qGetCategoryOwnerEditorUserGroups"
						CategoryID="#ThisCategoryID#">
					<cfset ThisLToUserGroupID="">
					<cfoutput query="qGetCategoryOwnerEditorUserGroups" group="UserGroupID">
						<cfif pSaveLive>
							<cfset ThisLToUserGroupID=ListAppend(ThisLToUserGroupID,UserGroupID)>
						</cfif>
					</cfoutput>
					<cfset MyWorkflowRequest.SetProperty("LToUserGroupID","#ThisLToUserGroupID#")>
					<cfset MyWorkflowRequest.Save()>
					<cfset MyWorkflowRequest="">
				</cfif>
			</cfif>
		</cfloop>

		<cfif APPLICATION.Staging>
			<cfif ProductionDBDSN IS NOT "">
				<cftransaction>
					<cfloop index="ThisCategoryLocaleID" list="#lCategoryLocaleIDToDeactivate#">
						<cfquery name="UpdateWorkflowStatusID" datasource="#ProductionDBDSN#">
							update t_CategoryLocale Set
							WorkflowStatusID=<cfqueryparam value="18002" cfsqltype="cf_sql_integer">,
							CategoryLocaleActive=<cfqueryparam value="0" cfsqltype="cf_sql_integer">
							WHERE
							CategoryLocaleID=<cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfloop>
				</cftransaction>

				<cfset lCategoryIDToSave="">
				<cfloop index="ThisCategoryLocaleID" list="#lCategoryLocaleIDToPublish#">
					<cfquery name="GetCategoryID" datasource="#APPLICATION.DSN#">
						select CategoryID from t_CategoryLocale
						Where
						CategoryLocaleID=<cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset lCategoryIDToSave=ListAppend(lCategoryIDToSave,GetCategoryID.CategoryID)>
				</cfloop>
				<cfinvoke component="/com/ContentManager/CategoryHandler"
					method="SavePages"
					returnVariable="bSuccess"
					UserID="#SESSION.AdminUserID#"
					LocaleID="#ATTRIBUTES.LocaleID#"
					lCategoryID="#lCategoryIDToSave#">
			</cfif>
		<cfelse>
			<cfdump var="#lCategoryLocaleIDToDeactivate#">
			<cfdump var="#lCategoryLocaleIDToPublish#">
		</cfif>
		<cfif IsDebugMode()>
			<cfabort>
		</cfif>
		<cf_AddToQueryString queryString="#FormQueryString#" name="mvca" value="1">
		<cflocation url="#FormPage#?#QueryString#" addToken="no">
	</cfcase>

	<cfdefaultcase>

		<cfquery name="GetTopCategories1" datasource="#APPLICATION.DSN#">
			select CategoryName,DisplayLevel,DisplayOrder,CategoryID,pEdit,pSaveLive,UserGroupid
			from qry_GetCategoryPermission
			WHERE
			UserGroupID IN (<cfqueryparam value="#Session.AdminUserGroupIDList#" cfsqltype="cf_sql_integer" list="yes">)
			and PEdit=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			and DisplayOrder like <cfqueryparam value="#GetBranchDO.DisplayOrder#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset lCategoryIDPermission=ValueList(GetTopCategories1.CategoryID)>

		<cfif lCategoryIDPermission IS "">
			<cfset lCategoryIDPermission="-1">
		</cfif>

		<Cfquery name="GetTopCategories" dbtype="query">
			select * from GetTopCategories1 order by DisplayORder
		</cfquery>

		<!--- Commented out for speeds sake. will need for internationalization though
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetTopCategories">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="#ValueList(GetAllCategories.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="60,90" null="Yes"><!--- Content,Topic --->
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
		</cfstoredproc> --->

		<cfquery name="GetCategoryList" datasource="#APPLICATION.DSN#">
			SELECT * from qry_GetWorkFlow
			WHERE
			LocaleID = <cfqueryparam value="#Val(ATTRIBUTES.LocaleID)#" cfsqltype="cf_sql_integer">
			<cfif ParamTitle IS NOT "">
				and CategoryName like <cfqueryparam value="%#ParamTitle#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif Val(ParamStatusID) GT "0">
				and WorkflowStatusID=<cfqueryparam value="#ParamStatusID#" cfsqltype="cf_sql_integer">
			</cfif>
			and
			<cfif ParamCascade IS "1"><!--- this page and subpages --->
				(
				ParentID=<cfqueryparam value="#ATTRIBUTES.CategoryID#" cfsqltype="cf_sql_integer"> OR
				CategoryID=<cfqueryparam value="#ATTRIBUTES.CategoryID#" cfsqltype="cf_sql_integer">
				)
			<cfelseif ParamCascade IS "2"><!--- whole section --->
				(
				ParentID IN (#lCategoryIDPermission#) OR
				CategoryID=<cfqueryparam value="#ATTRIBUTES.CategoryID#" cfsqltype="cf_sql_integer">
				)
			<cfelse><!--- Just this page --->
				CategoryID=<cfqueryparam value="#ATTRIBUTES.CategoryID#" cfsqltype="cf_sql_integer" list="yes">
			</cfif>
			ORDER BY #sOrderBy[ParamOrderBy]#
		</cfquery>

		<cfset GetFinal = QueryNew(GetCategoryList.ColumnList)>
		<cfoutput query="GetCategoryList" group="CategoryID">
			<cfset QueryAddRow(GetFinal)>
			<cfloop index="ThisCol" list="#GetCategoryList.ColumnList#">
				<cfset QuerySetCell(GetFinal,ThisCol,Evaluate(ThisCol))>
			</cfloop>
		</cfoutput>


		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="1" OmitList="ParamTitle,ParamStatusID,ParamOrderBy,ParamCascade,startRow,SearchNum">
		<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
		<TR>
		<TD class="bordertop2" colspan="5" align="right" nowrap>
			<cfif ParamCascade IS not "0">
				<strong>Title</strong> <input type="text" class="text" value="<cfoutput>#ParamTitle#</cfoutput>" name="ParamTitle" style="width:80px;">
				<strong>Status</strong>
				<select name="ParamStatusID" class="form">
					<option value="-1">All</option>
					<cfoutput query="GetStatus">
						<option value="#LabelID#" <cfif ParamStatusID IS LabelID>selected</cfif>>#LabelName#</option>
					</cfoutput>
				</select>
				<strong>Order by</strong>
				<select name="ParamOrderBy" class="form">
					<cfloop index="ThisOrderBy" list="#StructKeyList(sOrderBy)#">
						<cfoutput><option value="#ThisOrderBy#" <cfif ParamOrderBy IS ThisOrderBy>selected</cfif>>#ThisOrderBy#</option></cfoutput>
					</cfloop>
				</select>
			</cfif>
			<strong>Show</strong>
			<select name="ParamCascade">
				<option value="0" <cfif ParamCascade IS "0">selected</cfif>>This page</option>
				<option value="1" <cfif ParamCascade IS "1">selected</cfif>>This page and its sub pages</option>
				<option value="2" <cfif ParamCascade IS "2">selected</cfif>>This whole section</option>
			</select>
			<input type="submit" value="Filter">
		</td>
		</TR>
		</form>
		<tr><td colspan="5">
			<div class="RuleDotted1"/>
		</td></tr>
		<TR>
			<td><strong>TITLE</strong></TD>
			<TD><strong>LAST UPDATED</strong></TD>
			<TD><strong>STATUS</strong></TD>
			<TD align="right"><a href="javascript:void(touchCheckboxes());"><img src="/common/images/admin/icon_checkbox.gif" border="0"></a></TD>
			<td align="right"><strong>ACTIONS</strong></td>
		</TR>
		<tr><td colspan="5">
			<div class="RuleSolid1"/>
		</td></tr>


		<cfif ATTRIBUTES.ObjectAction IS "SearchResults">
			<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="2">
			<cfloop index="ThisParam" list="ParamTitle,ParamStatusID,ParamOrderBy,ParamCascade">
				<cf_AddToQueryString queryString="#QueryString#" Name="#ThisParam#" value="#Evaluate(ThisParam)#">
			</cfloop>
			<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
			<cfset Counter="0">
			<cfset ShowUpdateButton="0">
			<cfset ShowDismissCheckbox="0">
			<cfif GetCategoryList.RecordCount IS NOT "0">
				<cfoutput query="GetFinal" MAXROWS="#SearchNUM#" STARTROW="#StartRow#">
					<cfquery name="GetThisPermissions" dbtype="query">
						select * from GetTopCategories
						Where CategoryID=#Val(CategoryID)#
						and pSaveLive=1
					</cfquery>
					<cfset Counter=IncrementValue(Counter)>
					<cfif CategoryID IS HighlightID>
						<tr valign="top">
					<cfelse>
						<tr valign="top">
					</cfif>
					<TD><span title="[ #CategoryID# ]">#CategoryName#</span></TD>
					<TD>
						by #TrackingFirstName# #TrackingMiddleName# #TrackingLastName# on #REQUEST.OutputDateTime(TrackingDateTime)#
					</TD>
					<TD nowrap>
					#sStatus[WorkflowStatusID]#
					</TD>
					<td align="right" nowrap>
					<cfinvoke component="/com/workflow/RequestHandler"
						method="OutstandingPublishRequest"
						returnVariable="qOutstandingPublishRequest"
						CategoryID="#CategoryID#">
					<cfif qOutstandingPublishRequest.RecordCount GT "0">
						<a title="#REQUEST.OutputDateTime(qOutstandingPublishRequest.WorkFlowRequestDateTime)# by #qOutstandingPublishRequest.FromFirstName# #qOutstandingPublishRequest.FromMiddleName# #qOutstandingPublishRequest.FromLastName#"><img src="/common/images/admin/icon_check.gif" border="0"/></a>
						<cfif GetThisPermissions.RecordCount GT "0">
							<cfset ShowDismissCheckbox="1">
						</cfif>
					</cfif>
					<cfif WorkflowStatusID IS "18001">
						<cfif GetThisPermissions.RecordCount GT "0">
							Publish? <input type="checkbox" name="SaveLive_#Counter#" value="1" <cfif qOutstandingPublishRequest.RecordCount IS "1">checked</cfif>>
						<cfelse>
							Request to Publish? <input type="checkbox" name="RequestSaveLive_#Counter#" value="1">
						</cfif>
					</cfif>
					<cfif WorkflowStatusID IS "18000" and GetThisPermissions.RecordCount GT "0">
						Re-Publish? <input type="checkbox" name="SaveLive_#Counter#" value="1">
					</cfif>
					</td>
					<input type="hidden" name="EditCategoryID#Counter#" value="#URLEncodedFormat(REQUEST.SimpleEncrypt(Val(CategoryID)))#">
					<input type="hidden" name="EditCategoryLocaleID#Counter#" value="#URLEncodedFormat(REQUEST.SimpleEncrypt(Val(CategoryLocaleID)))#">
					<TD nowrap align="right">
					<a href="/content.cfm/#CategoryAlias#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0"/></A>

					<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#EditPage#?#QueryString#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"/></A>

					<cf_AddToQueryString queryString="#RequestQueryString#" Name="cid" value="#REQUEST.SimpleEncrypt(Val(CategoryID))#">
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#RequestPage#?#QueryString#"><img src="/common/images/admin/icon_clipboard.gif" border="0"/></A>

					<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
					<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost#/content.cfm/#CategoryAlias#%0AEdit: #URLEncodedFormat('http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>

					<cfif ProductionDBDSN IS NOT "" and 0><br>
						<cfquery name="testlive" datasource="#ProductionDBDSN#">
							select CategoryActivePrime from qry_GetArticleStatus Where CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif testlive.RecordCount IS "0">
							Not visible on live site
						<cfelseif Val(testlive.CategoryActivePrime)>
							<a href="http://aboutjapan.japansociety.org/content.cfm/#CategoryAlias#" target="_blank">Visible on live site</A>
						<cfelse>
							Not visible on live site
						</cfif>
					</cfif></td></TR>
					<cfif Val(ParamCascade)>
						<cfmodule Template="/common/modules/utils/GetBranchFromRoot.cfm"
							ThisCategoryID="#CategoryID#"
							NameList=""
							IDList="#CategoryID#">
						<TR><TD colspan="5">
							<small>#ListChangeDelims(ListRest(NameList)," &gt; ")#</small>
						</TD></TR>
					</cfif>
					<tr><td colspan="5">
						<div class="RuleDotted1"/>
					</td></tr>
				</cfoutput>
				<cfoutput>
					<input type="hidden" name="NumItems" value="#Counter#">
					<TR>
					<TD colspan="5" align="right">
					<input type="submit" name="ButtonSubmit2" tabindex="#Counter#" class="Button" value="Publish">
					<cfif ShowDismissCheckbox>
						<br>
						Dismiss outstanding publish requests for selected pages? <input type="checkbox" name="DismissAll" value="1" checked>
					</cfif>
					</TD></form></tr>
				</cfoutput>
				<tr><td colspan="5">
					<div class="RuleDotted1"/>
				</td></tr>
				<tr><td colspan="5">
				<cf_AddToQueryString QueryString="#ThisPageQueryString#" name="mvmode" value="publish" OmitList="SearchNum,StartRow">
				<cf_AddToQueryString QueryString="#queryString#" name="mvcid" value="#ATTRIBUTES.CategoryID#">
				<cfmodule template="/common/modules/admin/pagination.cfm"
					StartRow="#StartRow#"
					SearchNum="#SearchNum#"
					RecordCount="#GetFinal.RecordCount#"
					FieldList="#QueryString#">
				</TD></tr>
				<tr><td colspan="5">
					<div class="RuleSolid1"/>
				</td></tr>
			<cfelse>
				<TR><TD colspan="5" align="center">No content found matching criteria.</TD></TR>
			</cfif>
		</cfif>
		</table>
	</cfdefaultcase>
</cfswitch>
<p>&nbsp;</p>