<cfif not ListFindNoCase("webtrend,ultraseek",ListFirst(CGI.HTTP_USER_AGENT,"/"))>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

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
<!--[if LT IE 7]>
    <style type="text/css">
        @import url(/common/styles/ie6.css);
    </style>
<![endif]-->
<!--[if GT IE 6]>
    <style type="text/css">
        @import url(/common/styles/ie7.css);
    </style>
<![endif]-->
<!--[if GT IE 7]>
    <style type="text/css">
        @import url(/common/styles/ie8.css);
    </style>
<![endif]-->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


	<link rel="stylesheet" type="text/css" media="screen, projection" href="/common/styles/screen.css" />
	
	<meta name="keywords" content="" />
	<meta name="description" content="" />
	<meta name="generator" content="#APPLICATION.GeneratorMeta#" />
	<meta name="generator-content" content="#APPLICATION.GeneratorContentMeta#" />
	<meta name="dc.title" content="" />
	
	<title>Site Error: #APPLICATION.CompanyName#</title>
	<script type="text/javascript" src="/common/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="/common/scripts/jquery.bgiframe.min.js"></script>
	<script type="text/javascript" src="/common/scripts/common.js"></script>
	<script type="text/javascript" src="/common/scripts/jquery.json-2.2.min.js"></script>
	<script type="text/javascript" src="/common/scripts/greybox.js"></script>
	<script type="text/javascript">
		var GB_ANIMATION = false;
		$(document).ready(function(){
			$("a.greybox").click(function(){
				var t = this.title || $(this).text() || this.href;
				GB_show(t,this.href,800);
				return false;
			});
			jQuery.each(jQuery.browser, function(i) {
				if($.browser.safari) {
					$('head').append("<link rel='stylesheet' type='text/css' href='/common/styles/safari.css' />");
					return false;
				}
			});
		});
	</script>
    <!--[if LT IE 7]>
		<script type="text/javascript" src="/common/scripts/pngfix.js"></script>
    <![endif]-->
</head>
<body>

<!-- Main Element Container (wrapper) -->
<div id="wrapper">
	<div class="topShadow">&nbsp;</div>
	
	<div id="leftContent">
		<div class="logoContainer">
	  		<a href="<cfoutput>#APPLICATION.utilsObj.parseCategoryUrl('/')#</cfoutput>"><img src="/common/images/template/logo.gif" border="0" alt="HDH Wine" /></a>
		</div>
	</div>


	<!-- Start of Content Area-->
	<div id="rightContent">
	
		<div class="mainContent">
			<h1>#APPLICATION.CompanyName#</h1>
		 	<p>Sorry, but that page could not be loaded.</P>
			  
			  <P>Please use either your
			  browser's Back button to go back, or click on the #APPLICATION.CompanyName# logo to the left
			  to return to the home page.  If you have any questions, please contact
			  <a href="/contact-us">#APPLICATION.CompanyName#</a>.
			  </p>
			  
			  <p>
			  <form><input type="button" value="Go Back" onclick="javascript:history.go(-1);"></form>
			  </p>						 
		</div>
		<div class="clearit">&nbsp;</div>
		<div id="footer">
			<cfinclude template="/common/modules/display/navigation/dsp_NavFooter.cfm">
		</div>
	</div>
	<div class="clearit">&nbsp;</div>
	<div class="bottomShadow">&nbsp;</div>
</div>

</body>
</html>

</cfoutput>
</cfif>