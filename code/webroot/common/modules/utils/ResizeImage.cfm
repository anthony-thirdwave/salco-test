<cfsilent>
	<!--- This page is called via cfhttp as a workaround to the <, issue --->
	<cftry>
		<cfinvoke component="/com/utils/image" method="Resize" returnVariable="ThisImageThumbnail"
			WebrootPath="#URL.WebrootPath#"
			Source="#URL.Source#"
			Width="#URL.Width#">
		<cfset result = ThisImageThumbnail>
		<cfcatch><cfset result = "failed"></cfcatch>
	</cftry>
</cfsilent><cfoutput>#result#</cfoutput>