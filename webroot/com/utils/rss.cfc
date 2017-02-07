<cfcomponent>

	<!--- grabs and parses a file with the cached results of an RSS feed --->
	<cffunction name="ParseRSSItems" output="false" returntype="struct">
		<cfargument name="filePath" required="yes" type="string">

		<!--- init vars --->
		<cfset var local = structNew() />
		<cfset local.returnStruct = structNew() />
		<cfset local.rawProps = structNew() />

		<!--- set some defaults --->
		<cfset local.returnStruct.queryRSS = "" />
		<cfset local.local.returnStruct.propsRSS = structNew() />
		<cfset local.returnStruct.propsRSS.title = "" />
		<cfset local.returnStruct.propsRSS.link = "" />

		<!--- read the feed - return items in a query and properties in a struct --->
		<cffeed action="read" source="#arguments.filePath#" query="local.returnStruct.queryRSS" properties="local.rawProps">

		<!--- if RSS --->
		<cfif structKeyExists(local.rawProps, "version")
				and getToken(local.rawProps.version, 1, "_") eq "rss">

			<cfif structKeyExists(local.rawProps, "title")>
				<cfset local.returnStruct.propsRSS.title = local.rawProps.title>
			</cfif>
			<cfif structKeyExists(local.rawProps, "link")>
				<cfset local.returnStruct.propsRSS.link = local.rawProps.link>
			</cfif>

		<!--- if atom --->
		<cfelseif structKeyExists(local.rawProps, "version")
					and getToken(local.rawProps.version, 1, "_") eq "atom">

			<!--- convert the atom values into the values we need --->
			<cfif structKeyExists(local.rawProps, "title") and structKeyExists(local.rawProps.title, "value")>
				<cfset local.returnStruct.propsRSS.title = local.rawProps.title.value />
			</cfif>

			<!--- get the first link --->
			<cfif isArray(local.rawProps.link) and arrayLen(local.rawProps.link) gt 0>
				<cfset local.returnStruct.propsRSS.link = local.rawProps.link[1].href />
			</cfif>
		</cfif>

		<!--- return the struct with the query of items and struct of properties --->
		<cfreturn local.returnStruct>
	</cffunction>
</cfcomponent>