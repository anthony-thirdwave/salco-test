<cfcomponent>

	<!--- grabs and parses a file with the cached results of an RSS feed ---> 
	<cffunction name="ParseRSSItems" output="false" returntype="struct">
		<cfargument name="filePath" required="yes" type="string">
		
		<!--- init vars --->
		<cfset var returnStruct = structNew() />
		<cfset var rawProps = structNew() />
		
		<!--- set some defaults --->
		<cfset returnStruct.queryRSS = "" />
		<cfset returnStruct.propsRSS = structNew() />
		<cfset returnStruct.propsRSS.title = "" />
		<cfset returnStruct.propsRSS.link = "" />
		
		<!--- read the feed - return items in a query and properties in a struct --->
		<cffeed action="read" source="#arguments.filePath#" query="returnStruct.queryRSS" properties="rawProps">
		
		<!--- if RSS --->
		<cfif structKeyExists(rawProps, "version") 
				and getToken(rawProps.version, 1, "_") eq "rss">
			<cfset returnStruct.propsRSS.title = rawProps.title>
			<cfset returnStruct.propsRSS.link = rawProps.link>
			
		<!--- if atom --->
		<cfelseif structKeyExists(rawProps, "version") 
					and getToken(rawProps.version, 1, "_") eq "atom">
			
			<!--- convert the atom values into the values we need --->
			<cfif structKeyExists(rawProps.title, "value")>
				<cfset returnStruct.propsRSS.title = rawProps.title.value />
			</cfif>
			
			<!--- get the first link --->
			<cfif isArray(rawProps.link) and arrayLen(rawProps.link) gt 0>
				<cfset returnStruct.propsRSS.link = rawProps.link[1].href />
			</cfif>
		</cfif>

		<!--- return the struct with the query of items and struct of properties --->
		<cfreturn returnStruct>
	</cffunction>
</cfcomponent>