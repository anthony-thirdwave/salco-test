<cfoutput><p id="search-results-stats">#ContentSearch.RecordCount# results for <span>#HTMLEditFormat(searchTxt)#</span> in <span>#sSearch[SearchType]#</span></p></cfoutput>

<ul id="search-results-list">
<cfoutput query="ContentSearch" maxrows="#SearchNUM#" startrow="#StartRow#">
	<li>
		<a href="#url#">
			<dl>
				<dt class="search-result-prodname">#Title#</dt>
				<dd class="search-result-image-bg" style="<cfif Custom2 IS NOT "">background-image:url(#Custom2#);</cfif>"></dd>
				<dd class="search-result-prodid">#Custom3#</dd>
				<dd class="search-result-description"><cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#APPLICATION.utilsObj.removeHTML(Custom1)#" NumChars="90"></dd>
			</dl>
		</a>
	</li>
</cfoutput>
</ul>

<div id="search-results-pagination">
<cf_AddToQueryString QueryString="#FormQueryString#" name="oa" value="2" OmitList="SearchNum,StartRow">
<cf_AddToQueryString QueryString="#QueryString#" name="searchTxt" value="#searchTxt#">
<cfmodule template="/common/modules/utils/pagination.cfm"
	StartRow="#StartRow#" SearchNum="#SearchNum#"
	RecordCount="#ContentSearch.RecordCount#"
	FieldList="#QueryString#"
	Label="Search Results"
	Path="#FormPath#">
</div>