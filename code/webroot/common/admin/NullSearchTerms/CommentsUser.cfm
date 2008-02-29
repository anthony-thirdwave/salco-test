<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<link rel="stylesheet" type="text/css" href="/common/styles/admin.css" title="docProperties">
	<title>User Comments</title>
</head>

<body>
<cfquery name="GetSearchTerms" datasource="#APPLICATION.DSN#">
	SELECT * FROM qry_GetSearchTracking WHERE TrackingTypeID=33 AND TrackingID=#Val(TID)#
</cfquery>

<cfoutput query="GetSearchTerms">
	<cf_wddx_IsPacketValid packet="#PropertiesPacket#">
	<cfif WDDX_IsPacketValid>
		<cfwddx action="WDDX2CFML" input="#PropertiesPacket#" output="sTrackingProperties">
	<cfelse>
		<cfset sTrackingProperties=StructNew()>
	</cfif>
	<cfif StructKeyExists(sTrackingProperties,"aUserComments")>
		<cfset aUserComments=sTrackingProperties.aUserComments>
	<cfelse>
		<cfset aUserComments=ArrayNew(1)>
	</cfif>
	<cfif ArrayLen(aUserComments) GT "0">
		<table>
		<cfloop index="i" from="1" to="#ArrayLen(aUserComments)#" step="1">
			<TR valign="top"><TD>#i#</TD><TD><P><a href="mailto:#aUserComments[i].EMailAddress#">#aUserComments[i].EMailAddress#</A> wrote on #DateFormat(aUserComments[i].DateTimeStamp)#<BR>
			#aUserComments[i].Comments#</P></TD></TR>
		</cfloop>
		</table>
	</cfif>
</cfoutput>
</body>
</html>
