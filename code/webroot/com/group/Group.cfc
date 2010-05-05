<cfcomponent hint="Handles grouped elements.">

<cffunction name="init" returntype="Group" output="false">
	<cfreturn this />
</cffunction>


<!--- get a group --->
<cffunction name="getGroupById" returntype="query" output="false">
	<cfargument name="groupId" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the group --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT	groupId, groupAlias, groupDescription, groupById, groupByColumn, groupByTable, groupDateDisabled
		FROM	t_group
		WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
	</cfquery>

	<!--- return the results --->
	<cfreturn local.getResults />
</cffunction>



<!--- get matching groups --->
<cffunction name="getGroups" returntype="query" output="false">
	<cfargument name="groupAlias" required="true" type="string">
	<cfargument name="groupById" default="">
	<cfargument name="groupByColumn" default="">
	<cfargument name="groupByTable" default="">
	<cfargument name="getDisabled" type="boolean" default="true">
	<cfargument name="getMaster" type="boolean" default="false">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the group --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT	groupId, groupAlias, groupDescription, groupById, groupByColumn, groupByTable, groupDateDisabled
		FROM	t_group
		WHERE

		<!--- if the groupAlias is "", then get *all* groups matching the passed criteria --->
		<cfif len(trim(arguments.groupAlias))>
			groupAlias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupAlias)#" />
		<cfelse>
			1=1
		</cfif>

		<!--- if this relates to a specific id --->
		<cfif val(trim(arguments.groupById))
				and len(trim(arguments.groupByColumn))
				and len(trim(arguments.groupByTable))>
			AND	groupById = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.groupById)#" />
			AND	groupByColumn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupByColumn)#" />
			AND	groupByTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupByTable)#" />

		<!--- get the master if requested --->
		<cfelseif arguments.getMaster>
			AND	groupIsMaster = 1

		<!--- else, get nothing --->
		<cfelse>
			AND	1 = 0
		</cfif>

		<!--- should we return disabled groups? --->
		<cfif not arguments.getDisabled>
			AND	groupDateDisabled IS NULL
		</cfif>
	</cfquery>

	<!--- return the results --->
	<cfreturn local.getResults />
</cffunction>







<!--- get the cloned groups of the master group --->
<cffunction name="getClonedGroups" returntype="query" output="false">
	<cfargument name="groupAlias" required="true" type="string">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the clones --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT	g3.groupId, g3.groupAlias, g3.groupDescription, g3.groupById, g3.groupByColumn,
				g3.groupByTable, g3.groupDateDisabled
		FROM	t_group g

		JOIN	t_group g2
		ON		g2.groupById = g.groupId
		AND		g2.groupAlias = <cfqueryparam cfsqltype="cf_sql_varchar" value="cloneAliasGroup" />

		JOIN	t_groupedElem ge
		ON		ge.groupId = g2.groupId

		JOIN	t_group g3
		ON		g3.groupId = ge.groupedElemId

		WHERE	g.groupAlias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupAlias)#" />
		AND		g.groupIsMaster = <cfqueryparam cfsqltype="cf_sql_integer" value="1" />
	</cfquery>

	<!--- return the results --->
	<cfreturn local.getResults />
</cffunction>




<!--- get the children groups of a group  --->
<cffunction name="getChildrenGroups" returntype="query" output="false">
	<cfargument name="groupId" required="true" type="numeric">
	<cfargument name="includeParent" default="false" type="boolean">
	<cfargument name="includeSelf" default="false" type="boolean">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the children groups --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">

		<!--- prepend the parent if requested --->
		<cfif arguments.includeParent>
			SELECT	g2.groupId, g2.groupAlias, g2.groupDescription, g2.groupById, g2.groupByColumn, g2.groupByTable,
					g2.groupDateDisabled
			FROM	t_group g

			JOIN	t_groupedElem ge
			ON		ge.groupedElemId = g.groupId

			JOIN	t_group g2
			ON		g2.groupId = ge.groupId

			WHERE	g.groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
			AND		ge.groupedElemTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="t_group" />
			UNION ALL
		</cfif>

		<!--- prepend self if requested --->
		<cfif arguments.includeSelf>
			SELECT	groupId, groupAlias, groupDescription, groupById, groupByColumn, groupByTable,
					groupDateDisabled
			FROM	t_group
			WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
			UNION ALL
		</cfif>

		SELECT 		g2.groupId, g2.groupAlias, g2.groupDescription, g2.groupById, g2.groupByColumn, g2.groupByTable,
					g2.groupDateDisabled
		FROM		t_group g

		JOIN		t_groupedElem ge
		ON			ge.groupId = g.groupId

		JOIN		t_group g2
		ON			g2.groupId = ge.groupedElemId

		WHERE		g.groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
		AND			ge.groupedElemTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="t_group" />
	</cfquery>

	<!--- return the results --->
	<cfreturn local.getResults />
