<cfsetting ShowDebugOutput="1">

<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">
<cfparam name="ATTRIBUTES.Mode" default="Default">
<cfparam name="ATTRIBUTES.Title" default="">
<cfparam name="ATTRIBUTES.OmitCurrentProduct" default="no">
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
	<cfif ListLast(GetBaseTemplatePath(),"\") IS "ProductListing.cfm">
		<cfif (ListLen(CGI.HTTP_Referer,"/") GTE "2" and FindNoCase("salco",ListGetAt(CGI.HTTP_Referer,2,"/")) IS "0") or CGI.HTTP_Referer IS "">
			<cfinvoke component="/com/ContentManager/CategoryHandler" 
				method="GetCategoryBasicDetails" 
				returnVariable="qGetCategoryBasicDetails"
				CategoryID="#ATTRIBUTES.ProductFamilyID#">
			<cflocation url="#APPLICATION.utilsObj.parseCategoryUrl(qGetCategoryBasicDetails.CategoryAlias)#" addtoken="No">
		</cfif>
	</cfif>
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
				<cfset StartRow=1>
			</cfif>
			<cfif Val(StartRow) LTE "0">
				<cfset StartRow=1>
			</cfif>
			<cfif Val(StartRow) GT Val(qGetProductListBasic.RecordCount)>
				<cfset StartRow=1>
			</cfif>
			<cfif ShowAll IS "1">
				<cfset StartRow=1>
				<cfset SearchNum=999>
			</cfif>
			
			<cfinvoke component="/com/product/productFamilyHandler" 
				method="GetProductList" 
				returnVariable="qGetProductList"
				ProductFamilyID="#ATTRIBUTES.ProductFamilyID#"
				LocaleID="#ATTRIBUTES.LocaleID#"
				LanguageID="#ATTRIBUTES.LanguageID#"
				StartRow="#StartRow#"
				MaxRows="#SearchNum#">
			
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
			
			<cfquery name="qTestIfDocument" dbtype="query">
				select * from qGetProductList
				where PublicDrawing <> ''
			</cfquery>
			
			<cfoutput><div id="pagList_#ATTRIBUTES.ProductFamilyID#" class="pagList"></cfoutput>
			<cfif qGetProductList.RecordCount GT "0">
				<cfoutput><div id="ProductListing_#ATTRIBUTES.ProductFamilyID#"></cfoutput>
				<table class="featuredDownloads" border="0" cellspacing="0" cellpadding="0">
                <thead>
				<tr>
					<th align="left" valign="middle">Product</th>
					<th align="center" valign="middle" width="110">Part No.</th>
					<cfif qTestIfDocument.RecordCount GT "0"><th align="center" valign="middle" width="110">Document(s)</th></cfif>
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
						<td class="tableLeft #ThisRowClass#" valign="middle"><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductList.CategoryAlias)#?StartRow=#StartRow#">#qGetProductList.CategoryNameDerived#</a></td>
						<td class="#ThisRowClass#" valign="middle"  align="left">#Ucase(qGetProductList.PartNumber)#</td>
						<cfif qTestIfDocument.RecordCount GT "0">
							<td class="tableRight #ThisRowClass#" valign="middle" align="left">
							<cfif qGetProductList.PublicDrawing IS NOT "" and FileExists(ExpandPath(qGetProductList.PublicDrawing))><a href="#APPLICATION.utilsObj.GetFreewheelLink(qGetProductList.PublicDrawing)#" target="_blank">CAD Drawing</a><cfelse>&nbsp;</cfif>
							</td>
						</cfif>
					</tr>
				</cfoutput></tbody>
				</table>
				</div>
				<cfoutput>
					<cfif Val(ShowAll) IS "0">
						<cfset AdditionalText="<a href=""/common/modules/product/ProductListing.cfm?ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#&ShowAll=1"">Show All</a>">
					<cfelse>
						<cfset AdditionalText="">
						<div class="pagination"><p><a href="/common/modules/product/ProductListing.cfm?ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#&ShowAll=0">Show As Paginated Results</a></p></div>
					</cfif>
				</cfoutput>
				
				<cfmodule template="/common/modules/utils/pagination.cfm"
					StartRow="#StartRow#" SearchNum="#SearchNum#"
					RecordCount="#qGetProductListBasic.RecordCount#"
					Path="/common/modules/product/ProductListing.cfm"
					FieldList="ProductFamilyID=#URLEncodedFormat(ATTRIBUTES.ProductFamilyID)#"
					Label="Products"
					AdditionalText="#AdditionalText#">
			<cfelse>
				<cfif ATTRIBUTES.OmitCurrentProduct>
				
				<cfelse>
					<h3>Product List Coming Soon</h3>
				</cfif>
			</cfif>
			</div>
		</cfdefaultcase>
	</cfswitch>
</cfif>
<div style="clear:both"></div>