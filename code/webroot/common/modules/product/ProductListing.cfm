<cfsetting ShowDebugOutput="false">

<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">
<cfparam name="ATTRIBUTES.Mode" default="Default">
<cfparam name="ATTRIBUTES.Title" default="">
<cfparam name="ATTRIBUTES.OmitCurrentProduct" default="no">
<cfparam name="ATTRIBUTES.HighlightCurrentProduct" default="No">
<cfparam name="ATTRIBUTES.currentPageAlias" default="">

<cfparam name="ShowAll" default="0">

<cfparam name="ATTRIBUTES.SpecificationSetID" default="8000">
<cfif IsDefined("APPLICATION.LanguageID")>
	<cfparam name="ATTRIBUTES.LanguageID" default="#APPLICATION.LanguageID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LanguageID" default="100">
</cfif>

<cfif IsDefined("APPLICATION.LocaleID")>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.LocaleID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
</cfif>

<cfif IsDefined("URL.ProductID")>
	<cfset ATTRIBUTES.ProductID=Val(URL.ProductID)>
</cfif>

<cfif IsDefined("URL.ProductFamilyID")>
	<cfset ATTRIBUTES.ProductFamilyID=Val(URL.ProductFamilyID)>
</cfif>

<cfif IsDefined("URL.Mode")>
	<cfset ATTRIBUTES.Mode=Trim(URL.Mode)>
</cfif>

<cfif Val(ATTRIBUTES.ProductFamilyID) LTE "0" AND Val(ATTRIBUTES.ProductID) GT "0">
	<cfinvoke component="/com/Product/ProductHandler"
		method="GetProductFamilyID"
		returnVariable="ATTRIBUTES.ProductFamilyID"
		ProductID="#ATTRIBUTES.ProductID#">
</cfif>

