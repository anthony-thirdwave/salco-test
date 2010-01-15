<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">

<cfset Restrictions=MyContent.GetRestrictionsPropertyList()>

<!--- Determine Domains --->

<cfset GetContentTypes=MyContent.GetContentTypeIDSetQuery()>
<cfset ContentTypeIDList="">
<cfoutput query="GetContentTypes">
	<cfset ContentTypeIDList=ListAppend(ContentTypeIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="com.ContentManager.CategoryHandler" 
	method="GetNavCategoryQuery" 
	returnVariable="ValidParents">
<cfset CategoryIDList="">
<cfoutput query="ValidParents">
	<cfset Gutter="">
	<cfloop index="i" from="1" to="#DisplayLevel#" step="1">
		<cfset Gutter="#Gutter#&nbsp;&nbsp;">
	</cfloop>
	<cfset CategoryIDList=ListAppend(CategoryIDList,"{#CategoryID#|#Gutter##CategoryName#}","^^")>
</cfoutput>
<cfset SourceCategoryIDList=ListPrepend(CategoryIDList,"{-1|Use This Page}","^^")>
<cfset CategoryIDList=ListPrepend(CategoryIDList,"{-1|None (Top Level)}","^^")>

<cfif ListFindNoCase(Restrictions,"InheritID")>
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qInheritIDList">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Label">
		<cfinvokeargument name="FieldName" value="LabelGroupID">
		<cfinvokeargument name="FieldValue" value="230">
		<cfinvokeargument name="SortFieldName" value="LabelPriority">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
	<cfset InheritIDList="">
	<cfoutput query="qInheritIDList">
		<cfset InheritIDList=ListAppend(InheritIDList,"{#LabelID#|#LabelName#}","^^")>
	</cfoutput>
</cfif>

<cfif ListFindNoCase(Restrictions,"ShowQuestionRangeID")>
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qShowQuestionRangeID">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Label">
		<cfinvokeargument name="FieldName" value="LabelGroupID">
		<cfinvokeargument name="FieldValue" value="220">
		<cfinvokeargument name="SortFieldName" value="LabelPriority">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
	<cfset ShowQuestionRangeIDList="">
	<cfoutput query="qShowQuestionRangeID">
		<cfset ShowQuestionRangeIDList=ListAppend(ShowQuestionRangeIDList,"{#LabelID#|#LabelName#}","^^")>
	</cfoutput>
</cfif>

	
<cfif OpenAndCloseFormTables><table width="100%" cellspacing="1" cellpadding="2"></cfif>
<cfif APPLICATION.GetAllLocale.RecordCount GT 1><TR><TD bgcolor="bac0c9" colspan="3"><b>Default item details</b></TD></TR></cfif>
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="Title" 
	ObjectName="MyContent"
	PropertyName="ContentName"
	cols="50" rows="2"
	Required="Y">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="select"
	caption="Content Item Type" 
	ObjectName="MyContent"
	PropertyName="ContentTypeID"
	OptionValues="#ContentTypeIDList#"
	FormEltJavaScript="onchange=""this.form.submit()"""
	Required="Y">

<!--- <cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="select"
	caption="Display on page" 
	ObjectName="MyContent"
	PropertyName="CategoryID"
	OptionValues="#CategoryIDList#"
	Required="Y"
	FormEltStyle="width:200px;"> --->
<!--- BEGIN Category CHOOSER --->
<cfquery name="getCatName" datasource="#APPLICATION.DSN#">
	SELECT	CategoryName 
	FROM	t_Category
	WHERE	CategoryID =  <cfqueryparam value="#MyContent.GetProperty('CategoryID')#" cfsqltype="cf_sql_integer">
</cfquery>
<cfset thisCatName = getCatName.CategoryName>
<cfif FormMode NEQ "ShowForm">
	<cfset thisCatName = "[ #getCatName.CategoryName# ]">
</cfif>
<input type="hidden" name="CategoryID" id="CategoryID" value="<cfoutput>#MyContent.GetProperty('CategoryID')#</cfoutput>">
<cfif FormMode EQ "ShowForm">
	<script language="javascript" type="text/javascript">
		function chooseCatParent(id,name){
			thisName = name;
			document.getElementById('CategoryID').value = id;
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
		Display on page<cfif FormMode EQ "ShowForm"> <a href="javascript:openChooser();">[choose]</a></cfif>
		<cfif FormMode EQ "ShowForm">
			<div id="pageChooser" style="display:none; border:1px solid black; width:400px; background-color:#FFFFCC; position:absolute; z-index:1;/*overflow: inherit;*/ white-space:normal; margin:16px 0px 0px -142px;">
				<div style="width:100%; text-align:right; font-weight:bold;"><a href="javascript:closeChooser();"><img src="/common/images/admin/icon_delete.gif" style="margin:5px;" border="0"/></a></div>
				<cfmodule template="/common/modules/admin/menu/menuAjax.cfm" 
					mvcid="#MyContent.GetProperty('CategoryID')#" 
					isAutoCollapse="1" 
					JSFunctionName="chooseCatParent"
					isNewPage="0"
					idPrefix="catParent_"/>
				&nbsp;
			</div>
		</cfif>
		<img src="/common/images/spacer.gif" height="15" width="1">&nbsp;
	</TD>
	<Td bgcolor="white"  nowrap>
		<div id="LocationName"><cfoutput>#thisCatName#</cfoutput></div>
	</TD>
</TR> 
<!--- END PARENT PAGE CHOOSER --->


<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="YesNo"
	caption="State" 
	YesMark="Active"
	NoMark="Not active"
	ObjectName="MyContent"
	PropertyName="ContentActive">

<cfif ListFindNoCase(Restrictions,"ContentIndexed")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="YesNo"
		caption="Index?" 
		ObjectName="MyContent"
		PropertyName="ContentIndexed">
</cfif>

<cfif ListFindNoCase(Restrictions,"InheritID")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="Apply to" 
		ObjectName="MyContent"
		PropertyName="InheritID"
		OptionValues="#InheritIDList#"
		Required="Y">
</cfif>

<cfif ListFindNoCase(Restrictions,"ShowNavigationRangeID")>
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qShowNavigationRangeIDList">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Label">
		<cfinvokeargument name="FieldName" value="LabelGroupID">
		<cfinvokeargument name="FieldValue" value="2000">
		<cfinvokeargument name="SortFieldName" value="LabelPriority">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
	<cfset ShowNavigationRangeIDList="">
	<cfoutput query="qShowNavigationRangeIDList">
		<cfset ShowNavigationRangeIDList=ListAppend(ShowNavigationRangeIDList,"{#LabelID#|#LabelName#}","^^")>
	</cfoutput>
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="Show which items?" 
		ObjectName="MyContent"
		PropertyName="ShowNavigationRangeID"
		OptionValues="#ShowNavigationRangeIDList#"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"DisplayModeID")>
	<cfswitch expression="#MyContent.GetProperty("ContentTypeID")#">
		<cfcase value="230">
			<cfset thisGroupID = 12000>
			<cfset dspCapt = "Display Mode">
			<cfset dspModeReq = "N">
		</cfcase>
		<cfcase value="264">
			<cfset thisGroupID = 11000>
			<cfset dspCapt = "RSS Feed Type">
			<cfset dspModeReq = "Y">
		</cfcase>
		<cfdefaultcase>
			<cfset thisGroupID = 2100>
			<cfset dspCapt = "Display Mode">
			<cfset dspModeReq = "N">
		</cfdefaultcase>
	</cfswitch>
	<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="qDisplayModeID">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Label">
		<cfinvokeargument name="FieldName" value="LabelGroupID">
		<cfinvokeargument name="FieldValue" value="#thisGroupID#">
		<cfinvokeargument name="SortFieldName" value="LabelPriority">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
	<cfset DisplayModeIDList="">
	<cfoutput query="qDisplayModeID">
		<cfset DisplayModeIDList=ListAppend(DisplayModeIDList,"{#LabelID#|#LabelName#}","^^")>
	</cfoutput>
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="#dspCapt#" 
		ObjectName="MyContent"
		PropertyName="DisplayModeID"
		OptionValues="#DisplayModeIDList#"
		Required="#dspModeReq#">
</cfif>

<cfif ListFindNoCase(Restrictions,"ShowQuestionRangeID")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="Show which questions?" 
		ObjectName="MyContent"
		PropertyName="ShowQuestionRangeID"
		OptionValues="#ShowQuestionRangeIDList#"
		Required="Y">
</cfif>

<cfif ListFindNoCase(Restrictions,"SourceCategoryID")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="select"
		caption="Source" 
		ObjectName="MyContent"
		PropertyName="SourceCategoryID"
		OptionValues="#SourceCategoryIDList#"
		Required="Y"
		FormEltStyle="width:200px;">
</cfif>


<cfif ListFindNoCase(Restrictions,"ContentDate1")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Date" 
		ObjectName="MyContent"
		PropertyName="ContentDate1"
		size="40" maxlength="128"
		Required="N"
		Date="Y">
</cfif>

<cfif ListFindNoCase(Restrictions,"ContentDate2")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="End Date" 
		ObjectName="MyContent"
		PropertyName="ContentDate2"
		size="40" maxlength="128"
		Required="N"
		Date="Y">
</cfif>

<cfif ListFindNoCase(Restrictions,"OwnerName")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Owner Name" 
		ObjectName="MyContent"
		PropertyName="OwnerName"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"OwnerEmail")>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm" TDBGColor2="white"
		ObjectAction="#FormMode#"
		type="text"
		caption="Owner Email" 
		ObjectName="MyContent"
		PropertyName="OwnerEmail"
		size="40" maxlength="128"
		Required="N">
