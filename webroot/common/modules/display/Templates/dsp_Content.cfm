<cfif Trim(PageTitleOverride) EQ "">
	<cfset pageTitleList=ListRest(CategoryThreadName)>
	<cfset thisPageTitle=APPLICATION.utilsObj.generatePageTitleString(pageTitleList)>
<cfelse>
	<cfset thisPageTitle=PageTitleOverride>
</cfif>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta content="width=925, maximum-scale=1" name="viewport">
<cfoutput>
	<title>#thisPageTitle#</title>
	<meta name="keywords" content="#MetaKeywords#" />
	<meta name="description" content="#Metadescription#" />
	<meta name="generator" content="#APPLICATION.GeneratorMeta#" />
	<meta name="generator-content" content="#APPLICATION.GeneratorContentMeta#" />
	<meta name="dc.title" content="#HTMLEditFormat(CurrentCategoryName)#" />
	<cfif IsDefined("PageType")>
		<meta name="dc.type" content="#PageType#" />
	</cfif>
	<cfif APPLICATION.Production>
		<script type="text/javascript">
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', 'UA-8851532-4']);
			_gaq.push(['_trackPageview']);

			(function() {
				var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
				ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();
		</script>

		<!--- adds script for social media in search results --->
		<script type="application/ld+json">
			{
			  "@context" : "http://schema.org",
			  "@type" : "Organization",
			  "name" : "Salco Products Inc",
			  "url" : "http://www.salcoproducts.com",
			  "sameAs" : [
			    "https://plus.google.com/+SalcoProductsIncLemont/posts",
			    "https://www.linkedin.com/company/salco-products",
			    "https://www.youtube.com/channel/UCc5grhboh2Rjr2PvddkXzXw"
			  ]
			}
		</script>


	</cfif>
</cfoutput>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/common/js/jquery.client.js"></script>
<script type="text/javascript" src="/common/js/html5shiv.js"></script>

<script type="text/javascript" src="/common/js/default-updated.js"></script>

<script type="text/javascript" src="/common/js/jquery.patternizer.js"></script>
<script type="text/javascript" src="/common/js/jquery.hashchange.js"></script>
<!--[if lt IE 9]>
	<script src="/common/js/html5shiv.js"></script>
<![endif]-->
<link type="text/css" rel="stylesheet" href="http://fast.fonts.net/cssapi/2be01d4e-a0db-490d-a9b9-78f5099f10bc.css"/>
<style type="text/css">
	@import url(/common/css/main.css);
	body {
		font-family: 'Century Gothic W01';
	}
	#right-content {
	 font-family: font-family:'Myriad W01 Regular';
	}
	/* above css is just for demo, will need to update css for fonts when we have the fonts.com code */
</style>

<cfif ListFindNoCase("62,64",CategoryTypeID)>
	<cfif ListLen(CategoryThreadList) GTE "5">
		<cfoutput>
			<script type="text/javascript">
				$(document).ready(function() {
					<cfset ThisList="">
					<cfloop index="i" from="5" to="#ListLen(CategoryThreadList)#" step="1">
						<cfset ThisList=ListAppend(ThisList,ListGetAt(CategoryThreadList,i))>
					</cfloop>
					getNavItemsAuto('#ThisList#','#ThisList#');
				});
			</script>
		</cfoutput>
	</cfif>
</cfif>
<cfoutput>
	<script type="text/javascript">

			<cfset ThisList="">
			<cfloop index="i" from="1" to="#ListLen(CategoryThreadList)#" step="1">
				<cfset ThisList=ListAppend(ThisList,ListGetAt(CategoryThreadList,i))>
			</cfloop>
			var globalNavItems='#ThisList#';

	</script>
</cfoutput>
</head>

<cfoutput>
	<body id="#CSSID#" class="#CSSClass#"><a name="top"></a>
</cfoutput>
<!-- modal html start -->
<div id="modal-holder">
	<div id="modal-background"></div>
	<div id="modal-outer">
		<div id="modal-inner">
			<div id="modal-close"><a href="#close"></a></div>
			<div id="modal-content"> </div>
		</div>
	</div>
</div>
<!-- modal html end -->
<!--- updated non-home template start --->
<div id="site-wrapper">
	<header id="site-header"><a href="/" id="salco-logo"><img src="/common/images/template-updated/logo-updated-resized.jpg" alt="Salco Products, Inc."/></a>
		<div id="util-nav">
			<div id="util-nav-bg"></div>
			<a href="#util-nav" class="toggle-util-link"></a>
			<nav>
				<ul>
					<li><a target="_blank" href="https://www.m2mvip.com/vipsite/global/login/userlogin.aspx">VIP Login</a></li>
					<li><a href="/page/espanol">Espa&ntilde;ol</a></li>
				</ul>
			</nav>
			<cfmodule template="/common/modules/search/searchForm.cfm">
		</div>
		<div id="nav-toggle-container">
			<div id="nav-toggle-background"></div>
			<a href="#nav-toggle-container" class="toggle-nav"></a>
			<nav id="main-navigation">
				<cfmodule template="/common/modules/display/navigation/dsp_NavR.cfm"
					CategoryID="1">
			</nav>
			<nav id="products-navigation">
				<cfmodule template="/common/modules/Display/Navigation/dsp_NavR.cfm"
					CategoryID="7" MaxLevel="3">
			</nav>
		</div>
	</header>
	<cfswitch expression="#TemplateID#">
		<cfcase value="22">
			<div id="content-wrapper-home">
				<div id="left-content">
					<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
				</div>
				<div id="right-content">
					<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
				</div>
			</div>
		</cfcase>
		<cfdefaultcase>
			<div id="content-wrapper">
				<div id="left-content">
					<cfif ListFind("62,64",CategoryTypeID)>
						<cfif ListLen(CategoryThreadList) GTE "4">
							<ul id="acc3">
							<cfif listFind(CategoryThreadList,APPLICATION.orphanProductFamilyCategoryID) IS "0">
								<li class="treeHeader"><cfoutput>#ListGetAt(CategoryThreadName,3)#</cfoutput></li>
								<cfmodule template="/common/modules/display/navigation/dsp_NavProduct.cfm" CategoryID="#ListGetAt(CategoryThreadList,4)#" CategoryThreadList="#CategoryThreadList#">
							<cfelse>
								<li class="treeHeader">Sub-Assemblies</li>
								<cfif isDefined("URL.return") and URL.return is not "">
									<div id="productNav">
										<ul>
										<cfoutput><li><a href="#APPLICATION.utilsObj.parseCategoryUrl(URL.return)#" data-CategoryID="" data-CategoryThreadList="" data-HasChildren="false">Return to Main Assembly</a></li></cfoutput>
									</ul>
								</cfif>
							</cfif>
							</ul>
						</cfif>
					<cfelseif ListLen(CategoryThreadList) GTE "3">
						<cfsavecontent variable="LeftNavContent">
							<cfmodule template="/common/modules/display/navigation/dsp_NavR.cfm" CategoryID="#ListGetAt(CategoryThreadList,3)#">
						</cfsavecontent>
						<cfif Trim(LeftNavContent) IS NOT "">
							<nav class="vers-1">
								<cfoutput>#LeftNavContent#</cfoutput>
							</nav>
						</cfif>
					</cfif>
				</div>
				<div id="center-content">
					<cfif ListFind(CategoryThreadList,APPLICATION.NewsCategoryID)>
						<cfif currentCategoryID eq APPLICATION.NewsCategoryID>
							<cfinclude template="/common/modules/news/newsListingPagination.cfm">
						<cfelse>
							<cfinclude template="/common/modules/news/newsDetailPagination.cfm">
						</cfif>
					</cfif>
					<cfif ListFindNoCase("62",CategoryTypeID)>
						<cfif ListLen(CategoryThreadList) GTE "3">
							<cfoutput><h1>#ListGetAt(CategoryThreadName,3)#</h1></cfoutput>
						</cfif>
					<cfelseif ListFindNoCase("64",CategoryTypeID)>
						<cfoutput>
							<cfif ListLen(CategoryThreadList) GTE "3">
								<cfif listFind(CategoryThreadList,APPLICATION.orphanProductFamilyCategoryID) IS "0">
									<h3>#ListGetAt(CategoryThreadName,3)#</h3>
								<cfelse>
									<cfif ListLen(CategoryThreadList) GTE "4">
										<h3>Sub-Assembly</h3>
									<cfelse>
										<h3>Product</h3>
									</cfif>
								</cfif>
							</cfif>
							<cfif ListLen(CategoryThreadList) GTE "4">
								<cfif listFind(CategoryThreadList,APPLICATION.orphanProductFamilyCategoryID) IS "0">
									<h2>#ListGetAt(CategoryThreadName,4)#</h2>
								<cfelse>
									<h2>#ListLast(CategoryThreadName)#</h2>
								</cfif>
							</cfif>
							<h1>#CurrentCategoryName#</h1>
						</cfoutput>
					<cfelse>
						<cfoutput><h1>#CurrentCategoryName#</h1></cfoutput>
					</cfif>
					<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
				</div>
				<div id="right-content">
					<cfsavecontent variable="RightColumnContent">
						<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
					</cfsavecontent>
					<cfif Trim(RightColumnContent) IS NOT "">
						<cfif CurrentCategoryAlias is "contact-us">
							<aside id="contact-us-aside">
							<div class="inner-content">
							<cfoutput>#RightColumnContent#</cfoutput>
							</div>
							</aside>
						<cfelse>
							<div id="right-aside" style="">
								<cfoutput>#RightColumnContent#</cfoutput>
							</div>
						</cfif>
					</cfif>
				</div>
			</div>
		</cfdefaultcase>
	</cfswitch>
	<footer id="pagefooter">
		<ul>
			<li>&copy; <cfoutput>#Year(Now())#</cfoutput> Salco Products, Inc.</li>
			<li>
				<nav>
					<ul>
						<li><a href="/content.cfm/legal">Legal</a></li>
						<li><a href="/content.cfm/sitemap">Site Map</a></li>
					</ul>
				</nav>
			</li>
            <li class="socialmedia">
                <nav>
                    <ul>
                        <li><a href="https://www.linkedin.com/company/salco-products" target="_blank" title="LinkedIn"><img src="/common/images/template/social-linkin.png" ></a></li>
                        <li><a href="https://plus.google.com/+SalcoProductsIncLemont" target="_blank" title="Google+"><img src="/common/images/template/social-google-plus.png"></a></li>
                        <li><a href="https://www.youtube.com/salcoproductsinclemont" target="_blank" title="Youtube"><img src="/common/images/template/social-youtube.png"></a></li>
                    </ul>
                </nav>
            </li>
		</ul>
	</footer>
</div>
</body>
</html>
