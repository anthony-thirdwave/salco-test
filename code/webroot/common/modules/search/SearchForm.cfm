<cfparam name="ATTRIBUTES.FormAction" default="#APPLICATION.utilsObj.parseCategoryUrl('Search')#">
<cfparam name="searchTxt" default="Search Salco Products...">
<cfparam name="searchType" default="">
<cfset sSearch=APPLICATION.utilsObj.GetSearchStruct()>
<cfoutput>
	<form method="get" action="#ATTRIBUTES.FormAction#">
	<select name="searchType" id="search-type">
		<cfloop index="ThisSearchType" list="#StructKeyList(sSearch)#">
			<option value="#ThisSearchType#" <cfif searchType IS ThisSearchType>selected</cfif>>#sSearch[ThisSearchType]#</option>
		</cfloop>
	</select>
	<input type="text" name="searchTxt" class="backSearch" autocomplete="off" value="#HTMLEditFormat(searchTxt)#" id="search-text"/>
	<input type="submit" class="btnSearch" />
	<div id="json-return"></div>
	</form>
</cfoutput>
