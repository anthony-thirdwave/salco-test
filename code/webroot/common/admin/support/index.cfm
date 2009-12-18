<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	secure="No" 
	PageHeader="Support"
	Page="Support"
	Indent="1">
<cfparam name="supportaction" default="1">
<cfset ThisPath=CGI.SCRIPT_NAME>
<cfset ThisQueryString=CGI.QUERY_STRING>

<cfif supportaction IS "1">
	<!---<p><strong>Documentation</strong></p>
	
	<UL>
	<LI><a href="/common/admin/documentation/CMS_Instructions.pdf" target="_blank">CMS Overview</a></li>
	</UL> --->

	<!--- Display Form and submit to self --->
	<p><strong>Submit a support request</strong></p>
	<p>Let us know what the problem is,
				and we'll let you know the answer!<br />
				Please allow 24-48 hours for a response.</p>
	<cf_AddToQueryString querystring="#ThisQueryString#" name="supportaction" value="2">
	<Cfmodule template="/common/modules/Admin/support/supportrequest.cfm"
		ObjectAction="Page1"
		NextPage="#ThisPath#?#QueryString#">
<cfelseif supportaction IS "2">
	<!--- Validate & Email --->
	<cf_AddToQueryString querystring="#ThisQueryString#" name="supportaction" value="3">
	<Cfmodule template="/common/modules/Admin/support/supportrequest.cfm"
		ObjectAction="Page1ValidateAndSave"
		NextPage="#ThisPath#?#QueryString#"
		PrevPage="#ThisPath#">
<cfelse>
	<p><strong>Someone will look into your issue soon!</strong></p>
	<p>&nbsp;</p>
</cfif>


</cfmodule>