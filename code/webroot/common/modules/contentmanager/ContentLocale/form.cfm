<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">
<cfparam name="DeleteImage" default="0">
<cfparam name="DeleteFile" default="0">
<cfparam name="DeleteImageLarge" default="0">
<cfparam name="DeleteImageThumbnail" default="0">
<cfparam name="DeleteFlash" default="0">
<cfparam name="ActiveEditStyleSheet" default="http://#CGI.Server_Name#/common/styles/default.css">

<cfset HTMLActiveEditToolBar="quickstyles,quickformat,,,|,cut,copy,paste,|,redo,undo,|,bold,italic,underline,|,outdent,indent,|,justifyleft,justifycenter,justifyright,bullets,|,table,image,hyperlink,|,find,help,specialchars,spellcheck,clean">
<cfset TextActiveEditToolBar="quickformat,,,|,cut,copy,paste,|,redo,undo,|,bold,italic,underline,,,,|,,,,bullets,|,table,,hyperlink,|,find,help,specialchars,spellcheck,clean">
<cfset FileURL="#MyContentLocale.GetResourcePath('root')#">
<cfif SESSION.DisableRichControls>
	<cfset UseActiveEdit="No">
<cfelse>
	<cfset UseActiveEdit="Yes">
</cfif>
<!--- Determine Domains --->
<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qLocale">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Locale">
	<cfinvokeargument name="FieldName" value="LocaleID">
	<cfinvokeargument name="FieldValue" value="#Val(MyContentLocale.GetProperty('LocaleID'))#">
	<cfinvokeargument name="SortFieldName" value="LocaleName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset Restrictions=MyContentLocale.GetRestrictionsPropertyList()>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qTitleType">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="170">
	<cfinvokeargument name="SortFieldName" value="LabelPriority">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset TitleTypeIDList="">
<cfoutput query="qTitleType">
	<cfset TitleTypeIDList=ListAppend(TitleTypeIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
	thiscategoryid="#MyContent.GetProperty('CategoryID')#"
	namelist=""
	idlist="#MyContent.GetProperty('CategoryID')#"
	aliaslist="">
	
<cfif ListLen(IDList) GTE "2">
	<cfset ThisSiteCategoryID=ListGetAt(IDList,2)>
<cfelse>
	<cfset ThisSiteCategoryID="-1">
</cfif>

<cfif OpenAndCloseFormTables><table width="100%" cellspacing="1" cellpadding="2"></cfif>
<!--- <tr><td bgcolor="bac0c9" colspan="3"><b>
<cfdump var="#MyContentLocale.getAllErrorMessages()#">
</b></td></tr> --->
<cfif APPLICATION.GetAllLocale.RecordCount GT 1>
	<tr><td bgcolor="bac0c9" colspan="3"><b><cfoutput>#qLocale.LocaleName#</cfoutput> version</b></td></tr>
	
	<cfif IsDefined("SESSION.AdminCurrentAdminLocaleID") AND SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="Title<BR><small>leave blank to<BR>use default</small>" 
			ObjectName="MyContentLocale"
			PropertyName="ContentLocaleName"
			cols="50" rows="2"
			Required="N">
	<cfelse>
		<cfif MyContentLocale.GetProperty("ContentLocaleName") IS "">
			<cfinvoke component="com.ContentManager.ContentHandler" 
				method="GetContentName" 
				returnVariable="ThisContentName"
				ContentID="#MyContentLocale.GetProperty('ContentID')#">
			<cfset MyContentLocale.SetProperty("ContentLocaleName",ThisContentName)>
		</cfif>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="Title" 
			ObjectName="MyContentLocale"
			PropertyName="ContentLocaleName"
			cols="50" rows="2"
			Required="N">
	</cfif>
</cfif>

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="select"
	caption="Title Type" 
	ObjectName="MyContentLocale"
	PropertyName="TitleTypeID"
	OptionValues="#TitleTypeIDList#"
	Required="N"
	FormEltStyle="width:200px;">
	
<cfif APPLICATION.GetAllLocale.RecordCount GT 1>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="YesNo"
		caption="State" 
		YesMark="Active"
		NoMark="Not active"
		ObjectName="MyContentLocale"
		PropertyName="ContentLocaleActive">
		
	<cfif SESSION.AdminUserLocaleID IS "1" and MyContentLocale.GetProperty("LocaleID") IS APPLICATION.DefaultLocaleID>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="YesNo"
			caption="Default Record?" 
			ObjectName="MyContentLocale"
			PropertyName="DefaultContentLocale">
	</cfif>
<cfelse>
	<input type="hidden" name="ContentLocaleActive" value="1">
	<input type="hidden" name="DefaultContentLocale" value="1">
</cfif>

<cfif ThisSiteCategoryID IS NOT APPLICATION.intranetSiteCategoryID>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="CSS ID<BR>Default will be <BR>""ContentElement#MyContentLocale.GetProperty('ContentID')#""" 
		ObjectName="MyContentLocale"
		PropertyName="CSSID"
		size="40" maxlength="40"
		Required="N">
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="CSS Class" 
		ObjectName="MyContentLocale"
		PropertyName="CSSClass"
		size="40" maxlength="40"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"SubTitle")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Sub-Title"
		ObjectName="MyContentLocale"
		PropertyName="SubTitle"
		size="40" maxlength="40"
		Required="N">
