<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">
<!--- Determine Domains --->

<cfset Restrictions=MyCategoryLocale.GetRestrictionsPropertyList()>

<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
	thiscategoryid="#MyCategory.GetProperty('ParentID')#"
	namelist=""
	idlist="#MyCategory.GetProperty('ParentID')#"
	aliaslist="">
	
<cfif ListLen(IDList) GTE "2">
	<cfset ThisSiteCategoryID=ListGetAt(IDList,2)>
<cfelse>
	<cfset ThisSiteCategoryID="-1">
</cfif>

<cfif OpenAndCloseFormTables><table width="100%"></cfif>

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

<cfif ThisSiteCategoryID IS NOT APPLICATION.intranetSiteCategoryID>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Page Title Override<BR><small>leave blank to use default</small>" 
		ObjectName="MyCategoryLocale"
		PropertyName="PageTitleOverride"
		size="80" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"CSSID") and ThisSiteCategoryID IS NOT APPLICATION.intranetSiteCategoryID>
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

<cfif APPLICATION.GetAllLocale.RecordCount GT 1>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Override URL" 
		ObjectName="MyCategoryLocale"
		PropertyName="CategoryLocaleURL"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ThisSiteCategoryID IS NOT APPLICATION.intranetSiteCategoryID>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="textarea"
		caption="Keywords" 
		ObjectName="MyCategoryLocale"
		PropertyName="MetaKeywords"
		cols="40" rows="3"
		EscapeCRLF="No"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"SubTitle")>
	<cfinvoke component="com.ContentManager.EmployeeHandler"
		method="qryEmployees"
		orderBy="empFirstName,empLastName"
		returnVariable="employees">
	
	<cfset EmployeeIDList="">
	<cfoutput query="employees">
		<cfset EmployeeName=employees.empFirstName &" "& employees.empLastName>
		<cfset EmployeeIDList=ListAppend(EmployeeIDList,"{#employees.empAlias#&#EmployeeName#|#EmployeeName#}","^^")>
	</cfoutput>

	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="Sub Title / Posted by"
		ObjectName="MyCategoryLocale"
		PropertyName="SubTitle"
		OptionValues="#EmployeeIDList#"
		FormEltStyle="width:200px;">
</cfif>
	
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="Description / Abstract" 
	ObjectName="MyCategoryLocale"
	PropertyName="MetaDescription"
	cols="40" rows="3"
	EscapeCRLF="No"
	Required="N">
	
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="text"
	caption="CSS ID<BR>Default will be alias of this page" 
	ObjectName="MyCategoryLocale"
	PropertyName="CSSID"
	size="40" maxlength="128"
	Required="N">
	
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="CSS Class" 
	ObjectName="MyCategoryLocale"
	PropertyName="CSSClass"
	cols="40" rows="3"
	EscapeCRLF="No"
	Required="N">

<cfif ListFindNoCase(Restrictions,"HomePageDisplay")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Display on Home Page?"
		ObjectName="MyCategoryLocale"
		PropertyName="HomePageDisplay">
</cfif>

<cfif ListFindNoCase(Restrictions,"EmergencyAlert")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="This is an alert?"
		ObjectName="MyCategoryLocale"
		PropertyName="EmergencyAlert">
</cfif>

<cfif ThisSiteCategoryID IS APPLICATION.intranetSiteCategoryID>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Include in screen saver?"
		ObjectName="MyCategoryLocale"
		PropertyName="IncludeInScreenSaver">
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

<cfif ListFindNoCase(Restrictions,"lRelatedPageID")>
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
		.handle {
			cursor:move;
		}
		a.suggest {
			text-decoration:none;
		}
		a.suggest:hover {
			text-decoration:underline;
		}
	</style>

	<cfset articleList="">
	<cfif MyCategoryLocale.GetProperty("lRelatedPageID") NEQ "">
		<cfloop list="#MyCategoryLocale.GetProperty('lRelatedPageID')#" index="thisID">
			<cfquery name="getArticle" datasource="#APPLICATION.DSN#">
				SELECT CategoryName, t_Category.CategoryID, attributeValue
				FROM t_Category LEFT OUTER JOIN
				t_ProductAttribute ON t_Category.CategoryID = t_ProductAttribute.CategoryID AND t_ProductAttribute.ProductFamilyAttributeID = 10
				WHERE t_Category.CategoryID=<cfqueryparam value="#thisID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfoutput query="getArticle">
				<cfif attributeValue IS NOT "">
					<cfset articleList=articleList & "<li id=""#CategoryID#""><span class=""handle"">#CategoryName# (#attributeValue#)</span> <a href=""javascript:removeArticle('#CategoryID#');"">remove</a></li>">
				<cfelse>
					<cfset articleList=articleList & "<li id=""#CategoryID#""><span class=""handle"">#CategoryName#</span> <a href=""javascript:removeArticle('#CategoryID#');"">remove</a></li>">
				</cfif>
			</cfoutput>
		</cfloop>
	</cfif>
	<TR valign="top"><td></td><td colspan="2">
	<cfif MyCategoryLocale.GetCategoryTypeID() IS "62"><!--- Product Family --->
		Highlighted Products
	<cfelse>
		Sub-Assemblies/Components
	</cfif>
	</td></tr>
	<TR valign="top">
		<TD bgcolor="white"></TD>
		<TD bgcolor="white">
			Find Product<br>
			(by Product No. or Alias):<br/>
			<input id="txtResource" name="txtResource" style="WIDTH: 200px" type="text" onKeyDown="return supressEnterKey(event);" onKeyUp="return getSuggestions(this, event);" /><br />
			<div id="suggest" style="z-index:1000;position:absolute; border-style:solid; border-color:#7F9DB9; /*overflow: inherit;*/ white-space:normal; visibility:hidden; width:600px; border-width:1px; font-size:11px; font-family:Arial, Helvetica, sans-serif; padding-left: 0px; color:#000000; background-color:#FFFFCC"></div>
		</TD>
		<TD><strong>Product List:</strong><br/><ul id="articleList"><cfoutput>#Trim(articleList)#</cfoutput></ul></TD>
	</TR>
	<script src="/common/scripts/pageSelector.js" type="text/javascript"></script>
	<script type="text/javascript">
		document.getElementById('categoryForm').onsubmit=function (e) {setResults();return true;};
		function setResults(){
			document.getElementById('lRelatedPageID').value=getResults();
		} 
		<cfif articleList NEQ "">
			Sortable.create('articleList',{ghosting:true,handle:'handle',constraint:false});
		</cfif>
	</script>
	<input type="hidden" name="lRelatedPageID" id="lRelatedPageID" />
