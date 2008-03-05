<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">
<cfparam name="DeleteCategoryImageHeader" default="0">
<!--- Determine Domains --->


<cfset ValidCategoryTypes=MyCategory.GetCategoryTypeIDSetQuery()>
<cfset CategoryTypeIDList="">
<cfoutput query="ValidCategoryTypes">
	<cfset CategoryTypeIDList=ListAppend(CategoryTypeIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<!---
<cfset ValidParents=MyCategory.GetParentCategorySetQuery()>
<cfset CategoryIDList="">
<cfoutput query="ValidParents">
	<cfset Gutter="">
	<cfloop index="i" from="1" to="#DisplayLevel#" step="1">
		<cfset Gutter="#Gutter#&nbsp;&nbsp;">
	</cfloop>
	<cfif EditCategoryID IS NOT CategoryID>
		<cfset CategoryIDList=ListAppend(CategoryIDList,"{#CategoryID#|#Gutter##CategoryName#}","^^")>
	</cfif>
</cfoutput>
<cfset CategoryIDList=ListPrepend(CategoryIDList,"{-1|None (Top Level)}","^^")>--->

<cfset Restrictions=MyCategory.GetRestrictionsPropertyList()>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qSource">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="130">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset SourceIDList="">
<cfoutput query="qSource">
	<cfset SourceIDList=ListAppend(SourceIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qBrand">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="150">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset BrandIDList="">
<cfoutput query="qBrand">
	<cfset BrandIDList=ListAppend(BrandIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qConsole">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="160">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset ConsoleIDList="">
<cfoutput query="qConsole">
	<cfset ConsoleIDList=ListAppend(ConsoleIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qTemplate">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="200">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset TemplateIDList="">
<cfoutput query="qTemplate">
	<cfset TemplateIDList=ListAppend(TemplateIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qColorID">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="210">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset ColorIDList="">
<cfoutput query="qColorID">
	<cfset ColorIDList=ListAppend(ColorIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qProductProgramTypeIDList">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_category">
	<cfinvokeargument name="FieldName" value="ParentID">
	<cfinvokeargument name="FieldValue" value="809">
	<cfinvokeargument name="SortFieldName" value="Categoryname">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset ProductProgramTypeIDList="">
<cfoutput query="qProductProgramTypeIDList">
	<cfset ProductProgramTypeIDList=ListAppend(ProductProgramTypeIDList,"{#CategoryID#|#CategoryName#}","^^")>
</cfoutput>


<cfif OpenAndCloseFormTables><table width="100%"></cfif>
<!--- <TR><TD bgcolor="bac0c9" colspan="3"><b>
<cfdump var="#MyCategory.getAllErrorMessages()#">
</b></TD></TR>
<TR><TD bgcolor="bac0c9" colspan="3"><b>Page Details (Master)</b></TD></TR> --->

<cfif ListFindNoCase(Restrictions,"CategoryName")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Page Name"
		ObjectName="MyCategory"
		PropertyName="CategoryName"
		size="40" maxlength="128"
		Required="Y">
</cfif>

<cfif 1>
	<cfif ListFindNoCase(Restrictions,"CategoryAlias")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Alias"
			ObjectName="MyCategory"
			PropertyName="CategoryAlias"
			size="40" maxlength="64"
			Required="N">
	</cfif>
</cfif>

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="select"
	caption="Page Type"
	ObjectName="MyCategory"
	PropertyName="CategoryTypeID"
	OptionValues="#CategoryTypeIDList#"
	FormEltJavaScript="onchange=""this.form.submit()"""
	Required="Y"
	FormEltStyle="width:200px;">

<cfif ListFindNoCase(Restrictions,"TemplateID")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="Template Type"
		ObjectName="MyCategory"
		PropertyName="TemplateID"
		OptionValues="#TemplateIDList#"
		Required="Y"
		FormEltStyle="width:200px;">
</cfif>

<cfif ListFindNoCase(Restrictions,"UserloginAccess")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Username Access"
		ObjectName="MyCategory"
		PropertyName="UserloginAccess"
		size="40" maxlength="64"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"CategoryActive")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Active"
		ObjectName="MyCategory"
		PropertyName="CategoryActive">
</cfif>

<cfif ListFindNoCase(Restrictions,"ShowInNavigation")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Show In Navigation"
		ObjectName="MyCategory"
		PropertyName="ShowInNavigation">
</cfif>

<cfif ListFindNoCase(Restrictions,"CategoryIndexed")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Include Page in Counter"
		ObjectName="MyCategory"
		PropertyName="CategoryIndexed">
</cfif>

<cfif ListFindNoCase(Restrictions,"AllowComments")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Allow Comments?"
		ObjectName="MyCategory"
		PropertyName="AllowComments">
</cfif>

<cfif ListFindNoCase(Restrictions,"AllowBackToTop")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="checkbox"
		caption="Allow Back to Top Link?"
		ObjectName="MyCategory"
		PropertyName="AllowBackToTop">
</cfif>

<cfif ListFindNoCase(Restrictions,"ParentID")>
	<cfset ParentIDFormMode=FormMode>
<cfelse>
	<cfset ParentIDFormMode="Validate">
</cfif>
<!---
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#ParentIDFormMode#"
	type="select"
	caption="Parent Page"
	ObjectName="MyCategory"
	PropertyName="ParentID"
	OptionValues="#CategoryIDList#"
	Required="N"
	FormEltStyle="width:200px;"> --->

<!--- BEGIN PARENT PAGE CHOOSER --->
<cfquery name="getParentName" datasource="#APPLICATION.DSN#">
	SELECT CategoryName FROM t_Category
	WHERE CategoryID = #MyCategory.GetProperty('ParentID')#
</cfquery>
<cfset thisParentName = getParentName.CategoryName>
<cfif FormMode NEQ "ShowForm">
	<cfset thisParentName = "[ #getParentName.CategoryName# ]">
</cfif>
<input type="hidden" name="ParentID" id="ParentID" value="<cfoutput>#MyCategory.GetProperty('ParentID')#</cfoutput>">
<cfif FormMode EQ "ShowForm">
	<script language="javascript" type="text/javascript">
		function chooseCatParent(id,name){
			thisName = name;
			document.getElementById('ParentID').value = id;
			//document.getElementById('qpa_ParentName').value = thisName;
			document.getElementById('LocationName').innerHTML = thisName;
			closeChooser();
		}
		
		function openChooser(){
			<cfif SESSION.currentbrowserapp EQ "IE">hideSelect();</cfif>
			document.getElementById('pageChooser').style.display = 'inline';
		}
		function closeChooser(){
			document.getElementById('pageChooser').style.display = 'none';
			if(catParent_isDivExpanded('857'))
				catParent_closeThisDiv('857');//"catParent_" is menu idprefix
			<cfif SESSION.currentbrowserapp EQ "IE">restoreSelect();</cfif>
		}	
		<cfif SESSION.currentbrowserapp EQ "IE">
		function hideSelect(){
			for (var i = 0; i < document.forms.length; i++) {
				f = document.forms[i];
				for (var x = 0; x < f.elements.length; x++) {
					e = f.elements[x];
					if(e.type == 'select-multiple' || e.type == 'select-one'){
						if(e.style) e.style.display = 'none';
					}
				}
			}
		}
		function restoreSelect(){
			for (var i = 0; i < document.forms.length; i++) {
				f = document.forms[i];
				for (var x = 0; x < f.elements.length; x++) {
					e = f.elements[x];
					if(e.type == 'select-multiple' || e.type == 'select-one'){
						if(e.style) e.style.display = '';
					}
				}
			}
		}
		</cfif>
	</script>
</cfif>
<tr valign="top"> 
	<TD bgcolor="white"></TD><TD nowrap bgcolor="white" class="allcaps">
		Parent Page<cfif FormMode EQ "ShowForm"> <a href="javascript:openChooser();">[choose]</a></cfif>
		<cfif FormMode EQ "ShowForm">
			<div id="pageChooser" style="display:none; border:1px solid black; width:400px; background-color:#FFFFCC; position:absolute; z-index:1;/*overflow: inherit;*/ white-space:normal;">
				<div style="width:100%; text-align:right; font-weight:bold;"><a href="javascript:closeChooser();"><img src="/common/images/admin/icon_delete.gif" style="padding:2px;" border="0"/></a></div>
				<cfmodule template="/common/modules/admin/menu/menuAjax.cfm" 
					mvcid="#MyCategory.GetProperty('CategoryID')#" 
					isAutoCollapse="1" 
					JSFunctionName="chooseCatParent"
					isParentChooser="1"
					isNewPage="0"
					idPrefix="catParent_"/>
				&nbsp;
			</div>
		</cfif>
		<img src="/common/images/spacer.gif" height="15" width="1">&nbsp;
	</TD>
	<Td bgcolor="white"  nowrap>
		<div id="LocationName"><cfoutput>#thisParentName#</cfoutput></div>
	</TD>
</TR> 
<!--- END PARENT PAGE CHOOSER --->

<cfoutput>
	<cfif ListFindNoCase(Restrictions,"CategoryURL")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Override URL"
			ObjectName="MyCategory"
			PropertyName="CategoryURL"
			size="40" maxlength="512"
			Required="N"
			BlankMessage="none">
	</cfif>


	<cfif ListFindNoCase(Restrictions,"Foobar") and 0><!--- india --->
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="foo bar"
			ObjectName="MyCategory"
			PropertyName="foobar"
			size="40" maxlength="128"
			Required="N">
	</cfif>


	<cfif ListFindNoCase(Restrictions,"AuthorName")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Author Name"
			ObjectName="MyCategory"
			PropertyName="AuthorName"
			size="40" maxlength="128"
			Required="N">
	</cfif>

	<cfif ListFindNoCase(Restrictions,"AuthorName")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Press Release Date"
			ObjectName="MyCategory"
			PropertyName="PressReleaseDate"
			size="40" maxlength="128"
			Required="N">
	</cfif>

	<cfif ListFindNoCase(Restrictions,"ArticleSourceID")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Article Source"
			ObjectName="MyCategory"
			PropertyName="ArticleSourceID"
			OptionValues="#SourceIDList#"
			Required="N"
			FormEltStyle="width:200px;">
	</cfif>

	<cfif ListFindNoCase(Restrictions,"ProductBrandLogoID")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Product Brand"
			ObjectName="MyCategory"
			PropertyName="ProductBrandLogoID"
			OptionValues="#BrandIDList#"
			Required="N"
			FormEltStyle="width:200px;">
	</cfif>

	<cfif ListFindNoCase(Restrictions,"ProductConsoleTypeID")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Console Type"
			ObjectName="MyCategory"
			PropertyName="ProductConsoleTypeID"
			OptionValues="#ConsoleIDList#"
			Required="N"
			FormEltStyle="width:200px;">
	</cfif>

	<cfif ListFindNoCase(Restrictions,"ColorID")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Color Code"
			ObjectName="MyCategory"
			PropertyName="ColorID"
			OptionValues="#ColorIDList#"
			Required="N"
			FormEltStyle="width:200px;">
	</cfif>

	<cfif ListFindNoCase(Restrictions,"ProductProgramTypeID")>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Program Type"
			ObjectName="MyCategory"
			PropertyName="ProductProgramTypeID"
			OptionValues="#ProductProgramTypeIDList#"
			Required="N"
			FormEltStyle="width:200px;">
	</cfif>

	<Cf_venn
		ListA="#Restrictions#"
		ListB="ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer,ProductionDBName"
		AandB="Intersection">
	<cfif ListLen(Intersection) GT "0">
		<!--- <TR><TD bgcolor="bac0c9" colspan="3"><b>Production Server Information</b></TD></TR> --->
		</table>
		<div class="RuleDotted1"></div>
		<strong>Production Server Information</strong>
		<div class="RuleSolid1"></div>
		<table width="90%" cellspacing="1" cellpadding="1">
		<tr>
			<td width="1%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td width="25%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
			<td width="74%"><img src="/common/images/spacer.gif" height="1" width="1"/></td>
		</tr>
		<cfset ProdInfoRequired="N">
		<cfloop index="ThisProperty" list="ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer">
			<cfif MyCategory.GetProperty("#ThisProperty#") IS NOT "">
				<cfset ProdInfoRequired="Y">
			</cfif>
		</cfloop>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="FTP Host"
			ObjectName="MyCategory"
			PropertyName="ProductionFTPHost"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="FTP Root Path"
			ObjectName="MyCategory"
			PropertyName="ProductionFTPRootPath"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="FTP User Login"
			ObjectName="MyCategory"
			PropertyName="ProductionFTPUserLogin"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="FTP User Password"
			ObjectName="MyCategory"
			PropertyName="ProductionFTPPassword"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Production DB Server"
			ObjectName="MyCategory"
			PropertyName="ProductionDBServer"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Production DB Name"
			ObjectName="MyCategory"
			PropertyName="ProductionDBName"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Production DB Name"
			ObjectName="MyCategory"
			PropertyName="ProductionDBDSN"
			size="40" maxlength="128"
			Required="#ProdInfoRequired#">
	</cfif>

	<Cf_venn
		ListA="#Restrictions#"
		ListB="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle"
		AandB="Intersection">
	<cfif ListLen(Intersection) GT "0">
		<TR><TD bgcolor="bac0c9" colspan="3"><b>Images</b></TD></TR>
		<cfset sImageName=StructNew()>
		<cfset StructInsert(sImageName,"CategoryImageOff","Off Image",1)>
		<cfset StructInsert(sImageName,"CategoryImageOn","On Image",1)>
		<cfset StructInsert(sImageName,"CategoryImageRollover","Highlight Image",1)>
		<cfset StructInsert(sImageName,"CategoryImageHeader","Header Image",1)>
		<cfset StructInsert(sImageName,"CategoryImageTitle","Title Image",1)>

		<cfloop index="ThisImage" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle">
			<cfif ListFindNoCase(Restrictions,"#ThisImage#")>
				<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
					ObjectAction="#FormMode#"
					type="File"
					caption="#sImageName[ThisImage]#"
					ObjectName="MyCategory"
					PropertyName="#ThisImage#"
					Required="N">
				<cfif MyCategory.GetProperty("#ThisImage#") is not "">
					<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
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
</cfoutput>

<cfif OpenAndCloseFormTables></table></cfif>