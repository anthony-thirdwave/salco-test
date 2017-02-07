<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	PageHeader="Recent Changes"
	Page="Recent Changes"
	Indent="1">


<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">Recent Changes</div>
		<div class="ModuleBody2">
		<cfif 1>
			<cfmodule template="/common/modules/admin/RecentChanges/recentChanges.cfm" DisplayMode="Full">
		</cfif>
		</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>

</cfmodule>