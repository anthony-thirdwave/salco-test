<cfparam name="ATTRIBUTES.File" default="">
<cfparam name="ATTRIBUTES.NumItems" default="">

<cfif ATTRIBUTES.File IS NOT "" AND FileExists(ATTRIBUTES.File)>
	<cffile action="READ" file="#ATTRIBUTES.File#" variable="RSSContent">
	
	<!--- parse the file --->
	<cfinvoke component="com.utils.rss"
		method="ParseRSSItems"
		returnVariable="qRSS2"
		filePath="#ATTRIBUTES.File#">

	<!--- check to see that there are items returned --->
	<cfif isQuery(qRSS2.queryRSS) and qRSS2.queryRSS.recordcount GT "0">
	
		<!--- check to see if the number of items is limited and fewer than the number returned --->
		<cfif isNumeric(ATTRIBUTES.NumItems) and ATTRIBUTES.NumItems lte qRSS2.queryRSS.recordcount>
			<cfset numToDisplay = ATTRIBUTES.NumItems>
		<cfelse>
			<cfset numToDisplay = qRSS2.queryRSS.recordcount>
		</cfif>

		<cfoutput>
		
			<!--- only display items if they exist --->
			<cfif numToDisplay gt 0>
				<dl>
				
				<!--- display this query in a from loop so we can selectively limit
						the number of records returned --->
				<cfloop from="1" to="#numToDisplay#" index="itr">
					<dt>
						<!--- display title --->
						<a href="#qRSS2.queryRSS.linkHref[itr]#" target="_blank">
							#qRSS2.queryRSS.Title[itr]#
						</a>
						
						<!--- display author if returned --->
						<cfif qRSS2.queryRSS.authorName[itr] neq "">
							<span class="author">by #qRSS2.queryRSS.authorName[itr]#</span>
						</cfif>
					</dt>
					
					<!--- display content --->
					<dd>#REQUEST.ReplaceExtendedCharacters(qRSS2.queryRSS.content[itr])#</dd>
				</cfloop>
				</dl>
			</cfif>
			
			<!--- make sure the properties exist --->
			<cfif isStruct(qRSS2.propsRSS)
					and structKeyExists(qRSS2.propsRSS, "link")
					and structKeyExists(qRSS2.propsRSS, "title")>
					
				<!--- display the link to the RSS source --->
				<cfoutput><p class="additional"><a href="#qRSS2.propsRSS.link#" title="#qRSS2.propsRSS.title#" target="_blank">View more</a></p></cfoutput>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>