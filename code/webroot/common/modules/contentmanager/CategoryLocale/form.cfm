<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">
<!--- Determine Domains --->



<cfset Restrictions=MyCategoryLocale.GetRestrictionsPropertyList()>

<cfif OpenAndCloseFormTables><table width="100%"></cfif>
<!--- <TR><TD bgcolor="bac0c9" colspan="3"><b>
<cfdump var="#MyCategoryLocale.getAllErrorMessages()#">
</b></TD></TR> --->

<cfif APPLICATION.GetAllLocale.RecordCount GT 1>
	<cfif IsDefined("SESSION.AdminCurrentAdminLocaleID") AND SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>	
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="text"
			caption="Page Locale Name<BR><small>leave blank to use master</small>" 
			ObjectName="MyCategoryLocale"
			PropertyName="CategoryLocaleName"
			size="40" maxlength="128"
			Required="N">
	<cfelse>
		<cfif MyCategoryLocale.GetProperty("CategoryLocaleName") IS "">
			<cfinvoke component="com.ContentManager.CategoryHandler" 
				method="GetCategoryName" 
				returnVariable="ThisCategoryName"
				CategoryID="#MyCategoryLocale.GetProperty('CategoryID')#">
			<cfset MyCategoryLocale.SetProperty("CategoryLocaleName",ThisCategoryName)>
		</cfif>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="text"
			caption="Page Locale Name" 
			ObjectName="MyCategoryLocale"
			PropertyName="CategoryLocaleName"
			size="40" maxlength="128"
			Required="N">
	</cfif>
</cfif>

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="text"
	caption="Page Title Override<BR><small>leave blank to use default</small>" 
	ObjectName="MyCategoryLocale"
	PropertyName="PageTitleOverride"
	size="80" maxlength="128"
	Required="N">
	
<cfif ListFindNoCase(Restrictions,"ProductPrice")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Alternative Page Locale Name" 
		ObjectName="MyCategoryLocale"
		PropertyName="CategoryLocaleNameAlternative"
		size="40" maxlength="128"
		Required="N">	
</cfif>

<cfif APPLICATION.GetAllLocale.RecordCount GT 1>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Active" 
		ObjectName="MyCategoryLocale"
		PropertyName="CategoryLocaleActive">
	
	<cfif SESSION.AdminUserLocaleID IS "1" and MyCategoryLocale.GetProperty("LocaleID") IS APPLICATION.DefaultLocaleID>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox"
			caption="Default Record?" 
			ObjectName="MyCategoryLocale"
			PropertyName="DefaultCategoryLocale">
	</cfif>
<cfelse>
	<input type="hidden" value="1" name="CategoryLocaleActive" />
	<input type="hidden" value="1" name="DefaultCategoryLocale" />
</cfif>

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="text"
	caption="Override URL" 
	ObjectName="MyCategoryLocale"
	PropertyName="CategoryLocaleURL"
	size="40" maxlength="128"
	Required="N">

		
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="Keywords" 
	ObjectName="MyCategoryLocale"
	PropertyName="MetaKeywords"
	cols="40" rows="3"
	EscapeCRLF="No"
	Required="N">
	
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="Description / Abstract" 
	ObjectName="MyCategoryLocale"
	PropertyName="MetaDescription"
	cols="40" rows="3"
	EscapeCRLF="No"
	Required="N">
	
<cfif ListFindNoCase(Restrictions,"ProductPrice")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Product Price" 
		ObjectName="MyCategoryLocale"
		PropertyName="ProductPrice"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"Title")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Title" 
		ObjectName="MyCategoryLocale"
		PropertyName="Title"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"CallToActionURL")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Call to Action URL" 
		ObjectName="MyCategoryLocale"
		PropertyName="CallToActionURL"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"ProductFamilyDescription")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="textarea"
		caption="Positioning Sentence" 
		ObjectName="MyCategoryLocale"
		PropertyName="ProductFamilyDescription"
		cols="40" rows="3"
		EscapeCRLF="No"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"Byline1")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Byline 1" 
		ObjectName="MyCategoryLocale"
		PropertyName="Byline1"
		size="40" maxlength="128"
		Required="N">
