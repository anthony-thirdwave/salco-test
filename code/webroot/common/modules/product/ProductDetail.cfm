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
	<CFSET ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductDetail_v1.0_#ATTRIBUTES.ProductID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfsaveContent Variable="FileContents">
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfset MyProduct.Constructor(Val(ATTRIBUTES.ProductID),ATTRIBUTES.LanguageID)>
			<cfset aView=MyProduct.GetProperty("aProductView")>
			<cfset aProductFeature=MyProduct.GetProperty("aProductFeature")>
			<cfset aDownload=MyProduct.GetProperty("aProductDownload")>
			
			<cfset lProps="PublicDrawing,ProductDescription,PartNumber">
			<cfloop index="ThisProp" list="#lProps#">
				<cfset SetVariable("This#ThisProp#",MyProduct.GetProperty(ThisProp))>
			</cfloop>
			
			<cfset tempArray = ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aProductFeature)#" step="1">
				<cfif aProductFeature[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aProductFeature[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aProductFeature[i])>
				</cfif>
			</cfloop>
			<cfset aProductFeature = tempArray>
			
			<cfset tempArray = ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aView)#" step="1">
				<cfif aView[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aView[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aView[i])>
				</cfif>
			</cfloop>
			<cfset aView = tempArray>
			
			<cfset tempArray = ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
				<cfif aDownload[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aDownload[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aDownload[i])>
				</cfif>
			</cfloop>
			<cfset aDownload = tempArray>
			
			<cfoutput>
				<h1>#ThisPartNumber#</h1>
				<h3>#GetProduct.CategoryNameDerived#</h3>
				<cfif IsDefined("REQUEST.CategoryImageHeader") and REQUEST.CategoryImageHeader IS NOT "">
					<img class="hero" src="#REQUEST.CategoryImageHeader#" alt="#REQUEST.CategoryImageHeader#">
				</cfif>
				<p>#ThisProductDescription#</p>
				
				<cfif ArrayLen(aProductFeature) GT "0">
					<h3>Features</h3>
					<ul>
					<cfloop index="i" from="1" to="#ArrayLen(aProductFeature)#" step="1">
						<li>#aProductFeature[i].TextBlock#</li>
					</cfloop>
					</ul>
				</cfif>
				
				<cfif ArrayLen(aDownload) GT "0">
					<h3>Downloads</h3>
					<ul>
					<cfloop index="i" from="1" to="#ArrayLen(aDownload)#" step="1">
						<li><a href="#aDownload[i].MainFilePath#">#aView[i].ResourceName#</a><br/>
						#aView[i].ResourceText#
						</li>
					</cfloop>
					</ul>
				</cfif>
				
				<cfif ArrayLen(aView) GT "0">
					<h3>Additional Images</h3>
					<ul>
					<cfloop index="i" from="1" to="#ArrayLen(aView)#" step="1">
						<li><a href="#aView[i].MainFilePath#"><cfif aView[i].ThumbnailFilePath IS NOT "">#aView[i].ThumbnailFilePath#<cfelse>#aView[i].ResourceName#</cfif></a></li>
					</cfloop>
					</ul>
				</cfif>
				
			</cfoutput>
		</cfsavecontent>
		<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>