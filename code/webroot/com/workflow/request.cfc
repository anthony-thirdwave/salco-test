<cfcomponent output="false" displayname="Article" extends="com.common.base">

	<cfproperty name="WorkflowRequestID" type="numeric" default="">
	<cfproperty name="WorkflowRequestTypeID" type="numeric" default="">
	<cfproperty name="WorkflowRequestDateTime" type="date" default="">
	<cfproperty name="FromUserID" type="numeric" default="">
	<cfproperty name="LToUserID" type="string" default="">
	<cfproperty name="LToUserGroupID" type="String" default="">
	<cfproperty name="CategoryID" type="numeric" default="">
	<cfproperty name="Message" type="text" default="">
	
	<cfset structInsert(sPropertyDisplayName,"WorkflowRequestID","Workflow Request ID",1)>
	<cfset structInsert(sPropertyDisplayName,"WorkflowRequestTypeID","Workflow Request Type ID",1)>
	<cfset structInsert(sPropertyDisplayName,"WorkflowRequestDateTime","Workflow Request Date Time",1)>
	<cfset structInsert(sPropertyDisplayName,"FromUserID","From User ID",1)>
	<cfset structInsert(sPropertyDisplayName,"LToUserID","To User ID",1)>
	<cfset structInsert(sPropertyDisplayName,"LToUserGroupID","To User Group ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryID","Category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"Message","Message",1)>
	

	<cffunction name="constructor" returntype="boolean" output="false">
		<cfargument name="ID" type="numeric" default="0" required="false"/>

		<cfset var local = structNew() />

		<!--- Call each mutator field.  We need to initialize all the fields
			  even if loading from the database.  --->
		<cfset this.SetProperty("WorkflowRequestID","")>
		<cfset this.SetProperty("WorkflowRequestTypeID","")>
		<cfset this.SetProperty("WorkflowRequestDateTime","")>
		<cfset this.SetProperty("FromUserID","")>
		<cfset this.SetProperty("LToUserID","")>
		<cfset this.SetProperty("LToUserGroupID","")>
		<cfset this.SetProperty("CategoryID","")>
		<cfset this.SetProperty("Message","")>
		
		<!--- If an ID was given, try to pull the record with that primary key.  --->
		<cfif Arguments.ID GT 0>
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="local.GetWorkflowRequest" datasource="#APPLICATION.DSN#">
				SELECT	* 
				FROM	t_WorkflowRequest
				WHERE	WorkflowRequestID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ARGUMENTS.ID)#">
			</cfquery>
			<cfif local.GetWorkflowRequest.recordcount EQ 1>
				<cfoutput query="local.GetWorkflowRequest">
					<cfset this.SetProperty("WorkflowRequestID",local.GetWorkflowRequest.WorkflowRequestID)>
					<cfset this.SetProperty("WorkflowRequestTypeID",local.GetWorkflowRequest.WorkflowRequestTypeID)>
					<cfset this.SetProperty("WorkflowRequestDateTime",local.GetWorkflowRequest.WorkflowRequestDateTime)>
					<cfset this.SetProperty("LToUserGroupID",local.GetWorkflowRequest.LToUserGroupID)>
					<cfset this.SetProperty("CategoryID",local.GetWorkflowRequest.CategoryID)>
					<cfset this.SetProperty("Message",local.GetWorkflowRequest.Message)>
				</cfoutput>
				<cfquery name="local.GetWorkflowRequest2" datasource="#APPLICATION.DSN#">
					SELECT	* 
					FROM	t_WorkflowRequestRecipient
					WHERE	WorkflowRequestID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(ARGUMENTS.ID)#">
				</cfquery>
				<cfset this.SetProperty("LToUserID","#ValueList(local.GetWorkflowRequest2.UserID)#")>
				<cfset this.SetProperty("LToUserGroupID","#ValueList(local.GetWorkflowRequest2.UserGroupID)#")>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
				<!--- If id is not present, return false. --->
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>  <!--- constructor --->

	<cffunction name="save" returntype="boolean" output="false">
		
		<cfset var local = structNew() />
	
		<cfif IsCorrect()>
			<cfset local.thisWorkflowRequestID = this.GetProperty("WorkflowRequestID")>	
			<cfset local.thisWorkflowRequestTypeID = this.GetProperty("WorkflowRequestTypeID")>	
			<cfset local.thisWorkflowRequestDateTime = this.GetProperty("WorkflowRequestDateTime")>	
			<cfset local.thisFromUserID = this.GetProperty("FromUserID")>	
			<cfset local.thisLToUserID = this.GetProperty("LToUserID")>	
			<cfset local.thisLToUserGroupID = this.GetProperty("LToUserGroupID")>
			<cfset local.thisCategoryID = this.GetProperty("CategoryID")>
			<cfset local.thisMessage = this.GetProperty("Message")>
			
			<cfif val(local.thisWorkflowRequestID) LTE "0">
				<!--- Save Article --->
				<cfquery name="local.InsertArticle" datasource="#APPLICATION.DSN#">
					SET NOCOUNT ON
					INSERT INTO t_WorkflowRequest (
						WorkflowRequestTypeID,
						WorkflowRequestDateTime,
						FromUserID,
						CategoryID,
						Message,
						LocaleID
					) VALUES (
						<cfqueryparam value="#val(local.thisWorkflowRequestTypeID)#" cfsqltype="cf_sql_integer">,
						getdate(),
						<cfqueryparam value="#val(local.thisFromUserID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#val(local.thisCategoryID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Trim(local.thisMessage)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#APPLICATION.DefaultLocaleID#" cfsqltype="cf_sql_varchar">
					)
					SELECT NewWorkflowRequestID=@@Identity
				</cfquery>
				<cfset local.thisWorkflowRequestID = local.InsertArticle.NewWorkflowRequestID>
				<cfset this.SetProperty("WorkflowRequestID",local.thisWorkflowRequestID)>
			<cfelse>
				<cfquery name="local.UpdateArticle" datasource="#APPLICATION.DSN#">
					UPDATE	t_WorkflowRequest 
					SET		WorkflowRequestTypeID = <cfqueryparam value="#val(local.thisWorkflowRequestTypeID)#" cfsqltype="cf_sql_integer">
							FromUserID = <cfqueryparam value="#val(local.thisFromUserID)#" cfsqltype="cf_sql_integer">,
							CategoryID = <cfqueryparam value="#val(local.thisCategoryID)#" cfsqltype="cf_sql_integer">,
							Message = <cfqueryparam value="#local.thisMessage#" cfsqltype="cf_sql_varchar">
					WHERE	WorkflowRequestID = <cfqueryparam value="#val(local.thisWorkflowRequestID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
			<cfquery name="Delete" datasource="#APPLICATION.DSN#">
				DELETE FROM	t_WorkflowRequestRecipient
				WHERE		WorkflowRequestID = <cfqueryparam value="#val(local.thisWorkflowRequestID)#">
			</cfquery>
			<cfset local.ThisLDone="">
			<cfloop index="local.ThisUserID" list="#local.thisLToUserID#">
				<cfif ListFind(local.ThisLDone,local.ThisUserID) IS "0">
					<cfquery name="Insert" datasource="#APPLICATION.DSN#">
						INSERT INTO t_WorkflowRequestRecipient (WorkflowRequestID,UserID,UserGroupID)
						VALUES
						(<cfqueryparam value="#val(local.thisWorkflowRequestID)#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#val(local.ThisUserID)#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="-1" cfsqltype="cf_sql_integer">
						)
					</cfquery>
					<cfset local.ThisLDone=ListAppend(local.ThisLDone,local.ThisUserID)>
				</cfif>
			</cfloop>
			<cfset local.ThisLDone="">
			<cfloop index="local.ThisUserGroupID" list="#local.thisLToUserGroupID#">
				<cfif ListFind(local.ThisLDone,ThisUserGroupID) IS "0">
					<cfquery name="Insert" datasource="#APPLICATION.DSN#">
						insert into t_WorkflowRequestRecipient (WorkflowRequestID,UserID,UserGroupID)
						VALUES
						(<cfqueryparam value="#val(local.thisWorkflowRequestID)#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="-1" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#val(local.ThisUserGroupID)#" cfsqltype="cf_sql_integer">
						)
					</cfquery>
					<cfset local.ThisLDone=ListAppend(local.ThisLDone,local.ThisUserGroupID)>
				</cfif>
			</cfloop>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>  <!--- save --->
	
	<cffunction name="delete" returntype="boolean" output="false">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="Send" returntype="boolean" output="false">
		<cfargument name="AppliesToSubPages" type="boolean" default="0" required="false">
		<cfargument name="CCRequest" type="boolean" default="0" required="false">
		<cfargument name="OverrideSubject" type="string" default="" required="false">
		
		<cfset var local = structNew() />
		
		<cfset local.thisWorkflowRequestID = this.GetProperty("WorkflowRequestID")>	
		<cfset local.thisWorkflowRequestTypeID = this.GetProperty("WorkflowRequestTypeID")>	
		<cfset local.thisWorkflowRequestDateTime = this.GetProperty("WorkflowRequestDateTime")>	
		<cfset local.thisFromUserID = this.GetProperty("FromUserID")>	
		<cfset local.thisLToUserID = this.GetProperty("LToUserID")>	
		<cfset local.thisLToUserGroupID = this.GetProperty("LToUserGroupID")>
		<cfset local.thisCategoryID = this.GetProperty("CategoryID")>
		<cfset local.thisMessage = this.GetProperty("Message")>
		
		<cfif local.thisLToUserID IS "">
			<cfset local.thisLToUserID="-1">
		</cfif>
		<cfif local.thisLToUserGroupID IS "">
			<cfset local.thisLToUserGroupID="-1">
		</cfif>
		
		
		<cfinvoke component="com.utils.database" method="GenericLookup" returnVariable="local.GetRequestType">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Label">
			<cfinvokeargument name="FieldName" value="LabelID">
			<cfinvokeargument name="FieldValue" value="#local.thisWorkflowRequestTypeID#">
			<cfinvokeargument name="SortFieldName" value="LabelName">
			<cfinvokeargument name="SortOrder" value="Asc">
		</cfinvoke>
		
		<cfset local.ThisFromEMail="support@thirdwavellc.com">
		<cfquery name="local.GetFromEmail" datasource="#APPLICATION.USER_DSN#">
			SELECT	emailAddress, FirstName, MiddleName, LastName 
			FROM	t_User 
			WHERE	UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(local.thisFromUserID)#">
		</cfquery>
		<cfoutput query="local.GetFromEmail">
			<cfset ThisFromEMail="#local.GetFromEmail.FirstName# #local.GetFromEmail.MiddleName# #local.GetFromEmail.LastName# <#local.GetFromEmail.emailAddress#>">
		</cfoutput>
				
		<cfquery name="local.GetPage" datasource="#APPLICATION.DSN#">
			SELECT	CategoryName, CategoryAlias 
			FROM	t_Category 
			WHERE	CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(local.ThisCategoryID)#">
		</cfquery>
		
		<cfswitch expression="#local.thisWorkflowRequestTypeID#">
			<cfcase value="19000">
				<cfset local.ThisSubject="Message regarding the page ""#local.GetPage.CategoryName#""">
			</cfcase>
			<cfcase value="19001">
				<cfset local.ThisSubject="Request to publish the page ""#local.GetPage.CategoryName#""">
			</cfcase>
			<cfcase value="19002">
				<cfset local.ThisSubject="Request to edit the page ""#local.GetPage.CategoryName#""">
			</cfcase>
		</cfswitch>
		
		<cfif ARGUMENTS.OverrideSubject IS NOT "">
			<cfset local.ThisSubject="#ARGUMENTS.OverrideSubject# ""#local.GetPage.CategoryName#""">
		</cfif>
		<cfif IsDebugMode()>
			<cfset local.thisLToUserID="1">
			<!---<cfset thisLToUserGroupID="-1">--->
		</cfif>
		<cfquery name="local.GetRecipients" datasource="#APPLICATION.USER_DSN#">
			SELECT		FirstName, MiddleName, LastName, EMailAddress 
			FROM		qry_GetUser
			WHERE		(UserID IN (<cfqueryparam value="#local.thisLToUserID#" cfsqltype="cf_sql_integer" list="true">) 
						OR UserGroupID IN (<cfqueryparam value="#local.thisLToUserGroupID#" cfsqltype="cf_sql_integer" list="true">)) 
			AND			OwnerEMailNotifications=1
			ORDER BY	LastName, EmailAddress
		</cfquery>
		<cfset local.lRecipients="">
		<cfoutput query="local.GetRecipients" group="emailAddress">
			<cfset local.lRecipients=ListAppend(local.lRecipients,"#local.GetRecipients.FirstName# #local.GetRecipients.MiddleName# #local.GetRecipients.LastName# <#local.GetRecipients.emailAddress#>")>
		</cfoutput>
		
		<cfoutput>
		<cfsavecontent variable="local.FinalMessage">