</cffunction>




<!--- get the elements of a group --->
<cffunction name="getGroupedElems" returntype="query" output="false">
	<cfargument name="groupAlias" required="true" type="string">
	<cfargument name="groupById" default="">
	<cfargument name="groupByColumn" default="">
	<cfargument name="groupByTable" default="">
	<cfargument name="getDisabled" type="boolean" default="true">
	<cfargument name="rankHorizontal" type="boolean" default="false">
	<cfargument name="getMaster" type="boolean" default="false">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the search params --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT		ge.rank, ge.id, ge.groupedElemId, ge.groupedElemColumn, ge.groupedElemTable,
					ge.groupedElemDisabledDate, ge.groupedElemDisplayType, ge.groupedElemType, ge.groupedElemLabel,
					ge.groupedElemValue, ge.groupedElemPublicId, ge.groupId, ge.horizontalRank,
					g.groupDateDisabled, g.groupById, g.groupByTable, g.groupByColumn
		FROM		t_group g

		JOIN		t_groupedElem ge
		ON			ge.groupId = g.groupId

		WHERE		g.groupAlias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupAlias)#" />

		<!--- if this relates to a specific id --->
		<cfif val(arguments.groupById)
				and len(trim(arguments.groupByColumn))
				and len(trim(arguments.groupByTable))>
			AND 	g.groupById = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.groupById)#" />
			AND 	g.groupByColumn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupByColumn)#" />
			AND 	g.groupByTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupByTable)#" />

		<!--- get the master if requested --->
		<cfelseif arguments.getMaster>
			AND		g.groupIsMaster = <cfqueryparam cfsqltype="cf_sql_integer" value="1" />
		</cfif>

		<!--- check if disabled elements should be returned --->
		<cfif not arguments.getDisabled>
			AND		ge.groupedElemDisabledDate IS NULL
		</cfif>

		ORDER BY <cfif arguments.rankHorizontal>ge.horizontalRank, </cfif>ge.rank
	</cfquery>

	<!--- return the results --->
	<cfreturn local.getResults />
</cffunction>








<!--- get groupedElems by groupId --->
<cffunction name="getGroupedElemsByGroupId" returntype="query" output="false">
	<cfargument name="groupId" required="true" type="numeric">
	<cfargument name="groupedElemTable" default="">
	<cfargument name="groupedElemColumn" default="">
	<cfargument name="groupedElemId" default="">
	<cfargument name="getDisabled" type="boolean" default="true">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the search params --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT		rank, id, groupedElemId, groupedElemColumn, groupedElemTable, groupedElemDisabledDate,
					groupedElemDisplayType, groupedElemType, groupedElemLabel, groupedElemValue, groupedElemPublicId,
					horizontalRank
		FROM		t_groupedElem
		WHERE		groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />

		<!--- if the values specific to a record are filled in, use them --->
		<cfif len(trim(arguments.groupedElemTable)) and len(trim(arguments.groupedElemColumn)) and val(arguments.groupedElemID)>
			AND		groupedElemTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupedElemTable)#" />
			AND		groupedElemColumn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupedElemColumn)#" />
			AND		groupedElemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(arguments.groupedElemID)#" />
		</cfif>

		<!--- should we return disabled elems? --->
		<cfif not arguments.getDisabled>
			AND		groupedElemDisabledDate IS NULL
		</cfif>

		ORDER BY rank
	</cfquery>

	<!--- return the results --->
	<cfreturn local.getResults />
</cffunction>





<!--- copy a group --->
<cffunction name="copyGroup" output="false" returntype="numeric">
	<cfargument name="sourceGroupId" required="true" type="numeric">
	<cfargument name="targetGroupByTable"  required="true" type="string">
	<cfargument name="targetGroupByColumn" required="true" type="string">
	<cfargument name="targetGroupById" required="true" type="numeric">
	<cfargument name="targetDescription" type="string" default="">
	<cfargument name="copyGroupedElems" type="boolean" default="true">
	<cfargument name="groupAliasSuffix" type="string" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<cftry>

		<!--- copy the group --->
		<cfquery name="local.copyGroup" datasource="#APPLICATION.DSN#">
			SET NOCOUNT ON
			INSERT INTO t_group
					(groupAlias,
					groupByTable,
					groupByColumn,
					groupById,
					groupDescription)
			SELECT	groupAlias + <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupAliasSuffix)#" />,
					groupByTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.targetGroupByTable)#" />,
					groupByColumn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.targetGroupByColumn)#" />,
					groupById = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetGroupById#" />,
					groupDescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.targetDescription)#" />
			FROM	t_group
			WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sourceGroupId#" />

			SELECT SCOPE_IDENTITY() AS newId
			SET NOCOUNT OFF
		</cfquery>

		<!--- grab the new recordId --->
		<cfset local.recordId = local.copyGroup.newId />

		<cfcatch type="any">
			<cfreturn 0 />
		</cfcatch>
	</cftry>

	<!--- copy this group's elements if requested --->
	<cfif arguments.copyGroupedElems>
		<cfinvoke method="copyGroupedElements">
			<cfinvokeargument name="sourceGroupId" value="#arguments.sourceGroupId#" />
			<cfinvokeargument name="targetGroupId" value="#local.recordId#" />
		</cfinvoke>
	</cfif>

	<cfreturn local.recordId />
