<cfparam name="PageAction" default="CategoryList">
<cfparam name="ATTRIBUTES.DrawHTML" default="1">
<cfparam name="EditAttachCategoryID" default="-1">
<cfparam name="EditCategoryID" default="-1">
<cfparam name="SaveType" default="Replace"><!--- Replace,SaveMinor,SaveMajor --->
<cfset EditLocaleID=APPLICATION.DefaultLocaleID>

<cfif IsDefined("ATTRIBUTES.PageAction")>
	<cfset PageAction=ATTRIBUTES.PageAction>
</cfif>
<cfparam name="FormAction" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#">
<cfif IsDefined("ATTRIBUTES.FormAction")>
	<cfset FormAction=ATTRIBUTES.FormAction>
</cfif>
<cfif IsDefined("FORM.PageAction")>
	<cfset PageAction=FORM.PageAction>
</cfif>
<cfif NOT IsDefined("ATTRIBUTES.ListPage")>
	<cfset ATTRIBUTES.ListPage="/common/admin/MasterView/index.cfm">
</cfif>

<cfif ATTRIBUTES.DrawHTML>
	<cfmodule template="/common/modules/admin/dsp_AdminHeader.cfm"
		PageTitle="Page Details"
		PageHeader="<a href=""/common/admin/"">Main Menu</A> | <a href=""/common/admin/masterview/"">Master View</A> | Resource Details">
</cfif>

<cfif IsDefined("URL.cid")>
	<cfset EditCategoryID=Decrypt(URL.cid,APPLICATION.Key)>
</cfif>

<cfif IsDefined("URL.acid")>
	<cfset EditAttachCategoryID=Decrypt(URL.acid,APPLICATION.Key)>
<cfelse>
	<cfparam name="EditAttachCategoryID" default="-1">
</cfif>
<cfset ACID=Encrypt(EditAttachCategoryID,APPLICATION.Key)>

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
	<cfinvoke component="com.ContentManager.ResourceHandler" 
		method="GetLastVersionContentID" 
		returnVariable="EditContentID"
		ResourceID="#EditCategoryID#"
		LocaleID="#EditLocaleID#">
	<cfinvoke component="com.ContentManager.ContentHandler" 
		method="GetContentLocaleID" 
		returnVariable="EditContentLocaleID"
		ContentID="#EditContentID#"
		LocaleID="#EditLocaleID#">
<cfelse>
	<cfparam name="EditCategoryLocaleID" default="-1">
	<cfparam name="EditContentID" default="-1">
	<cfparam name="EditContentLocaleID" default="-1">
</cfif>

<cfset lImageName="File">
<cfloop index="ThisImage" list="#lImageName#">
	<cfparam name="FORM.Delete#ThisImage#" default="0">
</cfloop>

<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
<cfset MyCategory.Constructor(Val(EditCategoryID))>
<!--- Standard set parameters --->
<cfset MyCategory.SetProperty("Active",1)>
<cfset MyCategory.SetProperty("CategoryTypeID",APPLICATION.ResourceCategoryTypeID)>
<cfset MyCategory.SetProperty("ShowInNavigation",1)>
<cfset MyCategory.SetProperty("ParentID",392)>
<cfset MyCategory.SetProperty("TemplateID",1500)>

<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
<cfset MyCategoryLocale.Constructor(Val(EditCategoryLocaleID))>
<cfif Val(EditCategoryLocaleID) LTE "0">
	<cfset MyCategoryLocale.SetProperty("LocaleID",EditLocaleID)>
	<cfset MyCategoryLocale.SetCategoryTypeID(MyCategory.GetProperty("CategoryTypeID"))>
</cfif>
<cfset MyCategoryLocale.SetProperty("DefaultCategoryLocale",1)>
<cfset MyCategoryLocale.SetProperty("CategoryLocaleActive",1)>

<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
<cfset MyContent.Constructor(Val(EditContentID))>
<cfset MyContent.SetProperty("CategoryID",MyCategory.GetProperty("CategoryID"))>
<cfset MyContent.SetProperty("ContentName","#MyCategory.GetProperty('CategoryName')#  v#REQUEST.OutputVersion(MyCategory.GetProperty('MajorVersion'),MyCategory.GetProperty('MinorVersion'))#")>
<cfset MyContent.SetProperty("ContentTypeID",APPLICATION.ResourceVersionContentTypeID)>
<cfset MyContent.SetProperty("Indexed",1)>
<cfset MyContent.SetProperty("Active",1)>
<cfset MyContent.SetProperty("ContentPositionID",402)>

