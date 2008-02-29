<cfif NewStatus IS NOT "">
	<cfquery name="UpdateStatus" datasource="#APPLICATION.DSN#">
		UPDATE t_Tracking set TrackingStatusID='#NewStatus#'  WHERE TrackingID=#val(EditTrackingID)#
	</cfquery>
	<cfparam name="EditMessage" default="">
	<cfif Trim(EditMessage) IS NOT "">
		<cfquery name="GetSearchTerms" datasource="#APPLICATION.DSN#">
			SELECT * FROM qry_GetSearchTracking WHERE TrackingTypeID=33 AND TrackingID=#Val(EditTrackingID)#
		</cfquery>
		
		<cfoutput query="GetSearchTerms" group="trackingid">
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
			<cfif ArrayLen(aUserComments) GT "0" and EditMessage IS NOT "">
				<cfparam name="EditSubject" default="New Information">
				<cfloop index="i" from="1" to="#ArrayLen(aUserComments)#" step="1">
					<cfmail to="#aUserComments[i].EMailAddress#" from="#APPLICATION.ContactEmail#" subject="#EditSubject#">
#EditMessage#
					</cfmail>
				</cfloop>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
<cflocation url="index.cfm?#CGI.QUERY_STRING#" addtoken="No">