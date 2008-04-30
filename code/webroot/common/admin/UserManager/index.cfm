
<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="User Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | User Manager">
	
<cfparam name="ParamFirstName" default="">
<cfparam name="ParamLastName" default="">
<cfparam name="ParamEmailAddress" default="">
<cfparam name="ParamOrganizationName" default="">
<cfparam name="ParamUserGroupID" default="">

<cfset DevNull=DeleteClientVariable("OrderBy")>
<cfset DevNull=DeleteClientVariable("OrderASC")>
<cfparam name="OrderBy" default="LastName">
<cfparam name="OrderAsc" default="1">
<cfset PathPage=CGI.SCRIPT_NAME>
<cfset PathQueryString=CGI.Query_String>

<cfset ErrorMessage="">

<cfif IsDefined("RR")>
	<cfset ReturnResults="Yes">
<cfelse>
	<cfset ReturnResults="No">
</cfif>

<cfset sStateProvince=StructNew()>
<cfoutput query="Application.GetStateProvinces">
	<cfset DevNull=StructInsert(sStateProvince,StateProvinceID,StateProvinceName,1)>
</cfoutput>

<cfset PageAction=CGI.SCRIPT_NAME>
<cfset PageQueryString=CGI.Query_String>
<cfset sUserGroup=StructNew()>

<cfquery name="GetUserGroups" datasource="#APPLICATION.DSN#">
	select LabelID as UserGroupID, LabelName as UserGroupName from t_Label WHERE LabelGroupID=10
	order by LabelPriority
</cfquery>

