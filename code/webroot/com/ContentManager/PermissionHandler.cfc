<cfcomponent>
	<!--- IsUserAuthorized --->
	<cffunction name="IsUserAuthorized" access="public" returntype="boolean" output="true"
		hint="This takes a list of userroles and a category id and determines if the user is authorized">
		
		<!--- init variables --->
		<cfset var isValid = "">
		<cfset var i = "">
		<cfset var j = "">
		<cfset var GroupList = "">
		
		<cfargument name="UserRoles" type="string" required="true"
			hint="list of user roles"/>
		<cfargument name="CategoryID" type="numeric" required="true"
			hint="the categoryID to check against"/>
		
		<!--- establish return - guilty until proven innocent --->
		<cfset isValid = false/>
		<!--- get the front end permissions --->
		<cfinvoke component="com.ContentManager.CategoryHandler" method="GetCategoryFrontEndPermissionsList" returnVariable="GroupList">
			<cfinvokeargument name="CategoryID" value="#Arguments.CategoryID#">
		</cfinvoke>	
		<cfif listlen(#Grouplist#) eq -1> <!--- nobody is allowed to see this --->
			<cfreturn isValid/>
		<cfelse> <!--- we have a result --->
			<cfloop list="#GroupList#" index="i">
				<cfloop list="#arguments.UserRoles#" index="j">
					<cfif #i# eq #j#>
						<cfset isValid = true/>
						<cfbreak/>
					</cfif>
					<cfif isValid is true>
						<cfbreak/>
					</cfif>
				</cfloop>
			</cfloop>
		</cfif> <!--- is anybody allowed to see --->
		<!--- return the verdict --->
		<cfreturn isValid/>
	</cffunction> <!--- IsUserAuthorized --->
</cfcomponent>