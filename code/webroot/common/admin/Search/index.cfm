<cfif IsDefined("URL.newSearch")>
		
	<cfquery name="getResults" datasource="#APPLICATION.DSN#">
		SELECT DISTINCT c.CategoryID, c.CategoryName, c.CategoryAlias, c.cacheDateTime AS LastUpdated
		FROM t_Category c
		<cfswitch expression="#URL.searchBy#">
			<cfcase value="title">
			WHERE c.CategoryName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URL.searchText#%">
			</cfcase>
			<cfcase value="alias">
			WHERE c.CategoryAlias LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URL.searchText#%">
			</cfcase>
			<cfcase value="content">
			INNER JOIN t_Content cn ON c.CategoryID = cn.CategoryID
			LEFT OUTER JOIN t_ContentLocale clDefault ON (clDefault.ContentID = cn.ContentID AND clDefault.DefaultContentLocale = 1)
			LEFT OUTER JOIN t_ContentLocale clCurrent ON (clCurrent.ContentID = cn.ContentID AND clCurrent.LocaleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AdminCurrentAdminLocaleID#"> AND clCurrent.DefaultContentLocale <> 1)
			WHERE (clDefault.ContentBody LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URL.searchText#%"> OR clCurrent.ContentBody LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URL.searchText#%">)
			</cfcase>
		</cfswitch>
	
	</cfquery>
	
	<cflock scope="session" type="exclusive" timeout="5">
		<cfset SESSION.sGlobalSearch.qSearchResults = getResults>
		<cfset SESSION.sGlobalSearch.searchBy = URL.searchBy>
		<cfset SESSION.sGlobalSearch.searchText = URL.searchText>
		<cfset SESSION.sGlobalSearch.resultsPerPage = 10>
	</cflock>

</cfif>

<cfparam name="qTheseResults" default="">
<cfparam name="thisSearchBy" default="content">
<cfparam name="thisSearchText" default="">
<cfparam name="thisSortBy" default="title">
<cfparam name="thisSortOrder" default="asc">
<cfparam name="thisPageNum" default="1">
<cfparam name="thisPageTitle" default="Global Search">

<cfif IsDefined("URL.SortBy")>
	<cfset thisSortBy = URL.SortBy>
</cfif>
<cfif IsDefined("URL.SortOrder")>
	<cfset thisSortOrder = URL.SortOrder>
</cfif>
<cfif IsDefined("URL.pnum")>
	<cfset thisPageNum = URL.pnum>
</cfif>

<cfif IsDefined("newResultNum")>
	<cflock scope="session" type="exclusive" timeout="5">
		<cfset SESSION.sGlobalSearch.resultsPerPage = Val(newResultNum)>
	</cflock>
</cfif>

<cfif IsDefined("SESSION.sGlobalSearch")>
	<cflock scope="session" type="exclusive" timeout="5">
		<cfset qTheseResults = SESSION.sGlobalSearch.qSearchResults>
		<cfset thisSearchBy = SESSION.sGlobalSearch.searchBy>
		<cfset thisSearchText = SESSION.sGlobalSearch.searchText>
		<cfset thisResultsPerPage = SESSION.sGlobalSearch.resultsPerPage>
	</cflock>
	<cfset thisPageTitle = "Search: #qTheseResults.RecordCount# Matches for ""#thisSearchText#""">
</cfif>

<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="#thisPageTitle#"
	PageHeader="<a href=""/common/admin/"" class=""white"">Main Menu</A> | Search">

<!--- search results are stored in session, only reset when new search is defined --->

<div class="dashModuleWide">
<div class="box2 ieAdjWidthBox2">
<div class="boxtop2"><div></div></div>
<div class="ModuleTitle2 ieAdjRightMargin" style="border-bottom:1px solid #97AEB8; ">Search Results</div>
<div class="ModuleBody2">

<script language="javascript">
function valNewSearch(thisForm){
	if(document.getElementById('globalSearchForm').searchBy[document.getElementById('globalSearchForm').searchBy.selectedIndex].value == ""){
		alert("Please select a 'search by' option.");
		return false;
	}	
	else
		return true;
}
</script>
<div style="padding-left:20px; padding-right:20px;">
<table width="100%" cellpadding="2" cellspacing="0" border="0" bgcolor="#FFFFFF">
<cfoutput>
	<form action="#CGI.REQUEST_URI#" method="get" id="globalSearchForm" onSubmit="return valNewSearch();">
	<input name="newSearch" value="1" type="hidden">
	<tr bgcolor="##666666" height="50" valign="middle">
		<td colspan="4">
			<span style="font-weight:bold; color:##FFFFFF">Search</span>
			&nbsp;
			<select name="searchBy" style="width:150px;">
				<option value="">By</option>
				<option value="title"<cfif thisSearchBy EQ "title"> selected</cfif>>Page Title</option>
				<option value="alias"<cfif thisSearchBy EQ "alias"> selected</cfif>>Alias</option>
				<option value="content"<cfif thisSearchBy EQ "content"> selected</cfif>>Content</option>
			</select>
			&nbsp;
			<input type="text" style="width:400px;" maxlength="255" name="searchText" value="#thisSearchText#">
			&nbsp;
			<input class="adminSearchSubmitBut" type="image" src="/common/images/admin/button_search.gif" border="0" style="">
		</td>
	</tr>
	</form>
</cfoutput>
<cfif IsQuery(qTheseResults)>
	<cfif thisSortBy EQ "title" AND thisSortOrder EQ "asc"><cfset titleOrder = "desc"><cfelse><cfset titleOrder = "asc"></cfif>
	<cfif thisSortBy EQ "alias" AND thisSortOrder EQ "asc"><cfset aliasOrder = "desc"><cfelse><cfset aliasOrder = "asc"></cfif>
	<cfif thisSortBy EQ "date" AND thisSortOrder EQ "asc"><cfset dateOrder = "desc"><cfelse><cfset dateOrder = "asc"></cfif>
	<cfset uparrow = "<img src=""/common/images/green_arrow_up.gif"" border=""0"">">
	<cfset downarrow = "<img src=""/common/images/green_arrow_down.gif"" border=""0"">">
	<cfoutput>
	<tr style="background-color:##FFFFFF; font-weight:bold; height:30px;">
		<td colspan="4" style=" border-bottom:1px dashed ##999999;" align="left">&nbsp;</td>
	</tr>
	<tr style="background-color:##FFFFCC; font-weight:bold; height:30px;">
		<td><a href="?sortBy=title&sortOrder=#titleOrder#">Page Title</a>&nbsp;&nbsp;<cfif thisSortBy EQ "title"><cfif thisSortOrder EQ "desc">#uparrow#<cfelse>#downarrow#</cfif></cfif></td>
		<td><a href="?sortBy=alias&sortOrder=#aliasOrder#">Alias</a>&nbsp;&nbsp;<cfif thisSortBy EQ "alias"><cfif thisSortOrder EQ "desc">#uparrow#<cfelse>#downarrow#</cfif></cfif></td>
		<td><a href="?sortBy=date&sortOrder=#dateOrder#">Last Updated</a>&nbsp;&nbsp;<cfif thisSortBy EQ "date"><cfif thisSortOrder EQ "desc">#uparrow#<cfelse>#downarrow#</cfif></cfif></td>
		<td align="right">Action</td>
	</tr>
	<tr><td colspan="4" style=" border-top:1px solid ##999999;"><img src="/common/images/spacer.gif" height="1" width="1" border="0"/></td></tr>
	</cfoutput>
	<cfif qTheseResults.RecordCount GT 0>
		<cfquery name="getTheseResults" dbtype="query">
			SELECT * FROM qTheseResults
			ORDER BY 
				<cfswitch expression="#thisSortBy#">
					<cfcase value="title">
					CategoryName
					</cfcase>
					<cfcase value="alias">
					CategoryAlias
					</cfcase>
					<cfcase value="date">
					LastUpdated
					</cfcase>
					<cfdefaultcase>
					CategoryName
					</cfdefaultcase>
				</cfswitch>
				<cfif thisSortOrder EQ "desc"> DESC<cfelse> ASC</cfif>
		</cfquery>
		<cfset thisStartRow = ((thisPageNum-1)*thisResultsPerPage) + 1>
		<cfset counter = 0>
		<cfoutput query="getTheseResults" maxrows="#thisResultsPerPage#" startrow="#thisStartRow#">
			<cfset counter = counter+1>
			<cfif CurrentRow NEQ getTheseResults.RecordCount AND counter NEQ thisResultsPerPage><cfset showDashes = 1><cfelse><cfset showDashes = 0></cfif>
			<tr>
				<td width="29%"><a style="font-weight:bold;" href="/common/admin/masterview/index.cfm?&mvcid=#CategoryID#">#CategoryName#</a></td>
				<td width="29%">#CategoryAlias#</td>
				<td width="29%">#APPLICATION.utilsObj.OutputDateTime(LastUpdated)#</td>
				<td align="right" width="13%">
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" hspace="2" border="0"/></a>
					<a href="/common/admin/masterview/index.cfm?&mvcid=#CategoryID#" title="Edit"><img src="/common/images/admin/icon_edit.gif" hspace="2" border="0"/></a>
				</td>
			</tr>
			<cfif showDashes><tr><td colspan="4" style="border-top:1px dashed ##999999;"><img src="/common/images/spacer.gif" height="1" width="1" border="0"/></td></tr></cfif>
		</cfoutput>
		<cfoutput>
		<cf_AddToQueryString querystring="" name="sortBy" value="#thisSortBy#">
		<cf_AddToQueryString querystring="#QueryString#" name="sortOrder" value="#thisSortOrder#">
		<tr>
			<td colspan="4" align="center"  style=" border-top:1px solid ##999999; height:50px;">
			<form action="#CGI.REQUEST_URI#" method="get">
			<input type="hidden" name="sortBy" value="#thisSortBy#">
			<input type="hidden" name="sortOrder" value="#thisSortOrder#">
			<table width="100%">
				<tr>
					<td width="20%" align="left">
						<cfif thisPageNum GT 1>
							<cf_AddToQueryString querystring="#QueryString#" name="pnum" value="#thisPageNum-1#">
							<a href="?#QueryString#" style="font-weight:bold;">&lt;&lt; Prev</a>
						</cfif>
						<cfif getTheseResults.Recordcount GT thisPageNum*thisResultsPerPage>
							<cfif thisPageNum GT 1>&nbsp;|&nbsp;</cfif>
							<cf_AddToQueryString querystring="#QueryString#" name="pnum" value="#thisPageNum+1#">
							<a href="?#QueryString#" style="font-weight:bold;">Next &gt;&gt;</a>
						</cfif>
					</td>
					<td width="60%" align="center">
						Show
						<cfset lResultNums = "1,2,3,5,10,25,50,100">
						<select name="newResultNum" onChange="this.form.submit();">
							<cfloop list="#lResultNums#" index="i">
							<option value="#i#"<cfif thisResultsPerPage EQ i> selected</cfif>>#i#</option> 
							</cfloop>
							<option value="#getTheseResults.Recordcount#"<cfif thisResultsPerPage EQ getTheseResults.Recordcount> selected</cfif>>all</option>
						</select>
						at a time
					</td>
					<cf_AddToQueryString querystring="#QueryString#" name="newResultNum" value="#getTheseResults.Recordcount#" omitlist="pnum">
					<td width="20%" align="right"><a href="?#QueryString#" style="font-weight:bold;">See All</a></td>
				</tr>
			</table>
			</form>
				
			</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td>&nbsp;</td>
			<td colspan="3">This search produced no results.</td>
		</tr>
	</cfif>
</cfif>
</table>
</div>

</div>
		<div class="boxbottom2"><div></div></div>
		</div>
		</div>
</cfmodule>