Greetings,

#local.GetFromEmail.FirstName# #local.GetFromEmail.MiddleName# #local.GetFromEmail.LastName# has sent you the following request from the #APPLICATION.companyName# CMS.

Request Type: #local.GetRequestType.LabelName#
Page: #local.GetPage.CategoryName#

<cfif ARGUMENTS.AppliesToSubPages>
This request applies to this page and all of its subpages.
</cfif>

Message:
#local.ThisMessage#

Staging URL:
http://#REQUEST.CGIHTTPHost##APPLICATION.contentPageInUrl#/#local.GetPage.CategoryAlias#?Preview=1

CMS URL:
http://#REQUEST.CGIHTTPHost#/common/admin/masterview/index.cfm?MVEid=1&MVCid=#local.ThisCategoryID#

--------------------------------------------------------
To turn off these notifications, login at http://#REQUEST.CGIHTTPHost#/common/admin/ and click on "Your Account".
		</cfsavecontent>
		</cfoutput>
		<cfif local.lRecipients IS NOT "">
			<cfif val(ARGUMENTS.CCRequest)>
				<cfmail to="#local.lRecipients#" from="#local.ThisFromEMail#" cc="#local.ThisFromEMail#" subject="#local.ThisSubject#">#local.FinalMessage#</cfmail>
			<cfelse>
				<cfmail to="#local.lRecipients#" from="#local.ThisFromEMail#" subject="#local.ThisSubject#">#local.FinalMessage#</cfmail>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="SetProperty" returntype="boolean" output="true">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">
		
		<cfset ARGUMENTS.Property = trim(ARGUMENTS.Property)>

		<cfif listFindNoCase("Date",ARGUMENTS.Property) and ARGUMENTS.VALUE is not "">
			<cfif not isDate(ARGUMENTS.Value)>
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
				<cfreturn false>
			</cfif>
		</cfif>

		<cfset setVariable("this.#ARGUMENTS.Property#","#ARGUMENTS.Value#")>
		<cfset deleteError(ARGUMENTS.Property)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetProperty" returntype="Any" output="false">
		<cfargument name="Property" required="true">
		<cfif IsInError(ARGUMENTS.Property)>
			<cfreturn GetErrorValue(ARGUMENTS.Property)>
		<cfelse>
			<cfset ReturnValue=this["#ARGUMENTS.Property#"]>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>
	
</cfcomponent>