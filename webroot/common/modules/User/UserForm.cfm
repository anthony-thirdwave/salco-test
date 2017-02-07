
<cfquery name="GetUserGroups" datasource="#APPLICATION.DSN#">
select LabelID as UserGroupID, LabelName as UserGroupName from t_Label WHERE LabelGroupID=10
order by LabelPriority
</cfquery>

<!--- Declare domain of any object attributes --->
<cfset UserGroupIDList="">
<cfoutput query="GetUserGroups">
	<cfset UserGroupIDList=ListAppend(UserGroupIDList,"{#UserGroupID#|#UserGroupName#}","^^")>
</cfoutput>

<table>
<TR><TD bgcolor="BAC0C9" colspan="3"><b>Personal Info</b></TD></TR>
<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="First Name"
	ObjectName="MyUser"
	PropertyName="FirstName"
	Required="Y"
	size="32" maxlength="32">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="M.I."
	ObjectName="MyUser"
	PropertyName="MiddleName"
	Required="N"
	size="2" maxlength="1">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="Last Name"
	ObjectName="MyUser"
	PropertyName="LastName"
	Required="Y"
	size="32" maxlength="32">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="multiselect" ObjectAction="#FormMode#"
	caption="User Group"
	ObjectName="MyUser"
	PropertyName="UserGroupIDList" Size="8"
	Required="Y" OptionValues="#UserGroupIDList#">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="Title"
	ObjectName="MyUser"
	PropertyName="Title"
	Required="N"
	size="32" maxlength="64">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="Organization Name"
	ObjectName="MyUser"
	PropertyName="OrganizationName"
	Required="N"
	size="40" maxlength="64">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="Phone"
	ObjectName="MyUser"
	PropertyName="PhoneNumber"
	Required="N"
	size="32" maxlength="24">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="Fax"
	ObjectName="MyUser"
	PropertyName="FaxNumber"
	Required="N"
	size="32" maxlength="24">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="E-Mail"
	ObjectName="MyUser"
	PropertyName="EmailAddress" EmailAddress="Y"
	Required="N"
	size="32" maxlength="128">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="text" ObjectAction="#FormMode#"
	caption="Login"
	ObjectName="MyUser"
	PropertyName="UserLogin"
	Required="Y"
	size="32" maxlength="128">

<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	type="password" ObjectAction="#FormMode#"
	caption="Password"
	ObjectName="MyUser"
	PropertyName="UserPassword"
	Required="Y"
	size="32" maxlength="16">

</table>

