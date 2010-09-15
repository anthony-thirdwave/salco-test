<cfparam name="StatusMessage" default="An Informative Message">
<cfif IsDefined("ATTRIBUTES.StatusMessage")>
	<cfset StatusMessage=ATTRIBUTES.StatusMessage>
</cfif>
<cfif IsDefined("URL.cvid") and isDefined("SESSION.mb_#URL.cvid#")>
	<cfset StatusMessage=SESSION["mb_#URL.cvid#"]>
	<cfset SetVariable("SESSION.mb_#URL.cvid#","")>
</cfif>
<cfif IsDefined("URL.svid")>
	<cfset StatusMessage=SESSION["mb_#URL.svid#"]>
</cfif>
<cfif IsDefined("URL.sem")>
	<cfset StatusMessage="Transaction declined\n\nYour credit card was entered incorrectly or was not authorized. Please re-enter your credit card information or use a new credit card for this transaction.">
</cfif>
<cfif IsDefined("ATTRIBUTES.Location")>
	<cfset Location=ATTRIBUTES.Location>
</cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<script language="JavaScript">
<!--
function ReloadPage() {
	<cfoutput>
		alert("\n#StatusMessage#");
		<cfif Location IS "Back">
			history.go(-1);
			history.back();
		<cfelse>
			window.location.replace("#Location#");
		</cfif>
	</cfoutput>
}
// -->
</script>
<title>Alert</title>
</head>
<BODY onload="ReloadPage();">

</body></html>
