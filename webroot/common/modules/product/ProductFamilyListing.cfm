<cfparam name="ATTRIBUTES.ParentProductFamilyID" default="-1">
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

<cfif Val(ATTRIBUTES.ParentProductFamilyID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfinvoke component="/com/product/productFamilyHandler" 
		method="GetProductFamilyList" 
		returnVariable="qGetProductFamilyList"
		ParentProductFamilyID="#ATTRIBUTES.ParentProductFamilyID#"
		LocaleID="#ATTRIBUTES.LocaleID#"
		LanguageID="#ATTRIBUTES.LanguageID#">
	
	<cfif qGetProductFamilyList.RecordCount GT "0">
		<cfswitch expression="#ATTRIBUTES.Mode#">
			<cfcase value="RolloverOutline">
				<cfset ThisDefaultImage="/common/images/template/hopper_car_01.gif">
				<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetPage" maxrows="1">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ParentProductFamilyID)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
				</cfstoredproc>
	
				<cfif IsWDDX(GetPage.CategoryLocalePropertiesPacket)>
					<cfwddx action="WDDX2CFML" input="#GetPage.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
					<cfloop index="ThisProp" list="CategoryImageRollover">
						<cfif StructKeyExists(sCategoryProperties,"#ThisProp#") AND Trim(StructFind(sCategoryProperties, "#ThisProp#")) IS NOT "">
							<cfif ThisProp IS "CategoryImageRollover">
								<cfset ThisDefaultImage=StructFind(sCategoryProperties, "#ThisProp#")>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<script type="text/javascript">
					$(document).ready(function(){
						<cfoutput>$('.parts').css("background-image", "url(#ThisDefaultImage#)");</cfoutput>
						<cfoutput query="qGetProductFamilyList">
							<cfif qGetProductFamilyList.CategoryImageRollover IS NOT "">
								$('a.roll_#qGetProductFamilyList.CategoryAlias#').mouseenter(function() {
									  $('.parts').css("background-image", "url(#qGetProductFamilyList.CategoryImageRollover#)");
									  return false;
								});
								$('a.roll_#qGetProductFamilyList.CategoryAlias#').mouseleave(function() {
									  $('.parts').css("background-image", "url(#ThisDefaultImage#)");
									  return false;
								});
							</cfif>
						</cfoutput>
					});
				</script>
				
				<div class="parts">
					<p><strong>PARTS LOCATIONS</strong></p>
					<div class="holderPartsNav">
						<p>Click on the text below car silhouette to view parts available for that section.</p>
					</div>
					<div class="partsNav">
						<ul class="nav">
							<cfoutput query="qGetProductFamilyList">
								<li><a class="roll_#qGetProductFamilyList.CategoryAlias#" href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyList.CategoryAlias)#">#qGetProductFamilyList.CategoryNameDerived#</a></li>
							</cfoutput>
						</ul>
					</div>
					<div class="clearFix"></div>
				</div>
			</cfcase>
			<cfcase value="MultiLevel">
				<cfset MyProductFamily=CreateObject("component","com.Product.ProductFamily")>
				<cfset MyProductFamily.Constructor(Val(ATTRIBUTES.ParentProductFamilyID),ATTRIBUTES.LanguageID)>
				
				<cfinvoke component="#APPLICATION.MyCategoryHandler#"
					method="GetCategoryBasicDetails"
					returnVariable="qGetCategoryBasicDetails"
					CategoryID="#ATTRIBUTES.ParentProductFamilyID#">
				<cfquery name="GetParentPageName" datasource="#APPLICATION.DSN#">
					SELECT	CategoryName
					FROM	t_Category
					WHERE	Categoryid=<cfqueryparam value="#Val(qGetCategoryBasicDetails.ParentID)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
				<cfset ParentCategoryName="#GetParentPageName.CategoryName#">
				
				<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetSiblingProductFamilies">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(ATTRIBUTES.LocaleID)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(qGetCategoryBasicDetails.ParentID)#" null="NO">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="62" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
				</cfstoredproc>
				
				<cfquery name="GetSiblingProductFamilies" dbtype="query">
					select * from GetSiblingProductFamilies order by CategoryNameDerived
				</cfquery>
				
				<div id="sub">
				<cfoutput>
					<cfif IsDefined("REQUEST.CategoryThreadList") AND ListLen(REQUEST.CategoryThreadList) GTE "4">
						<h2>#ListGetAt(REQUEST.CategoryThreadName,4)#</h2>
					<cfelse>
						<h2>#ParentCategoryName#</h2>
					</cfif>
				</cfoutput>
				
				<cfif GetSiblingProductFamilies.RecordCount GT "0">
					<nav class="product-nav">
					<ul>
					<cfoutput query="GetSiblingProductFamilies">
						<li><a href="#APPLICATION.utilsObj.parseCategoryUrl(GetSiblingProductFamilies.CategoryAlias)#" <cfif GetSiblingProductFamilies.CategoryID IS ATTRIBUTES.ParentProductFamilyID>class="active"</cfif>>#GetSiblingProductFamilies.CategoryNameDerived#</a></li>
					</cfoutput>
					</ul>
					</nav>
				</cfif>
				
				<cfif Trim(MyProductFamily.GetProperty("ProductFamilyDescription")) IS NOT "">
					<cfoutput>
						<p class="indent-bullet">#APPLICATION.utilsObj.AddBreaks(MyProductFamily.GetProperty('ProductFamilyDescription'))#</p>
					</cfoutput>
				</cfif>
				
				<cfmodule template="/common/modules/product/productListingAccordion.cfm" ParentProductFamilyID="#ATTRIBUTES.ParentProductFamilyID#">
				
				</div>
			</cfcase>
			<cfcase value="Simple">
				<dl>
				<cfoutput query="qGetProductFamilyList">
					<dt><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyList.CategoryAlias)#">#qGetProductFamilyList.CategoryNameDerived#</a></dt>
					<cfif qGetProductFamilyList.ProductFamilyDescription IS NOT "">
						<dd>#APPLICATION.utilsObj.AddBreaks(qGetProductFamilyList.ProductFamilyDescription)#</dd>
					</cfif>				
				</cfoutput>
				</dl>
			</cfcase>
			<cfdefaultcase>
				<cfoutput query="qGetProductFamilyList">
					<div class="carHolder">
						<h2><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyList.CategoryAlias)#">#qGetProductFamilyList.CategoryNameDerived#</a></h2>
						<cfif qGetProductFamilyList.CategoryImageRepresentative IS NOT "">
							<a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyList.CategoryAlias)#"><img src="#qGetProductFamilyList.CategoryImageRepresentative#" alt="#qGetProductFamilyList.CategoryNameDerived#" /></a>
						</cfif>
						<div class="carDesc">
							<cfif qGetProductFamilyList.ProductFamilyDescription IS NOT "">
								<p>#APPLICATION.utilsObj.AddBreaks(qGetProductFamilyList.ProductFamilyDescription)#</p>
							</cfif>
							<a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyList.CategoryAlias)#">More info</a>
						</div>
					</div>
				</cfoutput>
			</cfdefaultcase>
		</cfswitch>
	<cfelse>
		<cfmodule template="/common/modules/product/_ProductFamilyDetail.cfm" ProductFamilyID="#Val(ATTRIBUTES.ParentProductFamilyID)#">
		<cfmodule template="/common/modules/product/productListing.cfm" ProductFamilyID="#Val(ATTRIBUTES.ParentProductFamilyID)#" Title="Products in this Family">
	</cfif>
</cfif>