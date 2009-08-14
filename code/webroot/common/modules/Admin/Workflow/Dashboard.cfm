<cfparam name="ATTRIBUTES.SiteCategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#">
<cfparam name="ATTRIBUTES.EditAction" default="/common/admin/masterview/index.cfm?MVEid=1">
<cfparam name="ATTRIBUTES.RequestAction" default="/common/admin/workflow/request.cfm">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="ParamTitle" default="">
<cfparam name="ParamCategoryID" default="-1">
<cfparam name="ParamTypeID" default="-1">
<cfparam name="ParamStatusID" default="-1">
<cfparam name="ParamOrderBy" default="Last Updated">
<cfparam name="ShowOnlyCategoryTypeID" default="#APPLICATION.lVisibleCategoryTypeID#">

<cfparam name="SearchNum" default="10">
<cfif IsDefined("StartRow")>
	<CFSET StartRow = (StartRow + SearchNum)>
<cfelse>
	<CFSET StartRow = 1>
</cfif>



<cfset QueryString="">
<cfloop index="ThisParam" list="ParamTitle,ParamCategoryID,ParamTypeID,ParamStatusID,ParamOrderBy">
	<cf_AddToQueryString queryString="#QueryString#" Name="#ThisParam#" value="#Evaluate(ThisParam)#">
</cfloop>
<cf_AddToQueryString queryString="#QueryString#" Name="mvca" value="1">
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
	CategoryID="#ATTRIBUTES.SiteCategoryID#">
<cfif IsStruct(sProductionSiteInformation) and StructKeyExists(sProductionSiteInformation,"ProductionDBDSN") and sProductionSiteInformation["ProductionDBDSN"] IS NOT "">
	<cfset ProductionDBDSN=sProductionSiteInformation["ProductionDBDSN"]>
<cfelse>
	<cfset ProductionDBDSN="">
</cfif>

<!--- Query for domains of search options --->
<cfset sType=StructNew()>
<cfquery name="GetType" datasource="#APPLICATION.DSN#">
	SELECT		*
	FROM		t_label 
	WHERE		LabelGroupID = <cfqueryparam value="40" cfsqltype="cf_sql_integer">
	AND			LabelID IN (<cfqueryparam value="#ShowOnlyCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">)
	AND			LabelID != <cfqueryparam value="76" cfsqltype="cf_sql_integer"> <!--- Not in Journal --->
	ORDER BY	LabelName
</cfquery>
<cfoutput query="GetType">
	<cfset StructInsert(sType,LabelID,LabelName)>
</cfoutput>

<cfset sStatus=StructNew()>
<cfquery name="GetStatus" datasource="#APPLICATION.DSN#">
	SELECT		*
	FROM		t_label
	WHERE		LabelGroupID = <cfqueryparam value="18000" cfsqltype="cf_sql_integer">
	ORDER BY	LabelPriority
</cfquery>
<cfoutput query="GetStatus">
	<cfset StructInsert(sStatus,LabelID,LabelName)>
</cfoutput>

<cfquery name="GetSiteDO" datasource="#APPLICATION.DSN#">
	SELECT	DisplayOrder
	FROM	t_category
	WHERE	CategoryID = <cfqueryparam value="#ATTRIBUTES.SiteCategoryID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset sOrderBy=StructNew()>
