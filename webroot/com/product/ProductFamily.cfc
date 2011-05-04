<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="CategoryID" type="numeric" default="">
	<cfproperty name="LanguageID" type="numeric" default="">
	<cfproperty name="ProductFamilyDescription" type="string" default="">
	<cfproperty name="aProductFamilyAttribute" type="array" default="">
	<cfproperty name="aProductFamilyFeature" type="array" default="">
	<cfproperty name="aProductFamilyView" type="array" default="">
	<cfproperty name="aProductFamilyDownload" type="array" default="">
	
	<cfset structInsert(sPropertyDisplayName,"CategoryID","category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"LanguageID","language ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductFamilyDescription","description",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductViewLabel","product view label",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductFamilyBenchMarkDate","product family benchmark date",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductFamilyBrochurePath","product fmaily brochure path",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductFamilyAttribute","array of product family attributes",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductFamilyFeature","product feature array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductFamilyView","product view array",1)>
	<cfset structInsert(sPropertyDisplayName,"aProductFamilyDownload","product download array",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductFamilyBrochurePathOverride","product family brochure path overrides",1)>
	
	<!--- If these change, make sure to change in handler too. --->
	<cfset this.sAttributeID=StructNew()>
	<cfset StructInsert(this.sAttributeID,"ProductFamilyDescription","18",1)>
	<cfset StructInsert(this.sAttributeID,"ProductViewLabel","19",1)>
	<cfset StructInsert(this.sAttributeID,"ProductFamilyBrochurePath","20",1)>
	<cfset StructInsert(this.sAttributeID,"ProductFamilyBenchMarkDate","21",1)>
	<cfset StructInsert(this.sAttributeID,"ProductFamilyBrochurePathOverride","22",1)>
	
	<cfset this.lAttributeID="18,19,20,21,22">
	<cfset this.sAttribute=StructNew()>
	<cfloop index="ThisKey" list="#StructKeyList(this.sAttributeID)#">
		<cfset StructInsert(this.sAttribute,this.sAttributeID[thisKey],ThisKey,1)>
	</cfloop>
	
	<cffunction name="constructor" returntype="boolean" output="0">
		<cfargument name="ID" default="0" type="numeric" required="false">
		<cfargument name="LanguageID" default="0" type="numeric" required="false">
		<!--- Typically, use set methods in contructor. --->
		<cfset aBlank=ArrayNew(1)>
		<cfset this.SetProperty("CategoryID","-1")>
		<cfset this.SetProperty("LanguageID",ARGUMENTS.LanguageID)>
		<cfset this.SetProperty("ProductFamilyDescription","")>
		<cfset this.SetProperty("ProductViewLabel","")>
		<cfset this.SetProperty("ProductFamilyBenchMarkDate","")>
		<cfset this.SetProperty("ProductFamilyBrochurePath","")>
		<cfset this.SetProperty("ProductFamilyBrochurePathOverride","0")>
		<cfset this.SetProperty("aProductFamilyAttribute",aBlank)>
		<cfset this.SetProperty("aProductFamilyFeature",aBlank)>
		<cfset this.SetProperty("aProductFamilyView",aBlank)>
		<cfset this.SetProperty("aProductFamilyDownload",aBlank)>
		
		<cfif Val(ARGUMENTS.ID) GT 0 AND Val(ARGUMENTS.LanguageID) GT "0">
			<!--- If id is greater than 0, load from DB. --->
			<cfset this.SetProperty("CategoryID",ARGUMENTS.ID)>
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_ProductAttribute
				WHERE ProductFamilyAttributeID IN (#this.lAttributeID#) AND CategoryID=#Val(ARGUMENTS.ID)# and languageID=#Val(ARGUMENTS.LanguageID)#
			</cfquery>

			<cfoutput query="GetItems">
				<cfif ProductFamilyAttributeID IS "1441">
					<Cfset this.SetProperty(this.sAttribute[ProductFamilyAttributeID],Val(AttributeValue))>
				<cfelse>
					<Cfset this.SetProperty(this.sAttribute[ProductFamilyAttributeID],AttributeValue)>
				</cfif>
			</cfoutput>
			
			<cfquery name="GetFeatures" datasource="#APPLICATION.DSN#">
				select * from qry_GetTextBlock
				WHERE KeyID=#Val(ARGUMENTS.ID)# and Entity='t_Category' and languageID=#Val(ARGUMENTS.LanguageID)# AND TextBlockTypeID=900
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
				<cfset this.SetProperty("aProductFamilyFeature",aBlank)>
			</cfif>
			
			<cfquery name="GetView" datasource="#APPLICATION.DSN#">
				select * from qry_GetResource
				WHERE KeyID=#Val(ARGUMENTS.ID)# and 
				Entity='t_Category' and 
				languageID=#Val(ARGUMENTS.LanguageID)# and
				ResourceTypeID=9000
				Order by ResourcePriority
			</cfquery>
			<cfif GetView.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetView">
					<cfset sViewElt=StructNew()>
					<Cfset StructInsert(sViewElt,"ResourceID",ResourceID,1)>
					<Cfset StructInsert(sViewElt,"ResourceName",ResourceName,1)>
					<Cfset StructInsert(sViewElt,"ResourceText",ResourceText,1)>
					<Cfset StructInsert(sViewElt,"MainFilePath",MainFilePath,1)>
					<Cfset StructInsert(sViewElt,"ThumbnailFilePath",ThumbnailFilePath,1)>
					<Cfset StructInsert(sViewElt,"MainFileSize",ResourceSize,1)>
					<Cfset StructInsert(sViewElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sViewElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductFamilyView",aBlank)>
			</cfif>
			
			<cfquery name="GetDownload" datasource="#APPLICATION.DSN#">
				select * from qry_GetResource
				WHERE KeyID=#Val(ARGUMENTS.ID)# and 
				Entity='t_Category' and 
				languageID=#Val(ARGUMENTS.LanguageID)# and
				ResourceTypeID=9001
				Order by ResourcePriority
			</cfquery>
			<cfif GetDownload.RecordCount GT "0">
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetDownload">
					<cfset sViewElt=StructNew()>
					<Cfset StructInsert(sViewElt,"ResourceID",ResourceID,1)>
					<Cfset StructInsert(sViewElt,"ResourceName",ResourceName,1)>
					<Cfset StructInsert(sViewElt,"ResourceText",ResourceText,1)>
					<Cfset StructInsert(sViewElt,"MainFilePath",MainFilePath,1)>
					<Cfset StructInsert(sViewElt,"ThumbnailFilePath",ThumbnailFilePath,1)>
					<Cfset StructInsert(sViewElt,"MainFileSize",ResourceSize,1)>
					<Cfset StructInsert(sViewElt,"SpecificationSetID",SpecificationSetID,1)>
					<cfset arrayAppend(aBlank,sViewElt)>
				</cfoutput>
				<cfset this.SetProperty("aProductFamilyDownload",aBlank)>
			</cfif>
			
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT * FROM qry_GetProductFamilyAttribute
				WHERE CategoryID=#Val(ARGUMENTS.ID)# and languageID IN (#Val(ARGUMENTS.LanguageID)#,#APPLICATION.DefaultLanguageID#)
				order by ProductFamilyAttributePriority, LanguageID desc
			</cfquery>
			<cfif GetItems.recordcount GT 0>
				<cfset aBlank=ArrayNew(1)>
				<cfoutput query="GetItems" group="CategoryID">
					<cfset this.SetProperty("CategoryID",CategoryID)>
					<cfoutput group="ProductFamilyAttributeID">
						<cfset DefaultName="[none]">
						<cfoutput group="LanguageID">
							<cfif GetItems.LanguageID IS APPLICATION.DefaultLanguageID>
								<cfset DefaultName="#ProductFamilyAttributeName#">
							</cfif>
						</cfoutput>
						<cfset sAttrElement=StructNew()>
						<cfset StructInsert(sAttrElement,"ProductFamilyAttributeID",ProductFamilyAttributeID,1)>
						<cfset StructInsert(sAttrElement,"ProductFamilyAttributeTypeID",ProductFamilyAttributeTypeID,1)>
						<cfset StructInsert(sAttrElement,"ProductFamilyAttributePriority",ProductFamilyAttributePriority,1)>
						<cfif GetItems.LanguageID IS APPLICATION.DefaultLanguageID and Left(ProductFamilyAttributeName,1) IS "_">
							<cfset StructInsert(sAttrElement,"ProductFamilyAttributeName","",1)>
						<cfelse>
							<cfset StructInsert(sAttrElement,"ProductFamilyAttributeName",ProductFamilyAttributeName,1)>
						</cfif>
						<cfset StructInsert(sAttrElement,"ProductFamilyAttributeNameDefault",DefaultName,1)>
						<cfset StructInsert(sAttrElement,"SpecificationSetID",SpecificationSetID,1)>
						<cfset ArrayAppend(aBlank,sAttrElement)>
					</cfoutput>
				</cfoutput>
				<cfset this.SetProperty("aProductFamilyAttribute",aBlank)>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
				<!--- If id is not present, return false. --->
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">
		<cfif isCorrect()>
			<cfset ThisCategoryID=this.GetProperty("CategoryID")>
			<cfset thisLanguageID=this.GetProperty("LanguageID")>
			<cfset thisProductFamilyDescription=this.GetProperty("ProductFamilyDescription")>
			<cfset thisProductViewLabel=this.GetProperty("ProductViewLabel")>
			<cfset thisProductFamilyBenchMarkDate=this.GetProperty("ProductFamilyBenchMarkDate")>
			<cfset thisProductFamilyBrochurePath=this.GetProperty("ProductFamilyBrochurePath")>
			<cfset thisProductFamilyBrochurePathOverride=this.GetProperty("ProductFamilyBrochurePathOverride")>
			<cfset ThisAAttr=this.GetProperty("aProductFamilyAttribute")>
			<cfset thisaProductFamilyFeature=this.GetProperty("aProductFamilyFeature")>
			<cfset thisaProductFamilyView=this.GetProperty("aProductFamilyView")>
			<cfset thisaProductFamilyDownload=this.GetProperty("aProductFamilyDownload")>
			
			<cftransaction>
				<cfloop index="ThisID" list="#this.lAttributeID#">
					<cfset ThisValue=this.GetProperty(this.sAttribute[ThisID])>
					<cfquery name="test" datasource="#APPLICATION.DSN#">
						select * from t_ProductAttribute 
						WHERE CategoryID=#Val(ThisCategoryID)# AND LanguageID=#Val(ThisLanguageID)# AND ProductFamilyAttributeID=#Val(ThisID)#
					</cfquery>
					<cfif test.RecordCount GT "0">
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_ProductAttribute Set
							AttributeValue=N'#Trim(ThisValue)#'
							WHERE CategoryID=#Val(ThisCategoryID)# AND LanguageID=#Val(ThisLanguageID)# AND ProductFamilyAttributeID=#Val(ThisID)#
						</cfquery>
					<cfelse>
						<cfquery name="isnert" datasource="#APPLICATION.DSN#">
							INSERT INTO t_ProductAttribute 
							(CategoryID, LanguageID, ProductFamilyAttributeID, AttributeValue)
							VALUES
							(#Val(ThisCategoryID)#, #Val(ThisLanguageID)#, #Val(ThisID)#, N'#Trim(ThisValue)#')
						</cfquery>
					</cfiF>
				</cfloop>
				
				<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qLanguages">
					<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
					<cfinvokeargument name="TableName" value="t_Label">
					<cfinvokeargument name="FieldName" value="labelGroupID">
					<cfinvokeargument name="FieldValue" value="60">
					<cfinvokeargument name="SortFieldName" value="LabelName">
					<cfinvokeargument name="SortOrder" value="Asc">
				</cfinvoke>
				
				<cfquery name="GetPrevAttrs" datasource="#APPLICATION.DSN#">
					select ProductFamilyAttributeID from t_ProductFamilyAttribute
					WHERE CategoryID=#Val(ThisCategoryID)#
				</cfquery>
				<cfset OriginalList=ValueList(GetPrevAttrs.ProductFamilyAttributeID)>
				<cfset NewList="">
				<cfloop index="r" from="1" to="#ArrayLen(ThisAAttr)#">
					<cfif ThisAAttr[r].ProductFamilyAttributeID GT "0">
						<cfset NewList=ListAppend(NewList,ThisAAttr[r].ProductFamilyAttributeID)>
					</cfif>
				</cfloop>
				
				<CF_Venn
					ListA="#OriginalList#"
					ListB="#NewList#"
					AnotB="ListToDelete">
					
				<cfloop index="r" from="1" to="#ArrayLen(ThisAAttr)#">
					<cfset ThisPriority=ThisAAttr[r].ProductFamilyAttributePriority>
					<cfset ThisSpecificationSetID=ThisAAttr[r].SpecificationSetID>
					<cfif ThisAAttr[r].ProductFamilyAttributeID GT "0">
						<cfset ThisAttributeID=ThisAAttr[r].ProductFamilyAttributeID>
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_ProductFamilyAttribute Set
							ProductFamilyAttributeTypeID=#Val(ThisAAttr[r].ProductFamilyAttributeTypeID)#,
							ProductFamilyAttributePriority=#Val(ThisPriority)#,
							SpecificationSetID=#Val(ThisSpecificationSetID)#
							WHERE ProductFamilyAttributeID=#Val(ThisAttributeID)#
						</cfquery>
					<Cfelse>
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							SET NOCOUNT ON
							INSERT INTO t_ProductFamilyAttribute 
							(CategoryID, ProductFamilyAttributeTypeID, ProductFamilyAttributePriority, SpecificationSetID)
							VALUES
							(#Val(ThisCategoryID)#, #Val(ThisAAttr[r].ProductFamilyAttributeTypeID)#, #Val(ThisPriority)#, #Val(ThisSpecificationSetID)#)
							SELECT NewID=@@Identity
						</cfquery>
						<cfset ThisAttributeID=insert.NewID>
					</cfif>
					
					<cfquery name="TestExists" datasource="#APPLICATION.DSN#">
						select * FROM t_ProductFamilyAttributeLanguage 
						where LanguageID=#Val(thisLanguageID)# And ProductFamilyAttributeID=#Val(ThisAttributeID)#
					</cfquery>
					<cfif TestExists.RecordCount GT "0">
						<cfif Trim(ThisAAttr[r].ProductFamilyAttributeName) IS "">
							<cfquery name="DeleteOthers1" datasource="#APPLICATION.DSN#">
								DELETE from t_ProductAttribute WHERE ProductFamilyAttributeID=#Val(ThisAttributeID)# and LanguageID=#Val(thisLanguageID)#
							</cfquery>
							<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
								DELETE from t_ProductFamilyAttributeLanguage 
								WHERE ProductFamilyAttributeID=#Val(ThisAttributeID)# and LanguageID=#Val(thisLanguageID)#
							</cfquery>
						<cfelse>
							<cfquery name="update" datasource="#APPLICATION.DSN#">
								update t_ProductFamilyAttributeLanguage Set
								ProductFamilyAttributeName=N'#Trim(ThisAAttr[r].ProductFamilyAttributeName)#'
								where LanguageID=#Val(thisLanguageID)# And ProductFamilyAttributeID=#Val(ThisAttributeID)#
							</cfquery>
						</cfif>
					<cfelse>
						<cfif Trim(ThisAAttr[r].ProductFamilyAttributeName) IS NOT "">
							<cfquery name="insert" datasource="#APPLICATION.DSN#">
								SET NOCOUNT ON
								INSERT INTO t_ProductFamilyAttributeLanguage 
								(ProductFamilyAttributeID, LanguageID, ProductFamilyAttributeName)
								VALUES
								(#Val(ThisAttributeID)#, #Val(thisLanguageID)#, N'#Trim(ThisAAttr[r].ProductFamilyAttributeName)#')
								SELECT NewID=@@Identity
							</cfquery>
						</cfif>
					</cfif>
				</cfloop>
				
				<cfloop index="ThisID" list="#ListToDelete#">
					<cfquery name="DeleteOthers1" datasource="#APPLICATION.DSN#">
						DELETE from t_ProductAttribute WHERE ProductFamilyAttributeID=#Val(ThisID)# and LanguageID=#Val(thisLanguageID)#
					</cfquery>
					<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
						DELETE from t_ProductFamilyAttributeLanguage WHERE ProductFamilyAttributeID=#Val(ThisID)#  and LanguageID=#Val(thisLanguageID)#
					</cfquery>
					<cfif 1><!--- delete all, only admins should have ability to delete --->
						<cfquery name="DeleteThis" datasource="#APPLICATION.DSN#">
							DELETE from t_ProductFamilyAttribute WHERE ProductFamilyAttributeID=#Val(ThisID)#
						</cfquery>
					</cfif>
				</cfloop>
				
				<cfquery name="GetPrev" datasource="#APPLICATION.DSN#">
					select * from qry_GetTextBlock
					WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category' and languageID=#Val(ThisLanguageID)# AND TextBlockTypeID=900
					Order by TextBlockPriority
				</cfquery>
				<cfset OriginalList=ValueList(GetPrev.TextBlockID)>
				<cfset NewList="">
				<cfloop index="r" from="1" to="#ArrayLen(thisaProductFamilyFeature)#">
					<cfif thisaProductFamilyFeature[r].TextBlockID GT "0">
						<cfset NewList=ListAppend(NewList,thisaProductFamilyFeature[r].TextBlockID)>
					</cfif>
				</cfloop>
				
				<CF_Venn
					ListA="#OriginalList#"
					ListB="#NewList#"
					AnotB="ListToDelete">
					
				<cfloop index="r" from="1" to="#ArrayLen(thisaProductFamilyFeature)#">
					<cfset ThisPriority=r*10>
					<cfset ThisSpecificationSetID=thisaProductFamilyFeature[r].SpecificationSetID>
					<cfif thisaProductFamilyFeature[r].TextBlockID GT "0">
						<cfset ThisTextBlockID=thisaProductFamilyFeature[r].TextBlockID>
						<cfquery name="Test" datasource="#APPLICATION.DSN#">
							select * from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
						</cfquery>
						<cfif Test.RecordCount IS "0">
							<cfquery name="insert" datasource="#APPLICATION.DSN#">
								Insert into t_TextBlockLanguage 
								(TextBlock, TextBlockID, LanguageID)
								VALUES
								(N'#Trim(thisaProductFamilyFeature[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
							</cfquery>
						<cfelse>
							<cfquery name="update" datasource="#APPLICATION.DSN#">
								update t_TextBlockLanguage Set
								TextBlock=N'#Trim(thisaProductFamilyFeature[r].TextBlock)#'
								WHERE TextBlockID=#Val(ThisTextBlockID)# and LanguageID=#Val(ThisLanguageID)#
							</cfquery>
						</cfif>
						<cfquery name="update" datasource="#APPLICATION.DSN#">
							update t_TextBlock Set
							SpecificationSetID=#Val(ThisSpecificationSetID)#
							WHERE TextBlockID=#Val(ThisTextBlockID)#
						</cfquery>
					<Cfelse>
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							SET NOCOUNT ON
							INSERT INTO t_TextBlock 
							(Entity, KeyID, TextBlockPriority,TextBlockTypeID, SpecificationSetID)
							VALUES
							('t_Category', #Val(thisCategoryID)# , #Val(ThisPriority)#, 900, #Val(ThisSpecificationSetID)#)
							SELECT NewID=@@Identity
						</cfquery>
						<cfset ThisTextBlockID=insert.NewID>
						<cfquery name="insert" datasource="#APPLICATION.DSN#">
							Insert into t_TextBlockLanguage 
							(TextBlock, TextBlockID, LanguageID)
							VALUES
							(N'#Trim(thisaProductFamilyFeature[r].TextBlock)#', #Val(ThisTextBlockID)#, #Val(ThisLanguageID)#)
						</cfquery>
					</cfif>
				</cfloop>
	
				<cfloop index="ThisID" list="#ListToDelete#">
					<cfquery name="DeleteOthers2" datasource="#APPLICATION.DSN#">
						DELETE from t_TextBlockLanguage WHERE TextBlockID=#Val(ThisID)# and LanguageID=#Val(thisLanguageID)#
					</cfquery>
				</cfloop>
				
				<cfinvoke component="/com/product/ResourceHandler" method="SaveResource" returnVariable="bSuccess">
					<cfinvokeargument name="aResource" value="#thisaProductFamilyView#">
					<cfinvokeargument name="CategoryID" value="#ThisCategoryID#">
					<cfinvokeargument name="LanguageID" value="#ThisLanguageID#">
					<cfinvokeargument name="ResourceTypeID" value="9000">
				</cfinvoke>
				
				<cfinvoke component="/com/product/ResourceHandler" method="SaveResource" returnVariable="bSuccess">
					<cfinvokeargument name="aResource" value="#thisaProductFamilyDownload#">
					<cfinvokeargument name="CategoryID" value="#ThisCategoryID#">
					<cfinvokeargument name="LanguageID" value="#ThisLanguageID#">
					<cfinvokeargument name="ResourceTypeID" value="9001">
				</cfinvoke>
				
			</cftransaction>
			
			<cfinvoke component="/com/ContentManager/CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Category"
				KeyID="#ThisCategoryID#">
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

			<cfif ListFindNoCase("CategoryID",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsNumeric(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid number.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("ProductFamilyBenchMarkDate",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>

			<cfif ListFindNoCase("CategoryID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
						
			<cfif ListFindNoCase("CategoryID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="CategoryID">
							<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Category">
								<cfinvokeargument name="FieldName" value="CategoryID">
								<cfinvokeargument name="FieldValue" value="#Val(ARGUMENTS.Value)#">
								<cfinvokeargument name="SortFieldName" value="CategoryAlias">
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
	
	<cffunction name="GetProductBrandID" returntype="numeric" output="false">
		<cfset ThisCategoryID=This.GetProperty("CategoryID")>
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
	
	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			ResourceType="#ARGUMENTS.ResourceType#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
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
			<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#this.GetProperty('CategoryID')#" ReturnVarName="PathFragment">
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
			<cfset UploadedFile="#File.ServerDirectory#\#APPLICATION.UtilsObj.ScrubFileName(File.ServerFile)#">
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
			CategoryID="#this.GetProperty('CategoryID')#">
		
		<cfif isCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisCategoryID=this.GetProperty("CategoryID")>
			<cfset ThisLanguageID=this.GetProperty("LanguageID")>
			
			
			<cfquery name="SelectProductAttributes" datasource="#APPLICATION.DSN#">
				select * FROM t_ProductAttribute 
				WHERE CategoryID=#Val(ThisCategoryID)# and LanguageID=#ThisLanguageID# AND ProductFamilyAttributeID IN (#this.lAttributeID#)
			</cfquery>
			
			<cfquery name="DeleteProductAttributes" datasource="#sProductionSiteInformation.ProductionDBDSN#">
				delete from t_ProductAttribute 
				WHERE CategoryID=#Val(ThisCategoryID)# and LanguageID=#ThisLanguageID# AND ProductFamilyAttributeID IN (#this.lAttributeID#)
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
				WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category' AND TextBlockTypeID=900
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
					WHERE KeyID=#Val(thisCategoryID)# and Entity='t_Category' AND TextBlockTypeID=900
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
			<!--- ATTRIBUTES --->
			
			<!--- Get Staging Data --->
			<cfquery name="GetPrevProductFamilyAttributeStaging" datasource="#APPLICATION.DSN#">
				select * from t_ProductFamilyAttribute
				WHERE CategoryID=#Val(thisCategoryID)#
				Order by ProductFamilyAttributePriority
			</cfquery>
			<cfif GetPrevProductFamilyAttributeStaging.RecordCount GT "0">
				<cfquery name="GetPrevProductFamilyAttributeLanguageStaging" datasource="#APPLICATION.DSN#">
					select * from t_ProductFamilyAttributeLanguage
					WHERE ProductFamilyAttributeID IN (#ValueList(GetPrevProductFamilyAttributeStaging.ProductFamilyAttributeID)#) and LanguageID=#Val(ThisLanguageID)#
					Order by ProductFamilyAttributeID
				</cfquery>
			</cfif>
			
			<cftransaction>
				<!--- Get Prod Data --->
				<cfquery name="GetPrevProductFamilyAttributeProd" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					select * from t_ProductFamilyAttribute
					WHERE CategoryID=#Val(thisCategoryID)#
					Order by ProductFamilyAttributePriority
				</cfquery>
				
				<!--- Clear out Prod data --->
				<cfif GetPrevProductFamilyAttributeProd.RecordCount GT "0">
					<cfquery name="DeleteProductFamilyAttribute" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						delete from t_ProductFamilyAttribute
						WHERE ProductFamilyAttributeID IN (#ValueList(GetPrevProductFamilyAttributeProd.ProductFamilyAttributeID)#)
					</cfquery>
					<cfquery name="DeleteProductFamilyAttribute" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						delete from t_ProductFamilyAttributeLanguage
						WHERE ProductFamilyAttributeID IN (#ValueList(GetPrevProductFamilyAttributeProd.ProductFamilyAttributeID)#) and LanguageID=#Val(ThisLanguageID)#
					</cfquery>
				</cfif>
				
				<!--- Insert staging data into prod --->
				<cfoutput query="GetPrevProductFamilyAttributeStaging">
					<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SET IDENTITY_INSERT t_ProductFamilyAttribute ON
						INSERT INTO t_ProductFamilyAttribute 
						(ProductFamilyAttributeID, CategoryID, ProductFamilyAttributeTypeID, ProductFamilyAttributePriority,SpecificationSetID)
						VALUES
						(#Val(ProductFamilyAttributeID)#, #Val(CategoryID)# , #Val(ProductFamilyAttributeTypeID)#, #Val(ProductFamilyAttributePriority)#, #Val(SpecificationSetID)#)
						SET IDENTITY_INSERT t_ProductFamilyAttribute OFF
					</cfquery>
				</cfoutput>
				<cfif IsDefined("GetPrevProductFamilyAttributeLanguageStaging")>
					<cfoutput query="GetPrevProductFamilyAttributeLanguageStaging">
						<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							Insert into t_ProductFamilyAttributeLanguage 
							(ProductFamilyAttributeID, ProductFamilyAttributeName, LanguageID)
							VALUES
							(#Val(ProductFamilyAttributeID)#, N'#ProductFamilyAttributeName#', #Val(LanguageID)#)
						</cfquery>
					</cfoutput>
				</cfif>
				
				<CF_Venn
					ListA="#ValueList(GetPrevProductFamilyAttributeStaging.ProductFamilyAttributeID)#"
					ListB="#ValueList(GetPrevProductFamilyAttributeProd.ProductFamilyAttributeID)#"
					AnotB="ListToDelete">
				<cfif ListLen(ListToDelete) GT "0">
					<cfquery name="DeleteOthers1" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						DELETE from t_ProductAttribute WHERE ProductFamilyAttributeID IN (#ListToDelete#)
					</cfquery>
				</cfif>
			</cftransaction>	
			
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
						(ResourceID, Entity, KeyID, ResourcePriority)
						VALUES
						(#Val(ResourceID)#,'#Entity#', #Val(KeyID)# , #Val(ResourcePriority)#)
						SET IDENTITY_INSERT t_Resource OFF
					</cfquery>
				</cfoutput>
				<cfif Isdefined("GetPrevResourceLanguageStaging")>
					<cfoutput query="GetPrevResourceLanguageStaging">
						<cfquery name="insert" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							Insert into t_ResourceLanguage 
							(ResourceID, ResourceName, ResourceText, LanguageID, MainFilePath, ThumbnailFilePath)
							VALUES
							(#Val(ResourceID)#, N'#ResourceName#', N'#ResourceText#', #Val(LanguageID)#, '#MainFilePath#', '#ThumbnailFilePath#')
						</cfquery>
						<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
							<cfset ThisImageValue=Evaluate("#ThisImage#")>
							<cfif ThisImageValue IS NOT "">
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