<cfparam name="searchTxt" default="">
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<cfif Trim(PageTitleOverride) EQ "">
	<cfset pageTitleList=ListRest(CategoryThreadName)>
	<cfset thisPageTitle=APPLICATION.utilsObj.generatePageTitleString(pageTitleList)>
<cfelse>
	<cfset thisPageTitle=PageTitleOverride>
</cfif>
<cfoutput>
<meta name="keywords" content="#MetaKeywords#" />
<meta name="description" content="#Metadescription#" />
<meta name="generator" content="#APPLICATION.GeneratorMeta#" />
<cfif IsDefined("PageType")>
	<meta name="dc.type" content="#PageType#" />
</cfif>
<title>#thisPageTitle#</title>
</cfoutput>
	<!--- include meta --->
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
<script type="text/javascript" src="/common/scripts/swfobject.js"></script>

<!--[if lt IE 9]>
	<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->

<script type="text/javascript" src="/common/scripts/intranet/default.js"></script>

<style type="text/css">
	@import url(/common/styles/intranet/template.css);
	@import url(/common/styles/intranet/kiosk.css);
	@import url(/common/styles/intranet/calendar.css);
	@import url(/common/styles/intranet/jquery-ui.css);
</style>

<link href="/common/scripts/projekktor/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/common/scripts/projekktor/projekktor.min.js"></script>

<cfif APPLICATION.Production>
	<script type="text/javascript">
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-37736610-1']);
		_gaq.push(['_trackPageview']);
		
		(function() {
		   	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		   	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
	</script>
</cfif>
</head>

<cfoutput><body class="default content #CSSClass#" id="#CSSID#"></cfoutput>
<a name="top"></a>
<!-- Main Element Container (wrapper) -->
<div id="wrapper">
	<!-- Header Elements Container (header) -->
	<div id="header">
		<!-- Logo Content -->
		<div id="logoContainer">
			<a href="/"><img border="0" alt="Salco Products Intranet" src="/common/images/intranet/template/intranetLogo.png"></a>
		</div>
		<!-- Utility Navigation and items -->
		<div id="utilityNavigation">
			<cfif NOT REQUEST.SecurityDenyAccess>
				<nav class="utilityNavigation">
					<cfmodule template="/common/modules/Display/Navigation/intranet/dsp_NavUtility.cfm">
				</nav>
				<cfoutput>
				<form name="search" method="get" action="#APPLICATION.utilsObj.parseCategoryUrl('/page/system/search-intranet')#" id="search">
					<label for="search-text">Search</label>
					<input type="text" name="searchTxt" id="search-text" value="#HTMLEditFormat(searchTxt)#"/>
					<input type="submit" value="search" alt="Search"  id="search-btn">
				</form>
				</cfoutput>
			</cfif>
		</div>
		<!-- to clear out floats -->
		<div class="clearit"></div>
		<cfif ListLen(CategoryThreadList) GTE "3" and ListGetAt(CategoryThreadList,3) is APPLICATION.NewsCategoryID>
			<cfif currentCategoryID is APPLICATION.NewsCategoryID>
				<cfset BreadcrumbDisplayType="news">
			<cfelse>
				<cfset BreadcrumbDisplayType="newsDetail">
			</cfif>
			<cfset breadcrumbCategoryID="#APPLICATION.NewsCategoryID#">
		<cfelseif ListLen(CategoryThreadList) GTE "3" and ListGetAt(CategoryThreadList,3) is APPLICATION.safetyArchiveCategoryID>
			<cfif currentCategoryID is APPLICATION.safetyArchiveCategoryID>
				<cfset BreadcrumbDisplayType="news">
			<cfelse>
				<cfset BreadcrumbDisplayType="newsDetail">
			</cfif>
			<cfset breadcrumbCategoryID="#APPLICATION.safetyArchiveCategoryID#">
		<cfelseif ListLen(CategoryThreadList) GTE "3" and ListGetAt(CategoryThreadList,3) is APPLICATION.EmployeeCategoryID>
			<cfset BreadcrumbDisplayType="employee">
			<cfset breadcrumbCategoryID="#currentCategoryID#">
		<cfelse>
			<cfset BreadcrumbDisplayType="">
		</cfif>
		<cfif REQUEST.SecurityDenyAccess>
			<cfset BreadcrumbDisplayType="">
		</cfif>
		<!-- employee/news navigation -->
		<cfif len(BreadcrumbDisplayType)>
			<cfsavecontent variable="BreadcrumbContent">
				<cfmodule template="/common/modules/Display/Navigation/intranet/dsp_NavBreadcrumb.cfm" BreadcrumbDisplay="#BreadcrumbDisplayType#" CategoryID="#breadcrumbCategoryID#" newsID="#currentCategoryID#">
			</cfsavecontent>
			<cfoutput>#BreadcrumbContent#</cfoutput>
		<cfelse>
			<cfset BreadcrumbContent="">
		</cfif>
	</div>
	<!-- Main Content Container -->
	<div id="contentContainer">
		<!-- Sub Content Containers -->
			<!-- start left column -->
			<div id="leftColumn">
			<!-- main navigation -->
				<div id="mainNavigation"><!-- Start of Main Navigation Elements -->
					<cfif NOT REQUEST.SecurityDenyAccess>
						<cfmodule template="/common/modules/Display/Navigation/intranet/dsp_NavSub.cfm">
						<cfif SESSION.UserID GT "0">
							<div id="inLogoff">
								<a href="/common/modules/security/logoff.cfm">Logoff</a>
							</div>
						</cfif>
					</cfif>
				</div><!-- End of Main Navigation Elements -->
                
                <nav class="socialmedia">
                    <ul>
                        <li><a href="https://www.linkedin.com/company/salco-products" target="_blank" title="LinkedIn"><img src="/common/images/template/social-linkin.png" ></a></li>
                        <li><a href="https://plus.google.com/+SalcoProductsIncLemont" target="_blank" title="Google+"><img src="/common/images/template/social-google-plus.png"></a></li>
                        <li><a href="https://www.youtube.com/salcoproductsinclemont" target="_blank" title="Youtube"><img src="/common/images/template/social-youtube.png"></a></li>
                    </ul>
                </nav>
                	
			</div>
			<!-- end of left column -->
		<!-- start of center column -->
		<div id="centerColumn">
			<div class="centerInner">
				<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
			</div>
			<cfif ListLen(CategoryThreadList) GTE "3" and ListGetAt(CategoryThreadList,3) is APPLICATION.NewsCategoryID and BreadcrumbDisplayType IS NOT "newsDetail">
				<div id="bottomNavigation">
					<cfoutput>#BreadcrumbContent#</cfoutput>
				</div>
			</cfif>
	  	</div>
		<!-- end of center column -->
			<!-- start of right column -->
			<div id="rightColumn">
				<cfif NOT REQUEST.SecurityDenyAccess>
					<cfinclude template="/common/modules/calendar/calendarControl.cfm">
					<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
				</cfif>
			</div>
			<!-- end of right column -->
		<!-- clear floats -->
		<div class="clearit"></div>
	</div>
</div>
</body>
</html>