</cffunction>




<!--- copy grouped elements --->
<cffunction name="copyGroupedElements" output="false">
	<cfargument name="sourceGroupId" required="true" type="numeric">
	<cfargument name="targetGroupId" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the grouped elements of the sourceGroupId --->
	<cfquery name="local.getGroupedElems" datasource="#APPLICATION.DSN#">
		SELECT		groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetGroupId#" />,
					groupedElemColumn, groupedElemId, groupedElemTable, groupedElemDisabledDate, groupedElemDisplayType,
					groupedElemType, groupedElemLabel,
					groupedElemValue, rank,	horizontalRank
		FROM		t_groupedElem
		WHERE		groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sourceGroupId#" />
		ORDER BY	rank
	</cfquery>


	<!--- get the newly added target group if the source group has groupedElems --->
	<cfinvoke method="getGroupById" returnvariable="local.targetGroup">
		<cfinvokeargument name="groupId" value="#val(local.getGroupedElems.groupId)#" />
	</cfinvoke>

	<!--- loop through the query and add the new elems --->
	<cfloop query="local.getGroupedElems">

		<!--- if this grouped element points to a group, we need to see if the group exists
		for the copied groupedElem to point to --->
		<cfif local.getGroupedElems.groupedElemTable eq "t_group">

			<!--- get this element's source group --->
			<cfinvoke method="getGroupById" returnvariable="local.elementSourceGroup">
				<cfinvokeargument name="groupId" value="#local.getGroupedElems.groupedElemId#" />
			</cfinvoke>

			<cfif local.elementSourceGroup.recordcount eq 1>

				<!--- is there a matching group? --->
				<cfinvoke method="getGroups" returnvariable="local.elementTargetGroupExists">
					<cfinvokeargument name="groupAlias" value="#local.elementSourceGroup.groupAlias#" />
					<cfinvokeargument name="groupByTable" value="#local.targetGroup.groupByTable#" />
					<cfinvokeargument name="groupByColumn" value="#local.targetGroup.groupByColumn#" />
					<cfinvokeargument name="groupById" value="#local.targetGroup.groupById#" />
				</cfinvoke>

				<!--- if the group exists, use the groupId --->
				<cfif local.elementTargetGroupExists.recordcount eq 1>
					<cfset local.elementTargetGroupId = local.elementTargetGroupExists.groupId />

				<!--- else, copy the group --->
				<cfelse>
					<cfinvoke method="copyGroup" returnvariable="local.elementTargetGroupId">
						<cfinvokeargument name="sourceGroupId" value="#local.elementSourceGroup.groupId#" />
						<cfinvokeargument name="targetGroupByTable" value="#local.targetGroup.groupByTable#" />
						<cfinvokeargument name="targetGroupByColumn" value="#local.targetGroup.groupByColumn#" />
						<cfinvokeargument name="targetGroupById" value="#local.targetGroup.groupById#" />
						<cfinvokeargument name="targetDescription" value="#local.elementSourceGroup.groupDescription#" />
					</cfinvoke>
				</cfif>
			</cfif>

		<!--- else, this is a simple groupedElem --->
		<cfelse>
			<cfset local.elementTargetGroupId = local.getGroupedElems.groupedElemId />
		</cfif>

		<!--- insert the element --->
		<cfinvoke method="addGroupedElem">
			<cfinvokeargument name="groupId" value="#local.getGroupedElems.groupId#" />
			<cfinvokeargument name="groupedElemTable" value="#local.getGroupedElems.groupedElemTable#" />
			<cfinvokeargument name="groupedElemColumn" value="#local.getGroupedElems.groupedElemColumn#" />
			<cfinvokeargument name="groupedElemId" value="#local.elementTargetGroupId#" />
			<cfinvokeargument name="groupedElemDisabledDate" value="#local.getGroupedElems.groupedElemDisabledDate#" />
			<cfinvokeargument name="groupedElemDisplayType" value="#local.getGroupedElems.groupedElemDisplayType#" />
			<cfinvokeargument name="groupedElemType" value="#local.getGroupedElems.groupedElemType#" />
			<cfinvokeargument name="groupedElemLabel" value="#local.getGroupedElems.groupedElemLabel#" />
			<cfinvokeargument name="groupedElemValue" value="#local.getGroupedElems.groupedElemValue#" />
			<cfinvokeargument name="rank" value="#local.getGroupedElems.rank#" />
			<cfinvokeargument name="horizontalRank" value="#local.getGroupedElems.horizontalRank#" />
		</cfinvoke>
	</cfloop>
