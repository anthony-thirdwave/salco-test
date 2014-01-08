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
	<cfset ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductFamilyDetail_v1.1_#ATTRIBUTES.ProductFamilyID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfsaveContent Variable="FileContents">
			<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetProductFamily">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductFamilyID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
			</cfstoredproc>
			
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
			
			<cfset thisImageHeader="">
			<cfif IsWDDX(GetProductFamily.CategoryLocalePropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetProductFamily.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
				<cfloop index="ThisProp" list="MetaDescription,MetaKeywords,PageTitleOverride,CategoryImageHeader">
					<cfif StructKeyExists(sCategoryProperties,"CategoryImageHeader") AND Trim(StructFind(sCategoryProperties,"CategoryImageHeader")) IS NOT "">
						<cfset thisImageHeader=StructFind(sCategoryProperties,"CategoryImageHeader")>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetSubProductFamilies">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(ATTRIBUTES.LocaleID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(ATTRIBUTES.ProductFamilyID)#" null="NO">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="62" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
			</cfstoredproc>

			<cfoutput>
				<h2>#GetProductFamily.CategoryNameDerived#</h2>
			</cfoutput>
			
			<cfif GetSubProductFamilies.RecordCount GT "0">
				<nav class="product-nav">
				<ul>
				<cfoutput query="GetSubProductFamilies">
					<li><a href="#APPLICATION.utilsObj.parseCategoryUrl(GetSubProductFamilies.CategoryAlias)#">#GetSubProductFamilies.CategoryNameDerived#</a></li>
				</cfoutput>
				</ul>
				</nav>
			</cfif>
			
			<cfoutput>
				<cfif Trim(thisProductFamilyDescription) IS NOT "">
					<p class="indent-bullet">#APPLICATION.utilsObj.AddBreaks(thisProductFamilyDescription)#</p>
				</cfif>
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
				
				<cfif thisImageHeader IS NOT "">
					<div id="product-hero-image" <cfif thisImageHeader IS NOT "">style="background-image:url(#thisImageHeader#);"</cfif>>
					<cfif 0>
						<div class="product-hero-grad">
							<div class="popular-products">
								<h3>Popular Air Slide Parts:</h3>
								<ul>
									<li><a href="">
										<div style="background-image:url(AirslideHatchCover20.png)"></div>
										<span>Airslide Hatch Cover 20 <span>AHC20TAS</span></span> </a></li>
									<li><a href="">
										<div style="background-image:url(pipe-cap-number-3.png)"></div>
										<span>Pipe Cap 3 <span>GA3AIC</span></span> </a></li>
									<li><a href="">
										<div style="background-image:url(airslide-cover-handwheel.png)"></div>
										<span>Airslide Cover Handwheel Assembly <span>GA20HWA</span></span> </a></li>
								</ul>
							</div>
						</div>
					</cfif>
					</div>
				</cfif>
				
			</cfoutput>
		</cfsavecontent>
		<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>