</cfif>

<cfif ListFindNoCase(Restrictions,"SourceID")>
	<cfif MyContent.GetProperty("ContentTypeID") IS "234"><!--- Templatized Content --->
		<cfinvoke component="com.ContentManager.ContentHandler" 
			method="GetContentTemplatePicker" 
			returnVariable="GetContentTemplatePicker">
		<cfset ContentIDList="">
		<cfoutput query="GetContentTemplatePicker" group="categoryID">
			<cfset Gutter="">
			<cfloop index="i" from="1" to="#DisplayLevel#" step="1">
				<cfset Gutter="#Gutter#&nbsp;&nbsp;&nbsp;">
			</cfloop>
			<cfset ContentIDList=ListAppend(ContentIDList,"{0|#Gutter##CategoryName# (#CategoryTypeName#)}","^^")>
			<cfoutput group="ContentPositionID">
				<cfset Gutter2="#Gutter#&nbsp;&nbsp;&nbsp;">
				<cfset ContentIDList=ListAppend(ContentIDList,"{0|#Gutter2##ContentPositionName# Position}","^^")>
				<cfoutput group="ContentID">
					<cfset Gutter3="#Gutter2#&nbsp;&nbsp;&nbsp;">
					<cfset ContentIDList=ListAppend(ContentIDList,"{#ContentID#|#Gutter3##ContentName# (#ContentTypeName#)}","^^")>
				</cfoutput>
			</cfoutput>
		</cfoutput>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Content Template" 
			ObjectName="MyContent"
			PropertyName="SourceID"
			OptionValues="#ContentIDList#"
			Required="Y"
			FormEltJavaScript="onchange=""this.form.submit()"""
			FormEltStyle="width:200px;">
	<cfelseif listContains("249,250",MyContent.GetProperty("ContentTypeID"))><!--- Gallery Thumbnanil Navigation and Display --->
		<cfinvoke component="com.ContentManager.CategoryHandler" 
			method="GetCategoryPicker" 
			CategoryTypeID="73"
			LocaleID="#EditLocaleID#"
			returnVariable="GetContentPicker">
		<cfset ContentIDList="">
		<cfoutput query="GetContentPicker" group="categoryID">
			<cfset ContentIDList=ListAppend(ContentIDList,"{#CategoryID#|#CategoryName#}","^^")>
		</cfoutput>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Source Content" 
			ObjectName="MyContent"
			PropertyName="SourceID"
			OptionValues="#ContentIDList#"
			Required="Y"
			FormEltStyle="width:200px;">
	<cfelse>
		<cfinvoke component="com.ContentManager.ContentHandler" 
			method="GetContentPicker" 
			ContentTypeID="#MyContent.GetProperty('ContentTypeID')#" 
			returnVariable="GetContentPicker"
			LocaleID="#EditLocaleID#">
		<cfset ContentIDList="">
		<cfoutput query="GetContentPicker" group="categoryID">
			<cfset Gutter="">
			<cfloop index="i" from="1" to="#DisplayLevel#" step="1">
				<cfset Gutter="#Gutter#&nbsp;&nbsp;&nbsp;">
			</cfloop>
			<cfset ContentIDList=ListAppend(ContentIDList,"{0|#Gutter##CategoryName# (#CategoryTypeName#)}","^^")>
			<cfoutput group="ContentPositionID">
				<cfset Gutter2="#Gutter#&nbsp;&nbsp;&nbsp;">
				<cfset ContentIDList=ListAppend(ContentIDList,"{0|#Gutter2##ContentPositionName# Position}","^^")>
				<cfoutput group="ContentID">
					<cfset Gutter3="#Gutter2#&nbsp;&nbsp;&nbsp;">
					<cfset ContentIDList=ListAppend(ContentIDList,"{#ContentID#|#Gutter3##ContentName# (#ContentTypeName#)}","^^")>
				</cfoutput>
			</cfoutput>
		</cfoutput>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="select"
			caption="Source Content" 
			ObjectName="MyContent"
			PropertyName="SourceID"
			OptionValues="#ContentIDList#"
			Required="Y"
			FormEltStyle="width:200px;">
	</cfif>
