<!--- 
	User dashboard info is stored in session query, only retrieve if session var is undefined
--->
<cfif NOT IsDefined("SESSION.qUserDashboard")>
	<cflock scope="session" type="readonly" timeout="5">
		<cfset thisUserID = SESSION.AdminUserID>
		<cfset thisUsergroupIdList = SESSION.AdminUsergroupIdList>
	</cflock>
	<!--- create struct  --->
	<cfscript>
		sDashboard=StructNew();
		sDashboardModule=StructNew();
		thisKey = 1;
			
		sDashboardModule.ID = 1;
		sDashboardModule.Name = "Bulletins";
		sDashboardModule.Description = "Bulletins module.";
		sDashboardModule.Required = 1;
		sDashboardModule.Position=400;
		sDashboardModule.Priority=10;
		sDashboardModule.UsergroupIdList="all";
		sDashboardModule.Path="/common/modules/admin/Bulletin/bulletin.cfm";
		sDashboard[thisKey]=Duplicate(sDashboardModule);
		thisKey = thisKey + 1;
		
		// position 401 modules
		sDashboardModule.ID = 3;
		sDashboardModule.Name = "Quicky Add Page";
		sDashboardModule.Description = "Quicky add page module.";
		sDashboardModule.Required = 1;
		sDashboardModule.Position=401;
		sDashboardModule.Priority=20;
		sDashboardModule.UsergroupIdList="all";
		sDashboardModule.Path="/common/modules/admin/QuickyAddPage/addPage.cfm";
		sDashboard[thisKey]=Duplicate(sDashboardModule);
		thisKey = thisKey + 1;
		
		// position 402 modules
		sDashboardModule.ID = 2;
		sDashboardModule.Name = "Recent Changes";
		sDashboardModule.Description = "Recent changes module.";
		sDashboardModule.Required = 1;
		sDashboardModule.Position=402;
		sDashboardModule.Priority=10;
		sDashboardModule.UsergroupIdList="#APPLICATION.AdminUserGroupID#,#APPLICATION.ContentEditorUserGroupID#";
		sDashboardModule.Path="/common/modules/admin/RecentChanges/recentChanges.cfm";
		sDashboard[thisKey]=Duplicate(sDashboardModule);
		thisKey = thisKey + 1;
		
	</cfscript>
	<!--- <cfdump var="#sDashboard#"> --->
	
	<cfquery name="getDashboardIDList" datasource="#APPLICATION.DSN#">
	SELECT DashboardModuleIDList FROM t_User WHERE UserID = #thisUserID#
	</cfquery>
	
	<cfset thisDashboardModuleIDList = getDashboardIDList.DashboardModuleIDList>
	
	<cfset qDashboard= QueryNew("DashboardID,Name,Description,Required,ModulePosition,Priority,UsergroupIdList,Path,hasPermission,isActive")>
	
	<cfloop from="1" to="#StructCount(sDashboard)#" index="i">
		<!--- CHECK PERMISSIONS --->
		<cfset hasPermission = 0>
		<cfif sDashboard[i].UsergroupIdList EQ "all">
			<cfset hasPermission = 1>
		<cfelse>
			<Cf_venn
				ListA="#sDashboard[i].UsergroupIdList#"
				ListB="#thisUsergroupIdList#"
				AandB="Intersection">
			<cfif ListLen(Intersection) GTE "1">
				<cfset hasPermission = 1>
			</cfif>
		</cfif>
		
		<cfset isActive = 0>
		<cfif hasPermission AND (ListFind(thisDashboardModuleIDList,sDashboard[i].ID) OR sDashboard[i].Required EQ 1)>
			<cfset isActive = 1>
		</cfif>
		
		<cfscript>
			QueryAddRow(qDashboard);
			QuerySetCell(qDashboard,"DashboardID",sDashboard[i].ID);
			QuerySetCell(qDashboard,"Name",sDashboard[i].Name);
			QuerySetCell(qDashboard,"Description",sDashboard[i].Description);
			QuerySetCell(qDashboard,"Required",sDashboard[i].Required);
			QuerySetCell(qDashboard,"ModulePosition",sDashboard[i].Position);
			QuerySetCell(qDashboard,"Priority",sDashboard[i].Priority);
			QuerySetCell(qDashboard,"UsergroupIdList",sDashboard[i].UsergroupIdList);
			QuerySetCell(qDashboard,"Path",sDashboard[i].Path);
			QuerySetCell(qDashboard,"hasPermission",hasPermission);
			QuerySetCell(qDashboard,"isActive",isActive);
		</cfscript>
	</cfloop>
	
	<!--- <cfdump var="#qDashboard#"> --->
	<cflock scope="session" type="exclusive" timeout="5">
		<cfset SESSION.qUserDashboard = qDashboard>
	</cflock>
<cfelse>
	<!--- <cfdump var="#SESSION.qUserDashboard#"> --->
</cfif>