<cfcomponent>
	<cffunction name="searchProduct" returntype="query" output="1" access="remote">
		<cfargument name="searchTxt" default="" type="string" required="true">
		<cfargument name="searchType" default="" type="string" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfset LOCAL.sSearch=APPLICATION.utilsObj.GetSearchStruct()>
		<cfset LOCAL.CollectionName="#Application.CollectionName##APPLICATION.LocaleID#">
		
		<cfswitch expression="#ARGUMENTS.searchType#">
			<cfcase value="ProductNum">
				<cfset LOCAL.criteria="Custom3:#lcase(htmlEditFormat(ARGUMENTS.searchTxt))#">
			</cfcase>
			<cfcase value="hopper-car,tank-cars,railyard-accessories,hazarsolve">
				<cfset LOCAL.criteria="#lcase(htmlEditFormat(ARGUMENTS.searchTxt))#">
			</cfcase>
			<cfdefaultcase>
				<cfset LOCAL.criteria="title:#lcase(htmlEditFormat(ARGUMENTS.searchTxt))#">
			</cfdefaultcase>
		</cfswitch>
		
		<cfsearch name="ContentSearch"
			collection="#LOCAL.CollectionName#"
		 	type="simple"
			criteria="#LOCAL.criteria#"
			suggestions="always">
		
		<cfif ARGUMENTS.searchType IS "ProductNum" and 0><!--- product no search --->
			<cfinvoke component="/com/Product/ProductHandler"
				method="GetProductsByMatchingProductNo"
				returnVariable="LOCAL.qProducts"
				PartNo="#lcase(htmlEditFormat(ARGUMENTS.searchTxt))#">
			<cfif LOCAL.qProducts.RecordCount GT "0">
				<cfoutput query="LOCAL.qProducts">
					
					<cfquery name="LOCAL.GetProductProps" datasource="#APPLICATION.DSN#">
						select * from t_ProductAttribute 
						WHERE CategoryID=<cfqueryparam value="#LOCAL.qProducts.CategoryID#" cfsqltype="cf_sql_integer"> And
							LanguageID=<cfqueryparam value="#APPLICATION.LanguageID#" cfsqltype="cf_sql_integer">
		            	AND AttributeValue <> ''
					</cfquery>
			
					<cfquery name="LOCAL.GetDescription" dbtype="query">
		            	select * from GetProductProps
						where ProductFamilyAttributeID=7
					</cfquery>
					
					<cfif LOCAL.GetDescription.AttributeValue IS NOT "">
						<cfset LOCAL.Custom1="#LOCAL.GetDescription.AttributeValue#">
					<cfelse>
						<cfset LOCAL.Custom1="">
					</cfif>
							
					<cfquery name="LOCAL.getCategoryNameTree" datasource="#APPLICATION.dsn#">
		                select dbo.fn_getCategoryNameHierarchyList(<cfqueryparam value="#LOCAL.qProducts.CategoryID#" cfsqltype="cf_sql_integer">) as categoryNameTree
		            </cfquery>
		            <cfset LOCAL.CategoryNameList=LOCAL.getCategoryNameTree.categoryNameTree>
		
		            <cfquery name="LOCAL.getCategoryAliasTree" datasource="#APPLICATION.dsn#">
		                select dbo.fn_getCategoryAliasHierarchyList(<cfqueryparam value="#LOCAL.qProducts.CategoryID#" cfsqltype="cf_sql_integer">) as categoryAliasTree
		            </cfquery>
		            <cfset LOCAL.CategoryTree=LOCAL.getCategoryAliasTree.categoryAliasTree>
					
					<cfif ListLen(LOCAL.CategoryTree,"/") GTE "3">
						<cfset LOCAL.ThisCategory="Product-#ListGetAt(LOCAL.CategoryTree,'3','/')#">
					<cfelse>
						<cfset LOCAL.ThisCategory="">
					</cfif>
					
					<cfquery name="LOCAL.TestIfExists" dbtype="query">
						select * from ContentSearch 
						where [key]='#LOCAL.qProducts.CategoryID#'
					</cfquery>
					
					<cfif LOCAL.TestIfExists.RecordCount IS "0">
						<cfset QueryAddRow(ContentSearch,1)>
			            <cfset QuerySetCell(ContentSearch, "Category",LOCAL.ThisCategory)>
			            <cfset QuerySetCell(ContentSearch, "CategoryTree", LOCAL.CategoryTree)>
			            <cfset QuerySetCell(ContentSearch, "Custom1", LOCAL.Custom1)>
			            <cfset QuerySetCell(ContentSearch, "Custom2", 64)>
			            <cfset QuerySetCell(ContentSearch, "Custom4", 64)>
			            <cfset QuerySetCell(ContentSearch, "Key", LOCAL.qProducts.CategoryID)>
			            <cfset QuerySetCell(ContentSearch, "Rank",0)>
			            <cfset QuerySetCell(ContentSearch, "RecordsSearched", ContentSearch.RecordsSearched)>
						<cfset QuerySetCell(ContentSearch, "Score", 1.0000)>
						<cfset QuerySetCell(ContentSearch, "Size", 0)>
						<cfset QuerySetCell(ContentSearch, "Summary", LOCAL.Custom1)>
						<cfset QuerySetCell(ContentSearch, "Title", LOCAL.qProducts.CategoryName)>
						<cfset QuerySetCell(ContentSearch, "Type", "text/x-empty")>
						<cfset QuerySetCell(ContentSearch, "URL", LOCAL.qProducts.CategoryAlias)>
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
				collection="#LOCAL.CollectionName#"
				type="natural"
				criteria="#lcase(htmlEditFormat(ARGUMENTS.searchTxt))#"
				suggestions="always">
		</cfif>
		
		<cfif ContentSearch.recordcount>
			<cfif ListFindNoCase("ProductName,ProductNum",ARGUMENTS.searchType)><!--- Product only --->
				<cfquery name="ContentSearch" dbtype="query">
				 	select * from ContentSearch 
					Where Custom4=<cfqueryparam value="64" cfsqltype="cf_sql_varchar">
					order by rank
				 </cfquery>
			<cfelseif ListFindNoCase("hopper-car,tank-cars,railyard-accessories,hazarsolve",ARGUMENTS.searchType)>
				<cfquery name="ContentSearch" dbtype="query">
				 	select * from ContentSearch 
					Where Category=<cfqueryparam value="Product-#ARGUMENTS.searchType#" cfsqltype="cf_sql_varchar">
					order by rank
				 </cfquery>
			</cfif> 
		</cfif>
		
		<cfreturn ContentSearch>
	</cffunction>
	
	<cffunction name="searchProductJSON" returntype="array" output="false" returnformat="JSON" access="remote">
		<cfargument name="searchTxt" default="" type="string" required="true">
		<cfargument name="searchType" default="" type="string" required="true">
		<cfargument name="maxrows" default="all" type="string">
		
		<cfset var LOCAL=StructNew()>
		
		<cfif NOT IsNumeric(ARGUMENTS.MaxRows)>
			<cfset ARGUMENTS.MaxRows="999999">
		</cfif>
		<cfinvoke component="/com/product/search" method="searchProduct" returnVariable="LOCAL.ContentSearch"
			searchTxt="#ARGUMENTS.searchTxt#"
			searchType="#ARGUMENTS.searchType#">
		
		<cfquery name="LOCAL.ContentSearch" dbtype="query" maxrows="#ARGUMENTS.MaxRows#">
		 	select * from [LOCAL].ContentSearch 
			order by rank
		 </cfquery>
		
		<cfset LOCAL.aReturn=ArrayNew(1)>
		
		<cfoutput query="LOCAL.ContentSearch">
			<cfset LOCAL.sReturn=StructNew()>
			<cfset LOCAL.sReturn["Name"]="#LOCAL.ContentSearch.Title# (#LOCAL.ContentSearch.Custom3#)">
			<cfset LOCAL.sReturn["Value"]="/page/#LOCAL.ContentSearch.URL#">
			<cfset ArrayAppend(LOCAL.aReturn,LOCAL.sReturn)>
		</cfoutput>
		
		<cfreturn LOCAL.aReturn>
	</cffunction>
	
</cfcomponent>