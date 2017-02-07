<cfcomponent output="false">
	
	<cffunction name="GetColumnContentIDList" output="false" returntype="string">
		<cfargument name="CategoryID" default="-1" type="numeric">
		<cfargument name="LocaleID" default="-1" type="numeric">
		<cfargument name="ContentPositionID" default="-1" type="numeric">
		<cfargument name="CategoryThreadList" default="-1" type="string">
		
		<cfset var local=structNew() />
		
		<cfset LOCAL.FunctionHash=Hash("#ARGUMENTS.CategoryID#-#ARGUMENTS.LocaleID#-#ARGUMENTS.ContentPositionID#-#ARGUMENTS.CategoryThreadList#")>
		<cfset LOCAL.QueryName="GetInherited#LOCAL.FunctionHash#">
		
		<cfif ARGUMENTS.CategoryThreadList IS "">
			<cfobject component="com.ContentManager.CategoryHandler"
				name="MyCategoryHandler">
			
			<cfinvoke component="#MyCategoryHandler#"
				method="GetBranchFromRoot"
				returnVariable="LOCAL.sBranch"
				CategoryID="#ARGUMENTS.CategoryID#">
			<cfset LOCAL.CategoryThreadList=LOCAL.sBranch.IDList>
		<cfelse>
			<cfset LOCAL.CategoryThreadList=ARGUMENTS.CategoryThreadList>
		</cfif>
		
		<cfif NOT IsDefined("REQUEST.#LOCAL.QueryName#")>
			<cfquery name="REQUEST.#LOCAL.QueryName#" datasource="#APPLICATION.DSN#">
				SELECT		ContentID 
				FROM		qry_GetContentInherit
				WHERE		ContentPositionID=<cfqueryparam value="#Val(ARGUMENTS.ContentPositionID)#" cfsqltype="CF_SQL_INTEGER">
				AND			LocaleID=<cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
				AND			ContentActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
				AND			CategoryActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
				AND			(
								(
								CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="CF_SQL_INTEGER"> 
								AND (
									InheritID <= <cfqueryparam value="1800" cfsqltype="CF_SQL_INTEGER"> 
									OR InheritID=<cfqueryparam value="" cfsqltype="CF_SQL_INTEGER" null="Yes">
									)
								)
							OR
								(
								CategoryID IN (<cfqueryparam value="#LOCAL.CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">)
								AND	InheritID=<cfqueryparam value="1801" cfsqltype="CF_SQL_INTEGER">
								)
							OR
								(
								CategoryID IN (<cfqueryparam value="#ListDeleteAt(LOCAL.CategoryThreadList,ListLen(LOCAL.CategoryThreadList))#" cfsqltype="cf_sql_integer" list="yes">) 
								AND InheritID=<cfqueryparam value="1802" cfsqltype="CF_SQL_INTEGER">
								)
							)
				ORDER BY	displayorder DESC, ContentLocalePriority
			</cfquery>
						
			<cfif REQUEST[LOCAL.QueryName].RecordCount IS "0">
				<cfquery name="REQUEST.#LOCAL.QueryName#" datasource="#APPLICATION.DSN#" maxrows="1">
					SELECT		ContentID 
					FROM		qry_GetContentInherit
					WHERE		ContentPositionID=<cfqueryparam value="#Val(ARGUMENTS.ContentPositionID)#" cfsqltype="CF_SQL_INTEGER">
					AND 		LocaleID=<cfqueryparam value="#ARGUMENTS.LocaleID#" cfsqltype="CF_SQL_INTEGER">
					AND 		ContentActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND 		CategoryActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND 		CategoryID IN (<cfqueryparam value="#LOCAL.CategoryThreadList#" cfsqltype="cf_sql_integer" list="yes">)
					AND 		InheritID=<cfqueryparam value="1803" cfsqltype="CF_SQL_INTEGER">
					ORDER BY	displayorder DESC, ContentLocalePriority
				</cfquery>
			</cfif>
		</cfif>
		
		<cfset LOCAL.lContentID="">
		<cfoutput query="REQUEST.#LOCAL.QueryName#">
			<cfset LOCAL.lContentID=ListAppend(LOCAL.lContentID,Evaluate("REQUEST.#LOCAL.QueryName#.ContentID"))>
		</cfoutput>
		
		<cfreturn LOCAL.lContentID>
	</cffunction>
</cfcomponent>