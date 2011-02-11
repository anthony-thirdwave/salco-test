<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">
<cfparam name="ATTRIBUTES.Mode" default="Default">

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
		method="GetProductList" 
		returnVariable="qGetProductList"
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
			<cfif Val(StartRow) GT Val(qGetProductList.RecordCount)>
				<CFSET StartRow=1>
			</cfif>
			<div id="pagList">
			<cfif qGetProductList.RecordCount GT "0">
				<cfoutput><div id="ProductListing_#ATTRIBUTES.ProductFamilyID#"></cfoutput>
				<table>
				<tr><th>Product</th><th>Part No.</th><th>Document(s)</th></tr>
				<cfoutput query="qGetProductList" startrow="#StartRow#" maxrows="#SearchNUM#">
					<tr>
						<td><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductList.CategoryAlias)#">#qGetProductList.CategoryNameDerived#</a></td>
						<td>#Ucase(qGetProductList.PartNumber)#</td>
						<td>
						<cfif qGetProductList.PublicDrawing IS NOT ""><a href="#qGetProductList.PublicDrawing#" target="_blank">Public Drawing</a></cfif>
						</td>
					</tr>
				</cfoutput>
				</table>
				</div>
				<cfmodule template="/common/modules/utils/pagination.cfm"
					StartRow="#StartRow#" SearchNum="#SearchNum#"
					RecordCount="#qGetProductList.RecordCount#"
					Path="/common/modules/product/ProductListing.cfm"
					FieldList="ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#"
					Label="Products">
			</cfif></div>
		</cfdefaultcase>
	</cfswitch>
</cfif>