</cffunction>




<!--- enables a group --->
<cffunction name="enableGroup" output="false">
	<cfargument name="groupId" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- enable the group --->
	<cfquery name="local.enable" datasource="#APPLICATION.DSN#">
		UPDATE	t_group
		SET		groupDateDisabled = NULL
		WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
	</cfquery>
</cffunction>




<!--- disables a group --->
<cffunction name="disableGroup" output="false">
	<cfargument name="groupId" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- disable the group --->
	<cfquery name="local.disable" datasource="#APPLICATION.DSN#">
		UPDATE	t_group
		SET		groupDateDisabled = CURRENT_TIMESTAMP
		WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
	</cfquery>
</cffunction>




<!--- enables a grouped elem --->
<cffunction name="enableGroupedElem" output="false">
	<cfargument name="id" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- enable the groupedElem --->
	<cfquery name="local.enable" datasource="#APPLICATION.DSN#">
		UPDATE	t_groupedElem
		SET		groupedElemDisabledDate = NULL
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>




<!--- disables a grouped elem --->
<cffunction name="disableGroupedElem" output="false">
	<cfargument name="id" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- disable the groupedElem --->
	<cfquery name="local.disable" datasource="#APPLICATION.DSN#">
		UPDATE	t_groupedElem
		SET		groupedElemDisabledDate = CURRENT_TIMESTAMP
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>



<!--- set a groupedElemLabel --->
<cffunction name="setGroupedElemLabel" output="false">
	<cfargument name="id" required="true" type="numeric">
	<cfargument name="groupedElemLabel" required="true" type="string">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- set the groupedElemLabel --->
	<cfquery name="local.setValue" datasource="#APPLICATION.DSN#">
		UPDATE	t_groupedElem
		SET		groupedElemLabel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupedElemLabel)#" null="#not len(trim(arguments.groupedElemLabel))#" />
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>





<!--- set a groupedElemValue --->
<cffunction name="setGroupedElemValue" output="false">
	<cfargument name="id" required="true" type="numeric">
	<cfargument name="groupedElemValue" required="true" type="string">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- set the groupedElemValue --->
	<cfquery name="local.setValue" datasource="#APPLICATION.DSN#">
		UPDATE	t_groupedElem
		SET		groupedElemValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemValue#" null="#not len(trim(arguments.groupedElemValue))#" />
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>






<!--- set a groupedElemDisplayType --->
<cffunction name="setGroupedElemDisplayType" output="false">
	<cfargument name="id" required="true" type="numeric">
	<cfargument name="groupedElemDisplayType" required="true" type="string">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- set the groupedElemDisplayType --->
	<cfquery name="local.setValue" datasource="#APPLICATION.DSN#">
		UPDATE	t_groupedElem
		SET		groupedElemDisplayType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemDisplayType#" null="#not len(trim(arguments.groupedElemDisplayType))#" />
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>



<!--- getGroupedElemDisplayTypes --->
<cffunction name="getGroupedElemDisplayTypes" output="false" returntype="query">
	<cfargument name="groupedElemTable" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- set the groupedElemDisplayType --->
	<cfquery name="local.getDisplayTypes" datasource="#APPLICATION.DSN#">
		SELECT DISTINCT	groupedElemDisplayType
		FROM	t_groupedElem
		WHERE	groupedElemDisplayType IS NOT NULL

		<!--- determine which categories to display --->
		<cfif len(trim(arguments.groupedElemTable))>
			AND	groupedElemTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.groupedElemTable)#" />
		</cfif>
	</cfquery>

	<cfreturn local.getDisplayTypes />
</cffunction>