<cfset MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
<cfset MyContentLocale.Constructor(Val(EditContentLocaleID))>
<cfif Val(EditContentLocaleID) LTE "0">
	<cfset MyContentLocale.SetProperty("ContentID",EditContentID)>
	<cfset MyContentLocale.SetContentTypeID(MyContent.GetProperty("ContentTypeID"))>
	<cfset MyContentLocale.SetProperty("File","")>
</cfif>
<cfset MyContentLocale.SetProperty("DefaultContentLocale",1)>
<cfset MyContentLocale.SetProperty("ContentLocaleActive",1)>
<cfset MyContentLocale.SetProperty("TitleTypeID",1200)>
<cfset MyContentLocale.SetProperty("LocaleID",EditLocaleID)>


<cfif IsDefined("FORM.CategoryName")>
	<!--- if the form is submitted, load the form values into the object --->
	
	<!--- Handling MyCategory --->
	<cfloop index="ThisProperty" list="CategoryName">
		<cfparam name="FORM.#ThisProperty#" default="">
		<cfset MyCategory.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
	</cfloop>
	
	<!--- Handling MyCategoryLocale --->
	
	<!--- Handling MyContent --->
	<cfset MyContent.SetProperty("ContentName","#MyCategory.GetProperty('CategoryName')#  v#REQUEST.OutputVersion(MyCategory.GetProperty('MajorVersion'),MyCategory.GetProperty('MinorVersion'))#")>
	
	<cfloop index="ThisProperty" list="MetaKeywords,MetaDescription">
		<cfparam name="FORM.#ThisProperty#" default="">
		<cfset MyCategoryLocale.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
	</cfloop>
	<cfif ListFindNoCase("SaveMinor,SaveMajor",SaveType)>
		<cfif SaveType IS "SaveMinor">
			<cfset MyCategory.SetProperty("MinorVersion",IncrementValue(MyCategory.GetProperty("MinorVersion")))>
		<cfelse>
			<cfset MyCategory.SetProperty("MajorVersion",IncrementValue(Val(MyCategory.GetProperty("MajorVersion"))))>
			<cfset MyCategory.SetProperty("MinorVersion",0)>
		</cfif>
		<cfset MyContent.SetProperty("MinorVersion",MyCategory.GetProperty("MinorVersion"))>
		<cfset MyContent.SetProperty("MajorVersion",MyCategory.GetProperty("MajorVersion"))>
		<cfset MyContent.SetProperty("ContentName","#MyCategory.GetProperty('CategoryName')#  v#REQUEST.OutputVersion(MyCategory.GetProperty('MajorVersion'),MyCategory.GetProperty('MinorVersion'))#")>
		<cfset MyContent.SetProperty("ContentID",-1)><!--- To force save of new one --->
		<cfset MyContentLocale.SetProperty("ContentLocaleID",-1)><!--- To force save of new one --->
		<cfset MyContentLocale.SetProperty("File","")><!--- User's need to upload a file --->
	</cfif>
	
	<!--- Handling MyContentLocale --->
	<cfloop index="ThisImage" list="#lImageName#">
		<cfif IsDefined("FORM.#ThisImage#FileObject") AND Evaluate("FORM.#ThisImage#FileObject") IS NOT "">
			<cfset MyContentLocale.FormFileUpload("#APPLICATION.WebrootPath#","#ThisImage#","#ThisImage#FileObject")>
		<cfelseif IsDefined("FORM.#ThisImage#") and 0>
			<cfset MyContentLocale.SetProperty(ThisImage,evaluate("FORM.#ThisImage#"))>
		</cfif>
	</cfloop>
</cfif>

<cfset PageAction=Trim(PageAction)>

<cfif PageAction IS "ValidateEdit" OR PageAction IS "ValidateAdd">
	<cfif NOT IsDefined("FORM.ButSubmit")>
		<cfset PageAction=ReplaceNoCase(PageAction,"Validate","","All")>
	</cfif>
</cfif>

<cfif ListFindNoCase("Add,Edit,ValidateDelete,AttachDetach",PageAction) AND NOT IsDefined("ReturnURL")>
	<cfset ReturnURL=CGI.HTTP_Referer>
</cfif>

