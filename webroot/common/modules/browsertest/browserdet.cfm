<!--- sets GetOsBrow default --->
<cfparam name="GetOsBrow" default="">
<!--- sets var for cookie if not present --->
<cfparam name="OSBrow" default="">
<!--- Set browser/os list --->
<!--- 1st list comma deliminated, 2nd list semi-colon deliminated --->
<!--- browser, operation system, path to file 
<cfset OSBrow = "firefox,win,/common/styles/firefox.css;opera,all,/common/styles/opera.css;safari,all,/common/styles/safari.css">
--->
<cfif GetOsBrow eq "" and OSBrow neq "" >
	<cfset uaString = LCase(CGI.HTTP_USER_AGENT)>


<cfoutput>
<cfset bo=ListLen(OSBrow , ";")>

<cfloop index="i" from="1" to="#bo#">

<cfset subList=ListGetAt(OSBrow, i, ";")>
<!--- Test the user agent string against browser, os, style sheet list --->
<cfif uaString contains ListGetAt(subList,1,",") and uaString contains ListGetAt(subList,2,",") or uaString contains ListGetAt(subList,1,",") and  ListGetAt(subList,2,",") eq "all">
<!--- Set cookie for style sheet location so that it doesn't need to be tested again, setting cookie for browser session --->
<cfcookie name="GetOsBrow" value="#ListGetAt(subList,3)#">
<!--- Add Style sheet code to template --->
<style type="text/css">
	/* Exclusive styles for #ListGetAt(subList,1,",")# <cfif ListGetAt(subList,2,",") eq "all">for all operating systems<cfelse>for #ListGetAt(subList,2,",")# OS</cfif> */
	@import url(#ListGetAt(subList,3)#);
</style>
</cfif>

</cfloop>

</cfoutput>
<!--- If cookie is set load the proper style sheet for browser/OS --->
<cfelseif GetOsBrow neq "" and GetOsBrow neq "nboss">
<cfoutput><style type="text/css">
	/* Exclusive styles for browser/os */
	@import url(#GetOsBrow#);
</style></cfoutput>
</cfif>
