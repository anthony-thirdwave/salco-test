<cfsilent>
<cfsetting showdebugoutput="false">
<cfparam name="URL.s" default=""> <!--- searchTxt--->
<cfparam name="URL.st" default=""> <!--- searchType --->
<!--- Set MaxResults to the maximun number of results you want to suggest --->
<cfset MaxResults=7>
<cfinvoke component="/com/product/search" method="searchProductJSON" returnVariable="ContentSearch"
	searchTxt="#URL.s#"
	searchType="#URL.st#"
	maxrows="#MaxResults#">
</cfsilent><cfoutput>#SerializeJSON(ContentSearch)#</cfoutput>