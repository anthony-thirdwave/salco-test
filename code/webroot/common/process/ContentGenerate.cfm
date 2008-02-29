<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.Silent" default="No">

<cfset REQUEST.ContentGenerateMode="FLAT">
<cfset REQUEST.ReCache="1">

<cfset ThisContentPath="#APPLICATION.WebRootPath##Application.ContentPath#">

<cfif DirectoryExists(ThisContentPath) IS "No">
	<cfdirectory action="CREATE" directory="#ThisContentPath#">
</cfif>

<cfquery name="GetAllPages" datasource="#APPLICATION.DSN#">
	select * from t_Category 
	Where CategoryTypeID IN (#APPLICATION.lVisibleCategoryTypeID#) 
	<cfif Val(ATTRIBUTES.CategoryID) GT "0">
		and CategoryID=#Val(ATTRIBUTES.CategoryID)#
	</cfif>
	order by DisplayOrder
</cfquery>

<cfif NOT ATTRIBUTES.Silent>
	<cfflush>
</cfif>

<cfoutput query="GetAllPages">
	Processing "#CategoryName# (#CategoryAlias#)"...
	<cfif NOT ATTRIBUTES.Silent>
		<cfflush>
	</cfif>
	
	<cfset CategoryID="#CategoryID#">
	<cfset Page="#CategoryAlias#">
	<cfsavecontent variable="ThisContent">
		<cfinclude template="/common/modules/contentmanager/content.cfm">
	</cfsavecontent>
	
	<cfset ThisFile="#ThisContentPath##CategoryAlias#.cfm">
	<cfif FileExists(ThisFile)>
		<cffile action="DELETE" file="#ThisFile#">
	</cfif>
	<cffile action="WRITE" file="#ThisFile#" output="#ThisContent#" addnewline="Yes">
	
	Done.<BR>
	
	<cfif NOT ATTRIBUTES.Silent>
		<cfflush>
	</cfif>

	
</cfoutput>
