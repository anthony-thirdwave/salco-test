<cfsetting  showdebugoutput="1" requesttimeout="25000">
<cfset LocaleIDValue="#APPLICATION.DefaultLocaleID#">
<cfparam name="ProductFamilyID" default="-1">
<cfquery name="GetTopCats" datasource="#APPLICATION.DSN#">
	select * from t_category Where ParentID = 2213
</cfquery>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/common/styles/default.css">
<link rel="stylesheet" type="text/css" href="/common/styles/corporate.css" title="docProperties">
	<title>Copy Product Images</title>
	<script language="JavaScript" type="text/JavaScript" src="/common/scripts/common.js"></script>
<script language=javascript src="/common/scripts/mm4.js"></script> 
</head>
<body>
<cfset baseDir = APPLICATION.WebRootPath & "resources\ProductImages\#DateFormat(Now(),'mmddyyyy')#_#TimeFormat(Now(),'hhmmss')#\">
<cfoutput query="GetTopCats">
	<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_locale Where localeID=2
	</cfquery>
	<cfset LanguageIDValue=GetLang.LanguageID>
	<cfquery name="GetCats" datasource="#APPLICATION.DSN#">
		SELECT * FROM t_Category
		WHERE 
		DisplayOrder LIKE '#DisplayOrder#%' and
		CategoryTypeID IN (62,64)
		order by DisplayOrder
	</cfquery>
	
	<cfset catName = Replace(CategoryName," ","_","all")>

	<cfset thisDir = baseDir & catName>
	
	<cfif DirectoryExists(thisDir)>
		<cfdirectory action="delete" directory="#thisDir#">
	</cfif>
	
	<cfdirectory action="create" directory="#thisDir#">
	
	<cfset thisFileDir = thisDir>
	<cfloop query="GetCats">
		<cfset catName = ReplaceList(REQUEST.RemoveHTML(CategoryName)," ,\,/","_,-,-")>
		<cfset catName = REReplace(catName,'&[.]*;','','all')>
		<cfset catName = Left(catName,50)>
		<cfif CategoryTypeID IS "62">
			<cfset thisFileDir = thisDir & "\" & catName>
			<cfif NOT DirectoryExists(thisFileDir)>
				<cfdirectory action="create" directory="#thisFileDir#">
			</cfif>
		<cfelse>
			<cfset thisProdFileDir = thisFileDir & "\" & catName>
			<cfif NOT DirectoryExists(thisProdFileDir)>
				<cfdirectory action="create" directory="#thisProdFileDir#">
			</cfif>
				
			<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetProduct">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(CategoryID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#Val(LocaleIDValue)#" null="No">
			</cfstoredproc>
			<cfsilent>
				<cfset MyProduct=CreateObject("component","lifefitness.com.Product.Product")>
				<cfset MyProduct.Constructor(Val(CategoryID),LanguageIDValue)>
				<cfset aView=MyProduct.GetProperty("aProductView")>
				
				<cfset lProps="ProductThumbnailPath">
				<cfloop index="ThisProp" list="#lProps#">
					<cfset SetVariable("This#ThisProp#",MyProduct.GetProperty(ThisProp))>
				</cfloop>
				
			</cfsilent>
			
			<cfif ThisProductThumbnailPath iS NOT "">
				<cfset thisExt = ListLast(ThisProductThumbnailPath,".")>
				<cfset thisDest = thisProdFileDir & "\#catName#_thumbnail.#thisExt#">
				<cfset thisSrc = REQUEST.GetPathFromURL(ThisProductThumbnailPath)>
				<cfif FileExists(thisSrc)>
					<cffile action="copy" source="#thisSrc#" destination="#thisDest#">
					FILE:#thisDest#<br><br>
				</cfif>
			</cfif>
			<cfif ArrayLen(aView) GT "0">
				<cfloop index="i" from="1" to="#ArrayLen(aView)#">
					<cfset fileNameAppend = ReplaceList(REQUEST.RemoveHTML(REQUEST.ReplaceMarks(aView[i].ResourceName))," ,\,/","_,-,-")>
					<cfset thisExt = ListLast(aView[i].MainFilePath,".")>
					<cfset thisSrc = REQUEST.GetPathFromURL(aView[i].MainFilePath)>
					<cfset thisDest = thisProdFileDir & "\#catName#_#fileNameAppend#.#thisExt#">
					<cfif FileExists(thisSrc)>
						<cffile action="copy" source="#thisSrc#" destination="#thisDest#">
						FILE:#thisDest#<br><br>
					</cfif>
				</cfloop>
			</cfif>
			
		</cfif>
		
		<cfflush>
	</cfloop>
</cfoutput>
</body>
</html>
