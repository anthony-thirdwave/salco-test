<cfset locationURL = CGI.REQUEST_URI>
<cfif CGI.QUERY_STRING NEQ"">
	<cfset locationURL = locationURL & "?#CGI.QUERY_STRING#">
</cfif>
<cfset ValMsg = "">

<cfinclude template="addPageAction.cfm">

<cfparam name="FORM.qpa_PageName" default="">
<cfparam name="FORM.qpa_ParentID" default="">
<cfparam name="FORM.qpa_NextSiblingID" default="">
<cfparam name="FORM.qpa_ParentName" default="[none selected]">
<cfparam name="FORM.qpa_PlaceholderContent" default="">

<script language="javascript" type="text/javascript">
function chooseLocation(id,name){
	thisName = name + " (parent)";
	document.getElementById('qpa_ParentID').value = id;
	document.getElementById('qpa_NextSiblingID').value = "";
	document.getElementById('qpa_ParentName').value = thisName;
	document.getElementById('qpa_LocationName').innerHTML = thisName;
	closeChooser();
}

function chooseLocation_sibling(parentID,nextSiblingID,name){
	thisName = name + " (parent)";
	document.getElementById('qpa_ParentID').value = parentID;
	document.getElementById('qpa_NextSiblingID').value = nextSiblingID;
	document.getElementById('qpa_ParentName').value = thisName;
	document.getElementById('qpa_LocationName').innerHTML = thisName;
	closeChooser();
}

function openChooser(){
	document.getElementById('pageChooser').style.display = 'inline';
}
function closeChooser(){
	document.getElementById('pageChooser').style.display = 'none';
	if(qpa_isDivExpanded('857'))
		qpa_closeThisDiv('857');//"qpa_" is menu idprefix
}
</script>

Create a placeholder Page<br>
<div class="RuleSolid1"></div>
<cfoutput>
<cfif ValMsg NEQ "">
	<ul style="color:red;">#ValMsg#</ul>
</cfif>
<form method="post" action="#locationURL#">
<input type="hidden" name="qpa_WasSubmitted" value="1"> 
<input type="hidden" name="qpa_ParentID" id="qpa_ParentID" value="#FORM.qpa_ParentID#">
<input type="hidden" name="qpa_NextSiblingID" id="qpa_NextSiblingID" value="#FORM.qpa_NextSiblingID#">
<input type="hidden" name="qpa_ParentName" id="qpa_ParentName" value="#FORM.qpa_ParentName#"> 
<strong>Page Name</strong><br>
<input name="qpa_PageName" value="#FORM.qpa_PageName#" style="width:340px;"><br><br>
<strong>Select Location</strong> <a href="javascript:openChooser();">[choose]</a>

<div id="pageChooser" style="display:none; border:1px solid black; width:300px; background-color:##FFFFCC; position:absolute;">
	<div style="width:100%; text-align:right; font-weight:bold;"><a href="javascript:closeChooser();"><img src="/common/images/admin/icon_delete.gif" style="padding:2px;" border="0"/></a></div>
	<cfmodule template="/common/modules/admin/menu/menuAjax.cfm" 
		mvcid="-1" 
		isAutoCollapse="1" 
		JSFunctionName="chooseLocation"
		isNewPage="1"
		idPrefix="qpa_"/>
	&nbsp;
</div>

<br>
<div id="qpa_LocationName">#FORM.qpa_ParentName#</div>

<br>
<strong>Placeholder Block (Optional)</strong><br>
<cfmodule template="/common/modules/utils/fckeditor.cfm"
	fieldname="qpa_PlaceholderContent"
	fileURL="/common/incoming"
	height="200" width="340"
	Toolbar="Basic"
	Content="#FORM.qpa_PlaceholderContent#">
<br><br>
<input type="image" src="/common/images/admin/button_createpage.gif" value="create" name="createPageButton">
</form>
</cfoutput>