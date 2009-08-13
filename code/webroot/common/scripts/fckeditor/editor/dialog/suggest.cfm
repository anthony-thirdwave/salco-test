<!--- Set MaxResults to the maximun number of results you want to suggest --->
<cfset MaxResults = 7>
<cfif URL.t EQ "int">
	<cfquery datasource="#APPLICATION.DSN#" name="words">
		SELECT TOP #MaxResults# CategoryAlias
		FROM		t_Category 
		WHERE		CategoryAlias LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.l#%">
		ORDER BY	CategoryAlias
	</cfquery>
<cfoutput query="words">#replace(replace(lcase(CategoryAlias), chr(10), ""), chr(13), "")#,</cfoutput>%%%
<cfelseif URL.t EQ "res">
	<cfquery name="words" datasource="#APPLICATION.DSN#">
		SELECT TOP #MaxResults# CategoryName, CategoryID
		FROM		t_Category
		WHERE		CategoryTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="72">
		AND			CategoryName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.l#%">
		ORDER BY	CategoryName
	</cfquery>
	<cfset afid=ArrayNew(1)>
	<cfoutput query="words">
		<cfset ArrayAppend(aFid,application.utilsObj.SimpleEncrypt(CategoryID))>
	</cfoutput>
	<cfset QueryAddColumn(words,"fid",afid)>
<cfoutput query="words">#replace(replace(Replace(CategoryName,",","|","All"), chr(10), ""), chr(13), "")#;#fid#,</cfoutput>%%%
</cfif>
