<cfcomponent output="false">
	<!--- Properties --->
	<cfproperty name="errorStruct" type="struct">
	<cfparam name="this.errorStruct" default="#structNew()#">

	<!--- Constructor --->
	<cffunction name="constructor" returntype="boolean" output="false">
		<cfset this.clear()>
		<cfreturn true>
	</cffunction>

	<!--- Has Error Occurred --->
	<cffunction name="hasErrorOccurred" returntype="boolean" output="false">
		<cfif (listlen(this.getErrorFields()) GT 0)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- Is In Error --->
	<cffunction name="isInError" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfif (listfindnocase(structkeylist(this.errorStruct),arguments.key))>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- Get Error Messages --->
	<cffunction name="getErrorMessages" returntype="array" output="false">
		<cfset var errorField = "">
		<cfset variables.errorMessages = arrayNew(1)>
		<cfloop list="#this.getErrorFields()#" index="errorField">
			<cfset arrayAppend(variables.errorMessages,this.getErrorMessage(errorField))>
		</cfloop>
		<cfreturn variables.errorMessages>
	</cffunction>

	<!--- Get Error Value --->
	<cffunction name="getErrorValue" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfif (this.isInError(key))>
			<cfreturn this.ErrorStruct[arguments.key].value>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- Add Error Item --->
	<cffunction name="add" returntype="boolean" output="false">
		<cfargument name="errorKey" required="true" type="string">
		<cfargument name="errorValue" required="true" type="string">
		<cfargument name="errorMessage" required="true" type="string">
		<cfset structinsert(this.getErrorStruct(),arguments.errorkey,structNew(),1)>
		<cfset structinsert(structfind(this.getErrorStruct(),arguments.errorKey),"value",arguments.errorValue,1)>
		<cfset structinsert(structfind(this.getErrorStruct(),arguments.errorKey),"message",arguments.errorMessage,1)>
		<cfreturn true>
	</cffunction>

	<!--- Delete --->
	<cffunction name="delete" returntype="boolean" output="false">
		<cfargument name="key" required="true" type="string">
		<cfif (this.isInError(arguments.key))>
			<cfset structDelete(this.ErrorStruct,arguments.key)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- Clear --->
	<cffunction name="clear" returntype="boolean" output="false">
		<cfset this.setErrorStruct(structnew())>
		<cfreturn true>
	</cffunction>

	<!--- PRIVATE METHODS --->
	<!--- Get Error Fields --->
	<cffunction name="getErrorFields" returntype="string" output="false">
		<cfreturn structkeylist(this.errorStruct)>
		<!--- <cfreturn structkeylist(this.getErrorStruct())> --->
	</cffunction>

	<!--- Get Error Struct --->
	<cffunction name="getErrorStruct" returntype="struct" output="false">
		<cfreturn this.errorStruct>
	</cffunction>

	<!--- Get Error Message --->
	<cffunction name="getErrorMessage" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfif (listfindnocase(this.getErrorFields(),key))>
			<cfreturn structfind(structfind(this.getErrorStruct(),key),'message')>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- Set Error Struct --->
	<cffunction name="setErrorStruct" returntype="boolean" output="false">
		<cfargument name="errorStruct" required="true" type="struct">
		<cfset this.errorStruct = arguments.errorstruct>
		<cfreturn true>
	</cffunction>
</cfcomponent>