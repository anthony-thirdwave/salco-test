<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">
<!--- Determine Domains --->

<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qTemplate">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="3000">
	<cfinvokeargument name="SortFieldName" value="LabelPriority">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset TemplateIDList="">
<cfoutput query="qTemplate">
	<cfset TemplateIDList=ListAppend(TemplateIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qEventRegistrationMode">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="4000">
	<cfinvokeargument name="SortFieldName" value="LabelPriority">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>
<cfset EventRegistrationModeIDList="">
<cfoutput query="qEventRegistrationMode">
	<cfset EventRegistrationModeIDList=ListAppend(EventRegistrationModeIDList,"{#LabelID#|#LabelName#}","^^")>
</cfoutput>

<cfif OpenAndCloseFormTables><table width="100%"></cfif>
<!--- <TR><TD bgcolor="bac0c9" colspan="3"><b>
<cfdump var="#MyLocale.getAllErrorMessages()#">
</b></TD></TR> --->
<TR><TD bgcolor="bac0c9" colspan="3"><b>Site Settings</b><br>
The following settings affect the look and feel of your site.</TD></TR>

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="select"
	caption="Display Template"
	ObjectName="MyLocale"
	PropertyName="TemplateID"
	OptionValues="#TemplateIDList#"
	Required="Y"
	FormEltStyle="width:200px;">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="Custom Head HTML" 
	ObjectName="MyLocale"
	PropertyName="CustomHeadHTML"
	cols="50" rows="4"
	Required="N">

<TR><TD bgcolor="bac0c9" colspan="3"><b>Event Registration Settings</b><br>
If you wish to take advantage of the event registration features of the ISK, please specify the settings below. If you wish to integrate with Verisign payment services, please specify your Verisign ID as well.</TD></TR>
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="select"
	caption="Event Registration Mode"
	ObjectName="MyLocale"
	PropertyName="DefaultEventRegistrationModeID"
	OptionValues="#EventRegistrationModeIDList#"
	Required="Y"
	FormEltStyle="width:200px;">

<cfif MyLocale.GetProperty("DefaultEventRegistrationModeID") is "4002">
	<cfset VerisignUserIDRequired="Y">
<cfelse>
	<cfset VerisignUserIDRequired="N">
</cfif>

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="text"
	caption="Versign User ID"
	ObjectName="MyLocale"
	PropertyName="VerisignUserID"
	size="40" maxlength="64"
	Required="#VerisignUserIDRequired#">


<cfif OpenAndCloseFormTables></table></cfif>