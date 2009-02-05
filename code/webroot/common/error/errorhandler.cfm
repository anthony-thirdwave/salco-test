<cfif ListFindNoCase("webtrend,ultraseek",ListFirst(Error.Browser,"/"))>
<cfelse>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


	<link rel="stylesheet" type="text/css" media="screen, projection" href="/common/styles/screen.css" />
	
	<meta name="keywords" content="" />
	<meta name="description" content="" />
	<meta name="generator" content="#APPLICATION.GeneratorMeta#" />
	<meta name="generator-content" content="#APPLICATION.GeneratorContentMeta#" />
	<meta name="dc.title" content="" />
	
	<title>Site Error: #APPLICATION.CompanyName#</title>
	<script type="text/javascript" src="/common/scripts/sifr.js"></script>
	<script type="text/javascript" src="/common/scripts/common.js"></script>

</head>
<body>

<div id="wrap">

<div id="logo"><a href="/"><img src="/common/images/template/header_logo.gif" alt="#APPLICATION.CompanyName#" border="0" /></a></div>
<!-- Header and Navigation -->



<div id="header">
	<ul id="nav-top"></ul>

	<hr />
	
	
	<div id="banner">
		<div id="credit">
			<dl>
				<dt>#APPLICATION.CompanyName#</dt>
			</dl>
		</div>
	</div>
	
	
	<hr />
<ul id="nav-main"></ul>



	
</div> <!-- end #header -->

<hr />
<!-- Start of Content Area-->
<div id="content">
	<!-- Left/Main Column -->
	
	 
							<div class="cap"><h2>Error</h2></div>
						 <div class="group basic" id=""><div class="body"
						 
						 
 <p>Sorry, but that page could not be loaded.</P>
	  
	  <P>Please use either your
	  browser's Back button to go back, or click on the #APPLICATION.CompanyName# logo to the left
	  to return to the home page.  If you have any questions, please <a href="/content.cfm/about-contact">contact  
#APPLICATION.CompanyName#</a>.
	  </p>
	  
	  <p>
	  <form><input type="button" value="Go Back" onclick="javascript:history.go(-1);"></form>
	  </p>						 

</div></div>




	
	
	<p>&nbsp;</p>
</div>
<!-- End of Left Column	-->
<hr />
<!-- Start of Right/Side Content Area -->
<div id="sidebar">
	
		<h3 class="first">Search #APPLICATION.CompanyName#</h3>
	
	
	
	<form id="search" action="/content.cfm/search" method="get">

		<input id="search-text" type="text" name="searchTxt" />
		<input id="search-btn" type="image" src="/common/images/template/btn-search.gif" alt="Search" />
	</form>
	
		
	
	<p>&nbsp;</p>




</div><!-- End Side bar -->

<hr />
<!-- Footer Include -->
<cfinclude template="/common/modules/display/navigation/dsp_NavFooter.cfm">

</div><!-- End wrap -->

</body>
</html>
<!--- Get the list of addresses to which to send the error message, as well as
	  the From: address to use.  --->
<cftry>
	<cflock timeout="1" name="#Application.ApplicationName#" type="ReadOnly">
		<cfset ErrorMailTo = Application.ErrorMailTo>
		<cfset ErrorMailFrom = Application.ErrorMailFrom>
	</cflock>
<cfcatch type="Lock">
	<!--- There is a slight possibility that the application scope itself is
		  locked.  In fact, for all we know, a lock timeout might be what got
		  us here in the first place.  Failing to catch exceptions will result
		  in an infinite loop, so in this unlikely event, we will send the
		  error message to Thomas Sychay.  --->
	<cfset ErrorMailTo = "thomas@thirdwavellc.com">
	<cfset ErrorMailFrom = "webmaster@thirdwavellc.com">
</cfcatch>
</cftry>

<!--- Get the current time.  --->
<cfset ts = Now()>
<cfif 1 and Error.RemoteAddress IS NOT "81.203.209.76" and FindNoCase("slurp",Error.Browser,1) IS "0">
<!--- Send the error message to each address.  --->
<cfloop index="ToAddress" list="#ErrorMailTo#" delimiters=";">
	<cfmail to="#Trim(ToAddress)#"
			from="#ErrorMailFrom#"
			subject="#CGI.HTTP_HOST# Error on #DateFormat(ts)#, #TimeFormat(ts)#."
			type="HTML">
<p>
There was an error that occurred on the #CGI.HTTP_HOST# website on #DateFormat(ts)#, #TimeFormat(ts)#.
</p>

<p>
#Error.DateTime#<br>
Browser - #Error.Browser#<br>
IP Address - #Error.RemoteAddress#<br>
Referring Page - #Error.HTTPReferer#<br>
Page - #Error.Template#<br>
PATH_INFO - #CGI.SCRIPT_NAME#<br>
Query String - #Error.QueryString#<br>
</p>

<p>
#Error.Diagnostics#
<p>
</cfmail>
</cfloop>
</cfif>

</cfoutput>
</cfif>