<cfparam name="SourceTopLevelCategoryID" default="451">
<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
	select LocaleID,LocaleCode,LanguageID,LabelName As LanguageName from 
	 t_Locale LEFT OUTER JOIN
                  t_Label ON t_Locale.LanguageID = t_Label.LabelID
	
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

<cfset lSiteID="451,524,607">

<cfloop index="ThisTopCategoryID" list="#lSiteID#">
	<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
		select DisplayOrder from t_Category Where CategoryID=#Val(ThisTopCategoryID)#
	</cfquery>
	<cfloop index="ThisLocaleID" list="#ValueList(GetLocales.LocaleID)#">
		<cfset ThisCollectionName="#application.collectionname##THisLocaleID#">
		<cfoutput><p>Creating collection #APPLICATION.CollectionPath##ThisCollectionName#...</p></cfoutput>
		<cftry>
		<!--- <cfcollection action="CREATE" collection="#ThisCollectionName#" path="#APPLICATION.CollectionPath#" language="#slanguageName[ThisLocaleID]#"> --->
			
			<!--- as of CF8 categories="true" and language="englishx" don't work together,
			      so you need to pick one per the needs of the app --->
			
			<cfcollection 
				action="CREATE" 
				collection="#ThisCollectionName#" 
				path="#APPLICATION.CollectionPath#" 
				categories="true"
				language="english">Done...
			<cfcatch><cfoutput><p>Collection #ThisCollectionName# already exists</p></cfoutput></cfcatch>
		</cftry>
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
		<cfset qVerity=QueryNew("Key,Title,Body,Custom1,Custom2")>
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
			<cfset Custom2="#GetCats.CategoryTypeID#">
			<cfset Body="#GetCats.CategoryNameDerived# #GetCats.CategoryName# #GetCats.CategoryLocalePropertiesPacket#">
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
			</cfif>
			<cfquery name="GetpropertiesPacket" datasource="#APPLICATION.DSN#">
				select * from t_Properties Where PropertiesID=#Val(GetCats.categoryPropertiesID)#
			</cfquery>
			<cfset Body="#Body# #GetpropertiesPacket.PropertiesPacket#">
			<cfset Custom1="">
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
			<cfset QueryAddRow(qVerity,1)>
			<cfset QuerySetCell(qVerity, "Key", Key)>
			<cfset QuerySetCell(qVerity, "Title", Title)>
			<cfset QuerySetCell(qVerity, "Body", Body)>
			<cfset QuerySetCell(qVerity, "Custom1", Custom1)>
			<cfset QuerySetCell(qVerity, "Custom2", Custom2)>
		</cfloop>
		<cfindex action="UPDATE" collection="#ThisCollectionName#" 
			key="Key" 
			type="CUSTOM" 
			title="Title" 
			query="qVerity" 
			body="Body"
			custom1="Custom1"
			custom2="Custom2">
	</cfloop>
</cfloop>
