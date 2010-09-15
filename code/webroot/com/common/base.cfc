<!---
Name:			Editable.CFC
Purpose:	All CFC's that wish to make use of the standard
					data validation handling should extend this tag
Author:		Nathan Wesling
Date:			Jan 5, 2003
--->
<cfcomponent>
	<!--- Properties --->
	<cfproperty name="error" type="error"/>
	<cfparam name="This.Error" default="#CreateObject('component','com.error.error')#">

	<!--- Get Property List --->
	<cffunction name="getPropertyList" returntype="string" output="false">
		<cfreturn structkeylist(this)>
	</cffunction>

	<!--- Property Display Name Lookup --->
	<cfset sPropertyDisplayName = structNew()>

	<!--- GetPropertyDisplayName
				If you overwrite sPropertyDisplayName in the parent object, you can make use of this method.
	--->
	<cffunction name="getPropertyDisplayName" returntype="string" output="false">
		<cfargument name="property" required="true">
		<cftry>
			<cfreturn sPropertyDisplayName[arguments.property]>
			<cfcatch>
				<cfreturn arguments.property>
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- Add Error --->
	<cffunction name="addError" returntype="boolean" output="false">
		<cfargument name="errorKey" required="true" type="string">
		<cfargument name="errorValue" required="true" type="string">
		<cfargument name="errorMessage" required="true" type="string">
		<cfset This.Error.add(arguments.errorKey,arguments.errorValue,arguments.errorMessage)>
		<cfreturn true>
	</cffunction>

	<!--- Is In Error --->
	<cffunction name="isInError" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfreturn This.Error.isInError(key)>
	</cffunction>

	<!--- Get Error Value --->
	<cffunction name="getErrorValue" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfreturn This.Error.getErrorValue(key)>
	</cffunction>

	<!--- Delete Error Value --->
	<cffunction name="deleteError" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfreturn This.Error.delete(key)>
	</cffunction>

	<!--- Get Error Message --->
	<cffunction name="getErrorMessage" returntype="any" output="false">
		<cfargument name="key" required="true" type="string">
		<cfreturn This.Error.GetErrorMessage(key)>
	</cffunction>

	<!--- GetLocalErrorMessages --->
	<cffunction name="getLocalErrorMessages" returntype="array" output="false">
		<cfreturn This.Error.getErrorMessages()>
	</cffunction>

	<!--- GetAllErrorMessages --->
	<cffunction name="getAllErrorMessages" returntype="array" output="false">

		<!--- init variables --->
		<cfset var messageCollection = This.Error.getErrorMessages()>
		<cfset var properties = structkeylist(this)>
		<cfset var subErrorMessages = "">
		<cfset var errorMessageCount = "">
		<cfset var property = "">

		<cfloop list="#properties#" index="property">
			<cfif isObject(this[property]) and property is not "error">
				<cfset subErrorMessages = this[property].getAllErrorMessages()>
				<cfloop from="1" to="#arrayLen(subErrorMessages)#" index="errorMessageCount">
					<cfset arrayappend(messageCollection,subErrorMessages[errorMessageCount])>
				</cfloop>
			</cfif>
		</cfloop>
		<cfreturn messageCollection>
	</cffunction>

	<!--- IsCorrect --->
	<cffunction name="isCorrect" returntype="boolean" output="false">

		<!--- init variables --->
		<cfset var state = not This.Error.hasErrorOccurred()>
		<cfset var subState = true>
		<cfset var property = "">

		<cfif state is true>
			<cfloop list="#this.getPropertyList()#" index="property">
				<cfif isObject(this[property]) and property is not "error">
					<cfset subState = this[property].IsCorrect()>
					<cfif subState is false>
						<cfreturn substate>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn state>
	</cffunction>

	<cffunction name="GetVerboseError" returntype="struct" output="true">
		<cfargument name="Error" required="false" type="struct">
		<cfargument name="ErrorPrefix" required="false" type="string">

		<!--- init variables --->
		<cfset var TempStruct = "">
		<cfset var ErrorFieldList = "">
		<cfset var ThisErrorField = "">
		<cfset var ThisElement = "">

		<cfif Not IsDefined("ARGUMENTS.Error")>
			<cfset ARGUMENTS.Error=StructNew()>
		</cfif>
		<cfparam name="ARGUMENTS.ErrorPrefix" default="">
		<cfset TempStruct=StructNew()>
		<cfset TempStruct=This.Error.GetErrorStruct()>
		<cfset ErrorFieldList=StructKeyList(TempStruct)>
		<cfif ARGUMENTS.ErrorPrefix IS NOT "">
			<cfloop index="ThisErrorField" list="#ErrorFieldList#">
				<cfset StructInsert(TempStruct,ListChangeDelims(ListAppend(ARGUMENTS.ErrorPrefix,ThisErrorField),"_"),TempStruct[ThisErrorField],1)>
				<cfset StructDelete(TempStruct,"#ThisErrorField#")>
			</cfloop>
		</cfif>
		<cfset StructAppend(ARGUMENTS.Error,TempStruct)>
		<cfloop index="ThisElement" list="#StructKeyList(This)#">
			<cfif IsObject(this[ThisElement]) AND ThisElement IS NOT "Error">
				<cfset TempStruct=StructNew()>
				<cfset TempStruct=this[ThisElement].GetVerboseError(ARGUMENTS.Error,ListAppend(ARGUMENTS.ErrorPrefix,ThisElement))>
				<cfset ErrorFieldList=StructKeyList(TempStruct,"_")>
				<cfloop index="ThisErrorField" list="#ErrorFieldList#">
					<cfif StructKeyExists(TempStruct,ThisErrorField)>
						<cfset StructInsert(TempStruct,ListChangeDelims(ListAppend(ARGUMENTS.ErrorPrefix,ThisErrorField),"_"),TempStruct[ThisErrorField],1)>
						<cfset StructDelete(TempStruct,"#ThisErrorField#")>
					</cfif>
				</cfloop>
				<cfset StructAppend(ARGUMENTS.Error,TempStruct)>
			</cfif>
		</cfloop>
		<cfreturn ARGUMENTS.Error>
	</cffunction>
</cfcomponent>