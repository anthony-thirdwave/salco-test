<cfparam name="PageAction" default="CategoryList">
<cfparam name="ATTRIBUTES.DrawHTML" default="1">
<cfparam name="EditCategoryID" default="-1">
<cfparam name="EditParentID" default="-1">
<cfparam name="EditCategoryLocaleID" default="-1">
<cfparam name="EditLocaleID" default="#SESSION.AdminCurrentAdminLocaleID#">
<cfparam name="CurrentLanguageID" default="100">
<cfparam name="FormLanguageID" default="#CurrentLanguageID#">
<cfset OpenAndCloseFormTables="no">

<!--- convert any form variables with dot notation into a struct for the auction object --->
<cfset form = APPLICATION.UtilsObj.formDotNotationToStruct(form) />

<cfif IsDefined("ATTRIBUTES.PageAction")>
	<cfset PageAction=ATTRIBUTES.PageAction>
</cfif>
<cfparam name="FormAction" default="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
<cfif IsDefined("ATTRIBUTES.FormAction")>
	<cfset FormAction=ATTRIBUTES.FormAction>
</cfif>
<cfif IsDefined("FORM.PageAction")>
	<cfset PageAction=FORM.PageAction>
</cfif>
<cfif NOT IsDefined("ATTRIBUTES.ListPage")>
	<cfset ATTRIBUTES.ListPage="/common/admin/MasterView/index.cfm">
</cfif>

<cfif IsDefined("URL.cid")>
	<cfset EditCategoryID=Decrypt(URL.cid,APPLICATION.Key)>
</cfif>
<cfif IsDefined("URL.CFGridKey")>
	<cfset EditCategoryID=URL.CFGridKey>
</cfif>
<cfset CID=Encrypt(EditCategoryID,APPLICATION.Key)>

<cfif IsDefined("URL.pid")>
	<cfset EditParentID=Decrypt(URL.pid,APPLICATION.Key)>
<cfelse>
	<cfparam name="EditParentID" default="-1">
</cfif>
<cfset PID=Encrypt(EditParentID,APPLICATION.Key)>

<cfif IsDefined("URL.lid")>
	<cfset EditLocaleID=Decrypt(URL.lid,APPLICATION.Key)>
</cfif>
<cfset lid=Encrypt(EditLocaleID,APPLICATION.Key)>

<cfif EditCategoryID GT "0">
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetCategoryLocaleID"
		returnVariable="EditCategoryLocaleID"
		CategoryID="#EditCategoryID#"
		LocaleID="#EditLocaleID#">
</cfif>


<cfparam name="FORM.CategoryActive" default="0">
<cfparam name="FORM.ShowInNavigation" default="0">
<cfparam name="FORM.CategoryIndexed" default="0">
<cfparam name="FORM.CategoryLocaleActive" default="0">
<cfparam name="FORM.DefaultCategoryLocale" default="0">
<cfparam name="FORM.DeleteLocaleRecord" default="0">

<cfset lImageName="CategoryImageBackground,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageAccent,CategoryImageRepresentative,empImage,empImageThumb">
<cfloop index="ThisImage" list="#lImageName#">
	<cfparam name="FORM.Delete#ThisImage#" default="0">
</cfloop>

<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
<cfset MyCategory.Constructor(Val(EditCategoryID))>
<cfif PageAction IS "Add" and val(EditParentID) GT "0">
	<cfset MyCategory.SetProperty("ParentID",EditParentID)>
	<cfif IsDefined("URL.CategoryTypeID")>
		<cfset MyCategory.SetProperty("CategoryTypeID",URL.CategoryTypeID)>
	</cfif>
</cfif>
<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
<cfset MyCategoryLocale.Constructor(Val(EditCategoryLocaleID))>
<cfset MyCategoryLocale.SetProperty("CategoryID",EditCategoryID)>
<cfif Val(EditCategoryLocaleID) LTE "0">
	<cfset MyCategoryLocale.SetProperty("LocaleID",EditLocaleID)>
	<cfset MyCategoryLocale.SetCategoryTypeID(MyCategory.GetProperty("CategoryTypeID"))>
</cfif>

<!---
<!--- If Article, create Article object --->
<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66 OR (IsDefined("FORM.CategoryTypeID") AND FORM.CategoryTypeID EQ 66)>
	<cfparam name="FORM.DeletePortraitPath" default="0">
	<cfset MyArticle=CreateObject("component","com.Article.Article")>
	<cfset MyArticle.Constructor(Val(MyCategory.GetProperty("SourceID")))>
</cfif>
--->

<cfif IsDefined("FORM.CategoryName")>
	<cfif structKeyExists(form, "ButLoad2") and val(lclid) gte "1">
		<cfset SourceCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
		<cfset SourceCategoryLocale.Constructor(Val(application.utilsObj.SimpleDecrypt(lclid)))>
		<cfloop index="PropertyToCopy" list="CategoryID,CategoryLocaleName,CategoryLocaleActive,CategoryLocaleURL,MetaKeywords,MetaDescription,CSSID,CSSClass,CallToActionURL,CategoryLocaleNameAlternative,Byline1,Byline2,Title,#lImageName#,empFirstName,empLastName,empTitle,empPhone,empPhoneExt,empCellPhone,empEmail,empBirthDate,empJoinDate,SubTitle,HomePageDisplay,EmergencyAlert,IncludeInScreenSaver">
			<cfif PropertyToCopy is "SubTitle" and MyCategory.GetProperty("CategoryTypeID") EQ 82>
				<cfinvoke component="com.ContentManager.EmployeeHandler"
					method="GetAllEmployees"
					returnVariable="Employees">
				<cfset thisSubTitle = empFirstName & empLastName>
				<cfset MyCategoryLocale.SetProperty("thisSubTitle",SourceCategoryLocale.GetProperty("#thisSubTitle#"))>
			<cfelse>
				<cfset MyCategoryLocale.SetProperty("#PropertyToCopy#",SourceCategoryLocale.GetProperty("#PropertyToCopy#"))>
			</cfif>
			
		</cfloop>
	<cfelse>
		<!--- if the form is submitted, load the form values into the object --->

		<!--- Handling MyCategory --->
		<cfloop index="ThisProperty" list="CategoryTypeID,ParentID,CategoryName,CategoryAlias,CategoryActive,CategoryURL,MetaKeywords,MetaDescription,WorkflowStatusID,TemplateID,PublishDateTime,ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer,ProductionDBName,ProductionDBDSN,AuthorName,ArticleSourceID,AllowComments,AllowBackToTop,ProductBrandLogoID,ProductConsoleTypeID,ProductProgramTypeID,ColorID,ShowInNavigation,CategoryIndexed,PressReleaseDate,CommentNotificationEmail,lTopicID,foobar,useSSL,lTopicID,SourceID,empFirstName,empLastName,empTitle,empPhone,empPhoneExt,empCellPhone,empEmail,empBirthDate,empJoinDate,SubTitle,HomePageDisplay,EmergencyAlert,IncludeInScreenSaver">
			<cfparam name="FORM.#ThisProperty#" default="">
			<cfset MyCategory.SetProperty("#ThisProperty#", FORM[ThisProperty])>
		</cfloop>
		
		<cfloop index="ThisImage" list="">
			<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
				<cfset MyCategory.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
			</cfif>
		</cfloop>

		<!--- Handling MyCategoryLocale --->
		<cfset MyCategoryLocale.SetCategoryTypeID(CategoryTypeID)>
		<cfloop index="ThisProperty" list="CategoryLocaleName,CategoryLocaleActive,CategoryLocaleURL,MetaKeywords,MetaDescription,CSSID,CSSClass,CallToActionURL,CategoryLocaleNameAlternative,DefaultCategoryLocale,Byline1,Byline2,Title,PageTitleOverride,lRelatedPageID,ImageAltText1,empFirstName,empLastName,empTitle,empPhone,empPhoneExt,empCellPhone,empEmail,empBirthDate,empJoinDate,SubTitle,HomePageDisplay,EmergencyAlert,IncludeInScreenSaver">
			<cfparam name="FORM.#ThisProperty#" default="">
			<cfset MyCategoryLocale.SetProperty("#ThisProperty#", FORM[ThisProperty])>
		</cfloop>

		<cfloop index="ThisImage" list="#lImageName#">
			<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
				<cfset MyCategoryLocale.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
				<!--- employeeImageResize --->
				<!---  if the big image is uploaded, check on size and resize it 191x213 --->
				<cfif ThisImage IS "empImage">
					<cfset thisEmpImagePath = Evaluate("MyCategoryLocale.#ThisImage#")>
					<cfinvoke component="com.utils.Image" method="ResizeGalleryThumbnail" returnVariable="ThisEmpImage"
						WebrootPath="#APPLICATION.WebrootPath#"
						Source="#thisEmpImagePath#"
						Width="191"
						Height="212">
					<cfset MyCategoryLocale.SetProperty(ThisImage, ThisEmpImage)>
				</cfif>
				<cfif ThisImage IS "empImageThumb">
					<cfset thisEmpThumbImagePath = Evaluate("MyCategoryLocale.#ThisImage#")>
					<cfinvoke component="com.utils.Image" method="ResizeGalleryThumbnail" returnVariable="ThisEmpThumbImage"
						WebrootPath="#APPLICATION.WebrootPath#"
						Source="#thisEmpThumbImagePath#"
						Width="89"
						Height="99">
					<cfset MyCategoryLocale.SetProperty(ThisImage, ThisEmpThumbImage)>
				</cfif>
				<cfif MyCategoryLocale.CategoryTypeID eq 82 and ThisImage is "CategoryImageRepresentative">
					<cfset thisImagePath = Evaluate("MyCategoryLocale.#ThisImage#")>
					<cfinvoke component="com.utils.Image" method="Resize" returnVariable="ThisNewsImage"
						WebrootPath="#APPLICATION.WebrootPath#"
						Source="#thisImagePath#"
						Width="240">
					<cfset MyCategoryLocale.SetProperty(ThisImage, ThisNewsImage)>
				</cfif>
			<cfelseif IsDefined("FORM.#ThisImage#")>
				<cfset MyCategoryLocale.SetProperty(ThisImage, FORM[ThisImage])>
				<cfif ThisImage IS "empImageThumb" and IsDefined("FORM.empImageFileObject") AND Evaluate("FORM.empImageFileObject") IS NOT "">
					<cfset thisEmpImagePath = Evaluate("MyCategoryLocale.empImage")>
					<cfinvoke component="com.utils.Image" method="ResizeGalleryThumbnail" returnVariable="ThisEmpThumbImage"
						WebrootPath="#APPLICATION.WebrootPath#"
						Source="#thisEmpImagePath#"
						Width="89"
						Height="99">
					<cfset MyCategoryLocale.SetProperty(ThisImage, ThisEmpThumbImage)>
				</cfif>
			</cfif>
		</cfloop>


	</cfif>
