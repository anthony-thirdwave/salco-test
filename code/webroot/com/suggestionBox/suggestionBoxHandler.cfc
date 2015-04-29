<cfcomponent>

	<cffunction name="init" returntype="CategoryHandler">
		<cfreturn this>
	</cffunction>

	<cffunction name="getDepartmentName" returntype="query">
		<cfargument name="nameID" default="0" type="numeric" required="true">
		<cfset var LOCAL=StructNew()>
		<cfquery name="LOCAL.getDepartmentName" datasource="#APPLICATION.Data_DSN#">
			select labelName as name
			from t_label
			where labelID=<cfqueryparam value="#ARGUMENTS.nameID#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn LOCAL.getDepartmentName>
	</cffunction>


	<cffunction name="getAreaName" returntype="query">
		<cfargument name="areaID" default="0" type="numeric" required="true">
		<cfset var LOCAL=StructNew()>
		<cfquery name="LOCAL.getAreaName" datasource="#APPLICATION.Data_DSN#">
			select labelName as name
			from t_label
			where labelID=<cfqueryparam value="#ARGUMENTS.areaID#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn LOCAL.getAreaName>
	</cffunction>

	<cffunction name="getDepartments" returntype="query">
		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.getDepartments" datasource="#APPLICATION.Data_DSN#">
			select labelID as departmentID, labelName as departmentName
			from t_label
			where labelGroupID=<cfqueryparam value="2500" cfsqltype="cf_sql_integer">
			order by labelName
		</cfquery>

		<cfreturn LOCAL.getDepartments>

	</cffunction>

	<cffunction name="getSuggestionAreas" returntype="query">
		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.getSuggestionAreas" datasource="#APPLICATION.Data_DSN#">
			select labelID as areaID, labelName as areaName
			from t_label
			where labelGroupID=<cfqueryparam value="2600" cfsqltype="cf_sql_integer">
			order by labelName
		</cfquery>

		<cfreturn LOCAL.getSuggestionAreas>

	</cffunction>

	<cffunction name="getDepartmentsByID" returntype="query">
		<cfargument name="departmentIDValue" default="0" type="numeric" required="true">

		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.getDepartmentsByID" datasource="#APPLICATION.Data_DSN#">
			select labelID as departmentID, labelName as departmentName
			from t_label
			where labelGroupID=<cfqueryparam value="2500" cfsqltype="cf_sql_integer">
			and labelID=<cfqueryparam value="#val(ARGUMENTS.departmentIDValue)#" cfsqltype="cf_sql_integer">
			order by labelName
		</cfquery>

		<cfreturn LOCAL.getDepartmentsByID>

	</cffunction>

	<cffunction name="insertSuggestion" returntype="numeric">
		<cfargument name="suggestionFormValue" default="" type="struct" required="true">

		<cfset var LOCAL=StructNew()>

		<cfif isDefined("ARGUMENTS.suggestionFormValue") and isStruct(ARGUMENTS.suggestionFormValue)>
			<cfquery name="LOCAL.insertSuggestion" datasource="#APPLICATION.Data_DSN#">
				SET NOCOUNT ON
				INSERT INTO t_suggestions
				(employeeName,employeeEmail,suggestion,departmentID,areaID,anonymous)
				values
				(
					<cfqueryparam value="#ARGUMENTS.suggestionFormValue.employeeName#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#ARGUMENTS.suggestionFormValue.missive#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#ARGUMENTS.suggestionFormValue.message#" cfsqltype="cf_sql_longvarchar">,
					<cfqueryparam value="#ARGUMENTS.suggestionFormValue.salcoDepartment#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#ARGUMENTS.suggestionFormValue.suggestionArea#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#ARGUMENTS.suggestionFormValue.anonymousSuggestion#" cfsqltype="cf_sql_bit">
				)
				SELECT newSuggestionID=@@Identity
			</cfquery>
			<cfreturn LOCAL.insertSuggestion.newSuggestionID>
		<cfelse>
			<cfreturn 0>
		</cfif>

	</cffunction>

