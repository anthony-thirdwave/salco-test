<cfsetting requesttimeout="3000" ShowDebugOutput="0">

<cfparam name="SourceTopLevelCategoryID" default="#APPLICATION.defaultSiteCategoryID#">
<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
    select LocaleID,LocaleCode,LanguageID,LabelName As LanguageName from
	t_Locale LEFT OUTER JOIN
	t_Label ON t_Locale.LanguageID=t_Label.LabelID
    order by LocaleID
</cfquery>
<cfquery name="GetParentDisplayOrder" datasource="#APPLICATION.DSN#">
    select DisplayOrder from t_category Where CategoryID=<cfqueryparam value="#SourceTopLevelCategoryID#" cfsqltype="cf_sql_integer">
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
        select DisplayOrder from t_Category Where CategoryID=<cfqueryparam value="#Val(ThisTopCategoryID)#" cfsqltype="cf_sql_integer">
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
			<cfoutput>processing #GetCats.CategoryNameDerived#<br></cfoutput>
			<cfif GetCats.CategoryActive IS "0">
				<cfset lCategoryNotActive=ListAppend(lCategoryNotActive,Val(GetCats.CategoryID))>
			<cfelseif ListFindNoCase(lCategoryNotActive,GetCats.ParentID)>
				<cfset lCategoryNotActive=ListAppend(lCategoryNotActive,Val(GetCats.CategoryID))>
			<cfelseif GetCats.ParentID IS "5731"><!--- Orphan Products --->
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
	            <cfset Body="#GetCats.CategoryNameDerived# #GetCats.CategoryName# #GetCats.CategoryLocalePropertiesPacket#">
				<cfset ThisCategory="SiteContent">
				<cfset Custom1=""><!--- Description --->
				<cfset Custom2=""><!--- CategoryImageHeader --->
				<cfset Custom3=""><!--- Part No --->
				<cfset Custom4="#GetCats.CategoryTypeID#">
	
	            <cfif GetCats.CategoryTypeID IS "64"><!--- Product --->
	                <cfquery name="GetProductProps" datasource="#APPLICATION.DSN#">
	                    select * from t_ProductAttribute WHERE CategoryID=<cfqueryparam value="#Val(GetCats.CategoryID)#" cfsqltype="cf_sql_integer"> 
						And LanguageID=<cfqueryparam value="#Val(slanguageID[ThisLocaleID])#" cfsqltype="cf_sql_integer">
	                    AND AttributeValue <> <cfqueryparam value="" cfsqltype="cf_sql_varchar">
					</cfquery>
	                <cfoutput query="GetProductProps">
	                    <cfif Trim(AttributeValue) IS NOT "">
	                        <cfset Body="#Body# #Trim(AttributeValue)#">
	                    </cfif>
	                </cfoutput>
	                <cfquery name="GetProductProps2" datasource="#APPLICATION.DSN#">
	                    select * from qry_GetTextBlock WHERE Entity=<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar"> and 
						KeyID=<cfqueryparam value="#Val(GetCats.CategoryID)#" cfsqltype="cf_sql_integer"> And 
						LanguageID=<cfqueryparam value="#Val(slanguageID[ThisLocaleID])#" cfsqltype="cf_sql_integer">
	                </cfquery>
	                <cfoutput query="GetProductProps2">
	                    <cfif Trim(TextBlock) IS NOT "">
	                        <cfset Body="#Body# #Trim(TextBlock)#">
	                    </cfif>
	                </cfoutput>
					
					<cfquery name="GetDescription" dbtype="query">
	                    select * from GetProductProps
						where ProductFamilyAttributeID=<cfqueryparam value="7" cfsqltype="cf_sql_integer">
	                </cfquery>
					
					<cfif GetDescription.AttributeValue IS NOT ""><!--- Product Description --->
						<cfset Custom1="#GetDescription.AttributeValue#">
					</cfif>
					
					<cfquery name="GetProductNumber" dbtype="query">
	                    select * from GetProductProps
						where ProductFamilyAttributeID=<cfqueryparam value="10" cfsqltype="cf_sql_integer">
	                </cfquery>
					
					<cfif GetProductNumber.AttributeValue IS NOT ""><!--- Product Description --->
						<cfset Custom3="#GetProductNumber.AttributeValue#">
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
	                    select * from t_ProductAttribute WHERE CategoryID=<cfqueryparam value="#Val(GetCats.CategoryID)#" cfsqltype="cf_sql_integer"> And
						LanguageID=<cfqueryparam value="#Val(slanguageID[ThisLocaleID])#" cfsqltype="cf_sql_integer"> AND 
						AttributeValue <> <cfqueryparam value="" cfsqltype="cf_sql_varchar">
	                </cfquery>
	                <cfoutput query="GetProductProps">
	                    <cfif Trim(AttributeValue) IS NOT "">
	                        <cfset Body="#Body# #Trim(AttributeValue)#">
	                    </cfif>
	                </cfoutput>
	                <cfquery name="GetProductProps2" datasource="#APPLICATION.DSN#">
	                    select * from qry_GetTextBlock WHERE Entity=<cfqueryparam value="t_Category" cfsqltype="cf_sql_varchar"> and 
						KeyID=<cfqueryparam value="#Val(GetCats.CategoryID)#" cfsqltype="cf_sql_integer"> And 
						LanguageID=<cfqueryparam value="#Val(slanguageID[ThisLocaleID])#" cfsqltype="cf_sql_integer">
	                </cfquery>
	                <cfoutput query="GetProductProps2">
	                    <cfif Trim(TextBlock) IS NOT "">
	                        <cfset Body="#Body# #Trim(TextBlock)#">
	                    </cfif>
	                </cfoutput>
					
					<cfquery name="GetDescription" dbtype="query">
	                    select * from GetProductProps
						where ProductFamilyAttributeID=<cfqueryparam value="18" cfsqltype="cf_sql_integer">
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
				
	            <cfquery name="GetPropertiesPacket" datasource="#APPLICATION.DSN#">
	                select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(GetCats.categoryPropertiesID)#" cfsqltype="cf_sql_integer">
	            </cfquery>
	            <cfset Body="#Body# #GetpropertiesPacket.PropertiesPacket#">
	
				 <cfif IsWddx(GetCats.CategoryLocalePropertiesPacket)>
                    <cfwddx action="WDDX2CFML" input="#GetCats.CategoryLocalePropertiesPacket#" output="sContentLocalePropertiesPacket">

                    <cfif StructKeyExists(sContentLocalePropertiesPacket,"CategoryImageHeader") and sContentLocalePropertiesPacket.CategoryImageHeader IS NOT "">
                        <cfset Custom2="#sContentLocalePropertiesPacket.CategoryImageHeader#">
                    </cfif>
                </cfif>
				
	            <cfoutput query="GetContentList">
	                <cfset Body="#Body# #ContentName# #ContentNameDerived# #ContentBody#">
	                <cfquery name="GetpropertiesPacket2" datasource="#APPLICATION.DSN#">
	                    select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(ContentPropertiesID)#" cfsqltype="cf_sql_integer">
	                </cfquery>
	                <cfset Body="#Body# #GetpropertiesPacket2.PropertiesPacket#">
					
					<cfif 0>
		                <cfquery name="GetpropertiesPacket3" datasource="#APPLICATION.DSN#">
		                    select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(ContentLocalePropertiesID)#" cfsqltype="cf_sql_integer">
		                </cfquery>
		
		                <cfset Body="#Body# #GetpropertiesPacket3.PropertiesPacket#">
			            <cfif IsWddx(GetpropertiesPacket3.PropertiesPacket)>
		                    <cfwddx action="WDDX2CFML" input="#GetpropertiesPacket3.PropertiesPacket#" output="sContentLocalePropertiesPacket">
		
		                    <cfif StructKeyExists(sContentLocalePropertiesPacket,"ContentPreview")>
		                        <cfset Custom1="#Custom1# #sContentLocalePropertiesPacket.ContentPreview#">
		                    </cfif>
		                </cfif>
					</cfif>
	            </cfoutput>
	
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
	            <cfset QuerySetCell(qVerity, "Custom3", Custom3)>
	            <cfset QuerySetCell(qVerity, "Custom4", Custom4)>
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
		<cfdump var="#ThisCollectionName#">
		<!--- <cfdump var="#qVerity#" expand="false" label="qVerity"> --->
    </cfloop>
</cfloop>



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


