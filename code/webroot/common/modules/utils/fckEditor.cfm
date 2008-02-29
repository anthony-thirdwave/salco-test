<cfparam name="ATTRIBUTES.fieldname">
<cfparam name="ATTRIBUTES.Content">
<cfparam name="ATTRIBUTES.FileURL">
<cfparam name="ATTRIBUTES.Height">
<cfparam name="ATTRIBUTES.Width">
<cfparam name="ATTRIBUTES.toolbar" default="Default">
<cfscript>
	fckEditor = createObject("component", "/com/utils/fckeditor");
	fckEditor.instanceName="#ATTRIBUTES.fieldname#";
	fckEditor.basePath="/common/scripts/fckeditor/";
	fckEditor.value="#ATTRIBUTES.Content#";
	fckEditor.width="#ATTRIBUTES.Width#";
	fckEditor.height="#ATTRIBUTES.Height#";
	fckEditor.userDir="#ATTRIBUTES.FileURL#";
	fckEditor.toolbarset="#ATTRIBUTES.toolbar#";
		// ... additional parameters ...
	fckEditor.create(); // create instance now.
</cfscript>