<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.Silent" default="No">

<cfset REQUEST.ContentGenerateMode="FLAT">
<cfset REQUEST.ReCache="1">

<cfset ThisContentPath="#APPLICATION.WebRootPath##Application.ContentPath#">

<cfif DirectoryExists(ThisContentPath) IS "No">
	<cfdirectory action="CREATE" directory="#ThisContentPath#">
</cfif>

<cfquery name="GetAllPages" datasource="#APPLICATION.DSN#">
	SELECT		*
	FROM		t_Category 
	WHERE		CategoryTypeID IN (<cfqueryparam value="#APPLICATION.lVisibleCategoryTypeID#" cfsqltype="cf_sql_integer" list="true">) 
			<cfif Val(ATTRIBUTES.CategoryID) GT "0">
				AND CategoryID = <cfqueryparam value="#Val(ATTRIBUTES.CategoryID)#" cfsqltype="cf_sql_integer">
			</cfif>
	ORDER BY	DisplayOrder
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
