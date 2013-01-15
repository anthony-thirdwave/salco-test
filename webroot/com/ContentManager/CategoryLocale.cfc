<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct) --->
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
	<cfproperty name="CSSID" type="string" default="">
	<cfproperty name="CallToActionURL" type="string" default="">
	<cfproperty name="CSSClass" type="string" default="">
	<cfproperty name="CategoryLocaleNameAlternative" type="string" default="">
	<cfproperty name="Byline1" type="string" default="">
	<cfproperty name="Byline2" type="string" default="">
	<cfproperty name="Title" type="string" default="">
	<cfproperty name="SubTitle" type="string" default="">
	<cfproperty name="PageTitleOverride" type="string" default="">
	<cfproperty name="HomePageDisplay" type="boolean" default="">
	<cfproperty name="EmergencyAlert" type="boolean" default="">
	<cfproperty name="IncludeInScreenSaver" type="boolean" default="">
	
	<!--- /// added for page type employee/// --->
	<cfproperty name="EmpFirstName" type="string" default="">
	<cfproperty name="EmpLastName" type="string" default="">
	<cfproperty name="EmpTitle" type="string" default="">
	<cfproperty name="empPhone" type="string" default="">
	<cfproperty name="empPhoneExt" type="string" default="">
	<cfproperty name="empCellPhone" type="string" default="">
	<cfproperty name="empImage" type="string" default="">
	<cfproperty name="empImageThumb" type="string" default="">
	<cfproperty name="empEmail" type="string" default="">
	<cfproperty name="empBirthDate" type="string" default="">
	<cfproperty name="empJoinDate" type="string" default="">

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
	<cfset structInsert(sPropertyDisplayName,"CategoryImageHeader","hero image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageTitle","title image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageRepresentative","representative image",1)>
	<cfset structInsert(sPropertyDisplayName,"MetaKeywords","meta keywords",1)>
	<cfset structInsert(sPropertyDisplayName,"MetaDescription","meta description",1)>
	<cfset structInsert(sPropertyDisplayName,"DefaultCategoryLocale","default category locale",1)>
	<cfset structInsert(sPropertyDisplayName,"CSSID","CSS id",1)>
	<cfset structInsert(sPropertyDisplayName,"CSSClass","CSS class",1)>
	<cfset structInsert(sPropertyDisplayName,"CallToActionURL","Call To Action URL",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryLocaleNameAlternative","alternative category locale name",1)>
	<cfset structInsert(sPropertyDisplayName,"Byline1","Byline 1",1)>
	<cfset structInsert(sPropertyDisplayName,"Byline2","Byline 2",1)>
	<cfset structInsert(sPropertyDisplayName,"Title","Title 2",1)>
	<cfset structInsert(sPropertyDisplayName,"SubTitle","SubTitle 2",1)>
	<cfset structInsert(sPropertyDisplayName,"HomePageDisplay","Home Page Display",1)>
	<cfset structInsert(sPropertyDisplayName,"EmergencyAlert","Emergency Alert",1)>
	<cfset structInsert(sPropertyDisplayName,"IncludeInScreenSaver","Include In Screen Saver",1)>
	<cfset structInsert(sPropertyDisplayName,"PageTitleOverride","page title override",1)>
	
	<!--- /// added for page type employee/// --->
	<cfset structInsert(sPropertyDisplayName,"empFirstName","employee first name",1)>
	<cfset structInsert(sPropertyDisplayName,"empLastName","employee last name",1)>
	<cfset structInsert(sPropertyDisplayName,"empTitle","employee title",1)>
	<cfset structInsert(sPropertyDisplayName,"empPhone","employee phone",1)>
	<cfset structInsert(sPropertyDisplayName,"empPhoneExt","employee phone extension",1)>
	<cfset structInsert(sPropertyDisplayName,"empCellPhone","employee cell phone",1)>
	<cfset structInsert(sPropertyDisplayName,"empImage","employee Image",1)>
	<cfset structInsert(sPropertyDisplayName,"empImageThumb","employee image thumbnail",1)>
	<cfset structInsert(sPropertyDisplayName,"empEmail","employee email",1)>
	<cfset structInsert(sPropertyDisplayName,"empBirthDate","employee birth date",1)>
	<cfset structInsert(sPropertyDisplayName,"empJoinDate","employee join date",1)>

	<cfset this.CategoryTypeID="-1">

	<cfset this.sFields=StructNew()>
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetAllCategoryType"
		returnVariable="GetAllCategoryType">
	<cfloop index="ThisCategoryTypeID" list="#ValueList(GetAllCategoryType.LabelID)#">
		<cfswitch expression="#ThisCategoryTypeID#">
			<cfcase value="62"><!--- Product Family--->
				<cfset this.sFields[ThisCategoryTypeID]="CSSID,CategoryImageHeader,CategoryImageRepresentative,CategoryImageRollover">
			</cfcase>
			<cfcase value="64"><!--- Product --->
				<cfset this.sFields[ThisCategoryTypeID]="CSSID,CategoryImageHeader">
			</cfcase>
			<cfcase value="63"><!--- Product Series--->
				<cfset this.sFields[ThisCategoryTypeID]="CSSClass">
			</cfcase>
			<cfcase value="80"><!--- Repeated Page --->
				<cfset this.sFields[ThisCategoryTypeID]="">
			</cfcase>
			<cfcase value="81"><!--- Employee Page --->
				<cfset this.sFields[ThisCategoryTypeID]="empFirstName,empLastName,empTitle,empPhone,empPhoneExt,empCellPhone,empImage,empImageThumb,empEmail,empBirthDate,empJoinDate">
			</cfcase>
			<!--- Not Used --->
			<cfcase value="69"><!--- Press Release--->
				<cfset this.sFields[ThisCategoryTypeID]="Byline1,Byline2">
			</cfcase>
			<cfcase value="70"><!--- Press Release--->
				<cfset this.sFields[ThisCategoryTypeID]="Title">
			</cfcase>
			<!--- End Not Used --->
			<cfcase value="76"><!--- topic --->
				<cfset this.sFields[ThisCategoryTypeID]="">
			</cfcase>
			<cfcase value="77"><!--- Blog --->
				<cfset this.sFields[ThisCategoryTypeID]="CategoryImageRepresentative">
			</cfcase>
			<cfcase value="82"><!--- news --->
				<cfset this.sFields[ThisCategoryTypeID]="SubTitle,CategoryImageRepresentative,HomePageDisplay,EmergencyAlert">
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
		<cfset this.SetProperty("CSSID","")>
		<cfset this.SetProperty("CSSClass","")>
		<cfset this.SetProperty("CallToActionURL","")>
		<cfset this.SetProperty("CategoryLocaleNameAlternative","")>
		<cfset this.SetProperty("Byline1","")>
		<cfset this.SetProperty("Byline2","")>
		<cfset this.SetProperty("Title","")>
		<cfset this.SetProperty("SubTitle","")>
		<cfset this.SetProperty("HomePageDisplay","")>
		<cfset this.SetProperty("EmergencyAlert","")>
		<cfset this.SetProperty("IncludeInScreenSaver","")>
		<cfset this.SetProperty("PageTitleOverride","")>
		
		<!--- /// added for page type employee/// --->
		<cfset this.SetProperty("empFirstName","")>
		<cfset this.SetProperty("empLastName","")>
		<cfset this.SetProperty("empTitle","")>
		<cfset this.SetProperty("empPhone","")>
		<cfset this.SetProperty("empPhoneExt","")>
		<cfset this.SetProperty("empCellPhone","")>
		<cfset this.SetProperty("empImage","")>
		<cfset this.SetProperty("empImageThumb","")>
		<cfset this.SetProperty("empEmail","")>
		<cfset this.SetProperty("empBirthDate","")>
		<cfset this.SetProperty("empJoinDate","")>
		
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
						<cfloop index="ThisProperty" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative,CSSID,CSSClass,CallToActionURL,CategoryLocaleNameAlternative,MetaKeywords,MetaDescription,Byline1,Byline2,Title,PageTitleOverride,empFirstName,empLastName,empTitle,empPhone,empPhoneExt,empCellPhone,empImage,empImageThumb,empEmail,empBirthDate,empJoinDate,SubTitle,HomePageDisplay,EmergencyAlert,IncludeInScreenSaver">
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
		<cfset var thisCSSID = "">
		<cfset var thisCSSClass = "">
		<cfset var thisCallToActionURL = "">
		<cfset var thisCategoryLocaleNameAlternative = "">
		<cfset var thisByline1 = "">
		<cfset var thisByline2 = "">
		<cfset var thisTitle = "">
		<cfset var thisSubTitle = "">
		<cfset var thisHomePageDisplay = "">
		<cfset var thisEmergencyAlert = "">
		<cfset var thisIncludeInScreenSaver="">
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
		
		<cfset var thisEmpFirstName = "">
		<cfset var thisEmpLastName = "">
		<cfset var thisEmpTitle = "">
		<cfset var thisEmpPhone = "">
		<cfset var thisEmpPhoneExt = "">
		<cfset var thisEmpCellPhone = "">
		<cfset var thisEmpImage = "">
		<cfset var thisEmpImageThumb = "">
		<cfset var thisempEmail = "">
		<cfset var thisempBirthDate = "">
		<cfset var thisempJoinDate = "">

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
			<cfset thisCSSID=this.GetProperty("CSSID")>
			<cfset thisCSSClass=this.GetProperty("CSSClass")>
			<cfset thisCallToActionURL=this.GetProperty("CallToActionURL")>
			<cfset thisCategoryLocaleNameAlternative=this.GetProperty("CategoryLocaleNameAlternative")>
			<cfset thisByline1=this.GetProperty("Byline1")>
			<cfset thisByline2=this.GetProperty("Byline2")>
			<cfset thisTitle=this.GetProperty("Title")>
			<cfset thisSubTitle=this.GetProperty("SubTitle")>
			<cfset thisHomePageDisplay=this.GetProperty("HomePageDisplay")>
			<cfset thisEmergencyAlert=this.GetProperty("EmergencyAlert")>
			<cfset thisIncludeInScreenSaver=this.GetProperty("IncludeInScreenSaver")>
			<cfset thisPageTitleOverride=this.GetProperty("PageTitleOverride")>
			
			<cfset thisEmpFirstName=this.GetProperty("empFirstName")>
			<cfset thisEmpLastName=this.GetProperty("empLastName")>
			<cfset thisEmpTitle=this.GetProperty("empTitle")>
			<cfset thisEmpPhone=this.GetProperty("empPhone")>
			<cfset thisEmpPhoneExt=this.GetProperty("empPhoneExt")>
			<cfset thisEmpCellPhone=this.GetProperty("empCellPhone")>
			<cfset thisEmpImage=this.GetProperty("empImage")>
			<cfset thisEmpImageThumb=this.GetProperty("empImageThumb")>
			<cfset thisEmpEmail=this.GetProperty("empEmail")>
			<cfset thisEmpBirthDate=this.GetProperty("empBirthDate")>
			<cfset thisEmpJoinDate=this.GetProperty("empJoinDate")>
			

			<cfinvoke component="com.ContentManager.CategoryHandler"
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
				</cftransaction>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
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
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="CategoryLocale"
						KeyID="#thisCategoryLocaleID#"
						Operation="modify"
						EntityName="#this.GetProperty('CategoryLocaleName')#">
				</cfif>
			</cfif>

			<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
			<!--- Move files to its final resting place --->
			<cfif ARGUMENTS.WebrootPath is not "">
				<cfset ThisDestinationDirectory=this.GetResourcePath("images")>
				<cfset ThisDestinationDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##ThisDestinationDirectory#","/","\","all")>
				<cfset ThisDestinationDirectory=ReplaceNoCase("#ThisDestinationDirectory#","\\","\","all")>
				<cfloop index="ThisImage" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative,empImage,empImageThumb">
					<cfset OriginalPath=this.GetProperty("#ThisImage#")>
					<cfset Source=ExpandPath(OriginalPath)>
					<cfif FileExists(Source) and left(Source,Len(ThisDestinationDirectory)) is not ThisDestinationDirectory>
						<cfif left(OriginalPath,len("/common/incoming")) IS "/common/incoming">
							<cfset fileoperation="move">
						<cfelse>
							<cfset fileoperation="copy">
						</cfif>
						<cffile action="#fileoperation#" source="#Source#" destination="#ThisDestinationDirectory#">
						<cfset DestinationToSave="#this.GetResourcePath('images')##ListLast(OriginalPath,'/')#">
						<cfset DestinationToSave=ReplaceNoCase(DestinationToSave,"//","/","all")>
						<cfset this.SetProperty("#ThisImage#","#DestinationToSave#")>
						<cfset SetVariable("This#ThisImage#","#DestinationToSave#")>
					</cfif>
				</cfloop>
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

			<cfif FileExists("#application.utilsObj.GetPathFromURL(ThisCategoryImageOff)#")>
				<cf_ImageSize file="#application.utilsObj.GetPathFromURL(ThisCategoryImageOff)#">
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
			<cfset DevNull=StructInsert(sProperties,"CSSID","#Trim(ThisCSSID)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CSSClass","#Trim(ThisCSSClass)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CallToActionURL","#Trim(ThisCallToActionURL)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryLocaleNameAlternative","#Trim(ThisCategoryLocaleNameAlternative)#","1")>
			<cfset DevNull=StructInsert(sProperties,"Byline1","#Trim(ThisByline1)#","1")>
			<cfset DevNull=StructInsert(sProperties,"Byline2","#Trim(ThisByline2)#","1")>
			<cfset DevNull=StructInsert(sProperties,"Title","#Trim(ThisTitle)#","1")>
			<cfset DevNull=StructInsert(sProperties,"SubTitle","#Trim(ThisSubTitle)#","1")>
			<cfset DevNull=StructInsert(sProperties,"HomePageDisplay","#Trim(ThisHomePageDisplay)#","1")>
			<cfset DevNull=StructInsert(sProperties,"EmergencyAlert","#Trim(ThisEmergencyAlert)#","1")>
			<cfset DevNull=StructInsert(sProperties,"IncludeInScreenSaver","#Trim(ThisIncludeInScreenSaver)#","1")>
			<cfset DevNull=StructInsert(sProperties,"PageTitleOverride","#Trim(ThisPageTitleOverride)#","1")>
			
			<cfset DevNull=StructInsert(sProperties,"empFirstName","#Trim(thisEmpFirstName)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empLastName","#Trim(thisEmpLastName)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empTitle","#Trim(thisEmpTitle)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empPhone","#Trim(thisEmpPhone)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empPhoneExt","#Trim(thisEmpPhoneExt)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empCellPhone","#Trim(thisempCellPhone)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empImage","#Trim(thisEmpImage)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empImageThumb","#Trim(thisEmpImageThumb)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empEmail","#Trim(thisempEmail)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empBirthDate","#Trim(thisempBirthDate)#","1")>
			<cfset DevNull=StructInsert(sProperties,"empJoinDate","#Trim(thisempJoinDate)#","1")>
			
			<cfwddx action="CFML2WDDX" input="#sProperties#" output="wProperties">
			<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
				UPDATE t_Properties
				SET PropertiesPacket=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_varchar">
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
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

			<!--- <cfif this.categoryTypeid eq 81 and ListFindNoCase("empBirthDate,empJoinDate",ARGUMENTS.Property) AND ARGUMENTS.VALUE IS NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif this.categoryTypeid eq 81 and ListFindNoCase("empFirstName,empLastName,empTitle,empPhone,empEmail,empPhoneExt",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif> --->

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
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
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
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
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

		<cfinvoke component="com.ContentManager.CategoryHandler"
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

		<cfinvoke component="com.ContentManager.CategoryHandler"
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

		<cfinvoke component="com.ContentManager.CategoryHandler"
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
			<cfset UploadedFile=application.utilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)>
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
		<cfset var connectionName = APPLICATION.utilsObj.createUniqueId()>
		<cfset var ftpResult = structNew()>

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

				<cfset lImage="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative,empImage,empImageThumb">
				<cfloop index="ThisImageName" list="#lImage#">
					<cfset OriginalName=this.GetProperty(thisImageName)>
					<cfset OriginalName=ReplaceNoCase(OriginalName,"http://#CGI.Server_Name#","","All")>
					<cfset OriginalName=ReplaceNoCase(OriginalName,"//","/","All")>
					<cfset SourceFile=application.utilsObj.GetPathFromURL(OriginalName)>
					<cfif FileExists(SourceFile)>
						<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#OriginalName#','.')#",";") GT "0">
							<cffile action="MOVE" source="#SourceFile#" destination="#DestImages#">
						<cfelse>
							<cffile action="MOVE" source="#SourceFile#" destination="#DestDocs#">
						</cfif>
					</cfif>
				</cfloop>
			</cftransaction>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="CategoryID"
				KeyID="#thisCategoryID#">

			<cfif Val(ARGUMENTS.UserID) GT "0">
				<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
					UserID="#ARGUMENTS.UserID#"
					Entity="CategoryLocale"
					KeyID="#this.GetProperty('CategoryLocaleID')#"
					Operation="delete"
					EntityName="#this.GetProperty('CategoryLocaleName')#">
			</cfif>

			<cfinvoke component="com.ContentManager.CategoryHandler"
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

				<cfif SelectCategory.RecordCount GT "0">
					<cfset lImage="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative,empImage,empImageThumb">

					<!--- open the ftp connection to the production site --->
					<cfftp	action="open"
							username="#sProductionSiteInformation.ProductionFTPUserLogin#"
							password="#sProductionSiteInformation.ProductionFTPPassword#"
							server="#sProductionSiteInformation.ProductionFTPHost#"
							stoponerror="NO"
							connection="#connectionName#">

					<cfloop index="ThisImageName" list="#lImage#">
						<cfset ThisFile=this.GetProperty(thisImageName)>
						<cfif ThisFile IS NOT "">
							<cfset RemoteFile=ReplaceNoCase("#sProductionSiteInformation.ProductionFTPRootPath##ThisFile#","//","/","All")>
							RemoteFile: #RemoteFile#->
							<cfftp action="EXISTSFILE"
								stoponerror="NO"
								result="ftpResult"
								remotefile="#RemoteFile#"
								connection="#connectionName#"
								Passive="NO">
							<cfif ftpResult.returnValue IS "Yes">
								<cfftp action="REMOVE"
									stoponerror="NO"
									Passive="NO"
									item="#RemoteFile#"
									connection="#connectionName#"
									timeout="60">
								Removed!
							</cfif><BR>
						</cfif>
					</cfloop>

					<!--- close the connection --->
					<cfftp	action="close"
							stopOnError="NO"
							connection="#connectionName#">
				</cfif>
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

		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="#this.GetProperty('CategoryID')#">
		<cfif IsCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisCategoryLocaleID=this.GetProperty("CategoryLocaleID")>
			<cfset ThisCategoryID=this.GetProperty("CategoryID")>
			<cfset ThisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset ThisLocaleID=this.GetProperty("LocaleID")>

			<cfinvoke component="com.PostToProduction.postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisCategoryLocaleID#">
			     <cfinvokeargument name="columnList" value="CategoryLocaleID">
			     <cfinvokeargument name="tableName" value="t_CategoryLocale">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>

			<cfinvoke component="com.PostToProduction.postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisCategoryID#,#ThisLocaleID#">
			     <cfinvokeargument name="columnList" value="CategoryID,LocaleID">
			     <cfinvokeargument name="tableName" value="t_CategoryLocaleMeta">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>

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
				<cfinvoke component="com.ContentManager.CategoryHandler" method="CreateRemoteFolders" returnVariable="success"
					CategoryID="#ThisCategoryID#"
					FTPHost="#sProductionSiteInformation.ProductionFTPHost#"
					FTPRootPath="#sProductionSiteInformation.ProductionFTPRootPath#"
					FTPUserLogin="#sProductionSiteInformation.ProductionFTPUserLogin#"
					FTPPassword="#sProductionSiteInformation.ProductionFTPPassword#">
			</cfif>

			<cfset lImageName="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative,empImage,empImageThumb">

			<cfloop index="ThisImage" list="#lImageName#">
				<cfif this.GetProperty(ThisImage) is not "">
					<cfset Source=application.utilsObj.GetPathFromURL(this.GetProperty(ThisImage))>
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

			<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
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