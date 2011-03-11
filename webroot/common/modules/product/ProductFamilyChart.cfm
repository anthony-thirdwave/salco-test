<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">
<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="ATTRIBUTES.ShowProductRange" default="ProductFamily">
<cfparam name="ATTRIBUTES.Formatting" default="1">
<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.SpecificationSetID" default="8000">
<cfif IsDefined("APPLICATION.LanguageID")>
	<cfparam name="ATTRIBUTES.LanguageID" default="#APPLICATION.LanguageID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LanguageID" default="100">
</cfif>

<cfinvoke component="/com/Product/ProductHandler"
	method="GetProductFamilyID"
	returnVariable="CurrentProductFamilyID"
	ProductID="#ATTRIBUTES.ProductID#">

<cfif ATTRIBUTES.ProductFamilyID GT "0">
	<cfset CurrentProductFamilyID="#ATTRIBUTES.ProductFamilyID#">
</cfif>

<cfinvoke component="/com/Product/ProductHandler"
	method="GetProductColorID"
	returnVariable="ColorID"
	ProductID="#ATTRIBUTES.ProductID#">

<cfset sColor=StructNew()>
<cfset StructInsert(sColor,"1600","A09868",1)>
<cfset StructInsert(sColor,"1601","697A90",1)>
<cfset StructInsert(sColor,"1602","7E607C",1)>
<cfset StructInsert(sColor,"1603","CAA755",1)>
<cfset StructInsert(sColor,"1604","B73F40",1)>
<cfset StructInsert(sColor,"1605","D86E40",1)>
<cfset StructInsert(sColor,"1606","8E9295",1)>

<cfif ATTRIBUTES.ShowProductRange IS "singleProduct">
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProducts">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="#ATTRIBUTES.ProductID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	</cfstoredproc>
<cfelse>
	<cfinvoke component="/com/Product/ProductHandler"
		method="GetProductInProductFamily"
		returnVariable="lProductID"
		ProductFamilyID="#CurrentProductFamilyID#">
	<cfif lProductID IS "">
		<cfset lProductID="-1">
	</cfif>
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProducts">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="#lProductID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
	</cfstoredproc>
</cfif>

<cfset ProductIDList=ValueList(GetProducts.CategoryID)>
<cfset sProductSet=StructNew()>
<cfloop index="ThisProductID" list="#ProductIDList#">
	<cfif ATTRIBUTES.LanguageID IS APPLICATION.DefaultLanguageID>
		<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
			select * from qry_GetProductAttribute
			WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And
			LanguageID=#Val(ATTRIBUTES.LanguageID)# and AttributeLanguageID=#Val(ATTRIBUTES.LanguageID)#
			AND SpecificationSetID = #Val(ATTRIBUTES.SpecificationSetID)#
			ORDER By  ProductFamilyAttributePriority
		</cfquery>
	<cfelse>
		<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
			select * from qry_GetProductAttribute
			WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And
			LanguageID=#Val(ATTRIBUTES.LanguageID)# and AttributeLanguageID=#Val(ATTRIBUTES.LanguageID)#
			AND SpecificationSetID = #Val(ATTRIBUTES.SpecificationSetID)#
			ORDER By  ProductFamilyAttributePriority, AttributeLanguageID desc
		</cfquery>
		<cfif GetAttributes.RecordCount IS "0">
			<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
				select * from qry_GetProductAttribute
				WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And
				LanguageID=#Val(APPLICATION.DefaultLanguageID)# and AttributeLanguageID=#Val(APPLICATION.DefaultLanguageID)#
				AND SpecificationSetID = #Val(ATTRIBUTES.SpecificationSetID)#
				ORDER By  ProductFamilyAttributePriority
			</cfquery>
		</cfif>
	</cfif>
	<cfset sValues=StructNew()>
	<cfoutput query="GetAttributes" group="ProductFamilyAttributeID">
		<cfset sValueElt=StructNew()>
		<cfset StructInsert(sValueElt,"AttributeValueID",AttributeValueID,1)>
		<cfset StructInsert(sValueElt,"AttributeValue",AttributeValue,1)>
		<cfset StructInsert(sValues,ProductFamilyAttributeID,sValueElt,1)>
	</cfoutput>
	<cfset StructInsert(sProductSet,ThisProductID,sValues,1)>
</cfloop>