<!--- sync cloned groups with the master group --->
<cffunction name="syncClonesWithMaster" returntype="boolean" output="false">
	<cfargument name="groupAlias" required="true" type="string">
	<cfargument name="syncType" default="both">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- syncType determines if we add and/or delete records from cloned groups --->
	<cfswitch expression="#trim(arguments.syncType)#">

		<!--- just add records from master to clone --->
		<cfcase value="add">
			<cfset local.mySyncType = "add" />
		</cfcase>

		<!--- just delete records from master to clone --->
		<cfcase value="delete">
			<cfset local.mySyncType = "delete" />
		</cfcase>

		<!--- default to both --->
		<cfdefaultcase>
			<cfset local.mySyncType = "both" />
		</cfdefaultcase>
	</cfswitch>


	<!--- get the master groupedElems --->
	<cfinvoke method="getGroupedElems" returnvariable="local.masterGroupedElems">
		<cfinvokeargument name="groupAlias" value="#trim(arguments.groupAlias)#" />
		<cfinvokeargument name="getMaster" value="true" />
	</cfinvoke>

	<!--- get the cloned groups --->
	<cfinvoke method="getClonedGroups" returnvariable="local.clonedGroups">
		<cfinvokeargument name="groupAlias" value="#trim(arguments.groupAlias)#" />
	</cfinvoke>

	<!--- loop through the cloned groups --->
	<cfloop query="local.clonedGroups">

		<!--- get the cloned groupedElems --->
		<cfinvoke method="getGroupedElemsByGroupId" returnvariable="local.clonedGroupedElems">
			<cfinvokeargument name="groupId" value="#local.clonedGroups.groupId#" />
		</cfinvoke>

		<!--- add cloned groupedElems to match master --->
		<cfif local.mySyncType eq "both" or local.mySyncType eq "add">

			<!--- get the highest rank from the cloned groupedElems--->
			<cfquery name="local.highestRank" dbtype="query" maxrows="1">
				SELECT		rank
				FROM		[local].clonedGroupedElems
				ORDER BY	rank DESC
			</cfquery>

			<!--- see what's missing from the clone --->
			<cfquery name="local.missingFromClone" dbtype="query">
				SELECT	groupedElemTable, groupedElemColumn,	groupedElemId, groupedElemDisabledDate,
						groupedElemDisplayType,	groupedElemType, groupedElemLabel, groupedElemValue,
						horizontalRank
				FROM	[local].masterGroupedElems
				WHERE	groupedElemTable != <cfqueryparam cfsqltype="cf_sql_varchar" value="t_group" />

				<!--- only if there are existing values --->
				<cfif local.clonedGroupedElems.recordcount>
					AND groupedElemId NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(local.clonedGroupedElems.groupedElemId)#" list="true" />)
				</cfif>
			</cfquery>

			<!--- insert any missing groupedElems --->
			<cfinvoke method="addGroupedElemsByQuery">
				<cfinvokeargument name="elemsToAdd" value="#local.missingFromClone#" />
				<cfinvokeargument name="groupId" value="#local.clonedGroups.groupId#" />

				<!--- start at the next rank or 1 if there are no existing elems --->
				<cfif local.highestRank.recordcount>
					<cfinvokeargument name="startWithRank" value="#(local.highestRank.rank + 1)#" />
				<cfelse>
					<cfinvokeargument name="startWithRank" value="1" />
				</cfif>
			</cfinvoke>
		</cfif>

		<!--- delete cloned groupedElems to match master --->
		<cfif local.mySyncType eq "both" or local.mySyncType eq "delete">

			<!--- see what's missing from the master --->
			<cfquery name="local.missingFromMaster" dbtype="query">
				SELECT	id
				FROM	[local].clonedGroupedElems
				WHERE	groupedElemId NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(local.masterGroupedElems.groupedElemId)#" list="true" />)
				AND		groupedElemTable != <cfqueryparam cfsqltype="cf_sql_varchar" value="t_group" />
			</cfquery>

			<!--- delete any groupedElems from the clone that aren't in the master --->
			<cfinvoke method="deleteGroupedElemsByQuery">
				<cfinvokeargument name="elemsToDelete" value="#local.missingFromMaster#" />
			</cfinvoke>
		</cfif>

	</cfloop>

	<cfreturn true>
</cffunction>



