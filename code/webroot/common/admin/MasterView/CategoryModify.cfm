<cfparam name="PageAction" default="CategoryList">
<cfparam name="ATTRIBUTES.DrawHTML" default="1">
<cfparam name="EditCategoryID" default="-1">
<cfparam name="EditParentID" default="-1">
<cfparam name="EditCategoryLocaleID" default="-1">
<cfparam name="EditLocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="CurrentLanguageID" default="100">
<cfparam name="FormLanguageID" default="#CurrentLanguageID#">
<cfset OpenAndCloseFormTables="no">

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

<cfset lImageName="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative">
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
	<cfif IsDefined("FORM.ButLoad2") and FORM.ButLoad2 IS "Load" AND Val(lclid) GTE "1">
		<cfset SourceCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
		<cfset SourceCategoryLocale.Constructor(Val(application.utilsObj.SimpleDecrypt(lclid)))>
		<cfloop index="PropertyToCopy" list="CategoryID,CategoryLocaleName,CategoryLocaleActive,CategoryLocaleURL,MetaKeywords,MetaDescription,ProductPrice,ProductFamilyDescription,CallToActionURL,CategoryLocaleNameAlternative,Byline1,Byline2,Title,#lImageName#">
			<cfset MyCategoryLocale.SetProperty("#PropertyToCopy#",SourceCategoryLocale.GetProperty("#PropertyToCopy#"))>
		</cfloop>
	<cfelse>
		<!--- if the form is submitted, load the form values into the object --->
	
		<!--- Handling MyCategory --->
		<cfloop index="ThisProperty" list="CategoryTypeID,ParentID,CategoryName,CategoryAlias,CategoryActive,CategoryURL,MetaKeywords,MetaDescription,WorkflowStatusID,TemplateID,ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer,ProductionDBName,ProductionDBDSN,AuthorName,ArticleSourceID,AllowComments,AllowBackToTop,ProductBrandLogoID,ProductConsoleTypeID,ProductProgramTypeID,ColorID,ShowInNavigation,CategoryIndexed,PressReleaseDate,UserloginAccess,lTopicID,foobar"><!--- juno --->
			<cfparam name="FORM.#ThisProperty#" default="">
			<cfset MyCategory.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
		</cfloop>
		<cfloop index="ThisImage" list="">
			<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
				<cfset MyCategory.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
			</cfif>
		</cfloop>
	
		<!--- Handling MyCategoryLocale --->
		<cfset MyCategoryLocale.SetCategoryTypeID(CategoryTypeID)>
		<cfloop index="ThisProperty" list="CategoryLocaleName,CategoryLocaleActive,CategoryLocaleURL,MetaKeywords,MetaDescription,ProductPrice,ProductFamilyDescription,CallToActionURL,CategoryLocaleNameAlternative,DefaultCategoryLocale,Byline1,Byline2,Title,PageTitleOverride">
			<cfparam name="FORM.#ThisProperty#" default="">
			<cfset MyCategoryLocale.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
		</cfloop>
	
		<cfloop index="ThisImage" list="#lImageName#">
			<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
				<cfset MyCategoryLocale.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
			<cfelseif IsDefined("FORM.#ThisImage#")>
				<cfset MyCategoryLocale.SetProperty(ThisImage,evaluate("FORM.#ThisImage#"))>
			</cfif>
		</cfloop>

<!---		
		<!--- If Article, Handle MyArticle --->
		<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66>
			<cfloop index="ThisProperty" list="JournalCategoryID,ContributorName,Date,Abstract,ContributorBio,ContributorBioExtended,Quote">
				<cfparam name="FORM.#ThisProperty#" default="">
				<cfset MyArticle.SetProperty("#ThisProperty#","#Trim(Evaluate('FORM.#ThisProperty#'))#")>
			</cfloop>
			<cfloop index="ThisImage" list="PortraitPath">
				<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
					<cfset MyArticle.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
				<cfelseif IsDefined("FORM.#ThisImage#")>
					<cfset MyArticle.SetProperty(ThisImage,evaluate("FORM.#ThisImage#"))>
				</cfif>
			</cfloop>
		</cfif>
		--->
		
	</cfif>
</cfif>

<cfset PageAction=Trim(PageAction)>

<cfif PageAction IS "ValidateEdit" OR PageAction IS "ValidateAdd">
	<cfif NOT IsDefined("FORM.ButSubmit")>
		<cfset PageAction=ReplaceNoCase(PageAction,"Validate","","All")>
	</cfif>
</cfif>



