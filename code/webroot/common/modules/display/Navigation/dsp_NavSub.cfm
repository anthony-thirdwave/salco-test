<cfif ListLen(CategoryThreadList) GTE "3">
	<cfset ThisCategoryID=ListGetAt(CategoryThreadList,3)>
	<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
		SELECT     MAX(CacheDateTime) AS CacheDateTime
		FROM         t_Category where DisplayLevel=2 and ParentID=#Val(ThisCategoryID)#
	</cfquery>
	
	<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+SubNav_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">
	
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetTopCategories">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ThisCategoryID#" null="NO">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="2" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
		</cfstoredproc>
		<cfsaveContent Variable="FileContents">
			<cfif GetTopCategories.RecordCount GT "0">
				<div id="subnavigation"><!-- Start of Sub Navigation Elements -->
                    <ul>
                    <cfoutput query="GetTopCategories" group="CategoryID">
                        <cfif Trim(CategoryURLDerived) IS "">
                            <cfset ThisURL="#APPLICATION.contentPageInUrl#/#CategoryAlias#">
                        <cfelse>
                            <cfset ThisURL="#CategoryURLDerived#">
                        </cfif>
                        <li><a href="#REQUEST.GlobalNavURLPrefix##ThisURL#">#CategoryNameDerived#</a></li>
                    </cfoutput>
                    </ul>
				</div><!-- End of Sub Navigation Elements -->
			</cfif>
		</cfsaveContent>
		<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>	

