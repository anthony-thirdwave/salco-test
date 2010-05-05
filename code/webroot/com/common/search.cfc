<cfcomponent>
	<cffunction name="CreateExplicitSearchString" access="public" returntype="string" output="false">
		<cfargument name="SearchString" type="string" required="true">

		<!--- init variables --->
		<cfset var ExpKW = ReplaceNoCase(Arguments.SearchString,'"','','ALL')/>
		<cfset var criteria = "">
		<cfset var thisGuy = "">
		<cfset var i = "">

		<cfset ExpKW = ReplaceNoCase(ExpKW,",","","All")/>

		<!--- we need to do some parsing of this expression and get it into the criteria --->
		<cfset criteria = "CF_TITLE <CONTAINS>" & #ExpKW#/>
		<cfif listlen(#Arguments.SearchString#) gt 1>
			<!--- we have a list - first handle keywords as we will never use many with them --->
			<cfloop list="#Trim(Arguments.SearchString)#" index="i">
				<!--- check for quote to prevent stemming --->
				<cfif i neq "" and i neq " ">
					<cfif FindOneOf('"',#i#) neq 0>
						<!--- explicit - no stemming --->
						<cfset thisGuy = #ReplaceNoCase(i,'"','','All')#/>
						<cfset criteria = criteria & " OR CF_TITLE <CONTAINS>" & #Trim(thisGuy)#/>
					<cfelse>
						<cfset criteria = criteria & " OR CF_TITLE <CONTAINS><STEM>" & #i#/>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfif listlen(#Arguments.SearchString#) gt 1>
			<!--- we have a list - now handle body --->
			<cfloop list="#Trim(Arguments.SearchString)#" index="i">
				<!--- check for quote to prevent stemming --->
				<cfif i neq "" and i neq " ">
					<cfif FindOneOf('"',#i#) neq 0>
						<!--- explicit - no stemming --->
						<cfset thisGuy = #ReplaceNoCase(i,'"','','All')#/>
						<cfset criteria = criteria & " OR '" & #Trim(thisGuy)# & "'"/>
					<cfelse>
						<cfset criteria = criteria & " OR <MANY><STEM>" & #i#/>
					</cfif>
				</cfif>
			</cfloop>
		<cfelse>
			<!--- no list --->
			<cfif FindOneOf('"',#Arguments.SearchString#) neq 0>
				<cfset thisGuy = #ReplaceNoCase(Arguments.SearchString,'"','','All')#/>
				<cfset criteria = criteria & " OR '" & #Trim(thisGuy)# & "'"/>
			<cfelse>
				<cfset criteria = criteria & " OR <MANY><STEM>" & #Trim(Arguments.SearchString)#/>
			</cfif>
		</cfif>
		<cfreturn criteria>
	</cffunction>
</cfcomponent>