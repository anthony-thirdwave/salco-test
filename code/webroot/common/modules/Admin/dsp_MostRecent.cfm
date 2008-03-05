
<cfquery name="GetLastUpdated" datasource="#APPLICATION.DSN#" maxrows="10">
SELECT * FROM qry_GetTracking 
WHERE ENTITY not like '%Locale'
Order By TrackingID desc
</cfquery>

<cfif GetLastUpdated.RecordCount GT "0">
	<table width="100%" cellpadding="3" style="border: 2px silver solid">
	
	<cfset Counter="1">
	<tr>
	<td width="14%" bgcolor="BAC0C9"><strong>Entity</strong></td>
	<td width="32%" nowrap bgcolor="BAC0C9"><b>Name</b></td>
	<td width="26%" bgcolor="BAC0C9"><b>Last Action</b></td>
	<td width="14%" bgcolor="BAC0C9">&nbsp;</td>
	</tr>
	<cfif GetLastUpdated.RecordCount IS NOT "0">
	<cfset lDeleted="">
	<cfoutput query="GetLastUpdated" maxrows="10">
		<cfif entity is "T_Category">
			<cfquery name="GetName" datasource="#APPLICATION.DSN#">
				SELECT CategoryName as Name, CategoryAlias, CategoryID FROM t_Category where Categoryid = #keyid#
			</cfquery> 
		<cfelse>
			<cfquery name="GetName" datasource="#APPLICATION.DSN#">
				SELECT ContentName as Name, CategoryAlias, CategoryID FROM qry_GetContent where Contentid = #keyid#
			</cfquery> 
		</cfif>
		<tr valign="top" bgcolor="EAEAEA">
		<td nowrap><span title="[ #keyid# ]">#ReplaceNoCase(entity,"t_","","All")#</span></td>
		<td>#EntityName#<cfif OperationID IS "506"><cfset lDeleted=ListAppend(lDeleted,"#entity##KeyID#")></cfif></td>
		<td align="left">
		<cfinvoke component="com.utils.tracking"
			method="GetTrackingRecord"
			trackingID="#TrackingID#"
			returnvariable="ReturnString">
			#Returnstring#&nbsp;
		</td>
		<td align="left" nowrap>
		<cfif OperationID IS "506" or ListFindNoCase(lDeleted,"#entity##KeyID#")>
		<cfelse>
			<a href="/content.cfm/#GetName.CategoryAlias#">View</A> <a href="/common/admin/Masterview/index.cfm?MVEid=1&mvcid=#KeyID#">Go To</a>
		</cfif>
		</td>
	</tr>
	</cfoutput>
	
	</cfif>
	</table>
</cfif>
