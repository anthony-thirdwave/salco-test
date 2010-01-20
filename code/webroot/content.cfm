<cfsetting showdebugoutput="1">
<cfsilent><!--- Logic to handle the search engine friendly URL's --->
	<cfmodule template="/common/modules/utils/ParseURL.cfm" PageInfo="#CGI.path_info#">
	<Cfset REQUEST.ContentGenerateMode="DYNAMIC">
	<cfset REQUEST.ReCache="1">
</cfsilent>
<cfinclude template="/common/modules/contentmanager/content.cfm">
