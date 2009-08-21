<cfparam name="ATTRIBUTES.FormAction" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#">
<cfparam name="ATTRIBUTES.EditAction" default="/common/admin/masterview/index.cfm?MVEid=1">
<cfparam name="ATTRIBUTES.DisplayMode" default="Default">
<cfparam name="ATTRIBUTES.CategoryID" default="-1">

<cfparam name="ParamStatusID" default="0">
<cfparam name="ParamTypeID" default="-1">
<cfparam name="ParamOrderBy" default="1">

<cfparam name="action" default=0>
<cfparam name="form.processThis" default="">
<cfparam name="processedMessage" default="">

<cfset processedMessage="">

<cfset QueryString="">
<cfset SearchFormVariables="ParamStatusID,ParamTypeID,ParamOrderBy">
<cfloop index="ThisParam" list="#SearchFormVariables#">
	<cf_AddToQueryString queryString="#QueryString#" Name="#ThisParam#" value="#Evaluate(ThisParam)#">
</cfloop>
<cf_AddToQueryString queryString="#QueryString#" Name="mvca" value="1">
<cfset ThisPageQueryString="#querystring#">

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString="">
<cfif ListLen(ATTRIBUTES.FormAction,"?") IS "2">
	<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>
</cfif>

<cfset EditPage=ListFirst(ATTRIBUTES.EditAction,"?")>
<cfset EditQueryString="">
<cfif ListLen(ATTRIBUTES.EditAction,"?") IS "2">
	<cfset EditQueryString=ListLast(ATTRIBUTES.EditAction,"?")>
</cfif>

<cfinvoke component="com.workflow.RequestHandler" method="GetRequestTypes" 
	returnVariable="GetRequestTypes">
	
<!----- mark a request as processed ----->
<cfif IsDefined ("form.action")>
	<cfloop index="i" from="1" to="#Numwf#" step="1">
		<cfparam name="FORM.wfid_#i#" default="-1">
		<cfset ThisWorkflowID=Evaluate("FORM.wfid_#i#")>
		<cfif IsDefined("wfid_mark_#i#")>
			<cfset SetThis=1>
		<cfelse>
			<cfset SetThis=0>
		</cfif>
		<cfif ThisWorkflowID GT "0">
			<cfinvoke component="com.workflow.RequestHandler" method="ToggleDismiss" 
				Dismiss="#SetThis#"
				RequestID="#Val(ThisWorkflowID)#"
				returnVariable="Success">
		</cfif>
	</cfloop>
	<cfset processedMessage="Your selections have been processed">
</cfif>

<cfinvoke component="com.workflow.RequestHandler" method="GetRequestByCategory" 
	ParamStatusID="#ParamStatusID#"
	ParamTypeID="#ParamTypeID#"
	ParamOrderBy="#ParamOrderBy#"
	CategoryID="#Val(ATTRIBUTES.CategoryID)#"
	returnVariable="GetWF">
	
<p><cfoutput>#processedMessage#</cfoutput></p>

<cf_AddToQueryString queryString="#FormQueryString#" Name="1" value="1" OmitList="#SearchFormVariables#">

<form name="processRequests" action="<cfoutput>#FormPage#?#QueryString#</cfoutput>" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	<TR><td colspan="5" align="right" class="bordertop2">
	<strong>Show</strong> 
	<select name="ParamStatusID"  onchange="this.form.submit()">>
	<option value="-1" <cfif ParamStatusID EQ -1>selected</cfif>>All</option>
	<option value="1" <cfif ParamStatusID EQ 1>selected</cfif>>Dismissed Requests</option>
	<option value="0" <cfif ParamStatusID EQ 0>selected</cfif>>Pending Requests</option>
	</select>
	<strong>Request Type</strong>
	<select name="ParamTypeID">
	<option value="-1" <cfif ParamTypeID EQ -1>selected</cfif>>All</option>
	<cfoutput query="GetRequestTypes">
		<option value="#RequestTypeID#" <cfif ParamTypeID EQ RequestTypeID>selected</cfif>>#RequestTypeName#</option>
	</cfoutput>
	</select>
	<strong>Order by</strong> <select name="ParamOrderBy">
	<option value="1" <cfif ParamOrderBy EQ 1>selected</cfif>>Date</option>
	<option value="3" <cfif ParamOrderBy EQ 3>selected</cfif>>From</option>
	<option value="4" <cfif ParamOrderBy EQ 4>selected</cfif>>To</option>
	</select>
	<input type="submit" name="Filter" value="Filter" />
	</TD></TR>
	<tr><td colspan="5">
		<div class="RuleDotted1"/>
	</td></tr>