</cfif>

<cfif MyCategoryLocale.GetCategoryTypeID() IS "81"><!--- This is a employee  --->
</table>
	<div class="RuleDotted1"></div>
	<strong>Employee Information</strong>
	<div class="RuleSolid1"></div>
	<table width="90%" cellspacing="1" cellpadding="1">
	<cfoutput>
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td>First Name</td>
			<td>Last Name</td>
			<td>Birth Date (mm/dd)</td>
		</tr>
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td><input type="text" name="empFirstName" value="#MyCategoryLocale.GetProperty('empFirstName')#" size="40" maxlength="128"></td>
			<td><input type="text" name="empLastName" value="#MyCategoryLocale.GetProperty('empLastName')#" size="40" maxlength="128"></td>
			<td><input type="text" name="empBirthDate" value="#MyCategoryLocale.GetProperty('empBirthDate')#" size="40" maxlength="128"></td>
		</tr>
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td>Title</td>
			<td>Hire Date (mm/dd/yyyy)</td>
			<td>Email</td>
		</tr>
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td><input type="text" name="empTitle" value="#MyCategoryLocale.GetProperty('empTitle')#" size="40" maxlength="128"></td>
			<td><input type="text" name="empJoinDate" value="#MyCategoryLocale.GetProperty('empJoinDate')#" size="40" maxlength="128"></td>
			<td><input type="text" name="empEmail" value="#MyCategoryLocale.GetProperty('empEmail')#" size="40" maxlength="128"></td>
		</tr>
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td>Phone (xxx-xxx-xxxx)</td>
			<td>Extension</td>
			<td>Cell Phone (xxx-xxx-xxxx)</td>
		</tr>
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td><input type="text" name="empPhone" value="#MyCategoryLocale.GetProperty('empPhone')#" size="40" maxlength="128"></td>
			<td><input type="text" name="empPhoneExt" value="#MyCategoryLocale.GetProperty('empPhoneExt')#" size="10" maxlength="10"></td>
			<td><input type="text" name="empCellPhone" value="#MyCategoryLocale.GetProperty('empCellPhone')#" size="40" maxlength="128"></td>
		</tr>
	</cfoutput>
</cfif>

<cfif MyCategoryLocale.GetCategoryTypeID() IS "73"><!--- This is a gallery  --->
	<cfparam name="lFileToImport" default="">
	<cfinvoke component=".com.Utils.Locale"
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
	<cfset StructInsert(sImageName,"CategoryImageBackground","Background Image",1)>
	<cfset StructInsert(sImageName,"CategoryImageOn","Navigation Image: On",1)>
	<cfset StructInsert(sImageName,"CategoryImageRollover","Rollover Outline Image",1)>
	<cfif MyCategory.GetProperty("CategoryTypeID") EQ 66>
		<cfset StructInsert(sImageName,"CategoryImageHeader","Featured Thumbnail <small>(285 x 128)</small>",1)>
	<cfelseif  MyCategory.GetProperty("CategoryTypeID") EQ 81>
		<cfset StructInsert(sImageName,"empImage","Employee Picture <small>(191 x 213)</small>",1)>
		<cfset StructInsert(sImageName,"empImageThumb","Thumbnail Image <small>(89 x 99)</small>",1)>
	<cfelse>
		<cfset StructInsert(sImageName,"CategoryImageHeader","Hero Image",1)>
	</cfif>
	<cfset StructInsert(sImageName,"CategoryImageAccent","Accent Image",1)>
	<cfset StructInsert(sImageName,"CategoryImageRepresentative","Listing Image",1)>
	<cfset firstImg=0>
	<cfloop index="ThisImage" list="CategoryImageBackground,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageAccent,CategoryImageRepresentative,empImage,empImageThumb">
		<cfif ListFindNoCase(Restrictions,ThisImage)>
			<cfset firstImg=firstImg+1>
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

<cfif ListFindNoCase(Restrictions,"ImageAltText1")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Image Alt Text" 
		ObjectName="MyCategoryLocale"
		PropertyName="ImageAltText1"
		size="40" maxlength="1000"
		Required="N">
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