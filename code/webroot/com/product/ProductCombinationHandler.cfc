<cffunction name="GetProductCombination" output="false" returntype="query">
	<cfargument name="ProductID1" default="" type="numeric" required="true">
	<cfquery name="CheckCombination" datasource="#APPLICATION.DSN#">
		SELECT * FROM t_ProductCombination WHERE 
		ProductID1=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID1)#">
		order by ProductID2
	</cfquery>
	<cfreturn CheckCombination>
</cffunction>

<cffunction name="GetValueProductCombination" output="false" returntype="query">
	<cfargument name="ProductID1" default="" type="numeric" required="true">
	<cfargument name="LanguageID" default="" type="numeric" required="true">
	<cfquery name="CheckCombination" datasource="#APPLICATION.DSN#">
		SELECT * FROM t_ProductCombination WHERE 
		ProductID1=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID1)#"> AND
		LanguageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> AND
		ProductCombinationActive=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
		order by ProductID2
	</cfquery>
	<cfreturn CheckCombination>
</cffunction>

<cffunction name="GetProductCombinationID" output="false" returntype="numeric">
	<cfargument name="ProductID1" default="" type="numeric" required="true">
	<cfargument name="ProductID2" default="" type="numeric" required="true">
	<cfargument name="LanguageID" default="" type="numeric" required="true">
	<cfquery name="CheckCombination" datasource="#APPLICATION.DSN#">
		SELECT CombinationID FROM t_ProductCombination WHERE 
		ProductID1=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID1)#"> AND
		ProductID2=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.ProductID2)#"> and
		LanguageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)# ">
	</cfquery>
	<cfreturn Val(CheckCombination.CombinationID)>
</cffunction>