<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
	SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID,ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute
	WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(ATTRIBUTES.LanguageID)#
		AND SpecificationSetID = #Val(ATTRIBUTES.SpecificationSetID)#
	order by ProductFamilyAttributePriority
</cfquery>
<cfif GetCols.RecordCount IS "0">
	<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
		SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID,ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute
		WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(APPLICATION.DefaultLanguageID)#
			AND SpecificationSetID = #Val(ATTRIBUTES.SpecificationSetID)#
		order by ProductFamilyAttributePriority
	</cfquery>
</cfif>

<cfquery name="GetIfLegend" datasource="#APPLICATION.DSN#">
	SELECT ProductFamilyAttributeID FROM qry_GetProductFamilyAttribute
	WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(ATTRIBUTES.LanguageID)# and ProductFamilyAttributeTypeID=602
		AND SpecificationSetID = #Val(ATTRIBUTES.SpecificationSetID)#
</cfquery>

<cfif ATTRIBUTES.Formatting>
	<cfset sIcon1=StructNew()>
	<cfset StructInsert(sIcon1,-1,"/common/images/global/spec.dash.gif",1)>
	<cfset StructInsert(sIcon1,0,"/common/images/global/spec.dash.gif",1)>
	<cfset StructInsert(sIcon1,700,"/common/images/global/spec.dot.gif",1)>
	<cfset StructInsert(sIcon1,701,"/common/images/global/spec.dot.open.gif",1)>
	<cfset StructInsert(sIcon1,702,"/common/images/global/spec.dash.gif",1)>
	<cfset sIcon2=StructNew()>
	<cfset StructInsert(sIcon2,"ATTRVAL_S","/common/images/global/spec.dot.gif",1)>
	<cfset StructInsert(sIcon2,"ATTRVAL_O","/common/images/global/spec.dot.open.gif",1)>
	<cfset StructInsert(sIcon2,"ATTRVAL_U","/common/images/global/spec.dash.gif",1)>

	<div style="margin-top:20px;">
	<!-- blue: #697A90 -->
	<!-- brown: #CAA755 -->
	<!-- green: #A09868 -->
	<!-- purple: #7E607C -->
	<!-- red: #B73F40 -->
	<!-- orange: #D86E40 -->
	<!-- grey: #8E9295  -->
		<table border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor="<cfif REQUEST.Site IS 'commercial'>#233640<cfelse><cfif StructKeyExists(sColor,colorID)>#<cfoutput>#sColor[ColorID]#</cfoutput><cfelse>#697A90</cfif></cfif>">
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td><span style="margin-left: 10px; margin-top:5px;color:white;font-size:16px;"><cfoutput>#APPLICATION.sPhrase['Specifications']#</cfoutput></span><!--- <br>
					<img src="/common/images/global/specs.title.tread.blue.gif" width="300" height="27"> ---></td>
				<td align="right"><img src="/common/images/<cfif REQUEST.Site IS "Commercial">commercial<cfelse>global</cfif>/specs.title.block.gif" width="4" height="27"></td>
				</tr></table></td>
			</tr>
			<tr>
				<td><img src="/common/images/spacer.gif" width="1" height="1"></td>
			</tr>
			<cfif GetIfLegend.RecordCount GT "0">
				<cfif REQUEST.Site IS "commercial">
					<cfset keybgcolor="white">
				<cfelse>
					<cfset keybgcolor="##EAEEF1">
				</cfif>

				<!-- ******************** NEW SPECS KEY **************************** -->
				<tr>
					<cfoutput><td bgcolor="#keybgcolor#" style="padding-top:8px;padding-bottom:8px;">
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="padding-left:10px;">#ucase(APPLICATION.sPhrase['KEY'])#</td>
							<td style="padding-top:1px;"><img src="/common/images/global/key.standard.gif" width="39" height="9"></td>
							<td><span style="font-weight:bold;color:##88929A;">#APPLICATION.sPhrase['Standard']#</span></td>
							<td style="padding-top:1px;"><img src="/common/images/global/key.optional.gif" width="34" height="9"></td>
							<td><span style="font-weight:bold;color:##88929A;">#APPLICATION.sPhrase['Optional']#</span></td>
							<td style="padding-top:1px;"><img src="/common/images/global/key.unavailable.gif" width="32" height="9"></td>
							<td><span style="font-weight:bold;color:##88929A;">#APPLICATION.sPhrase['Unavailable']#</span></td>
							<td></td>
						</tr>
					</table>
					</td></cfoutput>
				</tr>
				<!-- ******************** END NEW SPECS KEY **************************** -->


				<!---
				<tr>
					<td bgcolor="<cfif REQUEST.Site IS 'commercial'>white<cfelse>#EAEEF1</cfif>"><div><img src="/common/images/<cfif REQUEST.Site IS 'commercial'>commercial<cfelse>global</cfif>/specs.key.gif" width="515" height="27"></div></td>
				</tr> --->
			<tr>
				<td><img src="/common/images/spacer.gif" width="1" height="2"></td>
			</tr>
			</cfif>
			<tr>
				<td>
				<div>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr bgcolor="<cfif REQUEST.Site IS 'commercial'>#233640<cfelse>#9EA9B7</cfif>">
						<td width="253" height="4"><img src="/common/images/spacer.gif" width="253" height="1"></td>
						<td width="1" bgcolor="#FFFFFF"><img src="/common/images/spacer.gif" width="1" height="1"></td>
						<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
							<cfif ListGetAt(ProductIDList,ii) IS ATTRIBUTES.ProductID><td align="right"><img src="/common/images/<cfif REQUEST.Site IS "Commercial">commercial<cfelse>global</cfif>/model.select.gif" width="4" height="4"></td><!-- selected model -->
							<cfelse><TD <cfif REQUEST.Site IS "commercial" AND ListGetAt(ProductIDList,ii) IS NOT ATTRIBUTES.ProductID>bgcolor="#7B868C"</cfif>></TD></cfif>
							<cfif ii is NOT Listlen(ProductIDList)>
								<td width="1" bgcolor="#FFFFFF"><img src="/common/images/spacer.gif" width="1" height="1"></td>
							</cfif>
						</cfloop>
					</tr>
	<!-- blue: #9EA9B7 -->
	<!-- brown: #DAC188 -->
	<!-- green: #BCB795 -->
	<!-- purple: #A48FA3 -->
	<!-- red: #CC7879 -->
	<!-- orange: #E49979 -->
	<!-- grey: #B0B2B5  -->
					<tr bgcolor="<cfif REQUEST.Site IS 'commercial'>#233640<cfelse>#9EA9B7</cfif>" valign="top">
						<td height="14" style="padding-left:9px;"><cfif GetProducts.RecordCount GT "1"><table border="0" cellspacing="0" cellpadding="0"><tr><td><span style="font-size:10px;color:#fff;"><cfoutput>#APPLICATION.sPhrase['Click to view another model']#</cfoutput></span> <img src="/common/images/global/specs.arrw.gif" width="15" height="8"></td><td></td></tr></table></cfif></td>
						<td bgcolor="#FFFFFF"></td>
						<cfoutput query="GetProducts">
							<cfset ThisAlias="#CategoryAlias#">
							<cfif ATTRIBUTES.CategoryID GT "0">
								<cfinvoke component="/lifefitness/com/product/producthandler" method="GetLinkedProductPage" returnVariable="qLinkedPage"
									ProductID="#CategoryID#"
									CategoryID="#ATTRIBUTES.CategoryID#"
									LocaleID="#ATTRIBUTES.LocaleID#">
								<cfset ThisAlias="#qLinkedPage.CategoryAlias#">
							</cfif>
							<cfif IsDefined("URL.DP") AND Val(URL.DP)>
								<cfmodule template="/common/modules/utils/AddToQueryString.cfm" querystring="" varname="page" value="#ThisAlias#">
								<cfmodule template="/common/modules/utils/AddToQueryString.cfm" querystring="#querystring#" varname="dp" value="1">
								<cfset ThisURL="/content.cfm?#querystring#">
							<cfelse>
								<cfset ThisURL="/content.cfm/#ThisAlias#">
							</cfif>
							<td align="center" <cfif REQUEST.Site IS "commercial" AND CategoryID IS NOT ATTRIBUTES.ProductID>bgcolor="##7B868C"</cfif>><cfif GetProducts.RecordCount GT "1"><div class="modelDiv"><a href="#ThisURL#"><cfelse><div class="modeldiv2"></cfif>#CategoryNameDerived#</a></div></td>
							<cfif CurrentRow is not GetProducts.RecordCount><td bgcolor="##FFFFFF"></td></cfif>
						</cfoutput>
					</tr>
					<cfset MajorCounter="1">
					<cfset Color1Regular="white">
					<cfset Color1Active="##ECEEEE">
					<cfset Color2Active="##DBE1E5">
					<cfset Color2Regular="##F1F6F6">
					<cfif REQUEST.Site IS "Commercial">
						<cfset Color1line="C6C6C6">
						<cfset Color2Line="C6C6C6">
					<cfelse>
						<cfset Color1Line="dddddd">
						<cfset Color2Line="white">
					</cfif>
					<cfset ThisColorRegular="#Color1Regular#">
					<cfset ThisColorActive="#Color1Active#">
					<cfset ThisColorLine="#Color1Line#">
					<cfoutput query="GetCols">
						<cfif Trim(ProductFamilyAttributeName) IS "" or Left(Trim(ProductFamilyAttributeName),1) IS "_">
						<cfelse>
							<cfswitch expression="#ProductFamilyAttributeTypeID#">
								<cfcase value="600">
									<cfif MajorCounter MOD "2" IS "1">
										<cfset ThisColorRegular="#Color1Regular#">
										<cfset ThisColorActive="#Color1Active#">
										<cfset ThisColorLine="#Color1Line#">
									<cfelse>
										<cfset ThisColorRegular="#Color2Regular#">
										<cfset ThisColorActive="#Color2Active#">
										<cfset ThisColorLine="#Color2Line#">
									</cfif>
									<cfif ProductFamilyAttributeTypeID IS "600">
										<cfset MajorCounter=MajorCounter+1>
									</cfif>
									<tr bgcolor="#ThisColorRegular#"><td style="padding:4px 0px 4px 9px;"><div class="specHead">#REQUEST.ReplaceMarks(ProductFamilyAttributeName)#</div></td>
									<td></td>
									<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
										<cfif ListGetAt(ProductIDList,ii) IS ATTRIBUTES.ProductID>
											<td bgcolor="#ThisColorActive#">&nbsp;</td><!-- selected model -->
										<cfelse>
											<TD>&nbsp;</TD>
										</cfif>
										<cfif ii is NOT Listlen(ProductIDList)>
											<TD></TD>
										</cfif>
									</cfloop>
									</TR>
								</cfcase>
								<cfcase value="601">
									<tr bgcolor="#ThisColorRegular#"><td style="padding:4px 0px 4px 9px;"><div class="specHeadMinor">#REQUEST.ReplaceMarks(ProductFamilyAttributeName)#</div></td>
									<td></td>
									<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
										<cfif ListGetAt(ProductIDList,ii) IS ATTRIBUTES.ProductID>
											<td bgcolor="#ThisColorActive#">&nbsp;</td><!-- selected model -->
										<cfelse>
											<TD>&nbsp;</TD>
										</cfif>
										<cfif ii is NOT Listlen(ProductIDList)>
											<TD></TD>
										</cfif>
									</cfloop>
									</TR>
								</cfcase>
								<cfcase value="602,603">
									<TR bgcolor="#ThisColorRegular#"><td class="specTD"><!--- <span class="specType">Polar&#174; Telemetry</span><br> --->
									<span class="specNote">#REQUEST.ReplaceMarks(ProductFamilyAttributeName)#</span>
									</td>
									<td></td>
									<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
										<cfif StructKeyExists(sProductSet[ListGetAt(ProductIDList,ii)],ProductFamilyAttributeID)>
											<cfif ProductFamilyAttributeTypeID IS "602">
												<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValueID>
												<cfset Answer="<img src=""#sIcon1[Answer]#"" width=""7"" height=""7"">">
											<cfelse>
												<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValue>
												<cfif GetProducts.RecordCount GT "1">
													<cfset Answer=Replace(Answer,"(","<BR>(","one")>
												</cfif>
												<cfif ListFind("ATTRVAL_S,ATTRVAL_O,ATTRVAL_U",Answer)>
													<cfset Answer="<img src=""#sIcon2[Answer]#"" width=""7"" height=""7"">">
												</cfif>
											</cfif>
										<cfelse>
											<cfset Answer="">
										</cfif>
										<cfif ListGetAt(ProductIDList,ii) IS ATTRIBUTES.ProductID>
											<td bgcolor="#ThisColorActive#" align="center" style="font-size:9px; padding-left:2px;padding-right:2px" <cfif Len(Answer) LTE "20">nowrap</cfif>>#Answer#</td><!-- selected model -->
										<cfelse>
											<TD align="center" style="font-size:9px; padding-left:2px;padding-right:2px" <cfif Len(Answer) LTE "20">nowrap</cfif>>#Answer#</TD>
										</cfif>
										<cfif ii is NOT Listlen(ProductIDList)>
											<TD></TD>
										</cfif>
									</cfloop>
									</TR>
								</cfcase>
							</cfswitch>
							<cfif CurrentRow IS NOT GetCols.RecordCount>
								<tr bgcolor="#ThisColorLine#"><td colspan="#Incrementvalue(ListLen(ProductIDList)*2)#"><img src="/common/images/spacer.gif" width="1" height="1"></td></tr>
							</cfif>
						</cfif>
					</cfoutput>
					<tr bgcolor="#C6C6C6">
						<td colspan="<cfoutput>#Incrementvalue(ListLen(ProductIDList)*2)#</cfoutput>"><img src="/common/images/spacer.gif" width="1" height="1"></td>
					</tr>
					<cfif REQUEST.Site IS "Commercial">
						<tr><td align="right" bgcolor="#FFFFFF" colspan="<cfoutput>#Incrementvalue(ListLen(ProductIDList)*2)#</cfoutput>"><img src="/common/images/commercial/prod.specsbot.gif" width="6" height="15"></td></tr>
					</cfif>
				</table>
				</div>
			</td>
		</tr>
	</table>
	</div>
