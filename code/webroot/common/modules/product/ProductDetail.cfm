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



<cfparam name="URL.DP" default="0">

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
	<CFSET ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductDetail_v1.4_#REQUEST.Site#_#ATTRIBUTES.ProductID#_loc#ATTRIBUTES.LocaleID#_dp#Val(URL.DP)#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfsaveContent Variable="FileContents">
			<cfsilent>
				<cfset MyProduct=CreateObject("component","lifefitness.com.Product.Product")>
				<cfset MyProduct.Constructor(Val(ATTRIBUTES.ProductID),ATTRIBUTES.LanguageID)>
				<cfset aView=MyProduct.GetProperty("aProductView")>
				<cfset aReview=MyProduct.GetProperty("aProductReview")>
				<cfset aProductFeature=MyProduct.GetProperty("aProductFeature")>
				<cfset ProgramTypeAlias=MyProduct.GetProductProgramTypeAlias()>
				<cfset sImage=StructNew()>
				<cfset StructInsert(sImage,"1600","/common/images/global/product.arrw.olivegreen.gif",1)>
				<cfset StructInsert(sImage,"1601","/common/images/global/product.arrw.blue.gif",1)>
				<cfset StructInsert(sImage,"1602","/common/images/global/product.arrw.purple.gif",1)>
				<cfset StructInsert(sImage,"1603","/common/images/global/product.arrw.yellow.gif",1)>
				<cfset StructInsert(sImage,"1604","/common/images/global/product.arrw.red.gif",1)>
				<cfset StructInsert(sImage,"1605","/common/images/global/product.arrw.orange.gif",1)>
				<cfset StructInsert(sImage,"1606","/common/images/global/product.arrw.darkgray.gif",1)>
				<cfset ThisColorID=MyProduct.GetProductColorID()>
				<cfif NOT StructKeyExists(sImage,ThisColorID)>
					<cfset ThisColorID="-1">
				</cfif>
				
				<cfset lProps="CompareGymBrochurePath,BrochurePath,ProductDescription,ProductLongName,ColorConfiguratorURL,VideoURL,ProductThumbnailPath,ProductThumbnailHoverPath">
				<cfloop index="ThisProp" list="#lProps#">
					<cfset SetVariable("This#ThisProp#",MyProduct.GetProperty(ThisProp))>
				</cfloop>
				
				<cfset ThisProductBrandLogoID=MyProduct.GetProductBrandID()>
				
				<cfif ATTRIBUTES.LanguageID IS NOT APPLICATION.DefaultLanguageID and ListFindNoCase("104,103",ATTRIBUTES.LanguageID)>
					<cfset MyProductDefault=CreateObject("component","lifefitness.com.Product.Product")>
					<cfset MyProductDefault.Constructor(Val(ATTRIBUTES.ProductID),APPLICATION.DefaultLanguageID)>
					
					<cfif ArrayLen(aView) IS "0">
						<cfset aView=MyProductDefault.GetProperty("aProductView")>
					</cfif>
					
					<cfif ArrayLen(aReview) IS "0">
						<cfset aReview=MyProductDefault.GetProperty("aProductReview")>
					</cfif>
					
					<cfif ArrayLen(aProductFeature) IS "0">
						<cfset aProductFeature=MyProductDefault.GetProperty("aProductFeature")>
					</cfif>
					
					<cfif ProgramTypeAlias IS "">
						<cfset ProgramTypeAlias=MyProductDefault.GetProductProgramTypeAlias()>
					</cfif>
					
					<cfif ThisColorID LTE "0">
						<cfset ThisColorID=MyProductDefault.GetProductColorID()>
						<cfif NOT StructKeyExists(sImage,ThisColorID)>
							<cfset ThisColorID="-1">
						</cfif>
					</cfif>
					<cfif ThisProductBrandLogoID LTE "0">
						<cfset ThisProductBrandLogoID=MyProductDefault.GetProductBrandID()>
					</cfif>
					<cfloop index="ThisProp" list="#lProps#">
						<cfif Trim(Evaluate("This#ThisProp#")) IS "">
							<cfset SetVariable("This#ThisProp#",MyProductDefault.GetProperty(ThisProp))>
						</cfif>
					</cfloop>
				</cfif>
			<!--- Only get array elements for given SpecificationSetID  --->
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
				
			</cfsilent>
			<cfoutput>
			<cfif ListFindNoCase("commercial,commercialv2",REQUEST.Site)>
				<cfif Val(ThisProductBrandLogoID) IS "1000">
					<div><img src="/common/images/commercial/content.logo.gif" width="240" height="53"></div>
				<cfelseif Val(ThisProductBrandLogoID) IS "1001">
					<div><img src="/common/images/commercial/content.logo.gif" width="240" height="53"></div>
				<cfelseif Val(ThisProductBrandLogoID) is "1002">
					<div><img src="/common/images/commercial/content.logo.gif" width="240" height="53"></div>
				<cfelseif Val(ThisProductBrandLogoID) is "1003">
					<div><img src="/common/images/commercial/content.logo.gif" width="240" height="53"></div>
				<cfelseif Val(ThisProductBrandLogoID) is "1004">
					<div><img src="/common/images/commercial/content.logo.hammer.gif" width="144" height="65"></div>
				<cfelse>
					<div><img src="/common/images/spacer.gif" width="240" height="53"></div>
				</cfif>
				<cfset WindowOpenParams="center=yes,height=650,width=540,resizable=1,scrollbars=1,toolbar=no,menubar=no,location=no">
			<cfelse>
				<cfset WindowOpenParams="width=540,height=544,scrollbars=1,resizable=1,menubar=1">
			</cfif>
			<div>
			<table width="515" border="0" cellspacing="0" cellpadding="0"><tr valign="top"><td>
			<cfif ThisProductThumbnailPath iS NOT ""><div><cfif ArrayLen(aView) GT "0"><a href="javascript:void(window.open('/common/modules/display/templates/dsp_popup.cfm?site=#URLEncodedFormat(REQUEST.Site)#&mode=resource&rid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(aView[1].ResourceID)))#&lid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ATTRIBUTES.LocaleID)))#&colrid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ThisColorID)))#','','#WindowOpenParams#'));" class="prodPopup"></cfif><cfif ThisProductThumbnailHoverPath IS ""><img src="#ThisProductThumbnailPath#" border="0"><cfelse><cfsilent>
