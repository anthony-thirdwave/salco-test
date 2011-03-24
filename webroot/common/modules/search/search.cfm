<cfif IsDefined("URL.soa") AND ATTRIBUTES.Action IS NOT "1">
	<cfset ATTRIBUTES.Action=URL.soa>
</cfif>
<cfparam name="ATTRIBUTES.SiteCategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.REQUEST_URI#?#CGI.Query_String#">
<cfparam name="sc" default="1">

<cfset ThisCollectionName="#Application.CollectionName##APPLICATION.LocaleID#">
<cfset SearchNum="10">

<cfset FormPath=GetToken(ATTRIBUTES.FormAction,1,"?")>
<cfset FormQueryString=GetToken(ATTRIBUTES.FormAction,2,"?")>

<cfset sStatusCode=StructNew()>
<cfset DevNull=StructInsert(sStatusCode,"1","<p><B>Enter search terms</B></p>","1")>
<cfset DevNull=StructInsert(sStatusCode,"2","<p>Please enter a search term.</p>","1")>
<cfset DevNull=StructInsert(sStatusCode,"3","<p><B>No results found.</B></p>","1")>


<cfparam name="searchTxt" default="">
<cfparam name="SearchCategory" default="">

<cfset blnCanSearch = len(trim(searchTxt)) OR len(trim(SearchCategory))>

<cfif not blnCanSearch>
	<cfoutput>#sStatusCode[2]#</cfoutput>
<cfelse>
	<cfif NOT IsDefined("StartRow")>
		<CFSET StartRow = 1>
	</cfif>
	<cfif Val(StartRow) LTE "0">
		<CFSET StartRow = 1>
	</cfif>
	
	<!---  simple search --->
	<!--- searching with the categorytree is hundreds of times slower,
		  so only search with it if necessary --->  
	<CFSEARCH NAME="ContentSearch"
		COLLECTION="#ThisCollectionName#"
	 	TYPE="simple"
		CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
		status="contentSearchStatus"
		suggestions="always">  

	
	<cfif ContentSearch.RecordCount eq 0>
		<!---  natural search --->
		<!--- see above for why the 2 cfsearches: categorytree is slow --->
		<CFSEARCH NAME="ContentSearch"
			COLLECTION="#ThisCollectionName#"
			TYPE="natural"
			CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
			status="contentSearchStatus"
			suggestions="always">
	</cfif>
	
	<cfif ContentSearch.recordcount and SearchCategory IS NOT "">
		 <cfquery name="ContentSearch" dbtype="query">
		 	select * from ContentSearch 
			Where Category=<cfqueryparam value="#SearchCategory#" cfsqltype="cf_sql_varchar">
			order by rank
		 </cfquery>
	</cfif> 
	
	<cfif structKeyExists(url,"showdump") and url.showdump>
		<cfdump var="#contentSearch#" expand="false">
		<cfdump var="#contentSearchStatus#" expand="false">
	</cfif>	
	
	<cfif ContentSearch.RecordCount eq 0>
	<!--- <p>No search results</p> --->
		<cfif isDefined("contentSearchStatus")>
			<cfset NewSearchTerm="">
			<cfif structKeyExists(contentSearchStatus,"suggestedQuery")>
				<cfset newSearchTerm = replace(contentSearchStatus.suggestedQuery,"<typo>","","ALL")>
			</cfif>
			<cfif newSearchTerm IS NOT "">
				<cfoutput>
					<div>
						Did you mean <a href="#APPLICATION.utilsObj.parseCategoryUrl('search')#?searchTxt=#urlencodedformat(variables.newSearchTerm)#">#HTMLEditFormat(variables.newSearchTerm)#</a>?
					</div>
				</cfoutput>
				
				<cfif ContentSearch.RecordCount IS "0">
					<CFSEARCH NAME="ContentSearch"
						COLLECTION="#ThisCollectionName#"
						TYPE="natural"
						CRITERIA="#lcase(htmlEditFormat(variables.newSearchTerm))#"
						status="contentSearchStatus"
						suggestions="always">	
					<cfif ContentSearch.recordcount eq 0>
						<cfinclude template="/common/modules/search/dspSearchFormFilter.cfm">
						<p>No search results</p>
					<cfelse>
						<h3>Results for<cfoutput> "#HTMLEditFormat(variables.newSearchTerm)#"</cfoutput></h3>
						<cfinclude template="dspSearchResults.cfm">
					</cfif>
				<cfelse>
					<cfinclude template="dspSearchResults.cfm">
				</cfif>
			<cfelse>
				<cfinclude template="/common/modules/search/dspSearchFormFilter.cfm">
				<p>No search results</p>	
			</cfif>
		<cfelse>
			<cfinclude template="/common/modules/search/dspSearchFormFilter.cfm">
			<p>No search results</p>			
		</cfif>
	<cfelse>	
		<cfinclude template="dspSearchResults.cfm">
	</cfif>
</cfif>
<!--- to use the contentsearch in the left nav --->
<cfif isDefined("contentsearch")>
	<cfset request.contentsearch = contentsearch>
</cfif>

<!---  <cfdump var="#contentsearch#" expand="false"> --->