<cfparam name="ATTRIBUTES.FormAction" default="#APPLICATION.utilsObj.parseCategoryUrl('/page/system/search-intranet')#">
<cfparam name="searchTxt" default="">

<cfoutput>
	<form name="search" method="get" action="#ATTRIBUTES.FormAction#" class="searchForm clearit">
		<label>Search Term</label>
		<input type="text" name="searchTxt" id="detailedSearch-text" value="#HTMLEditFormat(searchTxt)#"/>
		<input type="submit" value="search" alt="Search" id="detailedSearch-btn">
	</form>
</cfoutput>
