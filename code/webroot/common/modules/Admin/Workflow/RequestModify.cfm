<cfparam name="ATTRIBUTES.PageAction" default="Add">
<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="ATTRIBUTES.FormAction" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#">
<!--- <cfparam name="ReturnURL" default="#REQUEST.CGIPathInfo#?#REQUEST.CGIQueryString#"> --->

<cfparam name="AppliesToSubPages" default="0">
<cfparam name="CCRequest" default="0">
<cfparam name="Recipient" default="">
<cfparam name="ErrorMessage" default="">
<cfif IsDefined("FORM.PageAction")>
	<cfset ATTRIBUTES.PageAction=FORM.PageAction>
</cfif>

<cfset MyWorkflowRequest=CreateObject("component","/com/workflow/request")>
<cfset MyWorkflowRequest.Constructor(-1)>
<cfset MyWorkflowRequest.SetProperty("FromUserID",SESSION.AdminUserID)>
<cfset MyWorkflowRequest.SetProperty("CategoryID",ATTRIBUTES.CategoryID)>
<cfif IsDefined("FORM.WorkflowRequestTypeID")>
	<!--- if the form is submitted, load the form values into the object --->
	<!--- Handling MyWorkflowRequest --->
	<cfset ErrorMessage="">
	<cfparam name="FORM.Recipient" default="">
	<cfif Trim(FORM.Recipient) IS "">
		<cfset ErrorMessage="<li>Please specifiy a recipient for this request.</li>">
	</cfif>
	<cfif Trim(FORM.Message) IS "">
		<cfset ErrorMessage="#ErrorMessage#<li>Please specifiy the message.</li>">
	</cfif>
	<cfif ErrorMessage IS "">
		<!----- spb ----->
		<cfloop index="ThisProperty" list="WorkflowRequestTypeID,Message">
			<cfparam name="FORM.#ThisProperty#" default="">
			<cfset MyWorkflowRequest.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
		</cfloop>
		<cfset ThisLToUserID="">
		<cfset ThisLToUserGroupID="">
		<cfloop index="ThisValue" list="#FORM.Recipient#">
			<cfif ListFirst(ThisValue,"-") IS "G">
				<cfset ThisLToUserGroupID=ListAppend(ThisLToUserGroupID,ListLast(ThisValue,"-"))>
			<Cfelseif ListFirst(ThisValue,"-") IS "U">
				<cfset ThisLToUserID=ListAppend(ThisLToUserID,ListLast(ThisValue,"-"))>
			</cfif>
		</cfloop>
		<cfset MyWorkflowRequest.SetProperty("LToUserID","#ThisLToUserID#")>
		<cfset MyWorkflowRequest.SetProperty("LToUserGroupID","#ThisLToUserGroupID#")>
		<cfset MyWorkflowRequest.Save()>
		<cfset MyWorkflowRequest.Send(AppliesToSubPages,CCRequest)>
	
		<cflocation url="/common/modules/utils/_MessageBox.cfm?StatusMessage=#URLEncodedFormat('Your request has been sent.')#&Location=#URLencodedFormat(ReturnURL)#" addtoken="No">
	</cfif>
</cfif>

<cfset ATTRIBUTES.PageAction=Trim(ATTRIBUTES.PageAction)>

<cfif ListFindNoCase("Add,Edit,ValidateDelete",ATTRIBUTES.PageAction) AND NOT IsDefined("ReturnURL")>
	<cfset ReturnURL=CGI.HTTP_Referer>
</cfif>

<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qRequestType">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="LabelGroupID">
	<cfinvokeargument name="FieldValue" value="19000">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>

<cfinvoke component="/com/user/userhandler" method="GetCategoryOwnerEditorUsers" returnVariable="qGetCategoryOwnerEditorUsers">
	<cfinvokeargument name="CategoryID" value="#ATTRIBUTES.CategoryID#">
</cfinvoke>
<cfinvoke component="/com/user/userhandler" method="GetCategoryOwnerEditorUserGroups" returnVariable="qGetCategoryOwnerEditorUserGroups">
	<cfinvokeargument name="CategoryID" value="#ATTRIBUTES.CategoryID#">
</cfinvoke>

<cfset qEditorOptions=queryNew("OptionID,OptionValue")>
<cfset qOwnerOptions=queryNew("OptionID,OptionValue")>
<cfif qGetCategoryOwnerEditorUserGroups.RecordCount GT "0">
	<cfif qGetCategoryOwnerEditorUsers.RecordCount GT "0">
		<cfset QueryAddRow(qEditorOptions)>
		<cfset QuerySetCell(qEditorOptions,"OptionID","-1")>
		<cfset QuerySetCell(qEditorOptions,"OptionValue","Users:")>
		<cfset QueryAddRow(qOwnerOptions)>
		<cfset QuerySetCell(qOwnerOptions,"OptionID","-1")>
		<cfset QuerySetCell(qOwnerOptions,"OptionValue","Users:")>
		<cfoutput query="qGetCategoryOwnerEditorUsers" group="UserID">
			<cfif pSaveLive>
				<cfset ThisValue="---#FirstName# #MiddleName# #LastName# (Owner)">
			<cfelse>
				<cfset ThisValue="---#FirstName# #MiddleName# #LastName# (Editor)">
			</cfif>
			<cfset QueryAddRow(qEditorOptions)>
			<cfset QuerySetCell(qEditorOptions,"OptionID","U-#UserID#")>
			<cfset QuerySetCell(qEditorOptions,"OptionValue","#ThisValue#")>
			<cfif pSaveLive>
				<cfset QueryAddRow(qOwnerOptions)>
				<cfset QuerySetCell(qOwnerOptions,"OptionID","U-#UserID#")>
				<cfset QuerySetCell(qOwnerOptions,"OptionValue","#ThisValue#")>
			</cfif>
		</cfoutput>
	</cfif>
	<cfset QueryAddRow(qEditorOptions)>
	<cfset QuerySetCell(qEditorOptions,"OptionID","-1")>
	<cfset QuerySetCell(qEditorOptions,"OptionValue","User Groups:")>
	<cfset QueryAddRow(qOwnerOptions)>
	<cfset QuerySetCell(qOwnerOptions,"OptionID","-1")>
	<cfset QuerySetCell(qOwnerOptions,"OptionValue","User Groups:")>
	<cfoutput query="qGetCategoryOwnerEditorUserGroups" group="UserGroupID">
		<cfif pSaveLive>
			<cfset ThisValue="---#UserGroupName# (Owner)">
		<cfelse>
			<cfset ThisValue="---#UserGroupName# (Editor)">
		</cfif>
		<cfset QueryAddRow(qEditorOptions)>
		<cfset QuerySetCell(qEditorOptions,"OptionID","G-#UserGroupID#")>
		<cfset QuerySetCell(qEditorOptions,"OptionValue","#ThisValue#")>
		<cfif pSaveLive>
			<cfset QueryAddRow(qOwnerOptions)>
			<cfset QuerySetCell(qOwnerOptions,"OptionID","G-#UserGroupID#")>
			<cfset QuerySetCell(qOwnerOptions,"OptionValue","#ThisValue#")>
		</cfif>
	</cfoutput>
