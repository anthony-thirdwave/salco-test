<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.CategoryAlias" default="">
<cfparam name="ATTRIBUTES.PreviewSourceContentID" default="-1">
<cfparam name="ATTRIBUTES.PreviewTargetContentID" default="-1">

<cfobject component="com.ContentManager.ContentManager"
	name="REQUEST.MyContentManager">
	
<cfset CALLER.NoContent="1">
<cfset CALLER.CurrentCategoryName="Page Not Found">
<cfset CALLER.CurrentPageTitle="Page Not Found">
<cfset CALLER.ParentCategoryName="">
<cfset CALLER.PageTitleOverride="">
<cfset CALLER.CurrentCategoryAlias="">
<cfset REQUEST.CurrentCategoryAlias="">
<cfset REQUEST.CurrentCategoryID="-1">
<cfset REQUEST.ProductID="-1">
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
<cfset CALLER.CommentNotificationEmail="">
<cfset CALLER.CSSID="">
<cfset CALLER.CSSClass="">
<cfset CALLER.CategoryImageHeader="">
<cfset REQUEST.CategoryImageHeader="">

<cfset DenyAccess="0">
<cfset LoginPageCacheDateTime="">
<cfset LoginPageCategoryID="">
<cfset LoginPageAlias="">

<cfset lPosition="400,401,402">
<cfloop index="ThisContentPositionID" list="#lPosition#">
	<cfset StructInsert(CALLER.sIncludeFile,ThisContentPositionID,"",1)>
	<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"1",1)>
	<cfif REQUEST.ContentGenerateMode IS "FLAT">
		<cfset StructInsert(CALLER.sContent,ThisContentPositionID,"",1)>
	</cfif>
</cfloop>

<!--- Check given alias first and obtain categoryid--->
<cfif ATTRIBUTES.CategoryAlias IS NOT "">
	<cfquery name="GetCategoryID" datasource="#APPLICATION.DSN#" maxrows=1 dbtype="ODBC">
		SELECT	CategoryID
		FROM	t_Category
		WHERE	CategoryAlias=<cfqueryparam value="#Trim(ATTRIBUTES.CategoryAlias)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
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

