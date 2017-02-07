<cfcomponent hint="Handles grouped params" output="false">

<!--- create a group object in the variables scope for this component --->
<cfset myGroup = createObject("component", "com.group.Group") />





<!--- get the paramTypes based upon passed params --->
<cffunction name="getParamTypes" returntype="query" output="false">
	<cfargument name="groupById" default="">
	<cfargument name="groupByColumn" default="">
	<cfargument name="groupByTable" default="">
	<cfargument name="publicId" default="">
	<cfargument name="getDisabled" default="true">
	
	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	
	<!--- if there's a publicId, then use its internal value as the arguments.groupById --->
	<cfif arguments.publicId neq "">
		<cfinvoke method="getIdFromPublicId" component="#variables.myGroup#" returnvariable="arguments.groupById">
			<cfinvokeargument name="publicId" value="#arguments.publicId#">
		</cfinvoke>
	</cfif>

	<!--- get the types relevant to the passed params --->
	<cfinvoke component="#variables.myGroup#" method="getGroups" returnvariable="local.getResults">
		<cfinvokeargument name="groupAlias" value="">
		<cfinvokeargument name="getDisabled" value="#arguments.getDisabled#">
		
		<!--- get the specific set  if groupById exists, otherwise get the generic set --->
		<cfif isNumeric(arguments.groupById)>
			<cfinvokeargument name="groupById" value="#arguments.groupById#">
			<cfinvokeargument name="groupByColumn" value="#arguments.groupByColumn#">
			<cfinvokeargument name="groupByTable" value="#arguments.groupByTable#">
		</cfif>
	</cfinvoke>
		
	<!--- return the results --->
	<cfreturn local.getResults>
</cffunction>





<!--- get the grouped params based upon passed values --->
<cffunction name="getParams" returntype="query" output="false">
	<cfargument name="groupAlias" default="">
	<cfargument name="groupById" default="">
	<cfargument name="groupByColumn" default="">
	<cfargument name="groupByTable" default="">
	<cfargument name="publicId" default="">
	<cfargument name="getDisabled" default="true">
	<cfargument name="rankHorizontal" default="false">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- if there's a publicId, then use its internal value as the arguments.groupById --->
	<cfif arguments.publicId neq "">
		<cfinvoke method="getIdFromPublicId" component="#variables.myGroup#" returnvariable="arguments.groupById">
			<cfinvokeargument name="publicId" value="#arguments.publicId#">
		</cfinvoke>
	</cfif>

	<!--- get the grouped params for this groupById --->
	<cfinvoke component="#myGroup#" method="getGroupedElems" returnvariable="local.groupedElems">
		<cfinvokeargument name="groupAlias" value="#arguments.groupAlias#">
		<cfinvokeargument name="groupById" value="#arguments.groupById#">
		<cfinvokeargument name="getDisabled" value="#arguments.getDisabled#">
		<cfinvokeargument name="rankHorizontal" value="#arguments.rankHorizontal#">
		
		<!--- get the generic set if no groupById is passed --->
		<cfif isNumeric(arguments.groupById)>
			<cfinvokeargument name="groupByColumn" value="#arguments.groupByColumn#">
			<cfinvokeargument name="groupByTable" value="#arguments.groupByTable#">
		</cfif>
	</cfinvoke>
				
	<!--- return the results --->
	<cfreturn local.groupedElems>
</cffunction>



<!--- create a copy of grouped params --->
<cffunction name="copyParams" returntype="boolean" output="false">
	<cfargument name="sourceGroupById" default="">
	<cfargument name="sourceGroupByColumn" default="">
	<cfargument name="sourceGroupByTable" default="">
	<cfargument name="sourcePublicId" default="">
	<cfargument name="targetGroupById" default="">
	<cfargument name="targetGroupByColumn" default="">
	<cfargument name="targetGroupByTable" default="">
	<cfargument name="targetPublicId" default="">
	<cfargument name="groupAlias" default="">
	
	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	
	<!--- if there's a sourcePublicId, then use its internal value as the arguments.sourceGroupById --->
	<cfif arguments.sourcePublicId neq "">
		<cfinvoke method="getIdFromPublicId" component="#variables.myGroup#" returnvariable="arguments.sourceGroupById">
			<cfinvokeargument name="publicId" value="#arguments.sourcePublicId#">
		</cfinvoke>
	</cfif>
	
	<!--- if there's a targetPublicId, then use its internal value as the arguments.targetPublicId --->
	<cfif arguments.targetPublicId neq "">
		<cfinvoke method="getIdFromPublicId" component="#variables.myGroup#" returnvariable="arguments.targetGroupById">
			<cfinvokeargument name="publicId" value="#arguments.targetPublicId#">
		</cfinvoke>
	</cfif>
	
	<!--- check to see if this set of params already exists --->
	<cfinvoke method="getParams" returnvariable="local.checkParams">
		<cfinvokeargument name="groupAlias" value="#arguments.groupAlias#">
		<cfinvokeargument name="groupById" value="#arguments.targetGroupById#">
		<cfinvokeargument name="groupByColumn" value="#arguments.targetGroupByColumn#">
		<cfinvokeargument name="groupByTable" value="#arguments.targetGroupByTable#">
	</cfinvoke>

	<!--- if this set of params is already here for this company, then exit --->
	<cfif local.checkParams.recordcount gt 0>
		<cfreturn false>
	</cfif>
	
	<!--- get the source group  --->
	<cfinvoke component="#variables.myGroup#" method="getGroups" returnvariable="local.getSourceGroup">
		<cfinvokeargument name="groupAlias" value="#arguments.groupAlias#">
		
		<!--- only get specific if a arguments.sourceGroupById is numeric --->
		<cfif isNumeric(arguments.sourceGroupById)>
			<cfinvokeargument name="groupById" value="#arguments.sourceGroupById#">
			<cfinvokeargument name="groupByColumn" value="#arguments.sourceGroupByColumn#">
			<cfinvokeargument name="groupByTable" value="#arguments.sourceGroupByTable#">
		</cfif>
	</cfinvoke>

	<!--- if theres a matching source group --->
	<cfif local.getSourceGroup.recordcount eq 1>
		
		<cftry>
			<cftransaction>

				<!--- copy the group and its elements --->
				<cfinvoke component="#variables.myGroup#" method="copyGroup">
					<cfinvokeargument name="sourceGroupId" value="#local.getSourceGroup.groupId#">
					<cfinvokeargument name="targetGroupById" value="#arguments.targetGroupById#">
					<cfinvokeargument name="targetGroupByColumn" value="#arguments.targetGroupByColumn#">
					<cfinvokeargument name="targetGroupByTable" value="#arguments.targetGroupByTable#">
					<cfinvokeargument name="targetDescription" value="#local.getSourceGroup.groupDescription#">
					<cfinvokeargument name="copyGroupedElems" value="true">
				</cfinvoke>
			</cftransaction>
			
			<cfcatch type="any">
				<cfreturn false>
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfreturn true>
</cffunction>




