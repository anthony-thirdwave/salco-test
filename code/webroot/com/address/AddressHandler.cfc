<cfcomponent hint="Handles address management.">

	<cffunction name="init" returntype="AddressHandler">
		<cfreturn this>
	</cffunction>


	<!--- get an address  --->
	<cffunction name="getAddress" output="false">
		<cfargument name="addressId"  default="">
		<cfargument name="publicId" default="">

		<!--- keep scope local to function --->
		<cfset var local = structNew() />

		<!--- if a publicId is passed, set arguments.addressId--->
		<cfif trim(arguments.publicId) neq "">
			<cfinvoke method="getAddressIdByPublicId" returnvariable="arguments.addressId">
				<cfinvokeargument name="publicId" value="#trim(arguments.publicId)#">
			</cfinvoke>
		</cfif>

		<!--- create a factory object --->
		<cfset local.address = createObject("component", "com.factory.thirdwave.FactoryObject") />

		<!--- init the factory object as type address --->
		<cfset local.address.init("3W:Address") />

		<!--- if this is a valid id, then get the corresponding address --->
		<cfset local.address.constructor(val(arguments.addressId)) />

		<!--- return the results --->
		<cfreturn local.address>
	</cffunction>




	<!--- get an addressID by publicId  --->
	<cffunction name="getAddressIdByPublicId" returntype="string" output="false">
		<cfargument name="publicId" required="true" type="string">

		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		<cfset local.addressId = 0 />

		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
			SELECT	addressId, publicId
			FROM	t_Address
			WHERE	publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicId#">
		</cfquery>

		<cfif local.getResults.recordcount>
			<cfset local.addressId = local.getResults.addressId />
		</cfif>

		<!--- return the results --->
		<cfreturn local.addressId>
	</cffunction>


</cfcomponent>