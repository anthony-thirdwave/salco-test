<cfparam name="ATTRIBUTES.CategoryID" default="-1">

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


<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category
	WHERE     (ParentID = #ATTRIBUTES.CategoryID#)
</cfquery>

<cfif Val(ATTRIBUTES.CategoryID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<CFSET ExecuteTempFile="#APPLICATION.LocaleID#/PromoText_#ATTRIBUTES.CategoryID#_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") OR REQUEST.ReCache>
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetImageIndex">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ATTRIBUTES.CategoryID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
		</cfstoredproc>
		
		
		<cfsaveContent Variable="FileContents">
			<cfif GetImageIndex.RecordCount GT "0">
				<cfquery name="GetViewLabel" datasource="#APPLICATION.DSN#">
					select * from qry_GetProductAttribute
					WHERE ProductID=#Val(ATTRIBUTES.CategoryID)# and ProductFamilyAttributeID = 1223 and AttributeLanguageID IN (#Val(ATTRIBUTES.LanguageID)#,100)
					Order by AttributeLanguageID desc
				</cfquery>
				<!--- <table width="512" cellspacing="0" cellpadding="0" border="0">
				<tr><td width="12" valign="top" bgcolor="#<cfif ListFind("1004",ProductBrandLogoID)>8E8E8B<cfelse>eff1f4</cfif>" align="left"><img width="12" height="5" alt="" src="/common/images/commercial/<cfif ListFind("1004",ProductBrandLogoID)>hs<cfelse>cs</cfif>.topleft_1.gif"/><br/>
				<img width="12" height="1" alt="" src="/common/images/spacer.gif"/></td>
				<td width="495" bgcolor="#<cfif ListFind("1004",ProductBrandLogoID)>8E8E8B<cfelse>eff1f4</cfif>"><h2 <cfif ListFind("1004",ProductBrandLogoID)>class="HStitle"</cfif>><cfoutput><cfif Trim(GetViewLabel.AttributeValue) IS not "">#GetViewLabel.AttributeValue#<cfelse>#GetProductFamily.CategoryNameDerived# #APPLICATION.sPhrase["Features"]#</cfif></cfoutput></h2></td>
				<td width="5" valign="top" bgcolor="#<cfif ListFind("1004",ProductBrandLogoID)>8E8E8B<cfelse>eff1f4</cfif>" align="right"><img width="4" height="38" alt="" src="/common/images/commercial/<cfif ListFind("1004",ProductBrandLogoID)>hs<cfelse>cs</cfif>.topright_1.gif"/><br/>
				<img width="5" height="1" alt="" src="/common/images/spacer.gif"/></td>
				</tr>
				<tr><td height="1" bgcolor="#e4e8ed" colspan="3"><img width="1" height="1" alt="" src="/common/images/spacer.gif"/></td></tr></table> --->

				<cfoutput query="GetImageIndex">
					<cfset CategoryImageRepresentative="">
					<cfset PromoText="">
					<cfif isWddx(CategoryLocalePropertiesPacket)>
						<cfwddx action="WDDX2CFML" input="#CategoryLocalePropertiesPacket#" output="sProps">
						<cfif StructKeyExists(sProps,"CategoryImageRepresentative")>
							<cfset CategoryImageRepresentative=sProps.CategoryImageRepresentative>
						</cfif>
						<cfif StructKeyExists(sProps,"PromoText")>
							<cfset PromoText=sProps.PromoText>
						</cfif>
					</cfif>
					<cfif CategoryImageRepresentative IS "" and APPLICATION.LocaleID IS NOT APPLICATION.DefaultLocaleID>
						<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
							<cfprocresult name="GetDefaultPage" maxrows="1">
							<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(CategoryID)#" null="No">
							<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.DefaultLocaleID#" null="No">
							<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
						</cfstoredproc>
						<cfif isWddx(GetDefaultPage.CategoryLocalePropertiesPacket)>
							<cfwddx action="WDDX2CFML" input="#GetDefaultPage.CategoryLocalePropertiesPacket#" output="sDefaultProperties">
							<cfif StructKeyExists(sDefaultProperties,"CategoryImageRepresentative")>
								<cfset CategoryImageRepresentative=sDefaultProperties.CategoryImageRepresentative>
							</cfif>
						</cfif>
					</cfif>
					<cfif CategoryImageRepresentative IS NOT "">
						<table width="512" cellspacing="0" cellpadding="0" border="0">
						<cfif CurrentRow mod 2 IS "1">
							<tr bgcolor="##ffffff">
						<cfelse>
							<tr bgcolor="##f1f3f6">
						</cfif>
						<cfif Trim(CategoryURLDerived) IS "">
							<cfset ThisURL="/content.cfm/#CategoryAlias#">
						<cfelse>
							<cfset ThisURL="#CategoryURLDerived#">
						</cfif>
						<cfif ListLast(CategoryImageRepresentative,".") is not "swf">
				            <td width="6"><img width="6" height="1" alt="" src="/common/images/spacer.gif"></td>
			    	        <td width="162" style="padding-top: 10px; padding-bottom: 10px;" valign="top"><div style="padding: 6px 0px 6px 0px;"><a href="#ThisURL#"><img src="#CategoryImageRepresentative#" border="0" width="162" height="115"></a></div></td>
						</cfif>
						<td width="12"><img width="12" height="1" alt="" src="/common/images/spacer.gif"></td>
						<td style="padding-top: 10px; padding-bottom: 10px;" valign="top"><ul class="orange"><div class="maintext">
						<li><!--- <strong>#CategoryNameDerived#</strong> ---> #REQUEST.ReplaceMarks(PromoText)#</li></div></ul>
						</td><td width="20"><img width="20" height="1" alt="" src="/common/images/spacer.gif"></td></tr>
						<tr><td height="1" bgcolor="##e4e8ed" colspan="5"><img width="1" height="1" alt="" src="/common/images/spacer.gif"></td></tr>
						</table>
					</cfif>
				</cfoutput>
			</cfif>
		</cfsavecontent>
		<cfif APPLICATION.PageEncoding IS "UTF-8">
			<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
		<cfelse>
			<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes" charset="#APPLICATION.PageEncoding#">
		</cfif>
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>