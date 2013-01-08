<cfset ThisCategoryID=6061>
<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
	SELECT     MAX(CacheDateTime) AS CacheDateTime
	FROM         t_Category where ParentID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+GlobalNav_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">

<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
	<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetTopCategories">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ThisCategoryID#" null="NO">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
		<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
	</cfstoredproc>
	
	<cfsaveContent Variable="FileContents">
		<cfif GetTopCategories.RecordCount GT "0">
			<ul class="menuCSS" id="nav-main">
                   <cfoutput query="GetTopCategories" group="CategoryID">
					<cfif ListFind(REQUEST.CategoryThreadList,CategoryID)>
						<cfset ThisClass="activeMinus">
					<cfelse>
						<cfset ThisClass="">
					</cfif>
                       <cfif Trim(CategoryURLDerived) IS "">
                           <cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#">
                       <cfelse>
                           <cfset ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(CategoryURLDerived)#">
                       </cfif>
                       <li <cfif len(ThisClass)>class="#ThisClass#"</cfif>><a href="#ThisURL#" class="#CategoryAlias#">#CategoryNameDerived#</a>
					<cfif len(ThisClass)>
						<cfmodule template="/common/modules/display/Navigation/intranet/dsp_NavSubPages.cfm" CategoryID="#CategoryID#">
					</cfif>
				   </li>
                   </cfoutput>
			</ul>
		</cfif>
	</cfsaveContent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">

<!--- 




<ul class="menuCSS" id="nav-main">
  <li><a href="index.html">Home</a></li>
  
  <li><a href="news.html">News</a></li>
  
  <li><a href="#goals">Goals &amp; Progress</a></li>
  
  <li class="activeMinus"><a href="employees.html">Employees</a>
  		<ul>
		<!--<li><a href="#">marketing</a></li>
		<li><a href="#">sales</a></li>
		<li><a href="#">engineering</a></li>
		<li><a href="#">shop</a></li>
		<li class="active"><a href="#">finance</a></li>
		<li><a href="#">human resources</a></li>
		<li><a href="#">management</a></li>-->
		<li><a href="#">Sales &amp; Marketing</a></li>
		<li class="active"><a href="#">Customer Service IL</a></li>
		<li><a href="#">Customer Service TX</a></li>
		<li><a href="#">Special Products &amp; Opportunity Management</a></li>
		<li><a href="#">New Products</a></li>
		<li><a href="#">Engineering</a></li>
		<li><a href="#">Operations IL</a></li>
		<li><a href="#">Operations TX</a></li>
		<li><a href="#">Quality</a></li>
		<li><a href="#">Accounting</a></li>
		<li><a href="#">Executives</a></li>
		<li><a href="#">Executive Administration</a></li>
		<li><a href="#">Information Technology</a></li>
		<li><a href="#">Purchasing</a></li>
		<li><a href="#">Facility Management</a></li>
		<li><a href="#">Field Service</a></li>
	</ul>
  
</ul> --->