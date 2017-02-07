<cfparam name="ATTRIBUTES.ProductFamilyID" default="-1">

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

<cfquery name="Test" datasource="#APPLICATION.DSN#" maxrows="1">
	select CategoryTypeID,SourceID From t_category Where CategoryID=#Val(ATTRIBUTES.ProductFamilyID)#
</cfquery>
<cfif Test.CategoryTypeID IS "162">
	<cfset ATTRIBUTES.ProductFamilyID=Test.SourceID>
</cfif>

<cfif Val(ATTRIBUTES.ProductFamilyID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProductFamily">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductFamilyID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
	</cfstoredproc>
	<CFSET ExecuteTempFile="#ATTRIBUTES.LocaleID#/+Resource_#REQUEST.Site#_#ATTRIBUTES.ProductFamilyID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetProductFamily.CacheDateTime,'yyyymmdd')##TimeFormat(GetProductFamily.CacheDateTime,'HHmmss')#.cfm">
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache or 1>
		<cfset aView=ArrayNew(1)>
		<cfquery name="GetView" datasource="#APPLICATION.DSN#">
			select * from qry_GetResource
			WHERE KeyID=#Val(ATTRIBUTES.ProductFamilyID)# and Entity='t_Category' and languageID=#Val(ATTRIBUTES.LanguageID)#
			Order by ResourcePriority
		</cfquery>
		<cfif GetView.RecordCount GT "0">
			<cfoutput query="GetView">
				<cfset sViewElt=StructNew()>
				<Cfset StructInsert(sViewElt,"ResourceID",ResourceID,1)>
				<Cfset StructInsert(sViewElt,"ResourceName",ResourceName,1)>
				<Cfset StructInsert(sViewElt,"ResourceText",ResourceText,1)>
				<Cfset StructInsert(sViewElt,"MainFilePath",MainFilePath,1)>
				<Cfset StructInsert(sViewElt,"ThumbnailFilePath",ThumbnailFilePath,1)>
				<cfset arrayAppend(aView,sViewElt)>
			</cfoutput>
		<cfelse>
			<cfquery name="GetView" datasource="#APPLICATION.DSN#">
				select * from qry_GetResource
				WHERE KeyID=#Val(ATTRIBUTES.ProductFamilyID)# and Entity='t_Category' and languageID=100
				Order by ResourcePriority
			</cfquery>
			<cfoutput query="GetView">
				<cfset sViewElt=StructNew()>
				<Cfset StructInsert(sViewElt,"ResourceID",ResourceID,1)>
				<Cfset StructInsert(sViewElt,"ResourceName",ResourceName,1)>
				<Cfset StructInsert(sViewElt,"ResourceText",ResourceText,1)>
				<Cfset StructInsert(sViewElt,"MainFilePath",MainFilePath,1)>
				<Cfset StructInsert(sViewElt,"ThumbnailFilePath",ThumbnailFilePath,1)>
				<cfset arrayAppend(aView,sViewElt)>
			</cfoutput>
		</cfif>
		<cfquery name="GetProps" datasource="#APPLICATION.DSN#">
			select PropertiesPacket from 
			t_Category INNER JOIN
                  t_Properties ON t_Category.PropertiesID = t_Properties.PropertiesID
			Where CategoryID=#Val(ATTRIBUTES.ProductFamilyID)#
		</cfquery>
		<cfset ProductBrandLogoID="-1">
		<cfif isWddx(GetProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetProps.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ProductBrandLogoID")>
				<cfset ProductBrandLogoID=sProperties.ProductBrandLogoID>
			</cfif>
		</cfif>
		
		<cfsaveContent Variable="FileContents">
			<cfif ArrayLen(aView) GT "0">
				<cfquery name="GetViewLabel" datasource="#APPLICATION.DSN#">
					select * from qry_GetProductAttribute
					WHERE ProductID=#Val(ATTRIBUTES.ProductFamilyID)# and ProductFamilyAttributeID = 1223 and AttributeLanguageID IN (#Val(ATTRIBUTES.LanguageID)#,100)
					Order by AttributeLanguageID desc
				</cfquery>
				<table width="512" cellspacing="0" cellpadding="0" border="0">
				<tr><td width="12" valign="top" bgcolor="#<cfif ListFind("1004",ProductBrandLogoID)>8E8E8B<cfelse>eff1f4</cfif>" align="left"><img width="12" height="5" alt="" src="/common/images/commercial/<cfif ListFind("1004",ProductBrandLogoID)>hs<cfelse>cs</cfif>.topleft_1.gif"/><br/>
				<img width="12" height="1" alt="" src="/common/images/spacer.gif"/></td>
				<td width="495" bgcolor="#<cfif ListFind("1004",ProductBrandLogoID)>8E8E8B<cfelse>eff1f4</cfif>"><h2 <cfif ListFind("1004",ProductBrandLogoID)>class="HStitle"</cfif>><cfoutput><cfif Trim(GetViewLabel.AttributeValue) IS not "">#GetViewLabel.AttributeValue#<cfelse>#GetProductFamily.CategoryNameDerived# #APPLICATION.sPhrase["Features"]#</cfif></cfoutput></h2></td>
				<td width="5" valign="top" bgcolor="#<cfif ListFind("1004",ProductBrandLogoID)>8E8E8B<cfelse>eff1f4</cfif>" align="right"><img width="4" height="38" alt="" src="/common/images/commercial/<cfif ListFind("1004",ProductBrandLogoID)>hs<cfelse>cs</cfif>.topright_1.gif"/><br/>
				<img width="5" height="1" alt="" src="/common/images/spacer.gif"/></td>
				</tr>
				<tr><td height="1" bgcolor="#e4e8ed" colspan="3"><img width="1" height="1" alt="" src="/common/images/spacer.gif"/></td></tr></table>

				<cfoutput>
					<cfloop index="i" from="1" to="#ArrayLen(aView)#" step="1">
						<table width="512" cellspacing="0" cellpadding="0" border="0">
						<cfif ListFind("1004",ProductBrandLogoID)>
							<cfif i mod 2 IS "1">
								<tr bgcolor="##9F9F9D">
							<cfelse>
								<tr bgcolor="##8E8E8B">
							</cfif>
						<cfelse>
							<cfif i mod 2 IS "1">
								<tr bgcolor="##ffffff">
							<cfelse>
								<tr bgcolor="##f1f3f6">
							</cfif>
						</cfif>
						<cfif aView[i].ThumbnailFilePath is not "" and ListLast(aView[i].ThumbnailFilePath,".") is not "swf">
				            <td width="6"><img width="6" height="1" alt="" src="/common/images/spacer.gif"></td>
			    	        <td width="162" style="padding-top: 10px; padding-bottom: 10px;" valign="top"><div style="padding: 6px 0px 6px 0px;"><img src="#aView[i].ThumbnailFilePath#" border="0" width="162" height="115"></div></td>
						</cfif>
						<td width="12"><img width="12" height="1" alt="" src="/common/images/spacer.gif"></td>
						<td style="padding-top: 10px; padding-bottom: 10px;" valign="top"><ul class="<cfif ListFind("1004",ProductBrandLogoID)>HSRed<cfelse>orange</cfif>"><div class="<cfif ListFind("1004",ProductBrandLogoID)>HSBullet<cfelse>maintext</cfif>">
						<li><strong>#REQUEST.ReplaceMarks(aView[i].ResourceName)#</strong> #REQUEST.ReplaceMarks(aView[i].ResourceText)#</li></div></ul>
						</td><td width="20"><img width="20" height="1" alt="" src="/common/images/spacer.gif"></td></tr>
						<tr><td height="1" bgcolor="##e4e8ed" colspan="<cfif aView[i].ThumbnailFilePath is not "">5<cfelse>3</cfif>"><img width="1" height="1" alt="" src="/common/images/spacer.gif"></td></tr>
						</table>
					</cfloop>
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