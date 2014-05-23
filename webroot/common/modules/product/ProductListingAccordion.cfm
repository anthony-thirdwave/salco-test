<cfparam name="ATTRIBUTES.ParentProductFamilyID" default="-1">
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

<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
	SELECT     DisplayOrder
	FROM         t_Category
	WHERE     CategoryID=<cfqueryparam value="#Val(ATTRIBUTES.ParentProductFamilyID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery name="GetCache" datasource="#APPLICATION.DSN#">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category
	WHERE     DisplayOrder LIKE <cfqueryparam value="#GetDisplayOrder.DisplayOrder#%" cfsqltype="CF_SQL_CARCHAR">
</cfquery>
<cfset ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductListingAccordion_v1_#ATTRIBUTES.ParentProductFamilyID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">

<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or 1>
	<cfsaveContent Variable="FileContents">
		<cfinvoke component="/com/product/productFamilyHandler" 
			method="GetProductFamilyList" 
			returnVariable="qGetProductFamilyList"
			ParentProductFamilyID="#ATTRIBUTES.ParentProductFamilyID#"
			LocaleID="#ATTRIBUTES.LocaleID#"
			LanguageID="#ATTRIBUTES.LanguageID#">
		
		<cfif qGetProductFamilyList.RecordCount GT "0">
			<script type="text/javascript">
				$(document).ready(function() {
					/*$("html").addClass("js");
						$.fn.accordion.defaults.container = false; 
						$(function() {
							$("#acc3").accordion({initShow : "#current"});
							$("html").removeClass("js");
							return false;
					});*/
					/* $("#sub").accordion({
					  obj: "div", 
					  wrapper: "div", 
					  el: ".h", 
					  head: "h4", 
					  next: "div", 
					  initShow : "div.outer:first",
					  event : "click",
					  collapsible : true, // {true} - makes the accordion fully collapsible, {false} - forces one section to be open at any time
					  standardExpansible : true //if {true}, the functonality will be standard Expand/Collapse without 'accordion' effect
					}); */
				});
			</script>
			
			<p>Select categories below to expand for more information.</p>
			
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
		</cfif>
	</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
