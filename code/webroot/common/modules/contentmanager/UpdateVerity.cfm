<cfsilent>
<!--- update verity module --->
<cfparam name="attributes.ContentID" default=""/>
<cfparam name="attributes.LocaleID" default=""/>
<cfparam name="attributes.ContentLocaleID" default=""/>

<!--- get Locale Information --->
<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
	select LocaleID,LocaleCode,LanguageID,LabelName As LanguageName from 
	 t_Locale LEFT OUTER JOIN
                  t_Label ON t_Locale.LanguageID = t_Label.LabelID
	WHERE LocaleID = #attributes.LocaleID#
	order by LocaleID
</cfquery>
<!--- set our localecodes structure --->
<cfset sLocaleCode=StructNew()/>
<!--- spool out our locales - should only be one --->
<cfoutput query="GetLocales">
	<cfset StructInsert(sLocaleCode,LocaleID,LocaleCode)>
</cfoutput>
<!--- set language structure --->
<cfset slanguageID=StructNew()/>
<!--- spool out our locales - should only be one --->
<cfoutput query="GetLocales">
	<cfset StructInsert(slanguageID,LocaleID,LanguageID)/>
</cfoutput>
<!--- set language structure --->
<cfset slanguageName=StructNew()/>
<!--- spool out our locales - should only be one --->
<cfoutput query="GetLocales">
	<cfset StructInsert(slanguageName,LocaleID,LanguageName)/>
</cfoutput>
<!--- need to get categoryid --->
<cfinvoke component="com.ContentManager.ContentHandler"
	method="GetCategoryID"
	ContentID="#attributes.ContentID#"
	returnvariable="ThisCategoryID"/>

<!--- now lopp through the locales - again should only be one --->
<cfloop index="ThisLocaleID" list="#ValueList(GetLocales.LocaleID)#">
	<!--- set the collection to update --->
	<cfset ThisCollectionName="#Application.CollectionName##ThisLocaleID#"/>
	<cfoutput>
		Creating collection #ThisCollectionName#...
	</cfoutput>
	<cftry>
		<!--- attempt to create the collection, will error if it already exists, easy way to check for collections --->
		<cfcollection action="CREATE" collection="#ThisCollectionName#" path="#APPLICATION.CollectionPath#" language="English">Done...
		<cfcatch> <!--- collection already exists --->
			<cfoutput>
				Collection #ThisCollectionName# already exists
			</cfoutput>
		</cfcatch>
	</cftry> <!--- end check for existing collection --->
	
	<!--- this procedure gets the pages that need updated, this process however only needs one  --->
	<!--- perhaps use sp_GetPage instead as we will only be doing one 
		categoryID and loacaleID --->

		
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetCats">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#ThisCategoryID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#Attributes.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="no">
	</cfstoredproc>
	<cfdump var="#GetCats#"/>
	<!--- create the new query to use in the indexing process --->
	<cfset qVerity=QueryNew("Key,Title,Body,Custom1,Custom2")>
	<!--- iterate through the results of the stored proc, should only be one --->
	<cfloop query="GetCats">
		<cfset Key="#GetCats.CategoryID#"/>
		<cfset Title="#GetCats.CategoryNameDerived#"/>
		<cfset Custom2="#GetCats.CategoryTypeID#"/>
		<cfset Body="#GetCats.CategoryNameDerived# #GetCats.CategoryName# #GetCats.CategoryLocalePropertiesPacket#"/>
		<cfif GetCats.CategoryTypeID IS "64"><!--- Product --->
			<cfquery name="GetProductProps" datasource="#APPLICATION.DSN#">
				select * from t_ProductAttribute WHERE CategoryID=#Val(GetCats.CategoryID)# And LanguageID=#Val(slanguageID[THisLocaleID])# 
				AND AttributeValue <> ''
			</cfquery>
			<cfoutput query="GetProductProps">
				<cfif Trim(AttributeValue) IS NOT "">
					<cfset Body="#Body# #Trim(AttributeValue)#"/>
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
		</cfif> <!--- product --->
		<!--- get properties --->
		<cfquery name="GetpropertiesPacket" datasource="#APPLICATION.DSN#">
			select * from t_Properties Where PropertiesID=#Val(GetCats.categoryPropertiesID)#
		</cfquery>
		<!--- set the body for this indexing --->
		<cfset Body="#Body# #GetpropertiesPacket.PropertiesPacket#"/>
		<cfset Custom1=""/>
		<!--- I think we can use get Conetent here rather than get contents --->
		<cfstoredproc procedure="sp_GetContentsNoPosition" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetContentList">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ThisLocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(GetCats.CategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
		</cfstoredproc>
		<cfdump var="#GetContentList#"/>
		
			
			<cfoutput query="GetContentList">
				<cfset Body="#Body# #ContentName# #ContentNameDerived# #ContentBody#"/>
				<cfquery name="GetpropertiesPacket2" datasource="#APPLICATION.DSN#">
					select * from t_Properties Where PropertiesID=#Val(ContentPropertiesID)#
				</cfquery>
				<cfset Body="#Body# #GetpropertiesPacket2.PropertiesPacket#"/>
				<cfquery name="GetpropertiesPacket3" datasource="#APPLICATION.DSN#">
					select * from t_Properties Where PropertiesID=#Val(ContentLocalePropertiesID)#
				</cfquery>
				<cfset Body="#Body# #GetpropertiesPacket3.PropertiesPacket#"/>
				<cfif IsWddx(GetpropertiesPacket3.PropertiesPacket)>
					<cfwddx action="WDDX2CFML" input="#GetpropertiesPacket3.PropertiesPacket#" output="sContentLocalePropertiesPacket">
					<cfif StructKeyExists(sContentLocalePropertiesPacket,"ContentPreview")>
						<cfset Custom1="#Custom1# #sContentLocalePropertiesPacket.ContentPreview#"/>
					</cfif>
				</cfif>
			</cfoutput>

		<cfset QueryAddRow(qVerity,1)/>
		<cfset QuerySetCell(qVerity, "Key", Key)/>
		<cfset QuerySetCell(qVerity, "Title", Title)/>
		<cfset QuerySetCell(qVerity, "Body", Body)/>
		<cfset QuerySetCell(qVerity, "Custom1", Custom1)/>
		<cfset QuerySetCell(qVerity, "Custom2", Custom2)/>
	</cfloop>
	
	<!--- delete the key if its there --->
	<cfdump var="#qverity#"/>
	<cfif qverity.recordcount gt 0>
		<cftry>
			<cflock name="verity" timeout="60">
				<cfindex action="delete" collection="#ThisCollectionName#" 
					key="KEY" 
					type="CUSTOM"
					query="qverity">
			 </cflock>
			<cfcatch>Could not delete the key</cfcatch>
		</cftry>
		<cfindex action="UPDATE" collection="#ThisCollectionName#" 
			key="Key" 
			type="CUSTOM" 
			title="Title" 
			query="qVerity" 
			body="Body"
			custom1="Custom1"
			custom2="Custom2">
	<cfelse>
		no content to update
	</cfif>
</cfloop>
</cfsilent>