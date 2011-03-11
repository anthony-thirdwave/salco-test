<cfparam name="ATTRIBUTES.CategoryID" default="1">

<cfif 0>
	<cfoutput>
		<p>CategoryIDToStart: #CategoryIDToStart#-#ThisDisplayLevel#<br>
		#ATTRIBUTES.CategoryThreadList#</p>
	</cfoutput>
</cfif>
<cfsavecontent variable="SiteNavigation">
<cfmodule template="/common/modules/display/navigation/dsp_NavRHelper.cfm"
	CategoryID="#ATTRIBUTES.CategoryID#"
	Level="0">
</cfsavecontent>
<cfoutput>#SiteNavigation#</cfoutput>