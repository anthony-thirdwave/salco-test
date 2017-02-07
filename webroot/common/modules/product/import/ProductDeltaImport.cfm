<cfsetting RequestTimeOut="60000" showdebugoutput="false">
<cfset Commit="1">

<cfset LogFile="productDeltaImport_#Year(now())##numberformat(Month(now()),'00')##numberformat(day(now()),'00')#.txt">
<cfset LogFilePath="#getDirectoryFromPath(getCurrentTemplatePath())#\logs\">
<cfif directoryExists(LogFilePath) IS "0">
	<cfdirectory action="create" directory="#LogFilePath#">
</cfif>
<cffile action="WRITE" file="#LogFilePath#\#LogFile#" output="Log file created #Now()#" addnewline="Yes">

<cfset sImportFiles=structNew()>

<cfif APPLICATION.Staging>
	<cfset sImportFiles["new"]="D:\websites.staging\salco\Resources\W\ProductUpdates\new.csv">
	<cfset sImportFiles["update"]="D:\websites.staging\salco\Resources\W\ProductUpdates\update.csv">
	<cfset sImportFiles["delete"]="D:\websites.staging\salco\Resources\W\ProductUpdates\delete.csv">
<cfelse>
	<cfset sImportFiles["new"]="#ExpandPath('/common/incoming/import/productDelta/new.csv')#">
	<cfset sImportFiles["update"]="#ExpandPath('/common/incoming/import/productDelta/update.csv')#">
	<cfset sImportFiles["delete"]="#ExpandPath('/common/incoming/import/productDelta/delete.csv')#">
</cfif>

<!--- 
	5731: ID of Orphan Products
 --->
<cfset defaultProductFamilyID="5731">



<cfset sColumnName=structNew()>
<cfset sColumnName["Column_1"]="fpartno">
<cfset sColumnName["Column_2"]="frev">
<cfset sColumnName["Column_3"]="fac">
<cfset sColumnName["Column_4"]="fdescript">
<cfset sColumnName["Column_5"]="fdstmemo">
<cfset sColumnName["Column_6"]="fccadfile1">
<cfset sColumnName["Column_7"]="fccadfile2">
<cfset sColumnName["Column_8"]="fccadfile3">
<cfset sColumnName["Column_9"]="fcdncfile">

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

<cfset TotalLogText="">
<cfset CRLF="#CHR(13)##CHR(10)#">

<cfset sCounter=structNew()>

