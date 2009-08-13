<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.CategoryAlias" default="">
<cfparam name="ThisCategoryID" default="-1">

<cfset CALLER.NoContent="1">

<!--- Check given alias first and obtain categoryid--->
<cfif ATTRIBUTES.CategoryAlias IS NOT "">
	<cfquery name="GetCategoryID" datasource="#APPLICATION.DSN#" maxrows=1 dbtype="ODBC">
		SELECT	CategoryID
		FROM	t_Category
		WHERE	CategoryAlias = <cfqueryparam value="#Trim(ATTRIBUTES.CategoryAlias)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
	</cfquery>
	<cfif GetCategoryID.RecordCount IS "1">
		<cfset ATTRIBUTES.CategoryID=GetCategoryID.CategoryID>
	</cfif>
</cfif>


<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetPage" maxrows="1">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.CategoryID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
</cfstoredproc>

<cfif IsDefined("GetPage") AND GetPage.RecordCount IS "0">
	<cfset CALLER.NoContent="1">
</cfif>
<cfset CALLER.CurrentCategoryName="Page Not Found">
<cfset CALLER.CurrentPageTitle="Page Not Found">
<cfset CALLER.ParentCategoryName="">
<cfset CALLER.PageTitleOverride="">
<cfset CALLER.CurrentCategoryAlias="">
<cfset REQUEST.CurrentCategoryAlias="">
<cfset CALLER.CategoryTypeID="-1">
<cfset CALLER.TemplateID="-1">
<cfset CALLER.CurrentCategoryID="-1">
<cfset CALLER.CurrentSourceID="-1">
<cfset CALLER.CurrentCategoryParentID="-1">
<cfset CALLER.CurrentCategoryTypeID="-1">
<cfset CALLER.CategoryThreadList="-1">
<cfset CALLER.CategoryThreadName="">
<cfset CALLER.CategoryThreadAlias="">
<cfset CALLER.CategoryImageRepresentative="">
<cfset CALLER.CategoryImageTitle="">
<cfset CALLER.MetaDescription="">
<cfset CALLER.MetaKeywords="">
<cfset CALLER.CacheDateTime="#now()#">
<cfset CALLER.sIncludeFile=StructNew()>
<cfset CALLER.sIncludeFileBlank=StructNew()>
<cfset CALLER.sContent=StructNew()>
<cfset CALLER.CenterColumnTitle="">
<cfset CALLER.AllowComments="0">

<cfset DenyAccess="0">
<cfset LoginPageCacheDateTime="">
<cfset LoginPageCategoryID="">
<cfset LoginPageAlias="">

<cfset lPosition="400,401,402">
<cfloop index="ThisPosition" list="#lPosition#">
	<cfset StructInsert(CALLER.sIncludeFile,ThisPosition,"",1)>
	<cfset StructInsert(CALLER.sIncludeFileBlank,ThisPosition,"1",1)>
	<cfif REQUEST.ContentGenerateMode IS "FLAT">
		<cfset StructInsert(CALLER.sContent,ThisPosition,"",1)>
	</cfif>
</cfloop>

