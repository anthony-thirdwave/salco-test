<cfcomponent output="false" displayname="TopicHandler">
	<!--- GetTopicQuery: recursive function to build topic query --->
	<cffunction name="GetTopicQuery" output="false" returntype="query">
	
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.GetTopic" datasource="#APPLICATION.DSN#">
			select CategoryID as TopicID, CategoryName as TopicName, CategoryAlias as TopicAlias, DisplayLevel
			From t_category
			where
			CategoryTypeID = <cfqueryparam value="76" cfsqltype="cf_sql_integer">
			Order by DisplayOrder
		</cfquery>
		
		<cfreturn LOCAL.GetTopic>
	</cffunction>
	
	<cffunction name="GetRelatedTopics" output="false" returntype="query">
		<cfargument name="EntityID" required="yes" type="numeric">
		<cfargument name="EntityName" required="yes" type="string">
		<cfargument name="DSN" required="no" default="#APPLICATION.DSN#">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.GetTopics" datasource="#ARGUMENTS.DSN#">
			SELECT t.CategoryID AS topicID,t.CategoryName as TopicName, t.CategoryAlias as TopicAlias
			FROM t_TopicRelated tr
				INNER JOIN t_category t ON t.CategoryID = tr.TopicID
			WHERE tr.EntityID = <cfqueryparam value="#Val(ARGUMENTS.EntityID)#" cfsqltype="cf_sql_integer">
			AND tr.EntityName = <cfqueryparam value="#ARGUMENTS.EntityName#" cfsqltype="cf_sql_varchar">
			ORDER BY TopicName
		</cfquery>
		
		<cfreturn LOCAL.GetTopics>
	</cffunction>
	
	<cffunction name="InsertRelatedTopics" output="false" returntype="boolean">
		<cfargument name="EntityID" required="yes" type="numeric">
		<cfargument name="EntityName" required="yes" type="string">
		<cfargument name="lTopicID" required="yes" type="string">
		<cfargument name="DSN" required="no" default="#APPLICATION.DSN#">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfset DeleteRelatedTopics(ARGUMENTS.EntityID,ARGUMENTS.EntityName,ARGUMENTS.DSN)>
		
		<cfloop list="#ARGUMENTS.lTopicID#" index="LOCAL.topicID">
			<cfquery name="InsertTopic" datasource="#ARGUMENTS.DSN#">
				INSERT INTO t_TopicRelated (EntityID,TopicID,EntityName)
				VALUES(
					<cfqueryparam value="#Val(ARGUMENTS.EntityID)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Val(LOCAL.TopicID)#" cfsqltype="cf_sql_integer">,
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
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.DeleteTopics" datasource="#ARGUMENTS.DSN#">
			DELETE FROM t_TopicRelated 
			WHERE EntityID = <cfqueryparam value="#Val(ARGUMENTS.EntityID)#" cfsqltype="cf_sql_integer">
			AND EntityName = <cfqueryparam value="#ARGUMENTS.EntityName#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
</cfcomponent>