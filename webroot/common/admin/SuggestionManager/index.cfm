<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Suggestion Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Suggestion Manager">

<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">

<cfif isDefined("URL.cfgridkey")>
	Suggestion Detail
<cfelse>
	Suggestions Submitted
</cfif></div>
		<div class="ModuleBody2">

<cfif isDefined("URL.cfgridkey")>
	<cfmodule template="/common/modules/suggestionBox/suggestionDetail.cfm" suggestionID="#Val(URL.cfgridkey)#">
<cfelse>
	<cfmodule template="/common/modules/suggestionBox/suggestionGrid.cfm" mode="Admin">
</cfif>

</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>
<p>&nbsp;</p>

</cfmodule>