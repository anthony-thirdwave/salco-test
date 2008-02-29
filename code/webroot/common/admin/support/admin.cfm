<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	secure="No" 
	PageHeader="Support"
	Page="Support"
	IncludeTopMenu="no"
	Indent="1">
<cfparam name="supportaction" default="1">
<cfset ThisPath=REQUEST.CGIPathInfo>
<cfset ThisQueryString=REQUEST.CGIQueryString>
<h1>Support Admin</h1>
<cfif supportaction IS "1">
	<p><strong>View Requests and Change Staus</strong></p>
	
	<cf_AddToQueryString querystring="#ThisQueryString#" name="supportaction" value="2">
	<Cfmodule template="/common/modules/Admin/support/admin.cfm"
		ObjectAction="Page1"
		NextPage="#ThisPath#?#QueryString#">
<cfelse>
	<!--- Change Status --->
	<cf_AddToQueryString querystring="#ThisQueryString#" name="supportaction" value="1">
	<Cfmodule template="/common/modules/Admin/support/admin.cfm"
		ObjectAction="ChangeStatus"
		NextPage="#ThisPath#?#QueryString#"
		PrevPage="#ThisPath#">
</cfif>


</cfmodule>