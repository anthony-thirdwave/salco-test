
<cfset Counter="1">
<div class="seRow titleRow">
	<h3>Page</h3>
	<h3>Summary</h3>
</div>

<cfoutput query="ContentSearch" startrow="#StartRow#" maxrows="#SearchNUM#">
	<cfset thisTiTle = application.utilsObj.RemoveHTML(Replace(ContentSearch.title,","," ","all"))>
	<cfset thisCategoryID = ContentSearch.key>
	<cfset thisCategoryAlias = listLast(ContentSearch.url,"/")>
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#thisCategoryID#"
		namelist="#thisTiTle#"
		idlist="#thisCategoryID#"
		aliaslist="#thisCategoryAlias#">
		
		<cfset thisPageList = "">
		<cfif listLen(NameList) gt 2>
			<cfloop index="i" from="#listLen(NameList)#" to="2" step="-1">
				<cfset thisPageList = ListAppend(thisPageList,listGetAt(NameList,i))>
			</cfloop>
			<cfset thisPageList = replace(thisPageList, ",", " >> ", "all")>
		<cfelse>
			<cfset thisPageList = ContentSearch.Title>
		</cfif>
		
		<div class="seRow">
			<h3><a href="#APPLICATION.utilsObj.parseCategoryUrl(ContentSearch.url)#">#thisPageList#</a></h3>
			<p>
			
			<cfif NameList contains "employee">
				<cfif ContentSearch.custom1 neq "">
					#left(ContentSearch.custom1, 95)# ...
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(ContentSearch.url)#" class="moreLink">More &raquo;</a><br />
				</cfif>
			<cfelse>
				<cfif ContentSearch.Context neq "">
					#left(ContentSearch.context, 95)#...
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(ContentSearch.url)#" class="moreLink">More &raquo;</a><br />
				</cfif>
			</cfif>
			</p>
		</div>
	<cfset Counter=Counter+1>
</cfoutput>
<div class="footSePa">
<h5>Search Results:</h5>
<cf_AddToQueryString QueryString="#FormQueryString#" name="oa" value="2" OmitList="SearchNum,StartRow">
<cf_AddToQueryString QueryString="#QueryString#" name="searchTxt" value="#searchTxt#">
<cfmodule template="/common/modules/utils/pagination.cfm"
	StartRow="#StartRow#" SearchNum="#SearchNum#"
	RecordCount="#ContentSearch.RecordCount#"
	FieldList="#QueryString#">

</div>