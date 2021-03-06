<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="User Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | User Manager">
	
<cfparam name="firstName" default="">
<cfparam name="lastName" default="">
<cfparam name="emailAddress" default="">
<cfparam name="organizationName" default="">
<cfparam name="paramUserGroupId" default="">

<cfquery name="GetUserGroups" datasource="#APPLICATION.DSN#">
	SELECT		LabelID AS UserGroupID, LabelName AS UserGroupName
	FROM		t_Label
	WHERE		LabelGroupID= <cfqueryparam cfsqltype="cf_sql_integer" value="10" />
	ORDER BY	LabelPriority
</cfquery>

<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">Users</div>
		<div class="ModuleBody2">
<cfoutput>


	<cfform action="#CGI.SCRIPT_NAME#" method="post" name="userEditForm">
		<table cellspacing="0px" cellpadding="3px">
			<tr>
				<th>&nbsp;</th>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email Address</th>
				<th>Organization</th>
				<th>Group</th>
			</tr>
			<tr bgcolor="##666666">
				<td>
					<font color="##FFFFFF"><strong>Search By:</strong></font>
				</td>
				<td>
					<cfinput type="text" name="firstName" value="#firstName#">
				</td>
				<td>
					<cfinput type="text" name="lastName" value="#lastName#">
				</td>
				<td>
					<cfinput type="text" name="emailAddress" value="#emailAddress#">
				</td>
				<td>
					<cfinput type="text" name="organizationName" value="#organizationName#">
				</td>
				<td>
					<cfselect name="paramUserGroupID">
						<option value="" <cfif paramUserGroupID IS "">selected</cfif>>All</option>
						<cfloop query="GetUserGroups">
							<option value="#getUserGroups.UserGroupID#" <cfif paramUserGroupID eq getUserGroups.UserGroupID>selected</cfif>>#getUserGroups.UserGroupName#</option>
						</cfloop>
					</cfselect>
				</td>
			</tr>
			<tr>
				<td colspan="6"><strong>Results</strong>
				<div style="float:right"><a href="/common/admin/UserManager/UserModify.cfm?uoa=3">Add New User</a></div>
				</td>
			</tr>

			<tr>
				<td colspan="6">
					<!--- display the users in a cfgrid tag - this is bound both to the cfgrid
					controls and the form controls above --->
					<cfgrid format="html" name="showUsers" gridLines="yes"
							selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
							appendKey="true"
							bind="cfc:com.user.UserHandler.getUsers({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn}, 
								{cfgridsortdirection}, {firstName@keyup}, {lastName@keyup}, {emailAddress@keyup}, 
								{organizationName@keyup}, {paramUserGroupID@change})">
						<cfgridcolumn name="userId" display="no" />
						<cfgridcolumn name="firstName" header="First Name" width="100" />
						<cfgridcolumn name="lastName" header="Last Name" width="100" />
						<cfgridcolumn name="emailAddress" header="Email Address" width="200" />
						<cfgridcolumn name="organizationName" header="Organization" width="100" />
						<cfgridcolumn name="userGroups" header="Groups" width="200" />
						<cfgridcolumn name="edit" header="" width="24" href="/common/admin/UserManager/UserModify.cfm?uoa=2" hrefKey="userId"/>
						<cfgridcolumn name="delUser" header="" width="24" href="/common/admin/UserManager/UserModify.cfm?uoa=4" hrefKey="userId"/>
					</cfgrid>
				</td>
			</tr>
		</table>
			
	</cfform>
		
</cfoutput>
</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>
<p>&nbsp;</p>


<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">User Groups</div>
		<div class="ModuleBody2">
<cfif 1>
	<cfmodule template="/common/admin/PulldownOptionsManager/crud_PulldownOptions.cfm" labelGroupId="10" AllowEdit="Yes">
</cfif>
</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>


</cfmodule>