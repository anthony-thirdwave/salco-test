<cfparam name="PageAction" default="ContentList">
<cfparam name="ATTRIBUTES.DrawHTML" default="1">
<cfparam name="EditContentID" default="-1">
<cfparam name="EditCategoryID" default="-1">
<cfparam name="EditPositionID" default="-1">
<cfparam name="EditContentLocaleID" default="-1">
<cfparam name="EditLocaleID" default="-1">

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

<cfif IsDefined("URL.coid")>
	<cfset EditContentID=Decrypt(URL.coid,APPLICATION.Key)>
</cfif>
<cfif IsDefined("URL.cid")>
	<cfset EditCategoryID=Decrypt(URL.cid,APPLICATION.Key)>
</cfif>
<cfif IsDefined("URL.pid")>
	<cfset EditPositionID=Decrypt(URL.pid,APPLICATION.Key)>
</cfif>
<cfif IsDefined("URL.lid")>
	<cfset EditLocaleID=Decrypt(URL.lid,APPLICATION.Key)>
</cfif>
<cfif EditContentID GT "0">
	<cfinvoke component="com.ContentManager.ContentHandler" 
		method="GetContentLocaleID" 
		returnVariable="EditContentLocaleID"
		ContentID="#EditContentID#"
		LocaleID="#EditLocaleID#">
</cfif>


<cfset cid=Encrypt(EditCategoryID,APPLICATION.Key)>
<cfset pid=Encrypt(EditPositionID,APPLICATION.Key)>
<cfset lid=Encrypt(EditLocaleID,APPLICATION.Key)>

<!--- Form values that don't make sense to be "" --->
<cfparam name="FORM.ContentActive" default="0">
<cfparam name="FORM.ContentIndexed" default="0">
<cfparam name="FORM.ContentLocaleActive" default="0">
<cfparam name="FORM.DefaultContentLocale" default="0">
<cfparam name="FORM.DeleteLocaleRecord" default="0">
<cfparam name="FORM.AllowMultipleRegistrations" default="0">

<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
<cfset MyContent.Constructor(Val(EditContentID))>
<cfset MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
<cfset MyContentLocale.Constructor(Val(EditContentLocaleID))>
<cfset MyContentLocale.SetProperty("ContentID",EditContentID)>
<cfset MyContentNote=CreateObject("component","com.ContentManager.ContentNote")>
<cfset MyContentNote.Constructor()>

<cfif Right(PageAction,3) IS "Add" and val(EditCategoryID) GT "0">
	<cfset MyContent.SetProperty("CategoryID",EditCategoryID)>
	<cfinvoke component="com.ContentManager.CategoryHandler" 
		method="GetCategoryTypeID" 
		CategoryID="#EditCategoryID#"
		returnVariable="ThisCategoryTypeID">
	<cfif ThisCategoryTypeID IS 71>
		<cfset MyContent.SetProperty("ContentTypeID",235)>
	</cfif>
	<cfif ThisCategoryTypeID IS 67>
		<cfset MyContent.SetProperty("ContentTypeID",221)>
	</cfif>
</cfif>
<cfif Right(PageAction,3) IS "Add">
	<cfset MyContent.SetProperty("ContentPositionID",EditPositionID)>
	<cfset MyContentLocale.SetContentPositionID(EditPositionID)>
</cfif>
<cfif Val(EditContentLocaleID) LTE "0">
	<cfset MyContentLocale.SetProperty("LocaleID",EditLocaleID)>
	<cfset MyContentLocale.SetContentTypeID(MyContent.GetProperty("ContentTypeID"))>
</cfif>

