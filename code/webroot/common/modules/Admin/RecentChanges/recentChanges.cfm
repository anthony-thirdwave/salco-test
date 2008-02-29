
<!--- <cfquery name="GetLastUpdated" datasource="#APPLICATION.DSN#" maxrows="5">
SELECT gt.*, u.FirstName, u.lastName, c.CategoryName, c.CategoryAlias FROM qry_GetTracking gt
INNER JOIN t_Category c ON c.CategoryID = gt.KeyID 
INNER JOIN t_user u ON u.UserID = gt.UserID
WHERE gt.ENTITY = 't_Category'
Order By gt.TrackingID desc
</cfquery>

EXEC sp_CMS_getRecentHistory @totalRows --->

<cfstoredproc procedure="sp_CMS_getRecentHistory" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetLastUpdated">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="TotalRows" value="5" null="No">
</cfstoredproc>


<cfif isDefined("GetLastUpdated") and GetLastUpdated.RecordCount GT "0">
	<table width="350" cellpadding="0" cellspacing="0" border="0">
	
	<cfset Counter="1">
	<tr style="height:25px;">
		<td width="13%"><img src="/common/images/admin/icon_checkbox.gif" style="padding-left:3px; " border="0"/></td>
		<td width="13%"><img src="/common/images/admin/icon_clipboard.gif" border="0"/></td>
		<td width="49%"><strong>PAGE</strong></td>
		<td width="25%"><strong>ACTIONS</strong></td>
	</tr>
	<tr><td colspan="4"><div class="RuleSolid1"></div></td></tr>
	<!--- <tr><td colspan="4" style=" border-top:1px solid #999999;"><img src="/common/images/spacer.gif" height="1" width="1" border="0"/></td></tr> --->
	<cfif GetLastUpdated.RecordCount IS NOT "0">
	<cfset lDeleted="">
	<cfoutput query="GetLastUpdated" maxrows="10">
		<tr valign="top">
			<td><input type="checkbox" name="categoryIDs" value="#KeyID#"></td>
			<td><img src="/common/images/admin/icon_email.gif" border="0"/></td>
			<td align="left">
				<strong>#CategoryName#</strong><br/>
				By #FirstName# #LastName#<br>
				#DateFormat(TrackingDateTime,'mmm dd yyyy')#, #TimeFormat(TrackingDateTime,'h:mmtt')#
			</td>
			<td align="left">
			<cfif OperationID IS "506" or ListFindNoCase(lDeleted,"#entity##KeyID#")>
			<cfelse>
				<a href="/content.cfm/#CategoryAlias#" target="_blank"><img src="/common/images/admin/icon_preview.gif" border="0"/></a>&nbsp;
				<a href="/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#"><img src="/common/images/admin/icon_magnify.gif" border="0"/></a>
			</cfif>
			</td>
		</tr>
		<tr><td colspan="4"><div class="RuleDotted1"></div></td></tr>
	</cfoutput>
		<tr>
			<td colspan="4" style="font-weight:bold; height:25px;"><strong>GROUP ACTIONS:</strong> <a style="font-weight:bold; ">Request to Publish</a></td>
		</tr>
		<tr><td colspan="4"><div class="RuleSolid1"></div></td></tr>
		<tr>
			<td colspan="4" style="font-weight:bold; height:25px;"><a style="font-weight:bold; ">See All</a></td>
		</tr>
	</cfif>
	</table>
</cfif>
