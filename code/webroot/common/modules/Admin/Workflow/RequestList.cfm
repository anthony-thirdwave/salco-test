<cfparam name="ATTRIBUTES.FormAction" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#">
<cfparam name="ATTRIBUTES.EditAction" default="/common/admin/masterview/index.cfm?MVEid=1">
<cfparam name="ATTRIBUTES.DisplayMode" default="Default">
<cfparam name="thisFilter" default="">
<cfparam name="thisSortOrder" default="">

<cfparam name="ParamFolder" default="Inbox">
<cfparam name="ParamStatusID" default="0">
<cfparam name="ParamTypeID" default="-1">
<cfparam name="ParamOrderBy" default="1">
<cfparam name="action" default=0>
<cfparam name="form.processThis" default="">
<cfparam name="processedMessage" default="">

<cfset QueryString="">
<cfset SearchFormVariables="ParamFolder,ParamStatusID,ParamTypeID,ParamOrderBy">
<cfloop index="ThisParam" list="#SearchFormVariables#">
	<cf_AddToQueryString queryString="#QueryString#" Name="#ThisParam#" value="#variables[ThisParam]#">
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
	<cfif IsDefined("FORM.Process") and FORM.Process is "Publish Checked Items">
		<cfset lCategoryIDToPublish="">
		<cfloop index="i" from="1" to="#Numwf#" step="1">
			<cfparam name="FORM.wfid_#i#" default="-1">
			<cfset ThisWorkflowID=FORM["wfid_#i#"]>
			<cfif IsDefined("wfid_mark_#i#")>
				<cfset SaveThis=1>
			<cfelse>
				<cfset SaveThis=0>
			</cfif>
			<cfif ThisWorkflowID GT "0" and SaveThis IS "1">
				<cfinvoke component="com.workflow.RequestHandler" method="GetRequest"
					WorkflowRequestID="#Val(ThisWorkflowID)#"
					returnVariable="GetWF">
				<cfset lCategoryIDToPublish=ListAppend(lCategoryIDToPublish,GetWF.CategoryID)>
			</cfif>
		</cfloop>
		<cfloop index="ThisCategoryID" list="#lCategoryIDToPublish#">
			<cfinvoke component="com.ContentManager.CategoryHandler"
				method="GetCategoryLocaleID"
				returnVariable="ThisCategoryLocaleID"
				CategoryID="#ThisCategoryID#"
				LocaleID="#APPLICATION.DefaultLocaleID#">

			<!--- Mark page as "live" --->
			<cfquery name="UpdateWorkflowStatusID" datasource="#APPLICATION.DSN#">
				update t_CategoryLocale Set
				WorkflowStatusID=<cfqueryparam value="18000" cfsqltype="cf_sql_integer">
				WHERE
				CategoryLocaleID=<cfqueryparam value="#ThisCategoryLocaleID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<!--- Create snap shot --->
			<cfinvoke component="com.ContentManager.CategoryHandler"
				method="GetCategoryBasicDetails"
				returnVariable="qCategory"
				CategoryID="#Val(ThisCategoryID)#">
			<cfinvoke component="com.ContentManager.SnapShotHandler"
				method="CreateSnapShot"
				CategoryID="#Val(ThisCategoryID)#"
				LocaleID="#APPLICATION.DefaultLocaleID#"
				returnVariable="SnapShotParentID">
			<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
				UserID="#SESSION.AdminUserID#"
				Entity="Category"
				KeyID="#Val(ThisCategoryID)#"
				Operation="revisioncreate"
				EntityName="#qCategory.CategoryName#">
			<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
				UserID="#SESSION.AdminUserID#"
				Entity="SnapShot"
				KeyID="#Val(SnapShotParentID)#"
				Operation="create"
				EntityName="Snapshot: #qCategory.CategoryName#">
		</cfloop>
		<cfif APPLICATION.Staging>
			<cfinvoke component="com.ContentManager.CategoryHandler"
				method="SavePages"
				returnVariable="bSuccess"
				UserID="#SESSION.AdminUserID#"
				LocaleID="#APPLICATION.DefaultLocaleID#"
				lCategoryID="#lCategoryIDToPublish#">
		<cfelse>
			<cfdump var="#lCategoryIDToPublish#">
		</cfif>
		<cfset processedMessage="Your selections have been published">
		<cf_AddToQueryString queryString="#FormQueryString#" name="processedMessage" value="#processedMessage#">
		<cflocation url="#FormPage#?#QueryString#" addToken="no">
	<cfelse>
		<cfloop index="i" from="1" to="#Numwf#" step="1">
			<cfparam name="FORM.wfid_#i#" default="-1">
			<cfset ThisWorkflowID=FORM["wfid_#i#"]>
			<cfif IsDefined("wfid_mark_#i#")>
				<cfset SetThis=1>
			<cfelse>
				<cfset SetThis=0>
			</cfif>
			<cfif ThisWorkflowID GT "0">
				<cfquery name="processRequest" datasource="#APPLICATION.DSN#">
					UPDATE t_WorkflowRequest
					SET Dismissed = #Val(SetThis)#
					WHERE WorkflowRequestID = #Val(ThisWorkflowID)#
				</cfquery>
			</cfif>
		</cfloop>
		<cfset processedMessage="Your selections have been processed">
	</cfif>