<tr>
	<td><strong>FROM</strong></td>
	<td><strong>TO</strong></td>
	<td><strong>TYPE</strong></td>
	<td><strong>DATE</strong></td>
	<td><img src="/common/images/admin/icon_checkbox.gif"></td>
</tr>
</form>
<tr><td colspan="5">
	<div class="RuleSolid1"/>
</td></tr>
<cfif GetWF.RecordCount IS "0">
	<TR><td colspan="6" align="center" class="bordertop2">No requests</td></Tr></form>
<cfelse>
	<cf_AddToQueryString queryString="#FormQueryString#" Name="1" value="1">
	<cfset QueryString=ListAppend(QueryString,ThisPageQueryString,"&")>
	<form name="processRequests" action="<cfoutput>#FormPage#?#QueryString#</cfoutput>" method="post">
	<cfset Counter="1">
	<cfoutput query="GetWF" group="WorkflowRequestID">
		<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
		<tr valign="top">
		<td>#FromFirstName# #FromMiddleName# #FromLastName#
			<cfif FromEmailAddress IS NOT "">
				<a href="mailto:#FromEmailAddress#?subject=#WorkflowRequestTypeName#: #CategoryName#&body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost#/content.cfm/#CategoryAlias#%0AEdit: http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>
			</cfif>
			</td>
		<TD>
			<cfoutput group="RecipientUserGroupName">
				<cfif RecipientUserGroupName IS NOT "">#RecipientUserGroupName#<BR></cfif>
			</cfoutput>
			<cfoutput group="RecipientUserID">
				<cfif RecipientLastName IS NOT "">
					#RecipientFirstName# #RecipientMiddleName# #RecipientLastName#
					<cfif RecipientEmailAddress IS NOT "">
					<a href="mailto:#RecipientEmailAddress#?subject=#WorkflowRequestTypeName#: #CategoryName#&body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost#/content.cfm/#CategoryAlias#%0AEdit: http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>
				</cfif>
					<BR>
				</cfif>
			</cfoutput>
		</TD>
		<TD>#WorkflowRequestTypeName#: <span title="[ #CategoryID# ]">#CategoryName#</span></td>
		<TD nowrap>
			#REQUEST.OutputDateTime(WorkFlowRequestDateTime)#
		</TD>
		<td>
			<input type="checkbox" name="wfid_mark_#Counter#" value="1" <cfif Val(Dismissed)>checked</cfif>/>
			<input type="hidden" name="wfid_#Counter#" value="#WorkflowRequestID#"/>
		</td>
		</tr>
		<TR>
		<TD class="borderbottom1">&nbsp;</TD>
		<TD class="borderbottom1" colspan="5">#REQUEST.AddBreaks(Message)#</TD></TR>
		<tr><td colspan="5">
			<div class="RuleDotted1"/>
		</td></tr>
		<cfset Counter=Counter+1>
	</cfoutput>
	<tr>
		<td colspan="5" align="right"><input type="hidden" name="action" value="1"/>
		<cfif ParamStatusID IS "1">
			<input type="submit" name="Process" value="Dismiss Checked Items" class="button"/></td>
		<cfelse>
			<input type="submit" name="Process" value="Dismiss Checked Items" class="button"/></td>
		</cfif>
		<cfoutput><input type="hidden" name="Numwf" value="#Counter-1#"></cfoutput>
	</tr>
</cfif>
</table>
</form>