<cfloop index="thisImport" list="new,update,delete">
	<cfoutput><h2>#thisImport#</h2></cfoutput>
	<cfif fileExists(sImportFiles[thisImport])>
		<cffile action="read" file="#sImportFiles[thisImport]#" variable="thisImportContents">
		<cfinvoke component="/com/utils/utils"
			method="CSVToQuery"
			CSV="#Trim(thisImportContents)#"
			returnVariable="GetProductsToImport">
		<cfif GetProductsToImport.recordCount LTE "1">
			<cfsavecontent variable="LogTextElement">
				Empty import file: #sImportFiles[thisImport]#
			</cfsavecontent>
		<cfelse>
			<cfoutput query="GetProductsToImport">
				<cfif GetProductsToImport.CurrentRow IS NOT "1">

					<cfset sRow=structNew()>
					<cfloop index="thisKey" list="#StructKeyList(sColumnName)#">
						<cfset sRow[sColumnName[thisKey]]="#Trim(evaluate('GetProductsToImport.#thisKey#'))#">
					</cfloop>

					<cfquery name="GetTargetProduct" datasource="#APPLICATION.DSN#">
						select * from qry_GetProduct 
						where 
							ProductFamilyAttributeID=<cfqueryparam value="10" cfsqltype="cf_sql_integer"> and 
							AttributeValue=<cfqueryparam value="#sRow.fPartNo#" cfsqltype="cf_sql_varchar">
					</cfquery>
					
					<cfset ThisFile=sRow.FCCadFile2>
					<cfset ThisFile=ReplaceNoCase(ThisFile,"W:\DWF Parts","/resources/external/dwfparts")>
					<cfset ThisFile=Replace(ThisFile,"\","/","All")>
					<cfset Source=ReplaceNoCase(sRow.FCCadFile2,"W:\","#ListDeleteAt(APPLICATION.RootPath,ListLen(APPLICATION.RootPath,'\'),'\')#\resources\w\")>
					<cfif FileExists(Source)>
						<cfset ThisFileSize="#GetFileInfo(Source).Size#">
					<cfelse>
						<cfset ThisFileSize="">
					</cfif>
					<cfsavecontent variable="LogTextElement">
						------------------------------------------------------------------------------------
						#sRow.FPartNo#  operation: #thisImport#  CMS Category ID: #ValueList(GetTargetProduct.CategoryID)#
					</cfsavecontent>
					<cfset ThisProductDescription="#Trim(sRow.FDSTMemo)#">
					<cfset ThisPublicDrawing="#Trim(ThisFile)#">
					<cfset ThisPublicDrawingSize="#Trim(ThisFileSize)#">
					<cfset ThisPartNumber="#Trim(sRow.FPartNo)#">
					<cfset thisLSubPartNo="#Trim(sRow.fcdncfile)#">
					
					<cfif ThisPublicDrawing IS NOT "" and fileExists(expandPath(ThisPublicDrawing)) IS "0">
						<cfset LogTextElement="#LogTextElement##CRLF#+#expandPath(ThisPublicDrawing)# does not exist">
					</cfif>

					<cfif sRow.FPartNo IS NOT "">
						<cfif thisImport IS "delete">
							<cfset ThisWasUpdated="0">
							<cfif GetTargetProduct.RecordCount GTE "1">
								<cfloop query="GetTargetProduct">
									<cfquery name="UpdateCategory" datasource="#APPLICATION.DSN#">
										update t_Category set CategoryActive=0
										where CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfset ThisWasUpdated="1">
									<cfset LogTextElement="#LogTextElement##CRLF#+++DELETE: Made inactive (#GetTargetProduct.CategoryID#)">
								</cfloop>
							<cfelse>
								<cfset LogTextElement="#LogTextElement##CRLF#+++DELETE: Not present in DB">
							</cfif>
						<cfelse>
							<cfif GetTargetProduct.RecordCount GTE "1">
								<!--- update product --->
								
								<cfset thisNewLRelatedPageID="">
								<cfset lPartNoMissing="">
								<cfloop index="thisPartNo" list="#sRow.fcdncfile#">
									<cfinvoke component="/com/product/producthandler" method="GetProductByProductNo" returnVariable="thisPartCategoryID" PartNo="#thisPartNo#">
									<cfif val(thisPartCategoryID) GT "0">
										<cfset thisNewLRelatedPageID=listAppend(thisNewLRelatedPageID,thisPartCategoryID)>
									<cfelse>
										<cfset lPartNoMissing=ListAppend(lPartNoMissing,thisPartNo)>
									</cfif>
								</cfloop>

								<cfloop query="GetTargetProduct">
									<cfquery name="getProperties" datasource="#APPLICATION.DSN#">
										select * from qry_GetCategoryLocale
										where categoryID=<cfqueryparam value="#GetTargetProduct.CategoryID#" cfsqltype="cf_sql_integer">
										and localeID=<cfqueryparam value="#APPLICATION.defaultLocaleID#" cfsqltype="cf_sql_integer">
									</cfquery>

									<cfset sProperties=structNew()>
									<cfset thisOriginalLRelatedPageID="">
									<cfset thisPropertiesID="-1">
									<cfif isWDDX(getProperties.propertiesPacket)>
										<cfset thisPropertiesID=getProperties.propertiesID>
										<cfwddx action="WDDX2CFML" input="#getProperties.propertiesPacket#" output="sProperties">
										<cfif structKeyExists(sProperties, "lRelatedPageID") and sProperties.lRelatedPageID is NOT "">
											<cfset thisOriginalLRelatedPageID=sProperties.lRelatedPageID>
										</cfif>
									</cfif>

									<cfif Commit>
										<cfset LogTextElement="#LogTextElement##CRLF#+Working on #GetTargetProduct.CategoryID# in CMS">
										<cfset ThisWasUpdated="0">
										
										<cfif trim(sRow.fdescript) IS NOT "" and hash(GetTargetProduct.CategoryName) IS NOT Hash(Trim(sRow.fdescript))>
											<cfquery name="UpdateCategory" datasource="#APPLICATION.DSN#">
												update t_Category set CategoryName=<cfqueryparam value="#Trim(sRow.fdescript)#" cfsqltype="cf_sql_varchar">
												where CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer">
											</cfquery>
											<cfset ThisWasUpdated="1">
											<cfset LogTextElement="#LogTextElement##CRLF#+++Updated Name: ""#GetTargetProduct.CategoryName#"" -> ""#sRow.fdescript#"" (#GetTargetProduct.CategoryID#)">
										</cfif>
										
										<cfif thisNewLRelatedPageID IS NOT "" and hash(thisOriginalLRelatedPageID) IS NOT hash(thisNewLRelatedPageID) and val(thisPropertiesID) GT "0">
											<cfset sProperties["LRelatedPageID"]=thisNewLRelatedPageID>
											<cfwddx action="CFML2WDDX" input="#sProperties#" output="wProperties">
											<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
												UPDATE t_Properties
												SET PropertiesPacket=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_varchar">
												WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
											</cfquery>
											<cfset ThisWasUpdated="1">
											<cfset LogTextElement="#LogTextElement##CRLF#+++Updated Sub-Assemblies: ""#thisOriginalLRelatedPageID#"" -> ""#thisNewLRelatedPageID#"" (#GetTargetProduct.CategoryID#)">
										</cfif>
										<cfif lPartNoMissing IS NOT "">
											<cfset LogTextElement="#LogTextElement##CRLF#+++Missing related parts from CMS: #lPartNoMissing#">
										</cfif>
										<cfloop index="ThisID" list="#lAttributeID#">
											<cfset ThisValue=trim(Evaluate("This#sAttribute[ThisID]#"))>
											<cfquery name="test" datasource="#APPLICATION.DSN#">
												select * from t_ProductAttribute 
												WHERE 
												CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer"> AND 
												LanguageID=<cfqueryparam value="#Val(APPLICATION.DefaultLanguageID)#" cfsqltype="cf_sql_integer"> AND 
												ProductFamilyAttributeID=<cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">
											</cfquery>
											
											<cfif ThisValue IS NOT "" AND Hash(Trim(ThisValue)) IS NOT hash(Trim(test.AttributeValue))>
												
												<cfif test.RecordCount GT "0">
													<cfquery name="update" datasource="#APPLICATION.DSN#">
														update t_ProductAttribute Set
														AttributeValue=N'#Trim(ThisValue)#'
														WHERE 
														CategoryID=<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer"> AND 
														LanguageID=<cfqueryparam value="#Val(APPLICATION.DefaultLanguageID)#" cfsqltype="cf_sql_integer"> AND 
														ProductFamilyAttributeID=<cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">
													</cfquery>
													<cfset LogTextElement="#LogTextElement##CRLF#+++Updated #sAttribute[ThisID]#: ""#Trim(test.AttributeValue)#"" -> ""#Trim(ThisValue)#"" (#GetTargetProduct.CategoryID#)">
												<cfelse>
													<cfquery name="insert" datasource="#APPLICATION.DSN#">
														INSERT INTO t_ProductAttribute 
														(CategoryID, LanguageID, ProductFamilyAttributeID, AttributeValue)
														VALUES
														(<cfqueryparam value="#Val(GetTargetProduct.CategoryID)#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#Val(APPLICATION.DefaultLanguageID)#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">, N'#Trim(ThisValue)#')
													</cfquery>
													<cfset LogTextElement="#LogTextElement##CRLF#+++Inserted #sAttribute[ThisID]#: ""#Trim(ThisValue)#"" (#GetTargetProduct.CategoryID#)">
												</cfif>
												<cfset ThisWasUpdated="1">
											</cfif>
										</cfloop>
										
										<cfif ThisWasUpdated>
											<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
												UserID="1"
												Entity="Category"
												KeyID="#Val(GetTargetProduct.CategoryID)#"
												Operation="modify"
												EntityName="#Trim(sRow.fdescript)#"
												Note="#FormatLog(LogTextElement)#">
											<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
												Lookup="Category"
												KeyID="#Val(GetTargetProduct.CategoryID)#">
										</cfif>
										
									</cfif>
									<cfset LogTextElement="#LogTextElement##CRLF#+UPDATE DONE TO #Trim(sRow.fdescript)# (#GetTargetProduct.CategoryID#)#CRLF#Any updates made?: #YesNoFormat(ThisWasUpdated)#">
								</cfloop>
								
							<cfelse>
								<!--- new product --->
								<cfif Commit>

									<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
									<cfset MyCategory.Constructor(-1)>
									<cfset MyCategory.SetProperty("CategoryName",sRow.fdescript)>
									<cfset MyCategory.SetProperty("CategoryActive",1)>
									<cfset MyCategory.SetProperty("ShowInNavigation",1)>
									<cfset MyCategory.SetProperty("CategoryTypeID",64)>
									<cfset MyCategory.SetProperty("ParentID",defaultProductFamilyID)>
									<cfinvoke component="com.ContentManager.CategoryHandler"
										method="CreateAlias"
										Name="#sRow.FPartNo#"
										CategoryID="-1"
										returnVariable="thisCategoryAlias">
									<cfset MyCategory.SetProperty("CategoryAlias",thisCategoryAlias)>
									<cfif MyCategory.IsCorrect() IS "0">
										New product creation failed.
									</cfif>
									<cfset MyCategory.Save(APPLICATION.WebrootPath,1)>
									<cfset ThisCategoryID=MyCategory.GetProperty("CategoryID")>
							
									<cfset MyProduct=CreateObject("component","com.Product.Product")>
									<cfset MyProduct.Constructor(Val(ThisCategoryID),APPLICATION.DefaultLanguageID)>
									<cfset MyProduct.SetProperty("ProductDescription",Trim(sRow.FDSTMemo))>
									<cfset MyProduct.SetProperty("PublicDrawing",Trim(ThisFile))>
									<cfset MyProduct.SetProperty("PublicDrawingSize",Trim(ThisFileSize))>
									<cfset MyProduct.SetProperty("PartNumber",sRow.FPartNo)>
									<cfset MyProduct.Save(APPLICATION.WebrootPath,1)>
									
									<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
									<cfset MyCategoryLocale.Constructor(-1)>
									<cfset MyCategoryLocale.SetProperty("CategoryID",ThisCategoryID)>
									<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
									<cfset MyCategoryLocale.SetCategoryTypeID(64)>
									
									<cfset MyCategoryLocale.SetProperty("DefaultCategoryLocale",1)>
									<cfset MyCategoryLocale.SetProperty("CategoryLocaleActive",1)>
									<cfset MyCategoryLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
									<cfset MyCategoryLocale.SetProperty("lRelatedPageID","")>
									<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,1)>
								</cfif>
								
								<cfset LogTextElement="#LogTextElement##CRLF#CREATE #sRow.fdescript# (CategoryID: #Val(ThisCategoryID)#)">
							</cfif>
						</cfif>
						#APPLICATION.utilsObj.AddBreaks(LogTextElement)#
						<hr>
						<cffile action="APPEND" file="#LogFilePath#\#LogFile#" output="#FormatLog(LogTextElement)##CRLF#" addnewline="Yes">
						<cfset TotalLogText="#TotalLogText##CRLF##LogTextElement#">
						<cfif structKeyExists(sCounter,thisImport)>
							<cfset sCounter[thisImport]++>
						<cfelse>
							<cfset sCounter[thisImport]="1">
						</cfif>
					</cfif>
				</cfif>
			</cfoutput>
		</cfif>
	</cfif>
</cfloop>

<cfif APPLICATION.Staging>
	<cfset NotificationEmail="notifications@dev01.thirdwavellc.com">
<cfelse>
	<cfset NotificationEmail="notifications@dev01.thirdwavellc.com">
</cfif>

<cfset subject="">

<cfloop index="thisCounter" list="#StructKeyList(sCounter)#">
	<cfset subject="#subject# #thisCounter#:#sCounter[thisCounter]#">
</cfloop>

<cfmail to="#NotificationEmail#" from="support@thirdwavellc.com" subject="Salco Product Delta Import: #subject#" type="text">
#FormatLog(TotalLogText)#
</cfmail>

<cffunction name="FormatLog" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfset ARGUMENTS.String=ReplaceNoCase(Trim(ARGUMENTS.String),"#Chr(9)#", "","ALL")>
	<cfreturn ARGUMENTS.String>
</cffunction>
DONE