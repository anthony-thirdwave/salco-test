<!---
	Originally coded by TPS
	01/14/03 PWK, Hints and comments added; minor code enhancements
--->
<cfcomponent displayname="baseCollection"
	hint="Base object for a collection of other objects.">
	<!--- Properties.  --->
	<cfproperty name="Collection" type="array"
		hint="An ordered list of objects."/>
	<cfproperty name="BaseTable" type="string"
		hint="The table or view to use to populate the collection."/>
	<cfproperty name="FilterRules" type="array"
		hint="Rules specifying which records should be included in the collection."/>
	<cfproperty name="SortRules" type="array"
		hint="Rules specifying how the collection should be ordered."/>
	<cfproperty name="MaxRows" type="numeric">

	<cffunction name="constructor" returntype="boolean" output="false"
		hint="Initializes the collection.">
		<!--- The only initialization required is to set up new arrays.  --->
		<cfset this.clear()>

		<!--- The constructor for the base collection cannot fail, but a
			  specific type of collection might fail.  --->
		<cfreturn true>
	</cffunction>

	<cffunction name="clear" access="public" output="false"
		hint="Clears the collection and the filter and sort parameters.">
		<cfset This.Collection=ArrayNew(1)>
		<cfset This.BaseTable="">
		<cfset This.FilterRules=ArrayNew(1)>
		<cfset This.SortRules=ArrayNew(1)>
		<cfset This.MaxRows="">
	</cffunction>
	
	<cffunction name="isEmpty" returntype="boolean" output="false"
		hint="States whether or not the collection is currently empty.">
		<cfreturn (ArrayLen(This.Collection) IS 0)/>
	</cffunction>
	
	<cffunction name="SetMaxRows" returntype="boolean" output="false">
		<cfargument name="MaxRows" required="true" type="numeric">
		<cfif Val(ARGUMENTS.MaxRows) GT "0">
			<cfset THIS.MaxRows=Val(ARGUMENTS.MaxRows)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="getAllErrorMessages" returntype="array" output="false"
		hint="Compiles a list of all the error messages in members of this collection.">
		
		<!--- init variables --->
		<cfset var messageCollection = ArrayNew(1)>
		<cfset var subErrorMessages = "">
		<cfset var i = "">
		<cfset var errorMessageCount = "">
		
		<cfloop index="i" from="1" to="#ArrayLen(this.Collection)#" step="1">
			<cfset subErrorMessages = this.Collection[i].getAllErrorMessages()>
			<cfloop from="1" to="#arrayLen(subErrorMessages)#" index="errorMessageCount">
				<cfset arrayappend(messageCollection,subErrorMessages[errorMessageCount])>
			</cfloop>  <!--- error messages --->
		</cfloop>  <!--- elements --->

		<!--- Note that we can just pass back a pointer, because we created it
			  within this method and we don't retain our own pointer to it.  --->
		<cfreturn messageCollection>
	</cffunction>  <!--- getAllErrorMessages --->

	<cffunction name="isValid" returntype="boolean" output="false"
		hint="States whether or not the collection is currently valid.
			  A collection is valid when each of its elements is valid.
			  As this implies, a collection with no elements is valid.">
		
		<!--- init variables --->
		<cfset var i = "">
		<cfset var subState = "">
		
		<cfloop index="i" from="1" to="#ArrayLen(this.Collection)#" step="1">
			<cfset SubState=this.Collection[i].IsCorrect()>
			<cfif SubState IS False>
				<cfreturn SubState>
			</cfif>
		</cfloop>
		<cfreturn True>
	</cffunction>  <!--- isValid --->

	<cffunction name="setBaseTable"
		access="public" output="false"
		hint="Sets the table or view to be used to build the collection.">
		<cfargument name="BaseTable" required="true" type="string"/>

		<!--- init variables --->
		<cfset var TableNameIsBogus = "">
		
		<!--- It's best to check the table name to ensure that it actually exists.
			  Failing that, checking for illegal and potentially hostile characters
			  should be considered a minimum precaution.  --->
		<cfinvoke component="com.utils.Database"
			method="ContainsSpecialSQLChars"
			returnvariable="TableNameIsBogus">
			<cfinvokeargument name="Input" value="#Arguments.BaseTable#"/>
		</cfinvoke>
		<cfif TableNameIsBogus>
			<cfthrow type="BaseCollection.SecurityException"
					 message="The table name contains illegal characters."/>
		<cfelse>
			<cfset This.BaseTable = Arguments.BaseTable/>
		</cfif>  <!--- no special characters --->
	</cffunction>  <!--- setBaseTable --->

	<cffunction name="getBaseTable" returntype="string"
		access="public" output="false"
		hint="Returns the name of the table or view to be used to build the collection.">
		<cfreturn This.BaseTable/>
	</cffunction>  <!--- getBaseTable --->
</cfcomponent> 
