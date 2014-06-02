<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="ProductID" type="numeric" default="">
	<cfproperty name="LanguageID" type="numeric" default="">
	<cfproperty name="ProductLongName" type="string" default="">
	<cfproperty name="ProductPositioningSentence" type="string" default="">
	<cfproperty name="ProductDescription" type="string" default="">
	<cfproperty name="CallToActionURLDeprecated" type="string" default="">
	<cfproperty name="VideoURL" type="string" default="">
	<cfproperty name="PartNumber" type="string" default="">
	<cfproperty name="BrochurePath" type="string" default="">
	<cfproperty name="PublicDrawing" type="string" default="">
	<cfproperty name="ProductImagePath" type="string" default="">
	<cfproperty name="ProductThumbnailPath" type="string" default="">
	<cfproperty name="ProductThumbnailHoverPath" type="string" default="">
	<cfproperty name="ProductImageSourcePath" type="string" default="">
	<cfproperty name="ProductImageStorePath" type="string" default="">
	<cfproperty name="PublicDrawingSize" type="string" default="">
	<cfproperty name="aProductFeature" type="array" default="">
	<cfproperty name="aProductBullet" type="array" default="">
	<cfproperty name="aProductReview" type="array" default="">
	<cfproperty name="aProductView" type="array" default="">
	<cfproperty name="aProductDownload" type="array" default="">
	<cfproperty name="aProductAttribute" type="array" default="">
	
	<cfset structInsert(sPropertyDisplayName,"ProductID","product ID",1)>
	<cfset structInsert(sPropertyDisplayName,"LanguageID","language ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductLongName","long name",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductShortName","short name",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductPositioningSentence","positioning sentence",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductDescription","description",1)>
	<cfset structInsert(sPropertyDisplayName,"CallToActionURLDeprecated","category URL",1)>
	<cfset structInsert(sPropertyDisplayName,"VideoURL","video URL",1)>
	<cfset structInsert(sPropertyDisplayName,"PartNumber","part number",1)>
	<cfset structInsert(sPropertyDisplayName,"BrochurePath","brochure",1)>
	<cfset structInsert(sPropertyDisplayName,"PublicDrawing","compare gym brochure",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductImagePath","on image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductThumbnailPath","highlight image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductThumbnailHoverPath","thumbmnail hover image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductImageSourcePath","source image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductImageStorePath","store image",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductFeature","product feature array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductBullet","product bullet point array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductReview","product review array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductView","product view array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductDownload","product download array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductAttribute","product attributes array",1)>
	
	<!--- If these change, make sure to change in handler too. --->
	<cfset this.sAttributeID=StructNew()>
	<cfset StructInsert(this.sAttributeID,"ProductLongName","4",1)>
	<cfset StructInsert(this.sAttributeID,"ProductShortName","5",1)>
	<cfset StructInsert(this.sAttributeID,"ProductPositioningSentence","6",1)>
	<cfset StructInsert(this.sAttributeID,"ProductDescription","7",1)>
	<cfset StructInsert(this.sAttributeID,"CallToActionURLDeprecated","8",1)>
	<cfset StructInsert(this.sAttributeID,"VideoURL","9",1)>
	<cfset StructInsert(this.sAttributeID,"PartNumber","10",1)>
	<cfset StructInsert(this.sAttributeID,"BrochurePath","11",1)>
	<cfset StructInsert(this.sAttributeID,"PublicDrawing","12",1)>
	<cfset StructInsert(this.sAttributeID,"ProductImagePath","13",1)>
	<cfset StructInsert(this.sAttributeID,"ProductThumbnailPath","14",1)><!--- Will always come from English --->
	<cfset StructInsert(this.sAttributeID,"ProductThumbnailHoverPath","15",1)>
	<cfset StructInsert(this.sAttributeID,"ProductImageSourcePath","16",1)>
	<cfset StructInsert(this.sAttributeID,"ProductImageStorePath","17",1)>
	<cfset StructInsert(this.sAttributeID,"PublicDrawingSize","23",1)>
	
	<cfset this.lAttributeID="4,5,6,7,8,9,10,11,12,13,14,15,16,17,23">
	<cfset this.sAttribute=StructNew()>
	<cfloop index="ThisKey" list="#StructKeyList(this.sAttributeID)#">
		<cfset StructInsert(this.sAttribute,this.sAttributeID[thisKey],ThisKey,1)>
	</cfloop>
	
	<cffunction name="constructor" returntype="boolean" output="true">
		<cfargument name="ID" default="0" type="numeric" required="false">
		<cfargument name="LanguageID" default="0" type="numeric" required="false">
		<!--- Typically, use set methods in contructor. --->
		<cfset aBlank=ArrayNew(1)>
		<cfset this.SetProperty("ProductID",ARGUMENTS.ID)>
		<cfset this.SetProperty("LanguageID",ARGUMENTS.LanguageID)>
		<cfset this.SetProperty("ProductLongName","")>
		<cfset this.SetProperty("ProductShortName","")>
		<cfset this.SetProperty("ProductPositioningSentence","")>
		<cfset this.SetProperty("ProductDescription","")>
		<cfset this.SetProperty("CallToActionURLDeprecated","")>
		<cfset this.SetProperty("VideoURL","")>
		<cfset this.SetProperty("PartNumber","")>
		<cfset this.SetProperty("BrochurePath","")>
		<cfset this.SetProperty("PublicDrawing","")>
		<cfset this.SetProperty("PublicDrawingSize","")>
		<cfset this.SetProperty("ProductImagePath","")>
		<cfset this.SetProperty("ProductThumbnailPath","")>
		<cfset this.SetProperty("ProductThumbnailHoverPath","")>
		<cfset this.SetProperty("ProductImageSourcePath","")>
		<cfset this.SetProperty("ProductImageStorePath","")>
		<cfset this.SetProperty("aProductFeature",aBlank)>
		<cfset this.SetProperty("aProductBullet",aBlank)>
		<cfset this.SetProperty("aProductReview",aBlank)>
		<cfset this.SetProperty("aProductView",aBlank)>
		<cfset this.SetProperty("aProductDownload",aBlank)>
		<cfset this.SetProperty("aProductAttribute",aBlank)>
		
		<cfif Val(ARGUMENTS.ID) GT 0 AND Val(ARGUMENTS.LanguageID) GT "0">
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT ProductFamilyAttributeID,AttributeValue FROM t_ProductAttribute
				WHERE 
				ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#this.lAttributeID#" List="yes">) AND 
				CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
			</cfquery>

			<cfoutput query="GetItems">
				<Cfset this.SetProperty(this.sAttribute[ProductFamilyAttributeID],AttributeValue)>
			</cfoutput>
				
			<cfquery name="GetItemsEnglish" datasource="#APPLICATION.DSN#">
				SELECT ProductFamilyAttributeID,AttributeValue FROM t_ProductAttribute
				WHERE 
				ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="14,15" list="yes">) AND 
				CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(APPLICATION.DefaultLanguageID)#">
			</cfquery>
			<cfoutput query="GetItemsEnglish">
				<Cfset this.SetProperty(this.sAttribute[ProductFamilyAttributeID],AttributeValue)>
			</cfoutput>
			
			
			<cfquery name="GetFeatures" datasource="#APPLICATION.DSN#">
				select TextBlockID,TextBlock,SpecificationSetID from qry_GetTextBlock
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> AND 
				TextBlockTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="900">
				Order by TextBlockPriority
			</cfquery>
			<cfif GetFeatures.RecordCount GT "0">
				<cfoutput query="GetFeatures">
					<cfset sFeatureElt=StructNew()>
					<Cfset StructInsert(sFeatureElt,"TextBlockID",TextBlockID,1)>
					<Cfset StructInsert(sFeatureElt,"TextBlock",TextBlock,1)>
					<Cfset StructInsert(sFeatureElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sFeatureElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductFeature",aBlank)>
			</cfif>
			
			<cfquery name="GetBullets" datasource="#APPLICATION.DSN#">
				select TextBlockID,TextBlock,SpecificationSetID from qry_GetTextBlock
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> AND 
				TextBlockTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="902">
				Order by TextBlockPriority
			</cfquery>
			<cfif GetBullets.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetBullets">
					<cfset sFeatureElt=StructNew()>
					<Cfset StructInsert(sFeatureElt,"TextBlockID",TextBlockID,1)>
					<Cfset StructInsert(sFeatureElt,"TextBlock",TextBlock,1)>
					<Cfset StructInsert(sFeatureElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sFeatureElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductBullet",aBlank)>
			</cfif>
			
			<cfquery name="GetReviews" datasource="#APPLICATION.DSN#">
				select TextBlockID,TextBlock,SpecificationSetID from qry_GetTextBlock
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> AND 
				TextBlockTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="901">
				Order by TextBlockPriority
			</cfquery>
			<cfif GetReviews.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetReviews">
					<cfset sFeatureElt=StructNew()>
					<Cfset StructInsert(sFeatureElt,"TextBlockID",TextBlockID,1)>
					<Cfset StructInsert(sFeatureElt,"TextBlockName",TextBlockName,1)>
					<Cfset StructInsert(sFeatureElt,"TextBlock",TextBlock,1)>
					<cfset arrayAppend(aBlank,sFeatureElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductReview",aBlank)>
			</cfif>
			
			<cfquery name="GetView" datasource="#APPLICATION.DSN#">
				select ResourceID,ResourceName,ResourceText,ResourceSize,SpecificationSetID from qry_GetResource
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> and
				ResourceTypeID=9000
				Order by ResourcePriority
			</cfquery>
			
			<cfquery name="GetViewEnglish" datasource="#APPLICATION.DSN#">
				select ResourceID,MainFilePath,ThumbnailFilePath from qry_GetResource
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(APPLICATION.DefaultLanguageID)#"> and
				ResourceTypeID=9000
				Order by ResourcePriority
			</cfquery>
			
			<cfset sViewMainFilePath=StructNew()>
			<cfset sViewThumbnailFilePath=StructNew()>
			<cfoutput query="GetViewEnglish">
				<cfset StructInsert(sViewMainFilePath,ResourceID,MainFilePath)>
				<cfset StructInsert(sViewThumbnailFilePath,ResourceID,ThumbnailFilePath)>
			</cfoutput>
			
			<cfif GetView.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetView">
					<cfset sViewElt=StructNew()>
					<Cfset StructInsert(sViewElt,"ResourceID",ResourceID,1)>
					<Cfset StructInsert(sViewElt,"ResourceName",ResourceName,1)>
					<Cfset StructInsert(sViewElt,"ResourceText",ResourceText,1)>
					<Cfset StructInsert(sViewElt,"MainFilePath","",1)>
					<Cfset StructInsert(sViewElt,"ThumbnailFilePath","",1)>
					<Cfset StructInsert(sViewElt,"MainFileSize",ResourceSize,1)>
					<cfif StructKeyExists(sViewMainFilePath,ResourceID)>
						<Cfset StructInsert(sViewElt,"MainFilePath",sViewMainFilePath[ResourceID],1)>
					</cfif>
					<cfif StructKeyExists(sViewThumbnailFilePath,ResourceID)>
						<Cfset StructInsert(sViewElt,"ThumbnailFilePath",sViewThumbnailFilePath[ResourceID],1)>
					</cfif>
					<Cfset StructInsert(sViewElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sViewElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductView",aBlank)>
			</cfif>
			
			<cfquery name="GetDownload" datasource="#APPLICATION.DSN#">
				select ResourceID,ResourceName,ResourceText,ResourceSize,SpecificationSetID from qry_GetResource
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> and
				ResourceTypeID=9001
				Order by ResourcePriority
			</cfquery>
			
			<cfquery name="GetDownloadEnglish" datasource="#APPLICATION.DSN#">
				select ResourceID,MainFilePath,ThumbnailFilePath from qry_GetResource
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(APPLICATION.DefaultLanguageID)#"> and
				ResourceTypeID=9001
				Order by ResourcePriority
			</cfquery>
			
			<cfset sDownloadMainFilePath=StructNew()>
			<cfset sDownloadThumbnailFilePath=StructNew()>
			<cfoutput query="GetDownloadEnglish">
				<cfset StructInsert(sDownloadMainFilePath,ResourceID,MainFilePath)>
				<cfset StructInsert(sDownloadThumbnailFilePath,ResourceID,ThumbnailFilePath)>
			</cfoutput>
			
			<cfif GetDownload.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetDownload">
					<cfset sDownloadElt=StructNew()>
					<Cfset StructInsert(sDownloadElt,"ResourceID",ResourceID,1)>
					<Cfset StructInsert(sDownloadElt,"ResourceName",ResourceName,1)>
					<Cfset StructInsert(sDownloadElt,"ResourceText",ResourceText,1)>
					<Cfset StructInsert(sDownloadElt,"MainFilePath","",1)>
					<Cfset StructInsert(sDownloadElt,"ThumbnailFilePath","",1)>
					<Cfset StructInsert(sDownloadElt,"MainFileSize",ResourceSize,1)>
					<cfif StructKeyExists(sDownloadMainFilePath,ResourceID)>
						<Cfset StructInsert(sDownloadElt,"MainFilePath",sDownloadMainFilePath[ResourceID],1)>
					</cfif>
					<cfif StructKeyExists(sDownloadThumbnailFilePath,ResourceID)>
						<Cfset StructInsert(sDownloadElt,"ThumbnailFilePath",sDownloadThumbnailFilePath[ResourceID],1)>
					</cfif>
					<Cfset StructInsert(sDownloadElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sDownloadElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductDownload",aBlank)>
			</cfif>
			
			<cfset ThisProductFamilyID=this.GetProductFamilyID()>
			<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
				select AttributeValueID,AttributeValue,ProductFamilyAttributeID from qry_GetProductAttribute 
				WHERE 
				CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ThisProductFamilyID)#"> And 
				ProductID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> And 
				LanguageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> And 
				AttributeLanguageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
				ORDER By ProductFamilyAttributePriority
			</cfquery>
			<cfset sValues=StructNew()>
			<cfoutput query="GetAttributes">
				<cfset sValueElt=StructNew()>
				<cfset StructInsert(sValueElt,"AttributeValueID",AttributeValueID,1)>
				<cfset StructInsert(sValueElt,"AttributeValue",AttributeValue,1)>
				<cfset StructInsert(sValues,ProductFamilyAttributeID,sValueElt,1)>
			</cfoutput>
			
			<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
				SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID FROM qry_GetProductFamilyAttribute 
				WHERE CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ThisProductFamilyID)#">
				order by ProductFamilyAttributePriority
			</cfquery>
			
			
			<cfset aBlank=ArrayNew(1)>
			<cfoutput query="GetCols" group="ProductFamilyAttributeID">
				<cfset sAttributeElt=StructNew()>
				<Cfset StructInsert(sAttributeElt,"ProductFamilyAttributeID",ProductFamilyAttributeID,1)>
				<Cfset StructInsert(sAttributeElt,"ProductFamilyAttributeTypeID",ProductFamilyAttributeTypeID,1)>
				<cfif StructKeyExists(sValues,ProductFamilyAttributeID)>
					<Cfset StructInsert(sAttributeElt,"AttributeValue",sValues[ProductFamilyAttributeID].AttributeValue,1)>
				<cfelse>
					<Cfset StructInsert(sAttributeElt,"AttributeValue","",1)>
				</cfif>
				<cfif StructKeyExists(sValues,ProductFamilyAttributeID)>
					<Cfset StructInsert(sAttributeElt,"AttributeValueID",sValues[ProductFamilyAttributeID].AttributeValueID,1)>
				<cfelse>
					<Cfset StructInsert(sAttributeElt,"AttributeValueID","",1)>
				</cfif>
				<cfset arrayAppend(aBlank,sAttributeElt)>
			</cfoutput>
			<cfset this.SetProperty("aProductAttribute",aBlank)>
			
			
			<cfreturn true>
			
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="1">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">
		<cfif isCorrect()>
			<cfset thisProductID=this.GetProperty("ProductID")>
			<cfset thisLanguageID=this.GetProperty("LanguageID")>
			<cfset thisProductLongName=this.GetProperty("ProductLongName")>
			<cfset thisProductShortName=this.GetProperty("ProductShortName")>
			<cfset thisProductPositioningSentence=this.GetProperty("ProductPositioningSentence")>
			<cfset thisProductDescription=this.GetProperty("ProductDescription")>
			<cfset thisCallToActionURLDeprecated=this.GetProperty("CallToActionURLDeprecated")>
			<cfset thisVideoURL=this.GetProperty("VideoURL")>
			<cfset thisPartNumber=this.GetProperty("PartNumber")>
			<cfset thisBrochurePath=this.GetProperty("BrochurePath")>
			<cfset thisPublicDrawing=this.GetProperty("PublicDrawing")>
			<cfset thisPublicDrawingSize=this.GetProperty("PublicDrawingSize")>
			<cfset thisProductImagePath=this.GetProperty("ProductImagePath")>
			<cfset thisProductThumbnailPath=this.GetProperty("ProductThumbnailPath")>
			<cfset thisProductThumbnailHoverPath=this.GetProperty("ProductThumbnailHoverPath")>
			<cfset thisProductImageSourcePath=this.GetProperty("ProductImageSourcePath")>
			<cfset thisProductImageStorePath=this.GetProperty("ProductImageStorePath")>
			<cfset thisAProductBullet=this.GetProperty("AProductBullet")>
			<cfset thisAProductFeature=this.GetProperty("AProductFeature")>
			<cfset thisAProductReview=this.GetProperty("aProductReview")>
			<cfset thisAProductView=this.GetProperty("AProductView")>
			<cfset thisAProductDownload=this.GetProperty("aProductDownload")>
			<cfset thisAProductAttribute=this.GetProperty("AProductAttribute")>
			
			<cfif thisPublicDrawing IS NOT "" and FileExists(ExpandPath(thisPublicDrawing))>
				<cfset thisPublicDrawingSize=GetFileInfo(ExpandPath(thisPublicDrawing)).Size>
				<cfset this.SetProperty("PublicDrawingSize",thisPublicDrawingSize)>
			</cfif>
			
			<cfif thisProductThumbnailHoverPath IS "" and thisProductImageSourcePath IS NOT "">
				<cfinvoke component="/com/utils/image" 
					method="ResizeGalleryThumbnail" 
					returnVariable="thisProductThumbnailHoverPath"
					WebrootPath="#APPLICATION.WebrootPath#"
					Source="#thisProductImageSourcePath#"
					Width="310"
					Height="260">
				<cfset this.SetProperty("ProductThumbnailHoverPath",thisProductThumbnailHoverPath)>
			</cfif>
			
			<cfif thisProductImageStorePath IS "" and thisProductImageSourcePath IS NOT "">
				<cfinvoke component="/com/utils/image" 
					method="ResizeGalleryThumbnail" 
					returnVariable="thisProductImageStorePath"
					WebrootPath="#APPLICATION.WebrootPath#"
					Source="#thisProductImageSourcePath#"
					Width="500"
					Height="420">
				<cfset this.SetProperty("ProductImageStorePath",thisProductImageStorePath)>
			</cfif>
			
			<cfloop index="ThisID" list="#this.lAttributeID#">
				<cfset ThisValue=this.GetProperty(this.sAttribute[ThisID])>
				<cfquery name="test" datasource="#APPLICATION.DSN#">
					select * from t_ProductAttribute 
					WHERE CategoryID=#Val(ThisProductID)# AND LanguageID=#Val(ThisLanguageID)# AND ProductFamilyAttributeID=#Val(ThisID)#
				</cfquery>
				
				<cfif test.RecordCount GT "0">
					<cfquery name="update" datasource="#APPLICATION.DSN#">
						update t_ProductAttribute Set
						AttributeValue=N'#Trim(ThisValue)#'
						WHERE CategoryID=#Val(ThisProductID)# AND LanguageID=#Val(ThisLanguageID)# AND ProductFamilyAttributeID=#Val(ThisID)#
					</cfquery>
				<cfelse>
					<cfquery name="isnert" datasource="#APPLICATION.DSN#">
						INSERT INTO t_ProductAttribute 
						(CategoryID, LanguageID, ProductFamilyAttributeID, AttributeValue)
						VALUES
						(#Val(ThisProductID)#, #Val(ThisLanguageID)#, #Val(ThisID)#, N'#Trim(ThisValue)#')
					</cfquery>
				</cfiF>
			</cfloop>
			
			<cfquery name="GetPrev" datasource="#APPLICATION.DSN#">
				select * from qry_GetTextBlock
				WHERE KeyID=#Val(thisProductID)# and Entity='t_Category' and languageID=#Val(ThisLanguageID)# AND TextBlockTypeID=900
				Order by TextBlockPriority
			</cfquery>
			<cfset OriginalList=ValueList(GetPrev.TextBlockID)>
			<cfset NewList="">
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductFeature)#">
				<cfif thisAProductFeature[r].TextBlockID GT "0">
					<cfset NewList=ListAppend(NewList,thisAProductFeature[r].TextBlockID)>
				</cfif>
			</cfloop>
			
			<CF_Venn
				ListA="#OriginalList#"
				ListB="#NewList#"
				AnotB="ListToDelete">
				
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductFeature)#">
				<cfset ThisPriority=r*10>
				<cfset ThisSpecificationSetID=thisAProductFeature[r].SpecificationSetID>
				<cfif thisAProductFeature[r].TextBlockID GT "0">
					<cfset ThisTextBlockID=thisAProductFeature[r].TextBlockID>
					<cfquery name="Test" datasource="#APPLICATION.DSN#">
						select * from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
					</cfquery>
					<cfif Test.RecordCount IS "0">
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							Insert into t_TextBlockLanguage 
							(TextBlock, TextBlockID, LanguageID)
							VALUES
							(N'#Trim(thisAProductFeature[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
						</cfquery>
					<cfelse>
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_TextBlockLanguage Set
							TextBlock=N'#Trim(thisAProductFeature[r].TextBlock)#'
							WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
						</cfquery>
					</cfif>
					<cfquery name="updateTB" datasource="#APPLICATION.DSN#">
						update t_TextBlock set
						SpecificationSetID=#Val(ThisSpecificationSetID)#,
						TextBlockPriority=#Val(ThisPriority)#
						WHERE TextBlockID=#Val(ThisTextBlockID)# 
					</cfquery>
				<Cfelse>
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_TextBlock 
						(Entity, KeyID, TextBlockPriority,TextBlockTypeID, SpecificationSetID)
						VALUES
						('t_Category', #Val(thisProductID)# , #Val(ThisPriority)#, 900, #Val(ThisSpecificationSetID)#)
						SELECT NewID=@@Identity
					</cfquery>
					<cfset ThisTextBlockID=insert.NewID>
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						Insert into t_TextBlockLanguage 
						(TextBlock, TextBlockID, LanguageID)
						VALUES
						(N'#Trim(thisAProductFeature[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
					</cfquery>
				</cfif>
			</cfloop>
			
			<cfloop index="ThisID" list="#ListToDelete#">
				<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
					DELETE FROM t_TextBlockLanguage
					WHERE TextBlockID = #Val(ThisID)# AND LanguageID = #Val(ThisLanguageID)# 
				</cfquery>
				<!---
				<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
					UPDATE t_TextBlockLanguage set Languageid=#-Val(ThisLanguageID)# 
					WHERE TextBlockID=#Val(ThisID)# AND LanguageID = #Val(ThisLanguageID)# 
				</cfquery>
				--->
				<!--- <cfquery name="DeleteThis" datasource="#APPLICATION.DSN#">
					update t_TextBlock set KeyID=#0-thisProductID# WHERE TextBlockID=#Val(ThisID)#
				</cfquery> --->
			</cfloop>
			
			<!--- Handling bullets --->
			<cfquery name="GetPrev" datasource="#APPLICATION.DSN#">
				select * from qry_GetTextBlock
				WHERE KeyID=#Val(thisProductID)# and Entity='t_Category' and languageID=#Val(ThisLanguageID)# AND TextBlockTypeID=902
				Order by TextBlockPriority
			</cfquery>
			<cfset OriginalList=ValueList(GetPrev.TextBlockID)>
			<cfset NewList="">
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductBullet)#">
				<cfif thisAProductBullet[r].TextBlockID GT "0">
					<cfset NewList=ListAppend(NewList,thisAProductBullet[r].TextBlockID)>
				</cfif>
			</cfloop>
			
			<CF_Venn
				ListA="#OriginalList#"
				ListB="#NewList#"
				AnotB="ListToDelete">
				
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductBullet)#">
				<cfset ThisPriority=r*10>
				<cfset ThisSpecificationSetID=thisAProductBullet[r].SpecificationSetID>
				<cfif thisAProductBullet[r].TextBlockID GT "0">
					<cfset ThisTextBlockID=thisAProductBullet[r].TextBlockID>
					<cfquery name="Test" datasource="#APPLICATION.DSN#">
						select * from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
					</cfquery>
					<cfif Test.RecordCount IS "0">
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							Insert into t_TextBlockLanguage 
							(TextBlock, TextBlockID, LanguageID)
							VALUES
							(N'#Trim(thisAProductBullet[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
						</cfquery>
					<cfelse>
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_TextBlockLanguage Set
							TextBlock=N'#Trim(thisAProductBullet[r].TextBlock)#'
							WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
						</cfquery>
					</cfif>
					<cfquery name="updateTB" datasource="#APPLICATION.DSN#">
						update t_TextBlock set
						SpecificationSetID=#Val(ThisSpecificationSetID)#,
						TextBlockPriority=#Val(ThisPriority)#
						WHERE TextBlockID=#Val(ThisTextBlockID)# 
					</cfquery>
				<Cfelse>
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_TextBlock 
						(Entity, KeyID, TextBlockPriority,TextBlockTypeID, SpecificationSetID)
						VALUES
						('t_Category', #Val(thisProductID)# , #Val(ThisPriority)#, 902, #Val(ThisSpecificationSetID)#)
						SELECT NewID=@@Identity
					</cfquery>
					<cfset ThisTextBlockID=insert.NewID>
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						Insert into t_TextBlockLanguage 
						(TextBlock, TextBlockID, LanguageID)
						VALUES
						(N'#Trim(thisAProductBullet[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
					</cfquery>
				</cfif>
			</cfloop>
			
			<cfloop index="ThisID" list="#ListToDelete#">
				<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
					DELETE FROM t_TextBlockLanguage
					WHERE TextBlockID = #Val(ThisID)# AND LanguageID = #Val(ThisLanguageID)# 
				</cfquery>
				<!---
				<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
					UPDATE t_TextBlockLanguage set Languageid=#-Val(ThisLanguageID)# 
					WHERE TextBlockID=#Val(ThisID)# AND LanguageID = #Val(ThisLanguageID)# 
				</cfquery>
				--->
				<!--- <cfquery name="DeleteThis" datasource="#APPLICATION.DSN#">
					update t_TextBlock set KeyID=#0-thisProductID# WHERE TextBlockID=#Val(ThisID)#
				</cfquery> --->
			</cfloop>
			<!--- End Bullet Points --->
			
			
			<!--- Begin Product Reviews --->
			<cfquery name="GetPrev" datasource="#APPLICATION.DSN#">
				select * from qry_GetTextBlock
				WHERE KeyID=#Val(thisProductID)# and Entity='t_Category' and languageID=#Val(ThisLanguageID)# AND TextBlockTypeID=901
				Order by TextBlockPriority
			</cfquery>
			<cfset OriginalList=ValueList(GetPrev.TextBlockID)>
			<cfset NewList="">
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductReview)#">
				<cfif thisAProductReview[r].TextBlockID GT "0">
					<cfset NewList=ListAppend(NewList,thisAProductReview[r].TextBlockID)>
				</cfif>
			</cfloop>
			
			<CF_Venn
				ListA="#OriginalList#"
				ListB="#NewList#"
				AnotB="ListToDelete">
				
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductReview)#">
				<cfset ThisPriority=r*10>
				<cfif thisAProductReview[r].TextBlockID GT "0">
					<cfset ThisTextBlockID=thisAProductReview[r].TextBlockID>
					<cfquery name="Test" datasource="#APPLICATION.DSN#">
						select * from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
					</cfquery>
					<cfif Test.RecordCount IS "0">
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							Insert into t_TextBlockLanguage 
							(TextBlock, TextBlockName, TextBlockID, LanguageID)
							VALUES
							(N'#Trim(thisAProductReview[r].TextBlock)#', N'#Trim(thisAProductReview[r].TextBlockName)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
						</cfquery>
					<cfelse>
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_TextBlockLanguage Set
							TextBlock=N'#Trim(thisAProductReview[r].TextBlock)#',
							TextBlockName=N'#Trim(thisAProductReview[r].TextBlockName)#'
							WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
						</cfquery>
					</cfif>
					<cfquery name="updateTB" datasource="#APPLICATION.DSN#">
						update t_TextBlock set
						TextBlockPriority=#Val(ThisPriority)#
						WHERE TextBlockID=#Val(ThisTextBlockID)# 
					</cfquery>
				<Cfelse>
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_TextBlock 
						(Entity, KeyID, TextBlockPriority,TextBlockTypeID)
						VALUES
						('t_Category', #Val(thisProductID)# , #Val(ThisPriority)#, 901)
						SELECT NewID=@@Identity
					</cfquery>
					<cfset ThisTextBlockID=insert.NewID>
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						Insert into t_TextBlockLanguage 
						(TextBlock, TextBlockName, TextBlockID, LanguageID)
						VALUES
						(N'#Trim(thisAProductReview[r].TextBlock)#', N'#Trim(thisAProductReview[r].TextBlockName)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
					</cfquery>
				</cfif>
			</cfloop>
			
			<cfloop index="ThisID" list="#ListToDelete#">
				<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
					DELETE FROM t_TextBlockLanguage
					WHERE TextBlockID = #Val(ThisID)# AND LanguageID = #Val(ThisLanguageID)# 
				</cfquery>
				<!--- 
				<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
					UPDATE t_TextBlockLanguage SET Languageid=#-Val(ThisLanguageID)# 
					WHERE TextBlockID=#Val(ThisID)# AND Languageid = #Val(ThisLanguageID)# 
				</cfquery>
				<cfquery name="DeleteThis" datasource="#APPLICATION.DSN#">
					DELETE from t_TextBlock WHERE TextBlockID=#Val(ThisID)#
				</cfquery> --->
			</cfloop>
			
			<cfinvoke component="/com/product/ResourceHandler" method="SaveResource" returnVariable="bSuccess">
				<cfinvokeargument name="aResource" value="#thisaProductView#">
				<cfinvokeargument name="CategoryID" value="#thisProductID#">
				<cfinvokeargument name="LanguageID" value="#ThisLanguageID#">
				<cfinvokeargument name="ResourceTypeID" value="9000">
			</cfinvoke>
			
			<cfinvoke component="/com/product/ResourceHandler" method="SaveResource" returnVariable="bSuccess">
				<cfinvokeargument name="aResource" value="#thisaProductDownload#">
				<cfinvokeargument name="CategoryID" value="#thisProductID#">
				<cfinvokeargument name="LanguageID" value="#ThisLanguageID#">
				<cfinvokeargument name="ResourceTypeID" value="9001">
			</cfinvoke>
			
			<cfloop index="r" from="1" to="#ArrayLen(thisAProductAttribute)#">
				<cfquery name="Test" datasource="#APPLICATION.DSN#">
					select * from t_ProductAttribute WHERE 
					CategoryID=#Val(ThisProductid)# and LanguageID=#Val(ThisLanguageID)# 
					And ProductFamilyAttributeID=#Val(thisAProductAttribute[r].ProductFamilyAttributeID)#
				</cfquery>
				<!--- get benchmark date for product family --->
				<cfquery name="getBenchmarkDate" datasource="#APPLICATION.DSN#" maxrows="1">
					SELECT AttributeValue AS BenchmarkDate from t_ProductAttribute 
					WHERE CategoryID=#Val(This.GetProductFamilyID())# AND LanguageID=#Val(ThisLanguageID)# AND ProductFamilyAttributeID=1225
				</cfquery>
				
				<cfif Test.RecordCount IS "0">
					<cfquery name="insert" datasource="#APPLICATION.DSN#">
						Insert into t_ProductAttribute 
						(CategoryID, LanguageID, ProductFamilyAttributeID, AttributeValue, AttributeValueID,LastModified)
						VALUES
						(#Val(ThisProductid)#, #Val(ThisLanguageID)#, #Val(thisAProductAttribute[r].ProductFamilyAttributeID)#,
						N'#Trim(thisAProductAttribute[r].AttributeValue)#',#Val(thisAProductAttribute[r].AttributeValueID)#,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">)
					</cfquery>
				<cfelse>
				
				<!--- if benchmark date exists, check if value has changed --->
					<cfset valueChanged = 0>
					<cfif getBenchmarkDate.RecordCount GT 0>
						<cfif IsDate(getBenchmarkDate.BenchmarkDate)>
							<!---if value has changed, set flag on --->
							<cfif Trim(test.AttributeValue) NEQ Trim(thisAProductAttribute[r].AttributeValue)
								OR Val(test.AttributeValueID) NEQ Val(thisAProductAttribute[r].AttributeValueID)>
								<cfset valueChanged = 1>
							</cfif>
						</cfif>
					</cfif>
				
					<cfquery name="update" datasource="#APPLICATION.DSN#">
						update t_ProductAttribute Set
						AttributeValue=N'#Trim(thisAProductAttribute[r].AttributeValue)#',
						AttributeValueID=#Val(thisAProductAttribute[r].AttributeValueID)#
						<cfif valueChanged>,LastModified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#"></cfif>
						WHERE
						CategoryID=#Val(ThisProductid)# and LanguageID=#Val(ThisLanguageID)# 
						And ProductFamilyAttributeID=#Val(thisAProductAttribute[r].ProductFamilyAttributeID)#
					</cfquery>
				</cfif>
			</cfloop>
						
			<cfinvoke component="/com/ContentManager/CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Category"
				KeyID="#thisProductID#">
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="SetProperty" returntype="boolean" output="false">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">
		<cfset ARGUMENTS.Property=Trim(ARGUMENTS.Property)>
		
		<cfif IsSimpleValue(ARGUMENTS.Value)>
			<cfset ARGUMENTS.Value=Trim(ARGUMENTS.Value)>

			<cfif ListFindNoCase("ProductID,LanguageID",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsNumeric(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid number.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("",ARGUMENTS.Property) AND ARGUMENTS.VALUE IS NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("ProductID,LanguageID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("ProductLongName,ProductShortName,CallToActionURLDeprecated,PartNumber,VideoURL",ARGUMENTS.Property)>
				<cfif Len(ARGUMENTS.Value) GT "256">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 256 characters long.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("ProductId,LanguageID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="ProductID">
							<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Category">
								<cfinvokeargument name="FieldName" value="CategoryID">
								<cfinvokeargument name="FieldValue" value="#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="categoryID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="LanguageID">
							<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="60,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
					</cfswitch>
				<cfelse>
					<cfset ARGUMENTS.Value="-1">
				</cfif>
			</cfif>
		</cfif>
		
		<cfset SetVariable("this.#ARGUMENTS.Property#","#ARGUMENTS.Value#")>
		<cfset deleteError(ARGUMENTS.Property)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetProperty" returntype="Any" output="false">
		<cfargument name="Property" required="true">
		<cfif IsInError(ARGUMENTS.Property)>
			<cfreturn GetErrorValue(ARGUMENTS.Property)>
		<cfelse>
			<cfset ReturnValue=this["#ARGUMENTS.Property#"]>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>
	
	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('ProductID')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('ProductID')#"
			ResourceType="#ARGUMENTS.ResourceType#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('ProductID')#"
			ResourceType="#ARGUMENTS.ResourceType#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetProductFamilyID" returntype="numeric" output="false">
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductFamilyID"
			returnVariable="ReturnValue"
			ProductID="#this.GetProperty('ProductID')#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetConsoleProductFamilyID" returntype="numeric" output="false">
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductFamilyID"
			returnVariable="ProductFamilyID"
			ProductID="#this.GetProperty('ProductID')#">
		<cfset ReturnValue="-1">
		<cfquery name="GetConsoleProductFamilyID" datasource="#APPLICATION.DSN#">
			select SourceID from t_category Where CategoryID=#Val(ProductFamilyID)# and CategoryTypeID=62
		</cfquery>
		<cfif Val(GetConsoleProductFamilyID.SourceID) GT "0">
			<cfset ReturnValue=Val(GetConsoleProductFamilyID.SourceID)>
		</cfif>
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetlConsoleAlias" returntype="string" output="false">
		<cfset ThisProductID=this.GetProperty("ProductID")>
		<cfset ThisLanguageID=this.GetProperty("LanguageID")>
		<cfquery name="GetConsoles" datasource="#APPLICATION.DSN#">
			SELECT     t_Console.CategoryAlias AS ConsoleAlias
			FROM         t_Category t_Console INNER JOIN
                      t_ProductCombination ON t_Console.CategoryID = t_ProductCombination.ProductID2
			where ProductCombinationActive=1 and ProductID1=#Val(ThisProductID)# and (LanguageID=#Val(ThisLanguageID)# or LanguageID=100)
		</cfquery>
		<cfset ReturnList="">
		<cfoutput query="GetConsoles">
			<cfif ListFindNoCase(ReturnList,ConsoleAlias) is "0">
				<cfset ReturnList=ListAppend(ReturnList,ConsoleAlias)>
			</cfif>
		</cfoutput>
		<cfreturn ReturnList>
	</cffunction>
	
	
	<cffunction name="GetProductBrandID" returntype="numeric" output="false">
		<cfset ThisCategoryID=This.GetProductFamilyID()>
		<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
			select PropertiesPacket from qry_GetCategory Where CategoryID=#Val(ThisCategoryID)#
		</cfquery>
		<cfif IsWDDX(GetProperties.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ProductBrandLogoID")>
				<cfset ProductBrandLogoID=sProperties.ProductBrandLogoID>
				<cfreturn ProductBrandLogoID>
			</cfif>
		</cfif>
		<cfreturn -1>
	</cffunction>
	
	<cffunction name="GetProductProgramTypeAlias" returntype="string" output="false">
		<cfset ThisCategoryID=This.GetProductFamilyID()>
		<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
			select PropertiesPacket from qry_GetCategory Where CategoryID=#Val(ThisCategoryID)#
		</cfquery>
		<cfif IsWDDX(GetProperties.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ProductProgramTypeID")>
				<cfset ProductProgramTypeID=sProperties.ProductProgramTypeID>
				<cfquery name="GetProgramTypeAlias" datasource="#APPLICATION.DSN#">
					select CategoryAlias from t_Category Where CategoryID=#Val(ProductProgramTypeID)#
				</cfquery>
				<cfreturn Trim(GetProgramTypeAlias.CategoryAlias)>
			</cfif>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="GetProductConsoleTypeID" returntype="numeric" output="false">
		<cfset ThisCategoryID=This.GetProperty("ProductID")>
		<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
			select PropertiesPacket from qry_GetCategory Where CategoryID=#Val(ThisCategoryID)#
		</cfquery>
		<cfif IsWDDX(GetProperties.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ProductConsoleTypeID")>
				<cfset ProductConsoleTypeID=sProperties.ProductConsoleTypeID>
				<cfreturn ProductConsoleTypeID>
			</cfif>
		</cfif>
		<cfreturn -1>
	</cffunction>
	
	<cffunction name="GetProductColorID" returntype="numeric" output="false">
		<cfset ThisCategoryID=This.GetProperty("ProductID")>
		<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
			select PropertiesPacket from qry_GetCategory Where CategoryID=#Val(ThisCategoryID)#
		</cfquery>
		<cfif IsWDDX(GetProperties.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ColorID")>
				<cfset ColorID=sProperties.ColorID>
				<cfreturn ColorID>
			</cfif>
		</cfif>
		<cfreturn -1>
	</cffunction>
	
	<cffunction name="FormFileUpload" returntype="boolean" output="false">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">
		<cfargument name="FormFileFieldName" required="true">
		<cfif ARGUMENTS.FormFileFieldName IS "" OR ARGUMENTS.WebrootPath IS "" OR ARGUMENTS.Property IS "">
			<cfreturn false>
		<cfelseif ListFindNoCase(StructkeyList(this),ARGUMENTS.Property) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#this.GetProperty('ProductID')#" ReturnVarName="PathFragment">
			<cfif ListFindNoCase("BrochurePathFileObject,PublicDrawing",Property)>
				<cfset UploadDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('documents')#","/","\","All")>
			<cfelse>
				<cfset UploadDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
			</cfif>
			<cfset UploadDirectory=ReplaceNoCase(UploadDirectory,"\\","\","all")>
			<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
			<cffile action="UPLOAD" 
				filefield="#ARGUMENTS.FormFileFieldName#"
				destination="#UploadDirectory#"
				nameconflict="MakeUnique">
			<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
			<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
				<cffile action="DELETE" file="#UploadedFile#">
				<cfset SetProperty("#ARGUMENTS.Property#","")>
				<cfset AddError(ARGUMENTS.Property,"","The #sPropertyDisplayName[ARGUMENTS.Property]# must be an valid document.")>
				<cfreturn false>
			<cfelse>
				<cfset FilePath=ReplaceNoCase(UploadedFile,ARGUMENTS.WebrootPath,"/","All")>
				<cfset FilePath=ReplaceNoCase(FilePath,"\","/","All")>
				<cfset FilePath=ReplaceNoCase(FilePath,"//","/","All")>
				<cfset SetProperty("#ARGUMENTS.Property#","#FilePath#")>
				<cfreturn true>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="FileRemove" returnType="boolean" output="false">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">
		<cfif ARGUMENTS.WebrootPath IS "" OR ARGUMENTS.Property IS "">
			<cfreturn false>
		<cfelseif ListFindNoCase(StructkeyList(this),ARGUMENTS.Property) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfset FileToDelete=this.GetProperty("#ARGUMENTS.Property#")>
			<cfset this.SetProperty("#ARGUMENTS.Property#","")>
			<cfset FileToDelete=ReplaceNoCase("#ARGUMENTS.WebrootPath##FileToDelete#","/","\","All")>
			<cfset FileToDelete=ReplaceNoCase("#FileToDelete#","\\","\","All")>
			<cfif fileExists(FileToDelete)>
				<cftry>
					<cffile action="DELETE" file="#FileToDelete#">
					<cfcatch></cfcatch>
				</cftry>
			</cfif>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="Delete" returnType="boolean" output="false">
		<cfargument name="TrashPath" required="true">
		<cfif this.ValidateDelete() and ARGUMENTS.TrashPath IS NOT "">
			<cftransaction>
				<CF_getbranch item="#this.GetProperty('ProductID')#" DataSource="#APPLICATION.DSN#" table="t_Category" Column="ProductID" ParentColumn="DELETEME">
				<cfquery name="SelectCategory" datasource="#APPLICATION.DSN#">
					SELECT * FROM t_Category WHERE ProductID IN (#branch#)
				</cfquery>
				<cfinvoke component="/com/ContentManager/CategoryHandler" 
					method="GetProductionSiteInformation"
					returnVariable="sProductionSiteInformation"
					ProductID="#this.GetProperty('ProductID')#">
				<cfoutput query="SelectCategory">
					<cfquery name="SelectProps" datasource="#APPLICATION.DSN#">
						SELECT DELETEME FROM t_Category WHERE ProductID=#ProductID#
					</cfquery>
					<cfquery name="SelectProps2" datasource="#APPLICATION.DSN#">
						SELECT DELETEME FROM t_CategoryLocale WHERE ProductID=#ProductID#
					</cfquery>
					
					<cfquery name="deleteContent3" datasource="#APPLICATION.DSN#">
						DELETE FROM t_properties WHERE DELETEME=#SelectProps.DELETEME#
					</cfquery>
					<cfif SelectProps2.RecordCount GT "0">
						<cfquery name="deleteContent4" datasource="#APPLICATION.DSN#">
							DELETE FROM t_properties WHERE DELETEME IN (#ValueList(SelectProps2.DELETEME)#)
						</cfquery>
					</cfif>
					<cfquery name="DeleteContentCategory" datasource="#APPLICATION.DSN#">
						DELETE FROM t_CategoryLocale WHERE ProductID=#ProductID#
					</cfquery>
					<cfquery name="DeletePermissions" datasource="#APPLICATION.DSN#">
						DELETE FROM t_Permissions WHERE ProductID=#ProductID#
					</cfquery>
					<cfquery name="BrochurePathssages" datasource="#APPLICATION.DSN#">
						DELETE FROM t_Category WHERE ProductID=#ProductID#
					</cfquery>
					<cfset DirDone="">
					<cfloop index="i" from="1" to="#Len(ProductID)#" step="1">
						<cfset DirectoryToCreate="#ARGUMENTS.TrashPath##APPLICATION.CategoryResourcesPath##DirDone##Mid(ProductID,i,1)#">
						<cfset DirDone="#DirDone##Mid(ProductID,i,1)#\">
						<cftry>
							<cfdirectory action="CREATE" directory="#DirectoryToCreate#">
							<cfdirectory action="CREATE" directory="#DirectoryToCreate#/images/">
							<cfdirectory action="CREATE" directory="#DirectoryToCreate#/documents/">
							<cfcatch></cfcatch>
						</cftry>
					</cfloop>
					<cfset DestImages="#DirectoryToCreate#\images\">
					<cfset DestDocs="#DirectoryToCreate#\documents\">
					<cfset DirDone="">
					<cfloop index="i" from="1" to="#Len(ProductID)#" step="1">
						<cfset DirectoryToCreate="#APPLICATION.WebRootPath##APPLICATION.CategoryResourcesPath##DirDone##Mid(ProductID,i,1)#">
						<cfset DirDone="#DirDone##Mid(ProductID,i,1)#\">
					</cfloop>
					<cfset SourceImages="#DirectoryToCreate#\images\">
					<cfset SourceDocs="#DirectoryToCreate#\documents\">
					<CF_DIRECTORYTREE ACTION="copytree" SOURCE="#SourceImages#" DESTINATION="#DestImages#" NAMECONFLICT="overwrite">
					<CF_DIRECTORYTREE ACTION="copytree" SOURCE="#SourceDocs#" DESTINATION="#DestDocs#" NAMECONFLICT="overwrite">
					<cfif DirectoryExists("#SourceImages#")>
						<cf_deletedirectory directory="#SourceImages#">
						<cfdirectory action="CREATE" directory="#SourceImages#">
					</cfif>
					<cfif DirectoryExists("#SourceDocs#")>
						<cf_deletedirectory directory="#SourceDocs#">
						<cfdirectory action="CREATE" directory="#SourceDocs#">
					</cfif>
				</cfoutput>
			</cftransaction>
			
			<cfif IsStruct(sProductionSiteInformation)>
				<cftransaction>
					<cfquery name="SelectCategory" datasource="#sProductionSiteInformation.ProductionDSN#">
						SELECT * FROM t_Category WHERE ProductID IN (#branch#)
					</cfquery>
					<cfoutput query="SelectCategory">
						<cfquery name="SelectProps" datasource="#sProductionSiteInformation.ProductionDSN#">
							SELECT DELETEME FROM t_Category WHERE ProductID=#ProductID#
						</cfquery>
						<cfquery name="deleteContent3" datasource="#sProductionSiteInformation.ProductionDSN#">
							DELETE FROM t_properties WHERE DELETEME=#SelectProps.DELETEME#
						</cfquery>
						<cfquery name="DeleteContentCategory" datasource="#sProductionSiteInformation.ProductionDSN#">
							DELETE FROM t_ContentCategory WHERE ProductID=#ProductID#
						</cfquery>
						<cfquery name="BrochurePathssages" datasource="#sProductionSiteInformation.ProductionDSN#">
							DELETE FROM t_Category WHERE ProductID=#ProductID#
						</cfquery>
					</cfoutput>
				</cftransaction>
				<cfoutput query="SelectCategory">
					<cfmodule template="/common/modules/utils/ExplodeString.cfm" string="#ProductID#" Delimiter="/" ReturnVarName="ThisPath">
					<cfset RemoteDirectories=ArrayNew(1)>
					<cfset RemoteDirectories[1]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('images')#">
					<cfset RemoteDirectories[2]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('documents')#">
					<cfset RemoteDirectories[3]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('generated')#">
					<cfloop index="i" from="1" to="3" step="1">
						<cfset ThisDirectory=Replace(RemoteDirectories[i],"\","/","All")>
						<cfset ThisDirectory=Replace(ThisDirectory,"//","/","All")>
						<cfftp action="LISTDIR"
							server="#sProductionSiteInformation.ProductionFTPHost#"
							username="#sProductionSiteInformation.ProductionFTPUserLogin#"
							password="#sProductionSiteInformation.ProductionFTPPassword#" 
							stoponerror="No"
							name="List"
							directory="#ThisDirectory#"
							connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#">
						<cfloop query="List">
							<cfif NOT IsDirectory>
								<cfftp action="REMOVE" server="#sProductionSiteInformation.ProductionFTPHost#" username="#sProductionSiteInformation.ProductionFTPUserLogin#" password="#sProductionSiteInformation.ProductionFTPPassword#" 
									stoponerror="No" item="#Path#" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#">
							</cfif>
						</cfloop>
					</cfloop>
				</cfoutput>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveToProduction" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="UserID" required="true">

		<cfinvoke component="/com/ContentManager/CategoryHandler" 
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="#this.GetProperty('ProductID')#">
		
		<cfif isCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisCategoryID=this.GetProperty("ProductID")>
			<cfset ThisLanguageID=this.GetProperty("LanguageID")>
			
			<!--- Create the directories on the production server --->
			<!--- Open connection to the ftp server --->
			
			<cfif 0>
				<cfinvoke component="/com/ContentManager/CategoryHandler" method="CreateRemoteFolders" returnVariable="success"
					CategoryID="#ThisCategoryID#"
					FTPHost="#sProductionSiteInformation.ProductionFTPHost#"
					FTPRootPath="#sProductionSiteInformation.ProductionFTPRootPath#"
					FTPUserLogin="#sProductionSiteInformation.ProductionFTPUserLogin#"
					FTPPassword="#sProductionSiteInformation.ProductionFTPPassword#">
			</cfif>
			
			<cfquery name="SelectProductAttributes" datasource="#APPLICATION.DSN#">
				select * FROM t_ProductAttribute 
				WHERE CategoryID=#Val(ThisCategoryID)# and LanguageID=#ThisLanguageID#
			</cfquery>
			
			<cfquery name="DeleteProductAttributes" datasource="#sProductionSiteInformation.ProductionDBDSN#">
				delete from t_ProductAttribute 
				WHERE CategoryID=#Val(ThisCategoryID)# and LanguageID=#ThisLanguageID#
			</cfquery>
			
			<cfoutput query="SelectProductAttributes">
				<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					INSERT INTO t_ProductAttribute 
					(CategoryID,LanguageID,ProductFamilyAttributeID,AttributeValue,AttributeValueID)
					VALUES
					(#Val(CategoryID)#,#Val(LanguageID)#,#Val(ProductFamilyAttributeID)#,N'#AttributeValue#',#Val(AttributeValueID)#)
				</cfquery>
				<cfif left(AttributeValue,Len("/resources/category/")) IS "/resources/category/">
					<cfset Source=application.utilsObj.GetPathFromURL(AttributeValue)>
					<cfset Destination=ReplaceNoCase("#sProductionSiteInformation.ProductionFTPRootPath##AttributeValue#","//","/","All")>
					<cfftp action="PUTFILE" server="#sProductionSiteInformation.ProductionFTPHost#" 
						username="#sProductionSiteInformation.ProductionFTPUserLogin#"
						password="#sProductionSiteInformation.ProductionFTPPassword#" 
						stoponerror="No"
						localfile="#Source#"
						remotefile="#Destination#"
						transfermode="Auto" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#" timeout="60"
						Passive="No">
					<cfftp action="CLOSE" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#">
				</cfif>
			</cfoutput>
			
			
			<!--- TEXT BLOCKS --->
			
			<!--- Get Staging Data --->
			<cfquery name="GetPrevTextBlockStaging" datasource="#APPLICATION.DSN#">
				select * from t_TextBlock
				WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category'
				Order by TextBlockPriority
			</cfquery>
			<cfif GetPrevTextBlockStaging.RecordCount GT "0">
				<cfquery name="GetPrevTextBlockLanguageStaging" datasource="#APPLICATION.DSN#">
					select * from t_TextBlockLanguage
					WHERE TextBlockID IN (#ValueList(GetPrevTextBlockStaging.TextBlockID)#) and LanguageID=#Val(ThisLanguageID)#
					Order by TextBlockID
				</cfquery>
			</cfif>
			
			<cftransaction>
				<!--- Get Prod Data --->
				<cfquery name="GetPrevTextBlockProd" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					select * from t_TextBlock
					WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category'
					Order by TextBlockPriority
				</cfquery>
				
				<!--- Clear out Prod data --->
				<cfif GetPrevTextBlockProd.RecordCount GT "0">
					<cfquery name="DeleteTextBlock" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						delete from t_TextBlock
						WHERE TextBlockID IN (#ValueList(GetPrevTextBlockProd.TextBlockID)#)
					</cfquery>
					<cfquery name="DeleteTextBlock" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						delete from t_TextBlockLanguage
						WHERE TextBlockID IN (#ValueList(GetPrevTextBlockProd.TextBlockID)#) and LanguageID=#Val(ThisLanguageID)#
					</cfquery>
				</cfif>
				
				<!--- Insert staging data into prod --->
				<cfoutput query="GetPrevTextBlockStaging">
					<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SET IDENTITY_INSERT t_textBlock ON
						INSERT INTO t_TextBlock 
						(TextBlockID, Entity, KeyID, TextBlockPriority,TextBlockTypeID, SpecificationSetID)
						VALUES
						(#Val(TextBlockID)#,'#Entity#', #Val(KeyID)# , #Val(TextBlockPriority)#, #Val(TextBlockTypeID)#, #Val(SpecificationSetID)#)
						SET IDENTITY_INSERT t_textBlock OFF
					</cfquery>
				</cfoutput>
				<cfif GetPrevTextBlockStaging.RecordCount GT "0">
					<cfoutput query="GetPrevTextBlockLanguageStaging">
						<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							Insert into t_TextBlockLanguage 
							(TextBlock, TextBlockID, TextBlockName, LanguageID)
							VALUES
							(N'#TextBlock#', #Val(TextBlockID)#, N'#TextBlockName#', #Val(LanguageID)#)
						</cfquery>
					</cfoutput>
				</cfif>
			</cftransaction>
			
			<!--- RESOURCES --->
			
			<!--- Get Staging Data --->
			<cfquery name="GetPrevResourceStaging" datasource="#APPLICATION.DSN#">
				select * from t_Resource
				WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category'
				Order by ResourcePriority
			</cfquery>
			<cfif GetPrevResourceStaging.RecordCount GT "0">
				<cfquery name="GetPrevResourceLanguageStaging" datasource="#APPLICATION.DSN#">
					select * from t_ResourceLanguage
					WHERE ResourceID IN (#ValueList(GetPrevResourceStaging.ResourceID)#) and LanguageID=#Val(ThisLanguageID)#
					Order by ResourceID
				</cfquery>
			</cfif>
			
			<cftransaction>
				<!--- Get Prod Data --->
				<cfquery name="GetPrevResourceProd" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					select * from t_Resource
					WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category'
					Order by ResourcePriority
				</cfquery>
				
				<!--- Clear out Prod data --->
				<cfif GetPrevResourceProd.RecordCount GT "0">
					<cfquery name="DeleteResource" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						delete from t_Resource
						WHERE ResourceID IN (#ValueList(GetPrevResourceProd.ResourceID)#)
					</cfquery>
					<cfquery name="DeleteResource" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						delete from t_ResourceLanguage
						WHERE ResourceID IN (#ValueList(GetPrevResourceProd.ResourceID)#) and LanguageID=#Val(ThisLanguageID)#
					</cfquery>
				</cfif>
				
				<!--- Insert staging data into prod --->
				<cfoutput query="GetPrevResourceStaging">
					<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SET IDENTITY_INSERT t_Resource ON
						INSERT INTO t_Resource 
						(ResourceID, Entity, KeyID, ResourcePriority,SpecificationSetID, ResourceTypeID)
						VALUES
						(#Val(ResourceID)#,'#Entity#', #Val(KeyID)# , #Val(ResourcePriority)#,#Val(SpecificationSetID)#,#Val(ResourceTypeID)#)
						SET IDENTITY_INSERT t_Resource OFF
					</cfquery>
				</cfoutput>
				<cfif Isdefined("GetPrevResourceLanguageStaging")>
					<cfoutput query="GetPrevResourceLanguageStaging">
						<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							Insert into t_ResourceLanguage 
							(ResourceID, ResourceName, ResourceText, LanguageID, MainFilePath, ThumbnailFilePath, ResourceSize)
							VALUES
							(#Val(ResourceID)#, N'#ResourceName#', N'#ResourceText#', #Val(LanguageID)#, '#MainFilePath#', '#ThumbnailFilePath#', #Val(ResourceSize)#)
						</cfquery>
						<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
							<cfset ThisImageValue=Evaluate("#ThisImage#")>
							<cfif ThisImageValue IS NOT "" and left(ThisImageValue,Len("/resources/category/")) IS "/resources/category/">
								<cfset Source=application.utilsObj.GetPathFromURL(ThisImageValue)>
								<cfset Destination=ReplaceNoCase("#sProductionSiteInformation.ProductionFTPRootPath##ThisImageValue#","//","/","All")>
								<cfftp action="PUTFILE" server="#sProductionSiteInformation.ProductionFTPHost#" 
									username="#sProductionSiteInformation.ProductionFTPUserLogin#"
									password="#sProductionSiteInformation.ProductionFTPPassword#" 
									stoponerror="No"
									localfile="#Source#"
									remotefile="#Destination#"
									transfermode="Auto" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#" timeout="60"
									Passive="No">
								<cfftp action="CLOSE" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#">
							</cfif>
						</cfloop>
					</cfoutput>
				</cfif>
			</cftransaction>
			
			<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
				UserID="#ARGUMENTS.UserID#"
				Entity="Category"
				KeyID="#ThisCategoryID#"
				Operation="savelive">
				
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>