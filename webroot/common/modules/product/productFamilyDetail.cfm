<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.SpecificationSetID" default="8000">
<cfparam name="ATTRIBUTES.Mode" default="Default">

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

<cfinvoke component="#APPLICATION.MyCategoryHandler#"
	method="GetCategoryBasicDetails"
	returnVariable="GetRootCategory"
	CategoryID="#ATTRIBUTES.CategoryID#">
	
<cfif ATTRIBUTES.Mode IS "Default" and GetRootCategory.DisplayLevel IS "2">
	<cfset ATTRIBUTES.Mode="TopLevel">
</cfif>

<cfif ATTRIBUTES.Mode IS "Default" and GetRootCategory.DisplayLevel IS "3">
	<cfset ATTRIBUTES.Mode="SecondLevel">
</cfif>

<cfswitch expression="#ATTRIBUTES.Mode#">
	<cfcase value="TopLevel">
		<cfmodule template="/common/modules/product/productFamilyListing.cfm" ParentProductFamilyID="#ATTRIBUTES.CategoryID#" Mode="TopLevel">
	</cfcase>
	<cfcase value="SecondLevel">
		<cfmodule template="/common/modules/product/_ProductFamilyDetail.cfm" ProductFamilyID="#ATTRIBUTES.CategoryID#">
		<cfmodule template="/common/modules/product/productFamilyListing.cfm" ParentProductFamilyID="#ATTRIBUTES.CategoryID#" Mode="RolloverOutline">
	</cfcase>
	<cfdefaultcase>
		<cfmodule template="/common/modules/product/productFamilyListing.cfm" ParentProductFamilyID="#ATTRIBUTES.CategoryID#" Mode="MultiLevel">
	</cfdefaultcase>
</cfswitch>