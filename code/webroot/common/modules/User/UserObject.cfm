<cfsilent>
<!--- Establish control variables --->
<cfparam name="ObjectAction" default="ShowForm">
<cfif IsDefined("ATTRIBUTES.ObjectAction")>
	<cfset ObjectAction="#trim(ATTRIBUTES.ObjectAction)#">
</cfif>

<!--- Establish Object Identitification --->
<cfparam name="ATTRIBUTES.EditUserID" default="-1">

<!--- Establish page flow --->
<cfparam name="ATTRIBUTES.FormAction" default="">

<!--- Declare variables that comprise object. --->
<cfparam name="EditFirstName" default="">
<cfparam name="EditMiddleName" default="">
<cfparam name="EditLastName" default="">
<cfparam name="EditUserGroupID" default="">
<cfparam name="EditTitle" default="">
<cfparam name="EditOrganizationName" default="">
<cfparam name="EditPhoneNumber" default="">
<cfparam name="EditFaxNumber" default="">
<cfparam name="EditEmailAddress" default="">
<cfparam name="EditUserLogin" default="">
<cfparam name="EditUserPassword" default="">

<cfquery name="GetUserGroups" datasource="#APPLICATION.DSN#">
	select LabelID as UserGroupID, LabelName as UserGroupName from t_Label WHERE LabelGroupID=10
	order by LabelPriority
</cfquery>

<!--- Declare domain of any object attributes --->
<cfset UserGroupIDList="">
<cfoutput query="GetUserGroups">
	<cfset UserGroupIDList=ListAppend(UserGroupIDList,"{#UserGroupID#|#UserGroupName#}","^^")>
</cfoutput>

<cfparam name="ATTRIBUTES.WriteForm" default="Yes">
<cfparam name="ATTRIBUTES.ValidationColor" default="COCOCO">

<cfset CRLF=Chr(13) & Chr(10)>

<!--- Load object from db if appropriate. --->
<cfif IsDefined("ATTRIBUTES.EditUserID") AND (ObjectAction IS "View" OR ObjectAction IS "ShowForm")>
	<CFQUERY NAME="GetUser" DATASOURCE="#APPLICATION.DSN#">
		SELECT * FROM qry_GetUser WHERE UserID=<cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfoutput query="GetUser" startrow=1 maxrows=1>
		<Cfset EditFirstName="#FirstName#">
		<Cfset EditMiddleName="#MiddleName#">
		<Cfset EditLastName="#LastName#">
		<Cfset EditTitle="#Title#">
		<cfset EditOrganizationName="#OrganizationName#">
		<Cfset EditPhoneNumber="#PhoneNumber#">
		<Cfset EditFaxNumber="#FaxNumber#">
		<Cfset EditEmailAddress="#EmailAddress#">
		<cfset EditUserLogin="#UserLogin#">
		<cfset EditUserPassword="#UserPassword#">
	</cfoutput>
	<cfquery name="GetUsersGroups" datasource="#APPLICATION.DSN#">
		SELECT * FROM t_UserGroup WHERE UserID=<cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset EditUserGroupID=ValueList(GetUsersGroups.UserGroupID)>
</cfif>

</cfsilent>

