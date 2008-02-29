<cfcomponent extends="com.common.baseCollection">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->

	<cffunction name="build"
		access="public" output="false" returntype="array"
		hint="Builds the collection based on the filter and sort parameters.  For now, this is a stub.">
		
		<!--- init variables --->
		<cfset var WhereClause = This.buildWhereClause()/>
		<cfset var OrderByClause = This.buildOrderByClause()/>
		<cfset var ThisCategoryItem = "">
		<cfset var GetItems = "">
		
		<cfif Val(This.MaxRows) GT "0">
			<cfquery name="GetItems" Datasource="#APPLICATION.DSN#" maxrows="#Val(This.MaxRows)#">
				Select CategoryID from qry_GetCategory #PreserveSingleQuotes(WhereClause)# #OrderByClause#
			</cfquery>
		<cfelse>
			<cfquery name="GetItems" Datasource="#APPLICATION.DSN#">
				Select CategoryID from qry_GetCategory #PreserveSingleQuotes(WhereClause)# #OrderByClause#
			</cfquery>
		</cfif>
		<cfoutput query="GetItems" group="CategoryID">
			<cfset ThisCategoryItem=CreateObject("component","//com/ContentManager/Category")>
			<cfset ThisCategoryItem.Constructor(CategoryID)>
			<cfset ArrayAppend(This.Collection, ThisCategoryItem)>
		</cfoutput>
		<cfreturn this.collection>
	</cffunction>
	
	<cffunction name="filterBy"
		access="public" output="false"
		hint="Specifies a rule on which to filter.">
		<cfargument name="FieldName" type="string" required="true"
			hint="The name of the field on which to filter."/>
		<cfargument name="Value" type="any" required="true"
			hint="The value the field must contain."/>
		<cfargument name="FieldType" type="string" required="true" default="string"
			hint="The type of data in this field.  Must be either string or numeric."/>
		<cfargument name="RuleType" type="String" required="False" default="="
			hint="The comparison operator to be used.">
		<!--- This has to be declared first.  --->
		<cfset var RuleInfo = StructNew()/>
		<cfset var FieldNameIsBogus = ""/>

		<!--- It's best to check the field name to ensure that it actually exists.
			  Failing that, checking for illegal and potentially hostile characters
			  should be considered a minimum precaution.  --->
		<cfinvoke component="/com/utils/Database"
			method="ContainsSpecialSQLChars"
			returnvariable="FieldNameIsBogus">
			<cfinvokeargument name="Input" value="#Arguments.FieldName#"/>
		</cfinvoke>
		<cfif FieldNameIsBogus>
			<cfthrow type="DiscussionCollection.SecurityException"
					 message="The field name contains illegal characters."/>
		</cfif>

		<!--- Build the rule information.  --->
		<cfset RuleInfo.FieldName = Arguments.FieldName/>
		<cfset RuleInfo.RuleType = Arguments.RuleType/>
		<cfset RuleInfo.Value = Arguments.Value/>
		<cfif LCase(Arguments.FieldType) IS "numeric">
			<cfset RuleInfo.FieldType = "numeric"/>
		<cfelse>
			<!--- Use string as the default.  --->
			<cfset RuleInfo.FieldType = "string"/>
		</cfif>
		<cfset ArrayAppend(This.FilterRules, RuleInfo)/>
	</cffunction>  <!--- filterBy --->
	<cffunction name="sortBy"
		access="public" output="false"
		hint="Specifies a rule on which to sort.  If more than one rule is specified, earlier method calls take higher precedence.">
		<cfargument name="FieldName" type="string" required="true"
			hint="The name of the field on which to filter."/>
		<cfargument name="SortOrder" type="string" required="true" default="ASC"
			hint="The order in which to sort.  If specified, should be either ASC or DESC."/>

		<!--- This has to be declared first.  --->
		<cfset var RuleInfo = StructNew()/>
		<cfset var FieldNameIsBogus = ""/>

		<!--- It's best to check the field name to ensure that it actually exists.
			  Failing that, checking for illegal and potentially hostile characters
			  should be considered a minimum precaution.  --->
		<cfinvoke component="/com/utils/Database"
			method="ContainsSpecialSQLChars"
			returnvariable="FieldNameIsBogus">
			<cfinvokeargument name="Input" value="#Arguments.FieldName#"/>
		</cfinvoke>
		<cfif FieldNameIsBogus>
			<cfthrow type="DiscussionCollection.SecurityException"
					 message="The field name contains illegal characters."/>
		</cfif>

		<!--- Build the rule information.  --->
		<cfset RuleInfo.FieldName = Arguments.FieldName/>
		<cfif UCase(Arguments.SortOrder) IS "DESC">
			<cfset RuleInfo.SortOrder = "DESC"/>
		<cfelse>
			<!--- ASC is the default as per the SQL standard.
				  It's convenient for the parameter to always be defined.  --->
			<cfset RuleInfo.SortOrder = "ASC"/>
		</cfif>
		<cfset ArrayAppend(This.SortRules, RuleInfo)/>
	</cffunction>  <!--- sortBy --->

	<cffunction name="buildWhereClause" returntype="string"
		access="package" output="false"
		hint="Returns the WHERE clause based on the current filter rules.
			  Includes the WHERE itself unless there are no filter rules, in which case a zero-length string is returned.">
		<cfset var WhereClause = ""/>
		<cfset var i = ""/>
		<cfset var ThisRule = ""/>
		<cfset var RHS = ""/>

		<cfloop index="i" from="1" to="#ArrayLen(This.FilterRules)#">
			<!--- First, separate the statements from each other.  --->
			<cfif i IS 1>
				<cfset WhereClause = "WHERE "/>
			<cfelse>
				<cfset WhereClause = WhereClause & " AND "/>
			</cfif>

			<!--- Then add this statement.  --->
			<cfset ThisRule = This.FilterRules[i]/>
			<cfif ThisRule.FieldType IS "numeric">
				<cfset RHS="#ThisRule.Value#">
			<cfelse>
				<cfset RHS="'#ThisRule.Value#'">
			</cfif>
			<cfset WhereClause = WhereClause & "#ThisRule.FieldName# #ThisRule.RuleType# #RHS#"/>
		</cfloop>  <!--- filter rules --->
		<!--- Post-condition:  WhereClause is complete.  --->

		<cfreturn WhereClause/>
	</cffunction>  <!--- buildWhereClause --->

	<cffunction name="buildOrderByClause" returntype="string"
		access="package" output="false"
		hint="Returns the ORDER BY clause based on the current sort rules.
			  Includes the ORDER BY itself unless there are no sort rules, in which case a zero-length string is returned.">
		<cfset var OrderByClause = ""/>
		<cfset var i = ""/>
		<cfset var ThisRule= ""/>

		<cfloop index="i" from="1" to="#ArrayLen(This.SortRules)#">
			<!--- First, separate the fields from each other.  --->
			<cfif i IS 1>
				<cfset OrderByClause = "ORDER BY "/>
			<cfelse>
				<cfset OrderByClause = OrderByClause & ", "/>
			</cfif>

			<!--- Then add this statement.  --->
			<cfset ThisRule = This.SortRules[i]/>
			<cfset OrderByClause = OrderByClause & "#ThisRule.FieldName# #ThisRule.SortOrder#"/>
		</cfloop>  <!--- filter rules --->
		<!--- Post-condition:  WhereClause is complete.  --->

		<cfreturn OrderByClause/>
	</cffunction>  <!--- buildOrderByClause --->
</cfcomponent>