</cfif>

<!----- sort the results ----->
<cfswitch expression="#ParamOrderBy#">
	<cfcase value="2">
		<cfset thisSortOrder="Order By CategoryName">
	</cfcase>
	<cfcase value="3">
		<cfset thisSortOrder="Order By FromLastName, FromFirstName">
	</cfcase>
	<cfcase value="4">
		<cfset thisSortOrder="Order By RecipientLastName, RecipientFirstName">
	</cfcase>
	<cfcase value="0">
		<cfset thisSortOrder="">
	</cfcase>
	<cfdefaultcase>
		<cfset thisSortOrder="Order By WorkflowRequestDateTime DESC">
	</cfdefaultcase>
</cfswitch>
<!----- /sort the results ----->


<cfinvoke component="com.workflow.RequestHandler" method="GetRequests"
	UserID="#SESSION.AdminUserID#"
	UserGroupIDList="#SESSION.AdminUserGroupIDList#"
	ParamStatusID="#ParamStatusID#"
	ParamTypeID="#ParamTypeID#"
	ParamOrderBy="#ParamOrderBy#"
	returnVariable="GetWF">

<p><cfoutput>#processedMessage#</cfoutput></p>

<cf_AddToQueryString queryString="#FormQueryString#" Name="1" value="1" OmitList="#SearchFormVariables#">

<form name="processRequests" action="<cfoutput>#FormPage#?#QueryString#</cfoutput>" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfif ATTRIBUTES.DisplayMode IS NOT "DashBoard">
	<TR><TD colspan="6">
	<!--- <strong>Folder</strong>
	<select name="ParamFolder" onchange="this.form.submit()">
		<option value="inbox" <cfif ParamFolder EQ "inbox">selected</cfif>>Inbox</option>
		<option value="outbox" <cfif ParamFolder EQ "outbox">selected</cfif>>Outbox</option>
	</select> --->
	<strong>Show</strong> <select name="ParamStatusID"  onchange="this.form.submit()">>
		<option value="-1" <cfif ParamStatusID EQ -1>selected</cfif>>All</option>
		<option value="1" <cfif ParamStatusID EQ 1>selected</cfif>>Processed Requests</option>
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
		<option value="2" <cfif ParamOrderBy EQ 2>selected</cfif>>Page</option>
		<option value="3" <cfif ParamOrderBy EQ 3>selected</cfif>>From</option>
		<option value="4" <cfif ParamOrderBy EQ 4>selected</cfif>>To</option>
	</select>
	<input type="submit" name="Filter" value="filter" /></TD></TR>
	<tr><td colspan="6">
		<div class="RuleDotted1"/>
	</td></tr>
