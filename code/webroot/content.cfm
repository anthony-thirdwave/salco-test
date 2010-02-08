<cfsilent><!--- Logic to handle the search engine friendly URL's --->
	<cfmodule template="/common/modules/utils/ParseURL.cfm" PageInfo="#CGI.path_info#">
</cfsilent>
<cfinclude template="/common/modules/contentmanager/content.cfm">
