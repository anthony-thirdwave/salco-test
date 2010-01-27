<cfcomponent output="false" hint="Returns a message based upon passed parameters.">

<cffunction name="init" returntype="Message">
	<cfreturn this>
</cffunction>

<!--- get the message and replace passed tokens with passed values --->
<cffunction name="getMessage" output="false" access="remote">
	<cfargument name="messageKey" default="">
	<cfargument name="tokenArray" type="array" default="#arrayNew(1)#">
	<cfargument name="returnAsStruct" type="boolean" default="false">
	
	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	
	<!--- get the results --->
	<cfquery name="local.getMessage" datasource="#APPLICATION.DSN#">
		SELECT messageId, messageKey, messageLabel, message
		FROM t_message
		WHERE messageKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.messageKey#">
	</cfquery>

	<!--- grab the raw message --->
	<cfset local.message = local.getMessage.message />
	
	<!--- loop through the token array and do replacements on the returned string --->
	<cfloop array="#arguments.tokenArray#" index="local.itr">
		<cfset local.message = replaceNoCase(local.getMessage.message, local.itr.token, local.itr.value) />
	</cfloop>

	<!--- if the request is to return this as a struct --->
	<cfif arguments.returnAsStruct>
		<cfinvoke method="createMessageStruct" returnvariable="local.getMessage">
			<cfinvokeargument name="messageLabel" value="#local.getMessage.messageLabel#">
			<cfinvokeargument name="message" value="#local.message#">
		</cfinvoke>
	</cfif>
	
	<!--- return the query --->
	<cfreturn local.getMessage />
</cffunction>



<!--- get the message and replace passed tokens with passed values --->
<cffunction name="createTokenStruct" output="false" returntype="struct" access="remote">
	<cfargument name="token" type="string" required="true">
	<cfargument name="value" type="string" required="true">
	
	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	
	<!--- set the values --->
	<cfset local.token = arguments.token>
	<cfset local.value = arguments.value>
	
	<cfreturn local />
</cffunction>



<!--- get the message and replace passed tokens with passed values --->
<cffunction name="createMessageStruct" output="false" returntype="struct">
	<cfargument name="messageLabel" type="string" required="true">
	<cfargument name="message" type="string" required="true">
	
	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	
	<!--- get the values - do them individually to keep case sensitivity --->
	<cfset "local.returnStruct.messageLabel" = arguments.messageLabel />
	<cfset "local.returnStruct.message" = arguments.message />
	
	<cfreturn local.returnStruct />
</cffunction>
		
		


</cfcomponent>