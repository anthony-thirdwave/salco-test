<cfstoredproc procedure="sp_CMS_getRecentHistory" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetLastUpdated">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="TotalRows" value="5" null="No">
</cfstoredproc>


<cfif isDefined("GetLastUpdated") and GetLastUpdated.RecordCount GT "0">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	
	<cfset Counter="1">
	<tr style="height:25px;">
		<td><strong>PAGE</strong></td>
		<td><strong>ACTIONS</strong></td>
	</tr>
	<tr><td colspan="2"><div class="RuleSolid1"></div></td></tr>
	<cfif GetLastUpdated.RecordCount IS NOT "0">
	<cfset lDeleted="">
	<cfoutput query="GetLastUpdated" maxrows="10">
		<tr valign="top">
			<td align="left">
				<strong>#CategoryName#</strong><br/>
				By #FirstName# #LastName#<br>
				#DateFormat(TrackingDateTime,'mmm dd yyyy')#, #TimeFormat(TrackingDateTime,'h:mmtt')#
			</td>
			<td align="left">
			<cfif OperationID IS "506" or ListFindNoCase(lDeleted,"#entity##KeyID#")>
			<cfelse>
				<a href="/content.cfm/#CategoryAlias#" target="_blank"><img src="/common/images/admin/icon_preview.gif" border="0"/></a>&nbsp;
				<a href="/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#"><img src="/common/images/admin/icon_magnify.gif" border="0"/></a>&nbsp;
				<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#CGI.HTTP_HOST#/content.cfm/#CategoryAlias#%0AEdit: #URLEncodedFormat('http://#CGI.HTTP_HOST#/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></a>
			</cfif>
			</td>
		</tr>
		<tr><td colspan="2"><div class="RuleDotted1"></div></td></tr>
	</cfoutput>
	</cfif>
	</table>
</cfif>
