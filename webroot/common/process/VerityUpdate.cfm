<cfsetting requesttimeout="3000" showdebugoutput="No">

<cfparam name="SourceTopLevelCategoryID" default="#APPLICATION.defaultSiteCategoryID#">
<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
    select LocaleID,LocaleCode,LanguageID,LabelName As LanguageName from
	t_Locale LEFT OUTER JOIN
	t_Label ON t_Locale.LanguageID=t_Label.LabelID
    order by LocaleID
</cfquery>
<cfquery name="GetParentDisplayOrder" datasource="#APPLICATION.DSN#">
    select DisplayOrder from t_category Where CategoryID=#SourceTopLevelCategoryID#
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

<cfset lSiteID="#SourceTopLevelCategoryID#">

<cfset lCategoryNotActive="">

<cfinvoke component="/com/product/producthandler" 
	method="GetTopProductFamily" 
	returnVariable="qGetTopProductFamily">
	
<cfloop index="ThisTopCategoryID" list="#lSiteID#">
    <cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
        select DisplayOrder from t_Category Where CategoryID=#Val(ThisTopCategoryID)#
    </cfquery>
    <cfloop index="ThisLocaleID" list="#ValueList(GetLocales.LocaleID)#">
        <cfset ThisCollectionName="#application.collectionname##ThisLocaleID#">
        <cfoutput><p>Creating collection #APPLICATION.CollectionPath##ThisCollectionName#...</p></cfoutput>
        <cftry>
            <cfcollection
                action="CREATE"
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
            <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="" null="Yes">
            <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
            <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
            <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
            <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
            <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
        </cfstoredproc>

        <cfset qVerity=QueryNew("Key,Title,Body,Custom1,Custom2,Custom3,Custom4,Category,CategoryTree,UrlPath")>

        <cfloop query="GetCats">
			<cfif GetCats.CategoryActive IS "0">
				<cfset lCategoryNotActive=ListAppend(lCategoryNotActive,Val(GetCats.CategoryID))>
			<cfelseif ListFindNoCase(lCategoryNotActive,GetCats.ParentID)>
				<cfset lCategoryNotActive=ListAppend(lCategoryNotActive,Val(GetCats.CategoryID))>
			<cfelse>
	            <cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
	                <cfprocresult name="GetContentList">
	                <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ThisLocaleID#" null="No">
	                <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetCats.CategoryID)#" null="No">
	                <cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="401" null="No">
	                <cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
	            </cfstoredproc>
	
	            <cfset Key="#GetCats.CategoryID#">
	            <cfset Title="#GetCats.CategoryNameDerived#">
	            <cfset UrlPath=getCats.CategoryAlias>
	            <cfset Custom2="#GetCats.CategoryTypeID#">
	            <cfset Body="#GetCats.CategoryNameDerived# #GetCats.CategoryName# #GetCats.CategoryLocalePropertiesPacket#">
				<cfset ThisCategory="SiteContent">
				<cfset Custom1="">
	
	            <cfif GetCats.CategoryTypeID IS "64"><!--- Product --->
	                <cfquery name="GetProductProps" datasource="#APPLICATION.DSN#">
	                    select * from t_ProductAttribute WHERE CategoryID=#Val(GetCats.CategoryID)# And LanguageID=#Val(slanguageID[THisLocaleID])#
	                    AND AttributeValue <> ''
	                </cfquery>
	                <cfoutput query="GetProductProps">
	                    <cfif Trim(AttributeValue) IS NOT "">
	                        <cfset Body="#Body# #Trim(AttributeValue)#">
	                    </cfif>
	                </cfoutput>
	                <cfquery name="GetProductProps2" datasource="#APPLICATION.DSN#">
	                    select * from qry_GetTextBlock WHERE Entity='t_Category' and KeyID=#Val(GetCats.CategoryID)# And LanguageID=#Val(slanguageID[THisLocaleID])#
	                </cfquery>
	                <cfoutput query="GetProductProps2">
	                    <cfif Trim(TextBlock) IS NOT "">
	                        <cfset Body="#Body# #Trim(TextBlock)#">
	                    </cfif>
	                </cfoutput>
					
					<cfquery name="GetDescription" dbtype="query">
	                    select * from GetProductProps
						where ProductFamilyAttributeID=7
	                </cfquery>
					
					<cfif GetDescription.AttributeValue IS NOT "">
						<cfset Custom1="#GetDescription.AttributeValue#">
					</cfif>
					
					<cfset ThisCategory="Product">
					<cfloop query="qGetTopProductFamily">
						<cfif Left(GetCats.DisplayOrder,Len(qGetTopProductFamily.DisplayOrder)) IS qGetTopProductFamily.DisplayOrder>
							<cfset ThisCategory="Product-#qGetTopProductFamily.CategoryAlias#">
						</cfif>
					</cfloop>
	            </cfif>
				
				<cfif GetCats.CategoryTypeID IS "62"><!--- Product -Family--->
	                <cfquery name="GetProductProps" datasource="#APPLICATION.DSN#">
	                    select * from t_ProductAttribute WHERE CategoryID=#Val(GetCats.CategoryID)# And LanguageID=#Val(slanguageID[THisLocaleID])#
	                    AND AttributeValue <> ''
	                </cfquery>
	                <cfoutput query="GetProductProps">
	                    <cfif Trim(AttributeValue) IS NOT "">
	                        <cfset Body="#Body# #Trim(AttributeValue)#">
	                    </cfif>
	                </cfoutput>
	                <cfquery name="GetProductProps2" datasource="#APPLICATION.DSN#">
	                    select * from qry_GetTextBlock WHERE Entity='t_Category' and KeyID=#Val(GetCats.CategoryID)# And LanguageID=#Val(slanguageID[THisLocaleID])#
	                </cfquery>
	                <cfoutput query="GetProductProps2">
	                    <cfif Trim(TextBlock) IS NOT "">
	                        <cfset Body="#Body# #Trim(TextBlock)#">
	                    </cfif>
	                </cfoutput>
					
					<cfquery name="GetDescription" dbtype="query">
	                    select * from GetProductProps
						where ProductFamilyAttributeID=18
	                </cfquery>
					
					<cfif GetDescription.AttributeValue IS NOT "">
						<cfset Custom1="#GetDescription.AttributeValue#">
					</cfif>
					
					<cfset ThisCategory="Product">
					<cfloop query="qGetTopProductFamily">
						<cfif Left(GetCats.DisplayOrder,Len(qGetTopProductFamily.DisplayOrder)) IS qGetTopProductFamily.DisplayOrder>
							<cfset ThisCategory="Product-#qGetTopProductFamily.CategoryAlias#">
						</cfif>
					</cfloop>
	            </cfif>
				
	            <cfquery name="GetpropertiesPacket" datasource="#APPLICATION.DSN#">
	                select * from t_Properties Where PropertiesID=#Val(GetCats.categoryPropertiesID)#
	            </cfquery>
	            <cfset Body="#Body# #GetpropertiesPacket.PropertiesPacket#">
	
	            <cfoutput query="GetContentList">
	                <cfset Body="#Body# #ContentName# #ContentNameDerived# #ContentBody#">
	                <cfquery name="GetpropertiesPacket2" datasource="#APPLICATION.DSN#">
	                    select * from t_Properties Where PropertiesID=#Val(ContentPropertiesID)#
	                </cfquery>
	                <cfset Body="#Body# #GetpropertiesPacket2.PropertiesPacket#">
	
	                <cfquery name="GetpropertiesPacket3" datasource="#APPLICATION.DSN#">
	                    select * from t_Properties Where PropertiesID=#Val(ContentLocalePropertiesID)#
	                </cfquery>
	
	                <cfset Body="#Body# #GetpropertiesPacket3.PropertiesPacket#">
	                <cfif IsWddx(GetpropertiesPacket3.PropertiesPacket)>
	                    <cfwddx action="WDDX2CFML" input="#GetpropertiesPacket3.PropertiesPacket#" output="sContentLocalePropertiesPacket">
	
	                    <cfif StructKeyExists(sContentLocalePropertiesPacket,"ContentPreview")>
	                        <cfset Custom1="#Custom1# #sContentLocalePropertiesPacket.ContentPreview#">
	                    </cfif>
	                </cfif>
	            </cfoutput>
	
	
	            <!--- find the taxonomy for this category, if any --->
	
				<cftry>
		            <cfquery name="getTaxonomy" datasource="#APPLICATION.dsn#">
		                SELECT lower(dbo.fn_getTopicEntityNameHierarchyList(c.categoryId)) as topicPath
		                  FROM t_category c
		                  JOIN t_topicEntity te ON c.categoryId=te.topicId
		                 WHERE te.entityId=<cfqueryparam value="#key#" cfsqltype="cf_sql_integer">
		                   AND te.entityName=<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar">
		            </cfquery>
	                <cfset Topic=valuelist(getTaxonomy.topicPath,",")>
					<cfcatch>
						<cfset Topic="">
					</cfcatch>
				</cftry>
	
	            <!--- <cfif len(taxonomyCategory)>
	             <cfset Category=listAppend(Category,taxonomyCategory,",")>
	            </cfif>  --->
	
	            <cfquery name="getCategoryNameTree" datasource="#APPLICATION.dsn#">
	                select dbo.fn_getCategoryNameHierarchyList(<cfqueryparam value="#GetCats.CategoryID#" cfsqltype="cf_sql_integer">) as categoryNameTree
	            </cfquery>
	
	            <cfset CategoryNameList=getCategoryNameTree.categoryNameTree>
	
	            <cfquery name="getCategoryAliasTree" datasource="#APPLICATION.dsn#">
	                select dbo.fn_getCategoryAliasHierarchyList(<cfqueryparam value="#GetCats.CategoryID#" cfsqltype="cf_sql_integer">) as categoryAliasTree
	            </cfquery>
	
	            <cfset CategoryTree=getCategoryAliasTree.categoryAliasTree>
	
	
	            <cfset QueryAddRow(qVerity,1)>
	            <cfset QuerySetCell(qVerity, "Key", Key)>
	            <cfset QuerySetCell(qVerity, "Title", Title)>
	            <cfset QuerySetCell(qVerity, "Body", Body)>
	            <cfset QuerySetCell(qVerity, "Custom1", Custom1)>
	            <cfset QuerySetCell(qVerity, "Custom2", Custom2)>
	            <cfset QuerySetCell(qVerity, "Custom3", Topic)>
	            <cfset QuerySetCell(qVerity, "Custom4", CategoryNameList)>
	            <cfset QuerySetCell(qVerity, "Category", ThisCategory)>
	            <cfset QuerySetCell(qVerity, "CategoryTree",CategoryTree)>
	            <cfset QuerySetCell(qVerity, "UrlPath", UrlPath)>
			</cfif>
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

<!--<cfdump var="#qVerity#" expand="false" label="qVerity">--->

<!--- after the update runs, drop the tagCloud, which will be recreated when called again --->
<cfif structKeyExists(APPLICATION,"tagCloud")>
    <cfset temp=structdelete(APPLICATION,"tagCloud")>
</cfif>

<!---
<cfquery name="getThis" dbtype="query">
    SELECT *
      FROM qVerity
     WHERE [key]=19
</cfquery>

<cfdump var="#getThis#"> --->

