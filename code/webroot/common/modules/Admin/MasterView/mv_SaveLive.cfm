<cfparam name="ATTRIBUTES.FormAction" default="#CGI.SCRIPT_NAME#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="ATTRIBUTES.sCurrentCategoryPermissions">

<!--- Default the Display All Sub-Categories option to false --->
<cfparam name="dasc" default="0">

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>

<!--- Let's check if the top level category is a website, else all is for naught --->
<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" ThisCategoryID="#ATTRIBUTES.CurrentCategoryID#" NameList="" IDList="#ATTRIBUTES.CurrentCategoryID#">

<cfinvoke component="com.ContentManager.CategoryHandler" 
	method="GetProductionSiteInformation"
	returnVariable="sProductionSiteInformation"
	CategoryID="#Val(ListFirst(ListRest(IDList)))#">

<cfif IsStruct(sProductionSiteInformation)>
	<cfif Isdefined("URL.mvsla")>
		<cfswitch expression="#URL.mvsla#">
			<cfcase value="2">
				<cfset ATTRIBUTES.ObjectAction="SaveLive">
			</cfcase>
			<cfcase value="3">
				<cfset ATTRIBUTES.ObjectAction="ToggleActive">
			</cfcase>
		</cfswitch>
	</cfif>
	<cfif ATTRIBUTES.ObjectAction IS "SaveLive">
		
		<cfset lCategoryID="">
		<cfloop index="i" from="1" to="#NumItems#" step="1">
			<cfif IsDefined("FORM.Object#i#")>
				<cfset ObjectID="#Decrypt(URLDecode(ListLast(Evaluate('Object#i#'),'|')),APPLICATION.Key)#">
				<cfset lCategoryID=ListAppend(lCategoryID,ObjectID)>
			</cfif>
		</cfloop>
		<cfset StartTickCount=GetTickCount()>
		<cfloop index="ThisCategoryID" list="#lCategoryID#">
			<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
			<cfset MyCategory.Constructor(Val(ThisCategoryID))>
			<cfset MyCategory.SaveToProduction(APPLICATION.WebrootPath,Val(SESSION.AdminUserID))>
			<cfoutput>saved #ThisCategoryID# category: #GetTickCount()-StartTickCount#<BR></cfoutput>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="GetCategoryLocaleID" returnVariable="CategoryLocaleID"
				CategoryID="#ThisCategoryID#"
				LocaleID="#SESSION.AdminCurrentAdminLocaleID#">
			<cfif Val(CategoryLocaleID) GT "0">
				<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
				<cfset MyCategoryLocale.Constructor(Val(CategoryLocaleID))>
				<cfset MyCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,Val(SESSION.AdminUserID))>
				saved #ThisCategoryID# category locale: #GetTickCount()-StartTickCount#<BR>
			</cfif>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="GetContentAndContentLocale" returnVariable="qContent"
				CategoryID="#ThisCategoryID#"
				LocaleID="#SESSION.AdminCurrentAdminLocaleID#">
			<cfif qContent.RecordCount GT "0">
				<cfoutput query="qContent" group="ContentID">
					<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
					<cfset MyContent.Constructor(Val(ContentID))>
					<cfset MyContent.SaveToProduction(APPLICATION.WebrootPath,Val(SESSION.AdminUserID))>
					saved #ContentID# content #GetTickCount()-StartTickCount#<BR>
					<cfoutput group="ContentLocaleID">
						<cfset MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
						<cfset MyContentLocale.Constructor(Val(ContentLocaleID))>
						<cfset MyContentLocale.SaveToProduction(APPLICATION.WebrootPath,Val(SESSION.AdminUserID))>
						saved #ContentLocaleID# content locale #GetTickCount()-StartTickCount#<BR>
					</cfoutput>
				</cfoutput>
			</cfif>
			<cfinvoke component="com.ContentManager.CategoryHandler"
				method="GetProductionSiteInformation"
				returnVariable="sProductionSiteInformation"
				CategoryID="#ThisCategoryID#">
			<cfinvoke component="com.ContentManager.CategoryHandler"
				method="UpdateCacheDateTime"
				returnVariable="success"
				Lookup="Category"
				KeyID="#thisCategoryID#"
				datasource="#sProductionSiteInformation.ProductionDBDSN#">
			<cfif IsDebugMode()>
				<cfflush>
			</cfif>
		</cfloop>
		
		<cfif IsDebugMode()>
			<cfabort>
		</cfif>
		<cf_AddToQueryString queryString="#FormQueryString#" OmitList="mvsla">
		<cflocation url="#FormPage#?#QueryString#" addToken="no">
	<cfelseif ATTRIBUTES.ObjectAction IS "ToggleActive">
		<cfparam name="Object" default="">
		<cfparam name="oid" default="">
		<cfif object IS NOT "" AND oid IS NOT "">
			<cfset ThisObjectID=Decrypt(oid,APPLICATION.Key)>
			<cfif ThisObjectID GT "0">
				<cfif Object IS "Content">
					<cfquery name="GetContentFromProduction1" datasource="#ProductionDSN#">
						SELECT	ContentActive
						FROM	t_Content
						WHERE	ContentID = <cfqueryparam value="#ThisObjectID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif GetContentFromProduction1.ContentActive>
						<cfset NewVal2=0>
					<cfelse>
						<cfset NewVal2=1>
					</cfif>
					<cfquery name="UpdateContentOnProduction1" datasource="#ProductionDSN#">
						UPDATE	t_Content
						SET		ContentActive = <cfqueryparam value="#NewVal2#" cfsqltype="cf_sql_bit">
						WHERE	ContentID=<cfqueryparam value="#ThisObjectID#" cfsqltype="cf_sql_integer">
					</cfquery>
				<cfelseif Object IS "Category">
					<cfquery name="GetContentFromStaging1" datasource="#ProductionDSN#">
						SELECT	CategoryActive
						FROM	t_Category
						WHERE	CategoryID = <cfqueryparam value="#ThisObjectID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif GetContentFromStaging1.CategoryActive>
						<cfset NewVal=0>
					<cfelse>
						<cfset NewVal=1>
					</cfif>
					<cfquery name="UpdateContentOnStaging1" datasource="#ProductionDSN#">
						UPDATE	t_Category
						SET		CategoryActive = <cfqueryparam value="#NewVal#" cfsqltype="cf_sql_bit">
						WHERE	CategoryID=<cfqueryparam value="#ThisObjectID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<!--- Originally, this went through all children, but for UIMC, no. --->
				</cfif>
			</cfif>
		</cfif>
		<cf_AddToQueryString queryString="#FormQueryString#" OmitList="mvsla">
		<cflocation url="#FormPage#?#QueryString#" addToken="no">
	<cfelse>
		<table width="100%" border="0">
		<cf_AddToQueryString queryString="#FormQueryString#" Name="mvsla" value="2">
		<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
		<cfset Counter="1">
		
		<cfif dasc EQ 1>
			<CF_getbranch item="#ATTRIBUTES.CurrentCategoryID#" DataSource="#APPLICATION.DSN#" 
				table="t_Category" Column="CategoryID" ParentColumn="ParentID">
			<cfset myBranch = branch>
		<cfelse>
			<cfset myBranch = ATTRIBUTES.CurrentCategoryID>
		</cfif>

		<cfquery name="GetMinDisplayLevel" datasource="#Application.DSN#">
			SELECT	Min(DisplayLevel) AS MinDisplayLevel
			FROM	qry_GetCategory
			WHERE	CategoryID IN (<cfqueryparam value="#myBranch#" cfsqltype="cf_sql_integer" list="yes">)
		</cfquery>
				
		<cfquery name="GetAllCategories" datasource="#Application.DSN#">
			SELECT	*,(displayLevel-#GetMinDisplayLevel.MinDisplayLevel#) AS indent
			FROM	qry_GetCategory
			WHERE	CategoryID IN (<cfqueryparam value="#myBranch#" cfsqltype="cf_sql_integer" list="yes">) order by displayorder
		</cfquery>
		
		<cfquery name="GetMaxDisplayLevel" dbtype="query">
			SELECT	Max(indent) AS MaxDisplayLevel
			FROM	GetAllCategories
		</cfquery>
		
		<cfset MaxDisplayLevel=IncrementValue(GetMaxDisplayLevel.MaxDisplayLevel)>
		
		<cfoutput>
			<TR bgcolor="bac0c9">
				<TD colspan="#MaxDisplayLevel+4#">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								FTP Host: #sProductionSiteInformation.ProductionFTPHost#<br>
								Production DSN: #sProductionSiteInformation.ProductionDBServer# 
							</td>
							<td align="right">
								<br>
								<cfif dasc NEQ 1>
									<cfmodule template="/common/modules/utils/addtoquerystring.cfm" QueryString="#cgi.QUERY_STRING#" varname="dasc" Value="1">
									<a href="#CGI.SCRIPT_NAME#?#QueryString#">display all sub-pages</a>
								<cfelse>
									<cfmodule template="/common/modules/utils/addtoquerystring.cfm" QueryString="#cgi.QUERY_STRING#" varname="dasc" Value="0">
									<a href="#CGI.SCRIPT_NAME#?#QueryString#">display only this page</a>		
								</cfif>
							</td>
						</tr>
					</table>
				</td>
			</TR>
			<TR  bgcolor="bac0c9">
				<TD bgcolor="bac0c9" colspan="#IncrementValue(MaxDisplayLevel)#"></TD>
				<TD bgcolor="bac0c9"><b>Active</b></TD>
				<TD bgcolor="bac0c9"><b>Last Updated</b></tD>
				<TD bgcolor="bac0c9"><b>Save?</b></TD>
			</TR>
		</cfoutput>
		<cfoutput query="GetAllCategories" group="CategoryID">
			<tr valign="top">
			<!--- Create the Indents --->
			<cfloop index="i" from="1" to="#indent#" step="1"><TD width="10"><img src="/common/images/spacer.gif" width="10" height="1"></TD></cfloop>
			<cfset ThisNum=(MaxDisplayLevel-Indent)>
			<TD bgcolor="bac0c9" colspan="#IncrementValue(ThisNum)#"><b>#CategoryName#</b> <img src="/common/images/ContentManager/icon_Category.gif" border="0"><BR><small>(#CategoryID# | #CategoryAlias#)</TD>
			<TD bgcolor="bac0c9" align="center">#YesNoFormat(CategoryActive)#</TD>
			<TD bgcolor="bac0c9">
			<table border="0" width="100%" cellspacing="0" cellpadding="0"><tr valign="top"><TD><small>last updated:</small></TD><TD nowrap>
			<small>#APPLICATION.utilsObj.OutputDateTime(CacheDateTime)#</small></TD></TR>
			<TR valign="top"><TD nowrap><Small>last saved live:</small></TD><TD nowrap>
			<cfinvoke component="com.utils.tracking" method="GetTrackingDate" returnVariable="SaveLiveDate"
				Entity="Category"
				KeyID="#CategoryID#"
				Operation="savelive"><cfif IsDate(SaveLiveDate)><small>#APPLICATION.utilsObj.OutputDateTime(SaveLiveDate)#</small></cfif>
			<cfset ShouldSave="Yes">
			<cfif IsDate(SaveLiveDate) and dateCompare(SaveLiveDate,CacheDateTime) GTE "0">
				<cfset ShouldSave="No">
			</cfif>
			<!--- <cfquery name="GetThisContent_Production" datasource="#ProductionDSN#" maxrows="1">
				SELECT  CategoryActive  
				FROM t_Category WHERE CategoryID=#Val(CategoryID)#
			</cfquery>
			<cfif GetThisContent_Production.RecordCount IS not "0">
				<cf_AddToQueryString queryString="#FormQueryString#" Name="mvsla" value="3">
				<cf_AddToQueryString queryString="#queryString#" Name="object" value="Category">
				<cf_AddToQueryString queryString="#queryString#" Name="oid" value="#Encrypt(CategoryID,APPLICATION.Key)#">
				<BR><a href="#FormPage#?#QueryString#"><small><cfif Val(GetThisContent_Production.CategoryActive)>Turn off active flag<Cfelse>Set active flag</cfif> on production</A>
			</cfif> --->
			</tD></TR></table></TD>
			
			<TD bgcolor="bac0c9"><input type="checkbox" name="Object#Counter#" <cfif ShouldSave>checked</cfif> value="#URLEncodedFormat(Encrypt(CategoryID,APPLICATION.Key))#"></tD></TR>
			<cfset Counter=Counter+1>
		</cfoutput>
		<cfoutput>
			<TR>
			<td colspan="#MaxDisplayLevel+4#" align="right" bgcolor="FFFFFF">
			<cfmodule template="/common/modules/utils/safeSubmit.cfm"
				buttonText1="Save"
				buttonText2="Saving...">
			<input type="hidden" name="NumItems" value="#DecrementValue(Counter)#">
			</td></form></tr>
		</cfoutput>
		</table>
	</cfif>
<cfelse>
	<p align="center"><b>No production website defined for this category!</b></p>
</cfif>