<cfif Val(ATTRIBUTES.ProductFamilyID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfif ListLast(GetBaseTemplatePath(),"\") IS "ProductListing.cfm">
		<cfif (ListLen(CGI.HTTP_Referer,"/") GTE "2" and FindNoCase("salco",ListGetAt(CGI.HTTP_Referer,2,"/")) IS "0") or CGI.HTTP_Referer IS "">
			<cfif 0>
				<cfinvoke component="/com/ContentManager/CategoryHandler" 
					method="GetCategoryBasicDetails" 
					returnVariable="qGetCategoryBasicDetails"
					CategoryID="#ATTRIBUTES.ProductFamilyID#">
				<cflocation url="#APPLICATION.utilsObj.parseCategoryUrl(qGetCategoryBasicDetails.CategoryAlias)#" addtoken="No">
			</cfif>
		</cfif>
	</cfif>

	<cfif ATTRIBUTES.mode IS "displayRelated">
		<cfinvoke component="/com/product/productHandler" 
			method="GetRelatedProductIDList"
			productID="#ATTRIBUTES.ProductID#"
			returnVariable="lRelatedProductID">
		<cfset productListCount=listLen(lRelatedProductID)>
	<cfelse>
		<cfinvoke component="/com/product/productFamilyHandler" 
			method="GetProductListBasic" 
			returnVariable="qGetProductListBasic"
			ProductFamilyID="#ATTRIBUTES.ProductFamilyID#"
			LocaleID="#ATTRIBUTES.LocaleID#"
			LanguageID="#ATTRIBUTES.LanguageID#">
		
		<cfinvoke component="/com/product/productHandler" 
			method="GetProductPartNumber"
			productID="#ATTRIBUTES.ProductID#"
			returnVariable="sourceProductPartNumber">

		<cfset productListCount=qGetProductListBasic.RecordCount>
	</cfif>
	
	<cfset SearchNum="5">
	<cfif NOT IsDefined("StartRow")>
		<cfset StartRow=1>
	</cfif>
	<cfif Val(StartRow) LTE "0">
		<cfset StartRow=1>
	</cfif>
	<cfif Val(StartRow) GT Val(productListCount)>
		<cfset StartRow=1>
	</cfif>
	<cfif ShowAll IS "1">
		<cfset StartRow=1>
		<cfset SearchNum=999>
	</cfif>
	<cfif NOT IsNumeric(StartRow)>
		<cfset StartRow="1">
	</cfif>
	
	<cfif ATTRIBUTES.mode IS "displayRelated">
		<cfif lRelatedProductID IS "">
			<cfset lRelatedProductID="-1">
		</cfif>
		<cfinvoke component="/com/product/productFamilyHandler" 
			method="GetProductList" 
			returnVariable="qGetProductList"
			ProductFamilyID="#ATTRIBUTES.ProductFamilyID#"
			LocaleID="#ATTRIBUTES.LocaleID#"
			LanguageID="#ATTRIBUTES.LanguageID#"
			StartRow="#StartRow#"
			MaxRows="#SearchNum#"
			lProductID="#lRelatedProductID#">
	<cfelse>
		<cfinvoke component="/com/product/productFamilyHandler" 
			method="GetProductList" 
			returnVariable="qGetProductList"
			ProductFamilyID="#ATTRIBUTES.ProductFamilyID#"
			LocaleID="#ATTRIBUTES.LocaleID#"
			LanguageID="#ATTRIBUTES.LanguageID#"
			StartRow="#StartRow#"
			MaxRows="#SearchNum#">
	</cfif>
	
	<cfif ATTRIBUTES.OmitCurrentProduct and Val(ATTRIBUTES.ProductID) GT "0">
		<cfquery name="qGetProductList" dbtype="query">
			select * from qGetProductList
			where CategoryID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.ProductID#">
			order by CategoryNameDerived
		</cfquery>
	</cfif>
	
	<cfif qGetProductList.RecordCount GT "0">
		<cfif ATTRIBUTES.Title IS NOT "">
			<cfoutput><h4>#ATTRIBUTES.Title#</h4></cfoutput>
		</cfif>
	</cfif>

	<cfoutput><div id="pagList_#ATTRIBUTES.ProductFamilyID#_#ATTRIBUTES.Mode#" class="pagList"></cfoutput>
	<cfif qGetProductList.RecordCount GT "0">
		<cfoutput><div id="ProductListing_#ATTRIBUTES.ProductFamilyID#_#ATTRIBUTES.Mode#"></cfoutput>
		<table class="featuredDownloads" border="0" cellspacing="0" cellpadding="0">
        <thead>
		<tr>
			<th align="left" valign="middle">Product</th>
			<th align="center" valign="middle" width="110">Part No.</th>
			<th align="center" valign="middle" width="110">Description</th>
		</tr>
        </thead>
        <tbody>
		<cfoutput query="qGetProductList">
			<cfif CurrentRow MOD 2 IS "1">
				<cfset ThisRowClass="evenRow">
			<cfelse>
				<cfset ThisRowClass="oddRow">
			</cfif>
			<cfif CurrentRow MOD SearchNum IS "0" or CurrentRow IS qGetProductList.RecordCount>
				<cfset ThisRowClass="#ThisRowClass# tableBot">
			</cfif>
			<tr<cfif ATTRIBUTES.HighlightCurrentProduct and (ATTRIBUTES.ProductID IS qGetProductList.CategoryID or sourceProductPartNumber IS qGetProductList.PartNumber)> class="activeRow"</cfif>>
				<cfif ATTRIBUTES.mode IS "displayRelated" and ATTRIBUTES.currentPageAlias IS NOT "">
					<cfset thisURL="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductList.CategoryAlias)#?StartRow=#StartRow#&return=#ATTRIBUTES.currentPageAlias#">
				<cfelse>
					<cfset thisURL="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductList.CategoryAlias)#?StartRow=#StartRow#">
				</cfif>
				<td class="tableLeft #ThisRowClass#" valign="middle"><a href="#thisURL#">#qGetProductList.CategoryNameDerived#</a></td>
				<td class="#ThisRowClass#" valign="middle" align="left"><a href="#thisURL#">#Ucase(qGetProductList.PartNumber)#</a></td>
				<td class="tableRight #ThisRowClass#" valign="middle" align="left">
					<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#qGetProductList.ProductDescription#" NumChars="100">

				</td>
			</tr>
		</cfoutput></tbody>
		</table>
		</div>
		<cfoutput>
			<cfif Val(ShowAll) IS "0">
				<cfset AdditionalText="<a href=""/common/modules/product/ProductListing.cfm?ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#&mode=#ATTRIBUTES.Mode#&ShowAll=1&productID=#ATTRIBUTES.ProductID#"">Show All</a>">
			<cfelse>
				<cfset AdditionalText="">
				<div class="pagination"><p><a href="/common/modules/product/ProductListing.cfm?ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#&mode=#ATTRIBUTES.Mode#&ShowAll=0&productID=#ATTRIBUTES.ProductID#">Show As Paginated Results</a></p></div>
			</cfif>
		</cfoutput>
		
		<cfmodule template="/common/modules/utils/pagination.cfm"
			StartRow="#StartRow#" SearchNum="#SearchNum#"
			RecordCount="#productListCount#"
			Path="/common/modules/product/ProductListing.cfm"
			FieldList="ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#&mode=#ATTRIBUTES.Mode#&productID=#ATTRIBUTES.ProductID#"
			Label="Products"
			AdditionalText="#AdditionalText#">
	<cfelse>
		<cfif ATTRIBUTES.OmitCurrentProduct>
		
		<cfelse>
			<cfif ATTRIBUTES.mode IS "displayRelated">

			<cfelse>
				<h3>Product List Coming Soon</h3>
			</cfif>
		</cfif>
	</cfif>
	</div>
</cfif>
<div style="clear:both"></div>