<!--- updates grouped params --->
<cffunction name="updateParams" output="false">
	<cfargument name="groupAlias" default="">
	<cfargument name="groupById" default="">
	<cfargument name="groupByColumn" default="">
	<cfargument name="groupByTable" default="">
	<cfargument name="publicId" default="">
	<cfargument name="form" required="true">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- if there's a publicId, then use its internal value as the arguments.groupById --->
	<cfif arguments.publicId neq "">
		<cfinvoke method="getIdFromPublicId" component="#variables.myGroup#" returnvariable="arguments.groupById">
			<cfinvokeargument name="publicId" value="#arguments.publicId#">
		</cfinvoke>
	</cfif>
	
	<!--- get the group Params --->
	<cfinvoke method="getParams" returnvariable="local.myParams">
		<cfinvokeargument name="groupAlias" value="#arguments.groupAlias#">
		<cfinvokeargument name="groupById" value="#arguments.groupById#">
		<cfinvokeargument name="groupByColumn" value="#arguments.groupByColumn#">
		<cfinvokeargument name="groupByTable" value="#arguments.groupByTable#">
	</cfinvoke>

	<!--- loop through the params --->
	<cfloop query="local.myParams">
		
		<!--- if the param is in the form and it's disabled, set it as enabled --->
		<cfif listFindNoCase(arguments.form.fieldNames, "groupedElemEnabled_" & local.myParams.groupedElemPublicId) 
				and local.myParams.groupedElemDisabledDate neq "">
			<cfset variables.myGroup.enableGroupedElem(local.myParams.id)>
			
			<!--- if this element is a group, enable the group, too --->
			<cfif local.myParams.groupedElemTable eq "t_group">
				<cfset variables.myGroup.enableGroup(local.myParams.groupedElemId)>
			</cfif>
		
		<!--- else if it's not in the form and enabled, disable it --->
		<cfelseif not listFindNoCase(arguments.form.fieldNames, "groupedElemEnabled_" & local.myParams.groupedElemPublicId) 
				and local.myParams.groupedElemDisabledDate eq "">
			<cfset variables.myGroup.disableGroupedElem(local.myParams.id)>
			
			<!--- if this element is a group, disable the group, too --->
			<cfif local.myParams.groupedElemTable eq "t_group">
				<cfset variables.myGroup.disableGroup(local.myParams.groupedElemId)>
			</cfif>
		</cfif>
		
		<!--- if the param is in the form and the label has been changed--->
		<cfif listFindNoCase(arguments.form.fieldNames, "groupedElemLabel_" & local.myParams.groupedElemPublicId)
				and local.myParams.groupedElemLabel neq trim(evaluate("arguments.form.groupedElemLabel_" & local.myParams.groupedElemPublicId))>

			<!--- set the groupedElemLabel for this element --->
			<cfinvoke method="setGroupedElemLabel" component="#variables.myGroup#">
				<cfinvokeargument name="id" value="#local.myParams.id#">
				<cfinvokeargument name="groupedElemLabel" value="#trim(evaluate('arguments.form.groupedElemLabel_' & local.myParams.groupedElemPublicId))#">
			</cfinvoke>
		</cfif>
		
		<!--- if the param is in the form and the value has been changed--->
		<cfif listFindNoCase(arguments.form.fieldNames, "groupedElemValue_" & local.myParams.groupedElemPublicId)
				and local.myParams.groupedElemValue neq trim(evaluate("arguments.form.groupedElemValue_" & local.myParams.groupedElemPublicId))>

			<!--- set the groupedElemValue for this element --->
			<cfinvoke method="setGroupedElemValue" component="#variables.myGroup#">
				<cfinvokeargument name="id" value="#local.myParams.id#">
				<cfinvokeargument name="groupedElemValue" value="#trim(evaluate('arguments.form.groupedElemValue_' & myParams.groupedElemPublicId))#">
			</cfinvoke>
		</cfif>
	</cfloop>
</cffunction>





</cfcomponent>