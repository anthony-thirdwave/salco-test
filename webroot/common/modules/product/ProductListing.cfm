<cfsetting showdebugoutput="No">

<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">
<cfparam name="ATTRIBUTES.Mode" default="Default">
<cfparam name="ATTRIBUTES.Title" default="">

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

<cfif IsDefined("URL.ProductFamilyID")>
	<cfset ATTRIBUTES.ProductFamilyID=Val(URL.ProductFamilyID)>
</cfif>

<cfif Val(ATTRIBUTES.ProductFamilyID) LTE "0" AND Val(ATTRIBUTES.ProductID) GT "0">
	<cfinvoke component="/com/Product/ProductHandler"
		method="GetProductFamilyID"
		returnVariable="ATTRIBUTES.ProductFamilyID"
		ProductID="#ATTRIBUTES.ProductID#">
</cfif>

<cfif Val(ATTRIBUTES.ProductFamilyID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfinvoke component="/com/product/productFamilyHandler" 
		method="GetProductListBasic" 
		returnVariable="qGetProductListBasic"
		ProductFamilyID="#ATTRIBUTES.ProductFamilyID#"
		LocaleID="#ATTRIBUTES.LocaleID#"
		LanguageID="#ATTRIBUTES.LanguageID#">
	
	<cfswitch expression="#ATTRIBUTES.Mode#">
		<cfdefaultcase>
			<cfset SearchNum="5">
			<cfif NOT IsDefined("StartRow")>
				<CFSET StartRow=1>
			</cfif>
			<cfif Val(StartRow) LTE "0">
				<CFSET StartRow=1>
			</cfif>
			<cfif Val(StartRow) GT Val(qGetProductListBasic.RecordCount)>
				<CFSET StartRow=1>
			</cfif>
			
			<cfinvoke component="/com/product/productFamilyHandler" 
				method="GetProductList" 
				returnVariable="qGetProductList"
				ProductFamilyID="#ATTRIBUTES.ProductFamilyID#"
				LocaleID="#ATTRIBUTES.LocaleID#"
				LanguageID="#ATTRIBUTES.LanguageID#"
				StartRow="#StartRow#"
				MaxRows="#SearchNum#">
		
			
			<cfoutput><div id="pagList_#ATTRIBUTES.ProductFamilyID#" class="pagList"></cfoutput>
			<cfif qGetProductList.RecordCount GT "0">
				<cfif ATTRIBUTES.Title IS NOT "">
					<cfoutput><h4>#ATTRIBUTES.Title#</h4></cfoutput>
				</cfif>
				<cfoutput><div id="ProductListing_#ATTRIBUTES.ProductFamilyID#"></cfoutput>
				<table class="featuredDownloads" border="0" cellspacing="0" cellpadding="0">
                <thead>
				<tr>
					<th align="left" valign="middle">Product</th>
					<th align="center" valign="middle" width="110">Part No.</th>
					<th align="center" valign="middle" width="110">Document(s)</th>
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
					<tr>
						<td class="tableLeft #ThisRowClass#" valign="middle"><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductList.CategoryAlias)#">#qGetProductList.CategoryNameDerived#</a></td>
						<td class="#ThisRowClass#" valign="middle"  align="Left">#Ucase(qGetProductList.PartNumber)#</td>
						<td class="tableRight #ThisRowClass#" valign="middle" align="Left">
						<cfif qGetProductList.PublicDrawing IS NOT ""><a href="#qGetProductList.PublicDrawing#" target="_blank">CAD Drawing</a></cfif>
						</td>
					</tr>
				</cfoutput></tbody>
				</table>
				</div>
				<cfmodule template="/common/modules/utils/pagination.cfm"
					StartRow="#StartRow#" SearchNum="#SearchNum#"
					RecordCount="#qGetProductListBasic.RecordCount#"
					Path="/common/modules/product/ProductListing.cfm"
					FieldList="ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#"
					Label="Products">
			</cfif>
			</div>
		</cfdefaultcase>
	</cfswitch>
</cfif>
<div style="clear:both"></div>