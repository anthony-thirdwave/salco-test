<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Errord Test</title>
</head>

<body>
<cfset Result = 1 / 0>


<!--- Division by zero will trigger an error  --->

<!--- This will not be processed  --->
<p>
<cfoutput>#NumberFormat(Result)#</cfoutput>
</p>

</body>
</html>