<cfif IsDefined("FORM.ContentName")>
	<cfif IsDefined("FORM.ButLoad") and FORM.ButLoad IS "Load">
		<cfset SourceContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
		<cfset SourceContentLocale.Constructor(Val(application.utilsObj.SimpleDecrypt(lclid)))>
		
		<cfloop index="PropertyToCopy" list="ContentID,ContentLocaleName,HTMLTemplate,ContentLocaleActive,PropertiesID,NumItems,HTML,Text,LinkURL,aText,TextPosition,Image,File,FileMimeID,FileSize,ImageLarge,Flash,Location,ContentAbstract,ContentPreview,TitleTypeID,lStateProvince,PageActionURL,NumItems,AllowMultipleRegistrations,lRelatedCategoryID,lMTCategoryIDRestrict,lMTCategoryIDAllow,CSSID,CSSClass,NumberOfMonths,lArticleCategoryID,ShowEventRangeID">
			<cfset MyContentLocale.SetProperty("#PropertyToCopy#",SourceContentLocale.GetProperty("#PropertyToCopy#"))>
		</cfloop>
	<cfelse>
		<!--- if the form is submitted, load the form values into the object --->
		
		<!--- MyContent Handling --->
		<cfif SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID OR Right(PageAction,3) IS "Add">
			<cfloop index="ThisProperty" list="ContentName,ContentTypeID,CategoryID,ContentActive,ContentIndexed,ShowProductRangeID,ShowNavigationRangeID,ShowQuestionRangeID,lArticleID,InheritID,SourceCategoryID,ContentDate1,ContentDate2,DisplayModeID,lTopicID,OwnerName,OwnerEmail,lPageID">
				<cfparam name="FORM.#ThisProperty#" default="">
				<cfset MyContent.SetProperty("#ThisProperty#",Evaluate("FORM.#ThisProperty#"))>
			</cfloop>
			<cfif MyContent.GetProperty("ContentTypeID") IS NOT "235">
				<cfif isDefined("FORM.SourceID")>
					<cfset MyContent.SetProperty("SourceID",FORM.SourceID)>
				</cfif>
			</cfif>
		</cfif>
		<cfif IsDefined("ContentNote")>
			<!--- MyContentNote Handling --->
			<cfset MyContentNote.SetProperty("ContentNote",ContentNote)>
			<cfset MyContentNote.SetProperty("ContentNoteDate",now())>
			<cfset MyContentNote.SetProperty("UserID",SESSION.AdminUserID)>
		</cfif>
		
		<!--- MyContentLocale Handling --->
		
		<!--- First set the contenttypeid since that determines what fields show up. --->
		<cfset MyContentLocale.SetContentTypeID(ContentTypeID)>
		<cfif IsDefined("FORM.HTML")>
			<cfset FORM.HTML=ReplaceNoCase(FORM.HTML,"</form>","</florm>","All")>
		</cfif>
		<cfif IsDefined("FORM.HTMLTemplate")>
			<cfset FORM.HTMLTemplate=ReplaceNoCase(FORM.HTMLTemplate,"</form>","</florm>","All")>
		</cfif>
		
		<cfloop index="ThisProperty" list="ContentLocaleName,ContentLocaleActive,ContentAbstract,HTML,HTMLTemplate,Text,SubTitle,LinkURL,TextPosition,TitleTypeID,DefaultContentLocale,Location,lStateProvince,PageActionURL,NumItems,AllowMultipleRegistrations,lRelatedCategoryID,lMTCategoryIDRestrict,lMTCategoryIDAllow,CSSID,CSSClass,NumberOfMonths,lArticleCategoryID,ShowEventRangeID">
			<cfparam name="FORM.#ThisProperty#" default="">
			<cfset MyContentLocale.SetProperty("#ThisProperty#",Evaluate("FORM.#ThisProperty#"))>
		</cfloop>
		<cfif MyContent.GetProperty("ContentTypeID") IS "234" and IsDefined("SourceID")>
			<cfset MyContentLocale.SetContentTemplateID(SourceID)>
			<cfset MyContentLocale.InitializeHTMLStructure()>
			<cfset ThisTokenList=MyContentLocale.GetTokenList()>
			<cfif IsDefined("sHTML_#ListFirst(ThisTokenList)#")>
				<cfset thissHTML=MyContentLocale.GetProperty("sHTML")>
				<cfloop index="ThisToken" list="#ThisTokenList#">
					<cfset StructInsert(ThissHTML,ThisToken,Evaluate("sHTML_#ThisToken#"),1)>
				</cfloop>
				<cfset MyContentLocale.SetProperty("sHTML",ThissHTML)>
			</cfif>
		</cfif>
		<cfif MyContent.GetProperty("ContentTypeID") IS "251">
			<cfset MyContent.ContentTemplateID=SourceID>
		</cfif>
		<cfif isDefined("FORM.aText_1") OR IsDefined("FORM.aText_New")>
			<cfset aText=arrayNew(1)>
			<cfloop index="r" from="1" to="#NumText#" step="1">
				<cfparam name="aText_#r#" default="">
				<cfif Trim(Evaluate("aText_#r#")) IS NOT "">
					<cfset ArrayAppend(aText,Trim(Evaluate("aText_#r#")))>
				</cfif>
			</cfloop>
			<cfif Trim(aText_New) IS NOT "">
				<cfset ArrayAppend(aText,Trim(aText_New))>
			</cfif>
			<cfset MyContentLocale.SetProperty("aText",aText)>
		</cfif>
		
		<cfif isDefined("FORM.LinkURL_1") OR IsDefined("FORM.LinkURL_New")>
			<cfset aLink=arrayNew(1)>
			<cfif IsDefined("FORM.LinkURL_1")>
				<cfloop index="r" from="1" to="#NumLinks#" step="1">
					<cfparam name="FORM.LinkURL_#r#" default="">
					<cfparam name="FORM.LinkTitle_#r#" default="">
					<cfparam name="FORM.LinkCaption_#r#" default="">
					<cfparam name="FORM.LinkDelete_#r#" default="0">
					<cfif Trim(Evaluate("FORM.LinkURL_#r#")) NEQ "" AND Evaluate("FORM.LinkDelete_#r#") EQ 0>
						<cfif Trim(Evaluate("FORM.LinkTitle_#r#")) EQ "">
							<Cfset SetVariable("FORM.LinkTitle_#r#",Evaluate("FORM.LinkURL_#r#"))>
						</cfif>
						<cfset sElement=StructNew()>
						<cfset StructInsert(sElement,"Title",Evaluate("FORM.LinkTitle_#r#"),1)>
						<cfset StructInsert(sElement,"Caption",Evaluate("FORM.LinkCaption_#r#"),1)>
						<cfset StructInsert(sElement,"URL",Evaluate("FORM.LinkURL_#r#"),1)>
						<cfset ArrayAppend(aLink,sElement)>
					</cfif>
				</cfloop>
			</cfif>
			<cfif IsDefined("FORM.LinkURL_New") AND Trim(FORM.LinkURL_New) IS NOT "">
				<cfif Trim(FORM.LinkTitle_New) EQ "">
					<cfset FORM.LinkTitle_New = FORM.LinkURL_New>
				</cfif>
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"Title",FORM.LinkTitle_New,1)>
				<cfset StructInsert(sElement,"Caption",FORM.LinkCaption_New,1)>
				<cfset StructInsert(sElement,"URL",FORM.LinkURL_New,1)>
				<cfset ArrayAppend(aLink,sElement)>
			</cfif>
			
			<cfloop index="r" from="1" to="#ArrayLen(aLink)#" step="1">
				<cfif isdefined("LinkButtonSubmit_up_#r#.x") OR isdefined("LinkButtonSubmit_down_#r#.x")>
					<cfif isdefined("LinkButtonSubmit_up_#r#.x")>
						<cfset TempStruct=aLink[r]>
						<cfset aLink[r]=aLink[r-1]>
						<cfset aLink[r-1]=TempStruct>
					<cfelseif isdefined("LinkButtonSubmit_down_#r#.x")>
						<cfset TempStruct=aLink[r]>
						<cfset aLink[r]=aLink[r+1]>
						<cfset aLink[r+1]=TempStruct>
					</cfif>
				</cfif>
			</cfloop>
			
			<cfset MyContentLocale.SetProperty("aLink",aLink)>
			
		</cfif>
		
		<cfif IsDefined("FORM.Image1")>
			<cfset MyContentLocale.FormFileListUpload("Image","#APPLICATION.WebrootPath#")>
		</cfif>
		<cfloop index="ThisImage" list="Image,ImageRollover,Flash,ImageLarge,File,ImageThumbnail">
			<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
				<cfset MyContentLocale.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
			</cfif>
		</cfloop>
		
		<cfif IsDefined("FileName_New") OR IsDefined("NumFiles")>
			<cfset sView=StructNew()>
			<cfset lOrder="">
			<cfloop index="r" from="1" to="#NumFiles#" step="1">
				<cfparam name="FileName_#r#" default="">
				<cfparam name="FileSubTitle_#r#" default="">
				<cfparam name="Author_#r#" default="">
				<cfparam name="FileDuration_#r#" default="">
				<cfparam name="FileKeywords_#r#" default="">
				<cfparam name="FileDateTimeStamp_#r#" default="">
				<cfparam name="FileCaption_#r#" default="">
				<cfparam name="MainFilePath_#r#" default="">
				<cfparam name="ThumbnailPath_#r#" default="">
				<cfparam name="FileDelete_#r#" default="0">
				<cfparam name="FileSize_#r#" default="0">
				<cfif Evaluate("FileName_#r#") IS NOT "" AND Evaluate("FileDelete_#r#") IS "0">
					<cfloop index="ThisImage" list="MainFilePath,ThumbnailPath">
						<cfif IsDefined("FORM.#ThisImage#_#r#FileObject") AND evaluate("FORM.#ThisImage#_#r#FileObject") IS NOT "">
							<cffile action="UPLOAD" 
								filefield="FORM.#ThisImage#_#r#FileObject" 
								destination="#MyContentLocale.GetResourceFilePath('documents',APPLICATION.WebrootPath)#"
								nameconflict="MAKEUNIQUE">
							<cfset UploadedFile=File.ServerDirectory & "\" & File.ServerFile>
							<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
								<cffile action="DELETE" file="#UploadedFile#">
								<!--- add AddError('aProductViews') here --->
							<cfelse>
								<cfset SetVariable("#ThisImage#_#r#",application.utilsObj.GetURLFromPath(UploadedFile))>
							</cfif>
						</cfif>
					</cfloop>
					<cfset sElement=StructNew()>
					<cfset StructInsert(sElement,"FileName",Evaluate("FileName_#r#"),1)>
					<cfset StructInsert(sElement,"FileSubTitle",Evaluate("FileSubtitle_#r#"),1)>
					<cfset StructInsert(sElement,"Author",Evaluate("Author_#r#"),1)>
					<cfset StructInsert(sElement,"FileDuration",Evaluate("FileDuration_#r#"),1)>
					<cfset StructInsert(sElement,"FileKeywords",Evaluate("FileKeywords_#r#"),1)>
					<cfset StructInsert(sElement,"FileDateTimeStamp",Evaluate("FileDateTimeStamp_#r#"),1)>
					<cfset StructInsert(sElement,"FileCaption",Evaluate("FileCaption_#r#"),1)>
					<cfset StructInsert(sElement,"FilePath",Evaluate("MainFilePath_#r#"),1)>
					<cfset StructInsert(sElement,"ThumbnailPath",Evaluate("ThumbnailPath_#r#"),1)>
					<cfset StructInsert(sElement,"FileSize",Evaluate("FileSize_#r#"),1)>
					<cfset StructInsert(sElement,"Order",Evaluate("Order_#r#"),1)>
					<cfif Evaluate("MainFilePath_#r#") IS NOT "">
						<cfset ThisDir="#application.utilsObj.GetPathFromURL(Evaluate('MainFilePath_#r#'))#">
						<cfset ThisDir=ListDeleteAt(ThisDir,ListLen(ThisDir,"\"),"\")>
						<cfdirectory action="LIST" directory="#ThisDir#" name="qDir">
						<cfquery name="qDir2" dbtype="query">
							select * from qDir Where Name='#ListLast(Evaluate('MainFilePath_#r#'),'/')#'
						</cfquery>
						<cfif Val(qDir2.Size) GT "0">
							<cfset StructInsert(sElement,"FileSize",Val(qDir2.Size),1)>
						</cfif>
					</cfif>
					<cfset ThisKey="#NumberFormat(Val(Evaluate('Order_#r#')),'000')#_#application.utilsObj.Scrub(Evaluate('FileName_#r#'))#">
					<cfset StructInsert(sView,ThisKey,sElement,"1")>
					<cfset lOrder=ListAppend(lOrder,ThisKey)>
				</cfif>
			</cfloop>
			
			<cfset aView=ArrayNew(1)>
			<cfset lOrder=ListSort(lOrder,text)>
			<cfloop index="ThisOrder" list="#lOrder#">
				<Cfset ArrayAppend(aView,sView[ThisOrder])>
			</cfloop>
			
			<cfif Isdefined("FORM.FileName_New") AND Trim(FORM.FileName_New) IS NOT "">
				<cfloop index="ThisImage" list="MainFilePath">
					<cfparam name="#ThisImage#_New" default="">
					<cfif IsDefined("FORM.#ThisImage#_NewFileObject") AND evaluate("FORM.#ThisImage#_NewFileObject") IS NOT "">
						<cffile action="UPLOAD" 
							filefield="FORM.#ThisImage#_newFileObject" 
							destination="#MyContentLocale.GetResourceFilePath('documents',APPLICATION.WebrootPath)#"
							nameconflict="MAKEUNIQUE">
						<cfset UploadedFile=File.ServerDirectory & "\" & File.ServerFile>
						<cfif ListFindNoCase("#APPLICATION.MasterFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
							<cffile action="DELETE" file="#UploadedFile#">
							<!--- add AddError('aProductViews') here --->
						<cfelse>
							<cfset SetVariable("#ThisImage#_New",application.utilsObj.GetURLFromPath(UploadedFile))>
						</cfif>
					</cfif>
				</cfloop>
				<cfset sElement=StructNew()>
				<cfset StructInsert(sElement,"FileName",FileName_New,1)>
				<cfset StructInsert(sElement,"FileCaption",FileCaption_New,1)>
				<cfset StructInsert(sElement,"FilePath",MainFilePath_New,1)>
				<cfset StructInsert(sElement,"ThumbnailPath","",1)>
				<cfset ArrayAppend(aView,sElement)>
			</cfif>

			<cfset MyContentLocale.SetProperty("aFile",aView)>
		</cfif>
	</cfif>
</cfif>

<cfset PageAction=Trim(PageAction)>

<cfif PageAction IS "ValidateEdit" OR PageAction IS "ValidateAdd">
	<cfif NOT IsDefined("FORM.ButSubmit")>
		<cfset PageAction=ReplaceNoCase(PageAction,"Validate","","All")>
	</cfif>
</cfif>

<cfset PageTitle="Add Content">
<cfif EditContentID GT "0">
	<cfif MyContentLocale.GetProperty("ContentLocaleName") IS NOT "">
		<cfset PageTitle="#MyContentLocale.GetProperty('ContentLocaleName')#">
	<cfelse>
		<cfset PageTitle="#MyContent.GetProperty('ContentName')#">
	</cfif>
</cfif>
<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Content Details"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | <a href=""/common/admin/masterview/"">Content Manager</A> | #PageTitle#">



<cfif IsDefined("FORM.ButPreview") And Mycontent.isCorrect() and MyContentLocale.isCorrect()>
	<cfset MyContentPreview=CreateObject("component","com.ContentManager.Content")>
	<cfset MyContentPreview.Constructor()>
	<cfloop index="PropertyToCopy" list="ContentName,ContentTypeID,CategoryID,ContentActive,ContentIndexed,SourceID,ShowProductRangeID,ShowNavigationRangeID,ShowQuestionRangeID,lArticleID,lRelatedCategoryID,InheritID,SourceCategoryID,DisplayModeID,lPageID">
		<cfset MyContentPreview.SetProperty("#PropertyToCopy#",MyContent.GetProperty("#PropertyToCopy#"))>
	</cfloop>
	
	<cfset MyContentPreview.SetProperty("ContentID",-1)>
	<cfset MyContentPreview.SetProperty("ContentPositionID",403)>
	<cfset MyContentPreview.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
	<cfset MyContentLocalePreview=CreateObject("component","com.ContentManager.ContentLocale")>
	<cfset MyContentLocalePreview.Constructor()>
	<cfloop index="PropertyToCopy" list="LocaleID,ContentLocaleName,HTMLTemplate,ContentLocaleActive,PropertiesID,NumItems,HTML,Text,LinkURL,aText,TextPosition,Image,File,FileMimeID,FileSize,ImageLarge,Flash,Location,ContentAbstract,ContentPreview,TitleTypeID,sHTML,ImageRollover,Flash,ImageLarge,aFile">
		<cfset MyContentLocalePreview.SetProperty("#PropertyToCopy#",MyContentLocale.GetProperty("#PropertyToCopy#"))>
	</cfloop>
	
	<cfset MyContentLocalePreview.SetProperty("ContentLocaleID",-1)>
	<cfset MyContentLocalePreview.SetProperty("ContentID",MyContentPreview.GetProperty("ContentID"))>
	<cfset MyContentLocalePreview.setContentPositionID(403)>
	<cfset MyContentLocalePreview.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
	<cfset pcid=application.utilsObj.SimpleEncrypt(MyContentPreview.GetProperty("ContentID"))>
	<cfset prcid=application.utilsObj.SimpleEncrypt(MyContent.GetProperty("ContentID"))>
	<cfinvoke component="com.ContentManager.CategoryHandler" 
		method="GetCategoryBasicDetails"
		CategoryID="#MyContent.GetProperty('CategoryID')#"
		returnVariable="qGetCategoryBasicDetails">
	<cfoutput>
	<script>
		window.open('#APPLICATION.contentPageInUrl#/#qGetCategoryBasicDetails.CategoryAlias#?pcid=#URLEncodedFormat(pcid)#&prcid=#URLEncodedFormat(prcid)#','cmspreview');
	</script>
	</cfoutput>
</cfif>


<cfif ListFindNoCase("Add,Edit,ValidateDelete",PageAction) AND NOT IsDefined("ReturnURL")>
	<cfset ReturnURL=CGI.HTTP_Referer>
</cfif>
			
<cfset OpenAndCloseFormTables="No">
<cfswitch expression="#Trim(PageAction)#">
	<cfcase value="Edit,Add">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cfif PageAction IS "Add">
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
				<cfif SESSION.AdminUserLocaleID IS "1" and MyContentLocale.GetProperty("LocaleID") IS APPLICATION.DefaultLocaleID>
					<cfset MyContentLocale.SetProperty("DefaultContentLocale",1)>
				</cfif>
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="coid" value="#coid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
			<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#pid#">
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
			<form id="contentForm" name="contentForm" action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
		</cfoutput>
		
		<cfoutput><input type="hidden" name="PageAction" value="Validate#PageAction#"></cfoutput>
		<cfif SESSION.AdminCurrentAdminLocaleID IS NOT APPLICATION.DefaultLocaleID and PageAction IS "Edit">
			<cfinvoke component="com.ContentManager.ContentHandler" 
				method="GetOtherContentLocale" 
				returnVariable="GetOtherContentLocale"
				ContentID="#EditContentID#">
			<cfif ValueList(GetOtherContentLocale.ContentLocaleID) IS NOT MyContentLocale.GetProperty("ContentLocaleID")>
				<div style="padding-bottom:10px;" align="right">Load Content From:
				<select name="lclid">
					<option value="-1">Select...</option>
					<cfoutput query="GetOtherContentLocale">
						<cfif ContentLocaleID IS NOT MyContentLocale.GetProperty("ContentLocaleID")>
							<option value="#application.utilsObj.SimpleEncrypt(ContentLocaleID)#">#LocaleName#</option>
						</cfif>
					</cfoutput>
				</select> <input type="submit" name="ButLoad" value="Load"></div>
			</cfif>
		</cfif>
	<div>
		<div class="box1">
			<div class="boxtop1"><div></div></div>
			<div class="ModuleTitle1">Enter Block Info</div>
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
					<cfif MyContentLocale.GetProperty("LocaleID") IS APPLICATION.DefaultLocaleID>
						<cfset FormMode="ShowForm">
					<cfelse>
						<cfinvoke component="com.ContentManager.ContentHandler" 
							method="GetOtherContentLocale" 
							returnVariable="GetOtherContentLocale"
							ContentID="#EditContentID#">
						<cfif ValueList(GetOtherContentLocale.ContentLocaleID) IS MyContentLocale.GetProperty("ContentLocaleID")>
							<cfset FormMode="ShowForm">
						<cfelse>
							<cfset FormMode="Validate">
						</cfif>
					</cfif>
				<cfelse>
					<cfinvoke component="com.ContentManager.ContentHandler" 
						method="GetOtherContentLocale" 
						returnVariable="GetOtherContentLocale"
						ContentID="#EditContentID#">
					<cfif ValueList(GetOtherContentLocale.ContentLocaleID) IS MyContentLocale.GetProperty("ContentLocaleID")>
						<cfset FormMode="ShowForm">
					<cfelse>
						<cfset FormMode="Validate">
					</cfif>
				</cfif>
			</cfif>
	
			<cfinclude template="/common/modules/ContentManager/Content/form.cfm">
			<!--- <cfinclude template="/common/modules/ContentManager/ContentNote/form.cfm"> --->
			</table>
			</div>
		</div>
	</div>
	<br><br>
	<div>
		<div class="box1">
			<div class="boxtop1"><div></div></div>
			<div class="ModuleTitle1">Content</div>
			<div class="ModuleBody1">
				<table width="90%" cellspacing="1" cellpadding="1" border="0">
				<tr>
					<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				</tr>
				<cfset FormMode="ShowForm">
				<cfswitch expression="#MyContent.GetProperty('ContentTypeID')#">
					<cfcase value="235">
						<cfinclude template="/common/modules/ContentManager/event/form.cfm">
					</cfcase>
				</cfswitch>
				<cfinclude template="/common/modules/ContentManager/ContentLocale/form.cfm">
				</table>
		    <BR>
				<div class="RuleDotted1"></div>
				<div class="butContainerWysiwyg">
					<CF_Venn
						ListA="HTML,HTMLTemplate,sHTML"
						ListB="#MyContentLocale.GetRestrictionsPropertyList()#"
						AandB="TestList">
					<cfif ListLen(TestList) GT "0">
						<input type="image" src="/common/images/admin/button_process.png" name="ButProcess" value="Process" title="If there are any images or documents linked to in the content areas, press this button for the CMS to prompt you to upload them.">
					</cfif>
					<input type="image" src="/common/images/admin/button_preview.png" name="ButPreview" value="Preview" title="Preview this content in the site layout without saving changes to database.">
					<input type="button" name="ButCancel2"  onclick="window.location='/common/admin/MasterView/index.cfm?MVEid=1&mvcid=<cfoutput>#MyContent.GetProperty('CategoryID')#</cfoutput>'" class="cxlBut" title="Cancel this edit and go to the Content Manager." />
			      <input type="image" src="/common/images/admin/button_save.png" name="ButSubmit" id="ButSubmit" value="Save" title="Save this content element to the database.">
                  <span class="clearit"></span>
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
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="coid" value="#coid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="pid" value="#pid#">
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
			<form id="contentForm" name="contentForm"  action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
		</cfoutput>
	<div>
		<div class="box1">
			<div class="boxtop1"><div></div></div>
			<div class="ModuleTitle1">Enter Block Info</div>
			<div class="ModuleBody1">
			<table width="90%" cellspacing="1" cellpadding="1" border="0">
			<tr>
				<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			</tr>
			<cfinclude template="/common/modules/ContentManager/Content/form.cfm">
			<cfswitch expression="#MyContent.GetProperty('ContentTypeID')#">
				<cfcase value="235">
					<cfinclude template="/common/modules/ContentManager/event/form.cfm">
				</cfcase>
			</cfswitch>
			</table>
			</div>
		</div>
	</div>
	<br/><br/>
	<div>
		<div class="box1">
			<div class="boxtop1"><div></div></div>
			<div class="ModuleTitle1">Content</div>
			<div class="ModuleBody1">
				<table width="100%" cellspacing="1" cellpadding="2">
				<tr>
					<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				</tr>
				<cfinclude template="/common/modules/ContentManager/ContentLocale/form.cfm">
				<!--- <cfinclude template="/common/modules/ContentManager/ContentNote/form.cfm"> --->
				</table>
				<BR>
				<div class="RuleDotted1"></div>
				<div>
					<input type="button" class="cxlBut2" name="ButCancel" value="Cancel" onClick="window.location = '/common/admin/MasterView/index.cfm?MVEid=1&mvcid=<cfoutput>#MyContent.GetProperty('CategoryID')#</cfoutput>'" title="Cancel this edit and go to the Content Manager.">
					<input type="image" src="/common/images/admin/button_save.png" name="ButSubmit" id="ButSubmit" value="Save">
				</div>
			</div>
		</div>
	</div>
		<cfset FormValid="No">
		<cfswitch expression="#MyContent.GetProperty('ContentTypeID')#">
			<cfcase value="235">
				<cfif MyContent.isCorrect() AND MyContentLocale.isCorrect() and MyEvent.isCorrect()>
					<cfset FormValid="Yes">
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfif MyContent.isCorrect() AND MyContentLocale.isCorrect()>
					<cfset FormValid="Yes">
				</cfif>
			</cfdefaultcase>
		</cfswitch>
		<cfif FormValid>
			<cfif ListLen(MyContentLocale.GetFileList(),";") IS "0" or 1>
				<cfset thisContentID = MyContent.GetProperty("contentID")>
				<!--- if no errors and no files, then save without confirmation screen. --->
				<cfswitch expression="#MyContent.GetProperty('ContentTypeID')#">
					<cfcase value="235">
						<cfset MyEvent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
						<cfset MyContent.SetProperty("SourceID",MyEvent.GetProperty("EventID"))>
					</cfcase>
				</cfswitch>
				
				<cfset MyContent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
				<cfset MyContentNote.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
				<cfset MyContentNote.Save()>
				
				<cfif val(thisContentID) LTE 0>
					<!--- When adding new content, for the specified content types, create a new discussion entry --->
					<cfswitch expression="#MyContent.GetProperty('ContentTypeID')#">
						<cfcase value="235">
							<!--- Get the correct discussion id --->
							<cfquery name="qDiscussionID" datasource="#APPLICATION.DSN#">
								SELECT		MTDefaultDiscussionID
								FROM		t_locale
								WHERE		localeID = <cfqueryparam value="#val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
							</cfquery>
							<!--- Create a new discussion entry --->
							<cfinvoke component="com.discussion.discussionHandler" method="setEntry" returnVariable="entryID">
								<cfinvokeargument name="Datasource" value="#APPLICATION.mtDSN#"/>
								<cfinvokeargument name="discussionID" value="#qDiscussionID.MTDefaultDiscussionID#"/>
								<cfinvokeargument name="title" value="#form.contentName#"/>
							</cfinvoke>
							<!--- Attach entry to content --->
							<cfinvoke component="com.ContentManager.ContentHandler" method="attachDiscussionEntry">
								<cfinvokeargument name="contentID" value="#MyContent.GetProperty("contentID")#"/>
								<cfinvokeargument name="entryID" value="#entryID#"/>
							</cfinvoke>
						</cfcase>
					</cfswitch>
				</cfif>
				
				<cfif DeleteLocaleRecord>
					<cfset MyContentLocale.Delete(APPLICATION.TrashPath,SESSION.AdminUserID)>
				<cfelse>
					<cfloop index="ThisImage" list="Image,flash,ImageLarge">
						<cfif IsDefined("FORM.Delete#ThisImage#") AND Evaluate("FORM.Delete#ThisImage#") IS "1">
							<cfset MyContentLocale.FileRemove(APPLICATION.WebrootPath,"#ThisImage#")>
						</cfif>
					</cfloop>
					<cfset MyContentLocale.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
					<cfset MyContentLocale.SetProperty("HTML",ReplaceNoCase(MyContentLocale.GetProperty("HTML"),"</florm>","</form>","All"))>
					<cfset MyContentLocale.SetProperty("HTMLTemplate",ReplaceNoCase(MyContentLocale.GetProperty("HTMLTemplate"),"</florm>","</form>","All"))>
					<cfset MyContentLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			
					<!--- do ultraseek indexing
					<cfinvoke component="com.UltraSeek.Search" 
						method="IndexByCategoryID" 
						CategoryID="#MyContent.GetProperty('CategoryID')#"/> --->
					<!--- if neccessary, regenerate rss --->
					<cfif MyContent.GetProperty('ContentTypeID') EQ 264>
						<cfmodule template="/common/modules/RSS/rss.cfm" ProcessMode="Generate" ContentID="#MyContent.GetProperty('ContentID')#" CategoryID="#MyContent.GetProperty('CategoryID')#">
					</cfif>
					
					<cfif Trim(ReturnURL) IS "">
						<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
						<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
						<!--- <cf_AddToQueryString querystring="#QueryString#" name="UpperIDList" value="#UpperIDList#"> --->
						<cflocation url="#Location#?#querystring#" addtoken="No">
					<cfelse>
						<cflocation url="#ReturnURL#" addtoken="No">
					</cfif>
				</cfif>
			<cfelse>
				<cfif PageAction IS "ValidateAdd">
					<input type="hidden" name="PageAction" value="CommitAdd">
				<cfelse>
					<input type="hidden" name="PageAction" value="CommitEdit">
				</cfif>
			</cfif>
		<cfelse>
			<cfoutput><input type="hidden" name="PageAction" value="#PageAction#"></cfoutput>
		</cfif>
		</form>
	</cfcase>
	<cfcase value="CommitAdd,CommitEdit">
		<cfabort showerror="Tom says this case is no more.">
		<!---
		<cfdump var="#form#">
		<cfdump var="#application#">
		<cfabort>

		<cfswitch expression="#MyContent.GetProperty('ContentTypeID')#">
			<cfcase value="235">
				<cfset MyEvent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
				<cfset MyContent.SetProperty("SourceID",MyEvent.GetProperty("EventID"))>
			</cfcase>
		</cfswitch>
		<cfset MyContent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
		<cfset MyContentNote.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
		<cfset MyContentNote.Save()>
		<cfif DeleteLocaleRecord>
			<cfset MyContentLocale.Delete(APPLICATION.TrashPath,SESSION.AdminUserID)>
		<cfelse>
			<cfloop index="ThisImage" list="Image,flash,ImageLarge">
				<cfif IsDefined("FORM.Delete#ThisImage#") AND Evaluate("FORM.Delete#ThisImage#") IS "1">
					<cfset MyContentLocale.FileRemove(APPLICATION.WebrootPath,"#ThisImage#")>
				</cfif>
			</cfloop>
			<cfset MyContentLocale.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
			<cfset MyContentLocale.SetProperty("HTML",ReplaceNoCase(MyContentLocale.GetProperty("HTML"),"</florm>","</form>","All"))>
			<cfset MyContentLocale.SetProperty("HTMLTemplate",ReplaceNoCase(MyContentLocale.GetProperty("HTMLTemplate"),"</florm>","</form>","All"))>
			<cfset MyContentLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
		</cfif>
		
		<cfif Trim(ReturnURL) IS "">
			<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
			<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
			<!--- <cf_AddToQueryString querystring="#QueryString#" name="UpperIDList" value="#UpperIDList#"> --->
			<cflocation url="#Location#?#querystring#" addtoken="No">
		<cfelse>
			<cflocation url="#ReturnURL#" addtoken="No">
		</cfif>
		--->
	</cfcase>
	<cfcase value="ValidateDelete">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cf_AddToQueryString querystring="#QueryString#" name="coid" value="#coid#">
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="CommitDelete">
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
			<form action="#Location#?#querystring#" method="post">
		</cfoutput>
		<cfoutput><P>Are you sure you want to delete the content "#MyContent.GetProperty('ContentName')#" from the site? Any associated localized content records will be deleted. In addition, if this content element is repeated elsewhere on the site, those instances will be deleted as well.</P></cfoutput>
		<input type="image" src="/common/images/admin/button_delete.png" value="Delete">
		</form>
	</cfcase>
	<cfcase value="CommitDelete">
		<cfset MyContent.Delete(APPLICATION.TrashPath,SESSION.AdminUserID)>
		<cfif Trim(ReturnURL) IS "">
			<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
		<cfelse>
			<cflocation url="#ReturnURL#" addtoken="No">
		</cfif>
	</cfcase>
	<cfcase value="ContentList">
		<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
	</cfcase>
</cfswitch>


</cfmodule>

