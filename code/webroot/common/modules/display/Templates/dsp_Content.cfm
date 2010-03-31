<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<cfif IsDefined("REQUEST.OverrideBaseHREF")>
	<cfoutput><base href="#REQUEST.OverrideBaseHREF#"></cfoutput>
</cfif>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- import standard styles -->
<style type="text/css">
	@import url(/common/styles/default.css);
</style>
<!-- import styles for IE, additional conditional comments may be needed -->
<!--[if IE]>
	<style type="text/css">
		@import url(/common/styles/ie.css);
	</style>
<![endif]-->

<!--- Remove CF comment if you need to emulate ie7 in ie8
<!-- Force IE8 to emulate IE7 -->
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> --->

<!--- Add Coldfusion browser detection --->
<!---
<cfset OSBrow = "browser,OS,path to style sheet; browser,OS,path to style sheet">
<!-- import addtional style sheets -->
<cfinclude template="/common/modules/browsertest/browserdet.cfm">
--->
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
	<meta name="generator" content="#APPLICATION.GeneratorMeta#" />
	<meta name="generator-content" content="#APPLICATION.GeneratorContentMeta#" />
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
<cfoutput>
	<body id="#CSSID#" class="#CSSClass#">
</cfoutput><a name="top"></a>
<!-- Main Element Container (wrapper) -->
<div id="wrapper">
	<!-- Header Elements Container (header) -->
	<div id="header">
		<!-- Logo Content -->
		<div id="logoContainer">
			<cfoutput><a href="#APPLICATION.utilsObj.parseCategoryUrl('/')#"><img src="/common/images/template/header_logo.gif" border="0" alt="#APPLICATION.CompanyName#" /></a></cfoutput>
		</div>
		<!-- Utility Navigation and items -->
		<div id="utilityNavigation">
			<cfoutput>
			<form id="search" action="#APPLICATION.utilsObj.parseCategoryUrl('search')#" method="get">
				<input id="search-text" type="text" name="searchTxt"<cfif IsDefined("URL.searchTxt")> value="#URL.searchTxt#"</cfif> />
				<input id="search-btn" type="image" src="/common/images/template/btn-search.gif" alt="Search" />
			</form>
			</cfoutput>
		</div>
		<!-- to clear out floats -->
		<div class="clearit"></div>
		<!-- main navigation -->
		<cfinclude template="/common/modules/Display/Navigation/dsp_NavGlobal.cfm">
	</div>
	<!-- clear floats -->
	<div class="clearit"></div>
	<!-- Main Content Container -->
	<div id="contentContainer">
		<!-- Sub Content Containers -->
		<!-- start left column -->
		<div id="leftColumn">
			<!--- Including side navigation, here or in right column  --->
			<cfsavecontent variable="sectionNav">
				<cfmodule template="/common/modules/display/dsp_NavSubPages.cfm" CategoryID="#CurrentCategoryID#">
			</cfsavecontent>
			<cfif Trim(sectionNav) NEQ "">
				<cfoutput>#sectionNav#</cfoutput>
			</cfif>
		</div>
		<!-- end of left column -->
		<!-- start of center column -->
		<div id="centerColumn">
			<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
	  	</div>
		<!-- end of center column -->
		<!-- start of right column -->
		<div id="rightColumn">
			<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
		</div>
		<!-- end of right column -->
		<!-- clear floats -->
		<div class="clearit"></div>
	</div>
	<!-- footer navigation -->
	<cfinclude template="/common/modules/Display/Navigation/dsp_NavFooter.cfm">
</div>
</body>
</html>
