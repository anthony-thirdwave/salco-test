
<cfsetting showdebugoutput="1">
<cfsilent><!--- Logic to handle the search engine friendly URL's --->
	<cfmodule template="/common/modules/utils/ParseURL.cfm" PageInfo="#CGI.path_info#">
	<Cfset REQUEST.ContentGenerateMode="DYNAMIC">
	<cfset REQUEST.ReCache="1">
</cfsilent>
<cfinclude template="/common/modules/contentmanager/content.cfm">
	
<cfif IsDebugMode() AND IsDefined("Client.wCurrentUser") and 0>
	<table border="1"><TR><TD><cfoutput><b>SESSION.UserLogin:</b> #SESSION.UserLogin#<BR>
	<b>SESSION.UserPassword:</b> #SESSION.UserPassword#</cfoutput>
	<cfdump var="#Client.wCurrentUser#">
	</TD></TR></table>
</cfif>