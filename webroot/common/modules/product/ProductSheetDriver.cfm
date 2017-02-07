<cfsetting requesttimeout="20000">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfset DontFlush="1">
<cfquery name="getTheselocales" datasource="#APPLICATION.DSN#">
	select * from t_locale order by localeID desc
</cfquery>
<cfloop query="getTheselocales">
	<cfset LocaleIDValue="#getTheselocales.LocaleID#">
	<cfset SiteID="524">
	<cfset ShowAll="Yes">
	<CFSET ExecuteTempFile="#GetTheseLocales.LocaleID#/ProductSheet_#getTheselocales.LocaleID#_#SiteID#_#DateFormat(now(),'yyyymmdd')#_#TimeFormat(now(),'HHmm')#.html">
	<cfsavecontent variable="ThisProductSheet">
		<cfinclude template="ProductSheet.cfm">
	</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir#ProductSheet/#ExecuteTempFile#" output="#ThisProductSheet#" addnewline="Yes">
	<cfoutput><p>Done #ExecuteTempFile#</p></cfoutput>
	<cfflush>
	
	<cfset LocaleIDValue="#getTheselocales.LocaleID#">
	<cfset SiteID="451">
	<cfset ShowAll="Yes">
	<CFSET ExecuteTempFile="#GetTheseLocales.LocaleID#/ProductSheet_#getTheselocales.LocaleID#_#SiteID#_#DateFormat(now(),'yyyymmdd')#_#TimeFormat(now(),'HHmm')#.html">
	<cfsavecontent variable="ThisProductSheet">
		<cfinclude template="ProductSheet.cfm">
	</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir#ProductSheet/#ExecuteTempFile#" output="#ThisProductSheet#" addnewline="Yes">
	<cfoutput><p>Done #ExecuteTempFile#</p></cfoutput>
	<cfflush>
</cfloop>

</body>
</html>
