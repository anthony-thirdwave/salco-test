<cfcomponent output="false" displayname="TopicHandler">


	<cffunction name="GetTopicQuery" output="false" returntype="query">

		<cfset var local = structNew() />

		<cfquery name="local.GetTaxonomyDisplayOrder" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT	c.DisplayOrder
			FROM	t_category c
			JOIN	t_label l
			ON		l.LabelName = <cfqueryparam value="Taxonomy" cfsqltype="cf_sql_varchar">
					AND l.LabelCode = <cfqueryparam value="3WCAT" cfsqltype="cf_sql_varchar">
			WHERE	c.CategoryTypeId = l.labelId
		</cfquery>

		<cfquery name="local.GetTopic" datasource="#APPLICATION.DSN#">
			SELECT		c.CategoryID AS TopicID, c.CategoryName as TopicName, c.CategoryAlias as TopicAlias,
						c.DisplayLevel
			FROM		t_category c
			JOIN		t_label l
			ON			l.LabelName = <cfqueryparam value="Topic" cfsqltype="cf_sql_varchar">
						AND l.LabelCode = <cfqueryparam value="3WCAT" cfsqltype="cf_sql_varchar">
			WHERE		c.CategoryTypeID = l.labelId
			AND			c.DisplayOrder LIKE <cfqueryparam value="#local.GetTaxonomyDisplayOrder.DisplayOrder#%" cfsqltype="cf_sql_varchar">
			ORDER BY	c.DisplayOrder
		</cfquery>

		<cfreturn local.GetTopic>
	</cffunction>



	<cffunction name="GetRelatedTopics" output="false" returntype="query">
		<cfargument name="EntityID" required="yes" type="numeric">
		<cfargument name="EntityName" required="yes" type="string">
		<cfargument name="DSN" required="no" default="#APPLICATION.DSN#">

		<cfset var local = structNew() />

		<cfquery name="local.GetTopics" datasource="#ARGUMENTS.DSN#">
			SELECT		t.CategoryID AS topicID, t.CategoryName as TopicName, t.CategoryAlias as TopicAlias
			FROM		t_TopicRelated tr
				INNER JOIN	t_category t
				ON			t.CategoryID = tr.TopicID
			WHERE		tr.EntityID = <cfqueryparam value="#Val(ARGUMENTS.EntityID)#" cfsqltype="cf_sql_integer">
			AND			tr.EntityName = <cfqueryparam value="#ARGUMENTS.EntityName#" cfsqltype="cf_sql_varchar">
			ORDER BY	TopicName
		</cfquery>

		<cfreturn local.GetTopics>
	</cffunction>



	<cffunction name="InsertRelatedTopics" output="false" returntype="boolean">
		<cfargument name="EntityID" required="yes" type="numeric">
		<cfargument name="EntityName" required="yes" type="string">
		<cfargument name="lTopicID" required="yes" type="string">
		<cfargument name="DSN" required="no" default="#APPLICATION.DSN#">

		<cfset var local = structNew() />

		<cfset DeleteRelatedTopics(ARGUMENTS.EntityID,ARGUMENTS.EntityName,ARGUMENTS.DSN)>

		<cfloop list="#ARGUMENTS.lTopicID#" index="local.TopicID">
			<cfquery name="InsertTopic" datasource="#ARGUMENTS.DSN#">
				INSERT INTO	t_TopicRelated (EntityID,TopicID,EntityName)
				VALUES(
					<cfqueryparam value="#Val(ARGUMENTS.EntityID)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Val(local.TopicID)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#ARGUMENTS.EntityName#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfloop>
		<cfreturn true>
	</cffunction>



	<cffunction name="DeleteRelatedTopics" output="false" returntype="boolean">
		<cfargument name="EntityID" required="yes" type="numeric">
		<cfargument name="EntityName" required="yes" type="string">
		<cfargument name="DSN" required="no" default="#APPLICATION.DSN#">

		<cfset var local = structNew() />

		<cfquery name="local.DeleteTopics" datasource="#ARGUMENTS.DSN#">
			DELETE FROM	t_TopicRelated
			WHERE		EntityID = <cfqueryparam value="#Val(ARGUMENTS.EntityID)#" cfsqltype="cf_sql_integer">
			AND			EntityName = <cfqueryparam value="#ARGUMENTS.EntityName#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn true>
	</cffunction>


</cfcomponent>