<!--- add grouped elems by passing a query --->
<cffunction name="addGroupedElemsByQuery" output="false">
	<cfargument name="elemsToAdd" required="true" type="query">
	<cfargument name="groupId" required="true" type="numeric">
	<cfargument name="startWithRank" default="1">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<cfset local.myRank = val(arguments.startWithRank) />

	<!--- loop through the passed query --->
	<cfloop query="arguments.elemsToAdd">

		<!--- add the missing element --->
		<cfinvoke method="addGroupedElem">
			<cfinvokeargument name="groupId" value="#arguments.groupId#" />
			<cfinvokeargument name="groupedElemTable" value="#arguments.elemsToAdd.groupedElemTable#" />
			<cfinvokeargument name="groupedElemColumn" value="#arguments.elemsToAdd.groupedElemColumn#" />
			<cfinvokeargument name="groupedElemId" value="#arguments.elemsToAdd.groupedElemId#" />
			<cfinvokeargument name="groupedElemDisabledDate" value="#arguments.elemsToAdd.groupedElemDisabledDate#" />
			<cfinvokeargument name="groupedElemDisplayType" value="#arguments.elemsToAdd.groupedElemDisplayType#" />
			<cfinvokeargument name="groupedElemType" value="#arguments.elemsToAdd.groupedElemType#" />
			<cfinvokeargument name="groupedElemLabel" value="#arguments.elemsToAdd.groupedElemLabel#" />
			<cfinvokeargument name="groupedElemValue" value="#arguments.elemsToAdd.groupedElemValue#" />
			<cfinvokeargument name="rank" value="#local.myRank#" />
			<cfinvokeargument name="horizontalRank" value="#arguments.elemsToAdd.horizontalRank#" />
		</cfinvoke>

		<!--- increment the rank --->
		<cfset local.myRank = local.myRank + 1>
	</cfloop>
</cffunction>





<!--- delete grouped elems by passing a query --->
<cffunction name="deleteGroupedElemsByQuery" output="false">
	<cfargument name="elemsToDelete" required="true" type="query">

	<!--- loop through the passed query --->
	<cfloop query="arguments.elemsToDelete">

		<!--- delete the extra element --->
		<cfinvoke method="deleteGroupedElem">
			<cfinvokeargument name="id" value="#arguments.elemsToDelete.id#" />
		</cfinvoke>
	</cfloop>
</cffunction>




<!--- add group --->
<cffunction name="addGroup" output="false" returntype="numeric">
	<cfargument name="groupAlias" type="string" required="true">
	<cfargument name="groupByTable" type="string" default="">
	<cfargument name="groupByColumn" type="string" default="">
	<cfargument name="groupById" default="">
	<cfargument name="groupDescription" type="string" default="">
	<cfargument name="groupIsMaster" type="boolean" default="false">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<cfset local.recordId = 0 />

	<!--- get this group --->
	<cfinvoke method="getGroups" returnvariable="local.groupExists">
		<cfinvokeargument name="groupAlias" value="#arguments.groupAlias#" />
		<cfinvokeargument name="groupByTable" value="#arguments.groupByTable#" />
		<cfinvokeargument name="groupByColumn" value="#arguments.groupByColumn#" />
		<cfinvokeargument name="groupById" value="#arguments.groupById#" />
	</cfinvoke>

	<!--- if a single matching group exists, then return the groupId, if more than one exists, bail,
		otherwise, continue and add the group  --->
	<cfif local.groupExists.recordcount eq 1>
		<cfreturn local.groupExists.groupId />
	<cfelseif local.groupExists.recordcount gt 1>
		<cfreturn 0 />
	</cfif>

	<cftry>
		<!--- add the Group --->
		<cfquery name="local.addGroup" datasource="#APPLICATION.DSN#">
			SET NOCOUNT ON
			INSERT INTO t_group
				(groupAlias,
				groupByTable,
				groupByColumn,
				groupById,
				groupDescription,
				groupIsMaster)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupAlias#" null="#not len(trim(arguments.groupAlias))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupByTable#" null="#not len(trim(arguments.groupByTable))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupByColumn#" null="#not len(trim(arguments.groupByColumn))#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupById#" null="#not isNumeric(trim(arguments.groupById))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupDescription#" null="#not len(trim(arguments.groupDescription))#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.groupIsMaster)#" />
				)

			SELECT SCOPE_IDENTITY() AS newId
			SET NOCOUNT OFF
		</cfquery>

		<!--- grab and return the new recordId --->
		<cfset local.recordId = local.addGroup.newId />

		<cfcatch type="any">
			<cfreturn 0 />
		</cfcatch>
	</cftry>
	<cfreturn local.recordId />
</cffunction>




