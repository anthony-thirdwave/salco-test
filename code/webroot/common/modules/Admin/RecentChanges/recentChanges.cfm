<cfparam name="ATTRIBUTES.DisplayMode" default="Dashboard">

<cfquery name="GetTrackingHistory" datasource="#APPLICATION.DSN#">
	select * from qry_GetTrackingHistory
	ORDER BY TrackingDateTime DESC
</cfquery>


<cfif ATTRIBUTES.DisplayMode IS "Dashboard">
	<cfif GetTrackingHistory.RecordCount GT "0">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		
		<cfset Counter="1">
		<tr style="height:25px;">
			<td><strong>PAGE</strong></td>
			<td><strong>ACTIONS</strong></td>
		</tr>
		<tr><td colspan="2"><div class="RuleSolid1"></div></td></tr>
		<cfset lDeleted="">
		<cfoutput query="GetTrackingHistory" maxrows="5">
			<tr valign="top">
				<td align="left">
					<strong>#CategoryName#</strong><br/>
					By #FirstName# #LastName#<br>
					#APPLICATION.utilsObj.OutputDateTime(TrackingDateTime)#
				</td>
				<td align="left">
				<cfif OperationID IS "506" or ListFindNoCase(lDeleted,"#entity##KeyID#")>
				<cfelse>
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0" title="Preview Page in new Tab"/></a>&nbsp;
					<a href="/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#" title="Edit"><img src="/common/images/admin/icon_edit.gif" title="Go to content in Masterview" border="0"/></a>&nbsp;
					<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#CGI.HTTP_HOST##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#CGI.HTTP_HOST#/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></a>
				</cfif>
				</td>
			</tr>
			<tr><td colspan="2"><div class="RuleDotted1"></div></td></tr>
		</cfoutput>
		<!--- <tr>
			<td colspan="2" style="height:25px;"><strong><a href="/common/admin/Masterview/RecentChanges.cfm">See All</A></strong></td>
		</tr> --->
		</table>
	</cfif>
<cfelse>
	<cfif GetTrackingHistory.RecordCount GT "0">
		<table  cellpadding="0" cellspacing="0" border="0">
		
		<cfset Counter="1">
		<tr style="height:25px;">
			<td><strong>PAGE</strong></td>
			<td><strong>ACTIONS</strong></td>
		</tr>
		<tr><td colspan="2"><div class="RuleSolid1"></div></td></tr>
		<cfset lDeleted="">
		<cfoutput query="GetTrackingHistory">
			<tr valign="top">
				<td align="left">
					<strong>#CategoryName#</strong><br/>
					By #FirstName# #LastName#<br>
					#APPLICATION.utilsObj.OutputDateTime(TrackingDateTime)#
				</td>
				<td align="left">
				<cfif OperationID IS "506" or ListFindNoCase(lDeleted,"#entity##KeyID#")>
				<cfelse>
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0" title="Preview Page in new Tab"/></a>&nbsp;
					<a href="/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#" title="Edit"><img src="/common/images/admin/icon_edit.gif" title="Go to content in Masterview" border="0"/></a>&nbsp;
					<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#CGI.HTTP_HOST##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#CGI.HTTP_HOST#/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></a>
				</cfif>
				</td>
			</tr>
			<tr><td colspan="2"><div class="RuleDotted1"></div></td></tr>
		</cfoutput>
		</table>
	</cfif>
</cfif>
