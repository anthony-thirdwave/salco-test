<cfsetting RequestTimeOut="60000">

<cfquery name="GetDetail" datasource="#APPLICATION.DSN#" maxrows="20">
	SELECT  t_ProductsHierarchyDataLink.CategoryID, t_ProductsHierarchyDataLink.ProductNum, t_ProductsHierarchyData.*
	FROM    t_ProductsHierarchyDataLink INNER JOIN
		    t_ProductsHierarchyData ON t_ProductsHierarchyDataLink.ProductNum = t_ProductsHierarchyData.fpartno
	--where import_datetime is null
	where CategoryID=6431
	ORDER BY import_datetime desc
</cfquery>

<cfset REQUEST.sNewCategoryID=StructNew()>

<cfquery name="GetExisting" datasource="#APPLICATION.DSN#">
	select * from t_ProductsHierarchyData
</cfquery>

<cfoutput query="GetExisting">
	<cfset StructInsert(REQUEST.sNewCategoryID,ID,Val(newCategoryID),1)>
</cfoutput>

<cfset ThisProductFamilyID=64>

<cfoutput query="GetDetail">
	<cfif Val(GetDetail.NewCategoryID) GT "0">
		<cfset ThisCategoryID=Val(GetDetail.NewCategoryID)>
	<cfelse>
		<cfset ThisCategoryID="-1">
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
	
	<cfset MyCategory.SetProperty("CategoryName",Trim(GetDetail.fdescript))>
	<cfset MyCategory.SetProperty("CategoryActive",1)>
	<cfset MyCategory.SetProperty("ShowInNavigation",1)>
	<cfset MyCategory.SetProperty("SourceID",GetDetail.ID)>
	<cfset MyCategory.SetProperty("ParentID",GetDetail.CategoryID)>
	
	<cfset MyCategory.SetProperty("CategoryTypeID",ThisProductFamilyID)>
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="CreateAlias"
		Name="#Trim(GetDetail.FPartNo)#"
		CategoryID="#Val(ThisCategoryID)#"
		returnVariable="thisCategoryAlias">
	<cfset MyCategory.SetProperty("CategoryAlias",thisCategoryAlias)>
	
	<cfset MyCategory.Save(APPLICATION.WebrootPath,1)>
	<cfset ThisCategoryID=MyCategory.GetProperty("CategoryID")>
	
	<cfset MyProduct=CreateObject("component","com.Product.Product")>
	<cfset MyProduct.Constructor(Val(ThisCategoryID),APPLICATION.DefaultLanguageID)>
	<cfset MyProduct.SetProperty("CategoryID",Val(ThisCategoryID))>
	<cfset MyProduct.SetProperty("ProductDescription",Trim(GetDetail.FSTDMemo))>
	<cfset MyProduct.SetProperty("PublicDrawing",Trim(GetDetail.FCCadFile2))>
	<cfset MyProduct.SetProperty("PartNumber",Trim(GetDetail.FPartNo))>
	<cfset MyProduct.Save(APPLICATION.WebrootPath,1)>
	
	<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
	<cfset MyCategoryLocale.Constructor(Val(ThisCategoryLocaleID))>
	<cfset MyCategoryLocale.SetProperty("CategoryID",ThisCategoryID)>
	<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
	<cfset MyCategoryLocale.SetCategoryTypeID(ThisProductFamilyID)>
	
	<cfset MyCategoryLocale.SetProperty("DefaultCategoryLocale",1)>
	<cfset MyCategoryLocale.SetProperty("CategoryLocaleActive",1)>
	<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
	<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,1)>
	
	<cfset StructInsert(REQUEST.sNewCategoryID,GetDetail.ID,ThisCategoryID,1)>
	
	<cfquery name="UpdateImport" datasource="#APPLICATION.DSN#">
		update t_ProductsHierarchyData
		set
		newCategoryID=#Val(ThisCategoryID)#,
		import_datetime=getDate()
		where ID=#GetDetail.ID#
	</cfquery>
</cfoutput>
Success!