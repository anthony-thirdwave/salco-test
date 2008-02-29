<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<cfif IsDefined("REQUEST.OverrideBaseHREF")>
	<cfoutput><base href="#REQUEST.OverrideBaseHREF#"></cfoutput>
</cfif>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfparam name="URL.pff" default="0">
<cfif Val(URL.pff)>
	<cfsetting showdebugoutput="no">
	<link rel="stylesheet" type="text/css" media="screen, projection" href="/common/styles/print.css" />
	<link rel="stylesheet" type="text/css" media="print" href="/common/styles/print.css" />
<cfelse>
	<link rel="stylesheet" type="text/css" media="screen, projection" href="/common/styles/screen.css" />
	<link rel="stylesheet" type="text/css" media="print" href="/common/styles/print.css" />
</cfif>
<cfoutput>
	<!--- These tags are managed by the CMS. --->
	<cfif Trim(PageTitleOverride) EQ "">
		<cfset pageTitleList = ListRest(CategoryThreadName)>
		<cfset thisPageTitle = REQUEST.GeneratePageTitleString(pageTitleList)>
	<cfelse>
		<cfset thisPageTitle = PageTitleOverride>
	</cfif>
	<meta name="keywords" content="#MetaKeywords#" />
	<meta name="description" content="#Metadescription#" />
	<meta name="generator" content="3WCMS" />
	<meta name="dc.title" content="#HTMLEditFormat(CurrentCategoryName)#" />

	<!--- include meta --->
	<cfif IsDefined("PageType")>
		<meta name="dc.type" content="#PageType#" />
	</cfif>
	<title>#thisPageTitle#</title>
	<script type="text/javascript" src="/common/scripts/sifr.js"></script>
	<script type="text/javascript" src="/common/scripts/common.js"></script>
</cfoutput>
</head>
<body<cfif Val(URL.pff)> onload="window.print();"</cfif>><a name="top"></a>

<div id="wrap">

<cfoutput><div id="logo"><a href="/"><img src="/common/images/template/header_logo.gif" border="0" alt="#APPLICATION.CompanyName#" /></a></div></cfoutput>
<!-- Header and Navigation -->
<cfinclude template="/common/modules/Display/Navigation/dsp_NavGlobal.cfm">
<!-- Start of Content Area-->
<div id="content">
	<!-- Left/Main Column -->
	<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
</div>
<!-- End of Left Column	-->
<hr />

<div id="sidebar">
	<cfif CurrentCategoryAlias IS "Home">
	<h5 id="about"><cfoutput>#APPLICATION.CompanyName#</cfoutput>, the professional association for design, is the place design professionals turn to first to exchange ideas and information, participate in critical analysis and research and advance education and ethical practice. <a href="/content.cfm/about">more&nbsp;&#187;</a></h5>
	</cfif>

	<h3 <cfif CurrentCategoryAlias IS NOT "Home">class="first"</cfif>>Search <cfoutput>#APPLICATION.SiteTitle#</cfoutput></h3>

	
	<form id="search" action="/content.cfm/search" method="get">
		<input id="search-text" type="text" name="searchTxt"<cfif IsDefined("URL.searchTxt")> value="<cfoutput>#URL.searchTxt#</cfoutput>"</cfif> />
		<input id="search-btn" type="image" src="/common/images/template/btn-search.gif" alt="Search" />
	</form>


	<cfsavecontent variable="sectionNav">
		<cfmodule template="/common/modules/display/dsp_NavSubPages.cfm" CategoryID="#CurrentCategoryID#">
	</cfsavecontent>
	<cfif Trim(sectionNav) NEQ "">
		<h3>In This Section</h3>
		<cfoutput>#sectionNav#</cfoutput>
	</cfif>
	<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
</div><!-- End Side bar -->

<hr />
<!-- Footer Include -->
<cfinclude template="/common/modules/Display/Navigation/dsp_NavFooter.cfm">

</div><!-- End wrap -->

</body>
</html>
