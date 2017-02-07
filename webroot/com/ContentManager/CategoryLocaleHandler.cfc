<cffunction name="GenerateDisplayOrderString" returnType="boolean" output="false">
	<cfargument name="SourceParentID" required="true" type="numeric">
	<cfargument name="Datasource" required="true" type="string">
	<cfargument name="LocaleID" required="true" type="numeric">
	<cfif IsDefined("APPLICATION.Migrate") AND APPLICATION.Migrate>
		<cfreturn true>
	</cfif>
	
	<cfquery datasource="#ARGUMENTS.Datasource#">
	EXEC sp_generateDisplayOrderLocaleMeta #Val(ARGUMENTS.SourceParentID)#, #Val(ARGUMENTS.LocaleID)#
	</cfquery>
	
	<cfreturn true>
</cffunction>