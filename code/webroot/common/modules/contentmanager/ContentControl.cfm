<cfparam name="ATTRIBUTES.ContentTypeID" default="-1">
<cfparam name="ATTRIBUTES.ContentID" default="-1">
<cfparam name="ATTRIBUTES.PositionID" default="-1">
<cfparam name="ATTRIBUTES.CurrentCategoryID" default="-1">
<cfparam name="ATTRIBUTES.returnVariable" default="ReturnValue">
<cfparam name="ATTRIBUTES.CurrentCategoryTypeID" default="-1">
<cfparam name="ATTRIBUTES.contentNameDerived" default="">
<cfif not IsDefined("ATTRIBUTES.sContentBody")>
	<cfset ATTRIBUTES.sContentBody=StructNew()>
</cfif>
<cfif not IsStruct(ATTRIBUTES.sContentBody)>
	<cfset ATTRIBUTES.sContentBody=StructNew()>
</cfif>
<cfset FileContents="">
<cfswitch expression="#ATTRIBUTES.ContentTypeID#">
	<cfcase value="200"><!--- Text --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"Text")>
			<cfset FileContents="#ATTRIBUTES.sContentBody.Text#">
			<cfset FileContents="#FileContents#">
		</cfif>
	</cfcase>
	<cfcase value="217"><!--- bullet List--->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"aText") AND IsArray(ATTRIBUTES.sContentBody.aText) AND ArrayLen(ATTRIBUTES.sContentBody.aText) GT "0">
			<cfset FileContents="<img src=""/common/images/global/horizbar.dots2.gif""/><table border=""0"" cellspacing=""0"" cellpadding=""0"">">
			<cfloop index="i" from="1" to="#ArrayLen(ATTRIBUTES.sContentBody.aText)#" step="1">
				<cfset FileContents="#FileContents#<tr valign=""top""><td><img src=""/common/images/global/bullet.redarrw.gif"" width=""8"" height=""9""/></td><td class=""bullet"">#application.utilsObj.ReplaceMarks(ATTRIBUTES.sContentBody.aText[i])#</td></tr>">
			</cfloop>
			<cfset FileContents="#FileContents#</table><img src=""/common/images/global/horizbar.dots2.gif""/>">
		</cfif>
	</cfcase>
	<cfcase value="201"><!--- HTML --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"HTML") and ATTRIBUTES.sContentBody.HTML IS NOT "">
			<cfif application.applicationname is "intranet.salco">
				<cfif ATTRIBUTES.currentCategoryTypeID neq 81>
					<cfset FileContents="#application.utilsObj.ObscureEMail(ATTRIBUTES.sContentBody.HTML)#">
				</cfif>
			<cfelse>
				<cfset FileContents="#application.utilsObj.ReplaceMarks(ATTRIBUTES.sContentBody.HTML)#">
				<cfset FileContents="#application.utilsObj.ObscureEMail(FileContents)#">
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="202"><!--- HTML & Text --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"HTML") AND StructKeyExists(ATTRIBUTES.sContentBody,"Text") AND StructKeyExists(ATTRIBUTES.sContentBody,"TextPosition")>
			<cfif sContentBody.TextPosition IS "left">
				<cfset FileContents="<table border=""0"" cellspacing=""0"" cellpadding=""0""><TR valign=""top""><TD width=""50%"">#ATTRIBUTES.sContentBody.Text#</TD><TD width=""50%"">#ATTRIBUTES.sContentBody.HTML#</TD></TR></table>">
			<cfelse>
				<cfset FileContents="<table border=""0"" cellspacing=""0"" cellpadding=""0""><TR valign=""top""><TD width=""50%"">#ATTRIBUTES.sContentBody.HTML#</TD><TD width=""50%"">#ATTRIBUTES.sContentBody.Text#</TD></TR></table>">
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="203"><!--- HTML Template --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"HTMLTemplate") AND StructKeyExists(ATTRIBUTES.sContentBody,"aText")>
			<cfif ArrayLen(ATTRIBUTES.sContentBody.aText) GT "0">
				<cfset HTMLTemplate="<a name=""htmltemplate1""></a>#ATTRIBUTES.sContentBody.HTMLTemplate#">
				<cfloop index="i" from="1" to="#ArrayLen(ATTRIBUTES.sContentBody.aText)#" step="1">
					<cfmodule template="/common/modules/utils/ReplaceToken.cfm"
						InputText="#HTMLTemplate#"
						returnVariable="HTMLTemplate"
						Token1="[[text#i#]]"
						Value1="#application.utilsObj.ObscureEMail(application.utilsObj.ReplaceMarks(application.utilsObj.RemoveLeadingPTag(ATTRIBUTES.sContentBody.aText[i])))#">
				</cfloop>
				<cfset FileContents="#HTMLTemplate#">
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="204"><!--- Teaser --->
		<!--- <cfset this.sFields[ThisATTRIBUTES.ContentTypeID]="HTML,LinkURL"> --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"HTML")>
			<cfset FileContents="#ATTRIBUTES.sContentBody.HTML#">
		</cfif>
	</cfcase>
	<cfcase value="206"><!--- Repeated Content --->
		<cfquery name="GetSource" datasource="#APPLICATION.DSN#">
			SELECT	SourceID 
			FROM	t_Content 
			WHERE	ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif GetSource.RecordCount IS "1">
			<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetSourceContent">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#GetSource.SourceID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>
			<cfif GetSourceContent.RecordCount IS "1">
				<cfif IsWDDX(GetSourceContent.ContentBody)>
					<cfwddx action="WDDX2CFML" input="#GetSourceContent.ContentBody#" output="sContentBody">
				<cfelse>
					<cfset sContentBody=StructNew()>
				</cfif>
				<cfmodule template="/common/modules/ContentManager/ContentControl.cfm" sContentBody="#sContentBody#" CurrentCategoryID="#ATTRIBUTES.CurrentCategoryID#" ContentTypeID="#GetSourceContent.ContentTypeID#" returnVariable="TheseFileContents" PositionID="#ATTRIBUTES.PositionID#">
				<cfset FileContents="#TheseFileContents#">
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="207"><!--- Inheirited Content --->
		<cfquery name="GetSource" datasource="#APPLICATION.DSN#">
			SELECT			t_Category_2.CacheDateTime AS CacheDateTime, t_Category_2.CategoryAlias as CategoryAlias
			FROM			t_Category t_Category_1 
			LEFT OUTER JOIN	t_Category t_Category_2
			ON				t_Category_1.ParentID=t_Category_2.CategoryID
			WHERE			t_Category_1.CategoryID=<cfqueryparam value="#Val(ATTRIBUTES.CurrentCategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif GetSource.RecordCount IS "1">
			<CFSET ExecuteTempFile="#GetSource.CategoryAlias#_#Val(ATTRIBUTES.PositionID)#_#APPLICATION.LocaleID#_#DateFormat(GetSource.CacheDateTime,'yyyymmdd')##TimeFormat(GetSource.CacheDateTime,'HHmmss')#.cfm">
			<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#")>
				<cfhttp url="#CGI.HTTP_HOST##APPLICATION.utilsObj.parseCategoryUrl(GetSource.CategoryAlias)#" method="GET">
			</cfif>
			<cfset FileContents="<cfinclude template=""#APPLICATION.TempMapping##ExecuteTempFile#"">">
		</cfif>
	</cfcase>
	<cfcase value="212"><!--- Image --->
		<!--- <cfset this.sFields[ThisATTRIBUTES.ContentTypeID]="Image,LinkURL"> --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"Image")>
			<cfset ContentAbstract="">
			<cfquery name="GetContentProps" datasource="#APPLICATION.DSN#">
				SELECT		*, t_Properties.PropertiesPacket
				FROM		t_ContentLocale
				INNER JOIN	t_Properties
				ON			t_ContentLocale.PropertiesID=t_Properties.PropertiesID
				WHERE		ContentLocaleID=<cfqueryparam value="#Val(APPLICATION.LocaleID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif IsWddx(GetContentProps.PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetContentProps.PropertiesPacket#" output="sProperties">
				<cfif StructKeyExists(sProperties,"ContentAbstract") AND Trim(StructFind(sProperties,"ContentAbstract")) is not "">
					<cfset ContentAbstract=sProperties.ContentAbstract>
				</cfif>
			</cfif>
			<cfif StructKeyExists(ATTRIBUTES.sContentBody,"LinkURL") and ATTRIBUTES.sContentBody.LinkURL IS NOT "">
				<cfset ThisURL=ATTRIBUTES.sContentBody.LinkURL>
				<cfif Left(ThisURL,4) IS "http">
					<cfset FileContents="<a href=""#ThisURL#"" target=""_blank""><img src=""#ATTRIBUTES.sContentBody.Image#"" alt=""#ContentAbstract#"" border=""0""/></a>">
				<cfelse>
					<cfset FileContents="<a href=""#ThisURL#""><img src=""#ATTRIBUTES.sContentBody.Image#"" alt=""#ContentAbstract#"" border=""0""/></A>">
				</cfif>
			<cfelse>
				<cfset FileContents="<img src=""#ATTRIBUTES.sContentBody.Image#"" alt=""#ContentAbstract#""/>">
			</cfif>
		</cfif>
	</cfcase>

	<cfcase value="218"><!--- Flash --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"Flash") and StructKeyExists(ATTRIBUTES.sContentBody,"Image")>
			<cfoutput>
			<cfif Trim(ATTRIBUTES.sContentBody.Flash) IS NOT "">
				<cfsavecontent variable="TheseContents">
					<!--page flash-->
					<div>
					<script LANGUAGE=JavaScript1.1 type="text/javascript">
					<!--
					var MM_contentVersion=7;
					var plugin=(navigator.mimeTypes && navigator.mimeTypes["application/x-shockwave-flash"]) ? navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin : 0;
					if ( plugin ) {
					 var words=navigator.plugins["Shockwave Flash"].description.split(" ");
					 for (var i=0; i < words.length; ++i)
					   {
					  if (isNaN(parseInt(words[i])))
					  continue;
					  var MM_PluginVersion=words[i];
					    }
					 var MM_FlashCanPlay=MM_PluginVersion >= MM_contentVersion;
					}
					else if (navigator.userAgent && navigator.userAgent.indexOf("MSIE")>=0 && (navigator.appVersion.indexOf("Win") != -1)) {
					document.write('<SCR' + 'IPT LANGUAGE=VBScript\> \n'); //FS hide this from IE4.5 Mac by splitting the tag
					document.write('on error resume next \n');
					document.write('MM_FlashCanPlay=( IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash." & MM_contentVersion)))\n');
					document.write('</SCR' + 'IPT\> \n');
					}
					if ( MM_FlashCanPlay ) {
					  document.write('<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"');
					 document.write('  codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0" ');
					 document.write(' ID="homeflash" width="#ATTRIBUTES.sContentBody.Imagewidth# " height="#ATTRIBUTES.sContentBody.Imageheight# " ALIGN="">');
					 document.write(' <PARAM NAME=movie VALUE ="#ATTRIBUTES.sContentBody.Flash#"> <PARAM NAME=quality VALUE=high> <PARAM NAME=wmode VALUE=transparent> <PARAM NAME=bgcolor VALUE=##FFFFFF>  ');
					 document.write(' <EMBED src="#ATTRIBUTES.sContentBody.Flash# " quality="high" wmode="transparent" bgcolor="##FFFFFF"');
					 document.write(' swLiveConnect=FALSE width="#ATTRIBUTES.sContentBody.Imagewidth#" height="#ATTRIBUTES.sContentBody.Imageheight#" NAME="homeflash" ALIGN=""');
					 document.write(' TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer">' );
					 document.write(' </EMBED>');
					 document.write(' </OBJECT>');
					} else{
					 document.write('<img src="#ATTRIBUTES.sContentBody.Image#" width="#ATTRIBUTES.sContentBody.Imagewidth#" height="#ATTRIBUTES.sContentBody.Imageheight#">');
					}
					//-->
					</SCRIPT><noscript><cfif StructKeyExists(ATTRIBUTES.sContentBody,"LinkURL") AND Trim(ATTRIBUTES.sContentBody.LinkURL) Is NOT ""><a href="#ATTRIBUTES.sContentBody.LinkURL#"></cfif><img src="#ATTRIBUTES.sContentBody.Image#" width="#ATTRIBUTES.sContentBody.Imagewidth#" height="#ATTRIBUTES.sContentBody.Imageheight#" border="0"></A></noscript>
					</div>
					<!-- end flash-->
				</cfsavecontent>
			<cfelse>
				<cfsavecontent variable="TheseContents"><cfif StructKeyExists(ATTRIBUTES.sContentBody,"LinkURL") AND Trim(ATTRIBUTES.sContentBody.LinkURL) Is NOT ""><a href="#ATTRIBUTES.sContentBody.LinkURL#"></cfif><img src="#ATTRIBUTES.sContentBody.Image#" width="#ATTRIBUTES.sContentBody.Imagewidth#" height="#ATTRIBUTES.sContentBody.Imageheight#" border="0"></A></cfsavecontent>
			</cfif>
			</cfoutput>
			<cfset FileContents="#TheseContents#">
		</cfif>
	</cfcase>
	<cfcase value="223">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"LinkURL")>
			<cfset FileContents="<iframe src=""#ATTRIBUTES.sContentBody.LinkURL#"" width=""515"" height=""1000"" frameborder=""0""></iframe>">
		</cfif>
	</cfcase>
	<cfcase value="214">
		<cfquery name="GetContentProps" datasource="#APPLICATION.DSN#">
			SELECT		*, t_Properties.PropertiesPacket
			FROM		t_Content
			INNER JOIN	t_Properties
			ON			t_Content.PropertiesID=t_Properties.PropertiesID
			WHERE		ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset lArticleID="">
		<cfif IsWddx(GetContentProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetContentProps.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"lArticleID") AND Trim(StructFind(sProperties,"lArticleID")) is not "">
				<cfset lArticleID=sProperties.sProperties>
			</cfif>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/article/articleBanner.cfm"" lArticleID=""#lArticleID#"" ArticleListAlias=""articledatabase"">">
	</cfcase>
	<cfcase value="230"><!--- Related Content --->
		<cfquery name="GetContentProps" datasource="#APPLICATION.DSN#">
			SELECT	PropertiesPacket
			FROM	t_Properties
			WHERE	PropertiesID =	(
									SELECT	PropertiesID 
									FROM	t_Content 
									WHERE	ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
									)
		</cfquery>
		<cfset thisDisplayID=0>
		<cfif IsWddx(GetContentProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetContentProps.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"DisplayModeID")>
				<cfset thisDisplayID=sProperties.DisplayModeID>
			</cfif>
		</cfif>
		<cfif thisDisplayID EQ 12001>
			<cfset FileContents="<cfmodule template=""/common/modules/RelatedContent/events.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"">">
		<cfelse>
			<cfset FileContents="<cfmodule template=""/common/modules/RelatedContent/relatedContent.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"">">
		</cfif> 
	</cfcase>
	<cfcase value="221"><!--- news Detail --->
		<cfset FileContents="<cfmodule template=""/common/modules/news/intranet/newsDetail.cfm"" ContentID=""#ATTRIBUTES.ContentID#"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"" LocaleID=""#APPLICATION.LocaleID#"">">
	</cfcase>
	<cfcase value="224"><!--- Press Release List --->
		<cfset FileContents="<cfmodule template=""/common/modules/pressrelease/PressReleaseListing.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"" LocaleID=""#APPLICATION.LocaleID#"">">
	</cfcase>
	<cfcase value="225"><!--- biography List --->
		<cfset FileContents="<cfmodule template=""/common/modules/Biography/BiographyListing.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"" LocaleID=""#APPLICATION.LocaleID#"">">
	</cfcase>
	<cfcase value="228"><!--- News List --->
		<cfset NumItems="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"NumItems")>
			<cfset NumItems=ATTRIBUTES.sContentBody.NumItems>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/News/NewsListing.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"" LocaleID=""#APPLICATION.LocaleID#"" NumItems=""#NumItems#"">">
	</cfcase>
	<cfcase value="229"><!--- Showcase Navigation List --->
		<cfset EventDetailURL="">
		<cfset EventListingURL="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL")>
			<cfset EventDetailURL="#ATTRIBUTES.sContentBody.PageActionURL#">
		</cfif>
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"LinkURL")>
			<cfset EventListingURL="#ATTRIBUTES.sContentBody.LinkURL#">
		</cfif>
		<cfset FileContents="""#EventListingURL#""<cfmodule template=""/common/modules/display/navigation/commercial/dsp_NavShowcase.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"" LocaleID=""#APPLICATION.LocaleID#"" EventDetailURL=""#EventDetailURL#"" EventListingURL=""#EventListingURL#"">">
	</cfcase>
	<cfcase value="231"><!--- List of Recent Pages/Resources --->
		<cfset CategoryIDToUse=ATTRIBUTES.CurrentCategoryID>
		<cfquery name="GetContentProps" datasource="#APPLICATION.DSN#">
			SELECT		*, t_Properties.PropertiesPacket
			FROM		t_Content
			INNER JOIN	t_Properties
			ON			t_Content.PropertiesID=t_Properties.PropertiesID
			WHERE		ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset ShowQuestionRange="All">
		<cfif IsWddx(GetContentProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetContentProps.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"SourceCategoryID") AND val(StructFind(sProperties,"SourceCategoryID")) GT "0">
				<cfset CategoryIDToUse="#sProperties['SourceCategoryID']#">
			</cfif>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/display/dsp_Recent.cfm"" CategoryID=""#CategoryIDToUse#"">">
	</cfcase>
	<cfcase value="232"><!--- Index of Sub Pages --->
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/display/dsp_NavSubPages.cfm" CategoryID="#ATTRIBUTES.CurrentCategoryID#">
		</cfsavecontent>
	</cfcase>
	<cfcase value="236"><!--- Event Listing --->
		<cfset Mode="Future">
		<cfset lTopicID="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL") and ATTRIBUTES.sContentBody.PageActionURL IS NOT "">
			<cfset EventDetailURL="#ATTRIBUTES.sContentBody.PageActionURL#">
		</cfif>
		<cfquery name="GetContentProps" datasource="#APPLICATION.DSN#">
			SELECT		t_Properties.PropertiesPacket
			FROM		t_Content
			INNER JOIN	t_Properties
			ON			t_Content.PropertiesID=t_Properties.PropertiesID
			WHERE		ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif IsWddx(GetContentProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetContentProps.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ShowNavigationRangeID") AND sProperties.ShowNavigationRangeID IS "2001">
				<cfset Mode="Recent">
			</cfif>
			<cfif StructKeyExists(sProperties,"lTopicID") AND sProperties.lTopicID IS NOT "">
				<cfset lTopicID="#sProperties.lTopicID#">
			</cfif>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/calendar/calendarListing.cfm"" Mode=""#Mode#"" lTopicID=""#lTopicID#"">">
	</cfcase>

	<cfcase value="238"><!--- Event Calendar --->
		<cfset Mode="Future">
		<cfset lTopicID="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL") and ATTRIBUTES.sContentBody.PageActionURL IS NOT "">
			<cfset EventDetailURL="#ATTRIBUTES.sContentBody.PageActionURL#">
		</cfif>
		<cfquery name="GetContentProps" datasource="#APPLICATION.DSN#">
			SELECT		t_Properties.PropertiesPacket
			FROM		t_Content
			INNER JOIN	t_Properties
			ON			t_Content.PropertiesID=t_Properties.PropertiesID
			WHERE		ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif IsWddx(GetContentProps.PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#GetContentProps.PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"ShowNavigationRangeID") AND sProperties.ShowNavigationRangeID IS "2001">
				<cfset Mode="Recent">
			</cfif>
			<cfif StructKeyExists(sProperties,"lTopicID") AND sProperties.lTopicID IS NOT "">
				<cfset lTopicID="#sProperties.lTopicID#">
			</cfif>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/calendar/calendarControl.cfm"" Mode=""#Mode#"" lTopicID=""#lTopicID#"">">
	</cfcase>

	<cfcase value="240"><!--- Event Detail --->
		<cfset EventID="-1">
		<cfif IsDefined("URL.eid") and application.utilsObj.SimpleDecrypt(Val(URL.eid)) GT "0">
			<cfset EventID=application.utilsObj.SimpleDecrypt(Val(URL.eid))>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/Events/EventDetail.cfm"" CategoryID=""#ATTRIBUTES.CurrentCategoryID#"" EventID=""#EventID#"">">
	</cfcase>

	<cfcase value="239"><!--- Event iCal download --->
		<cfset EventID="-1">
		<cfif IsDefined("URL.eid") and application.utilsObj.SimpleDecrypt(Val(URL.eid)) GT "0">
			<cfset EventID=application.utilsObj.SimpleDecrypt(Val(URL.eid))>
		</cfif>
		<cfsavecontent variable="FileContents">
			<cfif ATTRIBUTES.sContentBody.Text IS NOT "">
				<cfoutput><p>#ATTRIBUTES.sContentBody.Text#</p></cfoutput>
			</cfif>
			<cfmodule template="/common/modules/Events/EventDownload.cfm" EventID="#EventID#">
		</cfsavecontent>
	</cfcase>

	<cfcase value="241"><!--- RSS --->
		<cfset RSSFile="">
		<cfset NumItems="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"File") AND Trim(StructFind(ATTRIBUTES.sContentBody,"File")) is not "">
			<cfset RSSFile=application.utilsObj.GetPathFromURL(ATTRIBUTES.sContentBody.File)>
		</cfif>
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"NumItems") AND Trim(StructFind(ATTRIBUTES.sContentBody,"NumItems")) is not "">
			<cfset NumItems=ATTRIBUTES.sContentBody.NumItems>
		</cfif>
		<cfif RSSFile IS NOT "">
			<cfset FileContents="<cfmodule template=""/common/modules/utils/rss.cfm"" File=""#RSSFile#"" NumItems=""#NumItems#"">">
		</cfif>
	</cfcase>
	<cfcase value="234"><!--- templatized content --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"sHTML")>
			<cfquery name="GetSource" datasource="#APPLICATION.DSN#">
				select SourceID from t_Content WHere ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetSource.RecordCount IS "1">
				<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetSourceContent">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#GetSource.SourceID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
				</cfstoredproc>
				<cfif GetSourceContent.RecordCount IS "1">
					<cfif IsWDDX(GetSourceContent.ContentBody)>
						<cfwddx action="WDDX2CFML" input="#GetSourceContent.ContentBody#" output="sContentBody">
					<cfelse>
						<cfset sContentBody=StructNew()>
					</cfif>
					<cfif StructKeyExists(sContentBody,"HTMLTemplate")>
						<cfset ThisOutput=sContentBody["HTMLTemplate"]>
						<cfset ThissHTML=ATTRIBUTES.sContentBody["sHTML"]>
						<cfloop index="ThisToken" list="#StructKeyList(ThissHTML)#">
							<!--- get the token name --->
							<cfset ThisTokenName=getToken(ThisToken, 1, ":") />
							
							<!--- if the token has a type, will store values in a struct --->
							<cfif isStruct(ThissHTML[ThisTokenName])>
								<cfif structKeyExists(ThissHTML[ThisTokenName], "type") and len(trim(ThissHTML[ThisTokenName].type))>
									<cfset thisToken=thisToken & ":" & ThissHTML[ThisTokenName].type />
								</cfif>
								<cfset ThisOutput=ReplaceNoCase(ThisOutput,"[[#ThisToken#]]",ThissHTML[ThisTokenName].value,"all")>
							<cfelse>
								<cfset ThisOutput=ReplaceNoCase(ThisOutput,"[[#ThisToken#]]",ThissHTML[ThisTokenName],"all")>
							</cfif>
						</cfloop>
						<cfset FileContents=application.utilsObj.ObscureEMail(application.utilsObj.ReplaceMarks(ThisOutput))>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="245"><!--- Banner --->
		<cfquery name="GetSource" datasource="#APPLICATION.DSN#">
			select SourceID from t_Content WHere ContentID=#Val(ATTRIBUTES.ContentID)#
		</cfquery>
		<cfif GetSource.RecordCount IS "1">
			<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetSourceContent">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#GetSource.SourceID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>
			<cfif GetSourceContent.RecordCount IS "1">
				<cfif IsWDDX(GetSourceContent.ContentBody)>
					<cfwddx action="WDDX2CFML" input="#GetSourceContent.ContentBody#" output="sContentBody">
				<cfelse>
					<cfset sContentBody=StructNew()>
				</cfif>
				<cfmodule template="/common/modules/ContentManager/ContentControl.cfm" sContentBody="#sContentBody#" CurrentCategoryID="#ATTRIBUTES.CurrentCategoryID#" ContentTypeID="#GetSourceContent.ContentTypeID#" returnVariable="TheseFileContents" PositionID="#ATTRIBUTES.PositionID#">
				<cfset FileContents="#TheseFileContents#">
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="242"><!--- Job Search --->
		<cfset PageActionURL="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL")>
			<cfset PageActionURL=ATTRIBUTES.sContentBody.PageActionURL>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/job/jobSearchForm.cfm"" ChapterID=""#APPLICATION.ChapterID#"" PageActionURL=""#PageActionURL#"">">
	</cfcase>
	<cfcase value="246"><!--- Job Listing --->
		<cfset PageActionURL="#APPLICATION.utilsObj.parseCategoryUrl('Job_Detail')#">
		<cfset lStateProvince="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL") and ATTRIBUTES.sContentBody.PageActionURL IS NOT "">
			<cfset PageActionURL=ATTRIBUTES.sContentBody.PageActionURL>
		</cfif>
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"lStateProvince")>
			<cfset lStateProvince=ATTRIBUTES.sContentBody.lStateProvince>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/job/jobSearchResults.cfm"" ChapterID=""#APPLICATION.ChapterID#"" PageActionURL=""#PageActionURL#"" lStateProvinceCode=""#lStateProvince#"">">
	</cfcase>
	<cfcase value="244"><!--- Recent Jobs Listing --->
		<cfset NumItems="">
		<cfset lStateProvince="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"NumItems")>
			<cfset NumItems=ATTRIBUTES.sContentBody.NumItems>
		</cfif>
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"lStateProvince")>
			<cfset lStateProvince=ATTRIBUTES.sContentBody.lStateProvince>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/job/JobRecentListings.cfm"" ChapterID=""#APPLICATION.ChapterID#"" NumItems=""#NumItems#"" lStateProvinceCode=""#lStateProvince#"">">
	</cfcase>
	<cfcase value="243"><!--- Job Detail --->
		<cfset FileContents="<cfmodule template=""/common/modules/job/JobDetail.cfm"">">
	</cfcase>
	<cfcase value="247"><!--- HTTP Get --->
		<cfset HTTPContent="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"linkURL")>
			<cfhttp url="#ATTRIBUTES.sContentBody.linkURL#" method="GET">
			<cfset HTTPContent="#CFHTTP.FileContent#">
		</cfif>
		<cfset FileContents="#HTTPContent#">
	</cfcase>
	<cfcase value="248"><!--- Recent Comments --->
		<cfset FileContents="<cfmodule template=""/common/modules/Discussion/navigation/recentComments.cfm"">">
	</cfcase>
	<cfcase value="252"><!--- Recent Discussions --->
		<cfset lMTCategoryIDAllow="">
		<cfset NumItems="">
		<cfset LinkURL="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"lMTCategoryIDAllow") and ATTRIBUTES.sContentBody.lMTCategoryIDAllow IS NOT "">
			<cfset lMTCategoryIDAllow="#ATTRIBUTES.sContentBody.lMTCategoryIDAllow#">
		</cfif>
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"NumItems")>
			<cfset NumItems=ATTRIBUTES.sContentBody.NumItems>
		</cfif>
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"LinkURL")>
			<cfset LinkURL=ATTRIBUTES.sContentBody.LinkURL>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/Discussion/navigation/recentDiscussions.cfm"" lCategoryID=""#lMTCategoryIDAllow#"" NumItems=""#NumItems#"" LinkURL=""#LinkURL#"">">
	</cfcase>
	<cfcase value="249"><!--- Gallery Thumbnail Navigation --->
		<cfquery name="qContentGallery" datasource="#APPLICATION.DSN#">
			SELECT	sourceID
			FROM	t_content
			WHERE	contentID=<cfqueryparam value="#val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset PageActionURL="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL")>
			<cfset PageActionURL=ATTRIBUTES.sContentBody.PageActionURL>
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/Gallery/thumbnailNavigation.cfm"" galleryCategoryID=""#qContentGallery.sourceID#"" PageActionURL=""#PageActionURL#"">">
	</cfcase>
	<cfcase value="250"><!--- Gallery Display --->
		<cfquery name="qContentGallery" datasource="#APPLICATION.DSN#">
			SELECT	sourceID
			FROM	t_content
			WHERE	contentID=<cfqueryparam value="#val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset FileContents="<cfmodule template=""/common/modules/Gallery/dsp_gallery.cfm"" galleryCategoryID=""#qContentGallery.sourceID#"">">
	</cfcase>
	<cfcase value="251"><!--- Event Registration--->
		<cfquery name="GetEvent" datasource="#APPLICATION.DSN#">
			SELECT		t_Content_2.SourceID
			FROM		dbo.t_Content t_Content_1
			INNER JOIN	dbo.t_Content t_Content_2 
			ON			t_Content_1.SourceID=t_Content_2.ContentID
			WHERE		t_Content_1.contentID=<cfqueryparam value="#val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset FileContents="<cfmodule template=""/common/modules/Events/Registration/ChapterEventDriver.cfm"" ChapterCode=""#APPLICATION.LocaleCode#"" EventID=""#GetEvent.SourceID#"">">
	</cfcase>
	<cfcase value="253"><!--- Newsletter subscribe/unsubscribe--->
		<cfset ActionURL="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"PageActionURL")>
			<cfset ActionURL="#ATTRIBUTES.sContentBody.PageActionURL#">
		</cfif>
		<cfset FileContents="<cfmodule template=""/common/modules/Newsletter/NewsletterSubscribe.cfm"" PageActionURL=""#ActionURL#"">">
	</cfcase>
	<cfcase value="254"><!--- Blog Entry Listing --->
		<cfset BlogID="-1">
		<cfquery name="GetSource" datasource="#APPLICATION.DSN#">
			SELECT	SourceID 
			FROM	t_Content 
			WHERE	ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset BlogID=GetSource.SourceID>
		<cfset FileContents="<cfmodule template=""/common/modules/blog/dsp_BlogListing.cfm"" BlogID=""#Val(BlogID)#"">">
	</cfcase>
	<cfcase value="255"><!--- Blog Navigation --->
		<cfset BlogID="-1">
		<cfquery name="GetSource" datasource="#APPLICATION.DSN#">
			SELECT	SourceID 
			FROM	t_Content 
			WHERE	ContentID=<cfqueryparam value="#Val(ATTRIBUTES.ContentID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset BlogID=GetSource.SourceID>
		<cfset FileContents="<cfmodule template=""/common/modules/blog/dsp_BlogNav.cfm"" BlogID=""#Val(BlogID)#"">">
	</cfcase>
	<cfcase value="222"><!--- List of Files --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"aFile") AND IsArray(ATTRIBUTES.sContentBody.aFile) AND ArrayLen(ATTRIBUTES.sContentBody.aFile) GT 0>
			<cfset aFile=ATTRIBUTES.sContentBody.aFile>
			<cfif ATTRIBUTES.CurrentCategoryTypeID IS "66"><!--- Article --->
				<cfsavecontent variable="FileContents">
					<cfoutput>
					<ol class="related-images">
					<cfloop from="1" to="#ArrayLen(aFile)#" index="i">
						<cfset sFile=aFile[i]>
						<cfif IsStruct(sFile) AND StructKeyExists(sFile,"FilePath") AND sFile.FilePath NEQ "" AND FileExists(application.utilsObj.GetPathFromURL(sFile.FilePath))>
							<cfset thisName="">
							<cfset ThisLink="/common/modules/utils/ImagePopup.cfm?image=#URLEncodedFormat(sFile.FilePath)#">
							<cfset ThisLink="PopupPic('#JSStringFormat(ThisLink)#')">
							<cfif StructKeyExists(sFile,"ThumbnailPath") AND sFile.ThumbnailPath NEQ "" AND FileExists(application.utilsObj.GetPathFromURL(sFile.ThumbnailPath))>
								
								<cfset thisName="<img src=""#sFile.ThumbnailPath#"" border=""0"" />">
							</cfif>
							<cfif StructKeyExists(sFile,"FileName") AND sFile.FileName NEQ "">
								<cfset thisName=thisName & sFile.FileName>
							<cfelse>
								<cfset thisName=thisName & " Fig. #i#">
							</cfif>
							<li><a href="javascript:void(#ThisLink#);">#thisName#</a></li>
						</cfif>
					</cfloop>
					</ol>
					</cfoutput>
				</cfsavecontent>
			<cfelse>
				<cfsavecontent variable="FileContents">
					<cfoutput>
					<ul class="resources">
					<cfloop from="1" to="#ArrayLen(aFile)#" index="i">
						<cfset sFile=aFile[i]>
						<cfif IsStruct(sFile) AND StructKeyExists(sFile,"FilePath") AND sFile.FilePath NEQ "" AND FileExists(application.utilsObj.GetPathFromURL(sFile.FilePath))>
							<cfif ListFindNoCase("mov,mp4",ListLast(sFile.FilePath,".")) IS "video">
								<cfset ThisIcon="/common/images/icons/icon-qt.gif">
								<cfset ThisAlt="video podcast available">
							<cfelseif ListFindNoCase("pdf",ListLast(sFile.FilePath,"."))>
								<cfset ThisIcon="/common/images/icons/icon-pdf.gif">
								<cfset ThisAlt="pdf available">
							<cfelseif ListFindNoCase("mp3",ListLast(sFile.FilePath,"."))>
								<cfset ThisIcon="/common/images/icons/icon-audio.gif">
								<cfset ThisAlt="audio podcast available">
							<cfelse>
								<cfset ThisIcon="">
								<cfset ThisAlt="">
							</cfif>
							<cfif ListFindNoCase("mov,mp4",ListLast(sFile.FilePath,"."))>
								<cfset ThisLink="javascript:void(window.open('/common/modules/video/player.cfm?source=#URLEncodedFormat(sFile.FilePath)#','vidplayer','scrollbars=1,resizable=1,height=320,width=340'))">
							<cfelse>
								<cfset ThisLink="#sFile.FilePath#">
							</cfif>
							<li><a name="#application.utilsObj.Scrub(sFile.FileName)#"></a>
				            <dl>
								<dt><a href="#ThisLink#" <cfif ListFindNoCase("mov,mp4",ListLast(sFile.FilePath,".")) is "0">target="_blank"</cfif>><cfif ThisIcon IS NOT ""><img class="res-icon" src="#ThisIcon#" alt="#ThisAlt#" /> </cfif>#sFile.FileName#</a></dt>
								<dd>#sFile.FileCaption#</dd>
				            </dl>
							</li>
						</cfif>
					</cfloop>
					<ul>
					</cfoutput>
				</cfsavecontent>
			</cfif>
		</cfif>
	</cfcase>
	<cfcase value="256"><!--- List of Links / Text Slide Show --->
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"aLink") AND IsArray(ATTRIBUTES.sContentBody.aLink) AND ArrayLen(ATTRIBUTES.sContentBody.aLink) GT 0>
			<cfset aLink=ATTRIBUTES.sContentBody.aLink>
			<cfsavecontent variable="FileContents">
				<cfoutput>
					<div id="salco-statements">
					<cfloop from="1" to="#ArrayLen(aLink)#" index="i">
						<cfset sLink=aLink[i]>
						<cfset thisCaption="">
						<cfif StructKeyExists(sLink,"Title") AND sLink.Title NEQ "">
							<cfset thisName=sLink.Title>
						<cfelse>
							<cfset thisName=sLink.URL>
						</cfif>
						<cfif StructKeyExists(sLink,"Caption") AND sLink.Caption NEQ "">
							<cfset thisCaption=sLink.Caption>
						</cfif>
						<div id="ss-#i#" class="ss-statements<cfif i IS "1"> on</cfif>">
							<h3>#thisName#</h3>
							<p>#thisCaption#</p>
						</div>
					</cfloop>
					<ul id="statements-navigation">
					<cfloop from="1" to="#ArrayLen(aLink)#" index="i">
						<cfset sLink=aLink[i]>
						<cfif StructKeyExists(sLink,"Title") AND sLink.Title NEQ "">
							<cfset thisName=sLink.Title>
						<cfelse>
							<cfset thisName=sLink.URL>
						</cfif>
						<li><a href="##ss-#i#"<cfif i IS "1"> class="on"</cfif>>#thisName#</a></li>
					</cfloop>
					</ul>
					</div>
				</cfoutput>
			</cfsavecontent>
		</cfif>
	</cfcase>
	<cfcase value="256x"><!--- Article Listing --->
		<cfquery name="getThisCategory" datasource="#APPLICATION.DSN#">
			SELECT CategoryTypeID,CategoryName,CategoryAlias FROM t_Category
			WHERE CategoryID=<cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.CurrentCategoryID#">
		</cfquery>
		<cfset thisTitle="">
		<cfset thisNumItems="">
			<cfswitch expression="#getThisCategory.CategoryTypeID#">
				<cfcase value="76"><!--- Journal --->
					<cfset KeyType="Journal">
					<cfset KeyID=ATTRIBUTES.CurrentCategoryID>
				</cfcase>
				<cfdefaultcase>
					<cfset KeyType="Parent">
					<cfset KeyID=ATTRIBUTES.CurrentCategoryID>
				</cfdefaultcase>
			</cfswitch>
			<cfset thisTitle=getThisCategory.CategoryName>
			<cfif StructKeyExists(ATTRIBUTES.sContentBody,"NumItems") AND IsNumeric(ATTRIBUTES.sContentBody.NumItems)>
				<cfset thisNumItems=ATTRIBUTES.sContentBody.NumItems>
			</cfif>
		<!--- </cfif> --->
		<cfif ATTRIBUTES.returnVariable EQ "queryForRSS">
			<cfmodule template="/common/modules/Article/dsp_landing.cfm" KeyType="#KeyType#" KeyID="#KeyID#" Title="#thisTitle#" ContentID="#ATTRIBUTES.ContentID#" IsRSS="1" ResultsPerPage="#thisNumItems#">
			<cfset CALLER.qArticles=qArticles>
		<cfelse>
			<cfset FileContents="<cfmodule template=""/common/modules/Article/dsp_landing.cfm"" KeyType=""#KeyType#"" KeyID=""#KeyID#"" Title=""#thisTitle#"" ContentID=""#ATTRIBUTES.ContentID#"" IsRSS=""0"" ResultsPerPage=""#thisNumItems#"">">
		</cfif>
	</cfcase>
	<cfcase value="258"><!--- Teaser Slide Show --->
		<cfset FileContents="<cfmodule template=""/common/modules/display/dsp_TeaserSlideShow.cfm"" contentID=""#ATTRIBUTES.contentID#"">">
	</cfcase>
	<cfcase value="259"><!--- Video --->
		<cfset thisLinkURL="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"linkURL") AND ATTRIBUTES.sContentBody.linkURL NEQ "">
			<cfset thisLinkURL=ATTRIBUTES.sContentBody.linkURL>
		</cfif>

		<cfset thisImageThumbnail="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"ImageThumbnail") AND ATTRIBUTES.sContentBody.ImageThumbnail NEQ "">
			<cfset thisImageThumbnail=ATTRIBUTES.sContentBody.ImageThumbnail>
		</cfif>

		<cfset thisContentName=HTMLEditFormat(ATTRIBUTES.contentNameDerived)>

		<cfsavecontent variable="fileContents">
			<cfoutput>
				<video width="525" height="298" controls="" id="salcoPlayer#ATTRIBUTES.ContentID#" class="projekktor"
				<cfif thisImageThumbnail IS NOT "">
					poster="#thisImageThumbnail#"
				</cfif>
				title="#thisContentName#"><source type="video/mp4" src="/resources/external/videos/#thisLinkURL#"></source>
				</video>
				<script type="text/javascript">
					document.addEventListener("DOMContentLoaded", init, false);
					
					function init(){
						var video = document.getElementById("salcoPlayer#ATTRIBUTES.ContentID#");
						video.addEventListener("play", videoPlay, false);
						video.addEventListener("pause", videoPause, false);
						video.addEventListener("ended", videoEnd, false);
						console.log(video);
					}
							
					function videoPlay(event) {
						trackEvent('Play', '#thisContentName#'); 
					}
					
					function videoPause(event) {
						trackEvent('Pause', '#thisContentName#'); 
					}
					
					function videoEnd(event) {
						trackEvent('Ended', '#thisContentName#'); 
					}
					
					function trackEvent(action, title) {
						_gaq.push(['_trackEvent', 'Video Library', action, title]);
					}
				</script>
			</cfoutput>
		</cfsavecontent>
	</cfcase>
	<cfcase value="260"><!--- Related Topic List --->
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/Topic/getRelatedTopics.cfm" CategoryID="#ATTRIBUTES.CurrentCategoryID#">
		</cfsavecontent>
	</cfcase>
	<cfcase value="261"><!--- Discussion --->
		<cfparam name="URL.dscid" default="0">
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/DiscussionNew/viewDiscussion.cfm" DiscussionID="#URL.dscid#">
		</cfsavecontent>
	</cfcase>
	<cfcase value="262"><!--- section landing --->
		<cfset thisContent="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"HTML") AND ATTRIBUTES.sContentBody.HTML NEQ "">
			<cfset thisContent=ATTRIBUTES.sContentBody.HTML>
		</cfif>
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/RelatedContent/landing.cfm" Content="#thisContent#" ContentID="#ATTRIBUTES.ContentID#" CategoryID="#ATTRIBUTES.CurrentCategoryID#">
		</cfsavecontent>
	</cfcase>
	<cfcase value="263"><!--- institutional landing --->
		<cfset thisContent="">
		<cfif StructKeyExists(ATTRIBUTES.sContentBody,"HTML") AND ATTRIBUTES.sContentBody.HTML NEQ "">
			<cfset thisContent=ATTRIBUTES.sContentBody.HTML>
		</cfif>
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/display/dsp_institutionalLanding.cfm" Content="#thisContent#" CategoryID="#ATTRIBUTES.CurrentCategoryID#">
		</cfsavecontent>
	</cfcase>
	<cfcase value="264"><!--- RSS --->
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/RSS/rss.cfm" ProcessMode="Display" CategoryID="#ATTRIBUTES.CurrentCategoryID#" ContentID="#ATTRIBUTES.ContentID#">
		</cfsavecontent>
	</cfcase>
	<cfcase value="265"><!--- Article Listing (manual) --->
		<cfif ATTRIBUTES.returnVariable EQ "queryForRSS">
			<cfmodule template="/common/modules/Article/dsp_landing.cfm" KeyType="List" ContentID="#ATTRIBUTES.ContentID#" IsRSS="1">
			<cfset CALLER.qArticles=qArticles>
		<cfelse>
			<cfset FileContents="<cfmodule template=""/common/modules/Article/dsp_landing.cfm"" KeyType=""List"" ContentID=""#ATTRIBUTES.ContentID#"" IsRSS=""0"">">
		</cfif>
	</cfcase>
	<cfcase value="266"><!--- File List w/RSS --->
		<cfsavecontent variable="FileContents">
			<cfmodule template="/common/modules/RSS/PodCast.cfm"
				ProcessMode="Display" 
				ContentID="#ATTRIBUTES.ContentID#">
		</cfsavecontent>
	</cfcase>
	<cfdefaultCase>
		<cfquery name="GetContentTypes" datasource="#APPLICATION.DSN#">
			select LabelName from t_Label Where LabelID=#Val(ATTRIBUTES.ContentTypeID)#
		</cfquery>
		<cfset FileContents="#GetContentTypes.LabelName# Module (Under Construction)">
	</cfdefaultcase>
</cfswitch>

<cfset SetVariable("CALLER.#ATTRIBUTES.returnVariable#","#FileContents#")>