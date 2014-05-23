<cfcomponent>
	<cffunction name="GetProductFamilyID" returntype="numeric" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" 
			ThisCategoryID="#ARGUMENTS.ProductID#" NameList="" IDList="#ARGUMENTS.ProductID#">
		<cfquery name="GetProductFamilyID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_category
			Where CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#IDList#" list="yes">) and 
			CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="62">
			Order by DisplayOrder Desc
		</cfquery>
		<cfif GetProductFamilyID.RecordCount IS "1">
			<cfreturn GetProductFamilyID.CategoryID>
		<cfelse>
			<cfreturn -1>
		</cfif>
	</cffunction>
	
	<cffunction name="ProductExist" returntype="boolean" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfargument name="LanguageID" default="" type="numeric" required="true">
		<cfquery name="TestExistInLanguage" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT     *
			FROM         t_ProductAttribute
			WHERE     
			CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID)#"> AND 
			ProductFamilyAttributeID = <cfqueryparam cfsqltype="cf_sql_integer" value="390"> AND 
			LanguageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
		</cfquery>
		<cfif TestExistInLanguage.RecordCount IS "1">
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="GetProductFamilyAlias" returntype="string" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" 
			ThisCategoryID="#ARGUMENTS.ProductID#" NameList="" IDList="#ARGUMENTS.ProductID#">
		<cfquery name="getBranch" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryAlias from t_category
			Where CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#IDList#" list="yes">) and CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="62">
			Order by DisplayOrder Desc
		</cfquery>
		<cfif GetBranch.RecordCount IS "1">
			<cfreturn GetBranch.CategoryAlias>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="GetProductNameFromAlias" returntype="string" output="false" access="remote">
		<cfargument name="ProductAlias" default="" type="string" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		<cfset ReturnValue="">
		<cfquery name="GetProductID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_category
			WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.ProductAlias)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
		</cfquery>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetPage" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetProductID.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="Yes">
		</cfstoredproc>
		<cfset ReturnValue=GetPage.CategoryNameDerived>
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetProductColorID" returntype="numeric" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfquery name="getBranch" datasource="#APPLICATION.DSN#" maxrows="1">
			select PropertiesPacket from
			t_Category INNER JOIN
	                      t_Properties ON t_Category.PropertiesID = t_Properties.PropertiesID
			where categoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ProductID)#">
		</cfquery>
		<cfif IsWDDX(getBranch.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#getBranch.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ColorID")>
				<cfreturn sProperties.ColorID>
			</cfif>
		</cfif>
		<cfreturn -1>
	</cffunction>
	
	<cffunction name="GetProductInProductFamily" returntype="string" output="false">
		<cfargument name="ProductFamilyID" default="" type="numeric" required="true">
		<CF_getbranch item="#ARGUMENTS.ProductFamilyID#" 
			DataSource="#APPLICATION.DSN#" 
			table="t_Category" 
			Column="CategoryID" 
			ParentColumn="ParentID">
		<cfif Branch is not "">
			<cfquery name="getBranch" datasource="#APPLICATION.DSN#">
				select CategoryID from t_category
				Where CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#branch#" list="yes">) and 
				CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="64">
				Order by DisplayOrder
			</cfquery>
			<cfif GetBranch.RecordCount GT "0">
				<cfreturn ValueList(getBranch.CategoryID)>
			</cfif>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="GetProductFamilyProducts" returntype="query" output="false" access="remote">
		<cfargument name="ProductFamilyAlias" default="" type="string" required="true">
		<cfargument name="LocaleID" default="" type="string" required="true">
		<cfargument name="LanguageID" default="" type="string" required="true">
		
		<cfquery name="TestType" datasource="#APPLICATION.DSN#" maxrows="1">
			select DisplayOrder,CategoryTypeID,SourceID from t_category 
			WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.ProductFamilyAlias)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
		</cfquery>
		
		<cfif TestType.CategoryTypeID IS "162">
			<cfquery name="GetCategoryDO" datasource="#APPLICATION.DSN#" maxrows=1 dbtype="ODBC">
				SELECT DisplayOrder FROM t_Category
				WHERE CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(TestType.SourceID)#">
			</cfquery>
			<cfset ThisDisplayOrder="#GetCategoryDO.DisplayOrder#">
		<cfelse>
			<cfset ThisDisplayOrder="#TestType.DisplayOrder#">
		</cfif>
		<cfoutput>ThisDisplayOrder: #ThisDisplayOrder#</cfoutput>
			
		<cfset ColumnList="ProductID,ProductAlias,ProductName,ProductShortName,ProductBullet1,ProductBullet2,ProductBullet3,ProductBullet4,ProductBullet5,ProductBullet6,ProductBullet7,ProductBullet8,ProductRolloverURL,ProductThumbnailURL,AvailableConsoles">
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfif ThisDisplayOrder IS NOT "">
			<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetImageIndex">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="#ThisDisplayOrder#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="64" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
			</cfstoredproc>
			
			<cfoutput query="GetImageIndex">
				<cfset QueryAddRow(qReturn,1)>
				<cfset QuerySetCell(qReturn,"ProductID",CategoryID)>
				<cfset QuerySetCell(qReturn,"ProductAlias",CategoryAlias)>
				<cfset QuerySetCell(qReturn,"ProductName",CategoryNameDerived)>
				
				<cfinvoke component="/com/product/producthandler" method="ProductExist" returnVariable="ProductExist"
					ProductID="#CategoryID#"
					LanguageID="#ARGUMENTS.LanguageID#">
				<cfset MyProduct=CreateObject("component","com.Product.Product")>
				<cfif ProductExist>
					<cfset MyProduct.Constructor(Val(CategoryID),ARGUMENTS.LanguageID)>
				<cfelse>
					<cfset MyProduct.Constructor(Val(CategoryID),APPLICATION.DefaultLanguageID)>
				</cfif>
				
				<cfif MyProduct.GetProperty("ProductShortName") IS NOT "">
					<cfset QuerySetCell(qReturn,"ProductShortName",MyProduct.GetProperty("ProductShortName"))>
				<cfelse>
					<cfset QuerySetCell(qReturn,"ProductShortName",CategoryNameDerived)>
				</cfif>
				
				<cfif MyProduct.GetProperty("ProductThumbnailPath") IS NOT "">
					<cfif APPLICATION.Production>
						<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.salcoproducts.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
					<cfelse>
						<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.staging.salco.01.thirdwaveweb.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
					</cfif>
				</cfif>
				
				<cfif MyProduct.GetProperty("ProductThumbnailHoverPath") IS NOT "">
					<cfif APPLICATION.Production>
						<cfset QuerySetCell(qReturn,"ProductRolloverURL","http://www.salcoproducts.com#MyProduct.GetProperty('ProductThumbnailHoverPath')#")>
					<cfelse>
						<cfset QuerySetCell(qReturn,"ProductRolloverURL","http://www.staging.salco.01.thirdwaveweb.com#MyProduct.GetProperty('ProductThumbnailHoverPath')#")>
					</cfif>
				</cfif>
				
				<cfset aFeature=MyProduct.GetProperty("aProductBullet")>
				<cfloop index="i" from="1" to="#ArrayLen(aFeature)#" step="1">
					<cfif i lte "8">
						<cfset QuerySetCell(qReturn,"ProductBullet#i#",REQUEST.ReplaceMarks(aFeature[i].TextBlock))>
					</cfif>
				</cfloop>
				
				<cfif MyProduct.GetConsoleProductFamilyID() GT "0">
					<cfset QuerySetCell(qReturn,"AvailableConsoles",MyProduct.GetlConsoleAlias())>
				</cfif>
			</cfoutput>
		</cfif>
		
		<cfreturn qReturn>
	</cffunction>
	
	<cffunction name="GetProductLanguages" returntype="query" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfquery name="GetLanguages" datasource="#APPLICATION.DSN#">
			select LabelID as LanguageID, LabelName as LanguageName from 
			dbo.t_Label INNER JOIN
			dbo.t_ProductAttribute ON dbo.t_Label.LabelID = dbo.t_ProductAttribute.LanguageID
			Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID)#"> and 
			ProductFamilyAttributeID=<cfqueryparam cfsqltype="cf_sql_integer" value="390">
			order by LanguageName
		</cfquery>
		<cfreturn GetLanguages>
	</cffunction>
	
	<cffunction name="GetLinkedProductPage" returntype="query" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		<cfargument name="CategoryID" default="" type="numeric" required="true" Hint="CategoryID of forward facing page to find product display sub-page.">
		
		<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" ThisCategoryID="#ARGUMENTS.CategoryID#" NameList="" IDList="#ARGUMENTS.CategoryID#">

		<cfquery name="GetDOPrime" datasource="#APPLICATION.DSN#" maxrows="1"><!--- First look in ancestors to find most closest Content w/Product Family Page --->
			select CategoryID from t_Category Where CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#IDList#" list="yes">) and CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="162"> order by DisplayOrder Desc
		</cfquery>
		
		<cfquery name="GetDO" datasource="#APPLICATION.DSN#">
			select DisplayOrder from t_Category Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(GetDOPrime.CategoryID)#">
		</cfquery>
		
		<cfquery name="GetPage" datasource="#APPLICATION.DSN#" maxrows="1"><!--- Look underneath that page for the correct Page with a product detail page--->
			select CategoryID from qry_GetCategory
			Where DisplayOrder like <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetDO.DisplayOrder#%"> and CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="164"> and SourceID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID)#">
			Order by DisplayOrder
		</cfquery>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetPage2" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetPage.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
		</cfstoredproc>
		
		<cfreturn GetPage2>
	</cffunction>
	
	<cffunction name="GetLinkedProductFamilyPage" returntype="query" output="false">
		<cfargument name="ProductFamilyID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		<cfargument name="CategoryID" default="" type="numeric" required="true" Hint="CategoryID of forward facing page to find product display sub-page.">
		
		<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" ThisCategoryID="#ARGUMENTS.CategoryID#" NameList="" IDList="#ARGUMENTS.CategoryID#">

		<cfquery name="GetDOPrime" datasource="#APPLICATION.DSN#" maxrows="1"><!--- First look in ancestors to find most closest Content w/Product Family Page --->
			select CategoryID from t_Category Where CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#IDList#" list="Yes">) and CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="162"> order by DisplayOrder Desc
		</cfquery>
		
		<cfquery name="GetDO" datasource="#APPLICATION.DSN#">
			select DisplayOrder from t_Category Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(GetDOPrime.CategoryID)#">
		</cfquery>
		
		<cfquery name="GetPage" datasource="#APPLICATION.DSN#" maxrows="1"><!--- Look underneath that page for the correct Page with a product detail page--->
			select CategoryID from t_Category
			Where DisplayOrder like <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetDO.DisplayOrder#%"> and CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="162"> and SourceID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductFamilyID)#">
			Order by DisplayOrder
		</cfquery>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetPage2" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetPage.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
		</cfstoredproc>
		
		<cfreturn GetPage2>
	</cffunction>
	
	<cffunction name="GetProductFeature" returntype="query" output="false" access="remote">
		<cfargument name="ProductAlias" default="" type="string" required="true">
		<cfargument name="LanguageID" default="100" type="numeric" required="true">
		
		<cfquery name="GetID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_Category Where 
			CategoryAlias IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="prod_#Trim(ARGUMENTS.ProductAlias)#,#Trim(ARGUMENTS.ProductAlias)#" list="yes">) and 
			CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="64">
			order by CategoryAlias
		</cfquery>
		
		<cfset ColumnList="ItemValue">
		
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfset aFeature=ArrayNew(1)>
		
		<cfinvoke component="/com/product/producthandler" method="ProductExist" returnVariable="ProductExist"
			ProductID="#Val(GetID.CategoryID)#"
			LanguageID="#ARGUMENTS.LanguageID#">
		<cfset MyProduct=CreateObject("component","com.Product.Product")>
		<cfif ProductExist>
			<cfset MyProduct.Constructor(Val(GetID.CategoryID),ARGUMENTS.LanguageID)>
		<cfelse>
			<cfset MyProduct.Constructor(Val(GetID.CategoryID),APPLICATION.DefaultLanguageID)>
		</cfif>
		<cfset aFeature=MyProduct.GetProperty("aProductFeature")>
		<cfloop index="fi" from="1" to="#ArrayLen(aFeature)#" step="1">
			<cfset QueryAddRow(qReturn,1)>
			<cfset QuerySetCell(qReturn,"ItemValue",aFeature[fi].TextBlock)>
		</cfloop>
		
		<cfreturn qReturn>
	</cffunction>
	
	<cffunction name="GetProductDetail" returntype="query" output="false" access="remote">
		<cfargument name="ProductAlias" default="" type="string" required="true">
		<cfargument name="LocaleID" default="2" type="numeric" required="true">
		<cfargument name="LanguageID" default="100" type="numeric" required="true">
		
		<cfquery name="GetID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_Category Where 
			CategoryAlias IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="prod_#Trim(ARGUMENTS.ProductAlias)#,#Trim(ARGUMENTS.ProductAlias)#" list="yes">) and
			CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="64">
			order by CategoryAlias
		</cfquery>
		
		<cfset ColumnList="ProductID,ProductName,ProductShortName,ProductAlias,ProductDescription,ProductPositioningSentence,ProductFeature1,ProductFeature2,ProductFeature3,ProductFeature4,ProductFeature5,ProductFeature6,ProductFeature7,ProductFeature8,ProductFeature9,ProductFeature10,ProductPrice,CallToActionURL,ProductBullet1,ProductBullet2,ProductBullet3,ProductBullet4,ProductBullet5,ProductBullet6,ProductBullet7,ProductBullet8,ProductRolloverURL,ProductThumbnailURL,AvailableConsoles">
		
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetProduct">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="GetID.CategoryID" value="#Val(GetID.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
		</cfstoredproc>
	
		<cfif GetProduct.RecordCount IS "1">
			<cfinvoke component="/com/product/producthandler" method="ProductExist" returnVariable="ProductExist"
				ProductID="#GetID.CategoryID#"
				LanguageID="#ARGUMENTS.LanguageID#">
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfif ProductExist>
				<cfset MyProduct.Constructor(Val(GetID.CategoryID),ARGUMENTS.LanguageID)>
				<cfset UsingDefault="No">
			<cfelse>
				<cfset MyProduct.Constructor(Val(GetID.CategoryID),APPLICATION.DefaultLanguageID)>
				<cfset UsingDefault="Yes">
			</cfif>
			
			<cfset QueryAddRow(qReturn,1)>
			<cfset QuerySetCell(qReturn,"ProductName",GetProduct.CategoryNameDerived)>
			<cfif MyProduct.GetProperty("ProductShortName") IS NOT "">
				<cfset QuerySetCell(qReturn,"ProductShortName",MyProduct.GetProperty("ProductShortName"))>
			<cfelse>
				<cfset QuerySetCell(qReturn,"ProductShortName",GetProduct.CategoryNameDerived)>
			</cfif>
			<cfset QuerySetCell(qReturn,"ProductID",Val(GetID.CategoryID))>
			<cfset QuerySetCell(qReturn,"ProductAlias",GetProduct.CategoryAlias)>
			<cfset QuerySetCell(qReturn,"ProductDescription",REQUEST.ReplaceMarks(MyProduct.GetProperty("ProductDescription")))>
			<cfset QuerySetCell(qReturn,"ProductPositioningSentence",REQUEST.ReplaceMarks(MyProduct.GetProperty("ProductPositioningSentence")))>
			<cfset aFeature=MyProduct.GetProperty("aProductFeature")>
			<cfloop index="i" from="1" to="#ArrayLen(aFeature)#" step="1">
				<cfif i lte "10">
					<cfset QuerySetCell(qReturn,"ProductFeature#i#",REQUEST.ReplaceMarks(aFeature[i].TextBlock))>
				</cfif>
			</cfloop>
			<cfif IsWDDX(GetProduct.CategoryLocalePropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetProduct.CategoryLocalePropertiesPacket#" output="sProperties">
				<cfif StructKeyExists(sProperties,"ProductPrice") and sProperties.ProductPrice is not "" and UsingDefault IS "no">
					<cfset QuerySetCell(qReturn,"ProductPrice",sProperties.ProductPrice)>
				</cfif>
				<cfif StructKeyExists(sProperties,"CallToActionURL") and sProperties.CallToActionURL is not "" and UsingDefault IS "no">
					<cfset QuerySetCell(qReturn,"CallToActionURL",sProperties.CallToActionURL)>
				</cfif>
			</cfif>
			
			<cfif MyProduct.GetProperty("ProductThumbnailPath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.salcoproducts.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.staging.salco.01.thirdwaveweb.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
				</cfif>
			</cfif>
			
			<cfif MyProduct.GetProperty("ProductThumbnailHoverPath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"ProductRolloverURL","http://www.salcoproducts.com#MyProduct.GetProperty('ProductThumbnailHoverPath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"ProductRolloverURL","http://www.staging.salco.01.thirdwaveweb.com#MyProduct.GetProperty('ProductThumbnailHoverPath')#")>
				</cfif>
			</cfif>
			
			<cfset aFeature=MyProduct.GetProperty("aProductBullet")>
			<cfloop index="i" from="1" to="#ArrayLen(aFeature)#" step="1">
				<cfif i lte "8">
					<cfset QuerySetCell(qReturn,"ProductBullet#i#",REQUEST.ReplaceMarks(aFeature[i].TextBlock))>
				</cfif>
			</cfloop>
			
			<cfif MyProduct.GetConsoleProductFamilyID() GT "0">
				<cfset QuerySetCell(qReturn,"AvailableConsoles",MyProduct.GetlConsoleAlias())>
			</cfif>
		</cfif>
		<cfreturn qReturn>
	</cffunction>
	
	<cffunction name="GetProductBasicDetail" returntype="query" output="false" access="remote">
		<cfargument name="ProductAlias" default="" type="string" required="true">
		<cfargument name="LocaleID" default="2" type="numeric" required="true">
		<cfargument name="LanguageID" default="100" type="numeric" required="true">
		
		<cfquery name="GetID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_Category Where
			CategoryAlias IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="prod_#Trim(ARGUMENTS.ProductAlias)#,#Trim(ARGUMENTS.ProductAlias)#" list="yes">) and 
			CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="64">
			order by CategoryAlias
		</cfquery>
		
		<cfset ColumnList="ProductName,ProductShortName,ProductDescription,ProductPositioningSentence,ProductPrice,CallToActionURL">
		
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetProduct">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="GetID.CategoryID" value="#Val(GetID.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
		</cfstoredproc>
	
		<cfif GetProduct.RecordCount IS "1">
			<cfinvoke component="/com/product/producthandler" method="ProductExist" returnVariable="ProductExist"
				ProductID="#GetID.CategoryID#"
				LanguageID="#ARGUMENTS.LanguageID#">
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfif ProductExist>
				<cfset UsingDefault="No">
				<cfset MyProduct.Constructor(Val(GetID.CategoryID),ARGUMENTS.LanguageID)>
			<cfelse>
				<cfset UsingDefault="Yes">
				<cfset MyProduct.Constructor(Val(GetID.CategoryID),APPLICATION.DefaultLanguageID)>
			</cfif>
			
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfset MyProduct.Constructor(Val(GetID.CategoryID),ARGUMENTS.LanguageID)>
			<cfset QueryAddRow(qReturn,1)>
			<cfset QuerySetCell(qReturn,"ProductName",GetProduct.CategoryNameDerived)>
			<cfif MyProduct.GetProperty("ProductShortName") IS NOT "">
				<cfset QuerySetCell(qReturn,"ProductShortName",MyProduct.GetProperty("ProductShortName"))>
			<cfelse>
				<cfset QuerySetCell(qReturn,"ProductShortName",GetProduct.CategoryNameDerived)>
			</cfif>
			<cfset QuerySetCell(qReturn,"ProductDescription",REQUEST.ReplaceMarks(MyProduct.GetProperty("ProductDescription")))>
			<cfset QuerySetCell(qReturn,"ProductPositioningSentence",REQUEST.ReplaceMarks(MyProduct.GetProperty("ProductPositioningSentence")))>
			<cfwddx action="WDDX2CFML" input="#GetProduct.CategoryLocalePropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ProductPrice") and sProperties.ProductPrice is not "" and UsingDefault IS "No">
				<cfset QuerySetCell(qReturn,"ProductPrice",sProperties.ProductPrice)>
			</cfif>
			<cfif StructKeyExists(sProperties,"CallToActionURL") and sProperties.CallToActionURL is not "" and UsingDefault IS "No">
				<cfset QuerySetCell(qReturn,"CallToActionURL",sProperties.CallToActionURL)>
			</cfif>
		</cfif>
		<cfreturn qReturn>
	</cffunction>
	
	<cffunction name="GetProductPartNumber" returntype="string" output="false">
		<cfargument name="ProductID" default="" type="string" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.GetProductPartNumber" datasource="#APPLICATION.DSN#">
			select AttributeValue from qry_GetProductPartNumber 
			where CategoryID=<cfqueryparam value="#Trim(ARGUMENTS.ProductID)#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		
		<cfreturn LOCAL.GetProductPartNumber.AttributeValue>
	</cffunction>
	
	<cffunction name="GetProductSpecs" returntype="query" output="false" access="remote">
		<cfargument name="ProductAlias" default="" type="string" required="true">
		<cfargument name="LanguageID" default="" type="numeric" required="true">
		<cfargument name="SpecificationSetID" default="8000" type="numeric" required="true">
		
		<cfquery name="GetProductID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_category
			WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.ProductAlias)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
		</cfquery>
		
		<cfset ThisProductID=Val(GetProductID.CategoryID)>
		
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductFamilyID"
			returnVariable="CurrentProductFamilyID"
			ProductID="#Val(ThisProductID)#">
		
		<cfset ProductIDList=Val(ThisProductID)>
		<cfset sProductSet=StructNew()>
		<cfloop index="ThisProductID" list="#Val(ProductIDList)#">
			<cfif ARGUMENTS.LanguageID IS APPLICATION.DefaultLanguageID>
				<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
					select * from qry_GetProductAttribute 
					WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And 
					LanguageID=#Val(ARGUMENTS.LanguageID)# and AttributeLanguageID=#Val(ARGUMENTS.LanguageID)#
					AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
					ORDER By  ProductFamilyAttributePriority
				</cfquery>
			<cfelse>
				<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
					select * from qry_GetProductAttribute 
					WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And 
					LanguageID=#Val(ARGUMENTS.LanguageID)# and AttributeLanguageID=#Val(ARGUMENTS.LanguageID)#
					AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
					ORDER By  ProductFamilyAttributePriority, AttributeLanguageID desc
				</cfquery>
				<cfif GetAttributes.RecordCount IS "0" and ListFindNoCase("104,103",ARGUMENTS.LanguageID)>
					<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
						select * from qry_GetProductAttribute 
						WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And 
						LanguageID=#Val(APPLICATION.DefaultLanguageID)# and AttributeLanguageID=#Val(APPLICATION.DefaultLanguageID)#
						AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
						ORDER By  ProductFamilyAttributePriority
					</cfquery>
				</cfif>
			</cfif>
			<cfset sValues=StructNew()>
			<cfoutput query="GetAttributes" group="ProductFamilyAttributeID">
				<cfset sValueElt=StructNew()>
				<cfset StructInsert(sValueElt,"AttributeValueID",AttributeValueID,1)>
				<cfset StructInsert(sValueElt,"AttributeValue",AttributeValue,1)>
				<cfset StructInsert(sValues,ProductFamilyAttributeID,sValueElt,1)>
			</cfoutput>
			<cfset StructInsert(sProductSet,ThisProductID,sValues,1)>
		</cfloop>
		
		<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
			SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID,ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute 
			WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(ARGUMENTS.LanguageID)#
				AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
			order by ProductFamilyAttributePriority
		</cfquery>
		<cfif GetCols.RecordCount IS "0" and ListFindNoCase("104,103",ARGUMENTS.LanguageID)>
			<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
				SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID,ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute 
				WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(APPLICATION.DefaultLanguageID)#
					AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
				order by ProductFamilyAttributePriority
			</cfquery>
		</cfif>
		
		<cfquery name="GetIfLegend" datasource="#APPLICATION.DSN#">
			SELECT ProductFamilyAttributeID FROM qry_GetProductFamilyAttribute 
			WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(ARGUMENTS.LanguageID)# and ProductFamilyAttributeTypeID=602
				AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
		</cfquery>
		
		<cfset sCode1=StructNew()>
		<cfset StructInsert(sCode1,-1,"-",1)>
		<cfset StructInsert(sCode1,700,"S",1)>
		<cfset StructInsert(sCode1,701,"O",1)>
		<cfset StructInsert(sCode1,702,"-",1)>
		<cfset sCode2=StructNew()>
		<cfset StructInsert(sCode2,"ATTRVAL_S","S",1)>
		<cfset StructInsert(sCode2,"ATTRVAL_O","O",1)>
		<cfset StructInsert(sCode2,"ATTRVAL_U","-",1)>
		
		<cfset MajorCounter="1">
				
		<cfset ColumnList="ItemName,ItemValue">
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfoutput query="GetCols">
			<cfset QueryAddRow(qReturn,1)>
			<cfset QuerySetCell(qReturn,"ItemName",REQUEST.ReplaceMarks(ProductFamilyAttributeName))>
			<cfswitch expression="#ProductFamilyAttributeTypeID#">
				<cfcase value="602,603">
					<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
						<cfif StructKeyExists(sProductSet[ListGetAt(ProductIDList,ii)],ProductFamilyAttributeID)>
							<cfif ProductFamilyAttributeTypeID IS "602">
								<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValueID>
								<cfset Answer=sCode1[Answer]>
							<cfelse>
								<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValue>
								<cfif ListFind("ATTRVAL_S,ATTRVAL_O,ATTRVAL_U",Answer)>
									<cfset Answer=sCode2[Answer]>
								</cfif>
							</cfif>
						<cfelse>
							<cfset Answer="">
						</cfif>
						<cfset QuerySetCell(qReturn,"ItemValue",Answer)>
					</cfloop>
				</cfcase>
			</cfswitch>
		</cfoutput>
		
		<cfreturn qReturn>
	</cffunction>
	
	<cffunction name="GetProductAttributeStruct" returntype="struct" output="false">
		
		<cfset VAR LOCAL=StructNew()>
		<cfset LOCAL.sAttributeID=StructNew()>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductLongName","4",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductShortName","5",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductPositioningSentence","6",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductDescription","7",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"CallToActionURLDeprecated","8",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"VideoURL","9",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"PartNumber","10",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"BrochurePath","11",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"PublicDrawing","12",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductImagePath","13",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductThumbnailPath","14",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductThumbnailHoverPath","15",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductImageSourcePath","16",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductImageStorePath","17",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"PublicDrawingSize","23",1)>
		<cfreturn LOCAL.sAttributeID>
	</cffunction>
	
	<cffunction name="GetTopProductFamily" returntype="query" output="false">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="LOCAL.GetTopProductFamily">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="no">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="7" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="62" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
		</cfstoredproc>
		
		<cfreturn LOCAL.GetTopProductFamily>
	</cffunction>
	
	<cffunction name="GetPublicDrawingDupe" returntype="string" output="false">
		<cfargument name="PartNo" default="" type="string" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		<cfset LOCAL.ReturnValue="">
		
		<cfquery name="GetDupeProducts" datasource="#APPLICATION.DSN#">
			select CategoryID FROM t_ProductAttribute
			WHERE (ProductFamilyAttributeID = 10) AND
			AttributeValue=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.PartNo#">
		</cfquery>
		
		<cfif GetDupeProducts.RecordCount GT "0">
			<cfquery name="GetDupeProducts2" datasource="#APPLICATION.DSN#" maxrows="1">
				select CategoryID, AttributeValue FROM t_ProductAttribute
				WHERE (ProductFamilyAttributeID = <cfqueryparam cfsqltype="cf_sql_integer" value="12">) AND
				CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(GetDupeProducts.CategoryID)#" List="Yes">) AND
				len(AttributeValue) > <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			</cfquery>
			<cfif GetDupeProducts2.AttributeValue IS NOT "">
				<cfset LOCAL.ReturnValue=GetDupeProducts2.AttributeValue>
			</cfif>
		</cfif>
		
		<cfreturn LOCAL.ReturnValue>
	</cffunction>
	
	<cffunction name="GetProductsByMatchingProductNo" returntype="query" output="false">
		<cfargument name="PartNo" default="" type="string" required="true">
		<cfargument name="maxrows" default="all" type="string">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.GetProductsByMatchingProductNo" datasource="#APPLICATION.DSN#">
			select 
			<cfif ARGUMENTS.MaxRows IS NOT "All">TOP #Val(ARGUMENTS.MaxRows)#</cfif> *,
			AttributeValue as ProductNo
			FROM	qry_GetCategoryWithCategoryLocale INNER JOIN
				t_ProductAttribute ON qry_GetCategoryWithCategoryLocale.CategoryId = t_ProductAttribute.CategoryID AND t_ProductAttribute.ProductFamilyAttributeID=<cfqueryparam cfsqltype="cf_sql_numeric" value="10">
			WHERE	t_ProductAttribute.AttributeValue 
			LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.PartNo#%"> And
			qry_GetCategoryWithCategoryLocale.ParentID <> <cfqueryparam cfsqltype="cf_sql_numeric" value="5731">
			ORDER BY CategoryName
		</cfquery>
		
		<cfreturn LOCAL.GetProductsByMatchingProductNo>
	</cffunction>
	
	<cffunction name="GetPublicDrawing" returntype="query" output="false">
		<cfargument name="TopProductFamilyAlias" default="" type="string" required="true">
		<cfargument name="OrderBy" default="CategoryName" type="string" required="true">
		<cfargument name="OrderAsc" default="1" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfif ListFindNoCase("CategoryName,PartNumber",ARGUMENTS.OrderBy) IS "0">
			<cfset ARGUMENTS.OrderBy="CategoryName">
		</cfif>
		
		<cfset LOCAL.ColumnList="ProductID,ProductName,PartNumber,PublicDrawing,PublicDrawingSize,TopProductFamilyAlias,TopProductFamilyName">
		<cfset LOCAL.qReturn=QueryNew(ColumnList)>
		
		<cfset LOCAL.qGetTopProductFamily=GetTopProductFamily()>
		
		<cfquery name="LOCAL.GetAttributes" datasource="#APPLICATION.DSN#">
			SELECT CategoryID, CategoryName, DisplayOrder, ProductFamilyAttributeID, AttributeValue
			from qry_GetCategoryAttribute
			Where ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="10,12,23" list="yes">) AND
			CategoryActive=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
			order by CategoryID, ProductFamilyAttributeID
		</cfquery>

		<cfoutput query="LOCAL.GetAttributes" group="CategoryID">
			<cfset LOCAL.sElement=StructNew()>
			
			<cfset StructInsert(LOCAL.sElement,"ProductID",LOCAL.GetAttributes.CategoryID)>
			<cfset StructInsert(LOCAL.sElement,"ProductName",LOCAL.GetAttributes.CategoryName)>
			<cfset StructInsert(LOCAL.sElement,"PartNumber","")>
			<cfset StructInsert(LOCAL.sElement,"PublicDrawing","")>
			<cfset StructInsert(LOCAL.sElement,"PublicDrawingSize","")>
			<cfset StructInsert(LOCAL.sElement,"TopProductFamilyAlias","")>
			<cfset StructInsert(LOCAL.sElement,"TopProductFamilyName","")>
			
			<cfloop query="LOCAL.qGetTopProductFamily">
				<cfif Left(LOCAL.GetAttributes.DisplayOrder,Len(LOCAL.qGetTopProductFamily.DisplayOrder)) IS LOCAL.qGetTopProductFamily.DisplayOrder>
					<cfset StructInsert(LOCAL.sElement,"TopProductFamilyAlias",LOCAL.qGetTopProductFamily.CategoryAlias,1)>
					<cfset StructInsert(LOCAL.sElement,"TopProductFamilyName",LOCAL.qGetTopProductFamily.CategoryName,1)>
				</cfif>
			</cfloop>
			
			<cfoutput group="ProductFamilyAttributeID">
				<cfswitch expression="#LOCAL.GetAttributes.ProductFamilyAttributeID#">
					<cfcase value="10">
						<cfset StructInsert(LOCAL.sElement,"PartNumber",LOCAL.GetAttributes.AttributeValue,1)>
					</cfcase>
					<cfcase value="12">
						<cfset StructInsert(LOCAL.sElement,"PublicDrawing",LOCAL.GetAttributes.AttributeValue,1)>
					</cfcase>
					<cfcase value="23">
						<cfset StructInsert(LOCAL.sElement,"PublicDrawingSize",Val(LOCAL.GetAttributes.AttributeValue),1)>
					</cfcase>
				</cfswitch>
			</cfoutput>
			
			<cfif LOCAL.sElement.PublicDrawing IS NOT "" and FileExists(ExpandPath(LOCAL.sElement.PublicDrawing))>
				<cfif Val(LOCAL.sElement.PublicDrawingSize) IS "0">
					<cfset LOCAL.sElement.PublicDrawingSize=GetFileInfo(ExpandPath(LOCAL.sElement.PublicDrawing)).Size>
				</cfif>
				<cfset QueryAddRow(LOCAL.qReturn,1)>
				<cfset QuerySetCell(LOCAL.qReturn,"ProductID",LOCAL.sElement.ProductID)>
				<cfset QuerySetCell(LOCAL.qReturn,"ProductName",LOCAL.sElement.ProductName)>
				<cfset QuerySetCell(LOCAL.qReturn,"PartNumber",LOCAL.sElement.PartNumber)>
				<cfset QuerySetCell(LOCAL.qReturn,"PublicDrawing",LOCAL.sElement.PublicDrawing)>
				<cfset QuerySetCell(LOCAL.qReturn,"PublicDrawingSize",Val(LOCAL.sElement.PublicDrawingSize))>
				<cfset QuerySetCell(LOCAL.qReturn,"TopProductFamilyAlias",LOCAL.sElement.TopProductFamilyAlias)>
				<cfset QuerySetCell(LOCAL.qReturn,"TopProductFamilyName",LOCAL.sElement.TopProductFamilyName)>
			</cfif>
		</cfoutput>

		<cfquery name="LOCAL.qReturn" dbtype="query">
			select * from [LOCAL].qReturn
			<cfif ARGUMENTS.TopProductFamilyAlias IS NOT "">
				WHERE TopProductFamilyAlias=<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.TopProductFamilyAlias#">
			</cfif>
			order by ProductName
		</cfquery>
		<cfreturn LOCAL.qReturn>
	</cffunction>
	
	<cffunction name="GetProductReport" output="false" access="remote">
		<cfargument name="page" default="">
		<cfargument name="pageSize" default="">
		<cfargument name="cfgridsortcolumn" default="">
		<cfargument name="cfgridsortdirection" default="">
		<cfargument name="productName" type="string" default="">
		<cfargument name="PartNumber" type="string" default="">
		<cfargument name="productFamilyName" type="string" default="">
		<cfargument name="description" type="string" default="">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfset LOCAL.ColumnList="ProductID,ProductName,ProductAlias,ProductFamilyName,ProductFamilyID,PartNumber,ProductDescription,Edit,DisplayOrder">
		<cfset LOCAL.qReturn=QueryNew(ColumnList)>
		
		<cfset LOCAL.qGetTopProductFamily=GetTopProductFamily()>
		
		<cfquery name="LOCAL.GetProductList" datasource="#APPLICATION.DSN#">
			SELECT CategoryID, CategoryName, CategoryAlias, DisplayOrder, ProductFamilyAttributeID, AttributeValue, ParentCategoryName, ParentCategoryAlias, ParentID
			from qry_GetProduct
			Where ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="7,10" list="yes">)
			and CategoryActive=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
			order by DisplayOrder, ProductFamilyAttributeID
		</cfquery>

		<cfoutput query="LOCAL.GetProductList" group="CategoryID">
			<cfset QueryAddRow(LOCAL.qReturn,1)>
			<cfset QuerySetCell(LOCAL.qReturn,"ProductID",LOCAL.GetProductList.CategoryID)>
			<cfset QuerySetCell(LOCAL.qReturn,"ProductName",LOCAL.GetProductList.CategoryName)>
			<cfset QuerySetCell(LOCAL.qReturn,"ProductAlias",LOCAL.GetProductList.CategoryAlias)>
			<cfset QuerySetCell(LOCAL.qReturn,"ProductFamilyName",LOCAL.GetProductList.ParentCategoryName)>
			<cfset QuerySetCell(LOCAL.qReturn,"ProductFamilyID",LOCAL.GetProductList.ParentID)>
			<cfset QuerySetCell(LOCAL.qReturn,"DisplayOrder",LOCAL.GetProductList.DisplayOrder)>
			<cfset QuerySetCell(LOCAL.qReturn,"Edit","<img src=""/common/images/admin/icon_edit.gif"" width=""12"" height=""12"" />")>
			<cfoutput group="ProductFamilyAttributeID">
				<cfswitch expression="#LOCAL.GetProductList.ProductFamilyAttributeID#">
					<cfcase value="7">
						<cfset QuerySetCell(LOCAL.qReturn,"ProductDescription",LOCAL.GetProductList.AttributeValue)>
					</cfcase>
					<cfcase value="10">
						<cfset QuerySetCell(LOCAL.qReturn,"PartNumber",LOCAL.GetProductList.AttributeValue)>
					</cfcase>
				</cfswitch>
			</cfoutput>
		</cfoutput>

		<cfquery name="LOCAL.qReturn" dbtype="query">
			select * from [LOCAL].qReturn where 1=1
			<cfif trim(arguments.productName) neq "">
				AND lower(productName) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.productName#%">
			</cfif>
			<cfif trim(arguments.PartNumber) neq "">
				AND lower(PartNumber) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.PartNumber#%">
			</cfif>
			<cfif trim(arguments.productFamilyName) neq "">
				AND lower(productFamilyName) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.productFamilyName#%">
			</cfif>
			<cfif trim(arguments.description) neq "">
				AND lower(ProductDescription) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.description#%">
			</cfif>
			<cfif trim(arguments.cfgridsortcolumn) neq "">
				ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#
			<cfelse>
				order by DisplayOrder
			</cfif>
		</cfquery>
		
		<cfif isNumeric(arguments.page) and isNumeric(arguments.pageSize)>
			<cfreturn queryConvertForGrid(LOCAL.qReturn, arguments.page, arguments.pageSize)>
		<cfelse>
			<cfreturn LOCAL.qReturn>
		</cfif>
	</cffunction>
</cfcomponent>