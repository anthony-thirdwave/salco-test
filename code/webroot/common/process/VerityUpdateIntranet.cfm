<cfsetting requesttimeout="300">
<cfparam name="SourceTopLevelCategoryID" default="#APPLICATION.intranetSiteCategoryID#">

<cfparam name="lIntranetSlideShowCategoryAlias" default="">

<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
	select LocaleID,LocaleCode,LanguageID,LabelName As LanguageName from
	t_Locale LEFT OUTER JOIN
	t_Label ON t_Locale.LanguageID=t_Label.LabelID
	order by LocaleID
</cfquery>

<cfset sLocaleCode=StructNew()>
<cfoutput query="GetLocales">
	<cfset StructInsert(sLocaleCode,LocaleID,LocaleCode)>
</cfoutput>
<cfset slanguageID=StructNew()>
<cfoutput query="GetLocales">
	<cfset StructInsert(slanguageID,LocaleID,LanguageID)>
</cfoutput>
<cfset slanguageName=StructNew()>
<cfoutput query="GetLocales">
	<cfset StructInsert(slanguageName,LocaleID,LanguageName)>
</cfoutput>

<cfloop index="ThisTopCategoryID" list="#SourceTopLevelCategoryID#">
	<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
		select DisplayOrder from t_Category Where CategoryID=<cfqueryparam value="#Val(ThisTopCategoryID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfloop index="ThisLocaleID" list="#ValueList(GetLocales.LocaleID)#">
			<cfset ThisCollectionName="#application.collectionname##THisLocaleID#_intranet">
		<cfoutput><p>Creating collection #APPLICATION.CollectionPath##ThisCollectionName#...</p></cfoutput>
		<cftry>
		<!--- <cfcollection action="CREATE" collection="#ThisCollectionName#" path="#APPLICATION.CollectionPath#" language="#slanguageName[ThisLocaleID]#"> --->
			<cfcollection
				action="CREATE"
				engine="solr"
				collection="#ThisCollectionName#"
				path="#APPLICATION.CollectionPath#"
				categories="true"
				language="english">Done...
			<cfcatch><cfoutput><p>Collection #ThisCollectionName# already exists</p></cfoutput></cfcatch>
		</cftry>
		Purging <cfoutput>#ThisCollectionName#</cfoutput>....<br/>
		<cfindex action="PURGE" collection="#ThisCollectionName#">

		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetCats">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ThisLocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="#GetDisplayOrder.DisplayOrder#" null="no">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		</cfstoredproc>

		<cfdump var="#getCats#" label="getCats" expand="false">


		<cfset qVerity=QueryNew("Key,Title,Body,Custom1,Custom2,Custom3,Custom4,Category,CategoryTree,UrlPath")>


		<cfloop query="GetCats">
			<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetContentList">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ThisLocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetCats.CategoryID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="401" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
			</cfstoredproc>

			<cfset Key="#GetCats.CategoryID#">
			<cfset Title="#GetCats.CategoryNameDerived#">
			<cfset UrlPath="#APPLICATION.utilsObj.parseCategoryUrl(getCats.CategoryAlias)#">
			<cfset Custom2="#GetCats.CategoryTypeID#">
			<cfset Body="#GetCats.CategoryNameDerived# #GetCats.CategoryName# #application.utilsObj.RemoveHTML(GetCats.CategoryLocalePropertiesPacket)#">

			<cfset Keywords="">

			<cfif isWddx(GetCats.CategoryLocalePropertiesPacket)>
				<cfwddx action="wddx2cfml"
					input="#GetCats.CategoryLocalePropertiesPacket#"
					output="categoryLocaleProperties">

				<cfif structKeyExists(categoryLocaleProperties,"metakeywords")>
					<cfset counter=1>
					<!--- gotta do it like this so there are no spaces in the list --->
					<cfloop list="#categoryLocaleProperties.metakeywords#" index="k" delimiters="," >
						<!---  <cfset Keywords=listAppend(Keywords,lcase(k),",")> --->
						<cfset Keywords=Keywords & lcase(trim(k))>
						<cfif counter lt listlen(categoryLocaleProperties.metakeywords,",")>
							<cfset Keywords=Keywords & ",">
						</cfif>
						<cfset counter++>
					</cfloop>
				</cfif>
				
				<cfif structKeyExists(categoryLocaleProperties,"IncludeInScreenSaver") and Val(categoryLocaleProperties.IncludeInScreenSaver)>
					<cfset lIntranetSlideShowCategoryAlias=ListAppend(lIntranetSlideShowCategoryAlias,GetCats.CategoryAlias)>
				</cfif>
				
			</cfif>

			<cfquery name="GetpropertiesPacket" datasource="#APPLICATION.DSN#">
				select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(GetCats.categoryPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset Body="#Body# #application.utilsObj.RemoveHTML(GetpropertiesPacket.PropertiesPacket)#">


			<cfset Custom1="">
			<cfoutput query="GetContentList">
				<cfset Body="#Body# #ContentName# #ContentNameDerived# #application.utilsObj.RemoveHTML(ContentBody)#">
				<cfquery name="GetpropertiesPacket2" datasource="#APPLICATION.DSN#">
					select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(ContentPropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset Body="#Body# #application.utilsObj.RemoveHTML(GetpropertiesPacket2.PropertiesPacket)#">

				<cfquery name="GetpropertiesPacket3" datasource="#APPLICATION.DSN#">
					select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(ContentLocalePropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfset Body="#Body# #application.utilsObj.RemoveHTML(GetpropertiesPacket3.PropertiesPacket)#">
				<cfif IsWddx(GetpropertiesPacket3.PropertiesPacket)>
					<cfwddx action="WDDX2CFML" input="#GetpropertiesPacket3.PropertiesPacket#" output="sContentLocalePropertiesPacket">

					<cfif StructKeyExists(sContentLocalePropertiesPacket,"ContentPreview")>
						<cfset Custom1="#Custom1# #sContentLocalePropertiesPacket.ContentPreview#">
					</cfif>
					
					<cfif Trim(Custom1) IS "" and IsWDDX(ContentBody)>
						<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
						<cfif StructKeyExists(sContentBody,"sHTML") and StructKeyExists(sContentBody.sHTML,"Column1") and sContentBody.sHTML["Column1"].Value IS NOT "">
							<cfset Custom1=APPLICATION.utilsObj.RemoveHTML(sContentBody.sHTML["Column1"].Value)>
						</cfif>
					</cfif>
				</cfif>
			</cfoutput>

			<cfset Category="">
			<cfif 0><!--- find the taxonomy for this category, if any --->
				<cftry>
					<cfquery name="getTaxonomy" datasource="#APPLICATION.dsn#">
						SELECT lower(dbo.fn_getTopicEntityNameHierarchyList(c.categoryId)) as topicPath
						  FROM t_category c
						  JOIN t_topicEntity te ON c.categoryId=te.topicId
						 WHERE te.entityId=<cfqueryparam value="#key#" cfsqltype="cf_sql_integer">
							AND te.entityName=<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfset Category=valuelist(getTaxonomy.topicPath,",")>
					<cfcatch>
						<cfset Category="">
					</cfcatch>
				</cftry>
			</cfif>
			
			<cfset CategoryNameList="">
			<cfset CategoryTree="">


			<cfset QueryAddRow(qVerity,1)>
			<cfset QuerySetCell(qVerity, "Key", Key)>
			<cfset QuerySetCell(qVerity, "Title", Title)>
			<cfset QuerySetCell(qVerity, "Body", Body)>
			<cfset QuerySetCell(qVerity, "Custom1", Custom1)>
			<cfset QuerySetCell(qVerity, "Custom2", Custom2)>
			<cfset QuerySetCell(qVerity, "Custom3", Category)>
			<cfset QuerySetCell(qVerity, "Custom4", CategoryNameList)>
			<cfset QuerySetCell(qVerity, "Category", Keywords)>
			<cfset QuerySetCell(qVerity, "CategoryTree",CategoryTree)>
			<cfset QuerySetCell(qVerity, "UrlPath", UrlPath)>
		</cfloop>

		<cfindex action="UPDATE" collection="#ThisCollectionName#"
			key="Key"
			type="CUSTOM"
			title="Title"
			query="qVerity"
			body="Body"
			custom1="Custom1"
			custom2="Custom2"
			custom3="Custom3"
			custom4="Custom4"
			urlpath="UrlPath"
			category="Category"
			categorytree="CategoryTree">
	</cfloop>
</cfloop>

<cfdump var="#qVerity#" expand="false" label="qVerity">

<!--- after the update runs, drop the tagCloud, which will be recreated when called again --->
<cfif structKeyExists(APPLICATION,"tagCloud")>
	<cfset temp=structdelete(APPLICATION,"tagCloud")>
</cfif>

<cfif lIntranetSlideShowCategoryAlias IS NOT "">
	<cfoutput>
		<cfsavecontent variable="JSContents">
			var SlideShow=new Array;
			<cfloop index="i" from="1" to="#ListLen(lIntranetSlideShowCategoryAlias)#">
				SlideShow[#i-1#]="#ListGetAt(lIntranetSlideShowCategoryAlias,i)#";
			</cfloop>
		</cfsavecontent>
	</cfoutput>
	<cffile action="WRITE" file="#ExpandPath('/common/scripts/intranetSlideShow.js')#" output="#JSContents#" addnewline="Yes">
</cfif>