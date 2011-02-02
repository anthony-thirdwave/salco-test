<cfsetting showdebugoutput="0" RequestTimeOut="60000">
<cfparam name="URL.NodeID" default="-1000">

<cfquery name="GetDetail" datasource="#APPLICATION.DSN#">
	select * from qry_GetProductsProto where NodeID=<cfqueryparam value="#val(URL.NodeID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfset REQUEST.sNewCategoryID=StructNew()>

<cfquery name="GetExisting" datasource="#APPLICATION.DSN#">
	select * from t_ProductsHierarchy
</cfquery>

<cfoutput query="GetExisting">
	<cfset StructInsert(REQUEST.sNewCategoryID,ID,CategoryID,1)>
</cfoutput>

<cfif Val(GetDetail.CategoryID) GT "0">
	<cfset ThisCategoryID=Val(GetDetail.CategoryID)>
<cfelse>
	<cfset ThisCategoryID="-1">
</cfif>

<cfif Trim(GetDetail.ID) IS "">
	<cfset ThisProductFamilyID=62>
<cfelse>
	<cfset ThisProductFamilyID=64>
</cfif>

<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
<cfset MyCategory.Constructor(Val(ThisCategoryID))>
<cfif ThisCategoryID GT "0">
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetCategoryLocaleID"
		returnVariable="ThisCategoryLocaleID"
		CategoryID="#ThisCategoryID#"
		LocaleID="#APPLICATION.DefaultLocaleID#">
<cfelse>
	<cfset ThisCategoryLocaleID="-1">
</cfif>
<cfif ThisProductFamilyID IS "62">
	<cfset MyCategory.SetProperty("CategoryName",GetDetail.NodeName)>
<cfelse>
	<cfset MyCategory.SetProperty("CategoryName",GetDetail.fdescript)>
</cfif>
<cfset MyCategory.SetProperty("CategoryActive",1)>
<cfset MyCategory.SetProperty("ShowInNavigation",1)>
<cfset MyCategory.SetProperty("SourceID",GetDetail.NodeID)>
<cfset MyCategory.SetProperty("ParentID",REQUEST.sNewCategoryID[GetDetail.NodeParentID])>
<cfset MyCategory.SetProperty("CategoryTypeID",ThisProductFamilyID)>
<cfif ThisProductFamilyID IS "64">
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="CreateAlias"
		Name="#GetDetail.FPartNo#"
		CategoryID="#Val(ThisCategoryID)#"
		returnVariable="thisCategoryAlias">
	<cfset MyCategory.SetProperty("CategoryAlias",thisCategoryAlias)>
</cfif>

<cfset MyCategory.Save(APPLICATION.WebrootPath,1)>
<cfset ThisCategoryID=MyCategory.GetProperty("CategoryID")>

<cfif ThisProductFamilyID IS "62">
	<cfset MyProductFamily=CreateObject("component","com.Product.ProductFamily")>
	<cfset MyProductFamily.Constructor(Val(ThisCategoryID),APPLICATION.DefaultLanguageID)>
	<cfset MyProductFamily.SetProperty("CategoryID",Val(ThisCategoryID))>
	<cfset MyProductFamily.Save(APPLICATION.WebrootPath,1)>
<cfelse>
	<cfset MyProduct=CreateObject("component","com.Product.Product")>
	<cfset MyProduct.Constructor(Val(ThisCategoryID),APPLICATION.DefaultLanguageID)>
	<cfset MyProduct.SetProperty("CategoryID",Val(ThisCategoryID))>
	<cfset MyProduct.SetProperty("ProductDescription",Trim(GetDetail.FSTDMemo))>
	<cfset MyProduct.SetProperty("PublicDrawing",Trim(GetDetail.FCCadFile1))>
	<cfset MyProduct.Save(APPLICATION.WebrootPath,1)>
</cfif>

<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
<cfset MyCategoryLocale.Constructor(Val(ThisCategoryLocaleID))>
<cfset MyCategoryLocale.SetProperty("CategoryID",ThisCategoryID)>
<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
<cfset MyCategoryLocale.SetCategoryTypeID(ThisProductFamilyID)>

<cfset MyCategoryLocale.SetProperty("DefaultCategoryLocale",1)>
<cfset MyCategoryLocale.SetProperty("CategoryLocaleActive",1)>
<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,1)>

<cfset StructInsert(REQUEST.sNewCategoryID,GetDetail.NodeID,ThisCategoryID,1)>

<cfquery name="UpdateImport" datasource="#APPLICATION.DSN#">
	update t_ProductsHierarchy
	set
	CategoryID=#Val(ThisCategoryID)#,
	DateImported=getDate()
	where ID=#GetDetail.NodeID#
</cfquery>
Success!