<!--- structure keys are 'CategoryTypeID's, 'default' key is required for proper functionality --->
<cfscript>
	sIconsExpanded = StructNew();
	sIconsExpanded["default"] = "/common/images/admin/icon_minus.gif";
	sIconsExpanded["60"] = "/common/images/admin/icon_minus.gif";
	sIconsExpanded["61"] = "/common/images/admin/icon_system_minus.gif";
	sIconsExpanded["65"] = "/common/images/admin/icon_home_minus.gif";
	
	sIconsCollapsed = StructNew();
	sIconsCollapsed["default"] = "/common/images/admin/icon_plus.gif";
	sIconsCollapsed["60"] = "/common/images/admin/icon_plus.gif";
	sIconsCollapsed["61"] = "/common/images/admin/icon_system_plus.gif";
	sIconsCollapsed["65"] = "/common/images/admin/icon_home_plus.gif";
	
	sIconsNoChild = StructNew();
	sIconsNoChild["default"] = "/common/images/admin/icon_document.gif";
	sIconsNoChild["60"] =  "/common/images/admin/icon_document.gif";
	sIconsNoChild["61"] = "/common/images/admin/icon_system.gif";
	sIconsNoChild["65"] = "/common/images/admin/icon_home.gif";
</cfscript>