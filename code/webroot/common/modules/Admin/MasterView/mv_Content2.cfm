<cfset ElementCount = 0>
<cfset StartTickCount=GetTickCount()>
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.Path_Info#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="ATTRIBUTES.sCurrentCategoryPermissions">
<cfparam name="ATTRIBUTES.ObjectMode" default="ThreeColumn">
<cfif ATTRIBUTES.ObjectMode IS "OneColumn">
	<cfset lPosition="401">
<cfelseif ATTRIBUTES.ObjectMode IS "TwoColumn">
	<cfset lPosition="401,402">
<cfelseif ATTRIBUTES.ObjectMode IS "TwoColumnb">
	<cfset lPosition="400,401">
<cfelse>
	<cfset lPosition="400,401,402">
</cfif>
<cfset lid=Encrypt(SESSION.AdminCurrentAdminLocaleID,APPLICATION.Key)>

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>

<cfparam name="HighlightID" default="-1">
<cfif IsDefined("URL.hlid")>
	<cftry><cfset HighlightID=Decrypt(URL.hlid,APPLICATION.Key)><cfcatch><cfset HighlightID="-1"></cfcatch></cftry>
</cfif>

<cfquery name="qPosition" datasource="#APPLICATION.DSN#">
	SELECT     LabelID, LabelName
	FROM         t_Label
	WHERE     (LabelGroupID = 90)
</cfquery>
<cfset sPosition=StructNew()>
<cfoutput query="qPosition">
	<cfset StructInsert(sPosition,LabelID,LabelName)>
</cfoutput>

<cfif Isdefined("URL.mvca")>
	<cfswitch expression="#URL.mvca#">
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="UpdatePriorities">
		</cfcase>
	</cfswitch>
</cfif>