</cfif>
<cfif GetWF.RecordCount IS "0">
	<TR><td colspan="6">No requests</td></Tr></form>
<cfelse>
	<cfif ATTRIBUTES.DisplayMode IS "DashBoard">
		<tr>
			<td><strong>FROM</strong></td>
			<td><strong>PAGE</strong></td>
			<td><strong>ACTIONS</strong></td>
		</tr>
		<tr><td colspan="3">
			<div class="RuleSolid1"/>
		</td></tr>
		<cf_AddToQueryString queryString="#FormQueryString#" Name="1" value="1">
		<cfset QueryString=ListAppend(QueryString,ThisPageQueryString,"&")>
		<form name="processRequests" action="<cfoutput>#FormPage#?#QueryString#</cfoutput>" method="post">
		<cfset Counter="1">
		<cfoutput query="GetWF" group="WorkflowRequestID">
			<cfif Counter LTE "5">
				<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
				<tr valign="top">
				<td>
					#FromFirstName# #FromMiddleName# #FromLastName#
					<cfif FromEmailAddress IS NOT "">
						<a href="mailto:#FromEmailAddress#?subject=#WorkflowRequestTypeName#: #CategoryName#&body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>
					</cfif>
				</td>
				<TD><strong>#CategoryName#</strong><br>
				#WorkflowRequestTypeName#<br>
				#REQUEST.OutputDateTime(WorkFlowRequestDateTime)#</td>
				<td nowrap align="left">

				<!--- if this is not a facility manager request --->
				<cfif getWF.categoryId neq 12>
					<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview"><img src="/common/images/admin/icon_magnify.gif" border="0"/></a>
					<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
					<a href="#EditPage#?#QueryString#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"/></A>
					<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
					<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>

				<!--- else, this is a facility manager request - everything should go to the facility manager index --->
				<cfelse>
					<cf_AddToQueryString queryString="#QueryString#" Name="mvcid" value="#CategoryID#">
					<cfswitch expression="#getWF.workflowRequestTypeId#">
						<cfcase value="19001">
							<cf_AddToQueryString queryString="#QueryString#" Name="status" value="review">
						</cfcase>
						<cfcase value="19002">
							<cf_AddToQueryString queryString="#QueryString#" Name="status" value="new">
						</cfcase>
					</cfswitch>
					<a href="#EditPage#?#QueryString#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"/></A>
				</cfif>
				</td>
				</tr>
				<TR>
				<tr><td colspan="3">
					<div class="RuleDotted1"/>
				</td></tr>
				<cfset Counter=Counter+1>
			</cfif>
		</cfoutput>
		<tr>
			<td colspan="3" style="height:25px;"><strong><a href="/common/admin/workflow/requestlist.cfm">See All</A></strong></td>
		</tr>
	<cfelse>
		<tr>
			<td align="center">
				<a href="javascript:void(toggleCheckboxes());"><img src="/common/images/admin/icon_checkbox.gif" border="0"></A>
			</td>
			<td><strong>FROM</strong></td>
			<td><strong>TO</strong></td>
			<td><strong>TYPE/PAGE</strong></td>
			<td><strong>DATE</strong></td>
			<td nowrap><strong>ACTIONS</strong></td>
		</tr>
		</form>
		<tr><td colspan="6">
			<div class="RuleSolid1"/>
		</td></tr>
		<cf_AddToQueryString queryString="#FormQueryString#" Name="1" value="1">
		<cfset QueryString=ListAppend(QueryString,ThisPageQueryString,"&")>
		<form name="processRequests" action="<cfoutput>#FormPage#?#QueryString#</cfoutput>" method="post">
		<cfset Counter="1">
		<cfoutput query="GetWF" group="WorkflowRequestID">
			<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
			<tr valign="top">
				<td align="center">
					<input type="checkbox" name="wfid_mark_#Counter#" value="1" <cfif Val(Dismissed)>checked</cfif>/>
					<input type="hidden" name="wfid_#Counter#" value="#WorkflowRequestID#"/>
				</td>
			<td>
				#FromFirstName# #FromMiddleName# #FromLastName#
				<cfif FromEmailAddress IS NOT "">
					<a href="mailto:#FromEmailAddress#?subject=#WorkflowRequestTypeName#: #CategoryName#&body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>
				</cfif>
			</td>
			<TD>
				<cfoutput group="RecipientUserGroupName">
					<cfif RecipientUserGroupName IS NOT "">#RecipientUserGroupName#<BR></cfif>
				</cfoutput>
				<cfoutput group="RecipientUserID">
					<cfif RecipientLastName IS NOT "">#RecipientFirstName# #RecipientMiddleName# #RecipientLastName#
					<cfif RecipientEmailAddress IS NOT "">
						<a href="mailto:#RecipientEmailAddress#?subject=#WorkflowRequestTypeName#: #CategoryName#&body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>
					</cfif><BR></cfif>
				</cfoutput>
			</TD>
			<TD>#WorkflowRequestTypeName#: <span title="[ #CategoryID# ]">#CategoryName#</span></td>
			<TD nowrap>
				#REQUEST.OutputDateTime(WorkFlowRequestDateTime)#
			</TD>
			<td nowrap align="left">
			<!--- if this is not a facility manager request --->
			<cfif getWF.categoryId neq 12>
				<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0"/></a>&nbsp;
				<cf_AddToQueryString queryString="#QueryString#" Name="ReturnURL" value="#FormPage#?#ThisPageQueryString#">
				<a href="#EditPage#?#QueryString#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"/></A>
				<cf_AddToQueryString queryString="#EditQueryString#" Name="mvcid" value="#CategoryID#">
				<a href="mailto:?body=%0A%0A%0A%0A%0A%0A%0APage: #CategoryName#%0AView: http://#REQUEST.CGIHTTPHost##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#%0AEdit: #URLEncodedFormat('http://#REQUEST.CGIHTTPHost##EditPage#?#QueryString#')#" Title="Email"><img src="/common/images/admin/icon_email.gif" border="0"/></A>
			<!--- else, this is a facility manager request - everything should go to the facility manager index --->
			<cfelse>
				<cf_AddToQueryString queryString="#QueryString#" Name="mvcid" value="#CategoryID#">
				<cfswitch expression="#getWF.workflowRequestTypeId#">
					<cfcase value="19001">
						<cf_AddToQueryString queryString="#QueryString#" Name="status" value="review">
					</cfcase>
					<cfcase value="19002">
						<cf_AddToQueryString queryString="#QueryString#" Name="status" value="new">
					</cfcase>
				</cfswitch>
				<a href="#EditPage#?#QueryString#" title="Edit"><img src="/common/images/admin/icon_edit.gif" border="0"/></a>
			</cfif>
			</td>
			</tr>
			<TR>
			<TD>&nbsp;</TD>
			<TD colspan="5">#REQUEST.AddBreaks(Message)#</TD></TR>
			<tr><td colspan="6">
				<div class="RuleDotted1"/>
			</td></tr>
			<cfset Counter=Counter+1>
		</cfoutput>
		<tr><td colspan="6" align="right">
		<cfif ParamTypeID IS "19001"><!--- Request to publish --->
			<input type="submit" name="Process" value="Publish Checked Items" class="button"/>
		</cfif>
		<input type="hidden" name="action" value="1" /><input type="submit" name="Process" value="Dismiss Checked Items" class="button"/>
		</td></tr>
		<cfoutput><input type="hidden" name="Numwf" value="#Counter-1#"></cfoutput>
	</cfif>
</cfif>
</table>
</form>