<!--- GETTING SUGGESTION INFORMATION --->
	<cffunction name="getSuggestion" returntype="query">
		<cfargument name="suggestionID" default="0" type="numeric" required="true">
		<cfset var LOCAL=StructNew()>

		<cfquery name="LOCAL.getSuggestion" datasource="#APPLICATION.Data_DSN#">
			SELECT t_suggestions.suggestionID, 
						 t_suggestions.employeeName, 
						 t_suggestions.employeeEmail, 
						 t_suggestions.suggestion, 
						 t_suggestions.departmentID, 
						 t_suggestions.areaID, 
						 t_suggestions.anonymous, 
						 t_Label_1.LabelName AS departmentName, 
						 t_Label_2.LabelName AS areaName,
						 t_suggestions.dateSubmitted
			FROM t_Label AS t_Label_1 
				INNER JOIN t_suggestions ON t_Label_1.LabelID = t_suggestions.departmentID 
				INNER JOIN t_Label AS t_Label_2 ON t_suggestions.areaID = t_Label_2.LabelID
			where suggestionID=<cfqueryparam value="#ARGUMENTS.suggestionID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfreturn LOCAL.getSuggestion>
	</cffunction>

	<!--- get the users based upon the passed params --->
	<cffunction name="getSuggestions" output="false" access="remote">
		<cfargument name="page" default="">
		<cfargument name="pageSize" default="">
		<cfargument name="cfgridsortcolumn" default="dateSubmitted">
		<cfargument name="cfgridsortdirection" default="desc">
		<cfargument name="employeeName" type="string" default="">
		<cfargument name="suggestion" type="string" default="">
		<cfargument name="departmentName" type="string" default="">
		<cfargument name="areaName" type="string" default="">
		<cfargument name="anonymous" default="">

		<!--- keep scope local to function --->
		<cfset var local = structNew() />

		<cfdump var="#ARGUMENTS#"><cfabort>
		<!--- get the results --->
		<cfquery name="LOCAL.getResults" datasource="#APPLICATION.Data_DSN#">
			SELECT t_suggestions.suggestionID, 
			 t_suggestions.employeeName, 
			 t_suggestions.employeeEmail, 
			 CAST ( t_suggestions.suggestion AS nvarchar ) AS suggestionText, 
			 t_suggestions.departmentID, 
			 t_suggestions.areaID, 
			 t_suggestions.anonymous, 
			 t_Label_1.LabelName AS departmentName, 
			 t_Label_2.LabelName AS areaName, 
			 t_suggestions.dateSubmitted,
			 '<img src="/common/images/admin/icon_magnify.gif" width="12" height="12" />' as edit

			FROM t_Label AS t_Label_1 
				INNER JOIN t_suggestions ON t_Label_1.LabelID = t_suggestions.departmentID 
				INNER JOIN t_Label AS t_Label_2 ON t_suggestions.areaID = t_Label_2.LabelID
			where 1=1

			<cfif trim(arguments.employeeName) neq "">
				AND employeeName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.employeeName#%">
			</cfif>
			<cfif trim(arguments.suggestion) neq "">
				AND suggestion LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.suggestion#%">
			</cfif>
			<cfif trim(arguments.anonymous) neq "">
			  AND anonymous LIKE <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.anonymous#">
			</cfif>
			<cfif trim(arguments.departmentName) neq "">
				AND t_Label_1.LabelName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.departmentName#%">
			</cfif>
			<cfif trim(arguments.areaName) neq "">
				AND t_Label_2.LabelName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.areaName#%">
			</cfif>

			<!--- cfgrid ordering params --->
			<cfif trim(arguments.cfgridsortcolumn) neq "">
				ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#
			<cfelse>
				ORDER BY employeeName
			</cfif>
		</cfquery>

		<!--- if page and pageSize are numeric then return for cfgrid --->
		<cfif isNumeric(arguments.page) and isNumeric(arguments.pageSize)>
			<!--- return the results --->
			<cfreturn queryConvertForGrid(local.getResults, arguments.page, arguments.pageSize)>

		<!--- else, return the query  --->
		<cfelse>
			<cfreturn local.getResults>
		</cfif>
	</cffunction>

</cfcomponent>