<cfswitch expression="#Trim(ObjectAction)#">
	<cfcase value="ShowForm,Validate,View" delimiters=",">
		<cfset ErrorFieldList="">
		<!--- If ObjectAction is Validate, then show error messages. --->
		<cfif ATTRIBUTES.WriteForm IS "Yes">
			<cfoutput><form action="#ATTRIBUTES.FormAction#" method="post"></cfoutput>
		</cfif>
		<table>
		<TR><TD bgcolor="BAC0C9" colspan="3"><b>Personal Info</b></TD></TR>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="First Name" DefaultValue="#Trim(EditFirstName)#"
			VarName="EditFirstName"
			Required="Y"
			size="32" maxlength="32">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="M.I." DefaultValue="#Trim(EditMiddleName)#"
			VarName="EditMiddleName"
			Required="N"
			size="2" maxlength="1">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="Last Name" DefaultValue="#Trim(EditLastName)#"
			VarName="EditLastName"
			Required="Y"
			size="32" maxlength="32">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="multiselect" ObjectAction="#Trim(ObjectAction)#"
			caption="User Group" DefaultValue="#EditUserGroupID#"
			VarName="EditUserGroupID" Size="4"
			Required="Y" OptionValues="#UserGroupIDList#">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="Title" DefaultValue="#Trim(EditTitle)#"
			VarName="EditTitle"
			Required="N"
			size="32" maxlength="64">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="Organization Name" DefaultValue="#Trim(EditOrganizationName)#"
			VarName="EditOrganizationName"
			Required="N"
			size="40" maxlength="64">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="Phone" DefaultValue="#Trim(EditPhoneNumber)#"
			VarName="EditPhoneNumber"
			Required="N"
			size="14" maxlength="24">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="Fax" DefaultValue="#Trim(EditFaxNumber)#"
			VarName="EditFaxNumber"
			Required="N"
			size="14" maxlength="24">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="E-Mail" DefaultValue="#Trim(EditEmailAddress)#"
			VarName="EditEmailAddress" EmailAddress="Y"
			Required="N"
			size="32" maxlength="128">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfset ForceError="N">
		<cfif EditUserLogin IS NOT "" AND Trim(ObjectAction) IS "Validate">
			<cfquery name="CheckUserLogin" datasource="#APPLICATION.DSN#">
				select * from t_User where UserLogin=<cfqueryparam value="#Trim(EditUserLogin)#" cfsqltype="cf_sql_varchar"> AND UserID <> <cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif CheckUserLogin.RecordCount IS "0">
				<cfset ForceError="N">
			<cfelse>
				<cfset ForceError="Y">
			</cfif>
		</cfif>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="text" ObjectAction="#trim(ObjectAction)#"
			caption="Login" DefaultValue="#Trim(EditUserLogin)#"
			VarName="EditUserLogin"
			Required="Y" ForceError="#ForceError#" ForceErrorMessage="This login is already in use. Please select another."
			size="32" maxlength="16">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			type="password" ObjectAction="#trim(ObjectAction)#"
			caption="Password" DefaultValue="#Trim(EditUserPassword)#"
			VarName="EditUserPassword"
			Required="Y"
			size="32" maxlength="16">
		<cfset ErrorFieldList=ListAppend(ErrorFieldList,ErrorField)>

		<cfif trim(ObjectAction) IS "Validate">
			<cfparam name="FieldNames" default="">
			<cfset CALLER.ErrorFieldList=ErrorFieldList>
		</cfif>
		<TR><td align="right">&nbsp;</TD><TD></TD><TD>
		<cfif ATTRIBUTES.WriteForm IS "Yes">
			<input type="submit" name="ButSubmit" value="Finished!">
		</cfif>
		</td></TR>
		<cfif ATTRIBUTES.WriteForm IS "Yes">
			</form>
		</cfif></table>
	</cfcase>

	<cfcase value="CommitEdit,CommitAdd">
		<cftransaction>
			<cfif Trim(ObjectAction) IS "CommitAdd">
				<cfquery name="insertUser" datasource="#Application.DSN#">
					SET NOCOUNT ON
						INSERT INTO t_User (
						FirstName,
						MiddleName,
						LastName,
						Title,
						OrganizationName,
						PhoneNumber,
						FaxNumber,
						EmailAddress,
						UserLogin,
						UserPassword,
						LocaleID
						) VALUES (
						<cfqueryparam value="#TRIM(EditFirstName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#TRIM(EditMiddleName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#TRIM(EditLastName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#TRIM(EditTitle)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Trim(EditOrganizationName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#TRIM(EditPhoneNumber)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#TRIM(EditFaxNumber)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#TRIM(EditEmailAddress)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Trim(EditUserLogin)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Trim(EditUserPassword)#" cfsqltype="cf_sql_varchar">,
						1
						)
					SELECT UserID = @@Identity
					SET NOCOUNT OFF
				</cfquery>
				<cfset ATTRIBUTES.EditUserID=insertUser.UserID>
			<cfelse>
				<CFQUERY NAME="UpdateTeaser" DATASOURCE="#APPLICATION.DSN#">
					UPDATE t_User SET
					FirstName=<cfqueryparam value="#Trim(EditFirstName)#" cfsqltype="cf_sql_varchar">,
					MiddleName=<cfqueryparam value="#Trim(EditMiddleName)#" cfsqltype="cf_sql_varchar">,
					LastName=<cfqueryparam value="#Trim(EditLastName)#" cfsqltype="cf_sql_varchar">,
					Title=<cfqueryparam value="#Trim(EditTitle)#" cfsqltype="cf_sql_varchar">,
					OrganizationName=<cfqueryparam value="#Trim(EditOrganizationName)#" cfsqltype="cf_sql_varchar">,
					PhoneNumber=<cfqueryparam value="#Trim(EditPhoneNumber)#" cfsqltype="cf_sql_varchar">,
					FaxNumber=<cfqueryparam value="#Trim(EditFaxNumber)#" cfsqltype="cf_sql_varchar">,
					EmailAddress=<cfqueryparam value="#Trim(EditEmailAddress)#" cfsqltype="cf_sql_varchar">,
					UserLogin=<cfqueryparam value="#Trim(EditUserLogin)#" cfsqltype="cf_sql_varchar">,
					UserPassword=<cfqueryparam value="#Trim(EditUserPassword)#" cfsqltype="cf_sql_varchar">
					WHERE UserID=<cfqueryparam value="#val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="InsertUserGroup" datasource="#APPLICATION.DSN#">
					delete from t_UserGroup where UserID = <cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
			<cfloop index="ThisUserGroupID" list="#EditUserGroupID#">
				<cfif Val(ThisUserGroupID) GT "0">
					<cfquery name="InsertUserGroup" datasource="#APPLICATION.DSN#">
						INSERT Into t_UserGroup (
						UserID, UserGroupID
						) VALUES (
						<cfqueryparam value="#ATTRIBUTES.EditUserID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisUserGroupID)#" cfsqltype="cf_sql_integer">
						)
					</cfquery>
				</cfif>
			</cfloop>
			<cfset CALLER.EditUserID=ATTRIBUTES.EditUserID>
		</cftransaction>
	</cfcase>
	<cfcase value="ValidateDelete">
		<cfquery name="selectUser" datasource="#APPLICATION.DSN#">
			SELECT * FROM qry_GetUser WHERE UserID=<cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif selectUser.RecordCount GTE "1">
			<cfif ATTRIBUTES.WriteForm IS "Yes">
				<cfoutput><form action="#ATTRIBUTES.FormAction#" method="post"></cfoutput>
			</cfif>
			<p>Are you sure you want to delete the User, "<cfoutput>#selectUser.FirstName# #selectUser.MiddleName# #selectUser.LastName#</cfoutput>", from the system?</p>
			<cfif ATTRIBUTES.WriteForm IS "Yes">
				<P><input type="submit" name="SubmitButton" value="Yes"> <input type="button" onclick="history.go(-1);" value="No"></P>
				</form>
			</cfif>
		<cfelse>
			<p>That User does not exist.</p>
		</cfif>
	</cfcase>
	<cfcase value="CommitDelete">
		<cfquery name="DeleteTeaserCategory" datasource="#APPLICATION.DSN#">
			DELETE FROM t_User Where UserID=<cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfquery name="DeleteUserEvent" datasource="#APPLICATION.DSN#">
			Delete FROM t_UserGroup where UserID=<cfqueryparam value="#Val(ATTRIBUTES.EditUserID)#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfcase>
</cfswitch>

