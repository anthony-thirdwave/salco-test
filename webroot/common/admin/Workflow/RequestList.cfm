<cfparam name="cid" default="-1">
<cfset CategoryIDValue=REQUEST.SimpleDecrypt(cid)>

<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	secure="1"
	PageHeader="Request List"
	Page="Requests">

<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">LIST</div>
		<div class="ModuleBody2">
<cfif 1>
	<cfmodule template="/common/modules/admin/workflow/RequestList.cfm">
</cfif> 
</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>

</cfmodule>