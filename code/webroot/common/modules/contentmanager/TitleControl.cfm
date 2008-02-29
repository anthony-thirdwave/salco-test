<!--- END SET UNIQUE HOME TITLE BARS --->
<cfif Title EQ "">
	<cfswitch expression="#ContentTypeID#">
		<cfcase value="232">
			<cfif 0>
				<cfif ListLen(CALLER.CategoryThreadList) GT 4>
					<cfset Title="<h3>In This Section</h3>">
				<Cfelse>
					<cfset Title="<h3>#CALLER.CurrentCategoryName#</h3>">
				</cfif>
			</cfif>
			<cfset Title="<h3>In This Section</h3>">
		</cfcase>
		<cfdefaultcase>
			<cfif sContentBody.TitleTypeID IS not "1200"><!--- 1200 is hidden --->
				<cfoutput>
					<cfswitch expression="#APPLICATION.ApplicationName#">
						<cfdefaultcase>
							<cfswitch expression="#ThisPosition#">
								<cfcase value="401">
									<cfset ThisTitle=ContentNameDerived>
									<cfif IsDefined("centerCounter") AND centerCounter EQ 1>
										<cfif ListLen(CALLER.CategoryThreadList) gt "3" and ParentCategoryName IS NOT "" AND ParentCategoryName IS NOT "system">
											<cfset ThisTitle="<a href=""/content.cfm/#ListGetAt(CALLER.CategoryThreadAlias,DecrementValue(ListLen(CALLER.CategoryThreadAlias)))#"">#ParentCategoryName#</a>">
										<cfelse>
											<cfset ThisTitle=CALLER.CurrentCategoryName>
										</cfif>
									</cfif>
									<cfsavecontent variable="Title">
										<div class="cap"><h2>#ThisTitle#</h2></div>
									</cfsavecontent>
								</cfcase>
								<cfdefaultcase><cfset Title="<h3>#ContentNameDerived#</h3>"></cfdefaultcase>
							</cfswitch>
						</cfdefaultcase>
					</cfswitch>
				</cfoutput>
			</cfif>
		</cfdefaultcase>
	</cfswitch>
</cfif>

<cfif Title IS NOT "">
	<cfset Title="#Title#">
</cfif>
