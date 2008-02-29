<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="CategoryLocaleID" type="numeric" default="">
	<cfproperty name="CategoryID" type="numeric" default="">
	<cfproperty name="CategoryLocaleName" type="string" default="">
	<cfproperty name="CategoryLocaleActive" type="boolean" default="">
	<cfproperty name="CategoryLocaleURL" type="String" default="">
	<cfproperty name="LocaleID" type="numeric" default="">
	<cfproperty name="PropertiesID" type="numeric" default="">
	<cfproperty name="DefaultCategoryLocale" type="boolean" default="">
	
	<!--- Custom Properties --->
	<cfproperty name="CategoryImageOff" type="string" default="">
	<cfproperty name="CategoryImageOn" type="string" default="">
	<cfproperty name="CategoryImageRollover" type="string" default="">
	<cfproperty name="CategoryImageHeader" type="string" default="">
	<cfproperty name="CategoryImageTitle" type="string" default="">
	<cfproperty name="CategoryImageRepresentative" type="string" default="">
	<cfproperty name="MetaKeywords" type="string" default="">
	<cfproperty name="MetaDescription" type="string" default="">
	<cfproperty name="ProductPrice" type="string" default="">
	<cfproperty name="CallToActionURL" type="string" default="">
	<cfproperty name="ProductFamilyDescription" type="string" default="">
	<cfproperty name="CategoryLocaleNameAlternative" type="string" default="">
	<cfproperty name="Byline1" type="string" default="">
	<cfproperty name="Byline2" type="string" default="">
	<cfproperty name="Title" type="string" default="">
	<cfproperty name="PageTitleOverride " type="string" default="">
	
	<cfset structInsert(sPropertyDisplayName,"CategoryLocaleID","category locale ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryID","category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryLocaleName","category locale name",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryLocaleActive","category locale active",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryLocaleURL","category locale URL",1)>
	<cfset structInsert(sPropertyDisplayName,"LocaleID","locale ID",1)>
	<cfset structInsert(sPropertyDisplayName,"PropertiesID","properties ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageOff","off image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageOn","on image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageRollover","highlight image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageHeader","header image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageTitle","title image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageRepresentative","representative image",1)>
	<cfset structInsert(sPropertyDisplayName,"MetaKeywords","meta keywords",1)>
	<cfset structInsert(sPropertyDisplayName,"MetaDescription","meta description",1)>
	<cfset structInsert(sPropertyDisplayName,"DefaultCategoryLocale","default category locale",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductPrice","product price",1)>
	<cfset structInsert(sPropertyDisplayName,"CallToActionURL","Call To Action URL",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductFamilyDescription","product family description",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryLocaleNameAlternative","alternative category locale name",1)>
	<cfset structInsert(sPropertyDisplayName,"Byline1","Byline 1",1)>
	<cfset structInsert(sPropertyDisplayName,"Byline2","Byline 2",1)>
	<cfset structInsert(sPropertyDisplayName,"Title","Title 2",1)>
	<cfset structInsert(sPropertyDisplayName,"PageTitleOverride","page title override",1)>
	
	<cfset this.CategoryTypeID="-1">
	
	<cfset this.sFields=StructNew()>
	<cfloop index="ThisCategoryTypeID" list="-1,60,61,62,63,64,65,67,68,69,70,71,72,73,74,75,76">
		<cfswitch expression="#ThisCategoryTypeID#">
			
				<!--- Not Used --->
				<cfcase value="64"><!--- Product --->
					<cfset this.sFields[ThisCategoryTypeID]="ProductPrice,CallToActionURL">
				</cfcase>
				<cfcase value="63"><!--- Product Series--->
					<cfset this.sFields[ThisCategoryTypeID]="ProductFamilyDescription">
				</cfcase>
				<cfcase value="69"><!--- Press Release--->
					<cfset this.sFields[ThisCategoryTypeID]="Byline1,Byline2">
				</cfcase>
				<cfcase value="70"><!--- Press Release--->
					<cfset this.sFields[ThisCategoryTypeID]="Title">
				</cfcase>
				<!--- End Not Used --->
				<cfcase value="76"><!--- journal --->
					<cfset this.sFields[ThisCategoryTypeID]="Title,CategoryImageRepresentative">
				</cfcase>
			<cfdefaultcase><!--- Default --->
				<cfset this.sFields[ThisCategoryTypeID]="CategoryImageRepresentative">
			</cfdefaultcase>
		</cfswitch>
	</cfloop>
	
	<cffunction name="constructor" returntype="boolean" output="true">
		<cfargument name="ID" default="0" type="numeric" required="false">
		
		<!--- init variables --->
		<cfset var ThisProperty = "">
		<cfset var GetItems = "">
		<cfset var GetCategoryTypeID = "">
		<cfset var GetCategoryProperties = "">
		<cfset var sProperties = "">
		
		<!--- Typically, use set methods in contructor. --->
		<cfset this.SetProperty("CategoryLocaleID","-1")>
		<cfset this.SetProperty("LocaleID","-1")>
		<cfset this.SetProperty("CategoryID","-1")>
		<cfset this.SetProperty("CategoryLocaleName","")>
		<cfset this.SetProperty("CategoryLocaleActive","1")>
		<cfset this.SetProperty("CategoryLocaleURL","")>
		<cfset this.SetProperty("PropertiesID","-1")>
		<cfset this.SetProperty("DefaultCategoryLocale","0")>
		
		<cfset this.SetProperty("CategoryImageOff","")>
		<cfset this.SetProperty("CategoryImageOn","")>
		<cfset this.SetProperty("CategoryImageRollover","")>
		<cfset this.SetProperty("CategoryImageHeader","")>
		<cfset this.SetProperty("CategoryImageTitle","")>
		<cfset this.SetProperty("CategoryImageRepresentative","")>
		<cfset this.SetProperty("MetaKeywords","")>
		<cfset this.SetProperty("MetaDescription","")>
		<cfset this.SetProperty("ProductPrice","")>
		<cfset this.SetProperty("CallToActionURL","")>
		<cfset this.SetProperty("ProductFamilyDescription","")>
		<cfset this.SetProperty("CategoryLocaleNameAlternative","")>
		<cfset this.SetProperty("Byline1","")>
		<cfset this.SetProperty("Byline2","")>
		<cfset this.SetProperty("Title","")>
		<cfset this.SetProperty("PageTitleOverride","")>
		
		<cfif Val(ARGUMENTS.ID) GT 0>
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_CategoryLocale
				WHERE CategoryLocaleID=<cfqueryparam value="#Val(ARGUMENTS.ID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetItems.recordcount EQ 1>
				<cfquery name="GetCategoryTypeID" datasource="#APPLICATION.DSN#">
					select CategoryTypeID from t_Category Where CategoryID=<cfqueryparam value="#Val(GetItems.CategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset this.CategoryTypeID=GetCategoryTypeID.CategoryTypeID>
				<cfoutput query="GetItems">
					<cfset this.SetProperty("LocaleID",LocaleID)>
					<cfset this.SetProperty("CategoryLocaleID",CategoryLocaleID)>
					<cfset this.SetProperty("CategoryID",CategoryID)>
					<cfset this.SetProperty("CategoryLocaleName",CategoryLocaleName)>
					<cfset this.SetProperty("CategoryLocaleActive",CategoryLocaleActive)>
					<cfset this.SetProperty("CategoryLocaleURL",CategoryLocaleURL)>
					<cfset this.SetProperty("PropertiesID",PropertiesID)>
					<cfset this.SetProperty("DefaultCategoryLocale",DefaultCategoryLocale)>
					<!--- Custom Properties --->
					<cfquery name="GetCategoryProperties" datasource="#APPLICATION.DSN#">
						SELECT * FROM t_Properties WHERE PropertiesID = <cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif isWDDX(GetCategoryProperties.PropertiesPacket)>
						<cfwddx action="WDDX2CFML" input="#GetCategoryProperties.PropertiesPacket#" output="sProperties">
						<cfloop index="ThisProperty" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative,ProductPrice,ProductFamilyDescription,CallToActionURL,CategoryLocaleNameAlternative,MetaKeywords,MetaDescription,Byline1,Byline2,Title,PageTitleOverride">
							<cfif StructKeyExists(sProperties,"#ThisProperty#")>
								<cfset this.SetProperty("#ThisProperty#",sProperties["#ThisProperty#"])>
							</cfif>
						</cfloop>
					</cfif>
				</cfoutput>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
				<!--- If id is not present, return false. --->
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="false">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">
		
		<!--- init variables --->
		<cfset var thisCategoryLocaleID = "">
		<cfset var thisCategoryID = "">
		<cfset var thisCategoryLocaleName = "">
		<cfset var thisCategoryLocaleActive = "">
		<cfset var thisLocaleID = "">
		<cfset var thisPropertiesID = "">
		<cfset var thisCategoryLocaleURL = "">
		<cfset var thisDefaultCategoryLocale = "">
		<cfset var thisCategoryImageOff = "">
		<cfset var thisCategoryImageOn = "">
		<cfset var thisCategoryImageRollover = "">
		<cfset var thisCategoryImageHeader = "">
		<cfset var thisCategoryImageTitle = "">
		<cfset var thisCategoryImageRepresentative = "">
		<cfset var thisMetaKeywords = "">
		<cfset var thisMetaDescription = "">
		<cfset var thisProductPrice = "">
		<cfset var thisCallToActionURL = "">
		<cfset var thisProductFamilyDescription = "">
		<cfset var thisCategoryLocaleNameAlternative = "">
		<cfset var thisByline1 = "">
		<cfset var thisByline2 = "">
		<cfset var thisTitle = "">
		<cfset var thisPageTitleOverride = "">
		<cfset var Destination = "">
		<cfset var Source = "">
		<cfset var DestinationToSave = "">
		<cfset var sProperties = "">
		<cfset var ImageWidth = "">
		<cfset var DevNull = "">
		<cfset var ThisImage = "">
		<cfset var GetParentID = "">
		<cfset var InsertProperties = "">
		<cfset var InsertCategory = "">
		<cfset var UpdateCategory = "">
		<cfset var GetProperties = "">
		<cfset var UpdateContent = "">
		<cfset var ThisCategoryName = "">
		<cfset var success = "">
		<cfset var wProperties = "">
		
		<cfif IsCorrect()>
			<cfset thisCategoryLocaleID=this.GetProperty("CategoryLocaleID")>
			<cfset thisCategoryID=this.GetProperty("CategoryID")>
			<cfset thisCategoryLocaleName=this.GetProperty("CategoryLocaleName")>
			<cfset thisCategoryLocaleActive=this.GetProperty("CategoryLocaleActive")>
			<cfset thisLocaleID=this.GetProperty("LocaleID")>
			<cfset thisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset thisCategoryLocaleURL=this.GetProperty("CategoryLocaleURL")>
			<cfset thisDefaultCategoryLocale=this.GetProperty("DefaultCategoryLocale")>
			
			<cfset thisCategoryImageOff=this.GetProperty("CategoryImageOff")>
			<cfset thisCategoryImageOn=this.GetProperty("CategoryImageOn")>
			<cfset thisCategoryImageRollover=this.GetProperty("CategoryImageRollover")>
			<cfset thisCategoryImageHeader=this.GetProperty("CategoryImageHeader")>
			<cfset thisCategoryImageTitle=this.GetProperty("CategoryImageTitle")>
			<cfset thisCategoryImageRepresentative=this.GetProperty("CategoryImageRepresentative")>
			<cfset thisMetaKeywords=this.GetProperty("MetaKeywords")>
			<cfset thisMetaDescription=this.GetProperty("MetaDescription")>
			<cfset thisProductPrice=this.GetProperty("ProductPrice")>
			<cfset thisCallToActionURL=this.GetProperty("CallToActionURL")>
			<cfset thisProductFamilyDescription=this.GetProperty("ProductFamilyDescription")>
			<cfset thisCategoryLocaleNameAlternative=this.GetProperty("CategoryLocaleNameAlternative")>
			<cfset thisByline1=this.GetProperty("Byline1")>
			<cfset thisByline2=this.GetProperty("Byline2")>
			<cfset thisTitle=this.GetProperty("Title")>
			<cfset thisPageTitleOverride=this.GetProperty("PageTitleOverride")>
			
			<cfinvoke component="/com/ContentManager/CategoryHandler" 
				method="GetCategoryName" 
				returnVariable="ThisCategoryName"
				CategoryID="#this.GetProperty('CategoryID')#">
			<cfif thisCategoryLocaleName IS ThisCategoryName>
				<cfset thisCategoryLocaleName="">
				<cfset this.SetProperty("CategoryLocaleName","")>
			</cfif>
			
			<cfif Val(thisCategoryLocaleID) LTE "0">
				<cfquery name="GetParentID" datasource="#APPLICATION.DSN#">
					select ParentID from t_Category 
					where CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<cftransaction>
					<cfquery name="InsertProperties" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_Properties (PropertiesPacket)
						VALUES ('')
						SELECT NewTeaserID=@@Identity
					</cfquery>
					<cfset thisPropertiesID=InsertProperties.NewTeaserID>
					<cfset this.SetProperty("PropertiesID",thisPropertiesID)>
					
					<cfquery name="InsertCategory" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_CategoryLocale (
						LocaleID,
						CategoryLocaleName,
						CategoryID,
						CategoryLocaleURL,
						CategoryLocaleActive,
						PropertiesID,DefaultCategoryLocale
						)
						VALUES (
						<cfqueryparam value="#Val(ThisLocaleID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#trim(ThisCategoryLocaleName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Trim(ThisCategoryLocaleURL)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#val(ThisCategoryLocaleActive)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(thisPropertiesID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisDefaultCategoryLocale)#" cfsqltype="cf_sql_integer">						
						)
						SELECT NewCategoryLocaleID=@@Identity
					</cfquery>
					<cfset thisCategoryLocaleID=InsertCategory.NewCategoryLocaleID>
					<cfset this.SetProperty("CategoryLocaleID",thisCategoryLocaleID)>
				
					<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
					<!--- Move files to its final resting place --->
					<cfif ARGUMENTS.WebrootPath is not "">
						<cfset Destination=this.GetResourcePath("images")>
						<cfset Destination=ReplaceNoCase("#ARGUMENTS.WebrootPath##Destination#","/","\","all")>
						<cfset Destination=ReplaceNoCase("#Destination#","\\","\","all")>
						<cfloop index="ThisImage" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle">
							<cfset Source=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetProperty('#ThisImage#')#","/","\","all")>
							<cfset Source=ReplaceNoCase("#Source#","\\","\","all")>
							<cfif FileExists(Source)>							
								<cffile action="MOVE" source="#Source#" destination="#Destination#">
								<cfset DestinationToSave="#this.GetResourcePath('images')##ListLast(this.GetProperty('#ThisImage#'),'/')#">
								<cfset DestinationToSave=ReplaceNoCase(DestinationToSave,"//","/","all")>
								<cfset this.SetProperty("#ThisImage#","#DestinationToSave#")>
								<cfset SetVariable("This#ThisImage#","#DestinationToSave#")>
							</cfif>
							
						</cfloop>
					</cfif>
				</cftransaction>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="CategoryLocale"
						KeyID="#thisCategoryLocaleID#"
						Operation="create"
						EntityName="#this.GetProperty('CategoryLocaleName')#">
				</cfif>
			<cfelse>
				<cfquery name="UpdateCategory" datasource="#APPLICATION.DSN#">
					UPDATE t_CategoryLocale
					SET
					CategoryLocaleName=<cfqueryparam value="#trim(ThisCategoryLocaleName)#" cfsqltype="cf_sql_varchar">,
					LocaleID=<cfqueryparam value="#Val(ThisLocaleID)#" cfsqltype="cf_sql_integer">,
					CategoryLocaleActive=<cfqueryparam value="#val(ThisCategoryLocaleActive)#" cfsqltype="cf_sql_bit">,
					CategoryLocaleURL=<cfqueryparam value="#trim(ThisCategoryLocaleURL)#" cfsqltype="cf_sql_varchar">,
					CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
					DefaultCategoryLocale=<cfqueryparam value="#Val(ThisDefaultCategoryLocale)#" cfsqltype="cf_sql_integer">
					WHERE CategoryLocaleID=<cfqueryparam value="#val(thisCategoryLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="CategoryLocale"
						KeyID="#thisCategoryLocaleID#"
						Operation="modify"
						EntityName="#this.GetProperty('CategoryLocaleName')#">
				</cfif>
			</cfif>
			
			<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
				SELECT t_Properties.PropertiesID,t_Properties.PropertiesPacket
				FROM t_Properties 
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif isWDDX(GetProperties.PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfelse>
				<cfset sProperties=StructNew()>
			</cfif>
			
			<cfif FileExists("#REQUEST.GetPathFromURL(ThisCategoryImageOff)#")>
				<cf_ImageSize file="#REQUEST.GetPathFromURL(ThisCategoryImageOff)#">
				<cfset ImageWidth=Width>
				<cfset DevNull=StructInsert(sProperties,"ImageWidth","#val(ImageWidth)#","1")>
			<cfelse>
				<cfset DevNull=StructInsert(sProperties,"ImageWidth","0","1")>
			</cfif>
			
			<cfset DevNull=StructInsert(sProperties,"CategoryImageOff","#Trim(ThisCategoryImageOff)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageOn","#Trim(ThisCategoryImageOn)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageRollover","#Trim(ThisCategoryImageRollover)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageHeader","#Trim(ThisCategoryImageHeader)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageTitle","#Trim(ThisCategoryImageTitle)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageRepresentative","#Trim(ThisCategoryImageRepresentative)#","1")>
			<cfset DevNull=StructInsert(sProperties,"MetaKeywords","#Trim(ThisMetaKeywords)#","1")>
			<cfset DevNull=StructInsert(sProperties,"MetaDescription","#Trim(ThisMetaDescription)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductPrice","#Trim(ThisProductPrice)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CallToActionURL","#Trim(ThisCallToActionURL)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductFamilyDescription","#Trim(ThisProductFamilyDescription)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryLocaleNameAlternative","#Trim(ThisCategoryLocaleNameAlternative)#","1")>
			<cfset DevNull=StructInsert(sProperties,"Byline1","#Trim(ThisByline1)#","1")>
			<cfset DevNull=StructInsert(sProperties,"Byline2","#Trim(ThisByline2)#","1")>
			<cfset DevNull=StructInsert(sProperties,"Title","#Trim(ThisTitle)#","1")>
			<cfset DevNull=StructInsert(sProperties,"PageTitleOverride","#Trim(ThisPageTitleOverride)#","1")>
			
			<cfwddx action="CFML2WDDX" input="#sProperties#" output="wProperties">
			<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
				UPDATE t_Properties
				SET PropertiesPacket=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_varchar">
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfinvoke component="/com/ContentManager/CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Category"
				KeyID="#thisCategoryID#">
			
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="SetProperty" returntype="boolean" output="false">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">
		
		<!--- init variables --->
		<cfset var Test = "">
		
		<cfset ARGUMENTS.Property=Trim(ARGUMENTS.Property)>
		
		<cfif IsSimpleValue(ARGUMENTS.Value)>
			<cfset ARGUMENTS.Value=Trim(ARGUMENTS.Value)>

			<cfif ListFindNoCase("CategoryLocaleID,CategoryID,LocaleID,PropertiesID",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
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
			
			<cfif ListFindNoCase("LocaleID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("CategoryLocaleName",ARGUMENTS.Property)>
				<cfif Len(ARGUMENTS.Value) GT "128">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 128 characters long.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("CategoryID,LocaleID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="CategoryID">
							<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Category">
								<cfinvokeargument name="FieldName" value="CategoryID">
								<cfinvokeargument name="FieldValue" value="#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="CategoryID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="LocaleID">
							<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Locale">
								<cfinvokeargument name="FieldName" value="LocaleID">
								<cfinvokeargument name="FieldValue" value="#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LocaleID">
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
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfif IsInError(ARGUMENTS.Property)>
			<cfreturn GetErrorValue(ARGUMENTS.Property)>
		<cfelse>
			<cfset ReturnValue=this["#ARGUMENTS.Property#"]>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>
	
	<cffunction name="GetCategoryTypeID" returntype="numeric" output="false">
		<cfreturn this.CategoryTypeID>
	</cffunction>
	
	<cffunction name="SetCategoryTypeID" returntype="boolean" output="false">
		<cfargument name="NewCategoryTypeID" required="true">
		<cfset this.CategoryTypeID=ARGUMENTS.NewCategoryTypeID>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetRestrictionsPropertyList" returnType="string" output="false">
		<cfset var ReturnString=this.sFields[this.GetCategoryTypeID()]>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
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
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfinvoke component="/com/ContentManager/CategoryHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			ResourceType="#ARGUMENTS.ResourceType#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="FormFileUpload" returntype="boolean" output="1">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">
		<cfargument name="FormFileFieldName" required="true">
		
		<!--- init variables --->
		<cfset var UploadDirectory = "">
		<cfset var UploadedFile = "">
		<cfset var FilePath = "">
		
		<cfif ARGUMENTS.FormFileFieldName IS "" OR ARGUMENTS.WebrootPath IS "" OR ARGUMENTS.Property IS "">
			<cfreturn false>
		<cfelseif ListFindNoCase(StructkeyList(this),ARGUMENTS.Property) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#this.GetProperty('CategoryLocaleID')#" ReturnVarName="PathFragment">
			<cfset UploadDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
			<cfset UploadDirectory=ReplaceNoCase(UploadDirectory,"\\","\","all")>
			<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
			<cffile action="UPLOAD" 
				filefield="#ARGUMENTS.FormFileFieldName#"
				destination="#UploadDirectory#"
				nameconflict="MakeUnique">
			<cfset UploadedFile=File.ServerDirectory & "\" & File.ServerFile>
			<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
				<cffile action="DELETE" file="#UploadedFile#">
				<cfset SetProperty("#ARGUMENTS.Property#","")>
				<cfset AddError(ARGUMENTS.Property,"","The #sPropertyDisplayName[ARGUMENTS.Property]# must be an image.")>
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
		
		<!--- init variables --->
		<cfset var FileToDelete = "">
		
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
	
	<cffunction name="ValidateDelete" returnType="boolean" output="false">
		<cfif this.GetProperty("CategoryLocaleID") GT "0">
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="Delete" returnType="boolean" output="1">
		<cfargument name="TrashPath" required="true">
		<cfargument name="UserID" required="true">
		
		<!--- init variables --->
		<cfset var thisCategoryLocaleID = "">
		<cfset var thisCategoryID = "">
		<cfset var DirDone = "">
		<cfset var DirectoryToCreate = "">
		<cfset var DestImages = "">
		<cfset var DestDocs = "">
		<cfset var lImage = "">
		<cfset var OriginalName = "">
		<cfset var SourceFile = "">
		<cfset var ThisFile = "">
		<cfset var RemoteFile = "">
		<cfset var i = "">
		<cfset var ThisImageName = "">
		<cfset var SelectProps = "">
		<cfset var deleteContent1 = "">
		<cfset var deleteContent3 = "">
		<cfset var SelectCategory = "">
		<cfset var DELETEMEssages = "">
		<cfset var success = "">
		<cfset var sProductionSiteInformation = "">
		
		<cfif this.ValidateDelete() and ARGUMENTS.TrashPath IS NOT "">
			<cftransaction>
				<cfset ThisCategoryLocaleID=this.GetProperty("CategoryLocaleID")>
				<cfset ThisCategoryID=this.GetProperty("CategoryID")>
				<cfquery name="SelectProps" datasource="#APPLICATION.DSN#">
					SELECT PropertiesID FROM t_CategoryLocale WHERE CategoryLocaleID=<cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent1" datasource="#APPLICATION.DSN#">
					DELETE FROM t_CategoryLocale WHERE CategoryLocaleID=<cfqueryparam value="#val(ThisCategoryLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent3" datasource="#APPLICATION.DSN#">
					DELETE FROM t_properties WHERE PropertiesID=<cfqueryparam value="#Val(SelectProps.PropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset DirDone="">
				<cfloop index="i" from="1" to="#Len(ThisCategoryID)#" step="1">
					<cfset DirectoryToCreate="#ARGUMENTS.TrashPath##APPLICATION.CategoryResourcesPath##DirDone##Mid(ThisCategoryID,i,1)#">
					<cfset DirDone="#DirDone##Mid(ThisCategoryID,i,1)#\">
					<cftry>
						<cfdirectory action="CREATE" directory="#DirectoryToCreate#">
						<cfdirectory action="CREATE" directory="#DirectoryToCreate#/images/">
						<cfdirectory action="CREATE" directory="#DirectoryToCreate#/documents/">
						<cfcatch></cfcatch>
					</cftry>
				</cfloop>
				<cfset DestImages="#DirectoryToCreate#\images\">
				<cfset DestDocs="#DirectoryToCreate#\documents\">
				
				<cfset lImage="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative">
				<cfloop index="ThisImageName" list="#lImage#">
					<cfset OriginalName=this.GetProperty(thisImageName)>
					<cfset OriginalName=ReplaceNoCase(OriginalName,"http://#CGI.Server_Name#","","All")>
					<cfset OriginalName=ReplaceNoCase(OriginalName,"//","/","All")>
					<cfset SourceFile=REQUEST.GetPathFromURL(OriginalName)>
					<cfif FileExists(SourceFile)>
						<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#OriginalName#','.')#",";") GT "0">
							<cffile action="MOVE" source="#SourceFile#" destination="#DestImages#">
						<cfelse>
							<cffile action="MOVE" source="#SourceFile#" destination="#DestDocs#">
						</cfif>
					</cfif>
				</cfloop>
			</cftransaction>
			<cfinvoke component="/com/ContentManager/CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="CategoryID"
				KeyID="#thisCategoryID#">
				
			<cfif Val(ARGUMENTS.UserID) GT "0">
				<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
					UserID="#ARGUMENTS.UserID#"
					Entity="CategoryLocale"
					KeyID="#this.GetProperty('CategoryLocaleID')#"
					Operation="delete"
					EntityName="#this.GetProperty('CategoryLocaleName')#">
			</cfif>
			
			<cfinvoke component="/com/ContentManager/CategoryHandler"
				method="GetProductionSiteInformation"
				returnVariable="sProductionSiteInformation"
				CategoryID="#this.GetProperty('CategoryID')#">
				
			<cfif IsStruct(sProductionSiteInformation) and sProductionSiteInformation.ProductionDBDSN is not "">
				<cftransaction>
					<cfquery name="SelectCategory" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SELECT * FROM t_CategoryLocale WHERE CategoryLocaleID = <cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfoutput query="SelectCategory">
						<cfquery name="deleteContent3" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_properties WHERE PropertiesID=<cfqueryparam value="#PropertiesID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery name="DELETEMEssages" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_CategoryLocale WHERE CategoryLocaleID=<cfqueryparam value="#CategoryLocaleID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfoutput>
				</cftransaction>
				
				<cfset lImage="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative">
				<cfloop index="ThisImageName" list="#lImage#">
					<cfset ThisFile=this.GetProperty(thisImageName)>
					<cfif ThisFile IS NOT "">
						<cfset RemoteFile=ReplaceNoCase("#sProductionSiteInformation.ProductionFTPRootPath##ThisFile#","//","/","All")>
						RemoteFile: #RemoteFile#->
						<cfftp action="EXISTSFILE" server="#sProductionSiteInformation.ProductionFTPHost#" 
							username="#sProductionSiteInformation.ProductionFTPUserLogin#"
							password="#sProductionSiteInformation.ProductionFTPPassword#"
							stoponerror="No"
							remotefile="#RemoteFile#"
							connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#"
							Passive="No">
						<cfif cfftp.returnValue IS "Yes">
							<cfftp action="REMOVE" server="#sProductionSiteInformation.ProductionFTPHost#"
								username="#sProductionSiteInformation.ProductionFTPUserLogin#"
								password="#sProductionSiteInformation.ProductionFTPPassword#"
								stoponerror="No"
								Passive="No"
								item="#RemoteFile#"
								connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#"
								timeout="60">
							Removed!
						</cfif><BR>
					</cfif>
				</cfloop>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="GetContent" returnType="Query" output="true">
		<cfset var ThisCategoryLocaleID=this.GetProperty("CategoryLocaleID")>
		<cfset var GetContent = "">
		<cfquery name="GetContent" datasource="#APPLICATION.DSN#">
			SELECT * FROM qry_GetContent WHERE CategoryLocaleID=<cfqueryparam value="#Val(ThisCategoryLocaleID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn GetContent>
	</cffunction>
	
	<cffunction name="SaveToProduction" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="UserID" required="true">

		<!--- init variables --->
		<cfset var ThisCategoryLocaleID = "">
		<cfset var ThisCategoryID = "">
		<cfset var ThisPropertiesID = "">
		<cfset var thisCategoryLocaleActive = "">
		<cfset var ThisLocaleID = "">
		<cfset var lImageName = "">
		<cfset var Source = "">
		<cfset var Destination = "">
		<cfset var ThisImage = "">
		<cfset var GetSummary = "">
		<cfset var DeleteSummaryOnProduction = "">
		<cfset var UpdateSummaryOnProduction = "">
		<cfset var GetProps = "">
		<cfset var DeleteContentOnProduction2 = "">
		<cfset var UpdateContentOnProduction4 = "">
		<cfset var sProductionSiteInformation = "">
		<cfset var success = "">
		<cfset var SaveResults = "">
		
		<cfinvoke component="/com/ContentManager/CategoryHandler" 
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="#this.GetProperty('CategoryID')#">
		<cfif IsCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisCategoryLocaleID=this.GetProperty("CategoryLocaleID")>
			<cfset ThisCategoryID=this.GetProperty("CategoryID")>
			<cfset ThisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset ThisLocaleID=this.GetProperty("LocaleID")>
			
			<cfinvoke component="/com/PostToProduction/postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisCategoryLocaleID#">
			     <cfinvokeargument name="columnList" value="CategoryLocaleID">
			     <cfinvokeargument name="tableName" value="t_CategoryLocale">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>
			
			<cfinvoke component="/com/PostToProduction/postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisCategoryID#,#ThisLocaleID#">
			     <cfinvokeargument name="columnList" value="CategoryID,LocaleID">
			     <cfinvokeargument name="tableName" value="t_CategoryLocaleMeta">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>
			
			
			<cfquery name="GetSummary" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_CategorySummary WHERE CategoryID = <cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfoutput query="GetSummary">
				<cfquery name="DeleteSummaryOnProduction" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					DELETE FROM t_CategorySummary WHERE CategoryID = <cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="UpdateSummaryOnProduction" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					INSERT INTO t_CategorySummary (CategoryID, CategoryAlias, Summary, ThumbnailImage)
					VALUES (
						<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#CategoryAlias#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Summary#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#ThumbnailImage#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfoutput>
			
			<cfquery name="GetProps" datasource="#APPLICATION.DSN#">
				select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(ThisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfoutput query="GetProps">
				<cfquery name="DeleteContentOnProduction2" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					DELETE FROM t_Properties WHERE PropertiesID=<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="UpdateContentOnProduction4" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					SET IDENTITY_INSERT t_Properties ON
					INSERT INTO t_Properties (
					PropertiesPacket,
					PropertiesID
					) VALUES (
					<cfqueryparam value="#Trim(PropertiesPacket)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					)
					SET IDENTITY_INSERT t_Properties OFF
				</cfquery>
			</cfoutput>
		
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
			
			<cfset lImageName="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative">
			
			<cfloop index="ThisImage" list="#lImageName#">
				<cfif this.GetProperty(ThisImage) is not "">
					<cfset Source=REQUEST.GetPathFromURL(this.GetProperty(ThisImage))>
					<cfset Destination=ReplaceNoCase("#sProductionSiteInformation.ProductionFTPRootPath##this.GetProperty(ThisImage)#","//","/","All")>
					<cfftp action="PUTFILE" server="#sProductionSiteInformation.ProductionFTPHost#" 
						username="#sProductionSiteInformation.ProductionFTPUserLogin#"
						password="#sProductionSiteInformation.ProductionFTPPassword#" 
						stoponerror="No"
						localfile="#Source#"
						remotefile="#Destination#"
						transfermode="Auto" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#" timeout="60"
						Passive="No">
					<p>#ThisImage#|#Source# --><BR>
					#Destination#|#CFFTP.ErrorCode#|#CFFTP.ErrorText#</p>
				</cfif>
			</cfloop>
		
			<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
				UserID="#ARGUMENTS.UserID#"
				Entity="CategoryLocale"
				KeyID="#ThisCategoryLocaleID#"
				Operation="savelive"
				EntityName="#this.GetProperty('CategoryLocaleName')#">
				
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>