</cfif>

<cfset FormMode="ShowForm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<cfoutput>
	<cfset Location=GetToken(ATTRIBUTES.FormAction,1,"?")>
	<cfset querystring=GetToken(ATTRIBUTES.FormAction,2,"?")>
	<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" Omitlist="PageAction">
	<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data" name="WorkflowRequestForm">
	<input type="hidden" name="PageAction" value="Validate">
</cfoutput>
<TR><TD colspan="2">

<script language = "JavaScript">
<!--
	// Create the array
	RTArray19000 = new Array();// message
	RTArray19001 = new Array();// publish
	RTArray19002 = new Array();// edit
	<cfset i = 0>
	<cfoutput query="qEditorOptions">
		RTArray19000[#i#] = "#OptionID#+#OptionValue#";
		RTArray19002[#i#] = "#OptionID#+#OptionValue#";
		<cfset i = i + 1>
	</cfoutput>
	<cfset i = 0>
	<cfoutput query="qOwnerOptions">
		RTArray19001[#i#] = "#OptionID#+#OptionValue#";
		<cfset i = i + 1>
	</cfoutput>


// Function to populate the area codes for the state selected
function PopulateSelect() {
   // Only process the function if the first item is not selected.
   if (1) {
      // Find the state abbreviation
      var ThisState = document.WorkflowRequestForm.WorkflowRequestTypeID[document.WorkflowRequestForm.WorkflowRequestTypeID.selectedIndex].value;
      // Set the length of the arecode drop down equal to the length of the state's array
      document.WorkflowRequestForm.Recipient.length = eval("RTArray" + ThisState + ".length");
      // Loop through the state's array and populate the area code drop down.
      for (i=0; i<eval("RTArray" + ThisState + ".length"); i++) {
	  	 var ThisValue=eval("RTArray" + ThisState + "[i]");
		 ThisValue=ThisValue.split("+");
         document.WorkflowRequestForm.Recipient[i].value = ThisValue[0];
         document.WorkflowRequestForm.Recipient[i].text = ThisValue[1];
      }
   }
}
//-->
</script>
<cfparam name="WorkflowRequestTypeID" default="19001">
<cfinvoke component="/com/ContentManager/CategoryHandler" method="GetCategoryBasicDetails" returnVariable="qCategory" CategoryID="#ATTRIBUTES.CategoryID#">

<p>Page: <cfoutput><strong>#qCategory.CategoryName#</strong></cfoutput></p>
<div class="RuleSolid1"></div>

<cfif ErrorMessage IS NOT "">
	<ul style="color:red">
		<cfoutput>#ErrorMessage#</cfoutput>
	</ul>
</cfif>

<p>* Required fields</p>
<p>Type: <br>
<select name="WorkflowRequestTypeID" onChange="PopulateSelect()">
	<cfoutput query="qRequestType">
		<option value="#LabelID#" <cfif WorkflowRequestTypeID eq #labelId#>selected</cfif>>#LabelName#</option>
	</cfoutput>
</select></p>

<div class="RuleDotted1"></div>

<p>To: *<br>
<select name="Recipient" size="10" multiple>
	<cfoutput query="qEditorOptions">
		<option value="#OptionID#" <cfif IsDefined("FORM.Recipient") and ListFind(FORM.Recipient,OptionID)>selected</cfif>>#OptionValue#</option>
	</cfoutput>
</select>
</p>

<div class="RuleDotted1"></div>

<p>Message: *<BR>
<textarea cols="50" rows="10" name="Message"><cfoutput>#Trim(MyWorkflowRequest.GetProperty("Message"))#</cfoutput></textarea><br>
<!--- <input type="checkbox" name="AppliesToSubPages" value="1">This message applies to all sub pages.<br> --->
<input type="checkbox" name="CCRequest" value="1"<cfif ATTRIBUTES.PageAction IS "Add"> checked</cfif>>CC yourself this request.<br>
</p>



<div align="right">
	<cfoutput><input type="button" name="Cancel" value="Cancel" class="button" onclick="window.location='#ReturnURL#'"/></cfoutput>
	<input type="submit" name="ButSubmit" value="Submit" class="button">
</div>
</TD></form></TR></table>

