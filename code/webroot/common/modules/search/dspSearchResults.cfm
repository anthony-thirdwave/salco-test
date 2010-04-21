<cfset Counter="1">
<CFOUTPUT QUERY="ContentSearch" MAXROWS="#SearchNUM#" STARTROW="#StartRow#">
	<h4><a href="/content.cfm/#url#">#Title#</a></h4>
	Site location: #categoryTreeLinks(categorytree,custom4,3,' &gt; ')#<br/>
	<p>
	<cfif Custom1 neq "">
		<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#REReplace(Custom1, '<[^>]*>','','All')#" NumChars="140"><br />
	</cfif>
	<cfif len(custom3)>
		Topics: #searchLink('topic',custom3)#<br/>
	</cfif>
	<cfif len(category)>
		Keywords: #searchLink('metakeyword',category)#<br/>
	</cfif>
	</p>
	<cfset Counter=Counter+1>
</CFOUTPUT>
<div class="pagination">
<cf_AddToQueryString QueryString="#FormQueryString#" name="oa" value="2" OmitList="SearchNum,StartRow">
<cf_AddToQueryString QueryString="#QueryString#" name="searchTxt" value="#searchTxt#">
<cfmodule template="/common/modules/utils/pagination.cfm" 
	StartRow="#StartRow#" SearchNum="#SearchNum#" 
	RecordCount="#ContentSearch.RecordCount#" 
	FieldList="#QueryString#">
</div>

<cffunction name="searchLink">
	<cfargument name="searchType">
	<cfargument name="searchList">
	<cfargument name="searchAlias" required="false" default="search">
	
	<cfset var local = structNew()>
	
	<cfset local.links = "">
	<cfloop list="#arguments.searchList#" index="local.i" delimiters=",">
		<cfset local.linkSubStr = "">
		<cfset local.linkSubStr = "<a href='#APPLICATION.utilsObj.parseCategoryUrl(arguments.searchAlias)#?#arguments.searchType#=#urlencodedformat(trim(local.i))#'>#trim(local.i)#</a>">
		<cfset local.links = local.links & " " & local.linkSubStr>
	</cfloop>
	<!--- <cfdump var="#local.links#"> --->
	<cfreturn local.links>
</cffunction>

<cffunction name="categoryTreeLinks">
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
		<cfset local.linkSubStr = local.linkSubStr & "<a href='#listGetAt(arguments.categoryAliases,local.i,'/')#'>#listGetAt(arguments.categoryNames,local.i,',')#</a>">
		<cfset local.links = local.links & local.linkSubStr>
		<cfif local.i lt local.listEnd>
			<cfset local.links = local.links & arguments.separator>
		</cfif>
	</cfloop>
	
	<cfreturn local.links>
</cffunction>

