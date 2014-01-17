<cfsilent>

<cfsetting showdebugoutput="no">
<cfparam name="URL.l" default=""> <!--- l = letter --->
<cfparam name="URL.e" default=""> <!--- e = exclude list --->
<cfparam name="URL.f" default=""> <!--- f = display order filter --->
<!--- Set MaxResults to the maximun number of results you want to suggest --->
<cfset MaxResults=7>
<cfquery name="words" datasource="#APPLICATION.DSN#">
	SELECT DISTINCT TOP	#MaxResults# C.CategoryName ,C.CategoryID, C.CategoryAlias
	FROM t_Category C
	WHERE
	(CategoryName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URL.l#%"> OR
	 CategoryAlias LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URL.l#%">
	)
	AND CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="64">
	<cfif URL.e NEQ "">AND C.CategoryID NOT IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#URL.e#">)</cfif>
	<cfif URL.f NEQ "">AND C.DisplayOrder LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.f#%">)</cfif>
	ORDER BY	C.CategoryName
</cfquery>
</cfsilent>
<cfoutput query="words">#APPLICATION.utilsObj.RemoveBreaks(CategoryName)# (#CategoryAlias#)~|~#JSStringFormat(APPLICATION.utilsObj.RemoveBreaks(CategoryName))#~|~#CategoryID#~||~</cfoutput>%%%