
<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="User Details"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | <a href=""index.cfm"">User Manager</A> | User Details">
	
<cfparam name="ATTRIBUTES.DonePage" default="/common/admin/UserManager/index.cfm">
<cfparam name="ATTRIBUTES.EditUserID" default="-1">
<cfif IsDefined("URL.uid")>
	<cftry>
		<cfset ATTRIBUTES.EditUserID=Decrypt(URL.uid, APPLICATION.Key)>
		<cfcatch></cfcatch>
	</cftry>
</cfif>
<cfparam name="ATTRIBUTES.PageAction" default="#CGI.SCRIPT_NAME#?#CGI.Query_String#">
<cfset PageActionTemplate=GetToken(ATTRIBUTES.PageAction,1,"?")>
<cfset PageActionQueryString=GetToken(ATTRIBUTES.PageAction,2,"?")>

<cfparam name="uoa" default="3">
<cfparam name="upa" default="1">
<cfif upa IS "1">
	<cfif IsDefined("URL.ReturnURL")>
	<cfelse>
		<cfset ReturnURL=CGI.HTTP_REFERER>
	</cfif>
</cfif>

<cfswitch expression="#Trim(uoa)#">
	<cfcase value="1"><!--- View Object --->
		<cfmodule template="/common/modules/User/UserObject.cfm"
			ObjectAction="view" EditUserID="#ATTRIBUTES.EditUserID#">
	</cfcase>
	<cfcase value="2"><!--- Edit Object--->
		<cfswitch expression="#Trim(upa)#">
			<cfcase value="1"><!--- Show Form --->
				<table bgcolor="silver"><tr valign="top">
				<TD bgcolor="white">
				<cf_AddToQueryString querystring="#PageActionQueryString#" name="uoa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="upa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
				<cfmodule template="/common/modules/User/UserObject.cfm"
					PageAction="Edit" EditUserID="#ATTRIBUTES.EditUserID#"
					ObjectAction="ShowForm"
					FormAction="#PageActionTemplate#?#querystring#">
				</TD></TR></table>
			</cfcase>
			<cfcase value="2"><!--- Validate Form / Confirm --->
				<table bgcolor="silver"><tr valign="top">
				<TD bgcolor="white">
				<cf_AddToQueryString querystring="#PageActionQueryString#" name="uoa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="upa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
				<cfmodule template="/common/modules/User/UserObject.cfm"
					PageAction="Edit" EditUserID="#ATTRIBUTES.EditUserID#"
					ObjectAction="Validate"
					FormAction="#PageActionTemplate#?#querystring#">
				</TD></TR></table>
				<cfif Trim(ErrorFieldList) IS "">
					<cfmodule template="/common/modules/User/UserObject.cfm"
						PageAction="Edit" EditUserID="#ATTRIBUTES.EditUserID#"
						ObjectAction="CommitEdit">
					<cfif ReturnURL IS "">
						<cflocation url="#ATTRIBUTES.DonePage#" addtoken="No">
					<cfelse>
						<cflocation url="#ReturnURL#" addtoken="No">
					</cfif>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfcase>
	<cfcase value="3"><!--- Add Object --->
		<cfswitch expression="#Trim(upa)#">
			<cfcase value="1"><!--- ShowForm --->
				<table bgcolor="silver"><tr valign="top">
				<TD bgcolor="white">
				<cf_AddToQueryString querystring="#PageActionQueryString#" name="uoa" value="3">
				<cf_AddToQueryString querystring="#QueryString#" name="upa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
				<cfmodule template="/common/modules/User/UserObject.cfm"
					PageAction="Add" 
					ObjectAction="ShowForm"
					FormAction="#PageActionTemplate#?#querystring#">
				</TD></TR></table>
			</cfcase>
			<cfcase value="2"><!--- Validate Form / Confirm --->
				<table bgcolor="silver"><tr valign="top">
				<TD bgcolor="white">
				<cf_AddToQueryString querystring="#PageActionQueryString#" name="uoa" value="3">
				<cf_AddToQueryString querystring="#QueryString#" name="upa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
				<cfmodule template="/common/modules/User/UserObject.cfm"
					PageAction="Add"
					ObjectAction="Validate"
					FormAction="#PageActionTemplate#?#querystring#">
				</TD></tr></table>
				<cfif Trim(ErrorFieldList) IS "">
					<cfmodule template="/common/modules/User/UserObject.cfm"
						PageAction="Add" 
						ObjectAction="CommitAdd">
					<cfif ReturnURL IS "">
						<cflocation url="#ATTRIBUTES.DonePage#" addtoken="No">
					<cfelse>
						<cflocation url="#ReturnURL#" addtoken="No">
					</cfif>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfcase>
	<cfcase value="4"><!--- Delete Object --->
		<cfswitch expression="#Trim(upa)#">
			<cfcase value="1"><!--- Confirm Delete --->
				<table bgcolor="silver"><tr valign="top">
				<TD bgcolor="white">
				<cf_AddToQueryString querystring="#PageActionQueryString#" name="uoa" value="4">
				<cf_AddToQueryString querystring="#QueryString#" name="upa" value="2">
				<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
				<cfmodule template="/common/modules/User/UserObject.cfm"
					PageAction="Delete" EditUserID="#ATTRIBUTES.EditUserID#"
					ObjectAction="ValidateDelete"
					FormAction="#PageActionTemplate#?#querystring#">
				</TD></TR></table>
			</cfcase>
			<cfcase value="2"><!--- Commit Delete --->
				<cfmodule template="/common/modules/User/UserObject.cfm"
					PageAction="Delete" EditUserID="#ATTRIBUTES.EditUserID#"
					ObjectAction="CommitDelete">
				<cfif 1>
					<cflocation url="#ATTRIBUTES.DonePage#" addtoken="No">
				<cfelse>
					<cflocation url="#ReturnURL#" addtoken="No">
				</cfif>
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>


</cfmodule>