</cfif>

<cfif ListFindNoCase(Restrictions,"lTopicID")>
	<cfinvoke component="com.Topic.TopicHandler" method="GetTopicQuery" returnvariable="getTopics">
	<cfset TopicList="">
	<cfoutput query="getTopics">
		<cfset TopicList=ListAppend(TopicList,"{#ID#|" & RepeatString("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", level-1) & "-#name#}","^^")>
	</cfoutput>
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="MultiSelect"
		caption="Topics"
		ObjectName="MyContent"
		PropertyName="lTopicID"
		Default=""
		FormEltStyle="width:300px; height:250px;"
		OptionValues="#TopicList#"
		Required="N">
</cfif>

<cfif MyContent.GetProperty("ContentID") GT "0" AND 0>
	<TR><TD bgcolor="bac0c9" colspan="3"><b>Content Item Stats</b></TD></TR>
	<cfoutput>
		<TR><TD bgcolor="white">&nbsp;</TD><TD bgcolor="white">Content ID</TD><TD bgcolor="white">[ #MyContent.GetProperty("ContentID")# ]</TD></TR>
		<TR><TD bgcolor="white">&nbsp;</TD><TD bgcolor="white">Current State</TD><TD bgcolor="white">[ <cfif MyContent.GetProperty("ContentActive")>Active<cfelse>Not active</cfif> ]</TD></TR>
		<TR><TD bgcolor="white">&nbsp;</TD><TD bgcolor="white">Created</TD><TD bgcolor="white">
		<cfinvoke component="com.utils.tracking" method="GetTracking" returnVariable="ReturnString"
			Entity="Content"
			KeyID="#MyContent.GetProperty("ContentID")#"
			Operation="create">[ #ReturnString# ]
		</TD></TR>
		<TR><TD bgcolor="white">&nbsp;</TD><TD bgcolor="white">Last modified</TD><TD bgcolor="white">
		<cfinvoke component="com.utils.tracking" method="GetTracking" returnVariable="ReturnString"
			Entity="Content"
			KeyID="#MyContent.GetProperty("ContentID")#"
			Operation="modify">[ #ReturnString# ]
		</TD></TR>
	</cfoutput>
</cfif>

<cfif OpenAndCloseFormTables></table></cfif>