<cfif ATTRIBUTES.ObjectAction IS "UpdatePriorities">
	<cftransaction>
		<cfloop index="i" from="1" to="#NumItems#" step="1">
			<cftry>
				<cfset ThisContentID=Decrypt(URLDecode(Evaluate("Editcontentid#i#")),APPLICATION.Key)>
				<cfcatch>
					<cfset ThisContentID="-1">
				</cfcatch>
			</cftry>
			<cfif ThisContentID GT "0">
				<cfif IsDefined("EditShowContent#i#")>
					<cfset EditShowContent="1">
				<cfelse>
					<cfset EditShowContent="0">
				</cfif>
				<!--- <cfquery name="UpdateShowContent" datasource="#APPLICATION.DSN#">
					UPDATE t_Content SET ContentActive=#EditShowContent# WHERE contentid = #val(ThisContentID)#
				</cfquery> --->
				<cfif isdefined("ButtonSubmit_up_#i#.x") OR isdefined("ButtonSubmit_down_#i#.x")>
					<cfif isdefined("ButtonSubmit_up_#i#.x")>
						<cfif SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>
							<cfquery name="moveup" datasource="#APPLICATION.DSN#">
								update t_Content set ContentPriority=ContentPriority-15 
								where ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
						<cfquery name="moveup" datasource="#APPLICATION.DSN#">
							update t_ContentLocaleMeta set ContentLocalePriority=ContentLocalePriority-15
							where ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer"> and
							LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelseif isdefined("ButtonSubmit_down_#i#.x")>
						<cfif SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>
							<cfquery name="movedown" datasource="#APPLICATION.DSN#">
								update t_Content set ContentPriority=ContentPriority+15 where 
								ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
						<cfquery name="movedown" datasource="#APPLICATION.DSN#">
							update t_ContentLocaleMeta set ContentLocalePriority=ContentLocalePriority +15
							where ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer"> and
							LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
					<cfquery name="GetPos" datasource="#APPLICATION.DSN#">
						select ContentpositionID from t_ContentLocaleMeta
						WHERE ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
						and LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="Select" datasource="#APPLICATION.DSN#">
						SELECT ContentID FROM qry_GetContentLocaleMeta
						WHERE CategoryID=<cfqueryparam value="#Val(ATTRIBUTES.CurrentCategoryID)#" cfsqltype="cf_sql_integer">
						and LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
						And ContentPositionID=<cfqueryparam value="#Val(GetPos.ContentpositionID)#" cfsqltype="cf_sql_integer">
						Order By ContentLocalePriority
					</cfquery>
					<cfoutput query="select">
						<cfset ThisNewPriority=10*CurrentRow>
						<cfif SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>
							<cfquery name="Update" datasource="#APPLICATION.DSN#">
								update t_Content set ContentPriority=#Val(ThisNewPriority)# where 
								ContentID=<cfqueryparam value="#Val(ContentID)#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
						<cfquery name="Update" datasource="#APPLICATION.DSN#">
							update t_ContentLocaleMeta set ContentLocalePriority=#Val(ThisNewPriority)# where 
							ContentID=<cfqueryparam value="#Val(ContentID)#" cfsqltype="cf_sql_integer"> and
							LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfoutput>
				</cfif>
			</cfif>
			<cfif isdefined("ButtonSubmit_left_#i#.x") OR isdefined("ButtonSubmit_right_#i#.x")>
				<cfquery name="GetPos" datasource="#APPLICATION.DSN#">
					select ContentpositionID from t_ContentLocaleMeta
					WHERE ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
					and LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif isdefined("ButtonSubmit_left_#i#.x")>
					<cfset ThisNewPositionID=GetPos.ContentPositionID-1>
				<cfelse>
					<cfset ThisNewPositionID=GetPos.ContentPositionID+1>
				</cfif>
				<cfquery name="SelectMax" datasource="#APPLICATION.DSN#">
					SELECT Max(ContentLocalePriority) as MaxContentLocalePriority FROM t_ContentLocaleMeta
					WHERE ContentPositionID=<cfqueryparam value="#Val(ThisNewPositionID)#" cfsqltype="cf_sql_integer">
					and LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				<cfquery name="moveleft" datasource="#APPLICATION.DSN#">
					update t_ContentLocaleMeta set ContentPositionID=#Val(ThisNewPositionID)#, ContentLocalePriority=#Val(SelectMax.MaxContentLocalePriority)+10#
					where ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer"> and
					LocaleID=<cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
			
		</cfloop>
		<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
			Lookup="Category"
			KeyID="#ATTRIBUTES.CurrentCategoryID#">
	</cftransaction>
	<cf_AddToQueryString queryString="#FormQueryString#" OmitList="mvca">
	<cflocation url="#FormPage#?#QueryString#" addToken="no">
