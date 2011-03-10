<!--- 
		Generic Display Template
		This template can be modified at will except for the ColdFusion syntax which is enclosed in the tags beginning with "<cf"

 --->
<!--- turn off debugging local --->
<html>
<head>
<cfoutput>
	<!--- These tags are managed by the CMS. --->
	<cfif Trim(PageTitleOverride) EQ "">
		<cfset pageTitleList = ListRest(CategoryThreadName)>
		<cfset thisPageTitle = APPLICATION.utilsObj.generatePageTitleString(pageTitleList)>
	<cfelse>
		<cfset thisPageTitle = PageTitleOverride>
	</cfif>
	<meta name="keywords" content="#MetaKeywords#" />
	<meta name="description" content="#Metadescription#" />
	<title>#thisPageTitle#</title>
</cfoutput>
<link rel="stylesheet" type="text/css" href="/common/styles/default.css" media="screen" title="docProperties">


<script type="text/javascript" src="/common/scripts/common.js"></script>

</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin=0 topmargin=0 marginwidth="0" marginheight="0">
<table border="1"><tr valign="top">
<td width="168">
<cfinclude template="/common/modules/Display/Navigation/dsp_NavGeneric.cfm">
</td>
<td width="388">
<cfif StructKeyExists(sIncludeFile,"400") AND sIncludeFile["400"] IS NOT "">
	<cfinclude template="#sIncludeFile['400']#">
</cfif>
&nbsp;
</td>
<td width="388">
<cfif StructKeyExists(sIncludeFile,"401") AND sIncludeFile["401"] IS NOT "">
	<cfinclude template="#sIncludeFile['401']#">
</cfif>
&nbsp;
<!---
<cfif StructKeyExists(sIncludeFile,"402") AND sIncludeFile["402"] IS NOT "">
	<cfinclude template="#sIncludeFile['402']#">
</cfif>
--->
</td></tr></table>
</body>
</html>