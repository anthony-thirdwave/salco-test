<cfif IsDefined("URL.soa") AND ATTRIBUTES.Action IS NOT "1">
	<cfset ATTRIBUTES.Action=URL.soa>
</cfif>
<cfparam name="ATTRIBUTES.SiteCategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.Path_Info#?#CGI.Query_String#">
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
<cfparam name="metakeyword" default="">
<cfparam name="categorytree" default="">
<cfparam name="topic" default="">

<cfif structKeyExists(url,"metakeyword")>
	<cfset metakeyword = url.metakeyword>
</cfif>

<cfif structKeyExists(url,"topic")>
	<cfset topic = url.topic>
</cfif>

<cfif structKeyExists(url,"categorytree")>
	<cfset categorytree = url.categorytree>
</cfif>

<cfset blnCanSearch = len(trim(searchTxt)) OR len(trim(metakeyword)) or len(trim(topic))>

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
	<cfif not len(trim(categorytree))>	
		<CFSEARCH NAME="ContentSearch"
			COLLECTION="#ThisCollectionName#"
		 	TYPE="simple"
			CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
			status="contentSearchStatus"
			suggestions="always">  
	<cfelse>  
		<CFSEARCH NAME="ContentSearch"
			COLLECTION="#ThisCollectionName#"
			TYPE="simple"
			CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
			status="contentSearchStatus"
			suggestions="always"
			categorytree="#categorytree#">  
	</cfif>
	
	<cfif ContentSearch.RecordCount eq 0>
		<!---  natural search --->
		<!--- see above for why the 2 cfsearches: categorytree is slow --->
		<cfif not len(trim(categorytree))>  
			<CFSEARCH NAME="ContentSearch"
				COLLECTION="#ThisCollectionName#"
				TYPE="natural"
				CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
				status="contentSearchStatus"
				suggestions="always">
		<cfelse>
			<CFSEARCH NAME="ContentSearch"
				COLLECTION="#ThisCollectionName#"
				TYPE="natural"
				CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
				status="contentSearchStatus"
				suggestions="always"
				categorytree="#categorytree#">
		</cfif>	
	</cfif>
	
	<cfif ContentSearch.recordcount>
		 <cfif len(metakeyword)>
			<cfif not len(trim(categorytree))>  
				<CFSEARCH NAME="ContentSearch"
					COLLECTION="#ThisCollectionName#"
					CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
					status="contentSearchStatus"
					suggestions="always"
					category="#metakeyword#" /> 
			<cfelse>
				<CFSEARCH NAME="ContentSearch"
					COLLECTION="#ThisCollectionName#"
					CRITERIA="#lcase(htmlEditFormat(searchTxt))#"
					status="contentSearchStatus"
					suggestions="always"
					categorytree="#categorytree#"
					category="#metakeyword#" /> 
			</cfif>  
		</cfif>
	</cfif> 
	
	<cfif structKeyExists(url,"showdump") and url.showdump>
		<cfdump var="#contentSearch#" expand="false">
		<cfdump var="#contentSearchStatus#" expand="false">
	</cfif>	
	
	<cfif ContentSearch.RecordCount eq 0>
	<!--- <p>No search results</p> --->
	
	
		<cfif isDefined("contentSearchStatus")>
			<cfif structKeyExists(contentSearchStatus,"suggestedQuery")>
			<cfoutput>
				<cfset variables.newSearchTerm = replace(contentSearchStatus.suggestedQuery,"<typo>","","ALL")>
				<div>
					Did you mean <a href="#APPLICATION.utilsObj.parseCategoryUrl('search')#?searchTxt=#urlencodedformat(variables.newSearchTerm)#">#variables.newSearchTerm#</a>?
				</div>
			</cfoutput>
			
			
			<CFSEARCH NAME="ContentSearch"
				COLLECTION="#ThisCollectionName#"
				TYPE="natural"
				CRITERIA="#lcase(htmlEditFormat(variables.newSearchTerm))#"
				status="contentSearchStatus"
				suggestions="always">	
				
			  <cfif ContentSearch.recordcount eq 0>
				 <p>No search results</p>
			  <cfelse>
				 
				 Results for<cfoutput> #variables.newSearchTerm#</cfoutput><br/>
			  
				 <cfinclude template="dspSearchResults.cfm">
			  </cfif>	
				
			</cfif>
		<cfelse>	
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
