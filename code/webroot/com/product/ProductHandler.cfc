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
	
	<cffunction name="GetProductCombinationDetails" returntype="struct" output="false" access="remote">
		<cfargument name="ProductAlias1" default="" type="string" required="true">
		<cfargument name="ProductAlias2" default="" type="string" required="true">
		<cfargument name="LocaleID" default="" type="string" required="true">
		<cfargument name="LanguageID" default="" type="string" required="true">
		
		<cfset sReturn=StructNew()>
		
		<cfquery name="GetProductID1" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_category
			WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.ProductAlias1)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
		</cfquery>
		
		<cfquery name="GetProductID2" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_Category
			WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.ProductAlias2)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
		</cfquery>
		
		<cfinvoke component="/com/Product/ProductCombinationHandler"
			method="GetProductCombinationID" 
			returnVariable="ThisProductCombinationID"
			ProductID1="#Val(GetProductID1.CategoryID)#"
			ProductID2="#Val(GetProductID2.CategoryID)#"
			LanguageID="#Val(ARGUMENTS.LanguageID)#">
		<cfset UsingDefaultCombination="no">
		<cfif Val(ThisProductCombinationID) LTE "0">
			<cfinvoke component="/com/Product/ProductCombinationHandler"
				method="GetProductCombinationID" 
				returnVariable="ThisProductCombinationID"
				ProductID1="#Val(GetProductID1.CategoryID)#"
				ProductID2="#Val(GetProductID2.CategoryID)#"
				LanguageID="#Val(APPLICATION.DefaultLanguageID)#">
			<cfset UsingDefaultCombination="Yes">
		</cfif>
		
		<cfset MyCombination=CreateObject("component","com.Product.ProductCombination")>
		<cfset MyCombination.Constructor(ThisProductCombinationID,ARGUMENTS.LanguageID)>
		
		<cfset ColumnList="CombinationID,ProductCombinationDescription,LargeImageURL,LargeImageURLPrint,ZoomImageURL,ProductCombinationPrice,CallToActionURL">
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfif Val(MyCombination.GetProperty("CombinationID")) GT "0">
			<cfset QueryAddRow(qReturn,1)>
			<cfif UsingDefaultCombination>
				<cfset QuerySetCell(qReturn,"ProductCombinationPrice","")>
			<cfelse>
				<cfset QuerySetCell(qReturn,"ProductCombinationPrice",MyCombination.GetProperty("ProductCombinationPrice"))>
			</cfif>
			<cfset QuerySetCell(qReturn,"CombinationID",MyCombination.GetProperty("CombinationID"))>
			<cfset PromoText="">
			<cfquery name="GetFrontProductPage" datasource="#APPLICATION.DSN#">
				select CategoryID from t_Category Where 
				SourceID=<cfqueryparam value="#GetProductID1.CategoryID#" cfsqltype="CF_SQL_INTEGER"> and
				CategoryTypeID=<cfqueryparam value="164" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
			<cfinvoke component="/com/product/producthandler" method="GetLinkedProductPage" returnVariable="qLinkedPage"
				ProductID="#GetProductID1.CategoryID#"
				CategoryID="#GetFrontProductPage.CategoryID#"
				LocaleID="#ARGUMENTS.LocaleID#">
			<cfif isWddx(qLinkedPage.CategoryLocalePropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#qLinkedPage.CategoryLocalePropertiesPacket#" output="sLinkedPageProps">
				<cfif StructKeyExists(sLinkedPageProps,"sPromoText")>
					<cfif IsStruct(sLinkedPageProps.sPromoText)>
						<cfset ThisSPromoText=sLinkedPageProps.sPromoText>
						<cfif StructKeyExists(ThisSPromoText,ARGUMENTS.ProductAlias2)>
							<cfset PromoText=ThisSPromoText[ARGUMENTS.ProductAlias2]>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			<cfset ThisProductCombinationDescription=MyCombination.GetProperty("ProductCombinationDescription")>
			<cfif PromoText IS NOT "">
				<cfset ThisProductCombinationDescription="<font color=""##FF0000""><b>#PromoText#</b></font><br>#ThisProductCombinationDescription#">
			</cfif>
			<cfset QuerySetCell(qReturn,"ProductCombinationDescription",ThisProductCombinationDescription)>
			<cfif MyCombination.GetProperty("ProductCombinationImagePath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"ZoomImageURL","http://www.salco.com#MyCombination.GetProperty('ProductCombinationImagePath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"ZoomImageURL","http://www.staging.salco.01.thirdwaveweb.com#MyCombination.GetProperty('ProductCombinationImagePath')#")>
				</cfif>
			</cfif>
			
			<cfif MyCombination.GetProperty("ProductCombinationFlashZoomPath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"ZoomImageURL","http://www.salco.com#MyCombination.GetProperty('ProductCombinationFlashZoomPath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"ZoomImageURL","http://www.staging.salco.01.thirdwaveweb.com#MyCombination.GetProperty('ProductCombinationFlashZoomPath')#")>
				</cfif>
			</cfif>
			
			<cfif MyCombination.GetProperty("ProductCombinationThumbnailPath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"LargeImageURL","http://www.salco.com#MyCombination.GetProperty('ProductCombinationThumbnailPath')#")>
					<cfset QuerySetCell(qReturn,"LargeImageURLPrint","http://www.salco.com#MyCombination.GetProperty('ProductCombinationThumbnailPath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"LargeImageURL","http://www.staging.salco.01.thirdwaveweb.com#MyCombination.GetProperty('ProductCombinationThumbnailPath')#")>
					<cfset QuerySetCell(qReturn,"LargeImageURLPrint","http://www.staging.salco.01.thirdwaveweb.com#MyCombination.GetProperty('ProductCombinationThumbnailPath')#")>
				</cfif>
			</cfif>
			
			<cfif MyCombination.GetProperty("ProductCombinationFlashPath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"LargeImageURL","http://www.salco.com#MyCombination.GetProperty('ProductCombinationFlashPath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"LargeImageURL","http://www.staging.salco.01.thirdwaveweb.com#MyCombination.GetProperty('ProductCombinationFlashPath')#")>
				</cfif>
			</cfif>
			
			<cfif ARGUMENTS.LocaleID IS "2">
				<cfset ThisURL=MyCombination.GetProperty("ProductCombinationCallToActionURL")>
				<cfset QuerySetCell(qReturn,"CallToActionURL",ThisURL)>
			</cfif>
		</cfif>
		
		<cfset sGeneral=StructNew()>
		<cfset StructInsert(sGeneral,"ProductCombination",qReturn)>
		
		<cfinvoke 
			component="/com/Product/ProductHandler" 
			method="GetProductBasicDetail"
			ProductAlias="#ARGUMENTS.ProductAlias1#"
			LocaleID="#Val(ARGUMENTS.LocaleID)#"
			LanguageID="#Val(ARGUMENTS.LanguageID)#"
			returnvariable="Result1">
			
		<cfset StructInsert(sGeneral,"Product1",Result1)>
		
		<cfinvoke 
			component="/com/Product/ProductHandler" 
			method="GetProductBasicDetail"
			ProductAlias="#ARGUMENTS.ProductAlias2#"
			LocaleID="#Val(ARGUMENTS.LocaleID)#"
			LanguageID="#Val(ARGUMENTS.LanguageID)#"
			returnvariable="Result2">
			
		<cfset StructInsert(sGeneral,"Product2",Result2)>
		
		<cfinvoke 
			component="/com/Product/ProductHandler" 
			method="GetProductFeature"
			ProductAlias="#ARGUMENTS.ProductAlias1#"
			LanguageID="#ARGUMENTS.LanguageID#"
			returnvariable="Product1Features">
		<cfif Product1Features.RecordCount IS "0">
			<cfinvoke 
				component="/com/Product/ProductHandler" 
				method="GetProductFeature"
				ProductAlias="#ARGUMENTS.ProductAlias1#"
				LanguageID="#APPLICATION.DefaultLanguageID#"
				returnvariable="Product1Features">
		</cfif>
		<cfset StructInsert(sGeneral,"Product1Features",Product1Features)>
		
		<cfinvoke 
			component="/com/Product/ProductHandler" 
			method="GetProductFeature"
			ProductAlias="#ARGUMENTS.ProductAlias2#"
			LanguageID="#ARGUMENTS.LanguageID#"
			returnvariable="Product2Features">
		<cfif Product2Features.RecordCount IS "0">
			<cfinvoke 
				component="/com/Product/ProductHandler" 
				method="GetProductFeature"
				ProductAlias="#ARGUMENTS.ProductAlias2#"
				LanguageID="#APPLICATION.DefaultLanguageID#"
				returnvariable="Product2Features">
		</cfif>
		<cfset StructInsert(sGeneral,"Product2Features",Product2Features)>
		
		<cfset StructInsert(sReturn,"General",sGeneral)>
		
		<cfset sReadout=StructNew()>
		<cfset StructInsert(sReadout,"SummaryParagraph","")>
		<cfset StructInsert(sReadout,"Title","Electronic Readouts")>
		<cfinvoke 
			component="/com/Product/ProductSpecsHandler" 
			method="GetProductSpecs"
			ProductAlias="#ARGUMENTS.ProductAlias2#"
			LanguageID="#ARGUMENTS.LanguageID#"
			returnvariable="ResultReadouts">
		<cfif ResultReadouts.RecordCount IS "0">
			<cfinvoke 
				component="/com/Product/ProductSpecsHandler" 
				method="GetProductSpecs"
				ProductAlias="#ARGUMENTS.ProductAlias2#"
				LanguageID="#APPLICATION.DefaultLanguageID#"
				returnvariable="ResultReadouts">
		</cfif>
		
		<cfset ColumnList3="ItemValue">
		<cfset qConsoleReadOut=QueryNew(ColumnList3)>
		
		<cfoutput query="ResultReadouts">
			<cfset ThisItemValue="">
			<cfif ItemValue IS "S">
				<cfset ThisItemValue="#ItemName#">
			<cfelseif ListFindNoCase("O,-",ItemValue)>
				<cfset ThisItemValue="">
			<cfelseif ItemValue IS NOT "">
				<cfset ThisItemValue="#ItemValue#">
			</cfif>
			<cfif ThisItemValue IS NOT "">
				<cfset QueryAddRow(qConsoleReadOut,1)>
				<cfset QuerySetCell(qConsoleReadOut,"ItemValue",ThisItemValue)>
			</cfif>
		</cfoutput>
		
		<cfset StructInsert(sReadout,"ItemList",qConsoleReadOut)>
		<cfset StructInsert(sReturn,"Readouts",sReadout)>
		
		
		<cfset sSpecs=StructNew()>
		<cfset StructInsert(sSpecs,"SummaryParagraph","")>
		<cfset StructInsert(sSpecs,"Title","Specifications")>
		<cfinvoke 
			component="/com/Product/ProductSpecsHandler" 
			method="GetProductSpecs"
			ProductAlias="#ARGUMENTS.ProductAlias1#"
			LanguageID="#ARGUMENTS.LanguageID#"
			returnvariable="ResultReadouts">
		<cfif ResultReadouts.RecordCount IS "0">
			<cfinvoke 
				component="/com/Product/ProductSpecsHandler" 
				method="GetProductSpecs"
				ProductAlias="#ARGUMENTS.ProductAlias1#"
				LanguageID="#APPLICATION.DefaultLanguageID#"
				returnvariable="ResultReadouts">
		</cfif>
		<cfset StructInsert(sSpecs,"ItemList",ResultReadouts)>
		<cfset StructInsert(sReturn,"Specs",sSpecs)>
		
		
		<cfset aPrograms=ArrayNew(1)>
		
		<cfset ThisProgramID="-1">
		<cfquery name="GetProps" datasource="#APPLICATION.DSN#">
			select PropertiesPacket from qry_GetCategory Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(GetProductID2.CategoryID)#">
		</cfquery>
		<cfif IsWddx(GetProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetProps.PropertiesPacket#" output="sCat">
			<cfif StructKeyExists(sCat,"ProductProgramTypeID") and Val(sCat.ProductProgramTypeID) GT "0">
				<cfset ThisProgramID=Val(sCat.ProductProgramTypeID)>
			</cfif>
		</cfif>
		
		<cfif Val(ThisProgramID) GT "0">
			<cfquery name="GetProg" datasource="#APPLICATION.DSN#" maxrows="1">
				select ContentID from t_Content Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ThisProgramID)#"> and ContentTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="222">
				order by ContentPriority
			</cfquery>
			<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetContent">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(GetProg.ContentID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#Val(ARGUMENTS.LocaleID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>
			<cfif IsWddx(GetContent.ContentBody)>
				<cfwddx action="WDDX2CFML" input="#GetContent.ContentBody#" output="sContentBody">
				<cfif StructKeyExists(sContentBody,"aFile") AND IsArray(sContentBody.aFile) AND ArrayLen(sContentBody.aFile) GT "0">
					<cfset ColumnList2="ItemName,ItemText,ItemImageURL">
					<cfset qProgram=QueryNew(ColumnList2)>
					<Cfset LastDataBlockName=sContentBody.aFile[1].FileName>
					<cfloop index="pi" from="1" to="#ArrayLen(sContentBody.aFile)#" step="1">
						<cfif sContentBody.aFile[pi].FileCaption IS "">
							<cfset ThisDataBlockName="#sContentBody.aFile[pi].FileName#">
						</cfif>
						<cfif LastDataBlockName IS NOT ThisDataBlockName>
							<cfset s1=StructNew()>
							<cfset StructInsert(s1,"DataBlockName","#LastDataBlockName#")>
							<cfset StructInsert(s1,"ItemsList",qProgram)>
							<cfset ArrayAppend(aPrograms,s1)>
							<cfset qProgram=QueryNew(ColumnList2)>
							<cfset LastDataBlockName=ThisDataBlockName>
						</cfif>
						<cfif sContentBody.aFile[pi].FileCaption IS NOT "">
							<cfset QueryAddRow(qProgram,1)>
							<cfset QuerySetCell(qProgram,"ItemName","#sContentBody.aFile[pi].FileName#")>
							<cfset QuerySetCell(qProgram,"ItemText","#sContentBody.aFile[pi].FileCaption#")>
							<cfif APPLICATION.Production>
								<cfset QuerySetCell(qProgram,"ItemImageURL","http://www.salco.com#sContentBody.aFile[pi].FilePath#")>
							<cfelse>
								<cfset QuerySetCell(qProgram,"ItemImageURL","http://www.staging.salco.01.thirdwaveweb.com#sContentBody.aFile[pi].FilePath#")>
							</cfif>
						</cfif>
					</cfloop>
					<cfset s1=StructNew()>
					<cfset StructInsert(s1,"DataBlockName","#LastDataBlockName#")>
					<cfset StructInsert(s1,"ItemsList",qProgram)>
					<cfset ArrayAppend(aPrograms,s1)>
					<cfset qProgram=QueryNew(ColumnList2)>
					<cfset LastDataBlockName=ThisDataBlockName>
				</cfif>
			</cfif>
		</cfif>
		
		<cfset sPrograms=StructNew()>
		<cfset StructInsert(sPrograms,"SummaryParagraph","Click on any of the workouts listed below for a more detailed description.")>
		<cfset StructInsert(sPrograms,"ItemsList",aPrograms)>
		
		<cfset StructInsert(sReturn,"Programs",sPrograms)>
		
		<cfreturn sReturn>
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
						<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.salco.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
					<cfelse>
						<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.staging.salco.01.thirdwaveweb.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
					</cfif>
				</cfif>
				
				<cfif MyProduct.GetProperty("ProductThumbnailHoverPath") IS NOT "">
					<cfif APPLICATION.Production>
						<cfset QuerySetCell(qReturn,"ProductRolloverURL","http://www.salco.com#MyProduct.GetProperty('ProductThumbnailHoverPath')#")>
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
	
	<cffunction name="GetProductFamilyBrochureOverride" returntype="string" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		<cfargument name="LanguageID" default="" type="numeric" required="true">
		
		<cfset ReturnValue="0">
		
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductFamilyID"
			returnVariable="CurrentProductFamilyID"
			ProductID="#ARGUMENTS.ProductID#">
		<!--- First check if there is brochure at the product family level--->	
		<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
			SELECT * FROM t_ProductAttribute
			WHERE ProductFamilyAttributeID=<cfqueryparam cfsqltype="cf_sql_integer" value="1441"> AND 
			CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(CurrentProductFamilyID)#"> and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
		</cfquery>
		
		<cfoutput query="GetItems">
			<cfif AttributeValue IS NOT "">
				<Cfset ReturnValue="#Val(AttributeValue)#">
			</cfif>
		</cfoutput>
		
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetProductFamilyBrochure" returntype="string" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		<cfargument name="LanguageID" default="" type="numeric" required="true">
		
		<cfset ReturnValue="">
		
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductFamilyID"
			returnVariable="CurrentProductFamilyID"
			ProductID="#ARGUMENTS.ProductID#">
		<!--- First check if there is brochure at the product family level--->	
		<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
			SELECT * FROM t_ProductAttribute
			WHERE ProductFamilyAttributeID=<cfqueryparam cfsqltype="cf_sql_integer" value="1224"> AND 
			CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(CurrentProductFamilyID)#"> and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
		</cfquery>
		
		<cfoutput query="GetItems">
			<cfif AttributeValue IS NOT "">
				<Cfset ReturnValue="#AttributeValue#">
			</cfif>
		</cfoutput>
		
		<cfif ReturnValue IS "">
			<!--- else check the support page --->
			<cfquery name="GetProductFamilyName" datasource="#APPLICATION.DSN#">
				select CategoryName,ParentID from t_Category Where CategoryID=#Val(CurrentProductFamilyID)#
			</cfquery>
			<cfquery name="GetName" datasource="#APPLICATION.DSN#">
				select CategoryName from t_Category Where CategoryID=#Val(GetProductFamilyName.ParentID)#
			</cfquery>
			<cfquery name="GetContentID" datasource="#APPLICATION.DSN#">
				select ContentID 
				from qry_GetContent
				WHERE ContentActive=1 and ContentTypeID=222 and CategoryAlias='downloadbrochure_1' and ContentName='#GetName.CategoryName#'
			</cfquery>
			<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetContent">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(GetContentID.ContentID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ARGUMENTS.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>
			<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
				select PropertiesPacket 
				from t_Properties 
				WHERE PropertiesID=#Val(GetContent.contentLocalePropertiesID)#
			</cfquery>
			
			<cfif IsWDDX(GetContent.ContentBody)>
				<cfwddx action="WDDX2CFML" input="#GetContent.ContentBody#" output="sProperties">
				<cfif StructKeyExists(sProperties,"aFile") AND IsArray(sProperties.aFile)>
					<cfloop index="i" from="1" to="#ArrayLen(sProperties.aFile)#" step="1">
						<cfif Trim(sProperties.AFile[i].FileName) is Trim(GetProductFamilyName.CategoryName)>
							<cfset ReturnValue="#sProperties.AFile[i].FilePath#">
							<cfreturn ReturnValue>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn ReturnValue>
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
					<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.salco.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
				<cfelse>
					<cfset QuerySetCell(qReturn,"ProductThumbnailURL","http://www.staging.salco.01.thirdwaveweb.com#MyProduct.GetProperty('ProductThumbnailPath')#")>
				</cfif>
			</cfif>
			
			<cfif MyProduct.GetProperty("ProductThumbnailHoverPath") IS NOT "">
				<cfif APPLICATION.Production>
					<cfset QuerySetCell(qReturn,"ProductRolloverURL","http://www.salco.com#MyProduct.GetProperty('ProductThumbnailHoverPath')#")>
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
	
	<cffunction name="DeactivateProduct" output="false" returntype="boolean">
		<cfargument name="CategoryID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		<cfargument name="UserID" default="" type="numeric" required="true">
		<cfargument name="SaveToProduction" default="0" type="boolean" required="false">
		
		<cfquery name="GetCategoryTypeID" datasource="#APPLICATION.DSN#">
			SELECT CategoryTypeID FROM  t_Category 
			WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ARGUMENTS.CategoryID)#">
		</cfquery>
		
		<!--- IF Category Exists --->
		<cfif GetCategoryTypeID.RecordCount GT 0>
			
			<cfset thisCategoryTypeID = GetCategoryTypeID.CategoryTypeID>
			
			<cfswitch expression="#thisCategoryTypeID#">
				<cfcase value="62"><!--- Product Family --->
					<!--- GET ALL 'Content W/ Product Family' Categories for this Product Family --->
					<cfquery name="getProdFamCategories" datasource="#APPLICATION.DSN#">
						SELECT CategoryID AS CatID FROM t_Category
						WHERE SourceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ARGUMENTS.CategoryID)#">
						AND CategoryTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="162">
					</cfquery>
					
					<cfoutput query="getProdFamCategories">
						<!--- if master locale, deactivate category --->
						<cfif Val(ARGUMENTS.LocaleID) EQ 1>
							<cfquery name="DeactivateProdFamCategory" datasource="#APPLICATION.DSN#">
								UPDATE t_Category
									SET CategoryActive = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
								WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(CatID)#">
							</cfquery>
							
							<cfif ARGUMENTS.SaveToProduction>
								<cfinvoke component="/com/ContentManager/CategoryHandler" 
									method="GetProductionSiteInformation"
									returnVariable="sProductionSiteInformation"
									CategoryID="#val(CatID)#">
								<cfif IsStruct(sProductionSiteInformation)>
									<cfquery name="DeactivateProdFamCategory_Production" datasource="#sProductionSiteInformation.ProductionDBDSN#">
										UPDATE t_Category
											SET CategoryActive = 0, CachedateTime=getdate()
										WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(CatID)#">
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
						
						<!--- Try to get 'Content W/ Product Family' Category Locale --->
						<cfquery name="getProdFamCategoryLocale" datasource="#APPLICATION.DSN#" maxrows="1">
							SELECT CategoryLocaleID FROM t_CategoryLocale
							WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(CatID)#">
							AND LocaleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ARGUMENTS.LocaleID)#">
						</cfquery>
						<!--- If Category Locale exists deactivate, else create a new one, deactivate and save  --->
						<cfif getProdFamCategoryLocale.RecordCount GT 0>
							<cfquery name="UpdateCategoryLocale" datasource="#APPLICATION.DSN#">
								UPDATE t_CategoryLocale
									SET CategoryLocaleActive = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
								WHERE CategoryLocaleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(getProdFamCategoryLocale.CategoryLocaleID)#">
							</cfquery>
							<cfif ARGUMENTS.SaveToProduction>
								<cfset thisCategoryLocale = CreateObject("component","com.ContentManager.CategoryLocale")>
								<cfset thisCategoryLocale.Constructor(val(getProdFamCategoryLocale.CategoryLocaleID))>
								<cfset thisCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
								<cfset ThisCategoryIDToSave=thisCategoryLocale.GetProperty("CategoryID")>
								<cfinvoke component="/com/ContentManager/CategoryHandler" 
									method="GetProductionSiteInformation"
									returnVariable="sProductionSiteInformation"
									CategoryID="#val(ThisCategoryIDToSave)#">
								<cfif IsStruct(sProductionSiteInformation)>
									<cfquery name="TouchCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
										UPDATE t_Category
											SET CachedateTime=getdate()
										WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ThisCategoryIDToSave)#">
									</cfquery>
								</cfif>
							</cfif>
						<cfelse>
							<cfset thisCategoryLocale = CreateObject("component","com.ContentManager.CategoryLocale")>
							<cfset thisCategoryLocale.Constructor()>
							<cfset thisCategoryLocale.SetProperty("CategoryID",val(CatID))>
							<cfset thisCategoryLocale.SetProperty("LocaleID",ARGUMENTS.LocaleID)>
							<cfset thisCategoryLocale.SetProperty("CategoryLocaleActive",0)>
							<cfset thisCategoryLocale.Save(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
							<cfif ARGUMENTS.SaveToProduction>
								<cfset thisCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
								<cfset ThisCategoryIDToSave=thisCategoryLocale.GetProperty("CategoryID")>
								<cfinvoke component="/com/ContentManager/CategoryHandler" 
									method="GetProductionSiteInformation"
									returnVariable="sProductionSiteInformation"
									CategoryID="#val(ThisCategoryIDToSave)#">
								<cfif IsStruct(sProductionSiteInformation)>
									<cfquery name="TouchCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
										UPDATE t_Category
											SET CachedateTime=getdate()
										WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ThisCategoryIDToSave)#">
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
					</cfoutput>
				</cfcase>
				
				<cfcase value="64"><!--- Product --->
					<!--- GET ALL 'Content W/ Product' Categories for this Product --->
					<cfquery name="getProdCategories" datasource="#APPLICATION.DSN#">
						SELECT CategoryID AS CatID FROM t_Category
						WHERE SourceID = #val(ARGUMENTS.CategoryID)#
						AND CategoryTypeID = 164
					</cfquery>
					<cfoutput query="getProdCategories">
						<!--- if master locale, deactivate category --->
						<cfif Val(ARGUMENTS.LocaleID) EQ 1>
							<cfquery name="DeactivateProdCategory" datasource="#APPLICATION.DSN#">
								UPDATE t_Category
									SET CategoryActive = 0
								WHERE CategoryID = #val(CatID)#
							</cfquery>
							
							<cfif ARGUMENTS.SaveToProduction>
								<cfinvoke component="/com/ContentManager/CategoryHandler" 
									method="GetProductionSiteInformation"
									returnVariable="sProductionSiteInformation"
									CategoryID="#val(CatID)#">
								<cfif IsStruct(sProductionSiteInformation)>
									<cfquery name="DeactivateProdCategory_Production" datasource="#sProductionSiteInformation.ProductionDBDSN#">
										UPDATE t_Category
											SET CategoryActive = 0, CachedateTime=getdate()
										WHERE CategoryID = #val(CatID)#
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
						<!--- Try to get 'Content W/ Product' Category Locale --->
						<cfquery name="getProdCategoryLocale" datasource="#APPLICATION.DSN#" maxrows="1">
							SELECT CategoryLocaleID FROM t_CategoryLocale
							WHERE CategoryID = #val(CatID)#
							AND LocaleID = #val(ARGUMENTS.LocaleID)#
						</cfquery>
						<!--- If Category Locale exists deactivate, else create a new one, deactivate and save  --->
						<cfif getProdCategoryLocale.RecordCount GT 0>
							<cfquery name="UpdateCategoryLocale" datasource="#APPLICATION.DSN#">
								UPDATE t_CategoryLocale
									SET CategoryLocaleActive = 0
								WHERE CategoryLocaleID = #val(getProdCategoryLocale.CategoryLocaleID)#
							</cfquery>
							<cfif ARGUMENTS.SaveToProduction>
								<cfset thisCategoryLocale = CreateObject("component","com.ContentManager.CategoryLocale")>
								<cfset thisCategoryLocale.Constructor(val(getProdCategoryLocale.CategoryLocaleID))>
								<cfset thisCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
								<cfset ThisCategoryIDToSave=thisCategoryLocale.GetProperty("CategoryID")>
								<cfinvoke component="/com/ContentManager/CategoryHandler" 
									method="GetProductionSiteInformation"
									returnVariable="sProductionSiteInformation"
									CategoryID="#val(ThisCategoryIDToSave)#">
								<cfif IsStruct(sProductionSiteInformation)>
									<cfquery name="TouchCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
										UPDATE t_Category
											SET CachedateTime=getdate()
										WHERE CategoryID = #val(ThisCategoryIDToSave)#
									</cfquery>
								</cfif>
							</cfif>
						<cfelse>
							<cfset thisCategoryLocale = CreateObject("component","com.ContentManager.CategoryLocale")>
							<cfset thisCategoryLocale.Constructor()>
							<cfset thisCategoryLocale.SetProperty("CategoryID",val(CatID))>
							<cfset thisCategoryLocale.SetProperty("LocaleID",ARGUMENTS.LocaleID)>
							<cfset thisCategoryLocale.SetProperty("CategoryLocaleActive",0)>
							<cfset thisCategoryLocale.Save(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
							<cfif ARGUMENTS.SaveToProduction>
								<cfset thisCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
								<cfset ThisCategoryIDToSave=thisCategoryLocale.GetProperty("CategoryID")>
								<cfinvoke component="/com/ContentManager/CategoryHandler" 
									method="GetProductionSiteInformation"
									returnVariable="sProductionSiteInformation"
									CategoryID="#val(ThisCategoryIDToSave)#">
								<cfif IsStruct(sProductionSiteInformation)>
									<cfquery name="TouchCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
										UPDATE t_Category
											SET CachedateTime=getdate()
										WHERE CategoryID = #val(ThisCategoryIDToSave)#
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
					</cfoutput>
				</cfcase>
				<!--- IF 'Content' get sourceID and call deactivate  --->
				<cfcase value="162,163,164">
					<cfset retval = 0>
					<cfquery name="getSourceID" datasource="#APPLICATION.DSN#" maxrows="1">
						SELECT SourceID FROM t_Category
						WHERE CategoryID = #val(ARGUMENTS.CategoryID)#
					</cfquery>
					<cfif getSourceID.RecordCount GT 0>
						<cfinvoke component="/com/Product/ProductHandler" method="DeactivateProduct" 
							returnVariable="retval"
							CategoryID="#val(getSourceID.SourceID)#"
							LocaleID="#ARGUMENTS.LocaleID#"
							UserID="#ARGUMENTS.UserID#"
							SaveToProduction="#ARGUMENTS.SaveToProduction#">
					</cfif>
					<cfreturn retval>
				</cfcase>
				
			</cfswitch>
			
			<!--- IF 'Product', deactivate locale --->
			<cfif ListFind("62,64",thisCategoryTypeID)>
				<cfquery name="CheckCategoryLocale" datasource="#APPLICATION.DSN#" maxrows="1">
					SELECT CategoryLocaleID FROM  t_CategoryLocale 
					WHERE CategoryID = #val(ARGUMENTS.CategoryID)#
					AND LocaleID = #val(ARGUMENTS.LocaleID)#
				</cfquery>
				
				<!--- if master locale, deactivate category --->
				<cfif Val(ARGUMENTS.LocaleID) EQ 1>
					<cfquery name="DeactivateProduct" datasource="#APPLICATION.DSN#">
						UPDATE t_Category
							SET CategoryActive = 0
						WHERE CategoryID = #val(ARGUMENTS.CategoryID)#
					</cfquery>
					
					<cfif ARGUMENTS.SaveToProduction>
						<cfinvoke component="/com/ContentManager/CategoryHandler" 
							method="GetProductionSiteInformation"
							returnVariable="sProductionSiteInformation"
							CategoryID="#val(ARGUMENTS.CategoryID)#">
						<cfif IsStruct(sProductionSiteInformation)>
							<cfquery name="DeactivateProduct_Production" datasource="#sProductionSiteInformation.ProductionDBDSN#">
								UPDATE t_Category
									SET CategoryActive = 0, CachedateTime=getdate()
								WHERE CategoryID = #val(ARGUMENTS.CategoryID)#
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				
				<!--- If Category Locale exists deactivate, else create a new one, deactivate and save  --->
				<cfif CheckCategoryLocale.RecordCount GT 0>
					<cfquery name="UpdateCategoryLocale" datasource="#APPLICATION.DSN#">
						UPDATE t_CategoryLocale
							SET CategoryLocaleActive = 0
						WHERE CategoryLocaleID = #val(CheckCategoryLocale.CategoryLocaleID)#
					</cfquery>
					<cfif ARGUMENTS.SaveToProduction>
						<cfset thisCategoryLocale = CreateObject("component","com.ContentManager.CategoryLocale")>
						<cfset thisCategoryLocale.Constructor(val(CheckCategoryLocale.CategoryLocaleID))>
						<cfset thisCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
						<cfset ThisCategoryIDToSave=thisCategoryLocale.GetProperty("CategoryID")>
						<cfinvoke component="/com/ContentManager/CategoryHandler" 
							method="GetProductionSiteInformation"
							returnVariable="sProductionSiteInformation"
							CategoryID="#val(ThisCategoryIDToSave)#">
						<cfif IsStruct(sProductionSiteInformation)>
							<cfquery name="TouchCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
								UPDATE t_Category
									SET CachedateTime=getdate()
								WHERE CategoryID = #val(ThisCategoryIDToSave)#
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfset thisCategoryLocale = CreateObject("component","com.ContentManager.CategoryLocale")>
					<cfset thisCategoryLocale.Constructor()>
					<cfset thisCategoryLocale.SetProperty("CategoryID",ARGUMENTS.CategoryID)>
					<cfset thisCategoryLocale.SetProperty("LocaleID",ARGUMENTS.LocaleID)>
					<cfset thisCategoryLocale.SetProperty("CategoryLocaleActive",0)>
					<cfset thisCategoryLocale.Save(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
					<cfif ARGUMENTS.SaveToProduction>
						<cfset thisCategoryLocale.SaveToProduction(APPLICATION.WebrootPath,ARGUMENTS.UserID)>
						<cfset ThisCategoryIDToSave=thisCategoryLocale.GetProperty("CategoryID")>
						<cfinvoke component="/com/ContentManager/CategoryHandler" 
							method="GetProductionSiteInformation"
							returnVariable="sProductionSiteInformation"
							CategoryID="#val(ThisCategoryIDToSave)#">
						<cfif IsStruct(sProductionSiteInformation)>
							<cfquery name="TouchCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
								UPDATE t_Category
									SET CachedateTime=getdate()
								WHERE CategoryID = #val(ThisCategoryIDToSave)#
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			<cfreturn 1>
		</cfif>
		<cfreturn 0>
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
	
	<cffunction name="GetlConsoleAlias" returntype="string" output="false">
		<cfargument name="ProductID" default="" type="numeric" required="true">
		<cfquery name="GetConsoles" datasource="#APPLICATION.DSN#">
			SELECT     t_Console.CategoryAlias AS ConsoleAlias
			FROM         t_Category t_Console INNER JOIN
                      t_ProductCombination ON t_Console.CategoryID = t_ProductCombination.ProductID2
			where ProductCombinationActive=1 and ProductID1=#Val(ARGUMENTS.ProductID)# and LanguageID=100
		</cfquery>
		<cfset ReturnList="">
		<cfoutput query="GetConsoles">
			<cfif ListFindNoCase(ReturnList,ConsoleAlias) is "0">
				<cfset ReturnList=ListAppend(ReturnList,ConsoleAlias)>
			</cfif>
		</cfoutput>
		<cfreturn ReturnList>
	</cffunction>
</cfcomponent>