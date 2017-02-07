<cfparam name="ATTRIBUTES.fieldname">
<cfparam name="ATTRIBUTES.Content">
<cfparam name="ATTRIBUTES.FileURL">
<cfparam name="ATTRIBUTES.Height">
<cfparam name="ATTRIBUTES.Width">
<cfparam name="ATTRIBUTES.toolbar" default="Default">

<!--- initialize and return a fckEditor object --->
<cfinvoke method="init" component="com.utils.fckeditor" returnvariable="ATTRIBUTES.fckEditor">
	<cfif len(trim(ATTRIBUTES.fieldname))>
		<cfinvokeargument name="instanceName" value="#trim(ATTRIBUTES.fieldname)#">
	</cfif>
	<cfif len(trim(ATTRIBUTES.Content))>
		<cfinvokeargument name="value" value="#trim(ATTRIBUTES.Content)#">
	</cfif>
	<cfif len(trim(ATTRIBUTES.Width))>
		<cfinvokeargument name="width" value="#trim(ATTRIBUTES.Width)#">
	</cfif>
	<cfif len(trim(ATTRIBUTES.Height))>
		<cfinvokeargument name="height" value="#trim(ATTRIBUTES.Height)#">
	</cfif>
	<cfif len(trim(ATTRIBUTES.FileURL))>
		<cfinvokeargument name="userDir" value="#trim(ATTRIBUTES.FileURL)#">
	</cfif>
	<cfif len(trim(ATTRIBUTES.toolbar))>
		<cfinvokeargument name="toolbarset" value="#trim(ATTRIBUTES.toolbar)#">
	</cfif>
</cfinvoke>

<!--- create the editor in html--->
<cfset ATTRIBUTES.fckEditor.create()>