<cfset PageTitle="Add Page">
<cfif EditCategoryID GT "0">
	<cfif MyCategoryLocale.GetProperty("CategoryLocaleName") IS NOT "">
		<cfset PageTitle="#MyCategoryLocale.GetProperty('CategoryLocaleName')#">
	<cfelse>
		<cfset PageTitle="#MyCategory.GetProperty('CategoryName')#">
	</cfif>
</cfif>
<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Page Details"
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
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
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
				<div class="ModuleTitle1"><cfoutput>#qLocale.LocaleName#</cfoutput> version</div>
				<div class="ModuleBody1">
					<table width="90%" cellspacing="1" cellpadding="1">
					<tr>
						<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
						<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
						<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					</tr>
					<cfset FormMode="ShowForm">
					<cfinclude template="/common/modules/ContentManager/CategoryLocale/form.cfm">
					<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66>
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
						<cfinclude template="/common/modules/Article/form.cfm">
					</cfif>
					</table>
					<BR>
					<div class="RuleDotted1"></div>
					<div class="butContainerWysiwyg">
						<input type="button" class="cxlBut2"  name="ButCancel" value="" onClick="history.back()" title="Cancel this edit and go to the previous page.">
					    <input type="image" src="/common/images/admin/button_save.png" name="ButSubmit2" value="Save" />
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
				<div class="ModuleTitle1"><cfoutput>#qLocale.LocaleName#</cfoutput> version</div>
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
			<!--- if article, handle article object --->
<!---			<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66>
				<cfif FORM.DeletePortraitPath IS "1">
					<cfset MyArticle.FileRemove(APPLICATION.WebrootPath,"PortraitPath")>
				</cfif>
				<cfset MyArticle.SetProperty("LastModifiedBy",SESSION.AdminUserID)>
				<cfset MyArticle.Save()>
				<cfset MyCategory.SetProperty("SourceID",MyArticle.GetProperty("ArticleID"))>
			</cfif>--->
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
			<!--- if article, make sure categoryid is set --->
	<!---		<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66 AND (Val(MyArticle.GetProperty("CategoryID")) NEQ MyCategory.GetProperty("CategoryID"))>
				<cfset MyArticle.SaveCategoryID(MyCategory.GetProperty("CategoryID"))>
			</cfif> --->
			
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
			
			<cfif MyCategoryLocale.GetCategoryTypeID() IS "73" and IsDefined("NumImportFiles") and NumImportFiles GT "0"><!--- This is a gallery  --->
							
				<cfloop index="i" from="1" to="#NumImportFiles#" step="1">
					<cfset ThisFileName=Evaluate("ImageFile_#i#")>
					<cfset ThisFileImageName=Evaluate("ImageName_#i#")>
					<cfset ThisFileImageCaption=Evaluate("ImageCaption_#i#")>
					<cfif ThisFileImageName IS ""><cfset ThisFileImageName="#ThisFileName#"></cfif>
					<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
					<cfset MyContent.Constructor(-1)>
					<cfset MyContent.SetProperty("ContentTypeID",212)>
					<cfset MyContent.SetProperty("CategoryID",MyCategory.GetProperty("CategoryID"))>
					<cfset MyContent.SetProperty("ContentName",ThisFileImageName)>
					<cfset MyContent.SetProperty("ContentPositionID",401)>
					<cfset MyContent.SetProperty("ContentActive",1)>
					<cfset MyContent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
					<cfset MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
					<cfset MyContentLocale.Constructor(-1)>
					<cfset MyContentLocale.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
					<cfset MyContentLocale.SetProperty("LocaleID",EditLocaleID)>
					<cfset MyContentLocale.SetProperty("ContentLocaleName",ThisFileImageName)>
					<cfset MyContentLocale.SetProperty("ContentAbstract",ThisFileImageCaption)>
					<cfset MyContentLocale.SetProperty("DefaultContentLocale",0)>
					<cfset MyContentLocale.SetProperty("ContentLocaleActive",1)>
					<cfset MyContentLocale.SetProperty("Image",NewSource)>
					<cfset MyContentLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
				</cfloop>
			</cfif>
			
			<!--- do ultraseek indexing 
			<cfinvoke component="com.UltraSeek.Search" 
				method="IndexByCategoryID" 
				CategoryID="#MyCategory.GetProperty('CategoryID')#"/>--->
			<!--- update summary --->
			<!---
			<cfmodule template="/common/process/populateCategorySummary.cfm" CategoryID="#MyCategory.GetProperty('CategoryID')#">
			--->
			
			<cfif Trim(ReturnURL) IS "">
				<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
				<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
				<!---<cf_AddToQueryString querystring="#QueryString#" name="UpperIDList" value="#UpperIDList#">--->
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

