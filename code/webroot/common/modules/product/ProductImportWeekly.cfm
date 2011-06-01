<cfsetting RequestTimeOut="60000">
<cfparam name="ATTRIBUTES.RangeDays" default="1">

<cfif 1>
	<cfset My_NewArray=ArrayNew(1)>
    <cfset My_NewArray[1]="/FileName"/>
    <cfset My_NewArray[2]="#ExpandPath('/resources/external/ProductUpdates/ChesserReport.xlsx')#"/>
    <cfdump var="#My_NewArray#">
	<cfset objConsole=CreateObject("java","com.salco.productsHierarchyDataImport.ProductsHierarchyData_importConsole")>
	<cfdump var="#objConsole#"/>
	<cfset result=objConsole.importStatus(My_NewArray)>
	<cfoutput>The result is: #result#</cfoutput>
</cfif>

<cfset DateToUse=DateAdd("d",0-Val(ATTRIBUTES.RangeDays),Now())>

<cfquery name="GetProductsToImport">
	select * from t_ProductsHierarchyData 
	where
		Update_Datetime >= <cfqueryparam value="#DateToUse#" cfsqltype="cf_sql_timestamp">
</cfquery>

<cfdump var="#GetProductsToImport#">

<cfoutput query="GetProductsToImport">
	<cfquery name="GetTargetProduct">
		select * from qry_GetProduct 
		where 
			ProductFamilyAttributeID=<cfqueryparam value="10" cfsqltype="cf_sql_integer"> and 
			AttributeValue=<cfqueryparam value="#GetProductsToImport.fPartNo#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfset ThisFile=GetProductsToImport.FCCadFile2>
	<cfset ThisFile=Replace(ThisFile,"W:\DWF Parts","/resources/external/dwfparts")>
	<cfset ThisFile=Replace(ThisFile,"\","/","All")>
	<cfset Source=ReplaceNoCase(GetProductsToImport.FCCadFile2,"W:\","#ListDeleteAt(APPLICATION.RootPath,ListLen(APPLICATION.RootPath,'\'),'\')#\resources\w\")>
	<cfif FileExists(Source)>
		<cfset ThisFileSize="#GetFileInfo(Source).Size#">
	<cfelse>
		<cfset ThisFileSize="">
	</cfif>
	<hr>
	Importing #GetProductsToImport.FPartNo#<br>
	ThisFile: #ThisFile# (#ThisFileSize#)<br>
	Source: #Source#
	
	<cfif GetTargetProduct.RecordCount GTE "1">
		<!--- update product --->
		<cfloop query="GetTargetProduct">
			<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
			<cfset MyCategory.Constructor(Val(GetTargetProduct.CategoryID))>
			<cfset MyCategory.SetProperty("CategoryName",GetProductsToImport.fdescript)>
			<cfset MyCategory.Save(APPLICATION.WebrootPath,1)>
			
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfset MyProduct.Constructor(Val(GetTargetProduct.CategoryID),APPLICATION.DefaultLanguageID)>
			<cfset MyProduct.SetProperty("ProductDescription",Trim(GetProductsToImport.FSTDMemo))>
			<cfset MyProduct.SetProperty("PublicDrawing",Trim(ThisFile))>
			<cfset MyProduct.SetProperty("PublicDrawingSize",Trim(ThisFileSize))>
			<cfset MyProduct.SetProperty("PartNumber",GetProductsToImport.FPartNo)>
			<cfset MyProduct.Save(APPLICATION.WebrootPath,1)>
		</cfloop>
	<cfelse>
		<!--- new product --->
		
		<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
		<cfset MyCategory.Constructor(-1)>
		<cfset MyCategory.SetProperty("CategoryName",GetProductsToImport.fdescript)>
		<cfset MyCategory.SetProperty("CategoryActive",1)>
		<cfset MyCategory.SetProperty("ShowInNavigation",1)>
		<cfset MyCategory.SetProperty("SourceID",GetProductsToImport.ID)>
		<cfset MyCategory.SetProperty("CategoryTypeID",64)>
		<cfset MyCategory.SetProperty("ParentID",5731)>
		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="CreateAlias"
			Name="#GetProductsToImport.FPartNo#"
			CategoryID="-1"
			returnVariable="thisCategoryAlias">
		<cfset MyCategory.SetProperty("CategoryAlias",thisCategoryAlias)>
		<cfset MyCategory.Save(APPLICATION.WebrootPath,1)>
		<cfset ThisCategoryID=MyCategory.GetProperty("CategoryID")>

		<cfset MyProduct=CreateObject("component","com.Product.Product")>
		<cfset MyProduct.Constructor(Val(ThisCategoryID),APPLICATION.DefaultLanguageID)>
		<cfset MyProduct.SetProperty("ProductDescription",Trim(GetProductsToImport.FSTDMemo))>
		<cfset MyProduct.SetProperty("PublicDrawing",Trim(ThisFile))>
		<cfset MyProduct.SetProperty("PublicDrawingSize",Trim(ThisFileSize))>
		<cfset MyProduct.SetProperty("PartNumber",GetProductsToImport.FPartNo)>
		<cfset MyProduct.Save(APPLICATION.WebrootPath,1)>
		
		<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
		<cfset MyCategoryLocale.Constructor(-1)>
		<cfset MyCategoryLocale.SetProperty("CategoryID",ThisCategoryID)>
		<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
		<cfset MyCategoryLocale.SetCategoryTypeID(64)>
		
		<cfset MyCategoryLocale.SetProperty("DefaultCategoryLocale",1)>
		<cfset MyCategoryLocale.SetProperty("CategoryLocaleActive",1)>
		<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
		<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,1)>
	</cfif>
	
</cfoutput>