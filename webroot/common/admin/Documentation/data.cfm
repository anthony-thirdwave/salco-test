<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Data Structure"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Data Structure">
	
	
<cfstoredproc procedure="sp_util_getDataStructure" datasource="#Application.DSN#" >
	<cfprocresult name="tables" resultset="1">
	<cfprocresult name="defaults" resultset="2">
</cfstoredproc>

<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">Data Structure</div>
		<div class="ModuleBody2">
		
		

<br>
<b>This chart shows the current structure of the database for <cfoutput>#Application.DSN#</cfoutput>.</b><br>
<br>&nbsp;
<cfset bgcolor = "FFFFFF">
<table width="800" cellpadding="2" cellspacing="0" bordercolor="#000000" border="1">
<tr bgcolor="#bac0c9">
	<td width="250"><strong>Table Name</strong></td>
	<td width="250"><strong>Field Name</strong></td>
	<td width="100"><strong>DataType</strong></td>
	<td width="100"><strong>Size</strong></td>
	<td width="100"><strong>Is Nullable</strong></td>
</tr>
<cfoutput query="tables" group="TableName">
	<cfif bgcolor IS "FFFFFF">
		<cfset bgcolor = "EAEAEA">
	<cfelse>
		<cfset bgcolor = "FFFFFF">
	</cfif>
	<tr valign="top" bgcolor="#bgColor#">
		<td>#tableName#</td>
		<td colspan="4">
			<table cellpadding="0" cellspacing="0">
			<cfoutput>
			<tr>
				<td width="247">#fieldName#</td>
				<td width="110">#dataType#</td>
				<td width="100">#Size#</td>
				<td width="100">#IsNullable#</td>
			</tr>
			</cfoutput>
			</table>
		</td>
	</tr>		
</cfoutput>
</table>
<!--- Showing the defaults for each table --->
<br><br>
<b>This chart shows the defaults of the database for <cfoutput>#Application.DSN#</cfoutput>.</b><br>
<br>&nbsp;
<table width="600" cellpadding="2" cellspacing="0" bordercolor="#000000" border="1">
<tr bgcolor="#bac0c9">
	<td width="250"><strong>Table Name</strong></td>
	<td width="250"><strong>Field Name</strong></td>
	<td width="100"><strong>Check/Default Constraint Text</strong></td>
</tr>
	<cfoutput query="defaults" group="TableName">
	<cfif bgcolor IS "FFFFFF">
		<cfset bgcolor = "EAEAEA">
	<cfelse>
		<cfset bgcolor = "FFFFFF">
	</cfif>
	<tr valign="top" bgcolor="#bgColor#">
		<td>#tableName#</td>
		<td colspan="2">
			<table cellpadding="0" cellspacing="0" border="0">
			<cfoutput>
			<tr>
				<td width="250">#fieldName#</td>
				<td width="100">#default#</td>
			</tr>
			</cfoutput>
			</table>
		</td>
	</tr>		
</cfoutput>
</table>








</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>


</cfmodule>