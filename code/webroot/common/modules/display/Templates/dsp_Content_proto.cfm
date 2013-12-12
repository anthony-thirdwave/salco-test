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
<meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">
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
	</cfif>
</cfoutput>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/common/js/jquery.client.js"></script>
<script type="text/javascript" src="/common/js/html5shiv.js"></script>
<script type="text/javascript" src="/common/js/default-updated.js"></script>
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
	
	#contact-us-aside{display:none;}
	
	#contact-us-aside:target {
		display:block;
	}
	
	#contact-us-aside:target + div {
		display:none;
	}
	/* above css is just for demo, will need to update css for fonts when we have the fonts.com code */
</style>
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
			<cfoutput>
			<form method="get" action="#APPLICATION.utilsObj.parseCategoryUrl('search')#">
				<input type="text" name="searchTxt" class="backSearch" value="Search Salco Products..." />
				<input type="submit" class="btnSearch" />
			</form>
			</cfoutput>
		</div>
		<div id="nav-toggle-container">
			<div id="nav-toggle-background"></div>
			<a href="#nav-toggle-container" class="toggle-nav"></a>
			<nav id="main-navigation">
				<cfmodule template="/common/modules/Display/Navigation/dsp_Nav.cfm"
					ParentID="1">
			</nav>
			<nav id="products-navigation">
				<cfmodule template="/common/modules/Display/Navigation/dsp_Nav.cfm"
					ParentID="7">
			</nav>
		</div>
	</header>
	<div id="content-wrapper">
		<div id="left-content">
			<cfif ListLen(CategoryThreadList) GTE "3">
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
			<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
		</div>
		<div id="right-content">
			<cfsavecontent variable="RightColumnContent">
				<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
			</cfsavecontent>
			<cfif Trim(RightColumnContent) IS NOT "">
				<div id="right-aside" style="">
					<cfoutput>#RightColumnContent#</cfoutput>
				</div>
			</cfif>
		</div>
	</div>
	<footer>
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
		</ul>
	</footer>
</div>
</body>
</html>