<cfelse>
	<cfquery name="GetContentTypeIcons" datasource="#APPLICATION.DSN#">
		SELECT     *
		FROM         t_Label
		WHERE     (LabelGroupID = 70)
	</cfquery>
	<cfset sContentTypeIcon=StructNew()>
	<cfoutput query="GetContentTypeIcons">
		<cfset StructInsert(sContentTypeIcon,LabelID,LabelImage,1)>
	</cfoutput>
	<cfset sContentTypeName=StructNew()>
	<cfoutput query="GetContentTypeIcons">
		<cfset StructInsert(sContentTypeName,LabelID,LabelName,1)>
	</cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<TR valign="toP">
	<cfset ColWidth=100/ListLen(lPosition)>

	<!--- Declare constant part of edit paths here --->
	<cfset EditQueryString="">
	<cf_AddToQueryString querystring="#EditQueryString#" name="PageAction" value="Edit">
	<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
	<cfset EditQueryString="#QueryString#">
	<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="validatedelete">
	<cfset DeleteQueryString="#QueryString#">
	
	<cfloop index="ThisPosition" list="#lPosition#">
		<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetContentList">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#SESSION.AdminCurrentAdminLocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#ATTRIBUTES.CurrentCategoryID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="#Val(ThisPosition)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="" null="Yes">
			<cfif SESSION.AdminCurrentAdminLocaleID IS NOT APPLICATION.DefaultLocaleID>
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="DefaultContentLocale" value="1" null="No">
			</cfif>
		</cfstoredproc>
		<cfoutput>
		<td width="#ColWidth#%">
			<table width="100%" border="0">
			<TR>
				<TD>
					<div class="box3">
					<div class="boxtop3"><div></div></div>
					<div class="ModuleTitle3">
					<table width="90%"  border="0" cellpadding="3" cellspacing="0">
					<TR>
						<TD><cfif ATTRIBUTES.ObjectMode IS NOT "OneColumn"><strong>#sPosition[ThisPosition]#</strong></cfif></TD>
						<TD align="right">
							<cfif ATTRIBUTES.sCurrentCategoryPermissions["pCreate"]><cfoutput><a href="/common/admin/MasterView/ContentModify.cfm?PageAction=add&pid=#URLEncodedFormat(Encrypt(ThisPosition,APPLICATION.Key))#&cid=#URLEncodedFormat(Encrypt(ATTRIBUTES.CurrentCategoryID,APPLICATION.Key))#&lid=#URLEncodedFormat(lid)#"><b>Add</b></a></cfoutput></cfif>
						</TD>
					</TR>
					</table>
					</div>
					</div>
				</TD>
			</TR>
			</table>
		</cfoutput>
		<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="2">
		<cf_AddToQueryString queryString="#QueryString#" Name="p" value="#ThisPosition#">
		<cfoutput><form action="#FormPage#?#QueryString#" method="post"></cfoutput>
		<cfset Counter="1">
		
		<cfif GetContentList.RecordCount IS NOT "0">
			<cfoutput query="GetContentList" group="ContentID">
				<cfif ContentActiveDerived>
					<cfset Color1="bac0c9">
					<cfset Color2="eaeaea">
					<cfset Color3="black">
					<cfset ThisClass="Active">
				<cfelse>
					<cfset Color1="DFE2E7">
					<cfset Color2="F7F5F7">
					<cfset Color3="silver">
					<cfset ThisClass="inActive">
				</cfif><!---
				<cfif ContentID IS HighlightID>
					<tr valign="top" bgcolor="silver">
				<cfelse>
					<tr valign="top" bgcolor="white">
				</cfif>
				<TD style="border:1px solid red;"> --->
					<cfset ElementCount = ElementCount + 1>
					<div id="dragme#ElementCount#" class="dragme">
						<div class="box1">

							<div class="boxtop1"><div></div></div>
							<div class="ModuleTitle1"<cfif ThisClass EQ "inActive"></cfif>>
								<img src="#sContentTypeIcon[ContentTypeID]#" width="14" height="12">
								<strong>#sContentTypeName[ContentTypeID]# <cfif NOT ContentActiveDerived>[Inactive]</cfif></strong>
							</div>
							<div class="ModuleBody1" style="padding:0px; ">
							<table width="100%" border="0" cellpadding="3" cellspacing="1" height="140">
							<tr bgcolor="#Color2#" height="30">
								<td bgcolor="#Color2#" colspan="2">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<TR>
										<TD class="#ThisClass#"><strong><span title="[ #ContentID# ]">#ContentName#<span></strong></td>
										<td nowrap>
											<div align="right">
											<cfset coid=encrypt(ContentID,APPLICATION.KEY)>
											<cfset Location="/common/admin/MasterView/ContentModify.cfm">
											<cfset querystring="">
											<cfif ATTRIBUTES.sCurrentCategoryPermissions["pEdit"]>
												<cf_AddToQueryString querystring="#EditQueryString#" name="coid" value="#coid#">
												<a href="#Location#?#querystring#" class="#ThisClass#">Edit</A>
											</cfif>
											<cfif ATTRIBUTES.sCurrentCategoryPermissions["pDelete"]>
												<cfquery name="TestProduction" datasource="#APPLICATION.DSN#" maxrows="1">
													SELECT * FROM t_Tracking
													WHERE operationid=503 and Entity='t_Content' and KeyID=<cfqueryparam value="#ContentID#" cfsqltype="cf_sql_integer">
												</cfquery>
												<cfif TestProduction.RecordCount GT "0" and NOT ATTRIBUTES.sCurrentCategoryPermissions["pSaveLive"]>
													<a href="javascript:void(0)" title="You may not delete this content, since this is saved on production." class="#ThisClass#">Delete</A>
												<cfelse>
													<cf_AddToQueryString querystring="#DeleteQueryString#" name="coid" value="#coid#">
													<a href="#Location#?#querystring#" class="#ThisClass#">Delete</a>
												</cfif>
											</cfif>
											<BR><cfif ListFirst(lPosition) IS ThisPosition><img src="/common/images/widget_arrow_left_grey.gif"><cfelse><input type="image" name="ButtonSubmit_left_#Counter#" value="pos_#ThisPosition#_#Counter#" src="/common/images/widget_arrow_left.gif"></cfif>
											<cfif CurrentRow IS NOT "1"><input type="image" name="ButtonSubmit_up_#Counter#" value="up_#Counter#" src="/common/images/widget_arrow_up.gif"><cfelse><img src="/common/images/widget_arrow_up_grey.gif"></cfif><cfif Counter IS NOT GetContentList.RecordCount><input type="image" name="ButtonSubmit_down_#Counter#" value="down_#Counter#" src="/common/images/widget_arrow_down.gif"><cfelse><img src="/common/images/widget_arrow_down_grey.gif"></cfif><cfif ListLast(lPosition) IS ThisPosition><img src="/common/images/widget_arrow_right_grey.gif"><cfelse><input type="image" name="ButtonSubmit_right_#Counter#" value="pos_#ThisPosition#_#Counter#" src="/common/images/widget_arrow_right.gif"></cfif>
											</div>
										</TD>
									</TR>
									</table>
								</td>
								<input type="hidden" name="EditContentID#Counter#" value="#URLEncodedFormat(Encrypt(contentid,APPLICATION.Key))#">
							</tr>
							<cfset Location="/common/admin/MasterView/ContentLocaleModify.cfm">
							<cfset querystring="">
							<cfset ThisPreview="">
							<cfquery name="getPacket" datasource="#APPLICATION.DSN#">
								select PropertiesPacket FROM t_Properties where PropertiesID=<cfqueryparam value="#Val(contentLocalePropertiesID)#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif IsWddx(getPacket.PropertiesPacket)>
								<cfwddx action="WDDX2CFML" input="#getPacket.PropertiesPacket#" output="sContentLocalePropertiesPacket">
								<cfif StructKeyExists(sContentLocalePropertiesPacket,"ContentPreview")>
									<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#REQUEST.RemoveHTML(sContentLocalePropertiesPacket.ContentPreview)#" NumChars="200" VarName="ThisPreview">
								</cfif>
							</cfif>
							<cfif (ContentLocaleName IS NOT "" and ContentLocaleName IS NOT ContentName) OR ThisPreview IS NOT "" OR 1>
								<tr><td bgcolor="#Color2#" colspan="2"  class="#ThisClass#">
								<cfif ContentLocaleName IS NOT "" and ContentLocaleName IS NOT ContentName>
									<strong>#ContentLocaleName#</strong><br>
								</cfif>
								<cfif ThisPreview IS NOT "">
									#ThisPreview#
								<cfelse>
									[ Preview not available ]
								</cfif>
								</td></tr>
							</cfif>
							
							</table>
							</div><!-- /ModuleBody1 -->

						</div>
					</div>
					<img src="/common/images/spacer.gif" height="1"><!--- </TD></TR> --->
				<cfset Counter=Counter+1>
			</cfoutput>
		<cfelse>
		<!---	<TR><TD bgcolor="white" bgcolor="white" align="center">[ none ]</TD></TR> --->
		</cfif>
		<!--- </table> ---></TD><cfif ListFindNoCase(lPosition,ThisPosition) iS NOT ListLen(lPosition)><TD></TD></cfif>
		<cfoutput>
			<input type="hidden" name="NumItems" value="#Counter#">
		</cfoutput>
		</form>
	</cfloop>
	</TR>
	<cfif APPLICATION.GetAllLocale.RecordCount GT 1>
	<TR><TD colspan=5 align="center"><small>Border denotes default content.</TD>
	</TR>
	</cfif>
	</table>
</cfif>
<cfoutput>
<script type="text/javascript">
	window.onload = function() {
	getPositions(#ElementCount#);
}
</script>
</cfoutput>