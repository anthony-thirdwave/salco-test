<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">
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

<cfif Val(ATTRIBUTES.ProductFamilyID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProductFamily">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductFamilyID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
	</cfstoredproc>
	<cfquery name="GetCache" datasource="#APPLICATION.DSN#">
		SELECT     MAX(CacheDateTime) AS CacheDateTime
		FROM         t_Category
		WHERE     CategoryID IN (#ATTRIBUTES.ProductFamilyID#)
	</cfquery>
	<CFSET ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductFamilyDetail_v1.0_#ATTRIBUTES.ProductFamilyID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfsaveContent Variable="FileContents">
			<cfset MyProductFamily=CreateObject("component","com.Product.ProductFamily")>
			<cfset MyProductFamily.Constructor(Val(ATTRIBUTES.ProductFamilyID),ATTRIBUTES.LanguageID)>
			<cfset aView=MyProductFamily.GetProperty("aProductFamilyView")>
			<cfset aProductFamilyFeature=MyProductFamily.GetProperty("aProductFamilyFeature")>
			<cfset aDownload=MyProductFamily.GetProperty("aProductFamilyDownload")>
			
			<cfset lProps="ProductFamilyDescription">
			<cfloop index="ThisProp" list="#lProps#">
				<cfset SetVariable("This#ThisProp#",MyProductFamily.GetProperty(ThisProp))>
			</cfloop>
			
			<cfset tempArray=ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aProductFamilyFeature)#" step="1">
				<cfif aProductFamilyFeature[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aProductFamilyFeature[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aProductFamilyFeature[i])>
				</cfif>
			</cfloop>
			<cfset aProductFamilyFeature=tempArray>
			
			<cfset tempArray=ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aView)#" step="1">
				<cfif aView[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aView[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aView[i])>
				</cfif>
			</cfloop>
			<cfset aView=tempArray>
			
			<cfset tempArray=ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
				<cfif aDownload[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aDownload[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aDownload[i])>
				</cfif>
			</cfloop>
			<cfset aDownload=tempArray>
			
			<cfoutput>
				<h1>#GetProductFamily.CategoryNameDerived#</h1>
				<cfif IsDefined("REQUEST.CategoryImageHeader") and REQUEST.CategoryImageHeader IS NOT "">
					<img class="hero" src="#REQUEST.CategoryImageHeader#" alt="#REQUEST.CategoryImageHeader#">
				</cfif>
				<p>#APPLICATION.utilsObj.AddBreaks(thisProductFamilyDescription)#</p>
				
				<cfif ArrayLen(aProductFamilyFeature) GT "0">
					<h4>Features</h4>
					<ul>
					<cfloop index="i" from="1" to="#ArrayLen(aProductFamilyFeature)#" step="1">
						<li>#aProductFamilyFeature[i].TextBlock#</li>
					</cfloop>
					</ul>
				</cfif>
				
				<cfif ArrayLen(aDownload) GT "0">
					<h4>Downloads</h4>
					<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
						<p><a href="#aDownload[i].MainFilePath#" target="_blank">#aDownload[i].ResourceName#</a>
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