<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="ContentNoteID" type="numeric" default="">
	<cfproperty name="ContentID" type="numeric" default="">
	<cfproperty name="ContentNote" type="string" default="">
	<cfproperty name="ContentNoteDate" type="date" default="">
	<cfproperty name="UserID" type="numeric" default="">
	
	<cfset structInsert(sPropertyDisplayName,"ContentNoteID","content note ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentID","content ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentNote","note",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentNoteDate","date posted",1)>
	<cfset structInsert(sPropertyDisplayName,"UserID","posted by",1)>
	
	<cffunction name="constructor" returntype="boolean" output="false">
		<cfargument name="ID" default="0" type="numeric" required="false">
		
		<!--- init variables --->
		<cfset var GetItems = "">
		
		<!--- Typically, use set methods in contructor. --->
		<cfset this.IsStepContent="0">
		<cfset this.IsProjectContent="0">
		
		<cfset this.SetProperty("ContentNoteID","-1")>
		<cfset this.SetProperty("ContentID","-1")>
		<cfset this.SetProperty("ContentNote","")>
		<cfset this.SetProperty("ContentNoteDate","#now()#")>
		<cfset this.SetProperty("UserID","")>
		
		<cfif Val(ARGUMENTS.ID) GT 0>
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_ContentNote
				WHERE ContentNoteID=<cfqueryparam value="#Val(ARGUMENTS.ID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetItems.recordcount EQ 1>
				<cfoutput query="GetItems">
					<cfset this.SetProperty("ContentNoteID",ContentNoteID)>
					<cfset this.SetProperty("ContentID",Val(GetItems2.ContentID))>
					<cfset this.SetProperty("ContentNote",ContentNote)>
					<cfset this.SetProperty("ContentNoteDate",ContentNoteDate)>
					<cfset this.SetProperty("UserID",UserID)>
				</cfoutput>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
				<!--- If id is not present, return false. --->
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="false">
		
		<!--- init variables --->
		<cfset var thisContentNoteID = "">
		<cfset var thisContentID = "">
		<cfset var thisContentNote = "">
		<cfset var thisContentNoteDate = "">
		<cfset var thisUserID = "">
		<cfset var InsertContent = "">
		
		<cfif IsCorrect()>
			<cfset thisContentNoteID=this.GetProperty("ContentNoteID")>
			<cfset thisContentID=this.GetProperty("ContentID")>
			<cfset thisContentNote=this.GetProperty("ContentNote")>
			<cfset thisContentNoteDate=this.GetProperty("ContentNoteDate")>
			<cfset thisUserID=this.GetProperty("UserID")>
			
			<cfif ThisContentNote IS NOT "">
				<cfif Val(thisContentNoteID) LTE "0">
					<cftransaction>
						<cfquery name="InsertContent" datasource="#APPLICATION.DSN#">
							INSERT INTO t_ContentNote (
							ContentNote,
							ContentID,
							ContentNoteDate, 
							UserID
							) VALUES (
							<cfqueryparam value="#trim(ThisContentNote)#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#trim(ThisContentID)#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#CreateODBCDateTime(thisContentNoteDate)#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#Val(thisUserID)#" cfsqltype="cf_sql_integer">
							)
						</cfquery>
					</cftransaction>
				</cfif>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="SetProperty" returntype="boolean" output="false">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">
		
		<!--- init variables --->
		<cfset var Test = "">
		
		<cfset ARGUMENTS.Property=Trim(ARGUMENTS.Property)>
				
		<cfif IsSimpleValue(ARGUMENTS.Value)>
			<cfset ARGUMENTS.Value=Trim(ARGUMENTS.Value)>

			<cfif ListFindNoCase("ContentNoteID,ContentID",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsNumeric(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid number.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("ContentNoteDate",ARGUMENTS.Property) AND ARGUMENTS.VALUE IS NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<!--- <cfif ListFindNoCase("ContentNote",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif> --->
			
			<cfif ListFindNoCase("ContentID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("ContentID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="ContentID">
							<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Content">
								<cfinvokeargument name="FieldName" value="ContentID">
								<cfinvokeargument name="FieldValue" value="#Val(ARGUMENTS.Value)#">
								<cfinvokeargument name="SortFieldName" value="ContentName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
					</cfswitch>
				<cfelse>
					<cfset ARGUMENTS.Value="-1">
				</cfif>
			</cfif>
		</cfif>
		
		<cfset SetVariable("this.#ARGUMENTS.Property#","#ARGUMENTS.Value#")>
		<cfset deleteError(ARGUMENTS.Property)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetProperty" returntype="Any" output="false">
		<cfargument name="Property" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfif IsInError(ARGUMENTS.Property)>
			<cfreturn GetErrorValue(ARGUMENTS.Property)>
		<cfelse>
			<cfset ReturnValue=this["#ARGUMENTS.Property#"]>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>
	
	<cffunction name="GetUserIDUserLogin" returnType="String" output="false">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var Test = "">
		
		<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="Test">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_User">
			<cfinvokeargument name="FieldName" value="UserID">
			<cfinvokeargument name="FieldValue" value="#this.GetProperty('UserID')#">
		</cfinvoke>
		<cfset ReturnString="#ValueList(Test.UserLogin)#">
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="Delete" returnType="boolean" output="false">
		
		<!--- init variables --->
		<cfset var ThisContentNoteID = "">
		<cfset var deleteContent4 = "">
		
		<cfif this.GetProperty("ContentNoteID") GT "0">
			<cftransaction>
				<cfset ThisContentNoteID=this.GetProperty("ContentNoteID")>
				<cfquery name="deleteContent4" datasource="#APPLICATION.DSN#">
					DELETE FROM t_ContentNote WHERE ContentNoteID=<cfqueryparam value="#Val(ThisContentNoteID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cftransaction>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>