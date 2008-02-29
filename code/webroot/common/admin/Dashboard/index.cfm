<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Dashboard"
	PageHeader="<a href=""/common/admin/"" class=""white"">Main Menu</A> | Dashboard">
<cfinclude template="/common/admin/Dashboard/_InitDashboard.cfm">
<cflock scope="session" type="readonly" timeout="5">
	<cfset qDashboard=SESSION.qUserDashboard>
</cflock>

<cfif APPLICATION.Staging IS "0" and APPLICATION.Production is "0">
<cfoutput>
<p style="border:1px red solid; padding:5px;">This is the development server. The staging server can be accessed at <a href="#APPLICATION.StagingURL#">#APPLICATION.StagingURL#</a>.</p>
</cfoutput>
</cfif>

<table width="940" cellpadding="2" cellspacing="0" border="0">
	<tr valign="top">
	<cfloop index="ThisColumn" list="400,401,402">
		<cfif ThisColumn IS "401">
			<cfset ThisColWidth="370">
			<cfset ThisClass="Wide">
		<cfelse>
			<cfset ThisColWidth="275">
			<cfset ThisClass="Normal">
		</cfif>
		<td width="<cfoutput>#ThisColWidth#</cfoutput>" style="padding-right:10px;">
			<cfquery name="GetTheseModules" dbtype="query">
				SELECT * FROM qDashboard
				WHERE HasPermission = 1
				AND IsActive = 1
				AND ModulePosition = #ThisColumn#
				ORDER BY Priority
			</cfquery>
			
			<cfoutput query="GetTheseModules">
				<div class="dashModule#ThisClass#">
				<div class="box1">
					<div class="boxtop1"><div></div></div>
					<div class="ModuleTitle1">#Name#</div>
					<div class="ModuleBody1">
					  <cfmodule template="#Path#">
					</div>
				</div>
				</div>
				&nbsp;
			</cfoutput>
			&nbsp;
		</td>
	</cfloop>
	</tr>
</table>
</cfmodule>