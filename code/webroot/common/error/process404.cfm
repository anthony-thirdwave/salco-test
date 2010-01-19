<!---
Smert 404 Checker

This component of the content manager allows for a url such as
http://www.newermedia.com/AboutUs to be valid. The "AboutUs" string
corresponds to a CategoryAlias or a ContentAlias. Note that this process
looks first at the CategoryAlias, then the ContentAlias.

To implement this, make sure that these this folder and these two files
are in place:

/common/error/
/common/error/process404.cfm (This file)
/common/error/404.cfm (Page to be displayed when there is a 404 and no
					   CategoryAlias or ContentAlias match. This page should
					   have layout and gracefull message.)

Also, the IIS definition must be changed to apply this custom 404 message. In
IIS, edit a site's properties and go to the "Custom Errors" tab and scroll
down to HTTP Error 404. Click "Edit Properties". The "Message Type" should
be set to "URL" and the "URL" should be "/common/error/process404.cfm".
--->
<Cfset ThisURL=ListLast(CGI.QUERY_STRING,";")>
<cfset ThisAlias=ListLast(THisURL,"/")>
<cfset VarName="page">
<cflock scope="APPLICATION" type="READONLY" timeout="10">
	<cfset ThisDSN=APPLICATION.DSN>
</cflock>
<cfquery name="CheckAlias" datasource="#ThisDSN#">
	SELECT CategoryAlias FROM t_Category
	where CategoryAlias=<cfqueryparam value="#ThisAlias#" cfsqltype="cf_sql_varchar"> AND CategoryActive=1
</cfquery>

<cfset NewAlias=ThisAlias>
<cfif CheckAlias.RecordCount IS "1">
	<cfset NewAlias="#ThisAlias#">
<cfelse>
	<cfswitch expression="#ThisAlias#">
		<cfcase value="professional_practice">
			<cfset NewAlias="professional-practices">
		</cfcase>
		<cfcase value="designbusinessandethics">
			<cfset NewAlias="design-business-and-ethics">
		</cfcase>

		<cfdefaultcase>

		</cfdefaultcase>
	</cfswitch>
</cfif>

<cfif NOT IsDebugMode()>
	<cflocation url="#APPLICATION.contentPageInUrl#/#URLEncodedFormat(NewAlias)#" addtoken="No">
<cfelse>
	<cfoutput>404 Redirecting: <a href="#APPLICATION.contentPageInUrl#/#URLEncodedFormat(NewAlias)#">#APPLICATION.contentPageInUrl#/#URLEncodedFormat(NewAlias)#</a></cfoutput>
</cfif>


