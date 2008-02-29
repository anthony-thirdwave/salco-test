<cfparam name="ATTRIBUTES.File" default="">
<cfparam name="ATTRIBUTES.NumItems" default="">
<cfif ATTRIBUTES.File IS NOT "" AND FileExists(ATTRIBUTES.File)>
	<cffile action="READ" file="#ATTRIBUTES.File#" variable="RSSContent">
	<cfif 0>
		<cfinvoke component="/com/utils/rss"
			method="ParseRSSDescription"
			returnVariable="qRSS"
			RSSXML="#RSSContent#">
		<cfoutput query="qRSS">
			<p class="RSSTitle">#Title#</p>
		</cfoutput>
	</cfif>
	<cfinvoke component="/com/utils/rss"
		method="ParseRSSItems"
		returnVariable="qRSS"
		RSSXML="#RSSContent#">
	<cfif IsNumeric(ATTRIBUTES.NumItems) And ATTRIBUTES.NumItems GT "0">
		<cfoutput query="qRSS" maxrows="#ATTRIBUTES.NumItems#">
			<p class="RSSItem"><a href="#Link#">#Title#</a><br />
			<cfif Author IS NOT ""><em>&##8211;#Author#</EM><BR /></cfif>
			#Description#</p>
		</cfoutput>
	<cfelse>
		<cfoutput query="qRSS">
			<p class="RSSItem"><a href="#Link#">#Title#</a><br />
			<cfif Author IS NOT ""><em>&##8211;#Author#</EM><BR /></cfif>
			#Description#</p>
		</cfoutput>
	</cfif>
</cfif>