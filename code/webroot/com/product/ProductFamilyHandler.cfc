<cffunction name="GetProductFamilyAttributeStructure" output="false" returntype="struct">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	<cfargument name="LanguageID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<cfset LOCAL.sReturn=StructNew()>
	<cfquery name="LOCAL.Get" datasource="#APPLICATION.DSN#">
		SELECT ProductFamilyAttributeID, ProductFamilyAttributeName,LanguageID FROM qry_GetProductFamilyAttribute 
		WHERE 
		CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and 
		LanguageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">
		order by ProductFamilyAttributeID,LanguageID DESC
	</cfquery>
	<!--- In the query get english (100) last.  --->
	<cfoutput query="LOCAL.Get" group="ProductFamilyAttributeID">
		<cfset LOCAL.ThisName="">
		<cfoutput group="LanguageID">
			<cfif LOCAL.Get.ProductFamilyAttributeName IS NOT "" and LOCAL.ThisName IS "">
				<cfset LOCAL.ThisName=LOCAL.Get.ProductFamilyAttributeName>
			</cfif>
		</cfoutput>
		<cfset StructInsert(LOCAL.sReturn,LOCAL.Get.ProductFamilyAttributeID,LOCAL.ThisName)>
	</cfoutput>
	<cfreturn LOCAL.sReturn>
</cffunction>

<cffunction name="GetDefaultLanguageID" output="false" returntype="numeric">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<cfquery name="LOCAL.test" datasource="#APPLICATION.DSN#">
		SELECT	t_Locale.LanguageID AS LanguageID
		FROM	t_Locale 
		WHERE	LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfif LOCAL.test.RecordCount IS NOT "0">
		<cfreturn LOCAL.test.LanguageID>
	<cfelse>
		<cfreturn APPLICATION.DefaultLanguageID>
	</cfif>
</cffunction>

<cffunction name="GetProductFamilyLanguages" returntype="query" output="false">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	
	<cfset VAR LOCAL=StructNew()>
	
	<cfquery name="LOCAL.GetLanguages" datasource="#APPLICATION.DSN#">
		select LabelID as LanguageID, LabelName as LanguageName from 
		dbo.t_Label INNER JOIN
		dbo.t_ProductAttribute ON dbo.t_Label.LabelID = dbo.t_ProductAttribute.LanguageID
		Where 
		CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and 
		ProductFamilyAttributeID=<cfqueryparam value="515" cfsqltype="cf_sql_integer">
		order by LanguageName
	</cfquery>
	<cfreturn LOCAL.GetLanguages>
</cffunction>