<cfset StructInsert(sOrderBy,"Title","CategoryName")>
<cfset StructInsert(sOrderBy,"Type","CategoryTypeName")>
<cfset StructInsert(sOrderBy,"Status","StatusName")>
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
		<cftransaction>
			<cfloop index="i" from="1" to="#NumItems#" step="1">
				<cftry>
					<cfset ThisCategoryLocaleID=REQUEST.SimpleDecrypt(URLDecode(Evaluate("EditCategoryLocaleID#i#")))>
					<cfcatch>
						<cfset ThisCategoryLocaleID="-1">
					</cfcatch>
				</cftry>
				<cfparam name="WorkflowStatusID_#i#" default="0">
				<cfparam name="SaveLive_#i#" default="0">
				<cfif ThisCategoryLocaleID GT "0">
					<cfif Evaluate("SaveLive_#i#")>
						<cfset lCategoryLocaleIDToPublish=ListAppend(lCategoryLocaleIDToPublish,ThisCategoryLocaleID)>
						<!--- <cfset SetVariable("WorkflowStatusID_#i#",18000)> --->
					</cfif>
					<cfif Evaluate("WorkflowStatusID_#i#") GT "0">
						<cfquery name="UpdateWorkflowStatusID" datasource="#APPLICATION.DSN#">
							UPDATE	t_CategoryLocale
							SET		WorkflowStatusID = <cfqueryparam value="#Evaluate('WorkflowStatusID_#i#')#" cfsqltype="cf_sql_integer">
							WHERE	CategoryLocaleID = <cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
					<cfif Evaluate("WorkflowStatusID_#i#") IS "18002"><!--- If article is changed to archive --->
						<!--- Mark it on live too --->
						<cfset lCategoryLocaleIDToDeactivate=ListAppend(lCategoryLocaleIDToDeactivate,ThisCategoryLocaleID)>
					</cfif>

				</cfif>
			</cfloop>
		</cftransaction>

		<cfif Val(APPLICATION.Staging)>
			<cfinvoke component="/com/ContentManager/CategoryHandler"
				method="GetProductionSiteInformation"
				returnVariable="sProductionSiteInformation"
				CategoryID="#Val(ATTRIBUTES.SiteCategoryID)#">
			<cfif IsStruct(sProductionSiteInformation)>
				<cftransaction>
					<cfloop index="ThisCategoryLocaleID" list="#lCategoryLocaleIDToDeactivate#">
						<cfquery name="UpdateWorkflowStatusID" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							UPDATE	t_CategoryLocale 
							SET		WorkflowStatusID = <cfqueryparam value="18002" cfsqltype="cf_sql_integer">,
									CategoryLocaleActive = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
							WHERE	CategoryLocaleID = <cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfloop>
				</cftransaction>

				<cfset lCategoryIDToSave="">
				<cfloop index="ThisCategoryLocaleID" list="#lCategoryLocaleIDToPublish#">
					<cfquery name="GetCategoryID" datasource="#APPLICATION.DSN#">
						SELECT	CategoryID
						FROM	t_CategoryLocale
						WHERE	CategoryLocaleID = <cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset lCategoryIDToSave=ListAppend(lCategoryIDToSave,GetCategoryID.CategoryID)>
				</cfloop>
				<cfinvoke component="/com/ContentManager/CategoryHandler"
					method="SavePages"
					returnVariable="bSuccess"
					UserID="#SESSION.UserID#"
					LocaleID="#ATTRIBUTES.LocaleID#"
					lCategoryID="#lCategoryIDToSave#">
			</cfif>
		<cfelse>
			<cfdump var="#lCategoryLocaleIDToDeactivate#">
			<cfdump var="#lCategoryLocaleIDToPublish#">
		</cfif>
		<cf_AddToQueryString queryString="#FormQueryString#" name="mvca" value="1">
		<cflocation url="#FormPage#?#QueryString#" addToken="no">
	</cfcase>

	<cfdefaultcase>

		<cfquery name="GetTopCategories1" datasource="#APPLICATION.DSN#">
			SELECT CategoryName,DisplayLevel,DisplayOrder,CategoryID,pEdit,pSaveLive,UserGroupid
			FROM qry_GetCategoryPermission
			WHERE
			UserGroupID IN (<cfqueryparam value="#Session.AdminUserGroupIDList#" cfsqltype="cf_sql_integer" list="yes">)
			and PEdit=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			and CategoryTypeID IN (<cfqueryparam value="60,66" cfsqltype="cf_sql_integer" list="yes">)<!--- Content and Article --->
			and DisplayOrder like <cfqueryparam value="#GetSiteDO.DisplayOrder#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset lCategoryIDPermission=ValueList(GetTopCategories1.CategoryID)>

		<cfif lCategoryIDPermission IS "">
			<cfset lCategoryIDPermission="-1">
		</cfif>

		<cfset GetTopCategories3 = QueryNew("CategoryName,DisplayLevel,DisplayOrder,CategoryID,pSaveLive")>
		<cfoutput query="GetTopCategories1">
			<cfset QueryAddRow(GetTopCategories3)>
			<cfset QuerySetCell(GetTopCategories3,"CategoryName",CategoryName)>
			<cfset QuerySetCell(GetTopCategories3,"DisplayLevel",DisplayLevel)>
			<cfset QuerySetCell(GetTopCategories3,"DisplayOrder",DisplayOrder)>
			<cfset QuerySetCell(GetTopCategories3,"CategoryID",CategoryID)>
			<cfset QuerySetCell(GetTopCategories3,"pSaveLive",pSaveLive)>
		</cfoutput>
		
		<Cfquery name="GetTopCategories" dbtype="query">
			SELECT * FROM GetTopCategories3 order by DisplayORder
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
			SELECT		*
			FROM		qry_GetWorkFlow
			WHERE
			LocaleID = <cfqueryparam value="#Val(ATTRIBUTES.LocaleID)#" cfsqltype="cf_sql_integer"> and
			<cfif ParamCategoryID GT "0">
				(ParentID IN (<cfqueryparam value="#ParamCategoryID#" cfsqltype="cf_sql_integer" list="yes">) ) and
			</cfif>
			CategoryTypeID IN (<cfqueryparam value="#ShowOnlyCategoryTypeID#" cfsqltype="cf_sql_integer" list="yes">)
			<cfif ParamTitle IS NOT "">
				and CategoryName like <cfqueryparam value="%#ParamTitle#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif Val(ParamTypeID) GT "0">
				and CategoryTypeID = <cfqueryparam value="#Val(ParamTypeID)#" cfsqltype="cf_sql_integer">
			</cfif>
			and ParentID IN (<cfqueryparam value="#lCategoryIDPermission#" cfsqltype="cf_sql_integer" list="yes">)
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
		<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="1" OmitList="ParamTitle,ParamCategoryID,ParamTypeID,ParamStatusID,ParamOrderBy">
		<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
		<TR>
		<TD class="bordertop2" colspan="4"><strong>Location</strong>
		<select name="ParamCategoryID" class="form">
			<option value="-1">All</option>
			<cfoutput query="GetTopCategories" group="CategoryID">
				<cfif CategoryName IS NOT "">
					<option value="#CategoryID#" <cfif ParamCategoryID IS CategoryID>selected</cfif>><cfloop index="i" from="1" to="#Val(DisplayLevel)#" step="1">&nbsp;&nbsp;&nbsp;</cfloop>#CategoryName#</option>
				</cfif>
			</cfoutput>
		</select>
		</TD>
		<td class="bordertop2" align="right">
			<strong>Order by</strong>
			<select name="ParamOrderBy" class="form">
				<cfloop index="ThisOrderBy" list="#StructKeyList(sOrderBy)#">
					<cfoutput><option value="#ThisOrderBy#" <cfif ParamOrderBy IS ThisOrderBy>selected</cfif>>#ThisOrderBy#</option></cfoutput>
				</cfloop>
			</select>
		</td>
		</TR>
		<tr><td colspan="5">
			<div class="RuleDotted1"/>
		</td></tr>
		<TR>
			<td><strong>TITLE</strong></TD>
			<TD><strong>TYPE</strong></TD>
			<TD><strong>STATUS</strong></TD>
			<TD><strong>LAST UPDATED</strong></TD>
			<TD><strong>ACTIONS</strong></TD>
		</TR>
		<TR>
		<cfoutput><td class="borderbottom2"><input type="text" class="text" value="#ParamTitle#" name="ParamTitle" style="width:80px;"></TD></cfoutput>
		<TD class="borderbottom2">
		<select name="ParamTypeID" class="form">
			<option value="-1">All</option>
			<cfoutput query="GetType">
				<option value="#LabelID#" <cfif ParamTypeID IS LabelID>selected</cfif>>#LabelName#</option>
			</cfoutput>
		</select>
		</TD>
		<TD class="borderbottom2">
		<select name="ParamStatusID" class="form">
			<option value="-1">All</option>
			<cfoutput query="GetStatus">
				<option value="#LabelID#" <cfif ParamStatusID IS LabelID>selected</cfif>>#LabelName#</option>
			</cfoutput>
		</select>
		</TD>
		<TD class="borderbottom2">
		
		</TD>
		<TD align="right" class="borderbottom2"><input type="submit" value="Filter"></TD>
		</TR>
		<tr><td colspan="5">
			<div class="RuleSolid1"/>
		</td></tr>
		</form>

		<cfif ATTRIBUTES.ObjectAction IS "SearchResults">
			<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="2">
			<cfloop index="ThisParam" list="ParamTitle,ParamCategoryID,ParamTypeID,ParamStatusID,ParamOrderBy">
				<cf_AddToQueryString queryString="#QueryString#" Name="#ThisParam#" value="#Evaluate(ThisParam)#">
			</cfloop>
			<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
			<cfset Counter="0">
			<cfset ShowUpdateButton="0">
			<cfif GetCategoryList.RecordCount IS NOT "0">
				<cfoutput query="GetFinal" MAXROWS="#SearchNUM#" STARTROW="#StartRow#">
					<cfquery name="GetThisPermissions" dbtype="query">
						SELECT	*
						FROM	GetTopCategories
						WHERE	CategoryID = <cfqueryparam value="#Val(ParentID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset Counter=IncrementValue(Counter)>
					<cfif CategoryID IS HighlightID>
						<tr valign="top">
					<cfelse>
						<tr valign="top">
					</cfif>
					<TD><span title="[ #CategoryID# ]">#CategoryName#</span></TD>
					<TD>#sType[CategoryTypeID]#</TD>
					<TD nowrap>
					<cfif GetThisPermissions.RecordCount GT "0" and Val(GetThisPermissions.pSaveLive)>
						<select name="WorkflowStatusID_#Counter#">
							<cfset ThisWorkflowStatusID="#WorkflowStatusID#">
							<cfloop query="GetStatus">
								<option value="#LabelID#" <cfif GetStatus.LabelID IS ThisWorkflowStatusID>selected</cfif>>#GetStatus.LabelName#</option>
							</cfloop>
						</select><br>
						<cfif WorkflowStatusID IS "18001">
							<nobr>Save Live? <input type="checkbox" name="SaveLive_#Counter#" value="1"></nobr>
						</cfif>
						<cfset ShowUpdateButton="1">
					<cfelse>
						#sStatus[WorkflowStatusID]#
					</cfif>
					</TD>
					<TD>
						by #UserLogin# on #REQUEST.OutputDateTime(TrackingDateTime)#
					</TD>
					
					<input type="hidden" name="EditCategoryLocaleID#Counter#" value="#URLEncodedFormat(REQUEST.SimpleEncrypt(Val(CategoryLocaleID)))#">

					<TD nowrap align="right">
					<a href="/content.cfm/#CategoryAlias#" target="_blank">View</A>
					<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#EditPage#?#QueryString#">Edit</A>
					<cf_AddToQueryString queryString="#RequestQueryString#" Name="cid" value="#REQUEST.SimpleEncrypt(Val(CategoryID))#">
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#RequestPage#?#QueryString#">Send Request</A><cfif ProductionDBDSN IS NOT ""><br>
						<cfquery name="testlive" datasource="#ProductionDBDSN#">
							SELECT	CategoryActivePrime 
							FROM	qry_GetArticleStatus 
							WHERE	CategoryID = <cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif testlive.RecordCount IS "0">
							Not visible on live site
						<cfelseif Val(testlive.CategoryActivePrime)>
							<a href="http://aboutjapan.japansociety.org/content.cfm/#CategoryAlias#" target="_blank">Visible on live site</A>
						<cfelse>
							Not visible on live site
						</cfif>
					</cfif></td></TR>
					<TR><TD class="small borderbottom1"></TD><TD colspan="4" class="small borderbottom1">
					Location: #ParentCategoryName#</TD></TR>
					<tr><td colspan="8">
						<div class="RuleDotted1"/>
					</td></tr>
				</cfoutput>
				<tr><td colspan="8">
				<cf_AddToQueryString QueryString="#ThisPageQueryString#" name="1" value="1" OmitList="SearchNum,StartRow">
				<cfmodule template="/common/modules/admin/pagination.cfm" 
					StartRow="#StartRow#" 
					SearchNum="#SearchNum#" 
					RecordCount="#GetFinal.RecordCount#" 
					FieldList="#QueryString#">
				</TD></tr>
				<tr><td colspan="8">
						<div class="RuleSolid1"/>
					</td></tr>
				<cfif ShowUpdateButton>
					<cfoutput>
						<input type="hidden" name="NumItems" value="#Counter#">
						<TR>
						<TD colspan="1"></TD>
						<TD colspan="3" align="right">
						<input type="submit" name="ButtonSubmit2" tabindex="#Counter#" value="Update">
						</TD></form>
						<TD>&nbsp;</TD></tr>
					</cfoutput>
				</cfif>
			<cfelse>
				<TR><TD colspan="5" align="center">No content found matching criteria.</TD></TR>
			</cfif>
		</cfif>
		</table>
	</cfdefaultcase>
</cfswitch>
<p>&nbsp;</p>