<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.SpecificationSetID" default="8000">
<cfif IsDefined("APPLICATION.LanguageID")>
	<cfparam name="ATTRIBUTES.LanguageID" default="#APPLICATION.LanguageID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LanguageID" default="100">
</cfif>

<cfif IsDefined("APPLICATION.LocaleID")>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.LocaleID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
</cfif>

<cfif Val(ATTRIBUTES.ProductID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProduct">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
	</cfstoredproc>
	<cfinvoke component="/com/Product/ProductHandler"
		method="GetProductFamilyID"
		returnVariable="CurrentProductFamilyID"
		ProductID="#ATTRIBUTES.ProductID#">
	<cfquery name="GetCache" datasource="#APPLICATION.DSN#">
		SELECT     MAX(CacheDateTime) AS CacheDateTime
		FROM         t_Category
		WHERE     CategoryID IN (#ATTRIBUTES.ProductID#,#Val(CurrentProductFamilyID)#)
	</cfquery>
	<cfset ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductDetailOther_v1.0_#ATTRIBUTES.ProductID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or 1>
		<cfsaveContent Variable="FileContents">
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfset MyProduct.Constructor(Val(ATTRIBUTES.ProductID),ATTRIBUTES.LanguageID)>
			<cfset aDownload=MyProduct.GetProperty("aProductDownload")>
			<cfset lProps="PublicDrawing,PublicDrawingSize">
			<cfloop index="ThisProp" list="#lProps#">
				<cfset SetVariable("This#ThisProp#",MyProduct.GetProperty(ThisProp))>
			</cfloop>

			<cfset tempArray=ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
				<cfif aDownload[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aDownload[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aDownload[i])>
				</cfif>
			</cfloop>
			<cfset aDownload=tempArray>
			
			<cfoutput>
				<cfif ArrayLen(aDownload) GT "0" or (ThisPublicDrawing IS NOT "" and FileExists(ExpandPath(ThisPublicDrawing)))>
					<h4>Downloads</h4>
					<cfif ThisPublicDrawing IS NOT "" and FileExists(ExpandPath(ThisPublicDrawing))>
						<p><a href="#APPLICATION.utilsObj.GetFreewheelLink(ThisPublicDrawing)#" target="_blank">CAD Drawing</a>
						(#UCase(ListLast(ThisPublicDrawing,"."))#<cfif Val(ThisPublicDrawingSize) GT "0">, #Ceiling(ThisPublicDrawingSize/1024)#KB</cfif>, <a href="#ThisPublicDrawing#">download</a>)<br/>
						</p>
					</cfif>
					<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
						<p><a href="#APPLICATION.utilsObj.GetFreewheelLink(aDownload[i].MainFilePath)#" target="_blank">#aDownload[i].ResourceName#</a>
						(#UCase(ListLast(aDownload[i].MainFilePath,"."))#<cfif StructKeyExists(aDownload[i],"MainFileSize") AND Val(aDownload[i].MainFileSize) GT "0">, #Ceiling(aDownload[i].MainFileSize/1024)#KB</cfif>)<br/>
						#aDownload[i].ResourceText#
						</p>
					</cfloop>
				</cfif>
			</cfoutput>

		</cfsavecontent>
		<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>