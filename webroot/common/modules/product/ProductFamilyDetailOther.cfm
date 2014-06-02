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
	<cfquery name="GetCache" datasource="#APPLICATION.DSN#">
		SELECT     MAX(CacheDateTime) AS CacheDateTime
		FROM         t_Category
		WHERE     CategoryID IN (<cfqueryparam value="#Val(ATTRIBUTES.ProductFamilyID)#" cfsqltype="CF_SQL_INTEGER">)
	</cfquery>
	<cfset ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductFamilyDetailOther_v1.1_#ATTRIBUTES.ProductFamilyID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfsaveContent Variable="FileContents">
			<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetProductFamily">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductFamilyID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
			</cfstoredproc>
			
			<cfset MyProductFamily=CreateObject("component","com.Product.ProductFamily")>
			<cfset MyProductFamily.Constructor(Val(ATTRIBUTES.ProductFamilyID),ATTRIBUTES.LanguageID)>
			<cfset aDownload=MyProductFamily.GetProperty("aProductFamilyDownload")>
			
			<cfset tempArray=ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
				<cfif aDownload[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aDownload[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aDownload[i])>
				</cfif>
			</cfloop>
			<cfset aDownload=tempArray>
			
			<cfif ArrayLen(aDownload) GT "0">
				<h4>Downloads:</h4>
				<cfoutput>
					<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
						<p><a href="#aDownload[i].MainFilePath#" target="_blank">#aDownload[i].ResourceName#</a>
						(#UCase(ListLast(aDownload[i].MainFilePath,"."))#<cfif StructKeyExists(aDownload[i],"MainFileSize") AND Val(aDownload[i].MainFileSize) GT "0">, #Ceiling(aDownload[i].MainFileSize/1024)#KB</cfif>)<br/>
						#aDownload[i].ResourceText#
						</p>
					</cfloop>
				</cfoutput>
			</cfif>
			
		</cfsavecontent>
		<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>