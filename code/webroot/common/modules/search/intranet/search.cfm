<div class="searchResults">
<cfif IsDefined("URL.soa") AND ATTRIBUTES.Action IS NOT "1">
	<cfset ATTRIBUTES.Action=URL.soa>
</cfif>
<cfparam name="ATTRIBUTES.SiteCategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.Path_Info#?#CGI.Query_String#">
<cfparam name="sc" default="1">

<cfset ThisCollectionName="#Application.CollectionName##APPLICATION.LocaleID#_intranet">

<cfset SearchNum="10">

<cfset FormPath=GetToken(ATTRIBUTES.FormAction,1,"?")>
<cfset FormQueryString=GetToken(ATTRIBUTES.FormAction,2,"?")>

<cfset sStatusCode=StructNew()>
<cfset DevNull=StructInsert(sStatusCode,"1","<p><B>Enter search terms</B></p>","1")>
<cfset DevNull=StructInsert(sStatusCode,"2","<p>Please enter a search term.</p>","1")>
<cfset DevNull=StructInsert(sStatusCode,"3","<p><B>No results found.</B></p>","1")>

<cfparam name="searchTxt" default="">

<cfset blnCanSearch=len(trim(searchTxt))>

<article class='news'><div class='inArt'><div class='artContent'>
<h1>Search Results</h1>

<cfif not blnCanSearch>
	<cfoutput>#sStatusCode[2]#</cfoutput>
	<form name="detailedSearch" method="get" action="#APPLICATION.utilsObj.parseCategoryUrl('/page/system/search-intranet')#" id="detailedSearch">
		<label>Search Term</label>
		<input type="text" name="searchTxt" id="detailedSearch-text" value="#HTMLEditFormat(searchTxt)#"/>
		<input type="submit" value="search" alt="Search" id="detailedSearch-btn">
	</form>
<cfelse>
	<cfif NOT IsDefined("StartRow")>
		<CFSET StartRow=1>
	</cfif>
	<cfif Val(StartRow) LTE "0">
		<CFSET StartRow=1>
	</cfif>
	<!---  simple search --->
	<!--- searching with the categorytree is hundreds of times slower,
		  so only search with it if necessary --->  
	<!--- #lcase(htmlEditFormat(searchTxt))# --->
	<CFSEARCH NAME="ContentSearch"
		COLLECTION="#ThisCollectionName#"
	 	TYPE="simple"
		CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
		status="contentSearchStatus"
		suggestions="always"
		ContextPassages="1"  
	    ContextBytes="250"
		ContextHighlightBegin="<span class=""searchTxt"">"
		ContextHighlightEnd="</span>">  


	<!--- <cfif structKeyExists(url,"showdump") and url.showdump>
		<cfdump var="#contentSearch#" expand="false">
		<cfdump var="#contentSearchStatus#" expand="false">
	</cfif>	
	 --->
	<cfif ContentSearch.RecordCount eq 0>
		<p>No search results, search again</p>
		<cfoutput>
			<form name="detailedSearch" method="get" action="#APPLICATION.utilsObj.parseCategoryUrl('/page/system/search-intranet')#" id="detailedSearch">
				<label>Search Term</label>
				<input type="text" name="searchTxt" id="detailedSearch-text" value="#HTMLEditFormat(searchTxt)#"/>
				<input type="submit" value="search" alt="Search" id="detailedSearch-btn">
			</form>
		</cfoutput>
		<cfif isDefined("contentSearchStatus")>
			<cfif structKeyExists(contentSearchStatus,"suggestedQuery")>
			<cfoutput>
				<cfset variables.newSearchTerm=replace(contentSearchStatus.suggestedQuery,"<typo>","","ALL")>
				<p class="helpText">
					Did you mean <a href="#APPLICATION.MyCategoryHandler.parseCategoryUrl('search')#?searchTxt=#urlencodedformat(variables.newSearchTerm)#">#variables.newSearchTerm#</a>?
				</p>
			</cfoutput>
			
			<CFSEARCH NAME="ContentSearch"
				COLLECTION="#ThisCollectionName#"
				TYPE="natural"
				CRITERIA="#lcase(htmlEditFormat(variables.newSearchTerm))#"
				status="contentSearchStatus"
				suggestions="always"
				ContextPassages="1"  
			    ContextBytes="250"
				ContextHighlightBegin="<span class=""searchTxt"">"
				ContextHighlightEnd="</span>">	
			
			  <cfif ContentSearch.recordcount eq 0>
				 <p class="helpText">No search results</p>
			  <cfelse>
				
				<p class="helpText"> Results for <span class="searchTxt"><cfoutput>#variables.newSearchTerm#</cfoutput></span></p>
				<ul>
					 <cfinclude template="dspSearchResults.cfm">
				</ul>
			  </cfif>	
				
			</cfif>
		<cfelse>	
			<p class="helpText">No search results</p>
		</cfif>
	<cfelse>
		<cfoutput>
			<form name="detailedSearch" method="get" action="#APPLICATION.utilsObj.parseCategoryUrl('/page/system/search-intranet')#" id="detailedSearch">
				<label>Search Term</label>
				<input type="text" name="searchTxt" id="detailedSearch-text" value="#HTMLEditFormat(searchTxt)#"/>
				<input type="submit" value="search" alt="Search"  id="detailedSearch-btn">
			</form>
		</cfoutput>
		<!--- <cfoutput>
			<p class="helpText">Found <strong>#ContentSearch.RecordCount#</strong> result<cfif ContentSearch.RecordCount IS NOT "1">s</cfif>
			for <span class="searchTxt">#HTMLEditFormat(searchTxt)#</span>.</p>
		</cfoutput> --->
		<!--- <ul> --->
			<br><br>
			<cfinclude template="dspSearchResults.cfm">
		<!--- </ul> --->
	</cfif>
</cfif>
<!--- to use the contentsearch in the left nav --->
<cfif isDefined("contentsearch")>
	<cfset request.contentsearch=contentsearch>
</cfif>
</div></div></article>
<!---  <cfdump var="#contentsearch#" expand="false"> --->
</div>
