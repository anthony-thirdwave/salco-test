<cffunction name="GetTextBlock" returntype="query" output="false">
	<cfargument name="Entity" default="" type="string" required="true">
	<cfargument name="KeyID" default="" type="numeric" required="true">
	<cfargument name="TextBlockTypeID" default="" type="numeric" required="true">
	<cfargument name="LocaleID" default="" type="numeric" required="true">
	<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_Locale Where LocaleID=#Val(ARGUMENTS.LocaleID)#
	</cfquery>
	<cfif GetLang.RecordCount IS "1">
		<cfset CurrentLanguageID="#Val(GetLang.LanguageID)#">
	</cfif>
	<cfquery name="GetResource" datasource="#APPLICATION.DSN#">
		select * FROM qry_GetTextBlock WHERE 
		KeyID=#Val(ARGUMENTS.KeyID)# AND
		Entity='t_#Trim(ARGUMENTS.Entity)#' AND
		TextBlockTypeID=#Val(ARGUMENTS.TextBlockTypeID)# And
		(LanguageID =100 Or LanguageID=#Val(CurrentLanguageID)#)
		order by TextBlockPriority, LanguageID DESC
	</cfquery>
	<cfset qTextBlock=QueryNew("TextBlock,TextBlockName")>
	<cfoutput query="GetResource" group="TextBlockID">
		<cfset QueryAddRow(qTextBlock,1)>
		<cfset ThisTextBlock="">
		<cfset ThisTextBlockName="">
		<cfoutput group="LanguageID">
			<cfset ThisTextBlock=TextBlock>
			<cfset ThisTextBlockName=TextBlockname>
		</cfoutput>
		<cfset QuerySetCell(qTextBlock,"TextBlockName",ThisTextblockName)>
		<cfset QuerySetCell(qTextBlock,"TextBlock",ThisTextblock)>
	</cfoutput>
	<cfreturn qTextBlock>
</cffunction>