</cfif>

<cfswitch expression="#MyCategory.GetProperty('CategoryTypeID')#">
	<cfcase value="62"><!--- product family --->
		<cfset MyProductFamily=CreateObject("component","com.Product.ProductFamily")>
		<cfset MyProductFamily.Constructor(Val(EditCategoryID),FormLanguageID)>
		<cfset MyProductFamily.SetProperty("CategoryID",Val(EditCategoryID))>
		<cfparam name="ProductFamilyBrochurePathOverride" default="0">
		<cfif IsDefined("FORM.CategoryName") and IsDefined("FORM.NumAttributes")>
			<cfloop index="ThisProperty" list="ProductFamilyDescription,ProductViewLabel,ProductFamilyBrochurePathOverride">
				<cfparam name="FORM.#ThisProperty#" default="">
				<cfset MyProductFamily.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
			</cfloop>
			<cfloop index="ThisImage" list="ProductFamilyBrochurePath">
				<cfparam name="FORM.Delete#ThisImage#" default="0">
				<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
					<cfset MyProductFamily.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
				<cfelseif Evaluate("FORM.Delete#ThisImage#") IS "1">
					<cfset MyProductFamily.FileRemove(APPLICATION.WebrootPath,"#ThisImage#")>
				<cfelseif isDefined("FORM.#ThisImage#")>
					<cfset MyProductFamily.SetProperty("#ThisImage#","#Evaluate('FORM.#ThisImage#')#")>
				</cfif>
			</cfloop>
			<cfset lIndexToDelete="">
			<cfset qAttr=QueryNew("ID,Name,TypeID,Priority,SpecificationSetID")>
			<cfloop index="r" from="1" to="#NumAttributes#" step="1">
				<cfparam name="AttributeID_#r#" default="-1">
				<cfparam name="AttributeName_#r#" default="">
				<cfparam name="AttributeTypeID_#r#" default="-1">
				<cfparam name="AttributeDelete_#r#" default="0">
				<cfparam name="AttributeDeleteSoft_#r#" default="0">
				<cfparam name="AttributePriority_#r#" default="">
				<cfparam name="AttributeSpecificationSetID_#r#" default="8000">
				<cfset ThisAttributeID="-1">
				<cftry>
					<cfset ThisAttributeID=Decrypt(URLDecode(Evaluate("AttributeID_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisAttributeID="-1"></cfcatch>
				</cftry>
				<cfif Evaluate("AttributeDeleteSoft_#r#") IS "1"><!--- Locale deletes attribute --->
					<cfset QueryAddRow(qAttr,1)>
					<cfset QuerySetCell(qAttr,"ID",ThisAttributeID)>
					<cfset QuerySetCell(qAttr,"Name","")>
					<cfset QuerySetCell(qAttr,"TypeID",Evaluate("AttributeTypeID_#r#"))>
					<cfset QuerySetCell(qAttr,"Priority",Val(Evaluate("AttributePriority_#r#")))>
					<cfset QuerySetCell(qAttr,"SpecificationSetID",Val(Evaluate("AttributeSpecificationSetID_#r#")))>
				<cfelseif Evaluate("AttributeDelete_#r#") IS "0">
					<cfset QueryAddRow(qAttr,1)>
					<cfset QuerySetCell(qAttr,"ID",ThisAttributeID)>
					<cfset QuerySetCell(qAttr,"Name",Evaluate("AttributeName_#r#"))>
					<cfset QuerySetCell(qAttr,"TypeID",Evaluate("AttributeTypeID_#r#"))>
					<cfset QuerySetCell(qAttr,"Priority",Val(Evaluate("AttributePriority_#r#")))>
					<cfset QuerySetCell(qAttr,"SpecificationSetID",Val(Evaluate("AttributeSpecificationSetID_#r#")))>
				<cfelseif Evaluate("AttributeDelete_#r#") IS "1">
					<cfif ThisAttributeID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfif 0>
				<cfloop index="r" from="1" to="#ArrayLen(aAttr)#" step="1">
					<cfif isdefined("ButtonSubmit_up_#r#.x") OR isdefined("ButtonSubmit_down_#r#.x")>
						<cfif isdefined("ButtonSubmit_up_#r#.x")>
							<cfset TempStruct=aAttr[r]>
							<cfset aAttr[r]=aAttr[r-1]>
							<cfset aAttr[r-1]=TempStruct>
						<cfelseif isdefined("ButtonSubmit_down_#r#.x")>
							<cfset TempStruct=aAttr[r]>
							<cfset aAttr[r]=aAttr[r+1]>
							<cfset aAttr[r+1]=TempStruct>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfif IsDefined("AttributeName_New") AND Trim(AttributeName_New) IS NOT "">
				<cfparam name="AttributeSpecificationSetID_new" default="8000">
				<cfset NewPriority=(qAttr.RecordCount*10)+10>
				<cfset QueryAddRow(qAttr,1)>
				<cfset QuerySetCell(qAttr,"ID",-1)>
				<cfset QuerySetCell(qAttr,"Name",AttributeName_New)>
				<cfset QuerySetCell(qAttr,"TypeID",AttributeTypeID_New)>
				<cfset QuerySetCell(qAttr,"Priority",NewPriority)>
				<cfset QuerySetCell(qAttr,"SpecificationSetID",AttributeSpecificationSetID_new)>
			</cfif>
			<cfquery name="GetAttrsAgain" dbtype="query">
				select * from qAttr order by Priority
			</cfquery>
			<cfset aAttr=ArrayNew(1)>
			<cfoutput query="GetAttrsAgain">
				<cfset sAttrElement=StructNew()>
				<cfset StructInsert(sAttrElement,"ProductFamilyAttributeID",ID,1)>
				<cfset StructInsert(sAttrElement,"ProductFamilyAttributeTypeID",TypeID,1)>
				<cfset StructInsert(sAttrElement,"ProductFamilyAttributePriority",Priority,1)>
				<cfset StructInsert(sAttrElement,"ProductFamilyAttributeName",Name,1)>
				<cfset StructInsert(sAttrElement,"SpecificationSetID",SpecificationSetID,1)>
				<cfset ArrayAppend(aAttr,sAttrElement)>
			</cfoutput>
			
			<cfset MyProductFamily.SetProperty("aProductFamilyAttribute",aAttr)>
			
			<cfset aProductFamilyFeature=arrayNew(1)>
			<cfset lIndexToDelete="">
			<cfloop index="r" from="1" to="#NumKeyFeatures#" step="1">
				<cfparam name="KeyFeatureID_#r#" default="-1">
				<cfparam name="KeyFeatureText_#r#" default="">
				<cfparam name="KeyFeatureDelete_#r#" default="0">
				<cfparam name="KeyFeatureSpecificationSetID_#r#" default="8000">
				<cfset ThisKeyFeatureID="-1">
				<cftry>
					<cfset ThisKeyFeatureID=Decrypt(URLDecode(Evaluate("KeyFeatureID_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisKeyFeatureID="-1"></cfcatch>
				</cftry>
				<cfif Evaluate("KeyFeatureText_#r#") IS NOT "" AND Evaluate("KeyFeatureDelete_#r#") IS "0">
					<cfset sElement=StructNew()>
					<cfset StructInsert(sElement,"TextBlockID",ThisKeyFeatureID,1)>
					<cfset StructInsert(sElement,"SpecificationSetID",Evaluate("KeyFeatureSpecificationSetID_#r#"),1)>
					<cfset StructInsert(sElement,"TextBlock",Evaluate("KeyFeatureText_#r#"),1)>
					<cfset ArrayAppend(aProductFamilyFeature,sElement)>
				<cfelse>
					<cfif ThisKeyFeatureID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfif IsDefined("KeyFeatureText_New") AND Trim(KeyFeatureText_New) IS NOT "">
				<cfparam name="KeyFeatureSpecificationSetID_new" default="8000">
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"TextBlockID",-1,1)>
				<cfset StructInsert(sElement,"TextBlock",KeyFeatureText_New,1)>
				<cfset StructInsert(sElement,"SpecificationSetID",KeyFeatureSpecificationSetID_new,1)>
				<cfset ArrayAppend(aProductFamilyFeature,sElement)>
			</cfif>
			
			<cfset MyProductFamily.SetProperty("aProductFamilyFeature",aProductFamilyFeature)>
			
			<!--- Start of Product Family Images handling --->
			<cfset aProductFamilyView=arrayNew(1)>
			<cfset lIndexToDelete="">
			<cfloop index="r" from="1" to="#NumImages#" step="1">
				<cfparam name="ResourceID_image_#r#" default="-1">
				<cfparam name="ResourceName_image_#r#" default="">
				<cfparam name="ResourceText_image_#r#" default="">
				<cfparam name="MainFilePath_image_#r#" default="">
				<cfparam name="ThumbnailFilePath_image_#r#" default="">
				<cfparam name="ResourceDelete_image_#r#" default="0">
				<cfparam name="ResourceSpecificationSetID_image_#r#" default="8000">
				<cfset ThisResourceID="-1">
				<cftry>
					<cfset ThisResourceID=Decrypt(URLDecode(Evaluate("ResourceID_image_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisResourceID="-1"></cfcatch>
				</cftry>
				
				<cfif (Evaluate("ResourceName_image_#r#") IS NOT "" or Evaluate("ResourceText_image_#r#") IS NOT "") AND Evaluate("ResourceDelete_image_#r#") IS "0">
					<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
						<cfif IsDefined("FORM.#ThisImage#_image_#r#FileObject") AND evaluate("FORM.#ThisImage#_image_#r#FileObject") IS NOT "">
							<cffile action="UPLOAD" 
								filefield="FORM.#ThisImage#_image_#r#FileObject" 
								destination="#MyCategory.GetResourceFilePath('images',APPLICATION.WebrootPath)#"
								nameconflict="MAKEUNIQUE">
							<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
							<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
								<cffile action="DELETE" file="#UploadedFile#">
							<cfelse>
								<cfset SetVariable("#ThisImage#_image_#r#",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
							</cfif>
						</cfif>
					</cfloop>
					<cfif (Evaluate("ResourceName_image_#r#") IS NOT "" or Evaluate("ResourceText_image_#r#") IS NOT "")>
						<cfset sElement=StructNew()>
						<cfset StructInsert(sElement,"ResourceID",ThisResourceID,1)>
						<cfset StructInsert(sElement,"ResourceName",Evaluate("ResourceName_image_#r#"),1)>
						<cfset StructInsert(sElement,"ResourceText",Evaluate("ResourceText_image_#r#"),1)>
						<cfset StructInsert(sElement,"MainFilePath",Evaluate("MainFilePath_image_#r#"),1)>
						<cfset StructInsert(sElement,"ThumbnailFilePath",Evaluate("ThumbnailFilePath_image_#r#"),1)>
						<cfset StructInsert(sElement,"SpecificationSetID",Evaluate("ResourceSpecificationSetID_image_#r#"),1)>
						<cfset StructInsert(sElement,"MainFileSize","",1)>
						<cfif FileExists(ExpandPath(Evaluate("MainFilePath_image_#r#")))>
							<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(Evaluate("MainFilePath_image_#r#"))).Size,1)>
						</cfif>
						<cfset ArrayAppend(aProductFamilyView,sElement)>
					<cfelse>
						<cfif ThisResourceID GT "0">
							<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
						</cfif>
					</cfif>
				<cfelse>
					<cfif ThisResourceID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<!--- sort views --->
			<cfmodule template="/common/modules/product/ProductArraySort.cfm"
				ThisArray="#aProductFamilyView#"
				ThisFormID="views"
				IsDisplay="0">
			
			<cfif IsDefined("ResourceName_image_new") AND (Trim(ResourceName_image_new) IS NOT "" or Trim(ResourceText_image_new) IS NOT "" or Trim(MainFilePath_image_newFileObject) IS NOT "")>
				<cfparam name="ResourceSpecificationSetID_image_new" default="8000">
				<cfif ResourceName_image_new IS "">
					<cfset ResourceName_image_new="Image #ArrayLen(aProductFamilyView)+1#">
				</cfif>
				<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
					<cfif IsDefined("FORM.#ThisImage#_image_newFileObject") AND evaluate("FORM.#ThisImage#_image_newFileObject") IS NOT "">
						<cffile action="UPLOAD" 
							filefield="FORM.#ThisImage#_image_newFileObject" 
							destination="#MyCategory.GetResourceFilePath('images',APPLICATION.WebrootPath)#"
							nameconflict="MAKEUNIQUE">
						<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
						<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
							<cffile action="DELETE" file="#UploadedFile#">
							<!--- add AddError('aProductFamilyView') here --->
						<cfelse>
							<cfset SetVariable("#ThisImage#_image_new",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
						</cfif>
					</cfif>
				</cfloop>
				
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"ResourceID",-1,1)>
				<cfset StructInsert(sElement,"ResourceName",ResourceName_image_new,1)>
				<cfset StructInsert(sElement,"ResourceText",ResourceText_image_new,1)>
				<cfset StructInsert(sElement,"SpecificationSetID",ResourceSpecificationSetID_image_new,1)>
				<cfset StructInsert(sElement,"MainFileSize","",1)>
				<cfif IsDefined("MainFilePath_image_new") AND MainFilePath_image_new IS NOT "">
					<cfset StructInsert(sElement,"MainFilePath",MainFilePath_image_new,1)>
					<cfif FileExists(ExpandPath(MainFilePath_image_new))>
						<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(MainFilePath_image_new)).Size,1)>
					</cfif>
				<cfelse>
					<cfset StructInsert(sElement,"MainFilePath","",1)>
				</cfif>
				<cfif IsDefined("ThumbnailFilePath_image_new") AND ThumbnailFilePath_image_new IS NOT "">
					<cfset StructInsert(sElement,"ThumbnailFilePath",ThumbnailFilePath_image_new,1)>
				<cfelse>
					<cfset StructInsert(sElement,"ThumbnailFilePath","",1)>
				</cfif>
				<cfset ArrayAppend(aProductFamilyView,sElement)>
			</cfif>
			
			<!--- Start of Product Family Downloads handling --->
			<cfset aProductFamilyDownload=arrayNew(1)>
			<cfset lIndexToDelete="">
			<cfloop index="r" from="1" to="#NumDownloads#" step="1">
				<cfparam name="ResourceID_download_#r#" default="-1">
				<cfparam name="ResourceName_download_#r#" default="">
				<cfparam name="ResourceText_download_#r#" default="">
				<cfparam name="MainFilePath_download_#r#" default="">
				<cfparam name="ThumbnailFilePath_download_#r#" default="">
				<cfparam name="ResourceDelete_download_#r#" default="0">
				<cfparam name="ResourceSpecificationSetID_download_#r#" default="8000">
				<cfset ThisResourceID="-1">
				<cftry>
					<cfset ThisResourceID=Decrypt(URLDecode(Evaluate("ResourceID_download_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisResourceID="-1"></cfcatch>
				</cftry>
				
				<cfif (Evaluate("ResourceName_download_#r#") IS NOT "" or Evaluate("ResourceText_download_#r#") IS NOT "") AND Evaluate("ResourceDelete_download_#r#") IS "0">
					<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
						<cfif IsDefined("FORM.#ThisImage#_download_#r#FileObject") AND evaluate("FORM.#ThisImage#_download_#r#FileObject") IS NOT "">
							<cffile action="UPLOAD" 
								filefield="FORM.#ThisImage#_download_#r#FileObject" 
								destination="#MyCategory.GetResourceFilePath('documents',APPLICATION.WebrootPath)#"
								nameconflict="MAKEUNIQUE">
							<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
							<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
								<cffile action="DELETE" file="#UploadedFile#">
								<!--- add AddError('aProductFamilyDownload') here --->
							<cfelse>
								<cfset SetVariable("#ThisImage#_download_#r#",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
							</cfif>
						</cfif>
					</cfloop>
					<cfif (Evaluate("ResourceName_download_#r#") IS NOT "" or Evaluate("ResourceText_download_#r#") IS NOT "")>
						<cfset sElement=StructNew()>
						<cfset StructInsert(sElement,"ResourceID",ThisResourceID,1)>
						<cfset StructInsert(sElement,"ResourceName",Evaluate("ResourceName_download_#r#"),1)>
						<cfset StructInsert(sElement,"ResourceText",Evaluate("ResourceText_download_#r#"),1)>
						<cfset StructInsert(sElement,"MainFilePath",Evaluate("MainFilePath_download_#r#"),1)>
						<cfset StructInsert(sElement,"ThumbnailFilePath",Evaluate("ThumbnailFilePath_download_#r#"),1)>
						<cfset StructInsert(sElement,"SpecificationSetID",Evaluate("ResourceSpecificationSetID_download_#r#"),1)>
						<cfset StructInsert(sElement,"MainFileSize","",1)>
						<cfif FileExists(ExpandPath(Evaluate("MainFilePath_download_#r#")))>
							<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(Evaluate("MainFilePath_download_#r#"))).Size,1)>
						</cfif>
						<cfset ArrayAppend(aProductFamilyDownload,sElement)>
					<cfelse>
						<cfif ThisResourceID GT "0">
							<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
						</cfif>
					</cfif>
				<cfelse>
					<cfif ThisResourceID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<!--- sort views --->
			<cfmodule template="/common/modules/product/ProductArraySort.cfm"
				ThisArray="#aProductFamilyDownload#"
				ThisFormID="downloads"
				IsDisplay="0">
			
			<cfif IsDefined("ResourceName_download_new") AND (Trim(ResourceName_download_new) IS NOT "" or Trim(ResourceText_download_new) IS NOT "" or Trim(MainFilePath_download_newFileObject) IS NOT "")>
				<cfparam name="ResourceSpecificationSetID_download_new" default="8000">
				<cfif ResourceName_download_new IS "">
					<cfset ResourceName_download_new="Download #ArrayLen(aProductFamilyDownload)+1#">
				</cfif>
				<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
					<cfif IsDefined("FORM.#ThisImage#_download_newFileObject") AND evaluate("FORM.#ThisImage#_download_newFileObject") IS NOT "">
						<cffile action="UPLOAD" 
							filefield="FORM.#ThisImage#_download_newFileObject" 
							destination="#MyCategory.GetResourceFilePath('documents',APPLICATION.WebrootPath)#"
							nameconflict="MAKEUNIQUE">
						<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
						<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
							<cffile action="DELETE" file="#UploadedFile#">
							<!--- add AddError('aProductFamilyDownload') here --->
						<cfelse>
							<cfset SetVariable("#ThisImage#_download_new",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
						</cfif>
					</cfif>
				</cfloop>
				
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"ResourceID",-1,1)>
				<cfset StructInsert(sElement,"ResourceName",ResourceName_download_new,1)>
				<cfset StructInsert(sElement,"ResourceText",ResourceText_download_new,1)>
				<cfset StructInsert(sElement,"SpecificationSetID",ResourceSpecificationSetID_download_new,1)>
				<cfset StructInsert(sElement,"MainFileSize","",1)>
				<cfif IsDefined("MainFilePath_download_new") AND MainFilePath_download_new IS NOT "">
					<cfset StructInsert(sElement,"MainFilePath",MainFilePath_download_new,1)>
					<cfif FileExists(ExpandPath(MainFilePath_download_new))>
						<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(MainFilePath_download_new)).Size,1)>
					</cfif>
				<cfelse>
					<cfset StructInsert(sElement,"MainFilePath","",1)>
				</cfif>
				<cfif IsDefined("ThumbnailFilePath_download_new") AND ThumbnailFilePath_download_new IS NOT "">
					<cfset StructInsert(sElement,"ThumbnailFilePath",ThumbnailFilePath_download_new,1)>
				<cfelse>
					<cfset StructInsert(sElement,"ThumbnailFilePath","",1)>
				</cfif>
				<cfset ArrayAppend(aProductFamilyDownload,sElement)>
			</cfif>
			
			<cfset MyProductFamily.SetProperty("aProductFamilyView",aProductFamilyView)>
			<cfset MyProductFamily.SetProperty("aProductFamilyDownload",aProductFamilyDownload)>
			
			<cfif IsDefined("FORM.ButLoad") AND Val(plclid) GTE "1">
				<cfset SourceProductFamily=CreateObject("component","com.Product.ProductFamily")>
				<cfset SourceProductFamily.Constructor(Val(EditCategoryID),APPLICATION.UtilsObj.SimpleDecrypt(plclid))>
				<cfloop index="PropertyToCopy" list="ProductFamilyDescription,ProductViewLabel,ProductFamilyBrochurePath,ProductFamilyBrochurePathOverride,aProductFamilyFeature,aProductFamilyView,aProductFamilyDownload">
					<cfset MyProductFamily.SetProperty("#PropertyToCopy#",SourceProductFamily.GetProperty("#PropertyToCopy#"))>
				</cfloop>
			</cfif>
			<cfif IsDefined("FORM.ButLoad3") AND Val(plclid2) GTE "1">
				<cfset SourceProductFamily=CreateObject("component","com.Product.ProductFamily")>
				<cfset SourceProductFamily.Constructor(Val(EditCategoryID),APPLICATION.UtilsObj.SimpleDecrypt(plclid2))>
				<cfloop index="PropertyToCopy" list="aProductFamilyAttribute">
					<cfset MyProductFamily.SetProperty("#PropertyToCopy#",SourceProductFamily.GetProperty("#PropertyToCopy#"))>
				</cfloop>	
			</cfif>
			
		</cfif>
	</cfcase>
	<cfcase value="64"><!--- Product --->
		<cfset MyProduct=CreateObject("component","com.Product.Product")>
		<cfset MyProduct.Constructor(Val(EditCategoryID),FormLanguageID)>
		
		<cfif IsDefined("FORM.CategoryName") AND IsDefined("FORM.ProductDescription")>
			
			<cfloop index="ThisProperty" list="ProductLongName,ProductShortName,ProductPositioningSentence,ProductDescription,CallToActionURLDeprecated,VideoURL,PartNumber">
				<cfparam name="FORM.#ThisProperty#" default="">
				<cfset MyProduct.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
			</cfloop>
			<cfloop index="ThisImage" list="BrochurePath,PublicDrawing,ProductThumbnailPath,ProductThumbnailHoverPath,ProductImageSourcePath,ProductImageStorePath">
				<cfparam name="FORM.Delete#ThisImage#" default="0">
				<cfparam name="FORM.#ThisImage#" default="">
				<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
					<cfset MyProduct.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
				<cfelseif Evaluate("FORM.Delete#ThisImage#") IS "1">
					<cfset MyProduct.FileRemove(APPLICATION.WebrootPath,"#ThisImage#")>
				<cfelse>
					<cfset MyProduct.SetProperty("#ThisImage#","#Evaluate('FORM.#ThisImage#')#")>
				</cfif>
			</cfloop>
			
			<cfset aProductFeature=arrayNew(1)>
			<cfset lIndexToDelete="">
			<cfloop index="r" from="1" to="#NumKeyFeatures#" step="1">
				<cfparam name="KeyFeatureID_#r#" default="-1">
				<cfparam name="KeyFeatureText_#r#" default="">
				<cfparam name="KeyFeatureDelete_#r#" default="0">
				<cfparam name="KeyFeatureSpecificationSetID_#r#" default="8000">
				<cfset ThisKeyFeatureID="-1">
				<cftry>
					<cfset ThisKeyFeatureID=Decrypt(URLDecode(Evaluate("KeyFeatureID_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisKeyFeatureID="-1"></cfcatch>
				</cftry>
				<cfif Evaluate("KeyFeatureText_#r#") IS NOT "" AND Evaluate("KeyFeatureDelete_#r#") IS "0">
					<cfset sElement=StructNew()>
					<cfset StructInsert(sElement,"TextBlockID",ThisKeyFeatureID,1)>
					<cfset StructInsert(sElement,"TextBlock",Evaluate("KeyFeatureText_#r#"),1)>
					<cfset StructInsert(sElement,"SpecificationSetID",Evaluate("KeyFeatureSpecificationSetID_#r#"),1)>
					<cfset ArrayAppend(aProductFeature,sElement)>
				<cfelse>
					<cfif ThisKeyFeatureID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfif IsDefined("KeyFeatureText_New") AND  Trim(KeyFeatureText_New) IS NOT "">
				<cfparam name="KeyFeatureSpecificationSetID_new" default="8000">
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"TextBlockID",-1,1)>
				<cfset StructInsert(sElement,"TextBlock",KeyFeatureText_New,1)>
				<cfset StructInsert(sElement,"SpecificationSetID",KeyFeatureSpecificationSetID_new,1)>
				<cfset ArrayAppend(aProductFeature,sElement)>
			</cfif>
			
			<!--- sort keyfeatures --->
			<cfmodule template="/common/modules/product/ProductArraySort.cfm"
				ThisArray="#aProductFeature#"
				ThisFormID="keyfeature"
				IsDisplay="0">
				
			<!--- Start of Product Family Images handling --->
			<cfset aProductView=arrayNew(1)>
			<cfset lIndexToDelete="">
			<cfloop index="r" from="1" to="#NumImages#" step="1">
				<cfparam name="ResourceID_image_#r#" default="-1">
				<cfparam name="ResourceName_image_#r#" default="">
				<cfparam name="ResourceText_image_#r#" default="">
				<cfparam name="MainFilePath_image_#r#" default="">
				<cfparam name="ThumbnailFilePath_image_#r#" default="">
				<cfparam name="ResourceDelete_image_#r#" default="0">
				<cfparam name="ResourceSpecificationSetID_image_#r#" default="8000">
				<cfset ThisResourceID="-1">
				<cftry>
					<cfset ThisResourceID=Decrypt(URLDecode(Evaluate("ResourceID_image_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisResourceID="-1"></cfcatch>
				</cftry>
				
				<cfif (Evaluate("ResourceName_image_#r#") IS NOT "" or Evaluate("ResourceText_image_#r#") IS NOT "") AND Evaluate("ResourceDelete_image_#r#") IS "0">
					<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
						<cfif IsDefined("FORM.#ThisImage#_image_#r#FileObject") AND evaluate("FORM.#ThisImage#_image_#r#FileObject") IS NOT "">
							<cffile action="UPLOAD" 
								filefield="FORM.#ThisImage#_image_#r#FileObject" 
								destination="#MyCategory.GetResourceFilePath('images',APPLICATION.WebrootPath)#"
								nameconflict="MAKEUNIQUE">
							<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
							<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
								<cffile action="DELETE" file="#UploadedFile#">
							<cfelse>
								<cfset SetVariable("#ThisImage#_image_#r#",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
							</cfif>
						</cfif>
					</cfloop>
					<cfif (Evaluate("ResourceName_image_#r#") IS NOT "" or Evaluate("ResourceText_image_#r#") IS NOT "")>
						<cfset sElement=StructNew()>
						<cfset StructInsert(sElement,"ResourceID",ThisResourceID,1)>
						<cfset StructInsert(sElement,"ResourceName",Evaluate("ResourceName_image_#r#"),1)>
						<cfset StructInsert(sElement,"ResourceText",Evaluate("ResourceText_image_#r#"),1)>
						<cfset StructInsert(sElement,"MainFilePath",Evaluate("MainFilePath_image_#r#"),1)>
						<cfset StructInsert(sElement,"MainFileSize","",1)>
						<cfif FileExists(ExpandPath(Evaluate("MainFilePath_image_#r#")))>
							<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(Evaluate("MainFilePath_image_#r#"))).Size,1)>
						</cfif>
						<cfif (Evaluate("ThumbnailFilePath_image_#r#") IS "" and Evaluate("MainFilePath_image_#r#") IS NOT "") or (IsDefined("FORM.MainFilePath_image_#r#FileObject") AND evaluate("FORM.MainFilePath_image_#r#FileObject") IS NOT "")>
							<cfinvoke component="/com/utils/image" 
								method="ResizeGalleryThumbnail" 
								returnVariable="ThisImage"
								WebrootPath="#APPLICATION.WebrootPath#"
								Source="#Evaluate('MainFilePath_image_#r#')#"
								Width="54"
								Height="54">
							<cfset SetVariable("ThumbnailFilePath_image_#r#",ThisImage)>
						</cfif>
						<cfset StructInsert(sElement,"ThumbnailFilePath",Evaluate("ThumbnailFilePath_image_#r#"),1)>
						<cfset StructInsert(sElement,"SpecificationSetID",Evaluate("ResourceSpecificationSetID_image_#r#"),1)>
						<cfset ArrayAppend(aProductView,sElement)>
					<cfelse>
						<cfif ThisResourceID GT "0">
							<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
						</cfif>
					</cfif>
				<cfelse>
					<cfif ThisResourceID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<!--- sort views --->
			<cfmodule template="/common/modules/product/ProductArraySort.cfm"
				ThisArray="#aProductView#"
				ThisFormID="views"
				IsDisplay="0">
			
			<cfif IsDefined("ResourceName_image_new") AND (Trim(ResourceName_image_new) IS NOT "" or Trim(ResourceText_image_new) IS NOT "" or MainFilePath_image_newFileObject IS NOT "")>
				<cfparam name="ResourceSpecificationSetID_image_new" default="8000">
				<cfif ResourceName_image_new IS "">
					<cfset ResourceName_image_new="Image #ArrayLen(aProductView)+1#">
				</cfif>
				<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
					<cfif IsDefined("FORM.#ThisImage#_image_newFileObject") AND evaluate("FORM.#ThisImage#_image_newFileObject") IS NOT "">
						<cffile action="UPLOAD" 
							filefield="FORM.#ThisImage#_image_newFileObject" 
							destination="#MyCategory.GetResourceFilePath('images',APPLICATION.WebrootPath)#"
							nameconflict="MAKEUNIQUE">
						<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
						<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
							<cffile action="DELETE" file="#UploadedFile#">
							<!--- add AddError('aProductView') here --->
						<cfelse>
							<cfset SetVariable("#ThisImage#_image_new",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
						</cfif>
					</cfif>
				</cfloop>
				
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"ResourceID",-1,1)>
				<cfset StructInsert(sElement,"ResourceName",ResourceName_image_new,1)>
				<cfset StructInsert(sElement,"ResourceText",ResourceText_image_new,1)>
				<cfset StructInsert(sElement,"SpecificationSetID",ResourceSpecificationSetID_image_new,1)>
				<cfset StructInsert(sElement,"MainFileSize","",1)>
				<cfif IsDefined("MainFilePath_image_new") AND MainFilePath_image_new IS NOT "">
					<cfset StructInsert(sElement,"MainFilePath",MainFilePath_image_new,1)>
					<cfif FileExists(ExpandPath(MainFilePath_image_new))>
						<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(MainFilePath_image_new)).Size,1)>
					</cfif>
				<cfelse>
					<cfset StructInsert(sElement,"MainFilePath","",1)>
				</cfif>
				<cfif IsDefined("ThumbnailFilePath_image_new") AND ThumbnailFilePath_image_new IS NOT "">
					<cfset StructInsert(sElement,"ThumbnailFilePath",ThumbnailFilePath_image_new,1)>
				<cfelse>
					<cfset StructInsert(sElement,"ThumbnailFilePath","",1)>
				</cfif>
				<cfset ArrayAppend(aProductView,sElement)>
			</cfif>
			
			<!--- Start of Product Family Downloads handling --->
			<cfset aProductDownload=arrayNew(1)>
			<cfset lIndexToDelete="">
			<cfloop index="r" from="1" to="#NumDownloads#" step="1">
				<cfparam name="ResourceID_download_#r#" default="-1">
				<cfparam name="ResourceName_download_#r#" default="">
				<cfparam name="ResourceText_download_#r#" default="">
				<cfparam name="MainFilePath_download_#r#" default="">
				<cfparam name="ThumbnailFilePath_download_#r#" default="">
				<cfparam name="ResourceDelete_download_#r#" default="0">
				<cfparam name="ResourceSpecificationSetID_download_#r#" default="8000">
				<cfset ThisResourceID="-1">
				<cftry>
					<cfset ThisResourceID=Decrypt(URLDecode(Evaluate("ResourceID_download_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisResourceID="-1"></cfcatch>
				</cftry>
				
				<cfif (Evaluate("ResourceName_download_#r#") IS NOT "" or Evaluate("ResourceText_download_#r#") IS NOT "") AND Evaluate("ResourceDelete_download_#r#") IS "0">
					<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
						<cfif IsDefined("FORM.#ThisImage#_download_#r#FileObject") AND evaluate("FORM.#ThisImage#_download_#r#FileObject") IS NOT "">
							<cffile action="UPLOAD" 
								filefield="FORM.#ThisImage#_download_#r#FileObject" 
								destination="#MyCategory.GetResourceFilePath('documents',APPLICATION.WebrootPath)#"
								nameconflict="MAKEUNIQUE">
							<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
							<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
								<cffile action="DELETE" file="#UploadedFile#">
								<!--- add AddError('aProductDownload') here --->
							<cfelse>
								<cfset SetVariable("#ThisImage#_download_#r#",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
							</cfif>
						</cfif>
					</cfloop>
					<cfif (Evaluate("ResourceName_download_#r#") IS NOT "" or Evaluate("ResourceText_download_#r#") IS NOT "")>
						<cfset sElement=StructNew()>
						<cfset StructInsert(sElement,"ResourceID",ThisResourceID,1)>
						<cfset StructInsert(sElement,"ResourceName",Evaluate("ResourceName_download_#r#"),1)>
						<cfset StructInsert(sElement,"ResourceText",Evaluate("ResourceText_download_#r#"),1)>
						<cfset StructInsert(sElement,"MainFilePath",Evaluate("MainFilePath_download_#r#"),1)>
						<cfset StructInsert(sElement,"ThumbnailFilePath",Evaluate("ThumbnailFilePath_download_#r#"),1)>
						<cfset StructInsert(sElement,"SpecificationSetID",Evaluate("ResourceSpecificationSetID_download_#r#"),1)>
						<cfset StructInsert(sElement,"MainFileSize","",1)>
						<cfif FileExists(ExpandPath(Evaluate("MainFilePath_download_#r#")))>
							<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(Evaluate("MainFilePath_download_#r#"))).Size,1)>
						</cfif>
						<cfset ArrayAppend(aProductDownload,sElement)>
					<cfelse>
						<cfif ThisResourceID GT "0">
							<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
						</cfif>
					</cfif>
				<cfelse>
					<cfif ThisResourceID GT "0">
						<cfset lIndexToDelete=ListAppend(lIndexToDelete,r)>
					</cfif>
				</cfif>
			</cfloop>
			
			<!--- sort views --->
			<cfmodule template="/common/modules/product/ProductArraySort.cfm"
				ThisArray="#aProductDownload#"
				ThisFormID="downloads"
				IsDisplay="0">
			
			<cfif IsDefined("ResourceName_download_new") AND (Trim(ResourceName_download_new) IS NOT "" or Trim(ResourceText_download_new) IS NOT "" or Trim(MainFilePath_download_newFileObject) IS NOT "")>
				<cfparam name="ResourceSpecificationSetID_download_new" default="8000">
				<cfif ResourceName_download_new IS "">
					<cfset ResourceName_download_new="Download #ArrayLen(aProductDownload)+1#">
				</cfif>
				<cfloop index="ThisImage" list="MainFilePath,ThumbnailFilePath">
					<cfif IsDefined("FORM.#ThisImage#_download_newFileObject") AND evaluate("FORM.#ThisImage#_download_newFileObject") IS NOT "">
						<cffile action="UPLOAD" 
							filefield="FORM.#ThisImage#_download_newFileObject" 
							destination="#MyCategory.GetResourceFilePath('documents',APPLICATION.WebrootPath)#"
							nameconflict="MAKEUNIQUE">
						<cfset UploadedFile="#APPLICATION.UtilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)#">
						<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
							<cffile action="DELETE" file="#UploadedFile#">
							<!--- add AddError('aProductDownload') here --->
						<cfelse>
							<cfset SetVariable("#ThisImage#_download_new",APPLICATION.UtilsObj.GetURLFromPath(UploadedFile))>
						</cfif>
					</cfif>
				</cfloop>
				
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"ResourceID",-1,1)>
				<cfset StructInsert(sElement,"ResourceName",ResourceName_download_new,1)>
				<cfset StructInsert(sElement,"ResourceText",ResourceText_download_new,1)>
				<cfset StructInsert(sElement,"SpecificationSetID",ResourceSpecificationSetID_download_new,1)>
				<cfset StructInsert(sElement,"MainFileSize","",1)>
				<cfif IsDefined("MainFilePath_download_new") AND MainFilePath_download_new IS NOT "">
					<cfset StructInsert(sElement,"MainFilePath",MainFilePath_download_new,1)>
					<cfif FileExists(ExpandPath(MainFilePath_download_new))>
						<cfset StructInsert(sElement,"MainFileSize",GetFileInfo(ExpandPath(MainFilePath_download_new)).Size,1)>
					</cfif>
				<cfelse>
					<cfset StructInsert(sElement,"MainFilePath","",1)>
				</cfif>
				<cfif IsDefined("ThumbnailFilePath_download_new") AND ThumbnailFilePath_download_new IS NOT "">
					<cfset StructInsert(sElement,"ThumbnailFilePath",ThumbnailFilePath_download_new,1)>
				<cfelse>
					<cfset StructInsert(sElement,"ThumbnailFilePath","",1)>
				</cfif>
				<cfset ArrayAppend(aProductDownload,sElement)>
			</cfif>
			
			<cfset MyProduct.SetProperty("aProductView",aProductView)>
			<cfset MyProduct.SetProperty("aProductDownload",aProductDownload)>
			
			<cfset aProductAttribute=ArrayNew(1)>
			<cfloop index="r" from="1" to="#NumAttributes#" step="1">
				<cfparam name="ProductFamilyAttributeID_#r#" default="-1">
				<cfparam name="ProductFamilyAttributeTypeID_#r#" default="-1">
				<cfparam name="AttributeValue_#r#" default="">
				<cfparam name="AttributeValueID_#r#" default="-1">
				<cfset ThisProductFamilyAttributeID="-1">
				<cftry>
					<cfset ThisProductFamilyAttributeID=Decrypt(URLDecode(Evaluate("ProductFamilyAttributeID_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisProductFamilyAttributeID="-1"></cfcatch>
				</cftry>
				<cftry>
					<cfset ThisProductFamilyAttributeTypeID=Decrypt(URLDecode(Evaluate("ProductFamilyAttributeTypeID_#r#")),APPLICATION.Key)>
					<cfcatch><cfset ThisProductFamilyAttributeTypeID="-1"></cfcatch>
				</cftry>
				<cfif ThisProductFamilyAttributeID GT "0">
					<cfset sAttributeElt=StructNew()>
					<Cfset StructInsert(sAttributeElt,"ProductFamilyAttributeID",ThisProductFamilyAttributeID,1)>
					<Cfset StructInsert(sAttributeElt,"ProductFamilyAttributeTypeID",ThisProductFamilyAttributeTypeID,1)>
					<Cfset StructInsert(sAttributeElt,"AttributeValue","",1)>
					<Cfset StructInsert(sAttributeElt,"AttributeValueID","-1",1)>
					<cfif Trim(Evaluate("AttributeValue_#r#")) IS NOT "">
						<Cfset StructInsert(sAttributeElt,"AttributeValue",Trim(Evaluate("AttributeValue_#r#")),1)>
					</cfif>
					<cfif Val(Evaluate("AttributeValueID_#r#")) GT "0">
						<Cfset StructInsert(sAttributeElt,"AttributeValueID",Val(Evaluate("AttributeValueID_#r#")),1)>
					</cfif>
					<cfset ArrayAppend(aProductAttribute,sAttributeElt)>
				</cfif>
			</cfloop>
			
			
			<cfset MyProduct.SetProperty("aProductFeature",aProductFeature)>
			<cfset MyProduct.SetProperty("aProductAttribute",aProductAttribute)>
			<cfif MyProduct.IsCorrect()>
				<cfset MyProduct.Save(APPLICATION.WebrootPath,SESSION.UserID)>
			</cfif>
			
			
			<cfif IsDefined("FORM.ButLoad") AND Val(plclid) GTE "1">
				<cfset SourceProduct=CreateObject("component","com.Product.Product")>
				<cfset SourceProduct.Constructor(Val(EditCategoryID),APPLICATION.UtilsObj.SimpleDecrypt(plclid))>
				<cfloop index="PropertyToCopy" list="ProductLongName,ProductShortName,ProductPositioningSentence,ProductDescription,CallToActionURLDeprecated,VideoURL,PartNumber,BrochurePath,PublicDrawing,ProductImagePath,ProductThumbnailPath,ProductThumbnailHoverPath,ProductImageSourcePath,ProductImageStorePath,aProductFeature,aProductBullet,aProductReview,aProductView,aProductAttribute">
					<cfset MyProduct.SetProperty("#PropertyToCopy#",SourceProduct.GetProperty("#PropertyToCopy#"))>
				</cfloop>
			</cfif>
			
			<cfif IsDefined("FORM.ButLoad3") AND Val(plclid2) GTE "1"><!--- load only specs table --->
				<cfset SourceProduct=CreateObject("component","com.Product.Product")>
				<cfset SourceProduct.Constructor(Val(EditCategoryID),APPLICATION.UtilsObj.SimpleDecrypt(plclid2))>
				<cfloop index="PropertyToCopy" list="aProductAttribute">
					<cfset MyProduct.SetProperty("#PropertyToCopy#",SourceProduct.GetProperty("#PropertyToCopy#"))>
				</cfloop>
			</cfif>
		</cfif>
	</cfcase>
	<cfdefaultcase>
	</cfdefaultcase>
</cfswitch>

<cfset PageAction=Trim(PageAction)>

<cfif PageAction IS "ValidateEdit" OR PageAction IS "ValidateAdd">
	<cfif not structKeyExists(form, "ButSubmit")>
		<cfset PageAction=ReplaceNoCase(PageAction,"Validate","","All")>
	</cfif>
</cfif>



<cfset PageTitle="Page Details">
<cfif EditCategoryID GT "0">
	<cfif MyCategoryLocale.GetProperty("CategoryLocaleName") IS NOT "">
		<cfset PageTitle="#PageTitle# : #MyCategoryLocale.GetProperty('CategoryLocaleName')#">
	<cfelse>
		<cfset PageTitle="#PageTitle# : #MyCategory.GetProperty('CategoryName')#">
	</cfif>
</cfif>
<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="#PageTitle#"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | <a href=""/common/admin/masterview/"">Content Manager</A> | #PageTitle#">

<cfif ListFindNoCase("Add,Edit,ValidateDelete",PageAction) AND NOT IsDefined("ReturnURL")>
	<cfset ReturnURL=CGI.HTTP_Referer>
</cfif>

<cfswitch expression="#Trim(PageAction)#">
	<cfcase value="Add,Edit">
		<cfset FormMode="ShowForm">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cfif PageAction IS "add">
				<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#pid#">
				<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
				<cfif SESSION.AdminUserLocaleID IS "1" and MyCategoryLocale.GetProperty("LocaleID") IS APPLICATION.DefaultLocaleID>
					<cfset MyCategoryLocale.SetProperty("DefaultCategoryLocale",1)>
				</cfif>
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" Omitlist="PageAction">
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data" id="categoryForm">
			<input type="hidden" name="PageAction" value="Validate#PageAction#">
		</cfoutput>

		<cfif SESSION.AdminCurrentAdminLocaleID IS NOT APPLICATION.DefaultLocaleID and PageAction IS "Edit">
			<cfinvoke component="com.ContentManager.CategoryHandler"
					method="GetOtherCategoryLocale"
					returnVariable="GetOtherCategoryLocale"
					CategoryID="#EditCategoryID#">
			<cfif ValueList(GetOtherCategoryLocale.CategoryLocaleID) IS NOT MyCategoryLocale.GetProperty("CategoryLocaleID")>
				<div style="padding-bottom:10px;" align="right">Load Page From:
				<select name="lclid">
					<option value="-1">Select...</option>
					<cfoutput query="GetOtherCategoryLocale">
						<cfif CategoryLocaleID IS NOT MyCategoryLocale.GetProperty("CategoryLocaleID")>
							<option value="#application.utilsObj.SimpleEncrypt(CategoryLocaleID)#">#LocaleName#</option>
						</cfif>
					</cfoutput>
				</select> <input type="submit" name="ButLoad2" value="Load"></div>
			</cfif>
		</cfif>

		<div>
			<div class="box1">
				<div class="boxtop1"><div></div></div>
				<div class="ModuleTitle1">Page Details (Master)</div>
				<div class="ModuleBody1">
				<table width="90%" cellspacing="1" cellpadding="1">
				<tr>
					<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				</tr>
				<cfif PageAction IS "Add">
					<cfset FormMode="ShowForm">
				<cfelse>
					<cfif SESSION.AdminUserLocaleID IS "1">
						<cfif MyCategoryLocale.GetProperty("LocaleID") IS APPLICATION.DefaultLocaleID>
							<cfset FormMode="ShowForm">
						<cfelse>
							<cfset FormMode="Validate">
						</cfif>
					<cfelse>
						<cfinvoke component="com.ContentManager.CategoryHandler"
							method="GetOtherCategoryLocale"
							returnVariable="GetOtherCategoryLocale"
							CategoryID="#EditCategoryID#">
						<cfif ValueList(GetOtherCategoryLocale.CategoryLocaleID) IS MyCategoryLocale.GetProperty("CategoryLocaleID")>
							<cfset FormMode="ShowForm">
						<cfelse>
							<cfset FormMode="Validate">
						</cfif>
					</cfif>
				</cfif>

				<cfinclude template="/common/modules/ContentManager/Category/form.cfm">
				</table>

				</div>
			</div>
		</div>
		<br><br>
		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qLocale">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Locale">
			<cfinvokeargument name="FieldName" value="LocaleID">
			<cfinvokeargument name="FieldValue" value="#Val(MyCategoryLocale.GetProperty('LocaleID'))#">
			<cfinvokeargument name="SortFieldName" value="LocaleName">
			<cfinvokeargument name="SortOrder" value="Asc">
		</cfinvoke>
		<div>
			<div class="box1">
				<div class="boxtop1"><div></div></div>
				<div class="ModuleTitle1"><cfif qLocale.RecordCount IS "1">Additional Details<cfelse><cfoutput>#qLocale.LocaleName#</cfoutput> Version</cfif></div>
				<div class="ModuleBody1">
					<table width="90%" cellspacing="1" cellpadding="1">
					<tr>
						<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
						<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
						<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					</tr>
					<cfset FormMode="ShowForm">
					<cfinclude template="/common/modules/ContentManager/CategoryLocale/form.cfm">
					
					<cfswitch expression="#MyCategory.GetProperty('CategoryTypeID')#">
						<cfcase value="62">
							</table>
							<div class="RuleDotted1"></div>
							<strong>Product Family Details</strong>
							<div class="RuleSolid1"></div>
							<table width="90%" cellspacing="1" cellpadding="1">
							<tr>
								<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
								<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
								<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
							</tr>
							<cfinclude template="/common/modules/Product/ProductFamilyForm.cfm">
						</cfcase>
						<cfcase value="64">
							</table>
							<div class="RuleDotted1"></div>
							<strong>Product Details</strong>
							<div class="RuleSolid1"></div>
							<table width="90%" cellspacing="1" cellpadding="1">
							<tr>
								<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
								<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
								<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
							</tr>
							<cfinclude template="/common/modules/Product/ProductForm.cfm">
						</cfcase>
						<cfcase value="66">
							</table>
							<div class="RuleDotted1"></div>
							<strong>Article Details</strong>
							<div class="RuleSolid1"></div>
							<table width="90%" cellspacing="1" cellpadding="1">
							<tr>
								<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
								<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
								<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
							</tr>
							<cfinclude template="/common/modules/Product/ProductForm.cfm">
						</cfcase>
						<cfdefaultcase>
						</cfdefaultcase>
					</cfswitch>
					
					</table>
					<BR>
					<div class="RuleDotted1"></div>
					<div class="butContainerWysiwyg">
						<input type="button" class="cxlBut2"  name="ButCancel" value="" onClick="history.back()" title="Cancel this edit and go to the previous page.">
					    <input type="image" src="/common/images/admin/button_save.png" name="ButSubmit" value="Save" />
					</div>
				</div>
			</div>
		</div>
		</form>
	</cfcase>
	<cfcase value="ValidateEdit,ValidateAdd">
		<cfset FormMode="Validate">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cfif PageAction IS "ValidateAdd">
				<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#pid#">
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" omitlist="PageAction">
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
		</cfoutput>


		<div>
			<div class="box1">
				<div class="boxtop1"><div></div></div>
				<div class="ModuleTitle1">Page Details (Master)</div>
				<div class="ModuleBody1">
				<table width="90%" cellspacing="1" cellpadding="1">
				<tr>
					<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				</tr>
				<cfinclude template="/common/modules/ContentManager/Category/form.cfm">
				</table>
				</div>
			</div>
		</div>
		<br><br>
		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qLocale">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Locale">
			<cfinvokeargument name="FieldName" value="LocaleID">
			<cfinvokeargument name="FieldValue" value="#Val(MyCategoryLocale.GetProperty('LocaleID'))#">
			<cfinvokeargument name="SortFieldName" value="LocaleName">
			<cfinvokeargument name="SortOrder" value="Asc">
		</cfinvoke>
		<div>
			<div class="box1">
				<div class="boxtop1"><div></div></div>
				<div class="ModuleTitle1"><cfif qLocale.RecordCount IS "1">Additional Details<cfelse><cfoutput>#qLocale.LocaleName#</cfoutput> Version</cfif></div>
				<div class="ModuleBody1">
					<table width="90%" cellspacing="1" cellpadding="1">
					<tr>
						<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
						<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
						<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					</tr>
					<cfinclude template="/common/modules/ContentManager/CategoryLocale/form.cfm">
					</table>
					<BR>
					<div class="RuleDotted1"></div>
					<div>
						<input type="button" class="cxlBut2" name="ButCancel" value="Cancel" onClick="history.go(-2)" title="Cancel this edit and go to the previous page.">
						<input type="image" src="/common/images/admin/button_save.png" name="ButSubmit" value="Save">
					</div>
				</div>
			</div>
		</div>
		<cfset FormValid="No">
		<cfif MyCategoryLocale.GetCategoryTypeID() IS "73"><!--- This is a gallery  --->
			<cfif IsDefined("lFileToImport") and lFileToImport IS NOT "">
				<cfset FormValid="No">
			<cfelse>
				<cfif MyCategory.isCorrect()>
					<cfset FormValid="Yes">
				</cfif>
			</cfif>
		<cfelseif MyCategory.isCorrect()>
			<cfset FormValid="Yes">
			<!--- if article, check that article obj is valid --->
			<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66 AND NOT MyArticle.isCorrect()>
				<cfset FormValid="No">
			</cfif>
		</cfif>
		<cfif FormValid>
			<cfif MyCategory.GetProperty("CategoryID") LTE "0">
				<cfset GetCategoriesAtThisLevel=MyCategory.GetSiblingQuery()>
				<cfparam name="MaxCategoryPriority" default="0">
				<cfoutput query="GetCategoriesAtThisLevel">
					<cfif MaxCategoryPriority LTE CategoryPriority>
						<cfset MaxCategoryPriority = CategoryPriority>
					</cfif>
				</cfoutput>
				<cfset MyCategory.SetProperty("CategoryPriority",10+val(MaxCategoryPriority))>
			</cfif>
			
			<cfset MyCategory.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>

			<cfloop index="ThisImage" list="#lImageName#">
				<cfif Evaluate("FORM.Delete#ThisImage#") IS "1">
					<cfset MyCategoryLocale.FileRemove(APPLICATION.WebrootPath,"#ThisImage#")>
				</cfif>
			</cfloop>

			<cfif DeleteLocaleRecord>
				<cfset MyCategoryLocale.Delete(APPLICATION.TrashPath,SESSION.AdminUserID)>
			<cfelse>
				<cfset MyCategoryLocale.SetProperty("CategoryID",MyCategory.GetProperty("CategoryID"))>
				<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			</cfif>

			<cfswitch expression="#MyCategory.GetProperty('CategoryTypeID')#">
				<cfcase value="62">
					<cfset MyProductFamily.SetProperty("CategoryID",MyCategory.GetProperty("CategoryID"))>
					<cfset MyProductFamily.Save(APPLICATION.WebrootPath,SESSION.UserID)>
				</cfcase>
				<cfcase value="64">
					<cfset MyProduct.SetProperty("ProductID",MyCategory.GetProperty("CategoryID"))>
					<cfset MyProduct.Save(APPLICATION.WebrootPath,SESSION.UserID)>
				</cfcase>
				<cfdefaultcase>
				</cfdefaultcase>
			</cfswitch>
			
			<cfif Trim(ReturnURL) IS "">
				<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
				<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
				<cflocation url="#Location#?#querystring#" addtoken="No">
			<cfelse>
				<cflocation url="#ReturnURL#" addtoken="No">
			</cfif>
		<cfelse>
			<cfoutput><input type="hidden" name="PageAction" value="#PageAction#"></cfoutput>
		</cfif>
		</form>
	</cfcase>
	<cfcase value="CommitAdd,CommitEdit">

	</cfcase>
	<cfcase value="ValidateDelete">
		<div class="dashModuleWide">
		<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">Delete?</div>
		<div class="ModuleBody2">

		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="CommitDelete">
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
			<form action="#Location#?#querystring#" method="post">
		</cfoutput>
		<cfif MyCategory.ValidateDelete()>
			<cfoutput><P>Are you sure you want to delete the Category "#MyCategory.GetProperty('CategoryName')#" and its associated localized records from both staging and production?</P></cfoutput>
			<input type="image" src="/common/images/admin/button_delete.png" value="Delete">
		<cfelse>
			<cfoutput><P>You cannot delete the Category "#MyCategory.GetProperty('CategoryName')#" since it still contains content.</P></cfoutput>
		</cfif>
		</form>
		</div>
		<div class="boxbottom2"><div></div></div>
		</div>
		</div>
	</cfcase>
	<cfcase value="CommitDelete">
		<cfif MyCategory.ValidateDelete()>
			<cfset MyCategory.Delete(APPLICATION.TrashPath,SESSION.AdminUserID)>
		</cfif>
		<cfif Trim(ReturnURL) IS "">
			<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
		<cfelse>
			<cflocation url="#ReturnURL#" addtoken="No">
		</cfif>
	</cfcase>
	<cfcase value="View">
		<cfmodule template="/common/modules/ContentManager/Category/CategoryObject.cfm"
			Objectaction="View"
			WriteForm="No"
			EditCategoryID="#EditCategoryID#">
		<cfset Location=GetToken(FormAction,1,"?")>
		<cfset querystring=GetToken(FormAction,2,"?")>
		<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
		<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="Edit">
		<cfoutput>
			<a href="#Location#?#querystring#">Edit</A>
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="Add">
			<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#cid#" OmitList="Cid">
			<a href="#Location#?#querystring#">Add Subcategory</A>
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="ValidateDelete">
			<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			<a href="#Location#?#querystring#">Delete</A>
		</cfoutput>
	</cfcase>
	<cfcase value="CategoryList">
		<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
	</cfcase>
</cfswitch>

</cfmodule>