<!--- add grouped elem --->
<cffunction name="addGroupedElem" output="false" returntype="numeric">
	<cfargument name="groupId" required="true" type="numeric">
	<cfargument name="groupedElemTable" type="string" default="">
	<cfargument name="groupedElemColumn" type="string" default="">
	<cfargument name="groupedElemId" default="">
	<cfargument name="groupedElemDisabledDate" default="">
	<cfargument name="groupedElemDisplayType" default="">
	<cfargument name="groupedElemType" default="">
	<cfargument name="groupedElemLabel" default="">
	<cfargument name="groupedElemValue" default="">
	<cfargument name="rank" default="">
	<cfargument name="horizontalRank" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- create a uniqueId --->
	<cfset local.uniqueId = APPLICATION.utilsObj.createUniqueId() />
	<cfset local.recordId = "0" />

	<!--- get the min and max ranks for this group --->
	<cfinvoke method="getRankRange" returnvariable="local.rankRange">
		<cfinvokeargument name="groupId" value="#arguments.groupId#" />
	</cfinvoke>

	<!--- if there are existing grouped elems, get the next rank --->
	<cfif isNumeric(local.rankRange.maxRank)>
		<cfset local.maxRank = local.rankRange.maxRank + 1 />
	</cfif>

	<cftry>

		<!--- add the groupedElem --->
		<cfquery name="local.addElem" datasource="#APPLICATION.DSN#">
			SET NOCOUNT ON
			INSERT INTO t_groupedElem
				(groupId,
				groupedElemTable,
				groupedElemColumn,
				groupedElemId,
				groupedElemDisabledDate,
				groupedElemDisplayType,
				groupedElemType,
				groupedElemLabel,
				groupedElemValue,
				groupedElemPublicId,
				rank,
				horizontalRank)
			VALUES
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemTable#" null="#not len(trim(arguments.groupedElemTable))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemColumn#" null="#not len(trim(arguments.groupedElemColumn))#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupedElemId#" null="#not val(arguments.groupedElemId)#" />,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.groupedElemDisabledDate#" null="#not isDate(trim(arguments.groupedElemDisabledDate))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemDisplayType#" null="#not len(trim(arguments.groupedElemDisplayType))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemType#" null="#not len(trim(arguments.groupedElemType))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemLabel#" null="#not len(trim(arguments.groupedElemLabel))#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupedElemValue#" null="#not len(trim(arguments.groupedElemValue))#" />,

				<!--- always insert a uniqueId --->
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.uniqueId#" />,

				<!--- insert the passed rank if possible --->
				<cfif val(arguments.rank)>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.rank)#" />,
				<cfelse>

					<!--- if rank isn't passed, use the next value if it exists --->
					<cfif isDefined("local.maxRank") and val(local.maxRank)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#val(local.maxRank)#" />,

					<!--- otherwise, this is the first value --->
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1" />,
					</cfif>
				</cfif>
				<!--- horizontal rank --->
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horizontalRank#" null="#not val(arguments.horizontalRank)#" />
				)
			SELECT SCOPE_IDENTITY() AS newId
			SET NOCOUNT OFF
		</cfquery>

		<!--- grab and return the new recordId --->
		<cfset local.recordId = local.addElem.newId />

		<cfcatch type="any">
			<cfreturn 0 />
		</cfcatch>
	</cftry>

	<cfreturn local.recordId />
</cffunction>



<!--- delete grouped elem --->
<cffunction name="deleteGroupedElem" output="false">
	<cfargument name="id" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- delete the groupedElem --->
	<cfquery name="local.deleteElem" datasource="#APPLICATION.DSN#">
		DELETE FROM	t_groupedElem
		WHERE		id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>





<!--- change rank in a set of groupedElems  - can use either a public or an internal id--->
<cffunction name="rerankGroupedElems" output="false" returntype="boolean">
	<cfargument name="id" type="numeric" default="0">
	<cfargument name="publicId" type="string" default="">
	<cfargument name="newRank" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- if a publicId is passed, use it --->
	<cfif len(trim(arguments.publicId))>
		<cfinvoke method="getIdFromPublicId" returnvariable="arguments.id">
			<cfinvokeargument name="publicId" value="#trim(arguments.publicId)#" />
		</cfinvoke>
	</cfif>

	<cftransaction>

		<!--- get the current rank --->
		<cfquery name="local.getCurrentRank" datasource="#APPLICATION.DSN#">
			SELECT	groupId, rank
			FROM	t_groupedElem
			WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
		</cfquery>

		<!--- if there is no matching record, then return false --->
		<cfif not local.getCurrentRank.recordcount>
			<cfreturn false />
		</cfif>

		<!--- if the record is already at this rank, return true --->
		<cfif local.getCurrentRank.rank eq arguments.newRank>
			<cfreturn true />
		</cfif>

		<!--- get the min and max ranks for this group --->
		<cfinvoke method="getRankRange" returnvariable="local.rankRange">
			<cfinvokeargument name="groupId" value="#local.getCurrentRank.groupId#" />
		</cfinvoke>

		<!--- if the new rank is above or below the current range, return false --->
		<cfif arguments.newRank gt local.rankRange.maxRank or arguments.newRank lt local.rankRange.minRank>
			<cfreturn false />
		</cfif>

		<!--- if the current rank is greater than the new rank --->
		<cfif local.getCurrentRank.rank gt arguments.newRank>
			<cfquery name="local.moveElems" datasource="#APPLICATION.DSN#">
				SELECT	id, rank = rank + 1
				FROM	t_groupedElem
				WHERE	id
				IN		(
							SELECT	id
							FROM	t_groupedElem
							WHERE	rank >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newRank#" />
							AND		rank < <cfqueryparam cfsqltype="cf_sql_integer" value="#local.getCurrentRank.rank#" />
							AND		groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.getCurrentRank.groupId#" />
						)
			</cfquery>

		<!--- else if the current rank is less than the new rank --->
		<cfelse>
			<cfquery name="local.moveElems" datasource="#APPLICATION.DSN#">
				SELECT	id, rank = rank - 1
				FROM	t_groupedElem
				WHERE	id
				IN		(
							SELECT	id
							FROM	t_groupedElem
							WHERE	rank <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newRank#" />
							AND		rank > <cfqueryparam cfsqltype="cf_sql_integer" value="#local.getCurrentRank.rank#" />
							AND		groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.getCurrentRank.groupId#" />
						)
			</cfquery>
		</cfif>

		<!--- update the ranking for the necessary elements --->
		<cfloop query="local.moveElems">
			<cfinvoke method="setRank">
				<cfinvokeargument name="id" value="#local.moveElems.id#" />
				<cfinvokeargument name="rank" value="#local.moveElems.rank#" />
			</cfinvoke>
		</cfloop>

		<!--- rank the passed groupedElem --->
		<cfinvoke method="local.setRank">
			<cfinvokeargument name="id" value="#arguments.id#" />
			<cfinvokeargument name="rank" value="#arguments.newRank#" />
		</cfinvoke>

	</cftransaction>

	<cfreturn true />
