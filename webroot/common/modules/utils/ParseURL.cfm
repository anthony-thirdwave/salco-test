<cfsilent>
<cfparam name="ATTRIBUTES.PageInfo" default="">
<cfif NOT IsDefined("URL.Page") AND ListLen(ListLast(ATTRIBUTES.PageInfo,"/"),".") IS "1">
	<cfif ListLen(ListLast(ATTRIBUTES.PageInfo,"/"),"=") IS "1">
		<cfset CALLER.Page=ListLast(ATTRIBUTES.PageInfo,"/")>
	<cfelse>
		<cfloop index="ThisAttribute" list="#ListRest(ATTRIBUTES.PageInfo,"/")#" delimiters="/">
			<cfif ListLen(ThisAttribute,"=") IS "2">
				<cftry>
					<cfset DevNull=SetVariable("URL.#ListFirst(ThisAttribute,'=')#","#ListLast(ThisAttribute,'=')#")>
					<cfcatch>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
</cfsilent>