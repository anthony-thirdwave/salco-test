<cfsetting requesttimeout="25000">
<cfparam name="SiteID" default="524">
<cfparam name="ShowAll" default="No">
<cfparam name="DontFlush" default="0">
<cfquery name="getlocales" datasource="#ThisDSN#">
	select *, case when localeid=1 then '_' else localename end as localenamesort from t_locale order by localenamesort
</cfquery>
<cfset sLanguageID=StructNew()>
<cfoutput query="GetLocales">
	<cfset StructInsert(sLanguageID,LocaleID,LanguageID)>
</cfoutput>


<cfset ThisDSN="lifefitness_production">
<cfset Request.Recache="0">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/common/styles/admin.css" title="docProperties">
	<title>Product Sheet</title>
	<script language="JavaScript" type="text/JavaScript" src="/common/scripts/common.js"></script>
<script language=javascript src="/common/scripts/mm4.js"></script>
</head>
<body>

<!--- <form action="ProductSheet.cfm" method="post">
<table width="100%" cellspacing="3" cellpadding="3"><TR><TD>
Site: <select name="SiteID">
	<option value="2215" <cfif SiteID IS 524>selected</cfif>>Commercial</option>
	<option value="2214" <cfif SiteID IS 451>selected</cfif>>Home</option>
</select>




</TD></TR></table>
</form> --->

<p><cfoutput>Datasource: #ThisDSN#</cfoutput></p>

<cfif SiteID IS "2215">
	<cfset REQUEST.Site="Commercial">
<cfelse>
	<cfset REQUEST.Site="Home">
</cfif>
<cfquery name="GetTopDOS" datasource="#ThisDSN#">
	select DIsplayOrder from t_Category where CategoryID = #Val(SiteID)#
</cfquery>
<cfquery name="GetCats" datasource="#ThisDSN#">
	select * FRom t_Category
	where
	DisplayOrder like '#GetTopDOS.DisplayOrder#%' <!--- and CategoryID IN (1893,1892) ---> and
	CategoryTypeID IN
	(162) and categoryactive=1
	order by DisplayORder
</cfquery>
<table border="1">
	<TR><TD>Page</TD>
	<cfoutput query="GetLocales">
		<TD>#LocaleName#</TD>
	</cfoutput>
	</TR>
<cfoutput query="GetCats">
	<tr valign="top"><td nowrap><cfloop index="i" from="4" to="#DisplayLevel#" step="1">&nbsp;&nbsp;&nbsp;</cfloop> #CategoryName# (#categoryID#)<cfif CategoryActive IS "0">(inactive)</cfif></td>
	<cfset ThisCategoryID=GetCats.CategoryID>
	<cfloop query="GetLocales">
		<cfstoredproc procedure="sp_GetPage" datasource="#ThisDSN#">
			<cfprocresult name="GetPage" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#ThisCategoryID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#GetLocales.LocaleID#" null="No">
		</cfstoredproc>
		<td align="center" nowrap <cfif GetPage.CategoryActiveDerived>style="border:1px green solid"<cfelse>Style="border:1px red solid"</cfif>>
		<!--- #Evaluate("GetPage_#ThisCategoryID#.CategoryActiveDerived")# GetPage_#ThisCategoryID#.CategoryActiveDerived --->
		<cfif GetPage.CategoryActiveDerived>
			<strong>YES</strong>
		<cfelse>
			NO
		</cfif>
		<cfif Val(GetPage.CategoryActiveDerived) AND GetPage.LocaleID IS NOT GetLocales.LocaleID><BR>using default</cfif>
		<cfif GetPage.LocaleID IS GetLocales.LocaleID><BR>localized<cfelse></cfif>
		</td>
	</cfloop>
	</TR>
</cfoutput>
</table>

</body>
</html>
