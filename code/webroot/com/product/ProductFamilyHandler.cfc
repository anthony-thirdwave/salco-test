<cffunction name="GetProductFamilyAttributeStructure" output="false" returntype="struct">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	<cfargument name="LanguageID" default="" type="numeric" required="true">
	<cfset sReturn=StructNew()>
	<cfquery name="Get" datasource="#APPLICATION.DSN#">
		SELECT ProductFamilyAttributeID, ProductFamilyAttributeName,LanguageID FROM qry_GetProductFamilyAttribute 
		WHERE CategoryID=#Val(ARGUMENTS.CategoryID)# and LanguageID=#Val(ARGUMENTS.LanguageID)#
		order by ProductFamilyAttributeID,LanguageID DESC
	</cfquery>
	<!--- In the query get english (100) last.  --->
	<cfoutput query="Get" group="ProductFamilyAttributeID">
		<cfset ThisName="">
		<cfoutput group="LanguageID">
			<cfif ProductFamilyAttributeName IS NOT "" and THisName IS "">
				<cfset ThisName=ProductFamilyAttributeName>
			</cfif>
		</cfoutput>
		<cfset StructInsert(sReturn,ProductFamilyAttributeID,ThisName)>
	</cfoutput>
	<cfreturn sReturn>
</cffunction>

<cffunction name="GetDefaultLanguageID" output="false" returntype="numeric">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	<cfquery name="test" datasource="#APPLICATION.DSN#">
		SELECT	t_Locale.LanguageID AS LanguageID
		FROM	t_Locale 
		WHERE	LocaleID=#Val(ARGUMENTS.LocaleID)#
	</cfquery>
	<cfif test.RecordCount IS NOT "0">
		<cfreturn test.LanguageID>
	<cfelse>
		<cfreturn APPLICATION.DefaultLanguageID>
	</cfif>
</cffunction>

<cffunction name="GetProductFamilyLanguages" returntype="query" output="false">
	<cfargument name="CategoryID" default="" type="numeric" required="true">
	<cfquery name="GetLanguages" datasource="#APPLICATION.DSN#">
		select LabelID as LanguageID, LabelName as LanguageName from 
		dbo.t_Label INNER JOIN
		dbo.t_ProductAttribute ON dbo.t_Label.LabelID = dbo.t_ProductAttribute.LanguageID
		Where CategoryID=#Val(ARGUMENTS.CategoryID)# and ProductFamilyAttributeID=515
		order by LanguageName
	</cfquery>
	<cfreturn GetLanguages>
</cffunction>
