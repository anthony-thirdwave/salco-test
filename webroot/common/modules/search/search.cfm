<cfparam name="ATTRIBUTES.SiteCategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.REQUEST_URI#?#CGI.Query_String#">

<cfset sSearch=APPLICATION.utilsObj.GetSearchStruct()>

<cfset SearchNum="12">

<cfset FormPath=GetToken(ATTRIBUTES.FormAction,1,"?")>
<cfset FormQueryString=GetToken(ATTRIBUTES.FormAction,2,"?")>

<cfset sStatusCode=StructNew()>
<cfset DevNull=StructInsert(sStatusCode,"1","<p><B>Enter search terms</B></p>","1")>
<cfset DevNull=StructInsert(sStatusCode,"2","<p>Please enter a search term.</p>","1")>
<cfset DevNull=StructInsert(sStatusCode,"3","<p><B>No results found.</B></p>","1")>

<cfparam name="searchTxt" default="">
<cfparam name="searchType" default="ProductName">

<cfset searchTxt=Trim(searchTxt)>

<cfset blnCanSearch=len(trim(searchTxt)) OR len(trim(SearchCategory))>

<cfif not blnCanSearch>
	<cfoutput>#sStatusCode[2]#</cfoutput>
<cfelse>
	<cfif NOT IsDefined("StartRow")>
		<cfset StartRow=1>
	</cfif>
	<cfif Val(StartRow) LTE "0">
		<cfset StartRow=1>
	</cfif>
	
	<cfinvoke component="/com/product/search" method="searchProduct" returnVariable="ContentSearch"
		searchTxt="#searchTxt#"
		searchType="#searchType#">
	
	<cfif ContentSearch.RecordCount eq 0>
		<p>No search results</p>
	<cfelse>	
		<cfinclude template="dspSearchResults.cfm">
	</cfif>
</cfif>