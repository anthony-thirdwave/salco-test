<cfinclude template="/common/modules/search/dspSearchFormFilter.cfm">

<table class="featuredDownloads" border="0" cellspacing="0" cellpadding="0" width="100%">
<thead>
<tr>
	<th align="left" valign="middle">Rank</th>
	<th align="left" valign="middle" width="50%">Page</th>
	<th align="center" valign="middle" width="50%">Summary</th>
</tr>
</thead>
<tbody>
<cfoutput query="ContentSearch" maxrows="#SearchNUM#" startrow="#StartRow#">
	<cfif CurrentRow MOD 2 IS "1">
		<cfset ThisRowClass="evenRow">
	<cfelse>
		<cfset ThisRowClass="oddRow">
	</cfif>
	<tr valign="top">
	<td class="tableLeft #ThisRowClass#">#CurrentRow+StartRow-1#</td>
	<td class="#ThisRowClass#"><a href="#url#">#Title#</a></td>
	<td class="tableRight #ThisRowClass#" align="Left">
		<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#APPLICATION.utilsObj.removeHTML(Custom1)#" NumChars="250">
	</td></tr>
	<cfif CurrentRow MOD SearchNum IS "0" or CurrentRow IS ContentSearch.RecordCount>
		<cfset ThisRowClass="#ThisRowClass# tableBot">
	</cfif>
	<tr>
	<td class="tableLeft #ThisRowClass#"></td>
	<td class="tableRight #ThisRowClass#" colspan="2">#categoryTreeLinks(CategoryTree,Custom4,2," &gt; ")#</td>
	</tr>
</cfoutput>
</tbody>
</table>

<cf_AddToQueryString QueryString="#FormQueryString#" name="oa" value="2" OmitList="SearchNum,StartRow">
<cf_AddToQueryString QueryString="#QueryString#" name="searchTxt" value="#searchTxt#">
<cfmodule template="/common/modules/utils/pagination.cfm"
	StartRow="#StartRow#" SearchNum="#SearchNum#"
	RecordCount="#ContentSearch.RecordCount#"
	FieldList="#QueryString#"
	Label="Search Results"
	Path="#FormPath#">

<cffunction name="searchLink" output="false">
	<cfargument name="searchType">
	<cfargument name="searchList">
	<cfargument name="searchAlias" required="false" default="search">

	<cfset var local = structNew()>

	<cfset local.links = "">
	<cfloop list="#arguments.searchList#" index="local.i" delimiters=",">
		<cfset local.linkSubStr = "">
		<cfset local.linkSubStr = "<a href='#APPLICATION.MyCategoryHandler.parseCategoryUrl(arguments.searchAlias)#?#arguments.searchType#=#urlencodedformat(trim(local.i))#'>#trim(local.i)#</a>">
		<cfset local.links = local.links & " " & local.linkSubStr>
	</cfloop>
	
	<cfreturn local.links>
</cffunction>

<cffunction name="categoryTreeLinks" output="false">
	<cfargument name="categoryAliases">
	<cfargument name="categoryNames">
	<cfargument name="listStartAt" required="false" default="1">
	<cfargument name="separator" required="false" default="|">

	<!--- the root is the home page --->

	<cfset var local = structNew()>
	<!--- <cfset local.links = "<a href='/'>Home</a>" > --->
	<cfset local.links = "" >

	<!--- to control when to end getting the list items --->
	<cfset local.listEnd = listlen(arguments.categoryAliases,'/')-1>

	<cfif local.listEnd lte 0>
		<cfset local.listEnd = 0>
	</cfif>

	<cfloop index="local.i" from="#arguments.listStartAt#" to="#local.listEnd#" step="1">
		<!--- <cfset local.linkSubStr = arguments.separator> --->
		<cfset local.linkSubStr = "">
		<cfset local.linkSubStr = local.linkSubStr & "<a href=""#listGetAt(arguments.categoryAliases,local.i,'/')#"">#listGetAt(arguments.categoryNames,local.i,',')#</a>">
		<cfset local.links = local.links & local.linkSubStr>
		<cfif local.i lt local.listEnd>
			<cfset local.links = local.links & arguments.separator>
		</cfif>
	</cfloop>

	<cfreturn local.links>
</cffunction>

