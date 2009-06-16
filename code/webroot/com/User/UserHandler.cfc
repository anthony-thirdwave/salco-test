<cfcomponent>
	
	<cffunction name="GetUserLogin" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="true">
		
		<!--- init variables --->
		<cfset var local = structNew()>
		
		<cfquery name="local.checkAlias" datasource="#APPLICATION.DSN#">
			SELECT userName
			FROM t_user
			WHERE userID = <cfqueryparam value="#val(arguments.userID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfreturn local.checkAlias.userName>
	</cffunction>
	
	
	<!--- add a user --->
	<cffunction name="addUser" output="false" returntype="numeric">
		<cfargument name="firstName" default="">
		<cfargument name="middleName" default="">
		<cfargument name="lastName" default="">
		<cfargument name="title" default="">
		<cfargument name="organizationName" default="">
		<cfargument name="phoneNumber" default="">
		<cfargument name="emailAddress" default="">
		<cfargument name="userLogin" default="">
		<cfargument name="userPassword" default="">
		<cfargument name="localeID" default="1">
		<cfargument name="dayPhoneNumber" default="">
		<cfargument name="faxNumber" default="">
		<cfargument name="mailingList" default="">
		<cfargument name="browser" default="">
		<cfargument name="remoteHost" default="">
		<cfargument name="disableRichControls" default="0">
		<cfargument name="dashboardModuleIdList" default="">
		<cfargument name="ownerEmailNotifications" default="">
		
		<cfset var local = structNew() />
		
		<cfquery name="local.createAccount" datasource="#application.dsn#">
			SET NOCOUNT ON
			INSERT INTO t_User(firstName, middleName, lastName, title, organizationName, phoneNumber, emailAddress, userLogin, userPassword,
						       localeID, dayPhoneNumber, faxNumber, mailingList, browser,remoteHost, disableRichControls, dashboardModuleIDList,
						       ownerEmailNotifications) 
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.firstName)#" null="#not len(trim(arguments.firstName))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.middleName)#" null="#not len(trim(arguments.middleName))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.lastName)#" null="#not len(trim(arguments.lastName))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.title)#" null="#not len(trim(arguments.title))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.organizationName)#" null="#not len(trim(arguments.organizationName))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.phoneNumber)#" null="#not len(trim(arguments.phoneNumber))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.emailAddress)#" null="#not len(trim(arguments.emailAddress))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.userlogin)#" null="#not len(trim(arguments.userlogin))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.userPassword)#" null="#not len(trim(arguments.userPassword))#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.localeId#" null="#not isNumeric(arguments.localeId)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.dayPhoneNumber)#" null="#not len(trim(arguments.dayPhoneNumber))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.faxNumber)#" null="#not len(trim(arguments.faxNumber))#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mailingList#" null="#not isNumeric(arguments.mailingList)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.browser)#" null="#not len(trim(arguments.browser))#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.remoteHost)#" null="#not len(trim(arguments.remoteHost))#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.disableRichControls#" null="#not isNumeric(arguments.disableRichControls)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.dashboardModuleIdList)#" null="#not len(trim(arguments.dashboardModuleIdList))#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ownerEmailNotifications#" null="#not isNumeric(arguments.ownerEmailNotifications)#">
			)
					
			SELECT SCOPE_IDENTITY() AS newId
			SET NOCOUNT OFF
		</cfquery>
		
		<!--- grab the new userId --->
		<cfset local.userId = local.createAccount.newId>
		
		<cfreturn local.userId>
	</cffunction>
	
	
	
	
	<!--- update a user --->
	<cffunction name="updateUser" output="false" returntype="boolean">
		<cfargument name="userId" type="numeric" required="true">
		<cfargument name="localeId" required="true">
		<cfargument name="firstName" required="true">
		<cfargument name="middleName" required="true">
		<cfargument name="lastName" required="true">
		<cfargument name="title" required="true">
		<cfargument name="organizationName" required="true">
		<cfargument name="userLogin" required="true">
		<cfargument name="userPassword" required="true">
		<cfargument name="emailAddress" required="true">
		<cfargument name="phoneNumber" required="true">
		<cfargument name="dayPhoneNumber" required="true">
		<cfargument name="faxNumber" required="true">
		<cfargument name="mailingList" required="true">
		<cfargument name="browser" required="true">
		<cfargument name="remoteHost" required="true">
		<cfargument name="disableRichControls" required="true">
		<cfargument name="dashboardModuleIDList" required="true">
		<cfargument name="ownerEmailNotifications" required="true">
		
		
		<cfset var local = structNew() />
		
		<!--- get the user --->
		<cfinvoke method="getUser" returnvariable="local.thisUser">
			<cfinvokeargument name="userId" value="#arguments.userId#">
		</cfinvoke>
		
		<!--- make sure the user exists --->
		<cfif local.thisUser.recordcount neq 1>
			<cfreturn false>
		</cfif>

		<cfquery name="local.updateData" datasource="#application.dsn#">
			UPDATE t_User 
			SET 

			<cfif trim(arguments.firstName) neq trim(local.thisUser.firstName)>
				firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.firstName)#" null="#not len(trim(arguments.firstName))#">,
			</cfif>
			<cfif trim(arguments.middleName) neq trim(local.thisUser.middleName)>
				middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.middleName)#" null="#not len(trim(arguments.middleName))#">,
			</cfif> 
			<cfif trim(arguments.lastName) neq trim(local.thisUser.lastName)>
				lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.lastName)#" null="#not len(trim(arguments.lastName))#">,
			</cfif>
			<cfif trim(arguments.title) neq trim(local.thisUser.title)>
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.title)#" null="#not len(trim(arguments.title))#">,
			</cfif>
			<cfif trim(arguments.organizationName) neq trim(local.thisUser.organizationName)>
				organizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.organizationName)#" null="#not len(trim(arguments.organizationName))#">,
			</cfif>
			<cfif trim(arguments.userLogin) neq trim(local.thisUser.userLogin)>
				userLogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.userlogin)#" null="#not len(trim(arguments.userlogin))#">,
			</cfif>
			<cfif trim(arguments.userPassword) neq trim(local.thisUser.userPassword)>
				userPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.userPassword)#" null="#not len(trim(arguments.userPassword))#">,
			</cfif>
			<cfif trim(arguments.emailAddress) neq trim(local.thisUser.emailAddress)>
				emailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.emailAddress)#" null="#not len(trim(arguments.emailAddress))#">,
			</cfif>
			<cfif trim(arguments.phoneNumber) neq trim(local.thisUser.phoneNumber)>
				phoneNumber =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.phoneNumber)#" null="#not len(trim(arguments.phoneNumber))#">,
			</cfif>
			<cfif trim(arguments.dayPhoneNumber) neq trim(local.thisUser.dayPhoneNumber)>
				dayPhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.dayPhoneNumber)#" null="#not len(trim(arguments.dayPhoneNumber))#">,
			</cfif>
			<cfif trim(arguments.faxNumber) neq trim(local.thisUser.faxNumber)>
				faxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.faxNumber)#" null="#not len(trim(arguments.faxNumber))#">,
			</cfif>
			<cfif trim(arguments.mailingList) neq trim(local.thisUser.mailingList)>
				mailingList = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.mailingList#" null="#not isNumeric(arguments.mailingList)#">,
			</cfif>
			<cfif trim(arguments.browser) neq trim(local.thisUser.browser)>
				browser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.browser)#" null="#not len(trim(arguments.browser))#">,
			</cfif>
			<cfif trim(arguments.remoteHost) neq trim(local.thisUser.remoteHost)>
				remoteHost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.remoteHost)#" null="#not len(trim(arguments.remoteHost))#">,
			</cfif>
			<cfif trim(arguments.disableRichControls) neq trim(local.thisUser.disableRichControls)>
				disableRichControls = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.disableRichControls#" null="#not isNumeric(arguments.disableRichControls)#">,
			</cfif>
			<cfif trim(arguments.dashboardModuleIDList) neq trim(local.thisUser.dashboardModuleIDList)>
				dashboardModuleIDList = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.dashboardModuleIdList)#" null="#not len(trim(arguments.dashboardModuleIdList))#">,
			</cfif>
			<cfif trim(arguments.ownerEmailNotifications) neq trim(local.thisUser.ownerEmailNotifications)>
				ownerEmailNotifications = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ownerEmailNotifications#" null="#not isNumeric(arguments.ownerEmailNotifications)#">,
			</cfif>
			
			<!--- always set localeId so query always works --->
			localeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.localeId#" null="#not isNumeric(arguments.localeId)#">
			WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
	
	
	
	
	
	<!--- get the users based upon the passed params --->
	<cffunction name="getUsers" output="false" access="remote">
		<cfargument name="page" default="">
		<cfargument name="pageSize" default="">
		<cfargument name="cfgridsortcolumn" default="">
		<cfargument name="cfgridsortdirection" default="">
		<cfargument name="firstName" type="string" default="">
		<cfargument name="lastName" type="string" default="">
		<cfargument name="emailAddress" type="string" default="">
		<cfargument name="organizationName" type="string" default="">
		<cfargument name="userGroupId" type="string" default="">
	
		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		
		<!--- get the results --->
		<cfquery name="local.getResults" datasource="#APPLICATION.USER_DSN#">
			SELECT	u.userId, u.firstName, u.lastName, u.organizationName, u.emailAddress,
					
					<!--- the list of userGroups - the left takes care of the trailing comma --->
					userGroups = left(x.groupList, len(x.groupList)-1),
					edit = '<img src="/common/images/admin/icon_edit.gif" width="12" height="12" />',
					delUser = '<img src="/common/images/admin/icon_delete.gif" width="12" height="12" />'
					
			FROM	t_User u 
			
			<!--- only do this join if a userGroupId is passed --->
			<cfif isNumeric(trim(arguments.userGroupId))>
				JOIN t_UserGroup ug ON ug.userId = u.userId
			</cfif>
			
			<!--- this grabs a list of user groups and concatenates them into one field --->
			CROSS APPLY
			(
				SELECT		CONVERT(VARCHAR(20), l.labelName) + ',' AS [text()]
				FROM 		t_UserGroup ug
				JOIN 		t_Label l
				ON			l.labelId = ug.userGroupId
				WHERE		ug.userId = u.userId
				ORDER BY l.labelName
			
				<!--- this normally creates a wrapper element, but since we're using '', and returning
				text, it concatenates the values --->
				FOR XML PATH('')
			) x (groupList)
	
			WHERE 1=1
	
				<cfif trim(arguments.firstName) neq "">
					AND u.firstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.firstName#%">
				</cfif>
				<cfif trim(arguments.lastName) neq "">
					AND u.lastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.lastName#%">
				</cfif>
				<cfif trim(arguments.emailAddress) neq "">
					AND u.emailAddress LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.emailAddress#%">
				</cfif>
				<cfif trim(arguments.organizationName) neq "">
					AND u.organizationName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.organizationName#%">
				</cfif>
				<cfif isNumeric(trim(arguments.userGroupId))>
					AND ug.userGroupId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userGroupId#">
				</cfif>
				
				<!--- cfgrid ordering params --->
				<cfif trim(arguments.cfgridsortcolumn) neq "">
					ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#
				<cfelse>
					ORDER BY u.lastName, u.firstName
				</cfif>
		</cfquery>
	
		<!--- if page and pageSize are numeric then return for cfgrid --->
		<cfif isNumeric(arguments.page) and isNumeric(arguments.pageSize)>
			<!--- return the results --->
			<cfreturn queryConvertForGrid(local.getResults, arguments.page, arguments.pageSize)>
		
		<!--- else, return the query  --->
		<cfelse>	
			<cfreturn local.getResults>
		</cfif>
	</cffunction>	
	
	
	
	<cffunction name="getUser" output="false" returntype="query">
		<cfargument name="userId" type="numeric" required="true">

		<cfset var local = structNew() />
		
		<cfquery name="local.getResults" datasource="#application.dsn#">
			SELECT userId, firstName, middleName, lastName, title, organizationName, phoneNumber, 
					emailAddress, userLogin, userPassword, localeID, dayPhoneNumber, faxNumber,
					mailingList, browser, remoteHost, disableRichControls, dashboardModuleIDList,
					ownerEmailNotifications
			FROM t_user
			WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfreturn local.getResults>
	</cffunction>

	
	
	<!--- changePassword --->
	<cffunction name="changePassword" output="false" returntype="boolean">
		<cfargument name="userId" type="numeric" required="true">
		<cfargument name="userPassword" type="string" required="true">
		
		<cfset var local = structNew() />
		
		<!--- change the password --->
		<cfquery name="local.updateData" datasource="#application.dsn#">
			UPDATE t_User 
			SET userPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.userPassword)#" null="#not len(trim(arguments.userPassword))#">
			WHERE userId = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
</cfcomponent>