<cfsetting showdebugoutput="No">
<cfparam name="URL.URL" default="">
<cfparam name="URL.Title" default="Title">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title><cfoutput>#URL.Title#</cfoutput></title>
</head>

<body>

<iframe frameborder="0"  src="<cfoutput>#URL.URL#</cfoutput>" width="965" height="645"></iframe>

</body>
</html>
