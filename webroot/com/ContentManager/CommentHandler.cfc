<cfcomponent displayname="CommentHandler" output="false">

	<cffunction name="init" returntype="CommentHandler">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPublicComments" access="public" returntype="query" output="false" hint="Displays comments that are not Suspended, Draft or Delete">
		<cfargument name="EntityName" default="" type="string" required="true">
		<cfargument name="EntityID" default="" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.getComments" datasource="#APPLICATION.DSN#">
			SELECT LinkURL,Comment,DateCreated,Name,CommentID,SenderID, HideURL, UserFirstName, UserMiddleName, UserLastName FROM qry_GetComment 
			WHERE EntityName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.EntityName#">
			AND EntityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.EntityID#">
			AND StatusID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1092,1093,1094" list="Yes">)
			ORDER BY DateCreated
		</cfquery>

		<cfreturn LOCAL.GetComments>
	</cffunction>
	
	<cffunction name="formatComment" returntype="string" output="false">
		<cfargument name="input" type="string" required="yes">
		<cfset VAR LOCAL=StructNew()>
		<cfset LOCAL.ReturnValue=Trim(Replace(APPLICATION.utilsObj.ParseLinks(APPLICATION.utilsObj.RemoveHTML(ARGUMENTS.Input)),"#Chr(13)##Chr(10)#","<br/>","all"))>
		<cfreturn LOCAL.ReturnValue>
	</cffunction>
	
	<cffunction name="InsertComment" access="public" returntype="boolean" output="false">
		<cfargument name="EntityName" default="" type="string" required="true">
		<cfargument name="EntityID" default="" type="numeric" required="true">
		<cfargument name="CommenterName" default="" type="string" required="true">
		<cfargument name="emailAddress" default="" type="string" required="true">
		<cfargument name="linkURL" default="" type="string" required="true">
		<cfargument name="comment" default="" type="string" required="true">
		<cfargument name="senderID" default="" type="numeric" required="true">
		<cfargument name="statusID" default="1090" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfif ARGUMENTS.senderID EQ "">
			<cfset LOCAL.senderIdNull="yes">
		<cfelse>
			<cfset LOCAL.senderIdNull="no">
		</cfif>
		<cfif ARGUMENTS.statusID EQ "">
			<cfset LOCAL.statusIdNull="yes">
		<cfelse>
			<cfset LOCAL.statusIdNull="no">
		</cfif>
		
		<cfquery name="LOCAL.insertComment" datasource="#APPLICATION.DSN#">
			INSERT INTO t_Comment (EntityID,EntityName,Name,EmailAddress,LinkURL,Comment,SenderID,StatusID)
			VALUES(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.EntityID#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.EntityName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.CommenterName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.emailAddress#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.linkURL#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ARGUMENTS.comment#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.senderID#" null="#LOCAL.senderIdNull#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.statusID#" null="#LOCAL.statusIdNull#">
			)
		</cfquery>

		<cfreturn 1>
	</cffunction>
</cfcomponent>