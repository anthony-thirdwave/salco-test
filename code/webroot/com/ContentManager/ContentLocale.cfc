<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="ContentLocaleID" type="numeric" default="">
	<cfproperty name="ContentID" type="numeric" default="">
	<cfproperty name="ContentLocaleName" type="string" default="">
	<cfproperty name="LocaleID" type="numeric" default="">
	<cfproperty name="ContentLocaleActive" type="boolean" default="">
	<cfproperty name="PropertiesID" type="numeric" default="">
	<cfproperty name="ContentBody" type="string" default="">
	<cfproperty name="DefaultContentLocale" type="boolean" default="">
	
	<!--- Content Properties --->
	<cfproperty name="NumItems" type="numeric" default="">
	<cfproperty name="HTML" type="string" default="">
	<cfproperty name="HTMLTemplate" type="string" default="">
	<cfproperty name="Text" type="string" default="">
	<cfproperty name="SubTitle" type="string" default="">
	<cfproperty name="LinkURL" type="string" default="">
	<cfproperty name="aText" type="array" default="">
	<cfproperty name="aToken" type="array" default="">
	<cfproperty name="sHTML" type="structure" default="">
	<cfproperty name="TextPosition" type="string" default="">
	<cfproperty name="Image" type="string" default="">
	<cfproperty name="File" type="string" default="">
	<cfproperty name="FileMimeID" type="numeric" default="">
	<cfproperty name="FileSize" type="numeric" default="">
	<cfproperty name="ImageLarge" type="string" default="">
	<cfproperty name="ImageThumbnail" type="string" default="">
	<cfproperty name="Flash" type="string" default="">
	<cfproperty name="Location" type="string" default="">
	<cfproperty name="lStateProvince" type="string" default="">
	<cfproperty name="PageActionURL" type="string" default="">
	<cfproperty name="AllowMultipleRegistrations" type="boolean" default="">
	<cfproperty name="lRelatedCategoryID" type="string" default="">
	<cfproperty name="lMTCategoryIDRestrict" type="string" default="">
	<cfproperty name="lMTCategoryIDAllow" type="string" default="">
	<cfproperty name="CSSID" type="string" default="">
	<cfproperty name="CSSClass" type="string" default="">
	<cfproperty name="aLink" type="array" default="">
	<cfproperty name="ShowEventRangeID" type="numeric" default="">
	<cfproperty name="NumberOfMonths" type="numeric" default="">
	<cfproperty name="lArticleCategoryID" type="string" default="">
	
	<!--- Custom Properties  --->
	<cfproperty name="ContentAbstract" type="string" default="">
	<cfproperty name="ContentPreview" type="string" default="">
	<cfproperty name="TitleTypeID" type="numeric" default="">
	
	<cfset structInsert(sPropertyDisplayName,"ContentLocaleID","content ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentID","content ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentLocaleName","content name",1)>
	<cfset structInsert(sPropertyDisplayName,"LocaleID","locale ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentLocaleActive","content active",1)>
	<cfset structInsert(sPropertyDisplayName,"PropertiesID","properties ID",1)>
	<cfset structInsert(sPropertyDisplayName,"DefaultContentLocale","default content locale",1)>
	
	<!--- Content Properties --->
	<cfset structInsert(sPropertyDisplayName,"NumItems","number of items",1)>
	<cfset structInsert(sPropertyDisplayName,"HTML","HTML",1)>
	<cfset structInsert(sPropertyDisplayName,"HTMLTemplate","HTMLTemplate",1)>
	<cfset structInsert(sPropertyDisplayName,"SubTitle","Sub Title",1)>
	<cfset structInsert(sPropertyDisplayName,"Text","Text",1)>
	<cfset structInsert(sPropertyDisplayName,"LinkURL","LinkURL",1)>
	<cfset structInsert(sPropertyDisplayName,"aText","text array",1)>
	<cfset structInsert(sPropertyDisplayName,"aToken","token array",1)>
	<cfset structInsert(sPropertyDisplayName,"sHTML","token and html structure",1)>
	<cfset structInsert(sPropertyDisplayName,"TextPosition","text position",1)>
	<cfset structInsert(sPropertyDisplayName,"Image","Image",1)>
	<cfset structInsert(sPropertyDisplayName,"File","file",1)>
	<cfset structInsert(sPropertyDisplayName,"FileMimeID","file mime type",1)>
	<cfset structInsert(sPropertyDisplayName,"FileSize","file size",1)>
	<cfset structInsert(sPropertyDisplayName,"ImageLarge","Large Image",1)>
	<cfset structInsert(sPropertyDisplayName,"ImageThumbnail","Thumbnail Image",1)>
	<cfset structInsert(sPropertyDisplayName,"ImageRollover","Rollover Image",1)>
	<cfset structInsert(sPropertyDisplayName,"Flash","Flash",1)>
	<cfset structInsert(sPropertyDisplayName,"aFile","file list",1)>
	<cfset structInsert(sPropertyDisplayName,"Location","location",1)>
	<cfset structInsert(sPropertyDisplayName,"lStateProvince","state/province list",1)>
	<cfset structInsert(sPropertyDisplayName,"PageActionURL","page action",1)>
	<cfset structInsert(sPropertyDisplayName,"AllowMultipleRegistrations","allow registrant to register multiple persons",1)>
	<cfset structInsert(sPropertyDisplayName,"lRelatedCategoryID","related categories",1)>
	<cfset structInsert(sPropertyDisplayName,"lMTCategoryIDRestrict","restrict MT categories",1)>
	<cfset structInsert(sPropertyDisplayName,"lMTCategoryIDAllow","allow MT categories",1)>
	<cfset structInsert(sPropertyDisplayName,"CSSID","CSS ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CSSClass","CSS class",1)>
	<cfset structInsert(sPropertyDisplayName,"aLink","List of Links",1)>
	<cfset structInsert(sPropertyDisplayName,"ShowEventRangeID","show event range id",1)>
	<cfset structInsert(sPropertyDisplayName,"NumberOfMonths","Number Of Months",1)>
	<cfset structInsert(sPropertyDisplayName,"lArticleCategoryID","Article ID List",1)>
	
	<!--- Custom Properties  --->
	<cfset structInsert(sPropertyDisplayName,"ContentAbstract","content abstract",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentPreview","content preview",1)>
	<cfset structInsert(sPropertyDisplayName,"TitleTypeID","title type",1)>
	
	<cfset this.ContentTypeID="-1">
	<cfset this.ContentTemplateID="-1">
	<cfset this.ContentPositionID="-1">
	<!--- Determine field restrictions based on category type --->
	<cfset this.sFields=StructNew()>
	<cfloop index="ThisContentTypeID" list="-1,200,201,202,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,232,231,233,234,235,236,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266">
		<cfswitch expression="#ThisContentTypeID#">
			<cfcase value="209"><!--- Resource Link --->
				<cfset this.sFields[ThisContentTypeID]="">
			</cfcase>
			<cfcase value="210"><!--- Resource Version --->
				<cfset this.sFields[ThisContentTypeID]="File,FileMimeID,FileSize">
			</cfcase>
			<cfcase value="200"><!--- Text --->
				<cfset this.sFields[ThisContentTypeID]="Text">
			</cfcase>
			<cfcase value="217"><!--- Bullet --->
				<cfset this.sFields[ThisContentTypeID]="aText">
			</cfcase>
			<cfcase value="201"><!--- HTML --->
				<cfset this.sFields[ThisContentTypeID]="HTML">
			</cfcase>
			<cfcase value="232"><!--- Index of Subpages --->
				<cfset this.sFields[ThisContentTypeID]="NumItems">
			</cfcase>
			<cfcase value="202"><!--- HTML & Text --->
				<cfset this.sFields[ThisContentTypeID]="Text,HTML,TextPosition">
			</cfcase>
			<cfcase value="233"><!--- Content Template --->
				<cfset this.sFields[ThisContentTypeID]="HTMLTemplate,aToken">
			</cfcase>
			<cfcase value="234"><!--- Templatized Content--->
				<cfset this.sFields[ThisContentTypeID]="sHTML">
			</cfcase>
			<cfcase value="204"><!--- Teaser --->
				<cfset this.sFields[ThisContentTypeID]="HTML,LinkURL">
			</cfcase>
			<cfcase value="212"><!--- Image --->
				<cfset this.sFields[ThisContentTypeID]="Image,ImageThumbnail,ImageRollover,LinkURL">
			</cfcase>
			<cfcase value="218"><!--- Flash --->
				<cfset this.sFields[ThisContentTypeID]="Image,Flash,LinkURL">
			</cfcase>
			<cfcase value="222"><!--- list of files --->
				<cfset this.sFields[ThisContentTypeID]="aFile">
			</cfcase>
			<cfcase value="223"><!--- iFrame --->
				<cfset this.sFields[ThisContentTypeID]="LinkURL">
			</cfcase>
			<cfcase value="241"><!--- RSS --->
				<cfset this.sFields[ThisContentTypeID]="LinkURL,NumItems">
			</cfcase>
			<cfcase value="247"><!--- HTTP Get --->
				<cfset this.sFields[ThisContentTypeID]="LinkURL">
			</cfcase>
			<cfcase value="248"><!--- Recent Comments--->
				<cfset this.sFields[ThisContentTypeID]="NumItems">
			</cfcase>
			<cfcase value="252"><!--- Recent Discussions --->
				<cfset this.sFields[ThisContentTypeID]="NumItems,LinkURL,lMTCategoryIDRestrict,lMTCategoryIDAllow">
			</cfcase>
			<cfcase value="254"><!--- Article List (manual) --->
				<cfset this.sFields[ThisContentTypeID]="lPageID">
			</cfcase>
			
			<cfdefaultcase><!--- Default --->
				<cfset this.sFields[ThisContentTypeID]="">
			</cfdefaultcase>
		</cfswitch>
	</cfloop>
	
	<cffunction name="GetRestrictionsPropertyList" returnType="string" output="false">
		<cfset var ReturnString=this.sFields[this.GetContentTypeID()]>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="constructor" returntype="boolean" output="false">
		<cfargument name="ID" default="0" type="numeric" required="false">
		
		<!--- init variables --->
		<cfset var aBlank="">
		<cfset var sBlank="">
		<cfset var aTemp="">
		<cfset var ThisProperty="">
		<cfset var GetItems="">
		<cfset var GetContentTypeID="">
		<cfset var GetContentTypeID2="">
		<cfset var GetContentProperties="">
		<cfset var sContentBody="">
		<cfset var sProperties="">
		
		<!--- Typically, use set methods in contructor. --->
		
		<cfset this.SetProperty("ContentLocaleID","-1")>
		<cfset this.SetProperty("ContentID","-1")>
		<cfset this.SetProperty("ContentLocaleName","")>
		<cfset this.SetProperty("LocaleID","")>
		<cfset this.SetProperty("ContentLocaleActive","1")>
		<cfset this.SetProperty("PropertiesID","-1")>
		<cfset this.SetProperty("DefaultContentLocale","0")>
		
		<!--- Content Properties --->
		<cfset this.SetProperty("NumItems","")>
		<cfset this.SetProperty("HTML","")>
		<cfset this.SetProperty("HTMLTemplate","")>
		<cfset this.SetProperty("Text","")>
		<cfset this.SetProperty("SubTitle","")>
		<cfset this.SetProperty("LinkURL","")>
		
		<cfset aBlank=ArrayNew(1)>
		<cfset sBlank=StructNew()>
		<cfset this.SetProperty("aText",aBlank)>
		<cfset this.SetProperty("aToken",aBlank)>
		<cfset this.SetProperty("sHTML",sBlank)>
		<cfset this.SetProperty("TextPosition","")>
		<cfset this.SetProperty("Image","")>
		<cfset this.SetProperty("File","")>
		<cfset this.SetProperty("FileMimeID","")>
		<cfset this.SetProperty("FileSize","")>
		<cfset this.SetProperty("ImageLarge","")>
		<cfset this.SetProperty("ImageThumbnail","")>
		<cfset this.SetProperty("ImageRollover","")>
		<cfset this.SetProperty("Flash","")>
		<cfset this.SetProperty("aFile",aBlank)>
		<cfset this.SetProperty("Location","")>
		<cfset this.SetProperty("lStateProvince","")>
		<cfset this.SetProperty("PageActionURL","")>
		<cfset this.SetProperty("AllowMultipleRegistrations","0")>
		<cfset this.SetProperty("lRelatedCategoryID","-1")>
		<cfset this.SetProperty("lMTCategoryIDRestrict","")>
		<cfset this.SetProperty("lMTCategoryIDAllow","-1")>
		<cfset this.SetProperty("CSSID","")>
		<cfset this.SetProperty("CSSClass","")>
		<cfset this.SetProperty("aLink",aBlank)>
		<cfset this.SetProperty("ShowEventRangeID","8002")>
		<cfset this.SetProperty("NumberOfMonths","")>
		<cfset this.SetProperty("lArticleCategoryID","")>
		
		<!--- Custom Properties  --->
		<cfset this.SetProperty("ContentAbstract","")>
		<cfset this.SetProperty("ContentPreview","")>
		<cfset this.SetProperty("TitleTypeID","1200")>
		
		<cfif Val(ARGUMENTS.ID) GT 0>
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#" maxrows="1">
				SELECT * FROM t_ContentLocale
				WHERE ContentLocaleID=<cfqueryparam value="#Val(ARGUMENTS.ID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetItems.recordcount EQ 1>
				<cfquery name="GetContentTypeID" datasource="#APPLICATION.DSN#">
					select ContentTypeID, SourceID
					from t_Content Where ContentID=<cfqueryparam value="#Val(GetItems.ContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="GetContentTypeID2" datasource="#APPLICATION.DSN#">
					select ContentPositionID 
					from t_ContentLocaleMeta Where ContentID=<cfqueryparam value="#Val(GetItems.ContentID)#" cfsqltype="cf_sql_integer">
					and LocaleID=<cfqueryparam value="#Val(GetItems.LocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset this.ContentTypeID=GetContentTypeID.ContentTypeID>
				<cfset this.ContentTemplateID=GetContentTypeID.SourceID>
				<cfset this.ContentPositionID=GetContentTypeID2.ContentPositionID>
				<cfoutput query="GetItems">
					<cfset this.SetProperty("ContentLocaleID",ContentLocaleID)>
					<cfset this.SetProperty("ContentID",ContentID)>
					<cfset this.SetProperty("ContentLocaleName",ContentLocaleName)>
					<cfset this.SetProperty("LocaleID",LocaleID)>
					<cfset this.SetProperty("ContentLocaleActive",ContentLocaleActive)>
					<cfset this.SetProperty("PropertiesID",PropertiesID)>
					<cfset this.SetProperty("DefaultContentLocale",Val(DefaultContentLocale))>
					
					<!--- Content Properties --->
					<cfif isWDDX(ContentBody)>
						<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
						<cfloop index="ThisProperty" list="NumItems,HTML,HTMLTemplate,Text,LinkURL,aText,TextPosition,Image,ImageRollover,ImageThumbnail,File,FileMimeID,FileSize,Flash,TitleTypeID,aFile,Location,ImageLarge,aToken,sHTML,lStateProvince,PageActionURL,AllowMultipleRegistrations,lRelatedCategoryID,lMTCategoryIDRestrict,lMTCategoryIDAllow,CSSID,CSSClass,aLink,ShowEventRangeID,NumberOfMonths,lArticleCategoryID,SubTitle">
							<cfif StructKeyExists(sContentBody,"#ThisProperty#")>
								<cfset this.SetProperty("#ThisProperty#",sContentBody["#ThisProperty#"])>
							</cfif>
						</cfloop>
					</cfif>
					<!--- Custom Properties --->
					<cfquery name="GetContentProperties" datasource="#APPLICATION.DSN#">
						SELECT * FROM t_Properties WHERE PropertiesID=<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif isWDDX(GetContentProperties.PropertiesPacket)>
						<cfwddx action="WDDX2CFML" input="#GetContentProperties.PropertiesPacket#" output="sProperties">
						<cfloop index="ThisProperty" list="ContentAbstract,ContentPreview">
							<cfif StructKeyExists(sProperties,"#ThisProperty#")>
								<cfset this.SetProperty("#ThisProperty#",sProperties["#ThisProperty#"])>
							</cfif>
						</cfloop>
					</cfif>
				</cfoutput>
				
				<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"aText") and ArrayLen(this.aText) IS "0" and this.Text IS NOT "">
					<cfset aTemp=ArrayNew(1)>
					<cfset aTemp[1]=this.text>
					<cfset this.aText=Duplicate(aTemp)>
				</cfif>
				
				<cfreturn true>
			<cfelse>
				<cfreturn false>
				<!--- If id is not present, return false. --->
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="1">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">
		
		<!--- init variables --->
		<cfset var local = structNew() />
		<cfset var thisContentLocaleID="">
		<cfset var thisContentID="">
		<cfset var thisContentLocaleName="">
		<cfset var thisLocaleID="">
		<cfset var thisContentLocaleActive="">
		<cfset var thisPropertiesID="">
		<cfset var thisDefaultContentLocale="">
		<cfset var thisNumItems="">
		<cfset var thisHTML="">
		<cfset var thisHTMLTemplate="">
		<cfset var thisText="">
		<cfset var thisSubTitle="">
		<cfset var thisLinkURL="">
		<cfset var thisaText="">
		<cfset var thisaToken="">
		<cfset var thissHTML="">
		<cfset var thisTextPosition="">
		<cfset var thisImage="">
		<cfset var thisImageThumbnail="">
		<cfset var thisImageRollover="">
		<cfset var thisFile="">
		<cfset var thisFileMimeID="">
		<cfset var thisFileSize="">
		<cfset var thisImageLarge="">
		<cfset var thisFlash="">
		<cfset var thisaFile="">
		<cfset var thisLocation="">
		<cfset var thislStateProvince="">
		<cfset var thisPageActionURL="">
		<cfset var thisAllowMultipleRegistrations="">
		<cfset var thislRelatedCategoryID="">
		<cfset var thislMTCategoryIDRestrict="">
		<cfset var thislMTCategoryIDAllow="">
		<cfset var thisCSSID="">
		<cfset var thisCSSClass="">
		<cfset var thisALink="">
		<cfset var thisShowEventRangeID="">
		<cfset var thisNumberOfMonths="">
		<cfset var thislArticleCategoryID="">
		<cfset var thisContentAbstract="">
		<cfset var thisContentPreview="">
		<cfset var thisTitleTypeID="">
		<cfset var ThisFileList="">
		<cfset var DestinationDirectoryImages="">
		<cfset var DestinationDirectoryDocuments="">
		<cfset var OriginalName="">
		<cfset var SourceFile="">
		<cfset var ThisDestinationDirectory="">
		<cfset var UploadedFile="">
		<cfset var fileoperation="">
		<cfset var FileHREF="">
		<cfset var NewName="">
		<cfset var Source="">
		<cfset var DestinationToSave="">
		<cfset var sContentBody="">
		<cfset var FileToWrite="">
		<cfset var DevNull="">
		<cfset var ImageWidth="">
		<cfset var ImageHeight="">
		<cfset var sProperties="">
		<cfset var i="">
		<cfset var ThisKey="">
		<cfset var Afilei="">
		<cfset var ThisFileOfList="">
		<cfset var ThisImage2="">
		<cfset var InsertProperties="">
		<cfset var InsertContent="">
		<cfset var UpdateContent="">
		<cfset var GetOldContentBody="">
		<cfset var GetMime="">
		<cfset var GetProperties="">
		<cfset var GetLocales="">
		<cfset var TestContentLocaleMeta="">
		<cfset var TestThisContentLocaleMeta="">
		<cfset var InsertContentLocaleMeta="">
		<cfset var ThisContentName="">
		<cfset var success="">
		<cfset var ThisCategoryID="">
		<cfset var wProperties="">
			
		<cfif IsCorrect()>
			<cfset thisContentLocaleID=this.GetProperty("ContentLocaleID")>
			<cfset thisContentID=this.GetProperty("ContentID")>
			<cfset thisContentLocaleName=this.GetProperty("ContentLocaleName")>
			<cfset thisLocaleID=this.GetProperty("LocaleID")>
			<cfset thisContentLocaleActive=this.GetProperty("ContentLocaleActive")>
			<cfset thisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset thisDefaultContentLocale=this.GetProperty("DefaultContentLocale")>
			
			<!--- Content Properties --->
			<cfset thisNumItems=This.GetProperty("NumItems")>
			<cfset thisHTML=this.GetProperty("HTML")>
			<cfset thisHTMLTemplate=this.GetProperty("HTMLTemplate")>
			<cfset thisText=this.GetProperty("Text")>
			<cfset thisSubTitle=this.GetProperty("SubTitle")>
			<cfset thisLinkURL=this.GetProperty("LinkURL")>
			<cfset thisaText=this.GetProperty("aText")>
			<cfset thisaToken=this.GetProperty("aToken")>
			<cfset thissHTML=this.GetProperty("sHTML")>
			<cfset thisTextPosition=this.GetProperty("TextPosition")>
			<cfset thisImage=this.GetProperty("Image")>
			<cfset thisImageThumbnail=this.GetProperty("ImageThumbnail")>
			<cfset thisImageRollover=this.GetProperty("ImageRollover")>
			<cfset thisFile=this.GetProperty("File")>
			<cfset thisFileMimeID=this.GetProperty("FileMimeID")>
			<cfset thisFileSize=this.GetProperty("FileSize")>
			<cfset thisImageLarge=this.GetProperty("ImageLarge")>
			<cfset thisFlash=this.GetProperty("Flash")>
			<cfset thisaFile=this.GetProperty("aFile")>
			<cfset thisLocation=this.GetProperty("Location")>
			<cfset thislStateProvince=this.GetProperty("lStateProvince")>
			<cfset thisPageActionURL=this.GetProperty("PageActionURL")>
			<cfset thisAllowMultipleRegistrations=this.GetProperty("AllowMultipleRegistrations")>
			<cfset thislRelatedCategoryID=this.GetProperty("lRelatedCategoryID")>
			<cfset thislMTCategoryIDRestrict=this.GetProperty("lMTCategoryIDRestrict")>
			<cfset thislMTCategoryIDAllow=this.GetProperty("lMTCategoryIDAllow")>
			<cfset thisCSSID=this.GetProperty("CSSID")>
			<cfset thisCSSClass=this.GetProperty("CSSClass")>
			<cfset thisALink=this.GetProperty("aLink")>
			<cfset thisShowEventRangeID=this.GetProperty("ShowEventRangeID")>
			<cfset thisNumberOfMonths=this.GetProperty("NumberOfMonths")>
			<cfset thislArticleCategoryID=this.GetProperty("lArticleCategoryID")>
			
			<!--- Custom Properties --->
			<cfset thisContentAbstract=this.GetProperty("ContentAbstract")>
			<cfset thisContentPreview=this.GetProperty("ContentPreview")>
			<cfset thisTitleTypeID=this.GetProperty("TitleTypeID")>
			
			
			<cfinvoke component="com.ContentManager.ContentHandler" 
				method="GetContentName" 
				returnVariable="ThisContentName"
				ContentID="#this.GetProperty('ContentID')#">
			<cfif thisContentLocaleName IS ThisContentName>
				<cfset thisContentLocaleName="">
				<cfset this.SetProperty("ContentLocaleName","")>
			</cfif>
			
			<cfif Val(thisContentLocaleID) LTE "0">
				<cftransaction>
					<cfquery name="InsertProperties" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_Properties (PropertiesPacket)
						VALUES ('')
						SELECT NewTeaserID=@@Identity
					</cfquery>
					<cfset thisPropertiesID=InsertProperties.NewTeaserID>
					<cfset this.SetProperty("PropertiesID",InsertProperties.NewTeaserID)>
				
					<cfquery name="InsertContent" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_ContentLocale (
						ContentID,
						ContentLocaleName,
						ContentLocaleActive,
						LocaleID,
						PropertiesID,
						DefaultContentLocale
						) VALUES (
						<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#trim(ThisContentLocaleName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Val(ThisContentLocaleActive)#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Val(ThisLocaleID)#" cfsqltype="cf_sql_integer">, 
						<cfqueryparam value="#Val(ThisPropertiesID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisDefaultContentLocale)#" cfsqltype="cf_sql_bit">
						)
						SELECT NewContentLocaleID=@@Identity
					</cfquery>
					<cfset thisContentLocaleID=InsertContent.NewContentLocaleID>
					<cfset this.SetProperty("ContentLocaleID",InsertContent.NewContentLocaleID)>
					
					<cfif Val(ARGUMENTS.UserID) GT "0">
						<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
							UserID="#ARGUMENTS.UserID#"
							Entity="ContentLocale"
							KeyID="#thisContentLocaleID#"
							Operation="create"
							EntityName="#ThisContentLocaleName#">
					</cfif>
				</cftransaction>
			<cfelse>
				<cfset ThisFileList=this.GetFileList()>
				<cfif ListLen(ThisFileList,";") GT "0">
				
					<cfloop index="ThisFileOfList" list="#thisFileList#" delimiters=";">
					
						<cfset NewName=reReplaceNoCase(ThisFileOfList,"https?://#replaceNoCase(CGI.Server_Name, ".", "\.", "all")#","","All")>
						<cfset NewName=ReplaceNoCase(NewName,"//","/","All")>
						<cfset thisHTML=Replace(thisHTML,"#ThisFileOfList#","#NewName#","All")>
						<cfset thisHTMLTemplate=Replace(thisHTMLTemplate,"#ThisFileOfList#","#NewName#","All")>
						<cfset thisText=Replace(thisText,"#ThisFileOfList#","#NewName#","All")>
						<cfloop index="i" from="1" to="#ArrayLen(ThisAText)#" step="1">
							<cfset ThisAText[i]=ReplaceNoCase(ThisAText[i],"#ThisFileOfList#","#NewName#","All")>
						</cfloop>
						<cfloop index="local.ThisKey" list="#StructKeyList(ThissHTML)#">					
							<cfset ThissHTML[local.thisKey].value=ReplaceNoCase(ThissHTML[local.thisKey].value,"#ThisFileOfList#","#NewName#","All") />
						</cfloop>
					</cfloop>
				</cfif>
				<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
					UPDATE t_ContentLocale
					SET
					ContentLocaleName=<cfqueryparam value="#trim(ThisContentLocaleName)#" cfsqltype="cf_sql_varchar">,
					ContentLocaleActive=<cfqueryparam value="#Val(ThisContentLocaleActive)#" cfsqltype="cf_sql_integer">,
					LocaleID=<cfqueryparam value="#Val(ThisLocaleID)#" cfsqltype="cf_sql_integer">,
					DefaultContentLocale=<cfqueryparam value="#Val(ThisDefaultContentLocale)#" cfsqltype="cf_sql_integer">
					WHERE ContentLocaleID=<cfqueryparam value="#val(ThisContentLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="ContentLocale"
						KeyID="#thisContentLocaleID#"
						Operation="modify"
						EntityName="#ThisContentLocaleName#">
				</cfif>
			</cfif>
			
			<!--- This next routine makes sure that all associated resources are moved from /common/incoming into this 
					content locale's resource folder.
			 --->
			<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
			<cfset ThisFileList=this.GetFileList(1)>
			<cfif ListLen(ThisFileList,";") GT "0">
				<cfset DestinationDirectoryImages=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
				<cfset DestinationDirectoryImages=ReplaceNoCase(DestinationDirectoryImages,"\\","\","all")>
				<cfset DestinationDirectoryDocuments=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('documents')#","/","\","All")>
				<cfset DestinationDirectoryDocuments=ReplaceNoCase(DestinationDirectoryDocuments,"\\","\","all")>
				<cfloop index="i" from="1" to="#ListLen(ThisFileList,';')#" step="1">
					<cfset OriginalName=ListGetAt(ThisFileList,i,";")>
					<cfset OriginalName=ReplaceNoCase(OriginalName,"http://#CGI.Server_Name#","","All")>
					<cfset OriginalName=ReplaceNoCase(OriginalName,"//","/","All")>
					<cfset SourceFile="#ARGUMENTS.WebrootPath##ReplaceNoCase(OriginalName,'/','\','all')#">
					<cfset SourceFile=ReplaceNoCase(SourceFile,"\\","\","all")>
					<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#OriginalName#','.')#",";") GT "0">
						<cfset ThisDestinationDirectory="#DestinationDirectoryImages#">
					<cfelse>
						<cfset ThisDestinationDirectory="#DestinationDirectoryDocuments#">
					</cfif>
					<cfset UploadedFile="#ThisDestinationDirectory##ListLast('#SourceFile#','\')#">
					<cfif FileExists(SourceFile) AND SourceFile IS NOT UploadedFile>
						<cfif left(OriginalName,len("/common/incoming")) IS "/common/incoming">
							<cfset fileoperation="move">
						<cfelse>
							<cfset fileoperation="copy">
						</cfif>
						<cffile action="#fileoperation#" source="#SourceFile#" destination="#ThisDestinationDirectory#">
						
						<cfset FileHREF=ReplaceNoCase(UploadedFile,ARGUMENTS.WebrootPath,"/","All")>
						<cfset FileHREF=ReplaceNoCase(FileHREF,"\","/","All")>
						<cfset FileHREF=ReplaceNoCase(FileHREF,"//","/","All")>
						<cfset thisHTML=ReplaceNoCase(thisHTML,"#OriginalName#","#FileHREF#","All")>
						<cfset thisHTMLTemplate=ReplaceNoCase(thisHTMLTemplate,"#OriginalName#","#FileHREF#","All")>
						<cfset thisFile=ReplaceNoCase(thisFile,"#OriginalName#","#FileHREF#","All")>
						<cfset thisText=ReplaceNoCase(thisText,"#OriginalName#","#FileHREF#","All")>
						<cfloop index="i" from="1" to="#ArrayLen(ThisAText)#" step="1">
							<cfset ThisAText[i]=ReplaceNoCase(ThisAText[i],"#OriginalName#","#FileHREF#","All")>
						</cfloop>
						<cfloop index="ThisKey" list="#StructKeyList(ThissHTML)#">
							<cfset ThissHTML[ThisKey]=ReplaceNoCase(ThissHTML[ThisKey],"#OriginalName#","#FileHREF#","All")>
						</cfloop>
						<cfset thisImage=ReplaceNoCase(thisImage,"#OriginalName#","#FileHREF#","All")>
						<cfset thisImageLarge=ReplaceNoCase(thisImageLarge,"#OriginalName#","#FileHREF#","All")>
						<cfset thisImageThumbnail=ReplaceNoCase(thisImageThumbnail,"#OriginalName#","#FileHREF#","All")>
						<cfset thisImageRollover=ReplaceNoCase(thisImageRollover,"#OriginalName#","#FileHREF#","All")>
						<cfset thisFlash=ReplaceNoCase(thisFlash,"#OriginalName#","#FileHREF#","All")>
						<cfset thisAFile=this.GetProperty("aFile")>
						<cfif IsArray(thisAFile) and ArrayLen(thisAFile) GT "0">
							<cfloop index="Afilei" from="1" to="#ArrayLen(thisAFile)#" step="1">
								<cfset thisAFile[Afilei].FilePath=ReplaceNoCase(thisAFile[Afilei].FilePath,"#OriginalName#","#FileHREF#","All")>
							</cfloop>
						</cfif>
					</cfif>
				</cfloop>

				<cfset this.SetProperty("HTML",thisHTML)>
				<cfset this.SetProperty("HTMLTemplate",thisHTMLTemplate)>
				<cfset this.SetProperty("Text",thisText)>
				<cfset this.SetProperty("aText",ThisAText)>
				<cfset this.SetProperty("File",thisFile)>
				<cfset this.SetProperty("Image",thisImage)>
				<cfset this.SetProperty("ImageLarge",thisImageLarge)>
				<cfset this.SetProperty("ImageRollover",thisImageRollover)>
				<cfset this.SetProperty("ImageThumbnail",thisImageThumbnail)>
				<cfset this.SetProperty("Flash",thisFlash)>
				<cfset this.SetProperty("aFile",thisAFile)>
			</cfif>
			<cfloop index="ThisImage2" list="Image,Flash,ImageLarge,ImageRollover,ImageThumbnail">
				<cfset Source=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetProperty('#ThisImage2#')#","/","\","all")>
				<cfset Source=ReplaceNoCase("#Source#","\\","\","all")>
				<cfif FileExists(Source)>							
					<cffile action="MOVE" source="#Source#" destination="#DestinationDirectoryImages#">
					<cfset DestinationToSave="#this.GetResourcePath('images')##ListLast(this.GetProperty('#ThisImage2#'),'/')#">
					<cfset DestinationToSave=ReplaceNoCase(DestinationToSave,"//","/","all")>
					<cfset this.SetProperty("#ThisImage2#","#DestinationToSave#")>
					<cfset SetVariable("This#ThisImage2#","#DestinationToSave#")>
				</cfif>
			</cfloop>
			
			<cfquery name="GetOldContentBody" datasource="#APPLICATION.DSN#">
				SELECT ContentBody
				FROM t_ContentLocale
				WHERE ContentLocaleID=<cfqueryparam value="#val(ThisContentLocaleID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif isWDDX(GetOldContentBody.ContentBody)>
				<cfwddx action="WDDX2CFML" input="#GetOldContentBody.ContentBody#" output="sContentBody">
			<cfelse>
				<cfset sContentBody=StructNew()>
			</cfif>
			
			<cfif this.GetContentTypeID() IS "241" and ThisLinkURL IS NOT ""><!--- If RSS feed, fetch rss and store as file locally --->
				<cfhttp url="#LinkURL#" method="get">
				<cfset FileToWrite="#this.GetResourceFilePath('Generated',ARGUMENTS.WebrootPath)#rss_#ThisContentLocaleID#.xml">
				<cffile action="WRITE" file="#FileToWrite#" output="#CFHTTP.FileContent#" addnewline="Yes">
				<cfset ThisFile=application.utilsObj.GetURLFromPath(FileToWrite)>
			</cfif>
			
			<!--- create the thumbnail --->
			<cfif ThisImage IS NOT "" and ThisImageThumbnail IS "">
				<cfinvoke component="com.utils.Image" method="Resize" returnVariable="ThisImageThumbnail"
					WebrootPath="#ARGUMENTS.WebrootPath#"
					Source="#ThisImage#"
					Width="75">
			</cfif>
			
			<cfset structInsert(sContentBody,"NumItems","#ThisNumItems#",1)>
			<cfset structInsert(sContentBody,"HTML","#Trim(ThisHTML)#",1)>
			<cfset structInsert(sContentBody,"HTMLTemplate","#Trim(ThisHTMLTemplate)#",1)>
			<cfset structInsert(sContentBody,"Text","#Trim(ThisText)#",1)>
			<cfset structInsert(sContentBody,"SubTitle","#Trim(ThisSubTitle)#",1)>
			<cfset structInsert(sContentBody,"LinkURL","#Trim(ThisLinkURL)#",1)>
			<cfset structInsert(sContentBody,"aText",ThisAText,1)>
			<cfset structInsert(sContentBody,"aToken",ThisAToken,1)>
			<cfset structInsert(sContentBody,"sHTML",ThissHTML,1)>
			<cfset structInsert(sContentBody,"TextPosition","#Trim(ThisTextPosition)#",1)>
			<cfset structInsert(sContentBody,"Image","#Trim(ThisImage)#",1)>
			<cfset structInsert(sContentBody,"File","#Trim(ThisFile)#",1)>
			<cfset structInsert(sContentBody,"FileSize","#Trim(ThisFileSize)#",1)>
			<cfset structInsert(sContentBody,"ImageLarge","#Trim(ThisImageLarge)#",1)>
			<cfset structInsert(sContentBody,"ImageRollover","#Trim(ThisImageRollover)#",1)>
			<cfset structInsert(sContentBody,"ImageThumbnail","#Trim(ThisImageThumbnail)#",1)>
			<cfset structInsert(sContentBody,"Flash","#Trim(ThisFlash)#",1)>
			<cfset structInsert(sContentBody,"TitleTypeID","#Trim(ThisTitleTypeID)#",1)>
			
			<cfset structInsert(sContentBody,"Location","#Trim(ThisLocation)#",1)>
			<cfset structInsert(sContentBody,"lStateProvince","#Trim(ThislStateProvince)#",1)>
			<cfset structInsert(sContentBody,"PageActionURL","#Trim(ThisPageActionURL)#",1)>
			<cfset structInsert(sContentBody,"AllowMultipleRegistrations","#val(ThisAllowMultipleRegistrations)#",1)>
			<cfset structInsert(sContentBody,"lRelatedCategoryID","#val(ThislRelatedCategoryID)#",1)>
			<cfset structInsert(sContentBody,"lMTCategoryIDRestrict","#ThislMTCategoryIDRestrict#",1)>
			<cfset structInsert(sContentBody,"lMTCategoryIDAllow","#ThislMTCategoryIDAllow#",1)>
			<cfset structInsert(sContentBody,"CSSID","#Trim(ThisCSSID)#",1)>
			<cfset structInsert(sContentBody,"CSSClass","#Trim(ThisCSSClass)#",1)>
			<cfset structInsert(sContentBody,"aLink",ThisALink,1)>
			<cfset structInsert(sContentBody,"ShowEventRangeID","#val(ThisShowEventRangeID)#",1)>
			<cfset structInsert(sContentBody,"NumberOfMonths","#Trim(ThisNumberOfMonths)#",1)>
			<cfset structInsert(sContentBody,"lArticleCategoryID","#Trim(ThislArticleCategoryID)#",1)>
			
			<cfquery name="GetMime" datasource="#APPLICATION.DSN#">
				select MimeID from qry_GetMime Where MimeExtension=<cfqueryparam value="#Trim(ListLast(ThisFile,"."))#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif GetMime.RecordCount IS "1">
				<cfset structInsert(sContentBody,"FileMimeID","#Trim(GetMime.MimeID)#",1)>
			<cfelse>
				<cfset structInsert(sContentBody,"FileMimeID","",1)>
			</cfif>
			
			<cfset structInsert(sContentBody,"File","#Trim(ThisFile)#",1)>
			<cfif IsArray(thisAFile) and ArrayLen(thisAFile) GT "0">
				<cfloop index="Afilei" from="1" to="#ArrayLen(thisAFile)#" step="1">
					<cfif left(thisAFile[Afilei].FilePath,Len("/common/incoming")) iS "/common/incoming">
						<cffile action="MOVE" source="#application.utilsObj.GetPathFromURL(thisAFile[Afilei].FilePath)#" destination="#this.GetResourceFilePath('documents',ARGUMENTS.WebrootPath)#">
						<cfset thisAFile[Afilei].FilePath=application.utilsObj.GetURLFromPath("#this.GetResourceFilePath('documents',ARGUMENTS.WebrootPath)##ListLast(thisAFile[Afilei].FilePath,'/')#")>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfset structInsert(sContentBody,"aFile",ThisaFile,1)>

			<cfset DevNull=StructInsert(sContentBody,"ImageWidth","","1")>
			<cfset DevNull=StructInsert(sContentBody,"ImageHeight","","1")>			
			<cfif FileExists("#application.utilsObj.GetPathFromURL(ThisImage)#")>
				<cf_ImageSize file="#application.utilsObj.GetPathFromURL(ThisImage)#">
				<cfif IsDefined("Width")>
					<cfset ImageWidth=Width>
					<cfset ImageHeight=Height>
					<cfset DevNull=StructInsert(sContentBody,"ImageWidth","#val(ImageWidth)#","1")>
					<cfset DevNull=StructInsert(sContentBody,"ImageHeight","#val(ImageHeight)#","1")>
				</cfif>
			</cfif>
			
			<cfwddx action="CFML2WDDX" input="#sContentBody#" output="wProperties">
			<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
				UPDATE t_ContentLocale
				SET ContentBody=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_varchar">
				WHERE ContentLocaleID=<cfqueryparam value="#val(ThisContentLocaleID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			
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

			<cfset DevNull=StructInsert(sProperties,"ContentAbstract","#Trim(ThisContentAbstract)#",1)>
			<cfset DevNull=StructInsert(sProperties,"ContentPreview","#this.SetPreview()#",1)>
			
			<cfwddx action="CFML2WDDX" input="#sProperties#" output="wProperties">
			<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
				UPDATE t_Properties
				SET PropertiesPacket=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_varchar">
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
				select * from t_locale
			</cfquery>
			
			<cfquery name="TestContentLocaleMeta" datasource="#APPLICATION.DSN#">
				select * from t_ContentLocaleMeta 
				Where ContentID=<cfqueryparam value="#val(ThisContentID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif GetLocales.RecordCount IS NOT TestContentLocaleMeta.RecordCount>
				<cfinvoke component="com.ContentManager.ContentHandler" method="GetCategoryID" returnVariable="ThisCategoryID"
					ContentID="#ThisContentID#">
				<cfoutput query="GetLocales">
					<cfquery name="TestThisContentLocaleMeta" datasource="#APPLICATION.DSN#">
						SELECT	contentID
						FROM	t_ContentLocaleMeta
						WHERE	ContentID=<cfqueryparam value="#val(ThisContentID)#" cfsqltype="cf_sql_integer">
						AND		LocaleID=<cfqueryparam value="#val(GetLocales.LocaleID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif TestThisContentLocaleMeta.RecordCount IS "0">
						<!--- Get the top priority for this category --->
						<cfquery name="TestThisContentLocaleMeta" datasource="#APPLICATION.DSN#">
							SELECT 	MAX(cm.ContentLocalePriority) AS nextPriority
							FROM	t_ContentLocaleMeta cm
							INNER JOIN	t_content c ON c.contentID=cm.contentID
							WHERE	c.CategoryID=<cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
							AND		cm.LocaleID=<cfqueryparam value="#val(GetLocales.LocaleID)#" cfsqltype="cf_sql_integer">
							AND		cm.contentPositionID=<cfqueryparam cfsqltype="cf_sql_integer" value="#this.ContentPositionID#">
						</cfquery>
						<cfquery name="InsertContentLocaleMeta" datasource="#APPLICATION.DSN#">
							INSERT INTO t_ContentLocaleMeta
							(ContentID,LocaleID,ContentLocalePriority,contentPositionID)
							VALUES
							(<cfqueryparam value="#val(ThisContentID)#" cfsqltype="cf_sql_integer">, 
							 <cfqueryparam value="#val(LocaleID)#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#val(Val(TestThisContentLocaleMeta.nextPriority)+10)#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#val(this.ContentPositionID)#" cfsqltype="cf_sql_integer">
							)
						</cfquery>
					</cfif>
				</cfoutput>
			</cfif>
			
			<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Content"
				KeyID="#thisContentID#">
				
			<!---- HERE WE NEED TO CALL THE VERITY UPDATER 
			HOLDING OFF DUE TO ERROR --->
			
			<cfif 0>
				<cfif GetContentPositionID() IS NOT "403"><!--- If not a temp content --->
					<cfmodule template="/common/modules/contentManager/UpdateVerity.cfm"
						ContentID="#thisContentID#"
						ContentLocaleID="#val(ThisContentLocaleID)#"
						LocaleID="#Val(ThisLocaleID)#">
				</cfif>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="SetProperty" returntype="boolean" output="false">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">
		
		<!--- init variables --->
		<cfset var Test="">
		
		<cfset ARGUMENTS.Property=Trim(ARGUMENTS.Property)>
				
		<cfif IsSimpleValue(ARGUMENTS.Value)>
			<cfset ARGUMENTS.Value=Trim(ARGUMENTS.Value)>

			<cfif ListFindNoCase("ContentLocaleID,ContentID,PropertiesID,LocaleID,NumItems,NumberOfMonths",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
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
			
			<cfif ListFindNoCase("",ARGUMENTS.Property) AND ARGUMENTS.VALUE IS NOT "">
				<cfset ARGUMENTS.VALUE=lcase(ReReplace(ARGUMENTS.VALUE,"[’\!'/:"".;?&<>|,]","","all"))>
				<cfset ARGUMENTS.VALUE=lcase(ReReplace(ARGUMENTS.VALUE,"[ ]"," ","all"))>
			</cfif>
			
			<cfif ListFindNoCase("HTML",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfif StructKeyExists(this,"ContentTypeID") and ListFindNoCase("235,201",this.ContentTypeID)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter #sPropertyDisplayName[ARGUMENTS.Property]#.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("Text",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfif StructKeyExists(this,"ContentTypeID") and ListFindNoCase("200",this.ContentTypeID)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter #sPropertyDisplayName[ARGUMENTS.Property]#.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("LocaleID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("ContentLocaleName",ARGUMENTS.Property)>
				<cfif Len(ARGUMENTS.Value) GT "1000">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 128 characters long.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("Text",ARGUMENTS.Property)>
				<cfset ARGUMENTS.Value="#ARGUMENTS.Value#">
			</cfif>
			
			<cfif ListFindNoCase("HTMLTemplate",ARGUMENTS.Property)>
				<!--- This routine needs work. --->
				<!--- <cfset this.TokenCount=GetTokenCount()> --->
			</cfif>
			
			<cfif ListFindNoCase("ContentID,LocaleID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="ContentID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Content">
								<cfinvokeargument name="FieldName" value="ContentID">
								<cfinvokeargument name="FieldValue" value="#Val(ARGUMENTS.Value)#">
								<cfinvokeargument name="SortFieldName" value="ContentID">
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
						<cfcase value="TitleTypeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="170,#ARGUMENTS.Value#">
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
		
		<cfset SetVariable("this.#ARGUMENTS.Property#",ARGUMENTS.Value)>
		<cfset deleteError(ARGUMENTS.Property)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetProperty" returntype="Any" output="false">
		<cfargument name="Property" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue="">
		
		<cfif IsInError(ARGUMENTS.Property)>
			<cfreturn GetErrorValue(ARGUMENTS.Property)>
		<cfelse>
			<cfset ReturnValue=this["#ARGUMENTS.Property#"]>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>
	
	<cffunction name="SetPreview" returntype="string" output="1">
		
		<!--- init variables --->
		<cfset var ReturnString="">
		<cfset var aText="">
		<cfset var sHTML="">
		<cfset var ThisContentID="">
		<cfset var rit="">
		<cfset var ThisKey="">
		<cfset var GetContent="">
		
		<cfswitch expression="#this.GetContentTypeID()#">
			<cfcase value="200"><!--- Text --->
				<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('Text'))#">
			</cfcase>
			<cfcase value="201"><!--- HTML --->
				<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('HTML'))#">
			</cfcase>
			<cfcase value="202"><!--- HTML & Text --->
				<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('Text'))#">
			</cfcase>
			<cfcase value="217"><!--- Bullet List --->
				<cfif ArrayLen(this.GetProperty("aText")) GT "0">
					<cfset aText=this.GetProperty("aText")>
					<cfloop index="rit" from="1" to="#ArrayLen(aText)#">
						<cfset ReturnString="#ReturnString# #application.utilsObj.RemoveHTML(aText[rit])#">
					</cfloop>
				</cfif>
			</cfcase>
			<cfcase value="234"><!--- Templatized Content --->
				<cfif len(trim(structKeyList(this.GetProperty("sHTML"))))>
					<cfset sHTML=this.GetProperty("sHTML")>
					<cfloop index="ThisKey" list="#StructKeyList(sHTML)#">
						<cfif isStruct(sHTML[ThisKey])>
							<cfif sHTML[ThisKey].type neq "image">
								<cfset ReturnString="#ReturnString# #application.utilsObj.RemoveHTML(sHTML[ThisKey].value)#">
							</cfif>
						<cfelse>
							<cfset ReturnString="#ReturnString# #application.utilsObj.RemoveHTML(sHTML[ThisKey])#">
						</cfif>
					</cfloop>
				</cfif>
			</cfcase>
			<cfcase value="204"><!--- Teaser --->
				<cfset ReturnString="">
			</cfcase>
			<cfcase value="212"><!--- Image --->
				<cfset ReturnString="">
			</cfcase>
			<cfcase value="221"><!--- News Item --->
				<cfset ThisContentID=this.GetProperty("ContentID")>
				<cfquery name="GetContent" datasource="#APPLICATION.DSN#">
					select ContentDate1 from t_Content Where ContentID=#Val(ThisContentID)#
				</cfquery>
				<cfset ReturnString="#DateFormat(GetContent.ContentDate1)# - #application.utilsObj.RemoveHTML(this.GetProperty('Text'))#">
			</cfcase>
			<cfcase value="235"><!--- News Item --->
				<cfif application.utilsObj.RemoveHTML(this.GetProperty("ContentAbstract")) IS NOT "">
					<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('ContentAbstract'))#">
				<cfelse>
					<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('HTML'))#">
				</cfif>
				
				<cfset ThisContentID=this.GetProperty("ContentID")>
				<cfquery name="GetContent" datasource="#APPLICATION.DSN#">
					select ContentDate1 from t_Content Where ContentID=#Val(ThisContentID)#
				</cfquery>
				<cfset ReturnString="#DateFormat(GetContent.ContentDate1)# - #ReturnString#">
			</cfcase>
			<cfdefaultcase><!--- Default --->
				<cfif application.utilsObj.RemoveHTML(this.GetProperty("ContentAbstract")) IS NOT "">
					<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('ContentAbstract'))#">
				<cfelse>
					<cfset ReturnString="#application.utilsObj.RemoveHTML(this.GetProperty('HTML'))#">
				</cfif>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetContentTypeID" returntype="numeric" output="false">
		<cfreturn this.ContentTypeID>
	</cffunction>
	
	<cffunction name="SetContentTypeID" returntype="boolean" output="false">
		<cfargument name="NewContentTypeID" required="true">
		<cfset this.ContentTypeID=ARGUMENTS.NewContentTypeID>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetContentPositionID" returntype="numeric" output="false">
		<cfreturn this.ContentPositionID>
	</cffunction>
	
	<cffunction name="SetContentPositionID" returntype="boolean" output="false">
		<cfargument name="NewContentPositionID" required="true">
		<cfset this.ContentPositionID=ARGUMENTS.NewContentPositionID>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetContentTemplateID" returntype="numeric" output="false">
		<cfreturn this.ContentTemplateID>
	</cffunction>
	
	<cffunction name="SetContentTemplateID" returntype="boolean" output="false">
		<cfargument name="NewContentTemplateID" required="true">
		<cfset this.ContentTemplateID=ARGUMENTS.NewContentTemplateID>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="InitializeHTMLStructure" returntype="boolean" output="false">
		<cfset var local = structNew() />
		<cfset local.ThisTokenList=GetTokenList() />
		<cfset local.ThissHTML=this.getProperty("sHTML") />
		
		<cfloop index="local.ThisToken" list="#local.ThisTokenList#">
			
			<!--- get the token name and type --->
			<cfset local.ThisTokenName = getToken(local.ThisToken, 1, ":") />
			<cfset local.ThisTokenType = getToken(local.ThisToken, 2, ":") />
			
			<!--- if there's not a type defined, default to rich text --->
			<cfif not len(trim(local.ThisTokenType))>
				<cfset local.ThisTokenType = "rich" />
			</cfif>
			
			<cfif not structKeyExists(local.ThissHTML,local.ThisTokenName)>
				<cfset local.ThissHTML[local.ThisTokenName] = structNew() />
				<cfset local.ThissHTML[local.ThisTokenName].value = "" />
				<cfset local.ThissHTML[local.ThisTokenName].type = local.ThisTokenType />
			</cfif>
		</cfloop>
		<cfset this.SetProperty("sHTML",local.ThissHTML)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetTokenList" returntype="String" output="false">
		
		<!--- init variables --->
		<cfset var local = structNew() />
		
		<cfinvoke component="com.ContentManager.ContentHandler" 
			method="GetTokenList" 
			returnVariable="local.ThisTokenList"
			ContentID="#Val(GetContentTemplateID())#"
			LocaleID="#Val(this.GetProperty('LocaleID'))#">
		<cfreturn local.ThisTokenList>
	</cffunction>
	
	<cffunction name="GetFileList" returntype="string" output="false">
		<cfargument name="AllProperties" required="false">
		
		<cfset var local = structNew() />
		<cfset local.stringToTest = "" />
		<cfset local.finalList = "" />

		<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"HTML")>
			<cfset local.stringToTest = this.GetProperty('HTML') />
		</cfif>
		<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"HTMLTemplate")>
			<cfset local.stringToTest="#local.stringToTest# #this.GetProperty('HTMLTemplate')#" />
		</cfif>
		<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"aText")>
			<cfset local.ThisAText=this.GetProperty("aText") />
			<cfloop index="local.atexti" from="1" to="#ArrayLen(local.ThisAText)#" step="1">
				<cfset local.stringToTest="#local.stringToTest# #local.ThisAText[local.atexti]#" />
			</cfloop>
		</cfif>
		<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"sHTML")>
			<cfset local.ThissHTML = this.GetProperty("sHTML") />
			<cfloop index="local.ThisKey" list="#StructKeyList(local.ThissHTML)#">
				<cfif isStruct(local.ThissHTML[local.ThisKey])>
					<cfset local.stringToTest="#local.stringToTest# #local.ThissHTML[local.ThisKey].value#" />
					<cfset local.stringToTest="#local.stringToTest# #local.ThissHTML[local.ThisKey].type#" />
				<cfelse>
					<cfset local.stringToTest="#local.stringToTest# #local.ThissHTML[local.ThisKey]#" />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"Text")>
			<cfset local.stringToTest="#local.stringToTest# #this.GetProperty('Text')#">
		</cfif>
		<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"File")>
			<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('File')#"">">
		</cfif>
		
		<cfif IsDefined("ARGUMENTS.AllProperties") AND ARGUMENTS.AllProperties>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"Image")>
				<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('image')#"">">
			</cfif>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"File")>
				<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('File')#"">">
			</cfif>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"ImageLarge")>
				<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('ImageLarge')#"">">
			</cfif>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"ImageRollover")>
				<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('ImageRollover')#"">">
			</cfif>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"ImageThumbnail")>
				<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('ImageThumbnail')#"">">
			</cfif>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"flash")>
				<cfset local.stringToTest="#local.stringToTest# <img src=""#this.GetProperty('flash')#"">">
			</cfif>
			<cfif ListFindNoCase(this.GetRestrictionsPropertyList(),"aFile")>
				<cfset local.thisAFile=this.GetProperty("aFile")>
				<cfif IsArray(thisAFile) and ArrayLen(thisAFile) GT "0">
					<cfloop index="local.Afilei" from="1" to="#ArrayLen(local.thisAFile)#" step="1">
						<cfset local.stringToTest="#local.stringToTest# <a href=""#local.thisAFile[local.Afilei].FilePath#"">">
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		
		<!--- get the list of files with issues in this object --->
		<cfinvoke method="parseTemplateValue" returnvariable="local.fileList">
			<cfinvokeargument name="string" value="#local.stringToTest#" />
			<cfinvokeargument name="detectLocalHTTPImages" value="true" />
		</cfinvoke>

		<cfloop index="local.thisFile2" list="#local.fileList#" delimiters=";">
			<cfif left(local.thisFile2, len("/common/images")) neq "/common/images">
				<cfset local.finalList = ListAppend(local.finalList, local.thisFile2, ";") />
			</cfif>
		</cfloop>
		<cfreturn local.finalList>
	</cffunction>
	
	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue="">
		
		<cfinvoke component="com.ContentManager.ContentHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			ContentID="#this.GetProperty('ContentID')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue="">
		
		<cfinvoke component="com.ContentManager.ContentHandler"
			method="GetResourcePath"
			returnVariable="ReturnValue"
			ContentID="#this.GetProperty('ContentID')#"
			ResourceType="#ARGUMENTS.ResourceType#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue="">
		
		<cfinvoke component="com.ContentManager.ContentHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			ContentID="#this.GetProperty('ContentID')#"
			ResourceType="#ARGUMENTS.ResourceType#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="FormFileListUpload" returntype="boolean" output="false">
		<cfargument name="FormFileFieldName" required="true">
		<cfargument name="WebrootPath" required="true">
		
		<!--- init variables --->
		<cfset var ThisFileList=this.GetFileList()>
		<cfset var UploadDirectory="">
		<cfset var DestinationDirectoryImages="">
		<cfset var DestinationDirectoryDocuments="">
		<cfset var OriginalName="">
		<cfset var UploadedFile="">
		<cfset var FileHREF="">
		<cfset var thisaText="">
		<cfset var ThissHTML="">
		<cfset var i="">
		<cfset var ThisKey="">
		
		<cfif ARGUMENTS.FormFileFieldName IS "" OR ARGUMENTS.WebrootPath IS "" OR ListLen(ThisFileList,";") LTE "0">
			<cfreturn false>
		<cfelse>
			<cfset UploadDirectory="#ARGUMENTS.WebrootPath#common\incoming\">
			<cfif Val(GetProperty("ContentID")) LTE "0">
				<cfset DestinationDirectoryImages="#ARGUMENTS.WebrootPath#common\incoming\">
				<cfset DestinationDirectoryDocuments="#ARGUMENTS.WebrootPath#common\incoming\">
			<cfelse>
				<cfset DestinationDirectoryImages=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
				<cfset DestinationDirectoryImages=ReplaceNoCase(DestinationDirectoryImages,"\\","\","all")>
				<cfset DestinationDirectoryDocuments=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('documents')#","/","\","All")>
				<cfset DestinationDirectoryDocuments=ReplaceNoCase(DestinationDirectoryDocuments,"\\","\","all")>
				<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
			</cfif>
			<cfloop index="i" from="1" to="#ListLen(ThisFileList,';')#" step="1">
				<cfset OriginalName=Trim(ListGetAt(ThisFileList,i,";"))>
				<cfif IsDefined("#ARGUMENTS.FormFileFieldName##i#FileObject") AND Evaluate("#ARGUMENTS.FormFileFieldName##i#FileObject") IS NOT "">
					<cffile action="UPLOAD" 
						filefield="#ARGUMENTS.FormFileFieldName##i#FileObject"
						destination="#UploadDirectory#"
						nameconflict="MakeUnique">
					<cfset UploadedFile=File.ServerDirectory & "\" & File.ServerFile>
					<cfif Val(GetProperty("ContentLocaleID")) LTE "0">
						<!--- Keep files where they are, since we havent assigned an ID yet. --->
					<cfelse>
						<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#OriginalName#','.')#",";") GT "0">
							<cffile action="MOVE" source="#UploadedFile#" destination="#DestinationDirectoryImages#">
							<cfset UploadedFile="#DestinationDirectoryImages##ListLast('#UploadedFile#','\')#">
						<cfelse>
							<cffile action="MOVE" source="#UploadedFile#" destination="#DestinationDirectoryDocuments#">
							<cfset UploadedFile="#DestinationDirectoryDocuments##ListLast('#UploadedFile#','\')#">
						</cfif>
					</cfif>
					<cfset FileHREF=ReplaceNoCase(UploadedFile,ARGUMENTS.WebrootPath,"/","All")>
					<cfset FileHREF=ReplaceNoCase(FileHREF,"\","/","All")>
					<cfset FileHREF=ReplaceNoCase(FileHREF,"//","/","All")>
					<cfset this.SetProperty("HTML",ReplaceNoCase(this.GetProperty("HTML"),"#OriginalName#","#FileHREF#","All"))>
					<cfset this.SetProperty("HTMLTemplate",ReplaceNoCase(this.GetProperty("HTMLTemplate"),"#OriginalName#","#FileHREF#","All"))>
					<cfset this.SetProperty("Text",ReplaceNoCase(this.GetProperty("Text"),"#OriginalName#","#FileHREF#","All"))>
					<cfset thisaText=this.GetProperty("aText")>
					<cfloop index="i" from="1" to="#ArrayLen(ThisAText)#" step="1">
						<cfset ThisAText[i]=ReplaceNoCase(ThisAText[i],"#OriginalName#","#FileHREF#","All")>
					</cfloop>
					<cfset This.SetProperty("aText",ThisAText)>
					<cfset ThissHTML=this.GetProperty("sHTML")>
					<cfloop index="ThisKey" list="#StructKeyList(ThissHTML)#">
						<cfset ThissHTML[ThisKey]=ReplaceNoCase(ThissHTML[ThisKey],"#OriginalName#","#FileHREF#","All")>
					</cfloop>
					<cfset This.SetProperty("sHTML",ThissHTML)>
				</cfif>
			</cfloop>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="FormFileUpload" returntype="boolean" output="false">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">
		<cfargument name="FormFileFieldName" required="true">
		
		<!--- init variables --->
		<cfset var UploadDirectory="">
		<cfset var UploadedFile="">
		<cfset var ThisFileSize="">
		<cfset var ThisDestDir="">
		<cfset var ThisUploadedFile="">
		<cfset var thisExt="">
		<cfset var ThisFilePart="">
		<cfset var FinalDest="">
		<cfset var FilePath="">
		<cfset var GetMime="">
		
		<cfif ARGUMENTS.FormFileFieldName IS "" OR ARGUMENTS.WebrootPath IS "" OR ARGUMENTS.Property IS "">
			<cfreturn false>
		<cfelseif ListFindNoCase(StructkeyList(this),ARGUMENTS.Property) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfif Val(GetProperty("ContentID")) LTE "0">
				<cfset UploadDirectory="#ARGUMENTS.WebrootPath#common\incoming\">
			<cfelse>
				<cfif ARGUMENTS.Property IS "Flash">
					<cfset UploadDirectory="#ARGUMENTS.WebrootPath##APPLICATION.FlashPath#">
				<cfelseif ARGUMENTS.Property IS "File">
					<cfset UploadDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('Documents')#","/","\","All")>
					<cfset UploadDirectory=ReplaceNoCase(UploadDirectory,"\\","\","all")>
					<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
				<cfelse>
					<cfset UploadDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
					<cfset UploadDirectory=ReplaceNoCase(UploadDirectory,"\\","\","all")>
					<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
				</cfif>
			</cfif>
			<cffile action="UPLOAD" 
				filefield="#ARGUMENTS.FormFileFieldName#"
				destination="#UploadDirectory#"
				nameconflict="MakeUnique">
			<cfset UploadedFile=File.ServerDirectory & "\" & File.ServerFile>
			<cfset ThisFileSize=File.FileSize>
			<cfif ARGUMENTS.Property IS "Flash" and ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
				<cffile action="DELETE" file="#UploadedFile#">
				<cfset SetProperty("#ARGUMENTS.Property#","")>
				<cfset AddError(ARGUMENTS.Property,"","The #sPropertyDisplayName[ARGUMENTS.Property]# must be a .swf file.")>
				<cfreturn false>
			<cfelseif ARGUMENTS.Property IS "file">
				<!--- File can be of any recognizable type --->
				<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";")>
					<!--- If file is an image then move to images folder --->
					<cfset ThisDestDir=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
					<cfset ThisDestDir=ReplaceNoCase(UploadDirectory,"\\","\","all")>
					<cfif FileExists("#ThisDestDir##ListLast('#UploadedFile#','\')#")>
						<cfset ThisUploadedFile="#ListLast('#UploadedFile#','\')#">
						<cfset thisExt=ListLast(ThisUploadedFile,".")>
						<cfset ThisFilePart=ListDeleteAt(ThisUploadedFile,ListLen(ThisUploadedFile,"."),".")>
						<cfif IsNumeric(ListLast(ThisFilePart,"_"))>
							<cfset ThisFilePart="#ThisFilePart#_#IncrementValue(ListLast(ThisFilePart,'_'))#">
						<cfelse>
							<cfset ThisFilePart="#ThisFilePart#_1">
						</cfif>
						<cfset FinalDest="#ThisDestDir##ThisFilePart#.#thisExt#">
					<cfelse>
						<cfset FinalDest="#ThisDestDir##ListLast('#UploadedFile#','\')#">
					</cfif>
					<cfset UploadedFile=FinalDest>
				</cfif>
			<cfelseif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
				<cffile action="DELETE" file="#UploadedFile#">
				<cfset SetProperty("#ARGUMENTS.Property#","")>
				<cfset AddError(ARGUMENTS.Property,"","The #sPropertyDisplayName[ARGUMENTS.Property]# must be an image file.")>
				<cfreturn false>
			</cfif>
			<cfset FilePath=ReplaceNoCase(UploadedFile,ARGUMENTS.WebrootPath,"/","All")>
			<cfset FilePath=ReplaceNoCase(FilePath,"\","/","All")>
			<cfset FilePath=ReplaceNoCase(FilePath,"//","/","All")>
			<cfset SetProperty("#ARGUMENTS.Property#","#FilePath#")>
			<cfif ARGUMENTS.Property IS "File">
				<cfset SetProperty("FileSize",ThisFileSize)>
				<cfquery name="GetMime" datasource="#APPLICATION.DSN#">
					select MimeID from qry_GetMime Where MimeExtension=<cfqueryparam value="#Trim(ListLast(FilePath,"."))#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif GetMime.RecordCount IS "1">
					<cfset SetProperty("FileMimeID",GetMime.MimeID)>
				</cfif>
			</cfif>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="FileRemove" returnType="boolean" output="false">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">
		
		<!--- init variables --->
		<cfset var FileToDelete="">
		
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
	
	<cffunction name="GetDisplayTemplateTypeName" returnType="String" output="false">
		<cfset var ReturnString="">
		<cfset var Test="">
		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Label">
			<cfinvokeargument name="FieldName" value="LabelID">
			<cfinvokeargument name="FieldValue" value="#this.GetProperty('LocaleID')#">
		</cfinvoke>
		<cfset ReturnString="#ValueList(Test.LabelName)#">
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="Delete" returnType="boolean" output="1">
		<cfargument name="TrashPath" required="true">
		<cfargument name="UserID" required="true">
		
		<!--- init variables --->
		<cfset var ThisFileList="">
		<cfset var ThisContentLocaleID="">
		<cfset var ThisContentID="">
		<cfset var ThisLocaleID="">
		<cfset var DirDone="">
		<cfset var DirectoryToCreate="">
		<cfset var DestImages="">
		<cfset var DestDocs="">
		<cfset var OriginalName="">
		<cfset var SourceFile="">
		<cfset var RemoteFile="">
		<cfset var i="">
		<cfset var ThisFile="">
		<cfset var SelectProps="">
		<cfset var deleteContent1="">
		<cfset var deleteContent3="">
		<cfset var SelectContentFromProd="">
		<cfset var DeleteContent="">
		<cfset var DeleteContentProps="">
		<cfset var success="">
		<cfset var ThisCategoryID="">
		<cfset var sProductionSiteInformation="">
		
		<cfif ARGUMENTS.TrashPath IS NOT "" and this.GetProperty("ContentLocaleID") GT "0">
			<cftransaction>
				<cfset ThisFileList=this.GetFileList()>
				<cfset ThisContentLocaleID=this.GetProperty("ContentLocaleID")>
				<cfset ThisContentID=this.GetProperty("ContentID")>
				<cfset ThisLocaleID=this.GetProperty("LocaleID")>
				<cfquery name="SelectProps" datasource="#APPLICATION.DSN#">
					SELECT PropertiesID FROM t_ContentLocale WHERE ContentLocaleID=<cfqueryparam value="#ThisContentLocaleID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent1" datasource="#APPLICATION.DSN#">
					DELETE FROM t_ContentLocale WHERE ContentLocaleID=<cfqueryparam value="#val(ThisContentLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent3" datasource="#APPLICATION.DSN#">
					DELETE FROM t_properties WHERE PropertiesID=<cfqueryparam value="#Val(SelectProps.PropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset DirDone="">
				<cfloop index="i" from="1" to="#Len(ThisContentID)#" step="1">
					<cfset DirectoryToCreate="#ARGUMENTS.TrashPath##APPLICATION.ContentResourcesPath##DirDone##Mid(ThisContentID,i,1)#">
					<cfset DirDone="#DirDone##Mid(ThisContentID,i,1)#\">
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
				<cfloop index="i" from="1" to="#Len(ThisContentID)#" step="1">
					<cfset DirectoryToCreate="#APPLICATION.WebRootPath##APPLICATION.ContentResourcesPath##DirDone##Mid(ThisContentID,i,1)#">
					<cfset DirDone="#DirDone##Mid(ThisContentID,i,1)#\">
				</cfloop>
				
				<cfif 0>
					<cfif ListLen(ThisFileList,";") GT "0">
						<cfloop index="i" from="1" to="#ListLen(ThisFileList,';')#" step="1">
							<cfset OriginalName=ListGetAt(ThisFileList,i,";")>
							<cfset OriginalName=ReplaceNoCase(OriginalName,"http://#CGI.Server_Name#","","All")>
							<cfset OriginalName=ReplaceNoCase(OriginalName,"//","/","All")>
							<cfset SourceFile="#APPLICATION.WebrootPath##ReplaceNoCase(OriginalName,'/','\','all')#">
							<cfset SourceFile=ReplaceNoCase(SourceFile,"\\","\","all")>
							<cfif FileExists(SourceFile)>
								<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#OriginalName#','.')#",";") GT "0">
									<cffile action="MOVE" source="#SourceFile#" destination="#DestImages#">
								<cfelse>
									<cffile action="MOVE" source="#SourceFile#" destination="#DestDocs#">
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cftransaction>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Content"
				KeyID="#thisContentID#">
			
			<cfif Val(ARGUMENTS.UserID) GT "0">
				<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
					UserID="#ARGUMENTS.UserID#"
					Entity="ContentLocale"
					KeyID="#this.GetProperty('ContentLocaleID')#"
					Operation="delete"
					EntityName="#this.GetProperty('ContentLocaleName')#">
			</cfif>
			
			<cfinvoke component="com.ContentManager.ContentHandler" 
				method="GetCategoryID"
				returnVariable="ThisCategoryID"
				ContentID="#this.GetProperty('ContentID')#">
				
			<cfinvoke component="com.ContentManager.CategoryHandler" 
				method="GetProductionSiteInformation"
				returnVariable="sProductionSiteInformation"
				CategoryID="#ThisCategoryID#">
				
			<cfif IsStruct(sProductionSiteInformation)>
				<cftransaction>
					<cfquery name="SelectContentFromProd" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SELECT ContentLocaleID, PropertiesID FROM t_contentLocale where ContentLocaleID =<cfqueryparam value="#Val(ThisContentLocaleID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfoutput query="SelectContentFromProd">
						<cfquery name="DeleteContent" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_ContentLocale WHERE ContentLocaleID =<cfqueryparam value="#Val(ContentLocaleID)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery name="DeleteContentProps" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_Properties WHERE PropertiesID=<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfoutput>
				</cftransaction>
				
				<cfif SelectContentFromProd.RecordCount GT "0">
					<cfset ThisFileList=this.GetFileList(1)>
					<cfif ListLen(ThisFileList,";") GT "0">
						<cfloop index="ThisFile" list="#ThisFileList#" delimiters=";">
							<cfif Left(ThisFile,7) IS NOT "/common">
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
				</cfif>
			</cfif>
			<!--- need function here to  delete the key in verity, and update using the category --->
			<cfmodule template="/common/modules/contentManager/UpdateVerity.cfm"
				ContentID="#thisContentID#"
				ContentLocaleID="#val(ThisContentLocaleID)#"
				LocaleID="#val(ThisLocaleID)#">
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveToProduction" returntype="string" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="UserID" required="true">

		<!--- init variables --->
		<cfset var ThisContentLocaleID="">
		<cfset var ThisPropertiesID="">
		<cfset var ThisContentID="">
		<cfset var ThisLocaleID="">
		<cfset var ThisFileList="">
		<cfset var Source="">
		<cfset var Destination="">
		<cfset var ThisFile="">
		<cfset var GetProps="">
		<cfset var DeleteContentOnProduction2="">
		<cfset var UpdateContentOnProduction4="">
		<cfset var ThisCategoryID="">
		<cfset var sProductionSiteInformation="">
		<cfset var success="">
		<cfset var SaveResults="">
		
		<cfinvoke component="com.ContentManager.ContentHandler" 
			method="GetCategoryID"
			returnVariable="ThisCategoryID"
			ContentID="#this.GetProperty('ContentID')#">
			
		<cfinvoke component="com.ContentManager.CategoryHandler" 
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="#ThisCategoryID#">
			
		<cfif IsCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisContentLocaleID=this.GetProperty("ContentLocaleID")>
			<cfset ThisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset ThisContentID=this.GetProperty("ContentID")>
			<cfset ThisLocaleID=this.GetProperty("LocaleID")>
			
		
			<cfinvoke component="com.PostToProduction.postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisContentLocaleID#">
			     <cfinvokeargument name="columnList" value="ContentLocaleID">
			     <cfinvokeargument name="tableName" value="t_ContentLocale">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>
			
			<cfinvoke component="com.PostToProduction.postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisContentID#,#ThisLocaleID#">
			     <cfinvokeargument name="columnList" value="ContentID,LocaleID">
			     <cfinvokeargument name="tableName" value="t_ContentLocaleMeta">
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
			

			<cfinvoke component="com.ContentManager.ContentHandler" method="CreateRemoteFolders" returnVariable="success"
				ContentID="#ThisContentID#"
				FTPHost="#sProductionSiteInformation.ProductionFTPHost#"
				FTPRootPath="#sProductionSiteInformation.ProductionFTPRootPath#"
				FTPUserLogin="#sProductionSiteInformation.ProductionFTPUserLogin#"
				FTPPassword="#sProductionSiteInformation.ProductionFTPPassword#">
			
			<cfset ThisFileList=this.GetFileList(1)>
			<cfif ListLen(ThisFileList,";") GT "0">
				<cfloop index="ThisFile" list="#ThisFileList#" delimiters=";">
					<cfif Left(ThisFile,7) IS NOT "/common">
						<cfset Source=application.utilsObj.GetPathFromURL(ThisFile)>
						<cfset Destination=ReplaceNoCase("#sProductionSiteInformation.ProductionFTPRootPath##ThisFile#","//","/","All")>
						<cfftp action="PUTFILE" server="#sProductionSiteInformation.ProductionFTPHost#" 
							username="#sProductionSiteInformation.ProductionFTPUserLogin#"
							password="#sProductionSiteInformation.ProductionFTPPassword#" 
							stoponerror="No"
							localfile="#Source#"
							remotefile="#Destination#"
							transfermode="Auto" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#" timeout="60"
							Passive="No">
							<p>#ThisFile#|#Source# --><BR>
							#Destination#|#CFFTP.ErrorCode#|#CFFTP.ErrorText#</p>
						<cfftp action="CLOSE" connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#">
					</cfif>
				</cfloop>
			</cfif>
			
			<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
				UserID="#ARGUMENTS.UserID#"
				Entity="ContentLocale"
				KeyID="#ThisContentLocaleID#"
				Operation="savelive"
				EntityName="#This.GetProperty('ContentLocaleName')#">
				
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	
		
	<!--- Returns a ";" delimited list of files that are html attributes (with path and extension) --->
	<cffunction name="parseTemplateValue" output="false">
		<cfargument name="detectLocalHTTPImages" default="false">
		<cfargument name="string" default="">
		<cfargument name="fileExtensionList" default="#APPLICATION.MasterFileExtensionList#">

		<cfset var local = structNew() />
		
		<!--- search for http and https as a starting point --->
		<cfset local.invalidStartTokens="https?://|=|'|""|\(|:" />
		<cfset local.invalidFileTokens="=|'|""|\(|:" />
		<cfset local.fileList = "" />
		<cfset local.currentPosition = 1 />
		
		<!---	this regex, split into 4 groups, looks for:
				any of the invalidStartTokens, 
				*not* followed immediately by any of the invalidFileTokens,
				followed by any alphanumeric or whitespace,
				followed by any of the extensions in arguments.fileExtensionList  --->
		<cfset local.theRegex =	'('	& local.invalidStartTokens & ')([^(' & local.invalidFileTokens 
									& ')]*(?:\([A-Za-z0-9\s]*\)){0,1}(' 
									& replace(ListChangeDelims(arguments.fileExtensionList,'|',';'),".","\.","all") 
									& '))' />
		
		<!--- use this counter to jump past any extracted files --->
		<cfloop condition="local.currentPosition gt 0">
			
			<!--- this regex is looking for invalid tokens in paths to files --->
			<cfset local.aFileSearchResults = reFindNoCase(local.theRegex, arguments.string, local.currentPosition, true) />
			<cfif not local.aFileSearchResults.pos[1]>
				<cfset local.currentPosition = 0>
			<cfelse>
				<cfset local.isLocalHTTP = false />
				<cfset local.isUrl = false />
				
				<!--- if http or https is found in the url, we want the whole url, which is in regex group 1 --->
				<cfif reFindNoCase("https?://", trim(mid(arguments.string, local.aFileSearchResults.pos[2], local.aFileSearchResults.len[2])))>
					<cfset local.currentPosition = local.aFileSearchResults.pos[1] + local.aFileSearchResults.len[1] />
					<cfset local.thisFilePath = trim(mid(arguments.string, local.aFileSearchResults.pos[1], local.aFileSearchResults.len[1])) />
					<cfset local.isUrl = true />
				<!--- else, return the path - regex group 3 --->
				<cfelse>
					<cfset local.currentPosition = local.aFileSearchResults.pos[3] + local.aFileSearchResults.len[3] />
					<cfset local.thisFilePath=trim(mid(arguments.string, local.aFileSearchResults.pos[3], local.aFileSearchResults.len[3])) />
				</cfif>
				
				<!--- if detectLocalHTTPImages is enabled, check if the host's fully qualified url is in the string --->
				<cfif arguments.detectLocalHTTPImages>
					<cfset local.isLocalHTTP = reFindNoCase("https?://" & CGI.server_name & "/?", local.thisFilePath) />
				</cfif>

				<!--- add the file to the list if it needs help --->
				<cfif left(local.thisFilePath,2) is not "//" and (not local.isUrl or (local.isUrl and local.isLocalHttp))>
					<cfset local.fileList = listAppend(local.fileList, local.thisFilePath, ";") />
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn local.fileList />
 	</cffunction>
</cfcomponent>