</cfif>
<cfif ListFindNoCase(Restrictions,"Byline2")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Byline 2" 
		ObjectName="MyCategoryLocale"
		PropertyName="Byline2"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif MyCategoryLocale.GetCategoryTypeID() IS "73"><!--- This is a gallery  --->
	<cfparam name="lFileToImport" default="">
	<cfinvoke component=".com/Utils.Locale"
		method="GetLocaleAlias"
		LocaleID="#EditLocaleID#"
		returnVariable="ThisChapterAlias">
	<cfset ThisDirectory=ReplaceNoCase(APPLICATION.WebrootPath,"\chapter.","\#ThisChapterAlias#.","all")>
	<cfset ThisDirectory="#ThisDirectory#incoming\">
	
	<cfif FormMode IS "ShowForm">
		<cfdirectory action="LIST" directory="#ThisDirectory#" name="qFiles" filter="*">
		<cfset FileList="">
		<cfoutput query="qFiles">
			<cfif Type IS "file" and ListFindNoCase(APPLICATION.ImageFileExtensionList,".#ListLast(Name,'.')#",";")>
				<cfset FileList=ListAppend(FileList,"{#name#|#name#}","^^")>
			</cfif>
		</cfoutput>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="MultiSelect"
			caption="Images in ""Incoming"" folder<BR>to Import"
			VarName="lFileToImport"
			Default=""
			size="15"
			OptionValues="#FileList#"
			Required="N">
	<cfelseif lFileToImport IS NOT "">
		<cfoutput>
		<tr valign="top"><TD bgcolor="bac0c9">&nbsp;</TD><TD bgcolor="bac0c9">Images in ""Incoming"" folder<BR>to Import</TD><TD>
		<table><TR><TD><strong>Image/Name</strong></TD><TD><strong>Caption</strong></TD></TR>
		<cfloop index="i" from="1" to="#listLen(lFileToImport)#" step="1">
			<tr valign="top"><TD><a href="http://#ThisChapterAlias#.#CGI.HTTP_HOST#/common/incoming/#ListGetAt(lFileToImport,i)#" target="_blank">#ListGetAt(lFileToImport,i)#</A><BR><input name="ImageName_#i#" type="Text" size="20" maxlength="255"></TD>
			<TD><textarea cols="25" rows="4" name="ImageCaption_#i#"></textarea></TD></TR>
			<input type="hidden" name="ImageFile_#i#" value="#HTMLEditFormat(ListGetAt(lFileToImport,i))#">
		</cfloop>
		</table>
		</TD></TR><input type="hidden" name="NumImportFiles" value="#listLen(lFileToImport)#">
		</cfoutput>
	</cfif>
</cfif>

<!--- <TR><TD bgcolor="bac0c9" colspan="3"><b>Images</b></TD></TR>
 --->
<cfif 1>
	<cfset sImageName=StructNew()>
	<cfset StructInsert(sImageName,"CategoryImageOff","Navigation Image: Off",1)>
	<cfset StructInsert(sImageName,"CategoryImageOn","Navigation Image: On",1)>
	<cfset StructInsert(sImageName,"CategoryImageRollover","Navigation Image: Rollover",1)>
	<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66>
		<cfset StructInsert(sImageName,"CategoryImageHeader","Featured Thumbnail <small>(285 x 128)</small>",1)>
	<cfelse>
		<cfset StructInsert(sImageName,"CategoryImageHeader","Header Image",1)>
	</cfif>
	<cfset StructInsert(sImageName,"CategoryImageTitle","Title Image",1)>
	<cfset StructInsert(sImageName,"CategoryImageRepresentative","Thumbnail Image <small>(75px x 75px)</small>",1)>
	<cfset firstImg = 0>
	<cfloop index="ThisImage" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageRepresentative">
		<cfif ListFindNoCase(Restrictions,ThisImage)>
			<cfset firstImg = firstImg+1>
			<cfif firstImg EQ 1>
				</table>
				<div class="RuleDotted1"></div>
				<strong>Images</strong>
				<div class="RuleSolid1"></div>
				<table width="90%" cellspacing="1" cellpadding="1">
				<tr>
					<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
					<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
				</tr>
			</cfif>
			<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
				ObjectAction="#FormMode#"
				type="File"
				caption="#sImageName[ThisImage]#" 
				ObjectName="MyCategoryLocale"
				PropertyName="#ThisImage#"
				Required="N"
				size="80">
			<cfif MyCategoryLocale.GetProperty("#ThisImage#") is not "">
				<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
					ObjectAction="#FormMode#"
					type="checkbox" 
					caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
					DefaultValue="#Val(evaluate('Delete#ThisImage#'))#"
					VarName="Delete#ThisImage#"
					Required="N">
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfif MyCategoryLocale.GetProperty("LocaleID") IS NOT APPLICATION.DefaultLocaleID and MyCategoryLocale.GetProperty("CategoryLocaleID") GT "0">
	<cfparam name="DeleteLocaleRecord" default="0">
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" 
		TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="checkbox" 
		caption="Delete Locale Record"
		DefaultValue="#Val(DeleteLocaleRecord)#"
		VarName="DeleteLocaleRecord"
		Required="N">
</cfif>

<cfif OpenAndCloseFormTables></table></cfif>