<cfset ImageWidth=242>
<cfset ImageHeight=273>
<cf_ImageSize file="#REQUEST.GetPathFromURL(ThisProductThumbnailPath)#">
<cfif IsDefined("Width")>
	<cfset ImageWidth=Width>
	<cfset ImageHeight=Height>
</cfif>
</cfsilent><div id="Flash_Holder" align="left"><img src="#ThisProductThumbnailPath#" border="0"></div>	
   <script type="text/javascript">
	var so = new SWFObject("#ThisProductThumbnailHoverPath#", "Flash", "#ImageWidth#", "#ImageHeight#", "8", "##FFFFFF");
	so.addParam("allowScriptAccess","always");
	so.addParam("name", "Flash");
	so.addParam("id", "Flash");
	so.addParam("scale", "noScale");
	so.addParam("quality", "high");
	so.addParam("salign","lt");
	so.write("Flash_Holder");
</script></cfif></A></div>
</cfif>
			<cfif ArrayLen(aView) GT "0" or ArrayLen(aReview) GT "0" or ThisVideoURL IS NOT "" or ThisColorConfiguratorURL IS NOT "" OR Trim(ProgramTypeAlias) IS NOT "">
				<div style="margin-left:9px;">
				<cfif ListFindNoCase("commercial,commercialv2",REQUEST.Site)>
					<h3 style="margin:13px 0 6px 0;"><cfoutput>#APPLICATION.sPhrase['Product Highlights']#</cfoutput></h3>
				<cfelse>
					<h3 style="margin-bottom:10px"><cfoutput>#APPLICATION.sPhrase['Product Highlights']#</cfoutput></h3>
				</cfif>
				<cfloop index="i" from="1" to="#ArrayLen(aView)#">
					<div><img name="poparrw_#ATTRIBUTES.ProductID#_#i#" src="/common/images/global/prod.arrw.red.gif" border="0" alt="#aView[i].ResourceName#" title="#aView[i].ResourceName#"><a href="javascript:void(window.open('/common/modules/display/templates/dsp_popup.cfm?site=#URLEncodedFormat(REQUEST.Site)#&mode=resource&rid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(aView[i].ResourceID)))#&lid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ATTRIBUTES.LocaleID)))#&colrid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ThisColorID)))#','','#WindowOpenParams#'));" class="prodPopup" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('poparrw_#ATTRIBUTES.ProductID#_#i#','','/common/images/global/prod.arrw.blue.gif',1)">#REQUEST.ReplaceMarks(ucase(aView[i].ResourceName))#</a></div>
				</cfloop>
				<cfif ProgramTypeAlias IS NOT "">
					<cfset i=IncrementValue(i)>
					<div><img name="poparrw_#ATTRIBUTES.ProductID#_#i#" src="/common/images/global/prod.arrw.red.gif" border="0" alt="Reviews" title="Reviews"><a href="javascript:void(window.open('/content.cfm/#ProgramTypeAlias#?site=#URLEncodedFormat(REQUEST.Site)#&cid=#REQUEST.SimpleEncrypt(ATTRIBUTES.ProductID)#','','#WindowOpenParams#'));" class="prodPopup" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('poparrw_#ATTRIBUTES.ProductID#_#i#','','/common/images/global/prod.arrw.blue.gif',1)">#APPLICATION.sPhrase['Programs']#</a></div>
				</cfif>
				<cfif ArrayLen(aReview) GT "0">
					<cfset i=IncrementValue(i)>
					<div><img name="poparrw_#ATTRIBUTES.ProductID#_#i#" src="/common/images/global/prod.arrw.red.gif" border="0" alt="Programs" title="Programs"><a href="javascript:void(window.open('/common/modules/display/templates/dsp_popup.cfm?site=#URLEncodedFormat(REQUEST.Site)#&mode=review&cid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ATTRIBUTES.ProductID)))#&lid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ATTRIBUTES.LocaleID)))#&colrid=#JSStringFormat(URLEncodedFormat(REQUEST.SimpleEncrypt(ThisColorID)))#','','#WindowOpenParams#'));" class="prodPopup" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('poparrw_#ATTRIBUTES.ProductID#_#i#','','/common/images/global/prod.arrw.blue.gif',1)">#APPLICATION.sPhrase['REVIEWS']#</a></div>
				</cfif>
				<cfif ThisVideoURL IS NOT "">
					<cfif Left(ThisVideoURL,Len("http://video.lifefitness.com")) IS "http://video.lifefitness.com">
						<cfset ThisVideoURL="javascript:void(videoWindow('#ThisVideoURL#'));">
					</cfif>
					<cfset i=IncrementValue(i)>
					<div><img name="poparrw_#ATTRIBUTES.ProductID#_#i#" src="/common/images/global/prod.arrw.red.gif" border="0" alt="Video" title="Video"><a href="#ThisVideoURL#" class="prodPopup" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('poparrw_#ATTRIBUTES.ProductID#_#i#','','/common/images/global/prod.arrw.blue.gif',1)">#APPLICATION.sPhrase['Video']#</A></div>
				</cfif>
				<cfif ThisColorConfiguratorURL IS NOT "">
					<cfset i=IncrementValue(i)>
					<cfif left(ThisColorConfiguratorURL,Len("http://lifefitness.richfx.com/product")) IS "http://lifefitness.richfx.com/product">
						<cfset ThisColorConfiguratorURL=ReplaceNoCase(ThisColorConfiguratorURL,"http://lifefitness.richfx.com/product","http://lifefitness.richfx.com/lifefitness/product","one")>
					</cfif>
					<div><img name="poparrw_#ATTRIBUTES.ProductID#_#i#" src="/common/images/global/prod.arrw.red.gif" border="0" alt="Color Configurator" title="Color Configurator"><a href="javascript:void(window.open('#ThisColorConfiguratorURL#','','width=800,location=1,menubar=1,resizable=1,status=1,titlebar=1,toolbar=1,scrollbars=1'));" class="prodPopup" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('poparrw_#ATTRIBUTES.ProductID#_#i#','','/common/images/global/prod.arrw.blue.gif',1)">#APPLICATION.sPhrase['Color Configurator']#</A></div>
				</cfif>
				</div>
			</cfif>
			</td>		
			<cfif ListFindNoCase("commercial,commercialv2",REQUEST.Site)>
				<cfset ThisProductName="#GetProduct.CategoryNameDerived#">
				<cfinvoke component="/lifefitness/com/product/producthandler" method="GetLinkedProductPage" returnVariable="qLinkedPage"
					ProductID="#ATTRIBUTES.ProductID#"
					CategoryID="#CurrentProductFamilyID#"
					LocaleID="#ATTRIBUTES.LocaleID#">
				<cfif isWddx(qLinkedPage.CategoryLocalePropertiesPacket)>
					<cfwddx action="WDDX2CFML" input="#qLinkedPage.CategoryLocalePropertiesPacket#" output="sProperties">
					<cfif StructKeyExists(sProperties,"CategoryLocaleNameAlternative") and sProperties.CategoryLocaleNameAlternative IS NOT "">
						<cfset ThisProductName=REQUEST.ReplaceMarks(sProperties.CategoryLocaleNameAlternative)>
					</cfif>
				</cfif>
				<td><img src="/common/images/spacer.gif" width="23" height="1"></td><td style="padding-right:10px;">
				<div style="margin-top:5px;"><span class="prodTitle">#ThisProductName#</span></div>
			<cfelse>
				<td><div style="margin-bottom:8px;">
			   <table border="0" cellspacing="0" cellpadding="0">
			    <tr valign="top">
			     <td><cfif ThisColorID GT "0"><img src="#sImage[ThisColorID]#" width="28" height="20" vspace="5"><cfelse><img src="/common/images/global/title.prod.arrw.gif" width="28" height="20" vspace="5"></cfif></td>
			     <td><span class="prodTitle">#GetProduct.CategoryNameDerived#</span>
				
				<cfif Val(ThisProductBrandLogoID) IS "1000">
					<div style="position:absolute;left:607px;top:133px;"><img src="/common/images/global/logo.lfsport.gif" width="131" height="38"></div>
				<cfelseif Val(ThisProductBrandLogoID) IS "1001">
					<div style="position:absolute;left:607px;top:133px;"><img src="/common/images/global/logo.parabody.gif" width="131" height="38"></div>
				</cfif>
				 </TD>
			    </tr>
			   </table> 
			   </div>
			</cfif>
			<cfif ThisProductLongName iS NOT "" and ThisProductLongName IS NOT GetProduct.CategoryNameDerived><h1>#REQUEST.ReplaceMarks(ThisProductLongName)#</h1></cfif>
			<cfif ThisProductDescription iS NOT ""><div class="mainText">#REQUEST.ReplaceMarks(ThisProductDescription)#</div></cfif>
			<cfif ArrayLen(aProductFeature) GT "0">
				<cfif REQUEST.Site IS "Home">
					<img src="/common/images/global/horizbar.dots2.gif" width="25" height="20">
				<cfelse>
					<div id=divider2><img src="/common/images/spacer.gif" height="1"></div>
				</cfif>
				<div>
				<table border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td class="arrwpad"><img src="/common/images/global/arrw.blue.gif" width="15" height="8" border="0"></td>
						<td class="arrwText">#APPLICATION.sPhrase['KEY FEATURES']#</td>
					</tr>
				</table>
				</div>
				<table border="0" cellspacing="0" cellpadding="0">
					<cfloop index="i" from="1" to="#ArrayLen(aProductFeature)#" step="1">
						<tr valign="top">
							<td><img src="/common/images/global/bullet.redarrw.gif" width="8" height="9"></td>
							<td class="bullet">#REQUEST.ReplaceMarks(aProductFeature[i].TextBlock)#</td>
						</tr>
					</cfloop>
				</table>
				</div>
			</cfif>
			<cfif REQUEST.Site IS "Home">
				<img src="/common/images/global/horizbar.dots2.gif" width="25" height="20">
			<cfelse>
				<div id=divider2><img src="/common/images/spacer.gif" height="1"></div>
			</cfif>
			<cfparam name="ThisProductPrice" default="">
			<cfparam name="ThisCallToActionURL" default="">
			<cfif IsWDDX(GetProduct.CategoryLocalePropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetProduct.CategoryLocalePropertiesPacket#" output="sProperties">
				<cfif StructKeyExists(sProperties,"ProductPrice") and sProperties.ProductPrice is not "" and URL.DP is "0" AND (GetProduct.localeID IS ATTRIBUTES.LocaleID OR (ATTRIBUTES.LocaleID IS "2" and ListFindNoCase("1,2",GetProduct.localeID)))>
					<cfif ATTRIBUTES.LocaleID IS 2>
						<div><table border="0" cellspacing="0" cellpadding="0">
							<tr valign="top">
								<td class="arrwpad"><img src="/common/images/global/arrw.blue.gif" width="15" height="8" border="0"></td>
								<td class="arrwText">MSRP</td>
								<td class="msrpPrice">&nbsp;&nbsp;#sProperties.ProductPrice#<span style="color:##908F90">*</span></td>
							</tr>
						</table></div>
					<cfelse>
						<div><table border="0" cellspacing="0" cellpadding="0">
							<tr valign="top">
								<td class="arrwpad"><img src="/common/images/global/arrw.blue.gif" width="15" height="8" border="0"></td>
								<td class="msrpPrice">&nbsp;&nbsp;#sProperties.ProductPrice#<span style="color:##908F90">*</span></td>
							</tr>
						</table></div>
					</cfif>
					<cfset ThisProductPrice=sProperties.ProductPrice>
				</cfif>
				<cfif StructKeyExists(sProperties,"CallToActionURL") and sProperties.CallToActionURL is not "" and URL.DP is "0">
					<cfset ThisCallToActionURL=sProperties.CallToActionURL>
				</cfif>
			<cfelse>
				<div>&nbsp;</div>
			</cfif>
			
			<cfif ListFindNoCase("commercial,commercialv2",REQUEST.Site)>
				<div style="margin-top:4px;">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td style="padding-top:3px;padding-right:3px">
						<cfmodule template="/common/modules/utils/AddToQueryString.cfm" querystring="#REQUEST.CGIQueryString#" varname="pff" value="1"><a href="#REQUEST.CGIPathInfo#?#Querystring#" onMouseOut="MM_swapImgRestore()" target="_blank" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#9','','/local/common/images/commercial/prod.btn.print-o.gif',1)"><img src="/local/common/images/commercial/prod.btn.print.gif" alt="print friendly" title="print friendly" name="prodbtn_#ATTRIBUTES.ProductID#9" border="0"></a></td>
						<cfinvoke component="/com/Product/ProductHandler"
							method="GetProductFamilyBrochure"
							returnVariable="ProductFamilyBrochure"
							ProductID="#ATTRIBUTES.ProductID#"
							LocaleID="#ATTRIBUTES.LocaleID#"
							LanguageID="#ATTRIBUTES.LanguageID#">
						<cfinvoke component="/com/Product/ProductHandler"
							method="GetProductFamilyBrochureOverride"
							returnVariable="ProductFamilyBrochureOverride"
							ProductID="#ATTRIBUTES.ProductID#"
							LocaleID="#ATTRIBUTES.LocaleID#"
							LanguageID="#ATTRIBUTES.LanguageID#">
						
						<cfset ThisBrochurePathToUse=ThisBrochurePath>
						
						<cfif ProductFamilyBrochure is not "">
							<cfif ProductFamilyBrochureOverride>
								<cfset ThisBrochurePathToUse=ProductFamilyBrochure>
							<cfelseif ThisBrochurePathToUse IS "">
								<cfset ThisBrochurePathToUse=ProductFamilyBrochure>
							</cfif>
						</cfif>
						
						<td style="padding-top:3px;">
						<cfif ThisBrochurePathToUse IS NOT "" and 0><a href="#ThisBrochurePathToUse#" target="_blank" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#7','','/local/common/images/commercial/prod.btn.pdf-o.gif',1)"><img src="/local/common/images/commercial/prod.btn.pdf.gif" alt="pdf brochure" title="pdf brochure" name="prodbtn_#ATTRIBUTES.ProductID#7" border="0"></a></cfif></td>
					</tr>
					<tr valign="top">
						<td style="padding-top:3px;" colspan="2">
						<a href="/content.cfm/contactus_3" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#10','','/local/common/images/commercial/prod.details.btn.contact-o.gif',1)"><img src="/local/common/images/commercial/prod.details.btn.contact.gif" alt="Contact" title="Contact" name="prodbtn_#ATTRIBUTES.ProductID#10" border="0"></a></td></TR>
				</table>
				</div>
			<cfelse>
				<div style="margin-top:4px;">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td>
						<cfmodule template="/common/modules/utils/AddToQueryString.cfm" querystring="#REQUEST.CGIQueryString#" varname="pff" value="1"><a href="#REQUEST.CGIPathInfo#?#Querystring#" onMouseOut="MM_swapImgRestore()" target="_blank" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#9','','/local/common/images/global/prod.btn.print-o.gif',1)"><img src="/local/common/images/global/prod.btn.print.gif" alt="print friendly" title="print friendly" name="prodbtn_#ATTRIBUTES.ProductID#9" border="0"></a></td>
						<cfif ThisBrochurePath IS "">
							<cfinvoke component="/com/Product/ProductHandler"
								method="GetProductFamilyBrochure"
								returnVariable="ProductFamilyBrochure"
								ProductID="#ATTRIBUTES.ProductID#"
								LocaleID="#ATTRIBUTES.LocaleID#"
								LanguageID="#ATTRIBUTES.LanguageID#">
							<cfset ThisBrochurePath="#ProductFamilyBrochure#">
						</cfif>
						<td><cfif ThisBrochurePath IS NOT ""><a href="#ThisBrochurePath#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#7','','/local/common/images/global/prod.btn.pdf-o.gif',1)" target="_blank"><img src="/local/common/images/global/prod.btn.pdf.gif" alt="pdf brochure" title="pdf brochure" name="prodbtn_#ATTRIBUTES.ProductID#7" border="0"></a></cfif></td>
					</tr>
					<!--- <TR><TD colspan="2"><img src="/common/images/spacer.gif" height="4"></TD></TR> --->
					<tr valign="top">
						<td><cfif ATTRIBUTES.LocaleID IS not "12"><a href="/content.cfm/wheretobuy" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#8','','/local/common/images/global/prod.btn.find-o.gif',1)"><img src="/local/common/images/global/prod.btn.find.gif" alt="find a store" title="find a store" name="prodbtn_#ATTRIBUTES.ProductID#8" border="0"></a></cfif></td>
						<cfset DisplayBuyOnlineLink="no">
						<cfif ThisCallToActionURL IS NOT "" and URL.DP is "0" and ThisProductPrice is not "" and ATTRIBUTES.LocaleID IS "2">
							<cfset DisplayBuyOnlineLink="Yes">
						</cfif>
						<td><cfif DisplayBuyOnlineLink><a href="#ThisCallToActionURL#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#6','','/common/images/global/prod.btn.buy-o.gif',1)" target="_blank"><img src="/common/images/global/prod.btn.buy.gif" alt="buy online" title="buy online" name="prodbtn_#ATTRIBUTES.ProductID#6" width="121" height="19" border="0"></a><cfelseif ThisCompareGymBrochurePath IS NOT ""><a href="#ThisCompareGymBrochurePath#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#cg','','/common/images/global/prod.btn.comparegym-o.gif',1)" target="_blank"><img src="/common/images/global/prod.btn.comparegym.gif" alt="compare gym pdf brochure" title="compare gym pdf brochure" name="prodbtn_#ATTRIBUTES.ProductID#cg" width="123" height="19" border="0"></a></cfif></td>
					</tr>
					<cfif DisplayBuyOnlineLink and ThisCompareGymBrochurePath IS NOT "">
						<TR><TD colspan="2"><img src="/common/images/spacer.gif" height="4"></TD></TR>
						<TR><TD><a href="#ThisCompareGymBrochurePath#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('prodbtn_#ATTRIBUTES.ProductID#cg','','/common/images/global/prod.btn.comparegym-o.gif',1)" target="_blank"><img src="/common/images/global/prod.btn.comparegym.gif" alt="compare gym pdf brochure" title="compare gym pdf brochure" name="prodbtn_#ATTRIBUTES.ProductID#cg" width="123" height="19" border="0"></a></TD><TD>&nbsp;</TD></TR>
					</cfif>
				</table>
				</div>
			</cfif>
			</td></tr></table>
			</div>
			</cfoutput>
		</cfsavecontent>
		<cfif APPLICATION.PageEncoding IS "UTF-8">
			<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
		<cfelse>
			<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes" charset="#APPLICATION.PageEncoding#">
		</cfif>
		
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>