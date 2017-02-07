<!--- Pharmaio Pulldown Select Manager /index.cfm :: nw/3W 10214/02 --->
<!--- Application variables used --->
<cflock type="ReadOnly" name="#Application.ApplicationName#" timeout="1">
	<cfset DSN = Application.DSN>
	<cfset Key = Application.Key>
</cflock>

<!--- Header --->
<cfset PageTitle="Pulldown Manager">
<cfset PageHeader="<a href=""/common/admin/"">Main Menu</A> | Pulldown Manager">
<cfinclude template="/common/modules/display/dsp_AdminHeader.cfm">



<!--- Master List admin interface --->
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td valign="top"><cfmodule template="crud_PulldownOptions.cfm" labelGroupId="70" AllowEdit="Yes">
		&nbsp;
		<cfmodule template="crud_PulldownOptions.cfm" labelGroupId="80" AllowEdit="Yes">
		</td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td valign="top"><cfmodule template="crud_PulldownOptions.cfm" labelGroupId="90" AllowEdit="Yes">
		&nbsp;
		<cfmodule template="crud_PulldownOptions.cfm" labelGroupId="900" AllowEdit="Yes"></td>
	</tr>
</table>


<!--- Footer --->
<cfinclude template="/common/modules/display/dsp_AdminFooter.cfm">