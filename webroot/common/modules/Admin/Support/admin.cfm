<!--- feedbacksubmission module --->
<cfparam name="ATTRIBUTES.ObjectAction" default="">
<cfparam name="ATTRIBUTES.NextPage" default="">
<cfparam name="ATTRIBUTES.EmailAddressValidationMessage" default="Please enter a valid email address">

<cfset sErrorMessage=StructNew()>

<cfset StructInsert(sErrorMessage,100,"Please enter your name.")>
<cfset StructInsert(sErrorMessage,200,"Please enter a valid email address.")>
<cfset StructInsert(sErrorMessage,300,"Please enter your phone number.")>
<cfset StructInsert(sErrorMessage,400,"Please select a type of issue.")>
<cfset StructInsert(sErrorMessage,500,"Please enter your issue.")>

<cfswitch expression="#ATTRIBUTES.ObjectAction#">
	<cfcase value="Page1">
		<cfset Issue=ArrayNew(1)>
		<cfset Status=ArrayNew(1)>
		<cfset OS=ArrayNew(1)>
			
		<cfquery datasource="#APPLICATION.DSN#" name="statuses">
			SELECT LabelID, LabelName FROM t_Label WHERE LabelGroupID = 7000
		</cfquery>
		
		<cfoutput query="statuses">
			<cfset Status[LabelID] = LabelName>
		</cfoutput>
			
		<cfquery datasource="#APPLICATION.DSN#" name="issues">
			SELECT LabelID, LabelName FROM t_Label WHERE LabelGroupID = 5000
		</cfquery>
		
		<cfoutput query="issues">
			<cfset Issue[LabelID] = LabelName>
		</cfoutput>

		<cfquery datasource="#APPLICATION.DSN#" name="OSs">
			SELECT LabelID, LabelName FROM t_Label WHERE LabelGroupID = 6000
		</cfquery>
		
		<cfoutput query="OSs">
			<cfset OS[LabelID] = LabelName>
		</cfoutput>
		
		<cfquery datasource="#APPLICATION.DSN#" name="tickets">
			SELECT TOP 10 * FROM t_SupportRequest ORDER BY DateRequested DESC
		</cfquery>
		
		<table border="0" width="100%">
		<cfoutput query="tickets">
			<tr>
				<td width="120">Name: #requestorName#</td>
				<td>Email: #requestorEmail#</td>
				<td>Phone:#requestorPhone#</td>
			</tr>
			<tr height="10">
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td width="120">Platform: #OS[requestorPlatformID]#</td>
				<td>Browser: #requestorBrowser#</td>
				<td>Type: #Issue[supportIssueID]#</td>
			</tr>
			<tr height="10">
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td width="120">
					<form method="post" action="#ATTRIBUTES.NextPage#">
					<input type="hidden" name="hiddenID" value="#supportRequestID#" />
					<select name="selStatus" onChange="this.form.submit();">
						<option value="#supportRequestStatus#">#Status[supportRequestStatus]#</option>
						<cfloop index="count" from="7000" to="#ArrayLen(Status)#">
							<option value="#count#">#Status[count]#</option>
						</cfloop>
					</select>
					</form>
				</td>
				
				<td colspan="2">#supportIssue#</td>
			</tr>
			<tr>
				<td colspan="5"><hr width="100%" /></td>
			</tr>
		</cfoutput>
		</table>
	</cfcase>
	<cfcase value="ChangeStatus">
		<cfquery datasource="#APPLICATION.DSN#" name="updateStatus">
			UPDATE t_SupportRequest SET supportRequestStatus = 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.selStatus#">
			WHERE
				SupportRequestID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.hiddenID#">
		</cfquery>
		
		<cflocation url="#ATTRIBUTES.NextPage#">
	</cfcase>
	<cfdefaultcase>
	</cfdefaultcase>
</cfswitch>