<cfif IsDefined("GetPage") and GetPage.RecordCount IS "1">
	<cfset CALLER.NoContent="0">
	<cfset CALLER.CurrentCategoryName=GetPage.CategoryNameDerived>
	<cfset CALLER.CurrentPageTitle=GetPage.CategoryNameDerived>
	<cfset CALLER.TemplateID=GetPage.TemplateID>
	<cfset CALLER.CategoryTypeID=GetPage.CategoryTypeID>
	<cfset CALLER.CurrentCategoryParentID=GetPage.ParentID>
	<cfset CALLER.CurrentCategoryAlias=GetPage.CategoryAlias>
	<cfset REQUEST.CurrentCategoryAlias=GetPage.CategoryAlias>
	<cfset CALLER.CurrentCategoryID=GetPage.CategoryID>
	<cfset CALLER.CurrentSourceID=GetPage.SourceID>
	<cfif IsWDDX(GetPage.CategoryLocalePropertiesPacket)>
		<cfwddx action="WDDX2CFML" input="#GetPage.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
		<cfloop index="ThisProp" list="MetaDescription,MetaKeywords,PageTitleOverride">
			<cfif StructKeyExists(sCategoryProperties,"#ThisProp#") AND Trim(StructFind(sCategoryProperties, "#ThisProp#")) IS NOT "">
				<cfset Setvariable("CALLER.#ThisProp#",StructFind(sCategoryProperties, "#ThisProp#"))>
			</cfif>
		</cfloop>
	</cfif>
	<cfif Val(GetPage.ParentID) GT "0">
		<cfquery name="GetParentPageName" datasource="#APPLICATION.DSN#">
			SELECT	CategoryName
			FROM	t_Category
			WHERE	Categoryid = <cfqueryparam value="#Val(GetPage.ParentID)#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfset ParentCategoryName="#GetParentPageName.CategoryName#">
	</cfif>
	<cfif Trim(GetPage.CategoryURLDerived) IS NOT "">
		<cfif Left(GetPage.CategoryURLDerived,4) IS NOT "Java">
			<cfif CALLER.CategoryTypeID IS "75">
				<cfif Left(CGI.SCRIPT_NAME,Len("/content.cfm")) IS "/content.cfm">
					<cflocation url="#GetPage.CategoryURLDerived#" addtoken="No">
				</cfif>
			<cfelse>
				<cflocation url="#GetPage.CategoryURLDerived#" addtoken="No">
			</cfif>
		</cfif>
	</cfif>

	<cfset CALLER.CacheDateTime=GetPage.CacheDateTime>
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#GetPage.CategoryID#"
		namelist="#application.utilsObj.RemoveHTML(Replace(CALLER.CurrentCategoryName,","," ","all"))#"
		idlist="#GetPage.CategoryID#"
		aliaslist="#GetPage.CategoryAlias#">
	<cfif IDList IS NOT "">
		<cfset CALLER.CategoryThreadList=IDList>
		<cfset CALLER.CategoryThreadName=NameList>
		<cfset CALLER.CategoryThreadAlias=AliasList>
		<cfquery name="GetCatProps" datasource="#APPLICATION.DSN#">
			SELECT		PropertiesPacket
			FROM		qry_GetCategoryLocale
			WHERE		CategoryID IN (<cfqueryparam value="#CALLER.CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">) and LocaleID=<cfqueryparam value="#APPLICATION.DefaultLocaleID#" cfsqltype="cf_sql_integer">
			ORDER BY	displayorder DESC
		</cfquery>
		<cfoutput query="GetCatProps">
			<cfif IsWDDX(PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#PropertiesPacket#" output="sProperties">
				<cfif StructKeyExists(sProperties,"CategoryImageRepresentative") AND sProperties.CategoryImageRepresentative is not "" and CALLER.CategoryImageRepresentative is "">
					<cfset CALLER.CategoryImageRepresentative=sProperties.CategoryImageRepresentative>
				</cfif>
				<cfif StructKeyExists(sProperties,"CategoryImageTitle") AND sProperties.CategoryImageTitle is not "" and CALLER.CategoryImageTitle is "">
					<cfset CALLER.CategoryImageTitle=sProperties.CategoryImageTitle>
				</cfif>
			</cfif>
		</cfoutput>
	</cfif>

	<cfquery name="GetCatProps" datasource="#APPLICATION.DSN#">
		SELECT	PropertiesPacket
		FROM	t_Properties
		WHERE	PropertiesID = <cfqueryparam value="#Val(GetPage.categoryPropertiesID)#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	<cfoutput query="GetCatProps">
		<cfif IsWDDX(PropertiesPacket)>
			<cfwddx action="WDDX2CFML" input="#PropertiesPacket#" output="sProperties">
			<cfif StructKeyExists(sProperties,"AllowComments") AND Val(sProperties.AllowComments)>
				<cfset CALLER.AllowComments=1>
			</cfif>
		</cfif>
	</cfoutput>
	

	<!--- handle security --->
<!---
	<!--- First check if anyone is logging in via persistant right column form --->
	<cfif IsDefined("FORM.EditMemberLoginID") and IsDefined("FORM.EditMemberPassword")>
		<cfset SESSION.UserLogin = Trim(FORM.EditMemberLoginID)>
		<cfset SESSION.UserPassword = Trim(FORM.EditMemberPassword)>
		<cf_CheckMember
			MemberLoginID="#SESSION.UserLogin#"
			MemberPassword="#SESSION.UserPassword#"
			datasource="#APPLICATION.IMISDSN#"
			CheckLoginDisabledFlag="no">
	</cfif>

	<!--- Then (re)check against any security rules for current page --->
	<cfmodule template="/common/modules/security/_security.cfm"
		categorythreadlist="#CALLER.CategoryThreadList#"
		DenyAccessVar="DenyAccess"
		LoginPageAliasVar="LoginPageAlias">

	<cfif DenyAccess>
		<cfquery name="GetLoginModule" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT CategoryID, CacheDateTime
			FROM t_Category WHERE CategoryAlias=<cfqueryparam value="#LoginPageAlias#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset LoginPageCacheDateTime="#GetLoginModule.CacheDateTime#">
		<cfset LoginPageCategoryID="#GetLoginModule.CategoryID#">
	</cfif>  --->


	<!--- Increment Page View Counter 
	<cfif ListFind(SESSION.lPageIDView,Caller.CurrentCategoryID) IS "0" and Caller.CurrentCategoryID IS NOT 868>
		<cfquery name="InsertPageView" datasource="#APPLICATION.DSN#">
			insert into t_PageView (CategoryID)
			VALUES
			(<cfqueryparam value="#Caller.CurrentCategoryID#" cfsqltype="cf_sql_integer">)
		</cfquery>
		<cfset SESSION.lPageIDView=ListAppend(SESSION.lPageIDView,CALLER.CurrentCategoryID)>
	</cfif>--->
	
	<cfloop index="ThisPosition" list="#lPosition#">
		<cfset recacheThis = false>
		<cfif DenyAccess>
			<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\#APPLICATION.ApplicationName#_#LoginPageAlias#+#ThisPosition#_#APPLICATION.LocaleID#_#DateFormat(LoginPageCacheDateTime,'yyyymmdd')##TimeFormat(LoginPageCacheDateTime,'HHmmss')#.cfm">
		<cfelse>
			<cfif ListFind("2432,2548",CALLER.CurrentCategoryID)><!--- event detail, book detail always recache --->
				<cfset recacheThis = true>
			</cfif>
			<cfset ExecuteTempFile="#APPLICATION.LocaleID#\#APPLICATION.ApplicationName#_#GetPage.CategoryAlias#+#ThisPosition#_#APPLICATION.LocaleID#_#IsDefined('URL.ShowContentOnly')#_#DateFormat(CALLER.CacheDateTime,'yyyymmdd')##TimeFormat(CALLER.CacheDateTime,'HHmmss')#.cfm">
		</cfif>
		<cfset StructInsert(CALLER.sIncludeFile,ThisPosition,"#APPLICATION.TempMapping##ExecuteTempFile#",1)>
		<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") OR REQUEST.ReCache or Isdefined("prcid") or REQUEST.ContentGenerateMode IS "FLAT" OR recacheThis>
			<cfif DenyAccess>
				<cfquery name="GetInherited" datasource="#APPLICATION.DSN#">
					SELECT		ContentID 
					FROM		qry_GetContentInherit
					WHERE
							<cfif ThisPosition eq "401">
								ContentPositionID = <cfqueryparam value="#Val(ThisPosition)#" cfsqltype="cf_sql_integer">
							<cfelse>
								1=0
							</cfif>
					AND			LocaleID = <cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="cf_sql_integer">
					AND			ContentActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
					AND			CategoryActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
					AND			CategoryID = <cfqueryparam value="#Val(LoginPageCategoryID)#" cfsqltype="cf_sql_integer">
					ORDER BY	ContentLocalePriority
				</cfquery>
			<cfelse>
				<cfquery name="GetInherited" datasource="#APPLICATION.DSN#">
					SELECT		ContentID 
					FROM		qry_GetContentInherit
					WHERE		ContentPositionID = <cfqueryparam value="#Val(ThisPosition)#" cfsqltype="CF_SQL_INTEGER">
					AND			LocaleID = <cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
					AND			ContentActive = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND			CategoryActive = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND			(
									(
									CategoryID = <cfqueryparam value="#Val(CALLER.CurrentCategoryID)#" cfsqltype="CF_SQL_INTEGER"> 
									AND (
										InheritID <=<cfqueryparam value="1800" cfsqltype="CF_SQL_INTEGER"> 
										OR InheritID IS NULL
										)
									)
								OR
									(
									CategoryID IN (<cfqueryparam value="#CALLER.CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">)
									AND	InheritID = <cfqueryparam value="1801" cfsqltype="CF_SQL_INTEGER">
									)
								OR
									(
									CategoryID IN (<cfqueryparam value="#ListDeleteAt(CALLER.CategoryThreadList,ListLen(CALLER.CategoryThreadList))#" cfsqltype="cf_sql_integer" list="yes">) 
									AND InheritID=<cfqueryparam value="1802" cfsqltype="CF_SQL_INTEGER">
									)
								)
					ORDER BY	displayorder DESC, ContentLocalePriority
				</cfquery>
			</cfif>
			<cfset FileContents="">
			<cfif ThisPosition IS "401"><cfset CALLER.NoContent="1"></cfif>
			<cfset ContentCounter="1">
			<cfif GetInherited.RecordCount IS "0">
				<cfquery name="GetInherited" datasource="#APPLICATION.DSN#" maxrows="1">
					SELECT		ContentID
					FROM		qry_GetContentInherit
					WHERE		ContentPositionID = <cfqueryparam value="#Val(ThisPosition)#" cfsqltype="CF_SQL_INTEGER">
					AND			LocaleID = <cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
					AND			ContentActive = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND			CategoryActive = <cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND			CategoryID IN (<cfqueryparam value="#CALLER.CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">)
					AND			InheritID = <cfqueryparam value="1803" cfsqltype="CF_SQL_INTEGER">
					ORDER BY	displayorder DESC, ContentLocalePriority
				</cfquery>
			</cfif>
			<cfset centerCounter = 0>
			<cfloop index="ThisContentID" list="#ValueList(GetInherited.ContentID)#">
				<cfif Isdefined("prcid") and application.utilsObj.SimpleDecrypt(Val(prcid)) IS ThisContentID>
					<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
						<cfprocresult name="GetContent">
						<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(application.utilsObj.SimpleDecrypt(Val(pcid)))#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
					</cfstoredproc>
				<cfelse>
					<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
						<cfprocresult name="GetContent">
						<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(ThisContentID)#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
					</cfstoredproc>
				</cfif>
				<cfoutput query="GetContent">
					<cfset subTitle = "">
					<cfif ThisPosition IS "401">
						<cfset CALLER.NoContent="0">
						<cfset centerCounter = centerCounter+1>
						<cfif centerCounter EQ 1 and CALLER.CurrentCategoryAlias IS NOT "home">
							<cfset subTitle = "#ContentNameDerived#">
						</cfif>
					</cfif>
					<cfif IsWDDX(ContentBody)>
						<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
					<cfelse>
						<cfset sContentBody=StructNew()>
					</cfif>
					<cfmodule template="/common/modules/ContentManager/ContentControl.cfm"
						scontentbody="#sContentBody#"
						currentcategoryid="#CALLER.CurrentCategoryID#"
						currentcategorytypeid="#CALLER.CategoryTypeID#"
						contenttypeid="#ContentTypeID#"
						contentid="#ContentID#"
						ContentLocaleID="#ContentLocaleID#"
						positionid="#ThisPosition#"
						returnvariable="TheseFileContents">
					<!--- Render Title --->
					<cfif Trim(TheseFileContents) IS NOT "">
						<cfif (ContentTypeID EQ 230) or (IsDefined("URL.ShowContentOnly") AND Val(URL.ShowContentOnly))><!--- if related content, ignore title, etc... --->
							<cfset FileContents="#FileContents# #TheseFileContents#">
						<cfelse>
							<cfset Title="">
							<cfif StructKeyExists(sContentBody,"TitleTypeID")>
								<cfinclude template="/common/modules/ContentManager/TitleControl.cfm">
							</cfif>
							<cfif StructKeyExists(sContentBody,"CSSID") and sContentBody["CSSID"] IS NOT "">
								<cfset ThisID=sContentBody["CSSID"]>
							<cfelse>
								<cfset ThisID="iskContentElement#ContentID#">
							</cfif>
							
							
							<!--- design specifications --->
							<cfswitch expression="#ContentTypeID#">
								<cfdefaultcase><cfset divclass = "basic"></cfdefaultcase>
							</cfswitch>
						
							<cfif subTitle NEQ "">
								<cfset subTitle = "<h1>#subTitle#</h1>">
							</cfif>
							<cfswitch expression="#APPLICATION.ApplicationName#">
								<cfdefaultcase>
									<cfset thisContentString = "#subTitle##TheseFileContents#">
									<cfset FileContents="#FileContents# #Title# #thisContentString#">
								</cfdefaultcase>
							</cfswitch>

							<cfset ContentCounter=ContentCounter+1>
						</cfif>
					</cfif>
				</cfoutput>
			</cfloop>

			<cfif ThisPosition is "401" and CALLER.NoContent IS "1" and CALLER.CategoryTypeID IS NOT "75">


				<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetFirstChildCategory" maxrows="1">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="categoryActiveDerived" value="1" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#Val(ATTRIBUTES.CategoryID)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ShowInNavigation" value="" null="Yes">
				</cfstoredproc>

				<cfif val(GetFirstChildCategory.RecordCount) GT "0">
					<cfif GetFirstChildCategory.CategoryAlias is not "">
						<cflocation url="/content.cfm/#GetFirstChildCategory.CategoryAlias#" addtoken="No">
					<cfelse>
						<cflocation url="/content.cfm?CategoryID=#GetFirstChildCategory.CategoryID#" addtoken="No">
					</cfif>
				</cfif>
				<cfset FileContents="<p>No content found.</p>">
			</cfif>
			<cfif Trim(FileContents) IS NOT "">
				<cfset StructInsert(CALLER.sIncludeFileBlank,ThisPosition,"0",1)>
			</cfif>
			<cfif REQUEST.ContentGenerateMode IS "FLAT">
				<cfset StructInsert(CALLER.sContent,ThisPosition,"#FileContents#",1)>
			<cfelse>
				<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif CALLER.NoContent>
	<cfif REQUEST.ContentGenerateMode IS Not "FLAT">
		<cfheader
			statusCode = "404"
			statusText = "Not Found">
	</cfif>
	<cfset CALLER.NoContent="0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetErrorPage" maxrows="1">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="2570" null="No"><!--- 2570 is category id of 404 page --->
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	</cfstoredproc>
	<cfif IsDefined("GetErrorPage") AND GetErrorPage.RecordCount IS "1">
		<cfloop index="ThisPosition" list="400,401,402">
			<cfset ExecuteTempFile="#APPLICATION.LocaleID#\#GetErrorPage.CategoryAlias#+#ThisPosition#_#APPLICATION.LocaleID#_#DateFormat(GetErrorPage.CacheDateTime,'yyyymmdd')##TimeFormat(GetErrorPage.CacheDateTime,'HHmmss')#.cfm">
			<cfset StructInsert(CALLER.sIncludeFile,ThisPosition,"#APPLICATION.TempMapping##ExecuteTempFile#",1)>
			<cfset StructInsert(CALLER.sIncludeFileBlank,ThisPosition,"0",1)>
			<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") OR REQUEST.ReCache or REQUEST.ContentGenerateMode IS "FLAT">
				<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetContentList">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="2570" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="#Val(ThisPosition)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
				</cfstoredproc>
				<cfset FileContents="">
				<cfoutput query="GetContentList" group="ContentLocaleID">
					<cfif IsWDDX(ContentBody)>
						<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
					<cfelse>
						<cfset sContentBody=StructNew()>
					</cfif>
					<cfmodule template="/common/modules/ContentManager/ContentControl.cfm"
						scontentbody="#sContentBody#"
						currentcategoryid="#CALLER.CurrentCategoryID#"
						currentcategorytypeid="#CALLER.CategoryTypeID#"
						contenttypeid="#ContentTypeID#"
						contentid="#ContentID#"
						ContentLocaleID="#ContentLocaleID#"
						positionid="#ThisPosition#"
						returnvariable="TheseFileContents">
					<!--- Render Title --->
					<cfset Title="">
					<cfif StructKeyExists(sContentBody,"TitleTypeID")>
						<cfinclude template="/common/modules/ContentManager/TitleControl.cfm">
					</cfif>

					<cfif ThisPosition EQ 401 AND ContentTypeID NEQ 261>
						<cfset thisContentString = "<div class=""group basic"" id="""">#TheseFileContents#</div>">
					<cfelse>
						<cfset thisContentString = "#TheseFileContents#">
					</cfif>
					<cfset FileContents="#FileContents# #Title# #thisContentString#">
				</cfoutput>

				<cfif Trim(FileContents) IS NOT "">
					<cfset StructInsert(CALLER.sIncludeFileBlank,ThisPosition,"0",1)>
				</cfif>
				<cfif REQUEST.ContentGenerateMode IS "FLAT">
					<cfset StructInsert(CALLER.sContent,ThisPosition,"#FileContents#",1)>
				<cfelse>
					<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
				</cfif>

			</cfif>
		</cfloop>
	</cfif>
</cfif>

<!--- update the Last-Modified http header to represent the date modified ---> 
<cfset gmtdatetime=dateadd("h",GetTimeZoneInfo().utchouroffset,CALLER.CacheDateTime)>
<cfset gmtFullstring="#dateformat(gmtdatetime, "ddd, dd mmm yyyy")# #timeformat(gmtdatetime, "HH:mm:ss")# GMT">
<cfheader name="Last-Modified" value="#gmtFullstring#">

<cfset REQUEST.CategoryThreadList=CALLER.CategoryThreadList>
<cfset REQUEST.SecurityDenyAccess=DenyAccess>