<cfif ReturnResults>
	<cfquery name="GetUserPre" datasource="#APPLICATION.DSN#">
		SELECT distinct(UserID)
		FROM qry_GetUser WHERE 1=1
		AND
		<cfif Trim(ParamFirstName) IS NOT "">
			(
			<cfloop index="ThisParam" list="#ParamFirstName#" delimiters=" ">
				(FirstName like '#ThisParam#%') AND
			</cfloop>1=1)
		<cfelse>
			1=1
		</cfif>
		AND
		<cfif Trim(ParamLastName) IS NOT "">
			(
			<cfloop index="ThisParam" list="#ParamLastName#" delimiters=" ">
				(LastName like '#ThisParam#%') AND
			</cfloop>1=1)
		<cfelse>
			1=1
		</cfif>
		AND
		<cfif Trim(ParamEmailAddress) IS NOT "">
			(
			<cfloop index="ThisParam" list="#ParamEmailAddress#" delimiters=" ">
				(EmailAddress like '#ThisParam#%') AND
			</cfloop>1=1)
		<cfelse>
			1=1
		</cfif>
		AND
		<cfif Trim(ParamOrganizationName) IS NOT "">
			(
			<cfloop index="ThisParam" list="#ParamOrganizationName#" delimiters=" ">
				(OrganizationName like '#ThisParam#%') AND
			</cfloop>1=1)
		<cfelse>
			1=1
		</cfif>
		AND
		<cfif val(ParamUserGroupID) gt "0">
			UserGroupID=#Val(ParamUserGroupID)#
		<cfelse>
			1=1
		</cfif>
	</cfquery>

	<cfif GetUserPre.RecordCount IS "0">
		<cfset ThisList="-1">
	<cfelse>
		<cfset ThisList=ValueList(GetUserPre.UserID)>
	</cfif>

	<cfquery name="GetUser" datasource="#APPLICATION.DSN#">
		SELECT *
		FROM qry_GetUser WHERE UserID IN (#ThisList#)
		ORDER BY #OrderBy# <cfif OrderAsc>ASC<Cfelse>DESC</cfif>
	</cfquery>

	<cfoutput query="GetUser">
		<cfif NOT StructKeyExists(sUserGroup,UserID)>
			<cfset DevNull=StructInsert(sUserGroup,UserID,"",0)>
		</cfif>
		<cfif NOT ListFindNoCase(sUserGroup[UserID],UserGroupName)>
			<cfset sUserGroup[UserID]=ListAppend(sUserGroup[UserID],UserGroupName)>
		</cfif>
	</cfoutput>
</cfif>

<cfset FieldNameList="ParamFirstName,ParamLastName,ParamEmailAddress,ParamOrganizationName,ParamUserGroupID">
<cfset l_Col="FirstName,LastName,EmailAddress,OrganizationName,UserGroupName">
<cfset l_ColDescr="First Name,Last Name,Email Address,Organization,Group">

<cfset FieldList="">
<cfloop index="ThisFieldName" list="#FieldNameList#">
	<cfif isdefined("#ThisFieldName#")>
		<cfif Len(trim(Evaluate("#ThisFieldName#"))) IS NOT "0">
			<cfset FieldList=ListAppend(FieldList,"#ThisFieldName#=#URLEncodedFormat(evaluate('#ThisFieldName#'))#","&")>
		</cfif>
	</cfif>
</cfloop>
<table bgcolor="silver"><tr valign="top"><TD bgcolor="white">

<table cellpadding="3">
<cf_AddToQueryString querystring="#PageQueryString#" name="" value="" OmitList="#FieldNameList#">
<cfset BaseString=querystring>
<cfif OrderAsc>
	<cfset ThisOrderAsc="0">
	<cfset arrowimage="/common/images/widget_arrow_down.gif">
<cfelse>
	<cfset ThisOrderASc="1">
	<cfset arrowimage="/common/images/widget_arrow_up.gif">
</cfif>
<!--- <TD><b><a href="index.cfm?OrderBy=Name&OrderAsc=#ThisOrderAsc#&#FieldList#">Name</A></b></TD> --->

<tr bgcolor="bac0c9">
<cfoutput>
	<cfloop index="i" from="1" to="#ListLen(l_Col)#" step="1">
		<cfset ThisCol=ListGetAt(l_Col,i)>
		<Cfset ThisColDescr=ListGetAt(l_ColDescr,i)>
		<td valign="top" nowrap>
		<cf_AddToQueryString QueryString="#BaseString#" name="OrderBy" value="#ThisCol#">
		<cf_AddToQueryString QueryString="#QueryString#" name="OrderASc" value="#OrderAsc#">
		<cf_AddToQueryString QueryString="#QueryString#" name="rr" value="1">
		<cfset QueryString=ListAppend(QueryString,FieldList,"&")>
		<cfif ReturnResults IS "NO">
			<p><b>#ThisColDescr#</b></p>
		<cfelseif orderBy IS ThisCol>
			<cf_AddToQueryString QueryString="#QueryString#" name="OrderASc" value="#ThisOrderAsc#">
			<p><b><a href="#PageAction#?#QueryString#"><img src="#arrowimage#" border=0 alt="">#ThisColDescr#</a></b></p>
		<cfelseif ListFind("UserGroupName",ThisCol)>
			<p><b>#ThisColDescr#</b></p>
		<cfelse>
			<p><b><a href="#PageAction#?#QueryString#">#ThisColDescr#</A></b></p>
		</cfif>
		</td>
	</cfloop>
</cfoutput>
<TD>
<a href="/common/admin/UserManager/UserModify.cfm?uoa=3"><b>Add</b></A>
</TD></tr>

<cfoutput>
<cf_AddToQueryString querystring="#PageQueryString#" name="rr" value="1" omitlist="#FieldNameList#">
<form action="#PageAction#?#QueryString#" method="post"><input type="hidden" name="OrderAsc" value="#OrderAsc#">
<tr bgcolor="EAEAEA">
<td><input type="text" name="ParamFirstName" value="#ParamFirstName#" size="10"></td>
<td><input type="text" name="ParamLastName" value="#ParamLastName#" size="10"></td>
<td><input type="text" name="ParamEmailAddress" value="#ParamEmailAddress#" size="10"></td>
<td><input type="text" name="ParamOrganizationName" value="#ParamOrganizationName#" size="10"></td>
<td>
</cfoutput>
<select name="ParamUserGroupID">
	<option value="" <cfif ParamUserGroupID IS "">selected</cfif>>All</option>
<cfoutput query="GetUserGroups">
	<option value="#UserGroupID#" <cfif ParamUserGroupID IS UserGroupID>selected</cfif>>#UserGroupName#</option>
</cfoutput>
</select>
</td>
<td><input type="submit" name="Search" value="Search"></td></TR>
</form>
<cfif ReturnResults IS "No">
	<TR><TD colspan="4" align="center"><b>Please select parameters from above and click "Search".</b></TD></tR>
<cfelseif GetUser.RecordCount GT "0">
	<cfset Counter="0">
	<cfoutput query="GetUser" group="UserID">
		<cfset Counter=Counter+1>
		<CFIF (Counter MOD 2) IS 1><cfset BGColor="white"><cfelse><cfset BGColor="EAEAEA"></cfif>
		<cfset uid=Encrypt(UserID,APPLICATION.Key)>
		<TR bgcolor="#bgcolor#" valign="top">
		<td>#FirstName#</td>
		<td>#LastName#</td>
		<TD>#EmailAddress#</TD>
		<TD>#OrganizationName#</TD>
		<td>#ListChangeDelims(sUserGroup[UserID],", ")#</td>
		<TD><a href="/common/admin/UserManager/UserModify.cfm?uid=#URLEncodedFormat(uid)#&uoa=2"><b>Edit</b></a>
		<a href="/common/admin/UserManager/UserModify.cfm?uid=#URLEncodedFormat(uid)#&uoa=4"><b>Delete</b></A></TD>
		</TR>
	</cfoutput>
<cfelse>
	<TR><TD colspan="4" align="center"><b>No Records Found</b></TD></tR>
</cfif>
</table></TD></TR></table>
<p>&nbsp;</p>
<cfmodule template="/common/admin/PulldownOptionsManager/crud_PulldownOptions.cfm" labelGroupId="10" AllowEdit="Yes">

</cfmodule>