<cfelse>
	<cfset sCode1=StructNew()>
	<cfset StructInsert(sCode1,-1,"-",1)>
	<cfset StructInsert(sCode1,700,"S",1)>
	<cfset StructInsert(sCode1,701,"O",1)>
	<cfset StructInsert(sCode1,702,"-",1)>
	<cfset sCode2=StructNew()>
	<cfset StructInsert(sCode2,"ATTRVAL_S","S",1)>
	<cfset StructInsert(sCode2,"ATTRVAL_O","O",1)>
	<cfset StructInsert(sCode2,"ATTRVAL_U","-",1)>

	<table border="1" cellspacing="3" cellpadding="3">
	<tr valign="top">
	<td>&nbsp;</td>
	<cfoutput query="GetProducts">
	<td align="center">#CategoryNameDerived#</td>
	</cfoutput>
	</tr>
	<cfset MajorCounter="1">
	<cfoutput query="GetCols">
		<cfswitch expression="#ProductFamilyAttributeTypeID#">
			<cfcase value="600">
				<cfif ProductFamilyAttributeTypeID IS "600">
					<cfset MajorCounter=MajorCounter+1>
				</cfif>
				<tr bgcolor="gray"><td>#REQUEST.ReplaceMarks(ProductFamilyAttributeName)#</td>
				<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
					<td>&nbsp;</td><!-- selected model -->
				</cfloop>
				</TR>
			</cfcase>
			<cfcase value="601">
				<tr bgcolor="silver"><td>#REQUEST.ReplaceMarks(ProductFamilyAttributeName)#</td>
				<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
					<TD>&nbsp;</TD>
				</cfloop>
				</TR>
			</cfcase>
			<cfcase value="602,603">
				<TR><td>#REQUEST.ReplaceMarks(ProductFamilyAttributeName)#</td>
				<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
					<cfif StructKeyExists(sProductSet[ListGetAt(ProductIDList,ii)],ProductFamilyAttributeID)>
						<cfif ProductFamilyAttributeTypeID IS "602">
							<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValueID>
							<cfset Answer=sCode1[Answer]>
						<cfelse>
							<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValue>
							<cfif GetProducts.RecordCount GT "1">
								<cfset Answer=Replace(Answer,"(","<BR>(","one")>
							</cfif>
							<cfif ListFind("ATTRVAL_S,ATTRVAL_O,ATTRVAL_U",Answer)>
								<cfset Answer=sCode2[Answer]>
							</cfif>
						</cfif>
					<cfelse>
						<cfset Answer="">
					</cfif>
					<TD align="center" <cfif Len(Answer) LTE "20">nowrap</cfif>>#Answer#</TD>
				</cfloop>
				</TR>
			</cfcase>
		</cfswitch>
	</cfoutput>
	</table>
</cfif>