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
				
				<script type="text/javascript">
					$(document).ready(function() {
						$("html").addClass("js");
							$.fn.accordion.defaults.container = false; 
							$(function() {
								$("#acc3").accordion({initShow : "#current"});
								$("html").removeClass("js");
								return false;
						});
						$("#sub").accordion({
						  obj: "div", 
						  wrapper: "div", 
						  el: ".h", 
						  head: "h4", 
						  next: "div", 
						  initShow : "div.outer:first",
						  event : "click",
						  collapsible : true, // {true} - makes the accordion fully collapsible, {false} - forces one section to be open at any time
						  standardExpansible : true //if {true}, the functonality will be standard Expand/Collapse without 'accordion' effect
						});
					});
				</script>
				<div id="sub">
				<cfoutput>
					<h1>#REQUEST.CurrentCategoryName#</h1>
					#APPLICATION.utilsObj.AddBreaks(MyProductFamily.GetProperty('ProductFamilyDescription'))#
				</cfoutput>
				Select categories below to expand for more information.
				<div class="subordion">
					<cfoutput query="qGetProductFamilyList">
						<h4>#qGetProductFamilyList.CategoryNameDerived#</h4>
						<div class="inner">
							<div class="copyHolder">
							<cfif qGetProductFamilyList.ProductFamilyDescription IS NOT "">
								<p>#APPLICATION.utilsObj.AddBreaks(qGetProductFamilyList.ProductFamilyDescription)#</p>
							</cfif>
							<cfinvoke component="/com/product/productFamilyHandler" 
								method="GetProductFamilyList" 
								returnVariable="qGetProductFamilyListSub"
								ParentProductFamilyID="#qGetProductFamilyList.CategoryID#"
								LocaleID="#ATTRIBUTES.LocaleID#"
								LanguageID="#ATTRIBUTES.LanguageID#">
							<cfif qGetProductFamilyListSub.RecordCount GT "0">
								<cfloop query="qGetProductFamilyListSub">
									<cfif qGetProductFamilyListSub.HasSubProductFamilies>
										<cfif qGetProductFamilyListSub.HasProducts>
											<h4 class="subAcHd">#qGetProductFamilyListSub.CategoryNameDerived#</h4>
											<div class="inner subAcCont">
												<cfif qGetProductFamilyListSub.ProductFamilyDescription IS NOT "">
													<p>#APPLICATION.utilsObj.AddBreaks(qGetProductFamilyListSub.ProductFamilyDescription)#</p>
												</cfif>
												<cfmodule template="/common/modules/product/productListing.cfm" ProductID="#qGetProductFamilyListSub.CategoryID#">
											</div>
										<cfelse>
											<h4 class="subAcHd"><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyListSub.CategoryAlias)#">#qGetProductFamilyListSub.CategoryNameDerived#</a></h4>
											<cfif qGetProductFamilyListSub.ProductFamilyDescription IS NOT "">
												<p>#APPLICATION.utilsObj.AddBreaks(qGetProductFamilyListSub.ProductFamilyDescription)#</p>
											</cfif>
										</cfif>
									<cfelse>
										<h4 class="subAcHd"><a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyListSub.CategoryAlias)#">#qGetProductFamilyListSub.CategoryNameDerived#</a></h4>
									</cfif>
								</cfloop>
							<cfelse>
								<cfmodule template="/common/modules/product/productListing.cfm" ProductID="#qGetProductFamilyList.CategoryID#">
							</cfif>
							</div>
						</div>
					</cfoutput>
				</div>
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
							<a href="#APPLICATION.utilsObj.parseCategoryUrl(qGetProductFamilyList.CategoryAlias)#"><img src="#qGetProductFamilyList.CategoryImageRepresentative#" width="88" height="61" alt="#qGetProductFamilyList.CategoryNameDerived#" /></a>
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