</cfif>
<cfif ListFindNoCase(Restrictions,"ContentAbstract")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="textarea"
		caption="Abstract" 
		ObjectName="MyContentLocale"
		PropertyName="ContentAbstract"
		cols="50" rows="5"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"NumItems")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Number of Items" 
		ObjectName="MyContentLocale"
		PropertyName="NumItems"
		size="40" maxlength="40"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"NumberOfMonths")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="+/- Number of Months" 
		ObjectName="MyContentLocale"
		PropertyName="NumberOfMonths"
		size="40" maxlength="40"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"LinkURL")>

	<cfif MyContentLocale.ContentTypeID IS "259">
		<cfset TextPositionIDList="{left|Left of HTML}^^{right|Right of HTML}">
		<cfinvoke component="com.ContentManager.ContentHandler" method="getVideos" returnVariable="qVideos">
		<cfset lVideos="">
		<cfoutput query="qVideos">
			<cfset lVideos=ListAppend(lVideos,"{#qVideos.name#|#qVideos.name#}","^^")>
		</cfoutput>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="select"
			caption="Video" 
			ObjectName="MyContentLocale"
			PropertyName="linkURL"
			OptionValues="#lVideos#"
			Required="Y"
			FormEltStyle="width:200px;">
	<cfelse>
		<cfif MyContentLocale.ContentTypeID IS "236">
			<cfset ThisCaption="""See All"" URL<BR><small>Leave blank to omit</small>">
		<cfelse>
			<cfset ThisCaption="Link URL">
		</cfif>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="text"
			caption="#ThisCaption#" 
			ObjectName="MyContentLocale"
			PropertyName="LinkURL"
			size="40" maxlength="512"
			Required="N">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"PageActionURL")>
	<cfif MyContentLocale.ContentTypeID IS "236">
		<cfset ThisCaption="Event Detail URL<BR><small>Leave blank for default</small>">
	<cfelse>
		<cfset ThisCaption="Page Action URL">
	</cfif>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="#ThisCaption#" 
		ObjectName="MyContentLocale"
		PropertyName="PageActionURL"
		size="40" maxlength="512"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"Location")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Event Location" 
		ObjectName="MyContentLocale"
		PropertyName="Location"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"DateStart")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Start Date" 
		ObjectName="MyContentLocale"
		PropertyName="DateStart"
		size="40" maxlength="128"
		Required="N"
		Date="Y">
</cfif>

<cfif ListFindNoCase(Restrictions,"DateEnd")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="End Date" 
		ObjectName="MyContentLocale"
		PropertyName="DateEnd"
		size="40" maxlength="128"
		Required="N"
		Date="Y">
</cfif>

<cfif ListFindNoCase(Restrictions,"AllowMultipleRegistrations")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Allow user to register<BR>mulltiple people?" 
		ObjectName="MyContentLocale"
		PropertyName="AllowMultipleRegistrations">
</cfif>

<cfif ListFindNoCase(Restrictions,"TextPosition")>
	<cfset TextPositionIDList="{left|Left of HTML}^^{right|Right of HTML}">
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="select"
		caption="Text Position" 
		ObjectName="MyContentLocale"
		PropertyName="TextPosition"
		OptionValues="#TextPositionIDList#"
		Required="Y"
		FormEltStyle="width:200px;">
</cfif>


<cfif ListFindNoCase(Restrictions,"Image")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="File"
		caption="Image" 
		ObjectName="MyContentLocale"
		PropertyName="Image"
		Required="N">
	<cfif MyContentLocale.GetProperty("Image") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(DeleteImage)#"
			VarName="DeleteImage"
			Required="N">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"ImageRollover")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="File"
		caption="Rollover Image" 
		ObjectName="MyContentLocale"
		PropertyName="ImageRollover"
		Required="N">
	<cfif MyContentLocale.GetProperty("ImageRollover") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(DeleteImageRollover)#"
			VarName="DeleteImageRollover"
			Required="N">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"ImageLarge")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="File"
		caption="Large Image" 
		ObjectName="MyContentLocale"
		PropertyName="ImageLarge"
		Required="N">
	<cfif MyContentLocale.GetProperty("ImageLarge") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(DeleteImageLarge)#"
			VarName="DeleteImageLarge"
			Required="N">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"ImageThumbnail")>
	
	<cfif MyContentLocale.ContentTypeID IS "254">
		<cfset thumbCaption = "Drop Cap Image">
	<cfelse>
		<cfset thumbCaption = "Thumbnail Image">
	</cfif>

	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="File"
		caption="#thumbCaption#" 
		ObjectName="MyContentLocale"
		PropertyName="ImageThumbnail"
		Required="N">
	<cfif MyContentLocale.GetProperty("ImageThumbnail") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(DeleteImageThumbnail)#"
			VarName="DeleteImageThumbnail"
			Required="N">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"ShowEventRangeID")>
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qShowEventRangeID">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Label">
		<cfinvokeargument name="FieldName" value="LabelGroupID">
		<cfinvokeargument name="FieldValue" value="8000">
		<cfinvokeargument name="SortFieldName" value="LabelPriority">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
	<cfset ShowEventRangeIDList="">
	<cfoutput query="qShowEventRangeID">
		<cfset ShowEventRangeIDList=ListAppend(ShowEventRangeIDList,"{#LabelID#|#LabelName#}","^^")>
	</cfoutput>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="select"
		caption="Show which events" 
		ObjectName="MyContentLocale"
		PropertyName="ShowEventRangeID"
		OptionValues="#ShowEventRangeIDList#"
		Required="Y"
		FormEltStyle="width:200px;">
</cfif>

<cfif ListFindNoCase(Restrictions,"File")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="File"
		caption="File" 
		ObjectName="MyContentLocale"
		PropertyName="File"
		Required="N">
	<cfif MyContentLocale.GetProperty("File") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(DeleteFile)#"
			VarName="DeleteFile"
			Required="N">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"flash")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="File"
		caption="Flash" 
		ObjectName="MyContentLocale"
		PropertyName="Flash"
		Required="N">
	<cfif MyContentLocale.GetProperty("Flash") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(DeleteFlash)#"
			VarName="DeleteFlash"
			Required="N">
	</cfif>
</cfif>


<cfif ListFindNoCase(Restrictions,"lStateProvince")>
	<cfset StateProvinceList="">
	<cfoutput query="Application.GetStateProvinces">
		<cfset StateProvinceList=ListAppend(StateProvinceList,"{#StateProvinceCode#|#StateProvinceName#}","^^")>
	</cfoutput>

	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="multiselect"
		caption="States" 
		ObjectName="MyContentLocale"
		PropertyName="lStateProvince"
		OptionValues="#StateProvinceList#"
		Required="N">
	
</cfif>

<cfif ListFindNoCase(Restrictions,"lRelatedCategoryID")>
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="qGallery">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#EditLocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="73" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
	</cfstoredproc>
	<cfset lGalleryID="">
	<cfoutput query="qGallery">
		<cfset lGalleryID=ListAppend(lGalleryID,"{#CategoryID#|#CategoryNameDerived#}","^^")>
	</cfoutput>
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="multiselect"
		size="5"
		caption="Related Galleries" 
		ObjectName="MyContentLocale"
		PropertyName="lRelatedCategoryID"
		OptionValues="#lGalleryID#"
		Required="N">
	
</cfif>

<cfif ListFindNoCase(Restrictions,"lMTCategoryIDAllow")>
	<cfinvoke component="/.com.ContentManager.LocaleHandler" method="GetMTDefaultDiscussionIDFromLocaleID" returnvariable="GetMTDefaultDiscussionIDFromLocaleID">
		<cfinvokeargument name="LocaleID" value="#EditLocaleID#"/>
	</cfinvoke>
	<cfinvoke component="/.com.discussion.discussionHandler" method="getAllTopics" returnvariable="getTopics">
		<cfinvokeargument name="datasource" value="#APPLICATION.MTDSN#"/>
		<cfinvokeargument name="discussionID" value="#GetMTDefaultDiscussionIDFromLocaleID#"/>
	</cfinvoke>
	<cfset lMTCategoryID="">
	<cfoutput query="getTopics">
		<cfset lMTCategoryID=ListAppend(lMTCategoryID,"{#topicID#|#topic#}","^^")>
	</cfoutput>
	<cfset lMTCategoryID=ListPrepend(lMTCategoryID,"{-1|All}","^^")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="multiselect"
		size="5"
		caption="Only display entries<BR>in these categories"
		ObjectName="MyContentLocale"
		PropertyName="lMTCategoryIDAllow"
		OptionValues="#lMTCategoryID#"
		Required="N">
</cfif>


<cfif ListFindNoCase(Restrictions,"HTML")>
	<cfif FormMode IS "ShowForm">
		<cfif UseActiveEdit>
			<cfset ActiveEditToolBar="HTMLActiveEditToolBar">
			<tr valign="top"><td bgcolor="white"><strong>*</strong></td><td bgcolor="white" colspan="2">HTML</td></tr>
			<tr><td></td><td bgcolor="white" colspan="2">
			<cfmodule template="/common/modules/utils/fckeditor.cfm"
				fieldname="HTML"
				fileURL="#FileURL#"
				height="400" width="800"
				Content="#MyContentLocale.GetProperty('HTML')#">
			</td></tr>
		<cfelse>
			<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
				ObjectAction="#FormMode#"
				type="textarea"
				caption="HTML" 
				ObjectName="MyContentLocale"
				PropertyName="HTML"
				cols="50" rows="25"
				EscapeCRLF="No"
				Required="Y">
		</cfif>
	<cfelse>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="HTML" 
			ObjectName="MyContentLocale"
			PropertyName="HTML"
			cols="50" rows="25"
			EscapeCRLF="No"
			Required="Y">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"TEXT")>
	<cfif FormMode IS "ShowForm">
		<cfif 0>
			<tr valign="top"><td bgcolor="white"></td><td bgcolor="white" colspan="2">Text</td></tr>
			<tr><td></td><td bgcolor="white" colspan="2">
			<cfmodule template="/common/modules/utils/fckeditor.cfm"
				fieldname="Text"
				fileURL="#FileURL#"
				height="400" width="800"
				Content="#MyContentLocale.GetProperty('Text')#">
			</td></tr>
		<cfelse>
			<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
				ObjectAction="#FormMode#"
				type="textarea"
				caption="Text" 
				ObjectName="MyContentLocale"
				PropertyName="Text"
				cols="100" rows="25"
				EscapeCRLF="No"
				Required="Y">
		</cfif>
	<cfelse>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="Text" 
			ObjectName="MyContentLocale"
			PropertyName="Text"
			cols="80" rows="25"
			EscapeCRLF="No"
			Required="Y">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"HTMLTemplate")>
	<cfif FormMode IS "ShowForm">
		<cfif UseActiveEdit>			
			<tr valign="top"><td bgcolor="white">&nbsp;</td><td bgcolor="white" colspan="2">HTML Template<BR><small>Use [[text1]], [[text2]], etc. as the tokens.</small></td></tr>
			<tr><td></td><td bgcolor="white" colspan="2">
			
			<cfmodule template="/common/modules/utils/fckeditor.cfm"
				fieldname="HTMLTemplate"
				fileURL="#FileURL#"
				height="400" width="800"
				Content="#MyContentLocale.GetProperty('HTMLTemplate')#">
			</td></tr>
		<cfelse>
			<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
				ObjectAction="#FormMode#"
				type="textarea"
				caption="HTML Template" 
				ObjectName="MyContentLocale"
				PropertyName="HTMLTemplate"
				cols="80" rows="25"
				EscapeCRLF="No"
				Required="Y">
		</cfif>
		<!--- <tr><td bgcolor="bac0c9"></td><td bgcolor="bac0c9"></td><td align="right" bgcolor="#EAEAEA"><input type="submit" value="Process Template"></td></tr> --->
	<cfelse>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="HTML Template" 
			ObjectName="MyContentLocale"
			PropertyName="HTMLTemplate"
			cols="80" rows="25"
			EscapeCRLF="No"
			Required="Y">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"sHTML")>
	<cfset sHTML=MyContentLocale.GetProperty("sHTML")>
	<cfif ListLen(StructKeyList(sHTML)) IS "0">
		<tr><td bgcolor="white"></td><td bgcolor="white"></td><td align="center">[ No templatized areas. ]</td></tr>
	<cfelse>
		<cfset TokenList=MyContentLocale.GetTokenList()>
		<cfoutput>
		<cfloop index="ThisToken" list="#TokenList#">
		
			<!--- get token name and type --->
			<cfset ThisTokenName = getToken(ThisToken, 1, ":") />
			<cfset ThisTokenType = getToken(ThisToken, 2, ":") />
			
			<!--- get the token value --->
			<cfif StructKeyExists(sHTML,ThisTokenName)>
				<!--- if the token has a type, will store values in a struct --->
				<cfif isStruct(sHTML[ThisTokenName])>
					<cfset ThisValue=sHTML[ThisTokenName].value />
				<cfelse>
					<cfset ThisValue=sHTML[ThisTokenName] />
				</cfif>
			<cfelse>
				<cfset ThisValue="" />
			</cfif>
			
			<!--- get the fieldname --->
			<cfset thisFieldname = "sHTML_" & ThisTokenName />
			
			<cfif FormMode IS "ShowForm">
				<tr valign="top">
					<td bgcolor="white">&nbsp;</td>
					<td bgcolor="white" colspan="2">
						<strong>#ThisTokenName#</strong>
					</td>
				</tr>
				
				<!--- handle different token types --->
				<cfif ThisTokenType eq "image">
					<cfif FormMode IS "ShowForm">
						<tr valign="top">
							<td></td>
							<td>
							<input type="file" name="#thisFieldname#Image"><br />
							<cfif len(trim(ThisValue))>
								<img src="#ThisValue#" width="75" /><br />
								<small>Image: <a href="#ThisValue#" target="_blank">#ListLast(ThisValue,'/')#</a>
							</cfif>
							<input type="hidden" name="#thisFieldname#" value="#ThisValue#">
							</td>
							<td><input type="checkbox" name="#thisFieldname#Delete" value="1"></td>
						</tr>
					<cfelse>
						<tr>
							<td></td>
							<td>
								<a href="#ThisValue#" target="_blank">#ListLast(ThisValue,'/')#</a>
							</td>
						</tr>
					</cfif>
				<cfelseif ThisTokenType eq "text">
					<tr>
						<td></td>
						<td bgcolor="white" colspan="2">
							<input type="text" name="#thisFieldname#" value="#ThisValue#" maxlength="100" size="100" />
						</td>
					</tr>
				<cfelse>
					<tr>
						<td></td>
						<td bgcolor="white" colspan="2">
							<cfif UseActiveEdit>
								<cfmodule template="/common/modules/utils/fckeditor.cfm"
									fieldname="#thisFieldname#"
									fileURL="#FileURL#"
									height="400" width="800"
									Content="#ThisValue#">
							<cfelse>
								<textarea cols="80" rows="15" name="#thisFieldname#" wrap="virtual">#HTMLEditFormat(ThisValue)#</textarea>
							</cfif>
						</td>
					</tr>
				</cfif>
			<cfelse>
				<cfoutput><tr><td bgcolor="white">&nbsp;</td><td bgcolor="white"></td><td bgcolor="EAEAEA">#ThisValue#<input type="hidden"  name="sHTML_#ThisTokenName#" value="#HTMLEditFormat(ThisValue)#"></td></tr></cfoutput>
			</cfif>
				<tr valign="top">
					<td bgcolor="white">&nbsp;</td>
				</tr>
		</cfloop>
		</cfoutput>
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"aText")>
	<cfset aText=MyContentLocale.GetProperty("aText")>
	<cfloop index="at" from="1" to="#ArrayLen(aText)#" step="1">
		<cfif FormMode IS "ShowForm">
			<tr valign="top"><td bgcolor="white">&nbsp;></td><td bgcolor="white" colspan="2">Text block <cfoutput>#at#</cfoutput></td></tr>
			<tr><td></td><td bgcolor="white" colspan="2">
			<cfif UseActiveEdit>
				<cfmodule template="/common/modules/utils/fckeditor.cfm"
					fieldname="aText_#at#"
					fileURL="#FileURL#"
					height="400" width="800"
					Content="#aText[at]#">
			<cfelse>
				<cfoutput><textarea cols="80" rows="15" name="aText_#at#" wrap="virtual">#aText[at]#</textarea></cfoutput>
			</cfif></td></tr>
		<cfelse>
			<cfoutput><tr><td bgcolor="white">&nbsp;</td><td bgcolor="white"></td><td  bgcolor="EAEAEA">#aText[at]#<input type="hidden"  name="aText_#at#" value="#HTMLEditFormat(aText[at])#"></td></tr></cfoutput>
		</cfif>
	</cfloop>
	<cfoutput><input type="hidden" name="NumText" value="#at#"></cfoutput>
	<cfif FormMode IS "ShowForm">
		<tr valign="top"><td bgcolor="white">&nbsp;></td><td bgcolor="white" colspan="2">New Text Block</td></tr>
		<tr><td></td><td bgcolor="white" colspan="2">
		
		<cfif UseActiveEdit>
			<cfmodule template="/common/modules/utils/fckeditor.cfm"
				fieldname="aText_New"
				fileURL="#FileURL#"
				height="400" width="800"
				Content="">
		<cfelse>
			<cfoutput><textarea cols="80" rows="15" name="aText_New" wrap="virtual"></textarea></cfoutput>
		</cfif>
		</td></tr>
		<tr><td bgcolor="white">&nbsp;</td><td bgcolor="white">&nbsp;</td><td bgcolor="EAEAEA" align="right"><input type="submit" value="Update Text Blocks"></td></tr>
	</cfif>
</cfif>


<cfif ListFindNoCase(Restrictions,"aLink")>
	<tr><td bgcolor="white" colspan="3"><b>Links</b></td></tr>
	<tr>
		<td bgcolor="white"></td>
		<td colspan="2" bgcolor="EAEAEA">
			<table width="100%" border="0">
			<cfset aLink=MyContentLocale.GetProperty("aLink")>
			<tr>
				<td><strong>Title</strong></td>
				<td><strong>Caption</strong></td>
				<td><strong>URL</strong></td>
				<td>&nbsp;</td>
				<td><cfif ArrayLen(aLink) GT "0" and FormMode IS "ShowForm"><strong>Remove?</strong><cfelse>&nbsp;</cfif></td>
			</tr>
			<cfloop index="li" from="1" to="#ArrayLen(aLink)#" step="1">
				<cfif FormMode IS "ShowForm">
					<cfoutput>
					<tr valign="top">
						<td><input type="text" name="LinkTitle_#li#" value="#aLink[li].Title#" size="20" maxlength="255"></td>
						<td><textarea cols="50" rows="4" name="LinkCaption_#li#">#aLink[li].Caption#</textarea></td>
						<td><input type="text" name="LinkURL_#li#" value="#aLink[li].URL#" size="40" maxlength="255"></td>
						<td nowrap>
							<cfoutput><cfif ArrayLen(aLink) GT "1">
							<cfif li IS NOT "1"><input type="image" name="LinkButtonSubmit_up_#li#" value="up_#li#" src="/common/images/widget_arrow_up.gif"><cfelse><img src="/common/images/widget_arrow_up_grey.gif"></cfif><cfif li IS NOT ArrayLen(aLink)><input type="image" name="LinkButtonSubmit_down_#li#" value="down_#li#" src="/common/images/widget_arrow_down.gif"><cfelse><img src="/common/images/widget_arrow_down_grey.gif"></cfif>
							</cfif></cfoutput>&nbsp;
						</td>
						<td><input type="checkbox" name="LinkDelete_#li#" value="1"></td>
					</tr>
					</cfoutput>
				<cfelse>
					<cfoutput>
					<tr>
						<td>#aLink[li].Title#</td>
						<td>#aLink[li].Caption#</td>
						<td>
							<a href="#aLink[li].URL#" target="_blank">#aLink[li].URL#</a>
							<input type="hidden" name="LinkTitle_#li#" value="#HTMLEditFormat(aLink[li].Title)#">
							<input type="hidden" name="LinkCaption_#li#" value="#HTMLEditFormat(aLink[li].Caption)#">
							<input type="hidden" name="LinkURL_#li#" value="#HTMLEditFormat(aLink[li].URL)#">
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
					</cfoutput>
				</cfif>
			</cfloop>
	<cfoutput><input type="hidden" name="NumLinks" value="#li#"></cfoutput>
	<cfif FormMode IS "ShowForm">
		<tr valign="top">
			<td><input type="text" name="LinkTitle_New" value="" size="20" maxlength="255"></td>
			<td><textarea cols="50" rows="4" name="LinkCaption_New"></textarea></td>
			<td><input type="text" name="LinkURL_New" value="" size="40" maxlength="255"></td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr><td colspan="5" align="right"><input type="submit" value="Update Links"></td></tr>
	</cfif>
	
	</table>
	</td></tr>
</cfif>



<cfif ListFindNoCase(Restrictions,"aFile")>
	<cfif MyContentLocale.GetContentTypeID() IS "266">
		<cfset aFile=MyContentLocale.GetProperty("aFile")>
		<tr><td colspan="3"><b>Files</b></td></tr>
		<tr>
			<td></td>
			<td colspan="2">
				<table width="100%" border="0">
				
				<tr><td></td>
					<td><strong>Name / Date-Time Stamp</strong></td>
					<td><strong>Caption</strong></td>
					<td><strong>Thumbnail / File</strong></td>
					<td>&nbsp;</td>
					<td><cfif ArrayLen(aFile) GT "0" and FormMode IS "ShowForm"><strong>Remove?</strong><cfelse>&nbsp;</cfif></td>
				</tr>

				<cfloop index="fi" from="1" to="#ArrayLen(aFile)#" step="1">
					<cfloop index="ThisProperty" list="ThumbnailPath,FileDateTimeStamp,FileSize,FileSubTitle,Author,FileDuration,FileKeywords">
						<cfif NOT StructKeyExists(aFile[fi],ThisProperty)>
							<cfset StructInsert(aFile[fi],ThisProperty,"",1)>
						</cfif>
					</cfloop>
					<cfif FormMode IS "ShowForm">
						<cfoutput>
						<tr valign="top">
							<td><strong>#fi#)</strong></td>
							<td>
							<small>Title</small><br>
							<input type="text" name="FileName_#fi#" value="#aFile[fi].FileName#" size="30" maxlength="128"><br>
							<small>Sub-Title</strong><br>
							<input type="text" name="FileSubTitle_#fi#" value="#aFile[fi].FileSubTitle#" size="30" maxlength="128"><br>
							<small>Author</small><br>
							<input type="text" name="Author_#fi#" value="#aFile[fi].Author#" size="30" maxlength="128"><br>
							<small>Date-Time Stamp</small><br>
							<input type="text" name="FileDateTimeStamp_#fi#" value="#aFile[fi].FileDateTimeStamp#" size="30" maxlength="128"><br>
							<small>Duration (in mm:ss)</small><br>
							<input type="text" name="FileDuration_#fi#" value="#aFile[fi].FileDuration#" size="30" maxlength="128"><br>
							
							
							</td>
							<td><small>Summary</small><br>
								<textarea cols="30" rows="3" name="FileCaption_#fi#">#aFile[fi].FileCaption#</textarea><br>
								<small>Keywords</small><br>
								<textarea cols="30" rows="3" name="FileKeywords_#fi#">#aFile[fi].FileKeywords#</textarea>
							</td>
							<td><small>Thumbnail<cfif aFile[fi].ThumbnailPath IS NOT "">: <a href="#aFile[fi].ThumbnailPath#" target="_blank">#ListLast(aFile[fi].ThumbnailPath,'/')#</a><br></cfif></small>
							<input type="file" name="ThumbnailPath_#fi#FileObject"><br>
							<cfif aFile[fi].FilePath is not ""><small>Main: <a href="#aFile[fi].FilePath#" target="_blank">#ListLast(aFile[fi].FilePath,'/')# (#DecimalFormat(Val(aFile[fi].FileSize)/1000000)#mb)</a></cfif>
								<cfif 0>
									<input type="text" size="100" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
								<cfelse>
									<input type="hidden" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
								</cfif>
								<input type="hidden" name="ThumbnailPath_#fi#" value="#aFile[fi].ThumbnailPath#">
							</td>
							<td nowrap>
								<cfoutput>
								<input type="text" name="Order_#fi#" value="#fi*10#" size="4" maxlength="4">
								<cfif ArrayLen(aFile) GT "1" and 0>
									<cfif fi IS NOT "1"><input type="image" name="ButtonSubmit_up_#fi#" value="up_#fi#" src="/common/images/widget_arrow_up.gif"><cfelse><img src="/common/images/widget_arrow_up_grey.gif"></cfif><cfif fi IS NOT ArrayLen(aFile)><input type="image" name="ButtonSubmit_down_#fi#" value="down_#fi#" src="/common/images/widget_arrow_down.gif"><cfelse><img src="/common/images/widget_arrow_down_grey.gif"></cfif>
									</cfif>
								</cfoutput>&nbsp;
							</td>
							<td><input type="checkbox" name="FileDelete_#fi#" value="1"></td>
							<input type="hidden" name="FileSize_#fi#" value="#aFile[fi].FileSize#">
						</tr>
						</cfoutput>
					<cfelse>
						<cfoutput>
						<tr>
							<td>
							#aFile[fi].FileName#<br>
							#aFile[fi].FileDateTimeStamp#</td>
							<td>#aFile[fi].FileCaption#</td>
							<td>
								<a href="#aFile[fi].FilePath#" target="_blank">#ListLast(aFile[fi].FilePath,'/')#</a>
								<input type="hidden" name="FileName_#fi#" value="#HTMLEditFormat(aFile[fi].FileName)#">
								<input type="hidden" name="FileDateTimeStamp_#fi#" value="#HTMLEditFormat(aFile[fi].FileDateTimeStamp)#">
								<input type="hidden" name="FileCaption_#fi#" value="#HTMLEditFormat(aFile[fi].FileCaption)#">
								<input type="hidden" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
								<input type="hidden" name="ThumbnailPath_#fi#" value="#aFile[fi].ThumbnailPath#">
								<input type="hidden" name="FileSize_#fi#" value="#aFile[fi].FileSize#">
								
							</td>
							<td colspan="2"></td>
						</tr>
						</cfoutput>
					</cfif>
				</cfloop>
				<cfif ArrayLen(aFile) GT "0">
					<tr><td colspan="5" align="right"><input type="submit" value="Update Files"></td></tr>
				</cfif>
		<cfoutput><input type="hidden" name="NumFiles" value="#fi#"></cfoutput>
		<cfif FormMode IS "ShowForm">
			<tr valign="top">
				<td><strong>New)</strong></td>
				<td><small>Title</small><br>
					<input type="text" name="FileName_New" value="" size="30" maxlength="128"><br>
					<small>Sub-Title</small><br>
					<input type="text" name="FileSubTitle_New" value="" size="30" maxlength="128"><br>
					<small>Author</small><br>
					<input type="text" name="Author_New" value="" size="30" maxlength="128"><br>
					<small>Date-Time Stamp</small><br>
					<input type="text" name="FileDateTimeStamp_New" size="30" maxlength="128" value="<cfoutput>#DateFormat(Now(),'mm/dd/yyyy')# #TimeFormat(Now())#</cfoutput>"><br>
					<small>Duration (in mm:ss)</small><br>
					<input type="text" name="FileDuration_New" value="" size="30" maxlength="128"><br>
				</td>
				<td><small>Summary</small><br>
				<textarea cols="30" rows="3" name="FileCaption_New"></textarea><br>
				<small>Keywords</small><br>
				<textarea cols="30" rows="3" name="FileKeywords_New"></textarea>
				</td>
				<td>
				Thumb:<br>
				<input type="file" name="ThumbnailPath_NewFileObject"><br>
				Main: <br>
				<cfif 0>
				<div id="flashUI" style="display: none;">
					<!-- The UI only gets displayed if SWFUpload loads properly -->
					<div>
						<input type="text" id="txtFileName" disabled="true"/><input id="btnBrowse" type="button" value="Browse..." onclick="fileBrowse.apply(swf_upload_control)" />
					</div>
					<div class="flash" id="fsUploadProgress">
						<!-- This is where the file progress gets shown.  SWFUpload doesn't update the UI directly.
							The Handlers (in handlers.js) process the upload events and make the UI updates -->
					</div>
					<input type="hidden" name="hidFileID" id="hidFileID" value="" /><!-- This is where the file ID is stored after SWFUpload uploads the file and gets the ID back from upload.php -->
				</div>
				<div id="degradedUI">
					<!-- This is the standard UI.  This UI is shown by default but when SWFUpload loads it will be
					hidden and the "flashUI" will be shown -->
					<input type="file" name="MainFilePath_NewFileObject" id="MainFilePath_NewFileObject" /><br/>
				</div>
				<cfelse>
					<input type="file" name="MainFilePath_NewFileObject">
				</cfif>
				
				</td>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr><td colspan="5" align="right"><input type="submit" name="btnUpdateFiles" id="btnUpdateFiles" value="Add New"></td></tr>
		</cfif>
		
		</table>
		</td></tr>
	<cfelseif MyContentLocale.GetContentTypeID() IS "221">
		<cfset aFile=MyContentLocale.GetProperty("aFile")>
		<TR><TD colspan="3"><b>Files</b></TD></TR>
		<TR>
			<td></td>
			<TD colspan="2">
				<table width="100%" border="0">
				<TR>
					<TD></TD>
					<TD><strong>Title / Caption</strong></TD>
					<TD colspan="2"><strong>Files</strong></TD>
					<TD>&nbsp;</TD>
					<TD><cfif ArrayLen(aFile) GT "0" and FormMode IS "ShowForm"><strong>Remove?</strong><cfelse>&nbsp;</cfif></TD>
				</TR>
				<cfloop index="fi" from="#ArrayLen(aFile)#" to="1" step="-1">
					<cfif NOT StructKeyExists(aFile[fi],"ThumbnailPath")>
						<cfset StructInsert(aFile[fi],"ThumbnailPath","",1)>
					</cfif>
					<cfif FormMode IS "ShowForm">
						<cfoutput>
							<tr valign="top">
							<TD><strong>#fi#)</strong></TD>
							<TD nowrap>
								<input type="text" name="FileName_#fi#" value="#aFile[fi].FileName#" size="40" maxlength="128"><br>
								<small>Caption</small><br>
								<textarea cols="40" rows="4"  name="FileCaption_#fi#">#aFile[fi].FileCaption#</textarea>
							</TD>
							<TD>
								Main: <cfif aFile[fi].FilePath is not ""><small><a href="#aFile[fi].FilePath#" target="_blank">#ListLast(aFile[fi].FilePath,'/')#</a></small></cfif><br>
								<input type="file" name="MainFilePath_#fi#FileObject" value="#aFile[fi].FilePath#" size="40">
								<input type="hidden" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
							</TD>
							<TD>
								Thumbnail: <cfif aFile[fi].ThumbnailPath IS NOT ""><small> <a href="#aFile[fi].ThumbnailPath#" target="_blank">#ListLast(aFile[fi].ThumbnailPath,'/')#</a></cfif><br>
								<input type="file" name="ThumbnailPath_#fi#FileObject" size="40">
								<input type="hidden" name="ThumbnailPath_#fi#" value="#aFile[fi].ThumbnailPath#">
							</TD>
							<TD nowrap>
								<cfoutput>
								<input type="text" name="Order_#fi#" value="#fi*10#" size="2" maxlength="4">
								</cfoutput>&nbsp;
							</TD>
							<TD><input type="checkbox" name="FileDelete_#fi#" value="1"></TD>
						</TR>
						</cfoutput>
					<cfelse>
						<cfoutput>#formMode#</cfoutput>
						<cfoutput>
						<TR>
							<TD><strong>#fi#)</strong></TD>
							<TD>#aFile[fi].FileName#</TD>
							<TD>#aFile[fi].FileCaption#</TD>
							<TD>
								<a href="#aFile[fi].FilePath#" target="_blank">#ListLast(aFile[fi].FilePath,'/')#</A>
								<input type="hidden" name="FileName_#fi#" value="#HTMLEditFormat(aFile[fi].FileName)#">
								<input type="hidden" name="FileCaption_#fi#" value="#HTMLEditFormat(aFile[fi].FileCaption)#">
								<input type="hidden" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
								<input type="hidden" name="ThumbnailPath_#fi#" value="#aFile[fi].ThumbnailPath#">
							</TD>
							<TD colspan="2"></TD>
						</tr>
						</cfoutput>
					</cfif>
				</cfloop>
				<cfif ArrayLen(aFile) GT "0">
					<TR><TD colspan="6" align="right"><input type="submit" value="Update Files"></TD></TR>
				</cfif>
				<cfoutput><input type="hidden" name="NumFiles" value="#ArrayLen(aFile)#"></cfoutput>
				<cfif FormMode IS "ShowForm">
					<tr valign="top">
						<TD></TD>
						<TD>
							<small>Title ( * required ) /  Caption</small><br>
							<input type="text" name="FileName_New" value="" size="40" maxlength="128"><br>
							<textarea cols="40" rows="3" name="FileCaption_New"></textarea>
						</TD>
						<TD>
							Main: <br>
							<input type="file" name="MainFilePath_NewFileObject" size="40">
							<br>
						</TD>
						
						<TD>
						Thumbnail: <br>
						<input type="file" name="ThumbnailPath_NewFileObject" size="40">
						</TD>
						<TD colspan="2">&nbsp;</TD>
					</TR>
					<TR><TD colspan="5" align="right"><input type="submit" name="btnUpdateFiles" id="btnUpdateFiles" value="Add New"></TD></TR>
				</cfif>
				
				</table>
				</TD></TR>
	<cfelse>
		<tr><td bgcolor="white" colspan="3"><b>Files</b></td></tr>
		<tr>
			<td bgcolor="white"></td>
			<td colspan="2" bgcolor="EAEAEA">
				<table width="100%" border="0">
				<cfset aFile=MyContentLocale.GetProperty("aFile")>
				<tr>
					<td><strong>Name</strong></td>
					<td><strong>Caption</strong></td>
					<td><strong>Link</strong></td>
					<td><strong>File</strong></td>
					<td>&nbsp;</td>
					<td><cfif ArrayLen(aFile) GT "0" and FormMode IS "ShowForm"><strong>Remove?</strong><cfelse>&nbsp;</cfif></td>
				</tr>
				<cfloop index="fi" from="1" to="#ArrayLen(aFile)#" step="1">
					<cfif NOT StructKeyExists(aFile[fi],"ThumbnailPath")>
						<cfset StructInsert(aFile[fi],"ThumbnailPath","",1)>
					</cfif>
					<cfif NOT StructKeyExists(aFile[fi],"LinkURL")>
						<cfset StructInsert(aFile[fi],"LinkURL","",1)>
					</cfif>
					<cfif FormMode IS "ShowForm">
						<cfoutput>
						<tr valign="top">
							<td><input type="text" name="FileName_#fi#" value="#aFile[fi].FileName#" size="20" maxlength="128"></td>
							<td><textarea cols="50" rows="4" name="FileCaption_#fi#">#aFile[fi].FileCaption#</textarea></td>
							<td><input type="text" name="LinkURL_#fi#" value="#aFile[fi].LinkURL#" size="40" maxlength="255"></td>
							<td>
								<a href="#aFile[fi].FilePath#" target="_blank">#ListLast(aFile[fi].FilePath,'/')#</a><BR>
								<input type="file" name="MainFilePath_#fi#FileObject">
								<input type="hidden" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
								<input type="hidden" name="ThumbnailPath_#fi#" value="#aFile[fi].ThumbnailPath#">
							</td>
							<td nowrap><input type="text" name="Order_#fi#" value="#fi*10#" size="2" maxlength="4">&nbsp;</td>
							<td><input type="checkbox" name="FileDelete_#fi#" value="1"></td>
						</tr>
						</cfoutput>
					<cfelse>
						<cfoutput>
						<tr>
							<td>#aFile[fi].FileName#</td>
							<td>#aFile[fi].FileCaption#</td>
							<td>#aFile[fi].LinkURL#</td>
							<td>
								<a href="#aFile[fi].FilePath#" target="_blank">#ListLast(aFile[fi].FilePath,'/')#</a>
								<input type="hidden" name="MainFilePath_#fi#" value="#aFile[fi].FilePath#">
								<input type="hidden" name="FileCaption_#fi#" value="#aFile[fi].FileCaption#">
								<input type="hidden" name="LinkURL_#fi#" value="#aFile[fi].LinkURL#">
							</td>
							<td colspan="2"><input type="hidden" name="FileName_#fi#" value="#HTMLEditFormat(aFile[fi].FileName)#"></td>
						</tr>
						</cfoutput>
					</cfif>
				</cfloop>
		<cfoutput><input type="hidden" name="NumFiles" value="#fi#"></cfoutput>
		<cfif FormMode IS "ShowForm">
			<tr valign="top">
				<td><input type="text" name="FileName_New" value="" size="20" maxlength="128"></td>
				<td><textarea cols="50" rows="4" name="FileCaption_New"></textarea></td>
				<td><input type="text" name="LinkURL_New" value="" size="40" maxlength="128"></td>
				<td><input type="file" name="MainFilePath_NewFileObject"><BR>Leave blank to insert label</td>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr><td colspan="5" align="right"><input type="submit" value="Update Files"></td></tr>
		</cfif>
		
		</table>
		</td></tr>
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"lPageID")>
	<style>
	#articleList { 
	  list-style-type:none;
	  margin:0;
	  padding:0;
	}
	#articleList li {
	 width:400px;
	 border:1px solid #000000;
	 margin:3px;
	 padding:3px;
	}
	.handle{
	 cursor:move;
	}
	</style>
	<cfset articleList = "">
	<cfif MyContentLocale.GetProperty('lArticleCategoryID') NEQ "">
		<cfloop list="#MyContentLocale.GetProperty('lArticleCategoryID')#" index="thisid">
			<cfquery name="getArticle" datasource="#APPLICATION.DSN#">
			SELECT	CategoryName, CategoryID 
			FROM	t_Category
			WHERE	CategoryID = <cfqueryparam value="#thisid#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfoutput query="getArticle">
				<cfset articleList = articleList & "<li id=""#CategoryID#""><span class=""handle"">#CategoryName#</span> <a href=""javascript:removeArticle('#CategoryID#');"">remove</a></li>">
			</cfoutput>
		</cfloop>
	</cfif>
	<tr valign="top">
		<td bgcolor="white"></td>
		<td bgcolor="white">
			Find Article:<br/>
			<input id="txtResource" name="txtResource" style="WIDTH: 200px" type="text" onKeyDown="return supressEnterKey(event);" onKeyUp="return getSuggestions(this, event);" /><br />
			<div id="suggest" style="z-index:1000;position:absolute; border-style:solid; border-color:#7F9DB9; /*overflow: inherit;*/ white-space:normal; visibility:hidden; width:398px; border-width:1px; font-size:11px; font-family:Arial, Helvetica, sans-serif; padding-left: 0px; color:#000000; background-color:#FFFFCC"></div>
		</td>
		<td><strong>Article List:</strong><br/><span style=" font-size:.9em;">(topmost article is 'featured spot')</span><br/><ul id="articleList"><cfoutput>#Trim(articleList)#</cfoutput></ul></td>
	</tr>
	<script src="/common/scripts/articleSelector.js" type="text/javascript"></script>
	<script type="text/javascript">
		document.getElementById('contentForm').onsubmit = function (e) {setResults();return true;};
		function setResults(){
			document.getElementById('lArticleCategoryID').value = getResults();
		} 
		<cfif articleList NEQ "">
		Sortable.create('articleList',{ghosting:true,handle:'handle',constraint:false});
		</cfif>
	</script>
	<input type="hidden" name="lArticleCategoryID" id="lArticleCategoryID" />
</cfif>

<cfif ListLen(MyContentLocale.GetFileList(),";") GT "0" and (IsDefined("FORM.ContentLocaleName") or structKeyExists(form, "ButProcess"))>
	<tr valign="top" bgcolor="white"><td colspan="3"><b>Please upload the following files</b></tr></tr>
	<cfset Counter="1">
	<cfloop index="ThisFile" list="#MyContentLocale.GetFileList()#" delimiters=";">
		<cfset ThisNewFile=ReplaceNoCase(ThisFile,"http://#CGI.Server_Name#","","All")>
		<cfset ThisNewFile=ReplaceNoCase(ThisNewFile,"//","/","All")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
			type="File" ObjectAction="ShowForm"
			caption="#ListLast(ThisNewFile,'/')#" DefaultValue="#ThisNewFile#"
			VarName="Image#Counter#"
			TempDir="#APPLICATION.WebRootPath##APPLICATION.UploadPath#" WebRootPath="#APPLICATION.WebRootPath#"
			Required="N">
		<cfset Counter=Counter+1>
	</cfloop>
</cfif>


<cfif MyContentLocale.GetProperty("LocaleID") IS NOT APPLICATION.DefaultLocaleID and MyContentLocale.GetProperty("ContentLocaleID") GT "0">
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