<cfswitch expression="#Trim(PageAction)#">
	<cfcase value="AttachDetach">
		<cfinvoke component="com.ContentManager.ResourceHandler" 
			method="GetResourceLinkContentID"
			returnVariable="ResourceLinkContentID"
			CategoryID="#EditAttachCategoryID#"
			ResourceID="#EditCategoryID#">
		<cfif Val(ResourceLinkContentID) GT "0">
			<!--- A link exists, delete it --->
			<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
			<cfset MyContent.Constructor(Val(ResourceLinkContentID))>
			<cfset MyContent.Delete(APPLICATION.TrashPath)>
		<cfelse>
			<!--- No link exists, create it --->
			<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
			<cfset MyContent.Constructor(-1)>
			<cfset MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
			<cfset MyContentLocale.Constructor(-1)>
			
			<cfset MyContent.SetProperty("ContentTypeID",APPLICATION.ResourceLinkContentTypeID)>
			<cfset MyContent.SetProperty("SourceID",EditCategoryID)>
			<cfset MyContent.SetProperty("CategoryID",EditAttachCategoryID)>
			<cfset MyContent.SetProperty("ContentName",MyCategory.GetProperty("CategoryName"))>
			<cfset MyContent.SetProperty("ContentActive",1)>
			<cfset MyContent.SetProperty("ContentPositionID",400)>
			<cfset MyContent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			
			<cfset MyContentLocale.SetProperty("LocaleID",APPLICATION.DefaultLocaleID)>
			<cfset MyContentLocale.SetContentTypeID(MyContent.GetProperty("ContentTypeID"))>
			<cfset MyContentLocale.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
			<cfset MyContentLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
		</cfif>
		<cfif Trim(ReturnURL) IS "">
			<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
			<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
			<!---<cf_AddToQueryString querystring="#QueryString#" name="UpperIDList" value="#UpperIDList#">--->
			<cflocation url="#Location#?#querystring#" addtoken="No">
		<cfelse>
			<cflocation url="#ReturnURL#" addtoken="No">
		</cfif>
	</cfcase>
	<cfcase value="Add,Edit">
		<cfset FormMode="ShowForm">
		<table bgcolor="silver"><tr valign="top">
		<TD bgcolor="white" valign="top">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cfif PageAction IS "add">
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" Omitlist="PageAction">
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
			<input type="hidden" name="PageAction" value="Validate#PageAction#">
		</cfoutput>
		<cfinclude template="/common/modules/ContentManager/Resource/form.cfm">
		<div align="right">
			<cfif PageAction IS NOT "add">
				<select name="SaveType">
					<option value="Replace" <cfif SaveType IS "Replace">selected</cfif>>Replace Current Version</option>
					<option value="SaveMinor" <cfif SaveType IS "SaveMinor">selected</cfif>>Save as New Minor Version</option>
					<option value="SaveMajor" <cfif SaveType IS "SaveMajor">selected</cfif>>Save as New Major Version</option>
				</select>
			</cfif>
			<input type="submit" name="ButSubmit" value="Apply">
		</div>
		</TD></form>
		<cfif PageAction IS NOT "add">
			<TD bgcolor="white">
			<cfinclude template="/common/modules/ContentManager/Resource/ResourceVersionHistory.cfm">
			</TD>
		</cfif>
		</TR></table>
	</cfcase>
	<cfcase value="ValidateEdit,ValidateAdd">
		<cfset FormMode="Validate">
		<table bgcolor="silver"><tr valign="top">
		<TD bgcolor="white">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cfif PageAction IS "ValidateEdit">
				<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" omitlist="PageAction">
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
			<input type="hidden" name="PageAction" value="#PageAction#">
		</cfoutput>
		<cfinclude template="/common/modules/ContentManager/Resource/form.cfm">
		<div align="right">
			<cfif PageAction IS NOT "ValidateAdd">
				<select name="SaveType">
					<option value="Replace" <cfif SaveType IS "Replace">selected</cfif>>Replace Current Version</option>
					<option value="SaveMinor" <cfif SaveType IS "SaveMinor">selected</cfif>>Save as New Minor Version</option>
					<option value="SaveMajor" <cfif SaveType IS "SaveMajor">selected</cfif>>Save as New Major Version</option>
				</select>
			</cfif>
			<input type="submit" name="ButSubmit" value="Apply">
		</div>
		</TD></form>
		<cfif PageAction IS NOT "ValidateAdd">
			<TD bgcolor="white">
			<cfinclude template="/common/modules/ContentManager/Resource/ResourceVersionHistory.cfm">
			</TD>
		</cfif>
		</TR></table>
		<cfif MyCategory.isCorrect() and MyContentLocale.isCorrect() and (FEPermissions IS "Public" OR (FEPermissions IS "Private" and IsDefined("FrontEndUserGroupID")) )>
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
			<cfif ListFindNoCase("SaveMajor",SaveType) OR PageAction IS "ValidateAdd">
				<cfinvoke component="com.utils.tracking" 
					method="track"
					returnVariable="success"
					UserID="#SESSION.AdminUserID#"
					Entity="Category"
					KeyID="#MyCategory.GetProperty('CategoryID')#"
					Operation="#SaveType#">
			</cfif>	
			<cfset MyCategoryLocale.SetProperty("CategoryID",MyCategory.GetProperty("CategoryID"))>
			<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			
			<cfset MyContent.SetProperty("CategoryID",MyCategory.GetProperty("CategoryID"))>
			<cfset MyContent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			<cfset MyContentLocale.SetProperty("ContentID",MyContent.GetProperty("ContentID"))>
			<cfset MyContentLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			
			<!--- Handling Detachment of a Related Page --->
			<cfinvoke component="com.ContentManager.ResourceHandler" method="GetResourceRelatedCategory" returnVariable="qRelatedPages">
				<cfinvokeargument name="ResourceID" value="#MyCategory.GetProperty('CategoryID')#">
			</cfinvoke>
			
			<cfoutput query="qRelatedPages">
				<cfparam name="Detach_#REQUEST.SimpleEncrypt(RelatedCategoryID)#" default="0">
				<cfif Evaluate("Detach_#REQUEST.SimpleEncrypt(RelatedCategoryID)#")>
					<cfinvoke componencom.ContentManager.ResourceHandlerer" 
						method="GetResourceLinkContentID"
						returnVariable="ResourceLinkContentID"
						CategoryID="#RelatedCategoryID#"
						ResourceID="#MyCategory.GetProperty('CategoryID')#">
					<cfif Val(ResourceLinkContentID) GT "0">
						<!--- A link exists, delete it --->
						<cfset DeleteContent=CreateObject("component","com.ContentManager.Content")>
						<cfset DeleteContent.Constructor(Val(ResourceLinkContentID))>
						<cfset DeleteContent.Delete(APPLICATION.TrashPath)>
					</cfif>
				</cfif>
			</cfoutput>
			
			<!--- Handle Permissions --->
			<cfinvoke componencom.ContentManager.ResourceHandlerler" 
				method="ClearFrontEndPermissions"
				returnVariable="Success"
				ResourceID="#MyCategory.GetProperty('CategoryID')#">
			<cfif FEPermissions IS "Public">
				<cfinvoke componencom.ContentManager.ResourceHandlerler" 
					method="SetFrontEndPermissions"
					returnVariable="Success"
					lUserGroupID="1900"
					ResourceID="#MyCategory.GetProperty('CategoryID')#">
			<cfelse>
				<cfinvoke componencom.ContentManager.ResourceHandlerler" 
					method="SetFrontEndPermissions"
					returnVariable="Success"
					lUserGroupID="#FrontEndUserGroupID#"
					ResourceID="#MyCategory.GetProperty('CategoryID')#">
			</cfif>
			
			<cfif Trim(ReturnURL) IS "">
				<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
				<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
				<!---<cf_AddToQueryString querystring="#QueryString#" name="UpperIDList" value="#UpperIDList#">--->
				<cflocation url="#Location#?#querystring#" addtoken="No">
			<cfelse>
				<cfif PageAction is "ValidateAdd">
					<cfset Location=GetToken(ReturnURL,1,"?")>
					<cfset querystring=GetToken(ReturnURL,2,"?")>
					<cf_AddToQueryString querystring="#QueryString#" name="rid" value="#Encrypt(MyCategory.GetProperty('CategoryID'),APPLICATION.Key)#">
					<cflocation url="#Location#?#querystring#" addtoken="No">
				<cfelse>
					<cflocation url="#ReturnURL#" addtoken="No">
				</cfif>
			</cfif>
		</cfif>
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
		<cfoutput><P>Are you sure you want to delete the resource "#MyCategory.GetProperty('CategoryName')#" and its associated files?</P></cfoutput>
		<input type="submit" value="Delete">
		</form>
	</cfcase>
	<cfcase value="CommitDelete">
		<cfset MyCategory.Delete(APPLICATION.TrashPath)>
		<cfset MyContent.Delete(APPLICATION.TrashPath)>
		<cfif Trim(ReturnURL) IS "">
			<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
		<cfelse>
			<cflocation url="#ReturnURL#" addtoken="No">
		</cfif>
	</cfcase>
	<cfcase value="CategoryList">
		<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
	</cfcase>
</cfswitch>

<cfif ATTRIBUTES.DrawHTML>
	<cfmodule template="/common/modules/admin/dsp_AdminFooter.cfm">
</cfif>
