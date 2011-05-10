<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="CombinationID" type="numeric" default="">  
	<cfproperty name="ProductID1" type="numeric" default="">
	<cfproperty name="ProductID2" type="numeric" default="">
	<cfproperty name="LanguageID" type="numeric" default="">
	<cfproperty name="ProductCombinationActive" type="boolean" default="">
	<cfproperty name="ProductCombinationDescription" type="string" default="">
	<cfproperty name="ProductCombinationDetail" type="string" default="">
	<cfproperty name="ProductCombinationPrice" type="string" default="">
	<cfproperty name="ProductCombinationCallToActionURL" type="string" default="">
	<cfproperty name="aProductCombinationFeature" type="array" default="">
	<cfproperty name="aProductFamilyView" type="array" default="">
	<cfproperty name="ProductCombinationThumbnailPath" type="string" default="">
	<cfproperty name="ProductCombinationThumbnailHoverPath" type="string" default="">
	<cfproperty name="ProductCombinationImagePath" type="string" default="">
	<cfproperty name="ProductCombinationOverheadImagePath" type="string" default="">
	<cfproperty name="ProductCombinationFlashPath" type="string" default="">
	<cfproperty name="ProductCombinationFlashZoomPath" type="string" default="">
	
	<cfset structInsert(sPropertyDisplayName,"CombinationID","combination ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductID1","category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductID2","console ID",1)>
	<cfset structInsert(sPropertyDisplayName,"LanguageID","language ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationActive","ProductCombinationActive",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationDescription","description",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationDetail","detail",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationPrice","price",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationCallToActionURL","store URL",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductCombinationFeature","product feature array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductFamilyView","product combination view array",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationThumbnailPath","product thumbnail image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationThumbnailHoverPath","product thumbnail hover image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationImagePath","product image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationOverheadImagePath","product overhead view",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationFlashPath","product image",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductCombinationFlashZoomPath","product image",1)>
		
	<cffunction name="constructor" returntype="boolean" output="0">
		<cfargument name="ID" default="0" type="numeric" required="false">
		<cfargument name="LanguageID" default="0" type="numeric" required="false">
		<!--- Typically, use set methods in contructor. --->
		<cfset aBlank=ArrayNew(1)>
		<cfset this.SetProperty("CombinationID","-1")>
		<cfset this.SetProperty("ProductID1","-1")>
		<cfset this.SetProperty("ProductID2","-1")>
		<cfset this.SetProperty("LanguageID",ARGUMENTS.LanguageID)>
		<cfset this.SetProperty("ProductCombinationActive",0)>
		<cfset this.SetProperty("ProductCombinationDescription","")>
		<cfset this.SetProperty("ProductCombinationDetail","")>
		<cfset this.SetProperty("ProductCombinationPrice","")>
		<cfset this.SetProperty("ProductCombinationCallToActionURL","")>
		<cfset this.SetProperty("aProductCombinationFeature",aBlank)>
		<cfset this.SetProperty("aProductFamilyView",aBlank)>
		<cfset this.SetProperty("ProductCombinationThumbnailPath","")>
		<cfset this.SetProperty("ProductCombinationThumbnailHoverPath","")>
		<cfset this.SetProperty("ProductCombinationImagePath","")>
		<cfset this.SetProperty("ProductCombinationOverheadImagePath","")>
		<cfset this.SetProperty("ProductCombinationFlashPath","")>
		<cfset this.SetProperty("ProductCombinationFlashZoomPath","")>
		
		<cfif Val(ARGUMENTS.ID) GT 0 AND Val(ARGUMENTS.LanguageID) GT "0">
			<!--- If id is greater than 0, load from DB. --->
			<cfset this.SetProperty("CombinationID",ARGUMENTS.ID)>
			
			<cfquery name="GetItem" datasource="#APPLICATION.DSN#">
				SELECT * 
				FROM t_ProductCombination
				WHERE CombinationID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#">
			</cfquery>
			<cfset this.SetProperty("ProductID1",GetItem.ProductID1)>
			<cfset this.SetProperty("ProductID2",GetItem.ProductID2)>
			<cfset this.SetProperty("ProductCombinationActive",Val(GetItem.ProductCombinationActive))>
			<cfset this.SetProperty("ProductCombinationDescription",GetItem.ProductCombinationDescription)>
			<cfset this.SetProperty("ProductCombinationDetail",GetItem.ProductCombinationDetail)>
			<cfset this.SetProperty("ProductCombinationPrice",GetItem.ProductCombinationPrice)>
			<cfset this.SetProperty("ProductCombinationCallToActionURL",GetItem.ProductCombinationCallToActionURL)>
			<cfset this.SetProperty("ProductCombinationThumbnailPath",GetItem.ProductCombinationThumbnailPath)>
			<cfset this.SetProperty("ProductCombinationThumbnailHoverPath",GetItem.ProductCombinationThumbnailHoverPath)>
			<cfset this.SetProperty("ProductCombinationImagePath",GetItem.ProductCombinationImagePath)>
			<cfset this.SetProperty("ProductCombinationOverheadImagePath",GetItem.ProductCombinationOverheadImagePath)>
			<cfset this.SetProperty("ProductCombinationFlashPath",GetItem.ProductCombinationFlashPath)>
			<cfset this.SetProperty("ProductCombinationFlashZoomPath",GetItem.ProductCombinationFlashZoomPath)>
			
			<cfquery name="GetFeatures" datasource="#APPLICATION.DSN#">
				select * from qry_GetTextBlock
				WHERE 
				KeyID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ID)#"> and 
				Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Combination"> and 
				languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> AND 
				TextBlockTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="900">
				Order by TextBlockPriority
			</cfquery>
			
			<cfif GetFeatures.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetFeatures">
					<cfset sFeatureElt=StructNew()>
					<Cfset StructInsert(sFeatureElt,"TextBlockID",TextBlockID,1)>
					<Cfset StructInsert(sFeatureElt,"TextBlock",TextBlock,1)>
					<Cfset StructInsert(sFeatureElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sFeatureElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductCombinationFeature",aBlank)>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">
		<cfif isCorrect()>
			<cfset ThisCombinationID=this.GetProperty("CombinationID")>
			<cfset ThisProductID1=this.GetProperty("ProductID1")>
			<cfset ThisProductID2=this.GetProperty("ProductID2")>
			<cfset thisLanguageID=this.GetProperty("LanguageID")>
			<cfset thisProductCombinationActive=this.GetProperty("ProductCombinationActive")>
			<cfset thisProductCombinationDescription=this.GetProperty("ProductCombinationDescription")>
			<cfset thisProductCombinationDetail=this.GetProperty("ProductCombinationDetail")>
			<cfset thisProductCombinationPrice=this.GetProperty("ProductCombinationPrice")>
			<cfset thisProductCombinationCallToActionURL=this.GetProperty("ProductCombinationCallToActionURL")>
			<cfset thisaProductCombinationFeature=this.GetProperty("aProductCombinationFeature")>
			<cfset thisaProductFamilyView=this.GetProperty("aProductFamilyView")>
			<cfset thisProductCombinationThumbnailPath=this.GetProperty("ProductCombinationThumbnailPath")>
			<cfset thisProductCombinationThumbnailHoverPath=this.GetProperty("ProductCombinationThumbnailHoverPath")>
			<cfset thisProductCombinationImagePath=this.GetProperty("ProductCombinationImagePath")>
			<cfset thisProductCombinationOverheadImagePath=this.GetProperty("ProductCombinationOverheadImagePath")>
			<cfset thisProductCombinationFlashPath=this.GetProperty("ProductCombinationFlashPath")>
			<cfset thisProductCombinationFlashZoomPath=this.GetProperty("ProductCombinationFlashZoomPath")>
			
			<cftransaction>

				<cfif Val(ThisCombinationID) LTE "0">
					<cfquery name="InsertPC" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_ProductCombination
						(
						ProductID1,
						ProductID2,
						LanguageID,
						ProductCombinationActive,
						ProductCombinationDescription,
						ProductCombinationDetail,
						ProductCombinationPrice,
						ProductCombinationCallToActionURL,
						ProductCombinationThumbnailPath,
						ProductCombinationThumbnailHoverPath,
						ProductCombinationImagePath,
						ProductCombinationOverheadImagePath,
						ProductCombinationFlashPath,
						ProductCombinationFlashZoomPath
						)
						VALUES (
						#Val(ThisProductID1)#,
						#Val(ThisProductID2)#,
						#Val(ThisLanguageID)#,
						#Val(ThisProductCombinationActive)#,
						N'#Trim(ThisProductCombinationDescription)#',
						N'#Trim(ThisProductCombinationDetail)#',
						N'#Trim(ThisProductCombinationPrice)#',
						N'#Trim(ThisProductCombinationCallToActionURL)#',
						'#Trim(ThisProductCombinationThumbnailPath)#',
						'#Trim(ThisProductCombinationThumbnailHoverPath)#',
						'#Trim(ThisProductCombinationImagePath)#',
						'#Trim(ThisProductCombinationOverheadImagePath)#',
						'#Trim(ThisProductCombinationFlashPath)#',
						'#Trim(ThisProductCombinationFlashZoomPath)#'
						)
						SELECT NewID=@@Identity
					</cfquery>
					<cfset ThisCombinationID=InsertPC.NewID>
					<cfset this.SetProperty("CombinationID",InsertPC.NewID)>
				<cfelse>
					<cfquery name="UpdatePC" datasource="#APPLICATION.DSN#">
						update t_ProductCombination
						Set
						ProductID1=#Val(ThisProductID1)#,
						ProductID2=#Val(ThisProductID2)#,
						LanguageID=#Val(ThisLanguageID)#,
						ProductCombinationActive=#Val(ThisProductCombinationActive)#,
						ProductCombinationDescription=N'#Trim(ThisProductCombinationDescription)#',
						ProductCombinationDetail=N'#Trim(ThisProductCombinationDetail)#',
						ProductCombinationPrice=N'#Trim(ThisProductCombinationPrice)#',
						ProductCombinationCallToActionURL=N'#Trim(ThisProductCombinationCallToActionURL)#',
						ProductCombinationThumbnailPath='#Trim(ThisProductCombinationThumbnailPath)#',
						ProductCombinationThumbnailHoverPath='#Trim(ThisProductCombinationThumbnailHoverPath)#',
						ProductCombinationImagePath='#Trim(ThisProductCombinationImagePath)#',
						ProductCombinationOverheadImagePath='#Trim(ThisProductCombinationOverheadImagePath)#',
						ProductCombinationFlashPath='#Trim(ThisProductCombinationFlashPath)#',
						ProductCombinationFlashZoomPath='#Trim(ThisProductCombinationFlashZoomPath)#'
						WHERE CombinationID=#val(ThisCombinationID)#
					</cfquery>
				</cfif>
				<cfquery name="GetPrev" datasource="#APPLICATION.DSN#">
					select * from qry_GetTextBlock
					WHERE KeyID=#Val(ThisCombinationID)# and Entity='t_Combination' and languageID=#Val(ThisLanguageID)# AND TextBlockTypeID=900
					Order by TextBlockPriority
				</cfquery>
				<cfset OriginalList=ValueList(GetPrev.TextBlockID)>
				<cfset NewList="">
				<cfloop index="r" from="1" to="#ArrayLen(thisaProductCombinationFeature)#">
					<cfif thisaProductCombinationFeature[r].TextBlockID GT "0">
						<cfset NewList=ListAppend(NewList,thisaProductCombinationFeature[r].TextBlockID)>
					</cfif>
				</cfloop>
				
				<CF_Venn
					ListA="#OriginalList#"
					ListB="#NewList#"
					AnotB="ListToDelete">
					
				<cfloop index="r" from="1" to="#ArrayLen(thisaProductCombinationFeature)#">
					<cfset ThisPriority=r*10>
					<cfset ThisSpecificationSetID=thisaProductCombinationFeature[r].SpecificationSetID>
					<cfif thisaProductCombinationFeature[r].TextBlockID GT "0">
						<cfset ThisTextBlockID=thisaProductCombinationFeature[r].TextBlockID>
						<cfquery name="Test" datasource="#APPLICATION.DSN#">
							select * from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
						</cfquery>
						<cfif Test.RecordCount IS "0">
							<cfquery name="insert" datasource="#APPLICATION.DSN#">
								Insert into t_TextBlockLanguage 
								(TextBlock, TextBlockID, LanguageID)
								VALUES
								(N'#Trim(thisaProductCombinationFeature[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
							</cfquery>
						<cfelse>
							<cfquery name="update" datasource="#APPLICATION.DSN#">
								update t_TextBlockLanguage Set
								TextBlock=N'#Trim(thisaProductCombinationFeature[r].TextBlock)#'
								WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
							</cfquery>
						</cfif>
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_TextBlock Set
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
							('t_Combination', #Val(ThisCombinationID)# , #Val(ThisPriority)#, 900, #Val(ThisSpecificationSetID)#)
							SELECT NewID=@@Identity
						</cfquery>
						<cfset ThisTextBlockID=insert.NewID>
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							Insert into t_TextBlockLanguage 
							(TextBlock, TextBlockID, LanguageID)
							VALUES
							(N'#Trim(thisaProductCombinationFeature[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
						</cfquery>
					</cfif>
				</cfloop>
				
				<cfloop index="ThisID" list="#ListToDelete#">
					<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
						DELETE from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisID)# and LanguageID=#Val(thisLanguageID)#
					</cfquery>
					<!---
						<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
							UPDATE t_TextBlockLanguage set Languageid=#-Val(ThisLanguageID)# 
							WHERE TextBlockID=#Val(ThisID)# AND LanguageID = #Val(ThisLanguageID)# 
						</cfquery>
						<!--- delete only if last remaining --->
						<cfquery name="DeleteThis" datasource="#APPLICATION.DSN#">
							DELETE from t_TextBlock WHERE TextBlockID=#Val(ThisID)#
						</cfquery>
					--->
				</cfloop>
				
			</cftransaction>
			
			<cfinvoke component="/com/ContentManager/CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Category"
				KeyID="#ThisProductID1#">
			<cfinvoke component="/com/ContentManager/CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Category"
				KeyID="#ThisProductID2#">	
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

			<cfif ListFindNoCase("CombinationID,ProductID1,ProductID2",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsNumeric(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid number.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>

			<cfif ListFindNoCase("ProductID1,ProductID2",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
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
	
	<cffunction name="GetProductName1" returntype="string" output="false">
		<cfset ReturnValue="">
		<cfquery name="Get" datasource="#APPLICATION.DSN#">
			select CategoryName from t_Category 
			Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#this.ProductID1#">
		</cfquery>
		<cfset ReturnValue="#Get.CategoryName#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetProductName2" returntype="string" output="false">
		<cfset ReturnValue="">
		<cfquery name="Get" datasource="#APPLICATION.DSN#">
			select CategoryName from t_Category 
			Where CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#this.ProductID2#">
		</cfquery>
		<cfset ReturnValue="#Get.CategoryName#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('ProductID1')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('ProductID1')#"
			ResourceType="#ARGUMENTS.ResourceType#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('ProductID1')#"
			ResourceType="#ARGUMENTS.ResourceType#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
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
			<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#this.GetProperty('ProductID1')#" ReturnVarName="PathFragment">
			<cfif ListFindNoCase("ProductFamilyBrochurePathFileObject",FormFileFieldName)>
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
			<cfset UploadedFile=application.utilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)>
			<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
				<cffile action="DELETE" file="#UploadedFile#">
				<cfset SetProperty("#ARGUMENTS.Property#","")>
				<cfset AddError(ARGUMENTS.Property,"","The #sPropertyDisplayName[ARGUMENTS.Property]# must be an approved file type.")>
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
				<cffile action="DELETE" file="#FileToDelete#">
			</cfif>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="Delete" returnType="boolean" output="false">
		<cfargument name="TrashPath" required="true">
	</cffunction>
	
	<cffunction name="SaveToProduction" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="UserID" required="true">

		<cfinvoke component="/com/ContentManager/CategoryHandler" 
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="2213"><!--- CategoryID of Top Level Product Page--->
		
		<cfif isCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisCombinationID=this.GetProperty("CombinationID")>
			<cfset ThisLanguageID=this.GetProperty("LanguageID")>
			
			<cftransaction>
				<cfquery name="DeletePC" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					delete from t_ProductCombination
					WHERE CombinationID=#Val(ThisCombinationID)#
				</cfquery>
				
				<cfset ThisProductID1=this.GetProperty("ProductID1")>
				<cfset ThisProductID2=this.GetProperty("ProductID2")>
				<cfset thisLanguageID=this.GetProperty("LanguageID")>
				<cfset thisProductCombinationActive=this.GetProperty("ProductCombinationActive")>
				<cfset thisProductCombinationDescription=this.GetProperty("ProductCombinationDescription")>
				<cfset thisProductCombinationDetail=this.GetProperty("ProductCombinationDetail")>
				<cfset thisProductCombinationPrice=this.GetProperty("ProductCombinationPrice")>
				<cfset thisProductCombinationCallToActionURL=this.GetProperty("ProductCombinationCallToActionURL")>
				<cfset thisProductCombinationThumbnailPath=this.GetProperty("ProductCombinationThumbnailPath")>
				<cfset thisProductCombinationThumbnailHoverPath=this.GetProperty("ProductCombinationThumbnailHoverPath")>
				<cfset thisProductCombinationImagePath=this.GetProperty("ProductCombinationImagePath")>
				<cfset thisProductCombinationOverheadImagePath=this.GetProperty("ProductCombinationOverheadImagePath")>
				<cfset thisProductCombinationFlashPath=this.GetProperty("ProductCombinationFlashPath")>
				<cfset thisProductCombinationFlashZoomPath=this.GetProperty("ProductCombinationFlashZoomPath")>
				
				<cfquery name="DeletePC" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					delete from t_ProductCombination
					WHERE 
					ProductID1=#Val(ThisProductID1)# and
					ProductID2=#Val(ThisProductID2)# and
					LanguageID=#Val(ThisLanguageID)#
				</cfquery>
				
				<cfquery name="InsertPC" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					SET IDENTITY_INSERT t_ProductCombination ON
					INSERT INTO t_ProductCombination
					(
					CombinationID,
					ProductID1,
					ProductID2,
					LanguageID,
					ProductCombinationActive,
					ProductCombinationDescription,
					ProductCombinationDetail,
					ProductCombinationPrice,
					ProductCombinationCallToActionURL,
					ProductCombinationThumbnailPath,
					ProductCombinationThumbnailHoverPath,
					ProductCombinationImagePath,
					ProductCombinationOverheadImagePath,
					ProductCombinationFlashPath,
					ProductCombinationFlashZoomPath
					)
					VALUES (
					#Val(ThisCombinationID)#,
					#Val(ThisProductID1)#,
					#Val(ThisProductID2)#,
					#Val(ThisLanguageID)#,
					#Val(ThisProductCombinationActive)#,
					N'#Trim(ThisProductCombinationDescription)#',
					N'#Trim(ThisProductCombinationDetail)#',
					N'#Trim(ThisProductCombinationPrice)#',
					N'#Trim(ThisProductCombinationCallToActionURL)#',
					'#Trim(ThisProductCombinationThumbnailPath)#',
					'#Trim(ThisProductCombinationThumbnailHoverPath)#',
					'#Trim(ThisProductCombinationImagePath)#',
					'#Trim(ThisProductCombinationOverheadImagePath)#',
					'#Trim(ThisProductCombinationFlashPath)#',
					'#Trim(ThisProductCombinationFlashZoomPath)#'
					)
					SET IDENTITY_INSERT t_ProductCombination OFF
				</cfquery>
			</cftransaction>
			
			<!--- TEXT BLOCKS --->
			
			<!--- Get Staging Data --->
			<cfquery name="GetPrevTextBlockStaging" datasource="#APPLICATION.DSN#">
				select * from t_TextBlock
				WHERE KeyID=#Val(ThisCombinationID)# and Entity='t_Combination' AND TextBlockTypeID=900
				Order by TextBlockPriority
			</cfquery>
			<cfquery name="GetPrevTextBlockLanguageStaging" datasource="#APPLICATION.DSN#">
				select * from t_TextBlockLanguage
				WHERE TextBlockID IN (<cfif GetPrevTextBlockStaging.RecordCount GT "0">#ValueList(GetPrevTextBlockStaging.TextBlockID)#<cfelse>-1</cfif>) and LanguageID=#Val(ThisLanguageID)#
				Order by TextBlockID
			</cfquery>
			
			<cftransaction>
				<!--- Get Prod Data --->
				<cfquery name="GetPrevTextBlockProd" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					select * from t_TextBlock
					WHERE KeyID=#Val(ThisCombinationID)# and Entity='t_Combination' AND TextBlockTypeID=900
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
						(TextBlockID, Entity, KeyID, TextBlockPriority,TextBlockTypeID)
						VALUES
						(#Val(TextBlockID)#,'#Entity#', #Val(KeyID)# , #Val(TextBlockPriority)#, 900)
						SET IDENTITY_INSERT t_textBlock OFF
					</cfquery>
				</cfoutput>
				<cfoutput query="GetPrevTextBlockLanguageStaging">
					<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						Insert into t_TextBlockLanguage 
						(TextBlock, TextBlockID, TextBlockName, LanguageID)
						VALUES
						(N'#TextBlock#', #Val(TextBlockID)#, N'#TextBlockName#', #Val(LanguageID)#)
					</cfquery>
				</cfoutput>
			</cftransaction>

			<!--- Images --->			
			<cfquery name="GetItem" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_ProductCombination
				WHERE CombinationID=#Val(ThisCombinationID)#
			</cfquery>
			
			<cfoutput query="GetItem">
				<cfloop index="ThisImage" list="ProductCombinationThumbnailPath,ProductCombinationThumbnailHoverPath,ProductCombinationImagePath,ProductCombinationOverheadImagePath,ProductCombinationFlashPath,ProductCombinationFlashZoomPath">
					<cfset ThisImageValue=Evaluate("#ThisImage#")>
					<cfif ThisImageValue IS NOT "">
						<cfset Source=REQUEST.GetPathFromURL(ThisImageValue)>
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
			
			<!--- Create the directories on the production server --->
			<!--- Open connection to the ftp server --->
			
			<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
				UserID="#ARGUMENTS.UserID#"
				Entity="Combination"
				KeyID="#ThisCombinationID#"
				Operation="savelive">
				
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>