<cfsetting RequestTimeOut="60000">
<cfparam name="ATTRIBUTES.RangeDays" default="7">
<cfset Commit="1">

<cfif 1>
	<cfinclude template="ProductImportWeekly_SSIS.cfm">
</cfif>

<cfset DateToUse=DateAdd("d",0-Val(ATTRIBUTES.RangeDays),Now())>

<cfquery name="GetProductsToImport" datasource="#APPLICATION.DSN#">
	select * from t_ProductsHierarchyData 
	where
		Update_Datetime >= <cfqueryparam value="#DateToUse#" cfsqltype="cf_sql_timestamp">
	ORDER BY import_datetime
</cfquery>

<cfdump var="#GetProductsToImport#" expand="no">

<cfset sAttributeID=StructNew()>
<cfset StructInsert(sAttributeID,"ProductDescription","7",1)><!--- ProductDescription --->
<cfset StructInsert(sAttributeID,"PartNumber","10",1)><!--- PartNumber --->
<cfset StructInsert(sAttributeID,"PublicDrawing","12",1)><!--- PublicDrawing --->
<cfset StructInsert(sAttributeID,"PublicDrawingSize","23",1)><!--- PublicDrawingSize --->

<cfset lAttributeID="7,10,12,23">

<cfset sAttribute=StructNew()>
<cfloop index="ThisKey" list="#StructKeyList(sAttributeID)#">
	<cfset StructInsert(sAttribute,sAttributeID[thisKey],ThisKey,1)>
</cfloop>

<cfoutput query="GetProductsToImport">
	<cfquery name="GetTargetProduct" datasource="#APPLICATION.DSN#">
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
	Source: #Source#<br>
	
	<cfset ThisProductDescription="#Trim(GetProductsToImport.FSTDMemo)#">
	<cfset ThisPublicDrawing="#Trim(ThisFile)#">
	<cfset ThisPublicDrawingSize="#Trim(ThisFileSize)#">
	<cfset ThisPartNumber="#Trim(GetProductsToImport.FPartNo)#">
	
	<cfif GetTargetProduct.RecordCount GTE "1">
		<!--- update product --->
		
		<cfloop query="GetTargetProduct">
			<cfif Commit>
				
				<cfset ThisWasUpdated="0">
				
				<cfif hash(GetTargetProduct.CategoryName) IS NOT Hash(Trim(GetProductsToImport.fdescript))>
					<cfquery name="UpdateCategory" datasource="#APPLICATION.DSN#">
						update t_Category set CategoryName=<cfqueryparam value="#GetProductsToImport.fdescript#" cfsqltype="cf_sql_varchar">
						where CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset ThisWasUpdated="1">
				</cfif>
				
				<cfloop index="ThisID" list="#lAttributeID#">
					<cfset ThisValue=Evaluate("This#sAttribute[ThisID]#")>
					<cfquery name="test" datasource="#APPLICATION.DSN#">
						select * from t_ProductAttribute 
						WHERE 
						CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer"> AND 
						LanguageID=<cfqueryparam value="#Val(APPLICATION.DefaultLanguageID)#" cfsqltype="cf_sql_integer"> AND 
						ProductFamilyAttributeID=<cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<cfif Hash(ThisValue) IS NOT hash(test.AttributeValue)>
						<cfif test.RecordCount GT "0">
							<cfquery name="update" datasource="#APPLICATION.DSN#">
								update t_ProductAttribute Set
								AttributeValue=N'#Trim(ThisValue)#'
								WHERE 
								CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer"> AND 
								LanguageID=<cfqueryparam value="#Val(APPLICATION.DefaultLanguageID)#" cfsqltype="cf_sql_integer"> AND 
								ProductFamilyAttributeID=<cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">
							</cfquery>
						<cfelse>
							<cfquery name="isnert" datasource="#APPLICATION.DSN#">
								INSERT INTO t_ProductAttribute 
								(CategoryID, LanguageID, ProductFamilyAttributeID, AttributeValue)
								VALUES
								(<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#Val(APPLICATION.DefaultLanguageID)#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">, N'#Trim(ThisValue)#')
							</cfquery>
						</cfif>
						<cfset ThisWasUpdated="1">
					</cfif>
				</cfloop>
				
				<cfif ThisWasUpdated>
					<cfquery name="UpdateDateStamp" datasource="#APPLICATION.DSN#">
						update t_ProductsHierarchyData 
						set import_Datetime=<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
						Where ID=<cfqueryparam value="#GetProductsToImport.ID#" cfsqltype="cf_sql_integer">
					</cfquery>
				
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="1"
						Entity="Category"
						KeyID="#Val(GetTargetProduct.CategoryID)#"
						Operation="modify"
						EntityName="#Trim(GetProductsToImport.fdescript)#">
				</cfif>
				
			</cfif>
			UPDATE #GetProductsToImport.fdescript# (#Val(GetTargetProduct.CategoryID)#) ThisWasUpdated: #ThisWasUpdated#<br>
		</cfloop>
		
	<cfelse>
		<!--- new product --->
		<cfif Commit>
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

			<cfquery name="UpdateDataStamp" datasource="#APPLICATION.DSN#">
				update t_ProductsHierarchyData 
				set import_Datetime=<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
				Where ID=<cfqueryparam value="#GetProductsToImport.ID#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		CREATE #GetProductsToImport.fdescript# (#Val(ThisCategoryID)#)<br>
	</cfif>
	
</cfoutput>