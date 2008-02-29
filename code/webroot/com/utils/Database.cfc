<cfcomponent displayname="Database"
	hint="Static methods for accessing SOM databases.">
	<cffunction name="GenericLookup" returntype="query"
		access="public" output="false"
		hint="Given a DSN, table name, field name and unique ID, returns the matching record or records.">
		<cfargument name="DataSource" type="string" required="true"
			hint="The DSN to be queried."/>
		<cfargument name="TableName" type="string" required="true"
			hint="The name of the table to be queried."/>
		<cfargument name="FieldName" type="string" required="true"
			hint="The name of the field to be queried."/>
		<cfargument name="FieldValue" type="any" required="true"
			hint="The value to match.  Will usually be a unique ID."/>
		<cfargument name="SortFieldName" type="string" required="false" default=""
			hint="The name of the field on which to sort."/>
		<cfargument name="SortOrder" type="string" required="false"
			hint="The direction to sort if SortFieldName is specified.
				  Must be either ASC (the default) or DESC."/>
		<cfargument name="MaxRows" type="string" required="false"
			hint="The maxinum number of rows to be return from the table.
				  Leave blank to ignore"/>
				  
		<!--- init variables --->
		<cfset var OrderBy = "">
		<cfset var ThisFieldName = "">
		<cfset var i = "">
		<cfset var GenericQuery = "">
		
		<!--- Check for potentially hostile special characters before building
			  the SQL by hand.  --->
		<cfif ContainsSpecialSQLChars(Arguments.DataSource)>
			<cfthrow type="DatabaseUtils.SecurityException"
					 message="The DataSource attribute contained special SQL characters."/>
		</cfif>
		<cfif ContainsSpecialSQLChars(Arguments.TableName)>
			<cfthrow type="DatabaseUtils.SecurityException"
					 message="The TableName attribute contained special SQL characters."/>
		</cfif>
		<cfloop index="ThisFieldName" list="#Arguments.FieldName#">
			<cfif ContainsSpecialSQLChars(ThisFieldName)>
				<cfthrow type="DatabaseUtils.SecurityException"
						 message="The FieldName attribute contained special SQL characters."/>
			</cfif>
		</cfloop>
		<cfif ContainsSpecialSQLChars(Arguments.SortFieldName)>
			<cfthrow type="DatabaseUtils.SecurityException"
					 message="The SortFieldName attribute contained special SQL characters."/>
		</cfif>
		<cfif ListLen(ARGUMENTS.FieldName) IS NOT ListLen(ARGUMENTS.FieldValue)>
			<cfthrow type="DatabaseUtils.SecurityException"
					 message="The FieldName list and FieldValue list do not match."/>
		</cfif>
		<!--- Is there a ORDER BY clause?  --->
		<cfif Arguments.SortFieldName IS "">
			<!--- If there's no sort field, SortOrder is ignored.  --->
			<cfset OrderBy = ""/>
		<cfelse>
			<cfset OrderBy = "ORDER BY " & Arguments.SortFieldName/>

			<!--- If there was a sort order and it's DESC, add it on.
				  ASC is the default if it wasn't given or is bogus.  --->
			<cfif IsDefined("Arguments.SortOrder")>
				<cfif UCase(Arguments.SortOrder) IS "desc">
					<cfset OrderBy = OrderBy & " DESC"/>
				</cfif>  <!--- matches DESC --->
			</cfif>  <!--- sort order given --->
		</cfif>  <!--- sort field given --->

		<!--- Build our query.  --->
		<cftry>
			<cfparam name="ARGUMENTS.MaxRows" default="0">
			<cfif Val(Trim(ARGUMENTS.MaxRows)) IS not "0">
				<cfquery name="GenericQuery" datasource="#Arguments.DataSource#" maxrows="#Val(Trim(ARGUMENTS.MaxRows))#">
					SELECT * FROM #Arguments.TableName#
					WHERE 
					<cfloop index="i" from="1" to="#ListLen(Arguments.FieldName)#" step="1">
						#ListGetAt(Arguments.FieldName,i)# = '#ListGetAt(Arguments.FieldValue,i)#' AND
					</cfloop>
					1=1 
					#OrderBy#
				</cfquery>
			<cfelse>
				<cfquery name="GenericQuery" datasource="#Arguments.DataSource#">
					SELECT * FROM #Arguments.TableName#
					WHERE
					<cfloop index="i" from="1" to="#ListLen(Arguments.FieldName)#" step="1">
						#ListGetAt(Arguments.FieldName,i)# = '#ListGetAt(Arguments.FieldValue,i)#' AND
					</cfloop>
					1=1
					#OrderBy#
				</cfquery>
			</cfif>
		<cfcatch type="database">
			<!--- If the query failed, complain.  --->
			<cfthrow type="DatabaseUtils.DatabaseError"
					 message="#CFCatch.Message#"
					 detail="#CFCatch.Detail#"/>
		</cfcatch>
		</cftry>

		<cfreturn GenericQuery/>
	</cffunction>  <!--- GenericIDLookup --->

	<cffunction name="ContainsSpecialSQLChars" returntype="boolean"
		access="public" output="false"
		hint="Checks for special characters in the input value.
			  Special characters are defined as anything except letters, numbers and the underscore.
			  Other characters may contain hostile SQL code which can't safely be parsed into a query.">
		<cfargument name="Input" type="string" required="true"
			hint="The string to check for special characters."/>

		<cfreturn (REFind("[^A-Za-z0-9_.]", Arguments.Input) GTE 1)/>
	</cffunction>  <!--- ContainsSpecialSQLChars --->
</cfcomponent>  <!--- Database --->
