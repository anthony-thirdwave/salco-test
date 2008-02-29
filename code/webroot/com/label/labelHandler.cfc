<cfcomponent displayname="Label Handler" hint="Provides functionality for processing standard 3WCMS labels.">
	<!--- started 6/17/03 jk:3w --->

	<!---
		started by jk:3w
		09/19/03 PWK, Used a bind parameter and other enhancements
	--->
	<cffunction name="getLabels" access="remote" returntype="query" output="false"
		hint="Returns all the labels with a given label code, in the specified order.">
		<cfargument name="labelCode" type="string" required="true"
			hint="The label code whose labels should be returned."/>
		<cfargument name="dataSource" type="string" required="true"
			hint="The name of the data source from which the labels should be queried.">

		<cfset var labelSet = 0/>

		<cfquery datasource="#Arguments.dataSource#" name="labelSet">
			SELECT		LabelID, LabelName, LabelPriority
			FROM		t_Label
			WHERE		LabelCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.labelCode#"/>
			ORDER BY	LabelPriority
		</cfquery>

		<cfreturn Duplicate(labelSet)/>
	</cffunction>  <!--- getLabels --->

	<!---
		09/19/03 PWK, Created
	--->
	<cffunction name="showLabelSelect" access="remote" output="true"
		hint="Writes a select element including all the labels with a given label code to the page.
			  Optionally provides an element appearing above the labels, which can either serve as
			  a prompt or specify no label (corresponding to a NULL in the database.)">
		<cfargument name="labelCode" type="string" required="true"
			hint="The label code whose labels should be displayed."/>
		<cfargument name="dataSource" type="string" required="true"
			hint="The name of the data source from which the labels should be queried.">
		<cfargument name="name" type="string" required="true"
			hint="The name to be assigned to the select element."/>
		<cfargument name="default" type="string" required="false"
			hint="The element currently selected, if any."/>
		<cfargument name="nullOptionText" type="string" required="false"
			hint="If given, the null element will appear and will use this as its option text."/>
		<cfargument name="nullOptionValue" type="string" default=""
			hint="The value which should be associated with the null element."/>

		<cfset var labelSet = 0/>
		<cfset var status = ""/>

		<!--- First of all, get the labels to display.  --->
		<cfinvoke component="hbfc.com.label.labelHandler"
			method="getLabels"
			labelCode="#Arguments.labelCode#"
			dataSource="#Arguments.dataSource#"
			returnvariable="labelSet"/>

		<!--- Loop over them.  --->
		<cfoutput>
		<select name="#HTMLEditFormat(Arguments.name)#">
		<cfif IsDefined("Arguments.nullOptionText")>
			<option value="#HTMLEditFormat(Arguments.nullOptionValue)#">#HTMLEditFormat(Arguments.nullOptionText)#</option>
		</cfif>
		<cfloop query="labelSet">
			<cfif NOT IsDefined("Arguments.default")>
				<cfset status = ""/>
			<cfelseif Arguments.default IS LabelID>
				<cfset status = " selected"/>
			<cfelse>
				<cfset status = ""/>
			</cfif>
			<option value="#LabelID#"#status#>#HTMLEditFormat(LabelName)#</option>
		</cfloop>
		</select>
		</cfoutput>
	</cffunction>  <!--- showLabelSelect --->
</cfcomponent>  <!--- hbfc.com.label.labelHandler --->
