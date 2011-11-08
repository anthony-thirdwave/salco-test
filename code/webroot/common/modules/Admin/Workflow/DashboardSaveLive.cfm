<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.SCRIPT_NAME#?#CGI.Query_String#">
<cfparam name="ATTRIBUTES.EditAction" default="/common/admin/masterview/index.cfm?MVEid=1">
<cfparam name="ATTRIBUTES.RequestAction" default="/common/admin/workflow/request.cfm">
<cfparam name="ATTRIBUTES.ObjectAction" default="SearchResults">
<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="QuickSave" default="0">


<cfset QueryString="">
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

<!--- Pull production information --->
<cfinvoke component="#APPLICATION.MyCategoryHandler#"
	method="GetProductionSiteInformation"
	returnVariable="sProductionSiteInformation"
	CategoryID="#ATTRIBUTES.CategoryID#">
<cfif IsStruct(sProductionSiteInformation) and StructKeyExists(sProductionSiteInformation,"ProductionDBDSN") and sProductionSiteInformation["ProductionDBDSN"] IS NOT "">
	<cfset ProductionDBDSN=sProductionSiteInformation["ProductionDBDSN"]>
<cfelse>
	<cfset ProductionDBDSN="">
</cfif>

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
		<cfset lCategoryIDToPublish="">
		<cfloop index="i" from="1" to="#NumItems#" step="1">
			<cftry>
				<cfset ThisCategoryID=APPLICATION.utilsObj.SimpleDecrypt(URLDecode(FORM["EditCategoryID#i#"]))>
				<cfcatch>
					<cfset ThisCategoryID="-1">
				</cfcatch>
			</cftry>
			<cfparam name="FORM.SaveLive_#i#" default="0">
			<cfif ThisCategoryID GT "0">
				<cfif Evaluate("FORM.SaveLive_#i#")>
					<!--- Add this page to the list of pages to publish live --->
					<cfset lCategoryIDToPublish=ListAppend(lCategoryIDToPublish,ThisCategoryID)>
				</cfif>
			</cfif>
		</cfloop>

		<cfif APPLICATION.Staging>
			<cfif ProductionDBDSN IS NOT "">
				<cfinvoke component="#APPLICATION.MyCategoryHandler#"
					method="SavePages"
					returnVariable="bSuccess"
					UserID="#SESSION.AdminUserID#"
					LocaleID="#ATTRIBUTES.LocaleID#"
					lCategoryID="#lCategoryIDToPublish#"
					QuickSave="#Val(QuickSave)#">
			</cfif>
		<cfelse>
			<cfdump var="#lCategoryIDToPublish#">
		</cfif>
		<cfif IsDebugMode()>
			<cfabort>
		</cfif>
		<cf_AddToQueryString queryString="#FormQueryString#" name="mvca" value="1">
		<cflocation url="#FormPage#?#QueryString#" addToken="no">
	</cfcase>

	<cfdefaultcase>

		<cfquery name="GetCategoryList" datasource="#APPLICATION.DSN#">
			SELECT	qry_GetTrackingCategoryLatest.CategoryID, 
					DisplayOrder, CategoryAlias,
					qry_GetTrackingCategoryLatest.CategoryName,
					UserLogin, OperationName, OperationCode,
					TrackingDateTime, OperationID,
					FirstName as TrackingFirstName, MiddleName as TrackingMiddleName, LastName as TrackingLastName
			FROM	qry_GetTrackingCategoryLatest
					INNER JOIN
                    qry_GetCategoryPermission ON (qry_GetTrackingCategoryLatest.CategoryID = qry_GetCategoryPermission.CategoryID and qry_GetCategoryPermission.pSaveLive=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> and qry_GetCategoryPermission.UserGroupID IN (<cfqueryparam value="#Session.AdminUserGroupIDList#" cfsqltype="cf_sql_integer" list="yes">))
			WHERE
			OperationID <> <cfqueryparam value="503" cfsqltype="cf_sql_integer"> AND
			DisplayLevel <> <cfqueryparam value="0" cfsqltype="cf_sql_integer">
			ORDER BY DisplayOrder
		</cfquery>

		<cfset GetFinal=QueryNew(GetCategoryList.ColumnList)>
		<cfoutput query="GetCategoryList" group="CategoryID">
			<cfset QueryAddRow(GetFinal)>
			<cfloop index="ThisCol" list="#GetCategoryList.ColumnList#">
				<cfset QuerySetCell(GetFinal,ThisCol,GetCategoryList[ThisCol][GetCategoryList.currentrow])>
			</cfloop>
		</cfoutput>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="4">
			<div class="RuleDotted1"/>
		</td></tr>
		<TR>
			<td><strong>TITLE</strong></TD>
			<TD><strong>LAST UPDATED</strong></TD>
			<TD align="right"><a href="javascript:void(touchCheckboxes());"><img src="/common/images/admin/icon_checkbox.gif" border="0"></a></TD>
			<td align="right"><strong>ACTIONS</strong></td>
		</TR>
		<tr><td colspan="4">
			<div class="RuleSolid1"/>
		</td></tr>

		<cfif ATTRIBUTES.ObjectAction IS "SearchResults">
			<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="2">
			<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
			<cfset Counter="0">
			<cfset ShowUpdateButton="0">
			<cfset ShowDismissCheckbox="0">
			<cfif GetCategoryList.RecordCount IS NOT "0">
				<cfoutput query="GetFinal">
					<cfset Counter=IncrementValue(Counter)>
					<tr valign="top">
					<TD><span title="[ #CategoryID# ]">#CategoryName#</span></TD>
					<TD>#TrackingFirstName# #TrackingMiddleName# #TrackingLastName# on #APPLICATION.utilsObj.OutputDateTime(TrackingDateTime)#</TD>
					<td align="right" nowrap>
					Save Live? <input type="checkbox" name="SaveLive_#Counter#" value="1">
					</td>
					<input type="hidden" name="EditCategoryID#Counter#" value="#URLEncodedFormat(APPLICATION.utilsObj.SimpleEncrypt(Val(CategoryID)))#">
					<TD nowrap align="right">
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(getFinal.CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0"/></A>

					<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#EditPage#?#QueryString#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"/></A>

					<cf_AddToQueryString queryString="#RequestQueryString#" Name="cid" value="#APPLICATION.utilsObj.SimpleEncrypt(Val(CategoryID))#">
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#RequestPage#?#QueryString#"><img src="/common/images/admin/icon_clipboard.gif" border="0"/></A>

					<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
					<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#CGI.HTTP_Host##APPLICATION.utilsObj.parseCategoryUrl(getFinal.CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#CGI.HTTP_Host##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>

					<cfif ProductionDBDSN IS NOT "" and 0><br>
						<cfquery name="testlive" datasource="#ProductionDBDSN#">
							select CategoryActivePrime from qry_GetArticleStatus Where CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif testlive.RecordCount IS "0">
							Not visible on live site
						<cfelseif Val(testlive.CategoryActivePrime)>
							<a href="#APPLICATION.utilsObj.parseCategoryUrl(getFinal.CategoryAlias)#" target="_blank">Visible on live site</A>
						<cfelse>
							Not visible on live site
						</cfif>
					</cfif></td></TR>
					<cfmodule Template="/common/modules/utils/GetBranchFromRoot.cfm"
						ThisCategoryID="#CategoryID#"
						NameList=""
						IDList="#CategoryID#">
					<TR><TD colspan="4">
						<small>#ListChangeDelims(ListRest(NameList)," &gt; ")#</small>
					</TD></TR>
					<tr><td colspan="4">
						<div class="RuleDotted1"/>
					</td></tr>
				</cfoutput>
				<cfoutput>
					<input type="hidden" name="NumItems" value="#Counter#">
					<TR>
					<TD colspan="4" align="right">
					Save only page and product data only (faster)?<input type="checkbox" value="1" name="QuickSave"><br>
					<input type="submit" name="ButtonSubmit2" tabindex="#Counter#" class="Button" value="Save Live">
					</TD></form></tr>
				</cfoutput>
				<tr><td colspan="4">
					<div class="RuleSolid1"/>
				</td></tr>
			<cfelse>
				<TR><TD colspan="5" align="center">No pages need to be published.</TD></TR>
			</cfif>
		</cfif>
		</table>
	</cfdefaultcase>
</cfswitch>
<p>&nbsp;</p>