</cffunction>



<!--- set a rank --->
<cffunction name="setRank" output="false" access="private">
	<cfargument name="id" required="true" type="numeric">
	<cfargument name="rank" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- rank the groupedElem --->
	<cfquery name="local.rankElem" datasource="#APPLICATION.DSN#">
		UPDATE	t_groupedElem
		SET		rank = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rank#" />
		WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
	</cfquery>
</cffunction>






<!--- get the top and bottom ranks for a set of groupedElems --->
<cffunction name="getRankRange" output="false" returntype="query">
	<cfargument name="groupId" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the rank range for this group --->
	<cfquery name="local.getRanks" datasource="#APPLICATION.DSN#">
		SELECT	max(rank) AS maxRank, min(rank) AS minRank
		FROM	t_groupedElem
		WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
	</cfquery>

	<!--- return the ranks --->
	<cfreturn local.getRanks />
</cffunction>







<!--- set a horizontalRank --->
<cffunction name="setHorizontalRank" output="false" returntype="boolean">
	<cfargument name="id" type="numeric" default="0">
	<cfargument name="publicId" type="string" default="">
	<cfargument name="newRank" required="true">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- if a publicId is passed, use it --->
	<cfif len(trim(arguments.publicId))>
		<cfinvoke method="getIdFromPublicId" returnvariable="arguments.id">
			<cfinvokeargument name="publicId" value="#arguments.publicId#" />
		</cfinvoke>
	</cfif>

	<cftry>
		<!--- set the horizontal rank --->
		<cfquery name="local.setRank" datasource="#APPLICATION.DSN#">
			UPDATE	t_groupedElem
			SET		horizontalRank = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newRank#" null="#not val(trim(arguments.newRank))#" />
			WHERE	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
		</cfquery>

		<cfcatch>
			<cfreturn false />
		</cfcatch>
	</cftry>

	<cfreturn true />
</cffunction>



<!--- get the top and bottom horizontalRanks for a set of groupedElems --->
<cffunction name="getHorizontalRankRange" output="false" returntype="query">
	<cfargument name="groupId" required="true" type="numeric">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the rank range for this group --->
	<cfquery name="local.getRanks" datasource="#APPLICATION.DSN#">
		SELECT	max(horizontalRank) AS maxRank, min(horizontalRank) AS minRank
		FROM	t_groupedElem
		WHERE	groupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
		AND		horizontalRank IS NOT NULL
	</cfquery>

	<!--- return the ranks --->
	<cfreturn local.getRanks />
</cffunction>




<!--- get an id from a publicId --->
<cffunction name="getIdFromPublicId" output="false" returntype="numeric">
	<cfargument name="publicId" required="true" type="string">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	<cfset local.thisId = 0 />

	<!--- get the id --->
	<cfquery name="local.getId" datasource="#APPLICATION.DSN#">
		SELECT id
		FROM t_groupedElem
		WHERE groupedElemPublicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.publicId)#" />
	</cfquery>

	<cfreturn val(local.getId.id) />
</cffunction>



</cfcomponent>