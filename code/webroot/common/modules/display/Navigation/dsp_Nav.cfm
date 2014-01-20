<cfparam name="ATTRIBUTES.ParentID" default="-1">
<cfparam name="ATTRIBUTES.CSSID" default="">
<cfparam name="ATTRIBUTES.CSSClass" default="">

<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT	MAX(CacheDateTime) AS CacheDateTime
	FROM	t_Category where ParentID=<cfqueryparam value="#Val(ATTRIBUTES.ParentID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+nav_#ATTRIBUTES.ParentID#_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">

<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#")>
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetTopCategories">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ATTRIBUTES.ParentID#" null="NO">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
	</cfstoredproc>
	<cfsaveContent Variable="FileContents">
		<cfif GetTopCategories.RecordCount GT "0">
			<cfset ThisTarget="">
			<cfoutput><ul <cfif ATTRIBUTES.CSSID IS NOT "">id="#ATTRIBUTES.CSSID#"</cfif> <cfif ATTRIBUTES.CSSClass IS NOT "">class="#ATTRIBUTES.CSSClass#"</cfif>></cfoutput>
				<cfoutput query="GetTopCategories" group="CategoryID">
					<cfset ThisTarget="">
                    <cfif Trim(CategoryURLDerived) IS "">
                    	<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#">
					<cfelse>
                    	<cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryURLDerived)#">
						<cfif Left(CategoryURLDerived,4) IS "http">
							<cfset ThisTarget="target=""_blank""">
						</cfif>
                    </cfif>
                	<li><a href="#ThisURL#" #ThisTarget#>#CategoryNameDerived#</a></li>
				</cfoutput>
			</ul>
		</cfif>
	</cfsaveContent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">

