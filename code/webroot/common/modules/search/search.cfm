<cfparam name="ATTRIBUTES.SiteCategoryID" default="-1">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.REQUEST_URI#?#CGI.Query_String#">

<cfset sSearch=APPLICATION.utilsObj.GetSearchStruct()>

<cfset ThisCollectionName="#Application.CollectionName##APPLICATION.LocaleID#">
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
	
	<cfswitch expression="#searchType#">
		<cfcase value="ProductNum">
			<cfset criteria="Custom3:#lcase(htmlEditFormat(searchTxt))#">
		</cfcase>
		<cfcase value="hopper-car,tank-cars,railyard-accessories,hazarsolve">
			<cfset criteria="#lcase(htmlEditFormat(searchTxt))#">
		</cfcase>
		<cfdefaultcase>
			<cfset criteria="title:#lcase(htmlEditFormat(searchTxt))#">
		</cfdefaultcase>
	</cfswitch>
	
	<cfsearch name="ContentSearch"
		collection="#ThisCollectionName#"
	 	type="simple"
		criteria="#criteria#"
		status="contentSearchStatus"
		suggestions="always">  

	<cfif searchType IS "ProductNum" and 0><!--- product no search --->
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductsByMatchingProductNo"
			returnVariable="qProducts"
			PartNo="#lcase(htmlEditFormat(searchTxt))#">
		<cfif qProducts.RecordCount GT "0">
			<cfoutput query="qProducts">
				
				<cfquery name="GetProductProps" datasource="#APPLICATION.DSN#">
					select * from t_ProductAttribute WHERE CategoryID=<cfqueryparam value="#qProducts.CategoryID#" cfsqltype="cf_sql_integer"> And
						LanguageID=<cfqueryparam value="#APPLICATION.LanguageID#" cfsqltype="cf_sql_integer">
	            	AND AttributeValue <> ''
				</cfquery>
		
				<cfquery name="GetDescription" dbtype="query">
	            	select * from GetProductProps
					where ProductFamilyAttributeID=7
				</cfquery>
				
				<cfif GetDescription.AttributeValue IS NOT "">
					<cfset Custom1="#GetDescription.AttributeValue#">
				<cfelse>
					<cfset Custom1="">
				</cfif>
						
				<cfquery name="getCategoryNameTree" datasource="#APPLICATION.dsn#">
	                select dbo.fn_getCategoryNameHierarchyList(<cfqueryparam value="#qProducts.CategoryID#" cfsqltype="cf_sql_integer">) as categoryNameTree
	            </cfquery>
	            <cfset CategoryNameList=getCategoryNameTree.categoryNameTree>
	
	            <cfquery name="getCategoryAliasTree" datasource="#APPLICATION.dsn#">
	                select dbo.fn_getCategoryAliasHierarchyList(<cfqueryparam value="#qProducts.CategoryID#" cfsqltype="cf_sql_integer">) as categoryAliasTree
	            </cfquery>
	            <cfset CategoryTree=getCategoryAliasTree.categoryAliasTree>
				
				<cfif ListLen(CategoryTree,"/") GTE "3">
					<cfset ThisCategory="Product-#ListGetAt(CategoryTree,'3','/')#">
				<cfelse>
					<cfset ThisCategory="">
				</cfif>
				
				<cfquery name="TestIfExists" dbtype="query">
					select * from ContentSearch 
					where [key]='#CategoryID#'
				</cfquery>
				
				<cfif TestIfExists.RecordCount IS "0">
					<cfset QueryAddRow(ContentSearch,1)>
		            <cfset QuerySetCell(ContentSearch, "Category",ThisCategory)>
		            <cfset QuerySetCell(ContentSearch, "CategoryTree", CategoryTree)>
		            <cfset QuerySetCell(ContentSearch, "Custom1", Custom1)>
		            <cfset QuerySetCell(ContentSearch, "Custom2", 64)>
		            <cfset QuerySetCell(ContentSearch, "Custom4", CategoryNameList)>
		            <cfset QuerySetCell(ContentSearch, "Key", CategoryID)>
		            <cfset QuerySetCell(ContentSearch, "Rank",0)>
		            <cfset QuerySetCell(ContentSearch, "RecordsSearched", ContentSearch.RecordsSearched)>
					<cfset QuerySetCell(ContentSearch, "Score", 1.0000)>
					<cfset QuerySetCell(ContentSearch, "Size", 0)>
					<cfset QuerySetCell(ContentSearch, "Summary", Custom1)>
					<cfset QuerySetCell(ContentSearch, "Title", CategoryName)>
					<cfset QuerySetCell(ContentSearch, "Type", "text/x-empty")>
					<cfset QuerySetCell(ContentSearch, "URL", CategoryAlias)>
				</cfif>
			</cfoutput>
			
			<cfquery name="ContentSearch" dbtype="query">
				select * from ContentSearch 
				order by score,title
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif ContentSearch.RecordCount eq 0>
		<!---  natural search --->
		<!--- see above for why the 2 cfsearches: categorytree is slow --->
		<cfsearch name="ContentSearch"
			collection="#ThisCollectionName#"
			type="natural"
			criteria="#lcase(htmlEditFormat(searchTxt))#"
			status="contentSearchStatus"
			suggestions="always">
	</cfif>
	
	<cfif ContentSearch.recordcount>
		<cfif ListFindNoCase("ProductName,ProductNum",searchType)><!--- Product only --->
			<cfquery name="ContentSearch" dbtype="query">
			 	select * from ContentSearch 
				Where Custom4=<cfqueryparam value="64" cfsqltype="cf_sql_varchar">
				order by rank
			 </cfquery>
		<cfelseif ListFindNoCase("hopper-car,tank-cars,railyard-accessories,hazarsolve",searchType)>
			<cfquery name="ContentSearch" dbtype="query">
			 	select * from ContentSearch 
				Where Category=<cfqueryparam value="Product-#searchType#" cfsqltype="cf_sql_varchar">
				order by rank
			 </cfquery>
		</cfif> 
	</cfif>
	
	<cfif structKeyExists(url,"showdump") and url.showdump>
		<cfdump var="#contentSearch#" expand="false">
		<cfdump var="#contentSearchStatus#" expand="false">
	</cfif>	
	
	<cfif ContentSearch.RecordCount eq 0>
		<p>No search results</p>
	<cfelse>	
		<cfinclude template="dspSearchResults.cfm">
	</cfif>
</cfif>
<!--- to use the contentsearch in the left nav --->
<cfif isDefined("contentsearch")>
	<cfset request.contentsearch=contentsearch>
</cfif>

<!---  <cfdump var="#contentsearch#" expand="false"> --->