<cfif IsDefined("GetPage") and GetPage.RecordCount IS "1">
	<cfset CALLER.CurrentCategoryName=GetPage.CategoryNameDerived>
	<cfset CALLER.CurrentPageTitle=GetPage.CategoryNameDerived>
	<cfset CALLER.TemplateID=GetPage.TemplateID>
	<cfset CALLER.CategoryTypeID=GetPage.CategoryTypeID>
	<cfset CALLER.CurrentCategoryParentID=GetPage.ParentID>
	<cfset CALLER.CurrentCategoryAlias=GetPage.CategoryAlias>
	<cfset REQUEST.CurrentCategoryAlias=GetPage.CategoryAlias>
	<cfset CALLER.CurrentCategoryID=GetPage.CategoryID>
	<cfset REQUEST.CurrentCategoryID=GetPage.CategoryID>
	<cfset CALLER.CurrentSourceID=GetPage.SourceID>
	<cfset CALLER.CSSID=GetPage.CategoryAlias>

	<!--- If this is a product page OR a repeated product page, set the product ID --->
	<cfif CALLER.CategoryTypeID IS "64">
		<cfset REQUEST.ProductID="#CALLER.CurrentCategoryID#">
	</cfif>
	
	<cfif IsWDDX(GetPage.CategoryLocalePropertiesPacket)>
		<cfwddx action="WDDX2CFML" input="#GetPage.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
		<cfloop index="ThisProp" list="MetaDescription,MetaKeywords,PageTitleOverride,CategoryImageHeader">
			<cfif StructKeyExists(sCategoryProperties,"#ThisProp#") AND Trim(StructFind(sCategoryProperties, "#ThisProp#")) IS NOT "">
				<cfset Setvariable("CALLER.#ThisProp#",StructFind(sCategoryProperties, "#ThisProp#"))>
				<cfif ThisProp IS "CategoryImageHeader">
					<cfset REQUEST.CategoryImageHeader=StructFind(sCategoryProperties, "#ThisProp#")>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfif Val(GetPage.ParentID) GT "0">
		<cfquery name="GetParentPageName" datasource="#APPLICATION.DSN#">
			SELECT	CategoryName
			FROM	t_Category
			WHERE	Categoryid=<cfqueryparam value="#Val(GetPage.ParentID)#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfset ParentCategoryName="#GetParentPageName.CategoryName#">
	</cfif>
	<cfif Trim(GetPage.CategoryURLDerived) IS NOT "">
		<cfif Left(GetPage.CategoryURLDerived,4) IS NOT "Java">
			<cflocation url="#GetPage.CategoryURLDerived#" addtoken="No">
		</cfif>
	</cfif>

	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#GetPage.CategoryID#"
		namelist="#application.utilsObj.RemoveHTML(Replace(CALLER.CurrentCategoryName,","," ","all"))#"
		idlist="#GetPage.CategoryID#"
		aliaslist="#GetPage.CategoryAlias#">
	<cfif IDList IS NOT "">
		<cfset CALLER.CategoryThreadList=IDList>
		<cfset CALLER.CategoryThreadName=NameList>
		<cfset CALLER.CategoryThreadAlias=AliasList>

		<!--- Get Category Properties --->
		<cfquery name="GetCatProps" datasource="#APPLICATION.DSN#">
			select		PropertiesPacket, CacheDateTime
			from		qry_GetCategoryProperties
			WHERE 		CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#CALLER.CategoryThreadList#" list="yes">)
			order by 	displayorder desc
		</cfquery>
		<cfoutput query="GetCatProps">
			<cfif IsWDDX(PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#PropertiesPacket#" output="sProperties">
				<!--- Properties that should inherit --->
				<cfloop index="ThisProp" list="useSSL">
					<cfif StructKeyExists(sProperties,"#ThisProp#") AND Trim(StructFind(sProperties, "#ThisProp#")) IS NOT "">
						<cfset SetVariable("CALLER.#ThisProp#",StructFind(sProperties, "#ThisProp#"))>
					</cfif>
				</cfloop>
				<!--- Properties that just come from this category --->
				<cfif CurrentRow IS "1">
					<cfloop index="ThisProp" list="AllowComments,CommentNotificationEmail">
						<cfif StructKeyExists(sProperties,"#ThisProp#") AND Trim(StructFind(sProperties, "#ThisProp#")) IS NOT "">
							<cfset SetVariable("CALLER.#ThisProp#",StructFind(sProperties, "#ThisProp#"))>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfoutput>

		<!--- if this page should be ssl, redirect --->
		<cfif structKeyExists(caller, "useSSL") and caller.useSSL and CGI.SERVER_PORT neq APPLICATION.httpsPort and APPLICATION.SSLConfigured>

			<!--- if we're redirecting to https, we want the query string, but not the "page=contentalias" - this removes it --->
			<cfset thisQueryString=trim(reReplaceNoCase(CGI.query_string, "(&)?page=[^&]*(\?(1)|&|$)", "", "all")) />

			<!--- prepend a "?" --->
			<cfif len(trim(thisQueryString))>
				<cfset thisQueryString="?" & thisQueryString />
			</cfif>

			<!--- redirect to the ssl version of this page --->
			<cflocation url="#APPLICATION.utilsObj.parseCategoryUrl(ATTRIBUTES.CategoryAlias)##thisQueryString#" addtoken="false" />
		</cfif>

		<!--- Cache date calculated from branch --->
		<cfquery name="GetMaxCacheDateTime" dbtype="query" maxrows="1">
			select MAX(CacheDateTime) as MaxCacheDateTime from GetCatProps
		</cfquery>
		<cfset CALLER.CacheDateTime=GetMaxCacheDateTime.MaxCacheDateTime>

		<!--- Get Category Locale Properties --->
		<cfquery name="GetCatProps" datasource="#APPLICATION.DSN#">
			SELECT		PropertiesPacket, ROW_NUMBER() OVER (ORDER BY displayorder desc) as RowNumber
			FROM		qry_GetCategoryLocale
			WHERE		CategoryID IN (<cfqueryparam value="#CALLER.CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">) and
						LocaleID=<cfqueryparam value="#APPLICATION.DefaultLocaleID#" cfsqltype="cf_sql_integer">
			ORDER BY	displayorder DESC
		</cfquery>
		
		<cfif CALLER.CategoryTypeID IS "80">
			<!--- This page is a repeated page page type. --->
			
			<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetPagePrime" maxrows="1">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(CALLER.CurrentSourceID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
			</cfstoredproc>

			<cfset CALLER.CurrentCategoryName=GetPagePrime.CategoryNameDerived>
			<cfset CALLER.CurrentPageTitle=GetPagePrime.CategoryNameDerived>
			<cfset CALLER.TemplateID=GetPagePrime.TemplateID>
			<cfset CALLER.CategoryTypeID=GetPagePrime.CategoryTypeID>
			<cfset CALLER.CSSID=GetPage.CategoryAlias>
			
			<!--- If this is a product page OR a repeated product page, set the product ID --->
			<cfif GetPagePrime.CategoryTypeID IS "64">
				<cfset REQUEST.ProductID="#GetPagePrime.CategoryID#">
			</cfif>
			
			<cfquery name="GetCatPropsAddtional" datasource="#APPLICATION.DSN#">
				SELECT		PropertiesPacket
				FROM		qry_GetCategoryLocale
				WHERE		CategoryID=<cfqueryparam value="#Val(CALLER.CurrentSourceID)#" cfsqltype="cf_sql_integer"> and
							LocaleID=<cfqueryparam value="#APPLICATION.DefaultLocaleID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset queryAddRow(GetCatProps,1)>
			<cfset querySetCell(GetCatProps,"PropertiesPacket", GetCatPropsAddtional.PropertiesPacket)>
			<cfset querySetCell(GetCatProps,"RowNumber", 0)>
			<cfquery name="GetCatProps" dbtype="Query">
				select * from GetCatProps order by RowNumber
			</cfquery>
			<cfif IsWDDX(GetCatPropsAddtional.PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetCatPropsAddtional.PropertiesPacket#" output="sCategoryPropertiesAdditional">
				<cfloop index="ThisProp" list="MetaDescription,MetaKeywords,PageTitleOverride,HeaderText,CSSClass2,CSSID,SuppressHeaderImage">
					<cfif StructKeyExists(sCategoryPropertiesAdditional,"#ThisProp#") AND Trim(StructFind(sCategoryPropertiesAdditional, "#ThisProp#")) IS NOT "">
						<cfset Setvariable("CALLER.#ThisProp#",StructFind(sCategoryPropertiesAdditional, "#ThisProp#"))>
					</cfif>
				</cfloop>
				<cfloop index="ThisProp" list="HeaderTextTypeID">
					<cfif StructKeyExists(sCategoryPropertiesAdditional,"#ThisProp#") AND Val(StructFind(sCategoryPropertiesAdditional, "#ThisProp#")) GT "0">
						<cfset Setvariable("CALLER.#ThisProp#",StructFind(sCategoryPropertiesAdditional, "#ThisProp#"))>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfoutput query="GetCatProps">
			<cfif IsWDDX(PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#PropertiesPacket#" output="sProperties">
				<cfif StructKeyExists(sProperties,"CategoryImageRepresentative") AND sProperties.CategoryImageRepresentative is not "" and CALLER.CategoryImageRepresentative is "">
					<cfset CALLER.CategoryImageRepresentative=sProperties.CategoryImageRepresentative>
				</cfif>
				<cfif StructKeyExists(sProperties,"CategoryImageTitle") AND sProperties.CategoryImageTitle is not "" and CALLER.CategoryImageTitle is "">
					<cfset CALLER.CategoryImageTitle=sProperties.CategoryImageTitle>
				</cfif>
				<cfif StructKeyExists(sProperties,"CategoryImageHeader") AND sProperties.CategoryImageHeader is not "" and CALLER.CategoryImageHeader is "">
					<cfset CALLER.CategoryImageHeader=sProperties.CategoryImageHeader>
					<cfset REQUEST.CategoryImageHeader=sProperties.CategoryImageHeader>
				</cfif>
				<!--- Properties that just come from this category locale --->
				<cfif CurrentRow IS "1">
					<cfloop index="ThisProp" list="CSSClass,CSSID">
						<cfif StructKeyExists(sProperties,"#ThisProp#") AND Trim(StructFind(sProperties, "#ThisProp#")) IS NOT "">
							<cfset SetVariable("CALLER.#ThisProp#",StructFind(sProperties, "#ThisProp#"))>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		</cfoutput>
	</cfif>

	
	
	<cfset CALLER.CSSClass=Trim(ListAppend(lcase(application.utilsObj.scrub(GetPage.CategoryTypeName)),"#CALLER.CSSClass#"," "))>
	<cfset REQUEST.AllowComments=CALLER.AllowComments>

	<cfloop index="ThisContentPositionID" list="#lPosition#">
		<cfset recacheThis=false>
		<cfif DenyAccess>
			<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\#APPLICATION.ApplicationName#_#LoginPageAlias#+#ThisContentPositionID#_#APPLICATION.LocaleID#_#DateFormat(LoginPageCacheDateTime,'yyyymmdd')##TimeFormat(LoginPageCacheDateTime,'HHmmss')#.cfm">
			<cfset CALLER.AllowComments="0">
			<cfset REQUEST.AllowComments="0">
		<cfelse>
			<cfif ListFind("",CALLER.CurrentCategoryID)><!--- Certain page types should always recache --->
				<cfset recacheThis=true>
			</cfif>
			<cfset ExecuteTempFile="#APPLICATION.LocaleID#\#APPLICATION.ApplicationName#_#GetPage.CategoryAlias#+#ThisContentPositionID#_#APPLICATION.LocaleID#_#DateFormat(CALLER.CacheDateTime,'yyyymmdd')##TimeFormat(CALLER.CacheDateTime,'HHmmss')#.cfm">
		</cfif>
		<cfset StructInsert(CALLER.sIncludeFile,ThisContentPositionID,"#APPLICATION.TempMapping##ExecuteTempFile#",1)>
		<cfif DenyAccess>
			<cfset CategoryIDPrime="#Val(LoginPageCategoryID)#">
		<cfelse>
			<cfif CALLER.CategoryTypeID IS "80">
				<cfset CategoryIDPrime="#Val(CALLER.CurrentSourceID)#">
			<cfelse>
				<cfset CategoryIDPrime="#Val(CALLER.CurrentCategoryID)#">
			</cfif>
		</cfif>
		<cfif CALLER.CategoryTypeID IS "64">
			<cfset CategoryThreadListPrime=ListInsertAt(CALLER.CategoryThreadList,2,"5687")>
		<cfelseif CALLER.CategoryTypeID IS "62">
			<cfset CategoryThreadListPrime=ListInsertAt(CALLER.CategoryThreadList,2,"5688")>
		<cfelse>
			<cfset CategoryThreadListPrime=CALLER.CategoryThreadList>
		</cfif>
		<cfinvoke component="#REQUEST.MyContentManager#"
			method="GetColumnContentIDList"
			returnVariable="lContentID"
			CategoryID="#CategoryIDPrime#"
			LocaleID="#APPLICATION.LocaleID#"
			ContentPositionID="#ThisContentPositionID#"
			CategoryThreadList="#CategoryThreadListPrime#">
		<cfif ListLen(lContentID) IS "0" and ListFind("62,64",CALLER.CategoryTypeID)>
			<cfif CALLER.CategoryTypeID IS "64">
				<cfset CategoryIDPrime=5687>
			<cfelseif CALLER.CategoryTypeID IS "62">
				<cfset CategoryIDPrime=5688>
			</cfif>
			<cfset CategoryThreadListPrime=ListDeleteAt(CALLER.CategoryThreadList,2)>
			<cfinvoke component="#REQUEST.MyContentManager#"
				method="GetColumnContentIDList"
				returnVariable="lContentID"
				CategoryID="#CategoryIDPrime#"
				LocaleID="#APPLICATION.LocaleID#"
				ContentPositionID="#ThisContentPositionID#"
				CategoryThreadList="#CategoryThreadListPrime#">
		</cfif>
		<cfif ListLen(lContentID) IS "0">
			<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"1",1)>
		<cfelse>
			<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"0",1)>
		</cfif>
		<cfif ListFind("401",ThisContentPositionID) and ListLen(lContentID) GT "0">
			<cfset CALLER.NoContent="0">
		</cfif>
		<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") OR REQUEST.ReCache or Val(ATTRIBUTES.PreviewSourceContentID) GT "0" or REQUEST.ContentGenerateMode IS "FLAT" OR recacheThis>
			<cfmodule template="/common/modules/ContentManager/GetColumn.cfm"
				returnVariable="FileContents"
				CategoryID="#Val(CategoryIDPrime)#"
				LocaleID="#APPLICATION.LocaleID#"
				ContentPositionID="#ThisContentPositionID#"
				CategoryThreadList="#CategoryThreadListPrime#"
				PreviewSourceContentID="#Val(ATTRIBUTES.PreviewSourceContentID)#"
				PreviewTargetContentID="#Val(ATTRIBUTES.PreviewTargetContentID)#">
			<cfif ThisContentPositionID is "401" and CALLER.NoContent IS "1">
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
					<cflocation url="#APPLICATION.utilsObj.parseCategoryUrl(GetFirstChildCategory.CategoryAlias)#" addtoken="No">
				</cfif>
				<cfset FileContents="<p>No content found.</p>">
			</cfif>
			<cfif Trim(FileContents) IS NOT "">
				<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"0",1)>
			</cfif>
			<cfif REQUEST.ContentGenerateMode IS "FLAT">
				<cfset StructInsert(CALLER.sContent,ThisContentPositionID,"#FileContents#",1)>
			<cfelse>
				<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfif CALLER.NoContent>
	<cfif REQUEST.ContentGenerateMode IS Not "FLAT">
		<cfheader
			statusCode="404"
			statusText="Not Found">
	</cfif>
	<cfset CALLER.NoContent="0">
	<cfset CALLER.AllowComments="0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetErrorPage" maxrows="1">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#APPLICATION.CategoryID404Page#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	</cfstoredproc>
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#GetPage.CategoryID#"
		namelist="#application.utilsObj.RemoveHTML(Replace(GetErrorPage.CategoryNameDerived,","," ","all"))#"
		idlist="#GetErrorPage.CategoryID#"
		aliaslist="#GetErrorPage.CategoryAlias#">
	<cfif IDList IS NOT "">
		<cfset CALLER.CategoryThreadList=IDList>
		<cfset CALLER.CategoryThreadName=NameList>
		<cfset CALLER.CategoryThreadAlias=AliasList>
	</cfif>
	<cfif IsDefined("GetErrorPage") AND GetErrorPage.RecordCount IS "1">
		<cfloop index="ThisContentPositionID" list="400,401,402">
			<cfset ExecuteTempFile="#APPLICATION.LocaleID#\#GetErrorPage.CategoryAlias#+#ThisContentPositionID#_#APPLICATION.LocaleID#_#DateFormat(GetErrorPage.CacheDateTime,'yyyymmdd')##TimeFormat(GetErrorPage.CacheDateTime,'HHmmss')#.cfm">
			<cfset StructInsert(CALLER.sIncludeFile,ThisContentPositionID,"#APPLICATION.TempMapping##ExecuteTempFile#",1)>
			<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"0",1)>
			<cfinvoke component="#REQUEST.MyContentManager#"
				method="GetColumnContentIDList"
				returnVariable="lContentID"
				CategoryID="#APPLICATION.CategoryID404Page#"
				LocaleID="#APPLICATION.LocaleID#"
				ContentPositionID="#ThisContentPositionID#"
				CategoryThreadList="">
			<cfif ListLen(lContentID) IS "0">
				<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"1",1)>
			<cfelse>
				<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"0",1)>
			</cfif>
			<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") OR REQUEST.ReCache or REQUEST.ContentGenerateMode IS "FLAT">
				<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
					<cfprocresult name="GetContentList">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#APPLICATION.CategoryID404Page#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="#Val(ThisContentPositionID)#" null="No">
					<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
				</cfstoredproc>
				<cfset FileContents="">
				<cfoutput query="GetContentList" group="ContentLocaleID">
					<cfif IsWDDX(ContentBody)>
						<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
					<cfelse>
						<cfset sContentBody=StructNew()>
					</cfif>
					<cfmodule template="/common/modules/ContentManager/GetColumn.cfm"
						returnVariable="FileContents"
						CategoryID="#Val(APPLICATION.CategoryID404Page)#"
						LocaleID="#APPLICATION.LocaleID#"
						ContentPositionID="#ThisContentPositionID#"
						CategoryThreadList="#CALLER.CategoryThreadList#">
				</cfoutput>

				<cfif Trim(FileContents) IS NOT "">
					<cfset StructInsert(CALLER.sIncludeFileBlank,ThisContentPositionID,"0",1)>
				</cfif>
				<cfif REQUEST.ContentGenerateMode IS "FLAT">
					<cfset StructInsert(CALLER.sContent,ThisContentPositionID,"#FileContents#",1)>
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
<cfset REQUEST.CurrentCategoryName=CALLER.CurrentCategoryName>
