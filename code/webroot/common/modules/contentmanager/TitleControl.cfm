<cfif Title EQ "">
	<cfswitch expression="#ContentTypeID#">
		<cfdefaultcase>
			<cfif sContentBody.TitleTypeID IS not "1200"><!--- 1200 is hidden --->
				<cfoutput>
					<cfswitch expression="#APPLICATION.ApplicationName#">
						<cfdefaultcase>
							<cfswitch expression="#ARGUMENTS.ContentPositionID#">
								<cfdefaultcase>
									<cfswitch expression="#sContentBody.TitleTypeID#">
										<cfcase value="1201"><cfset Title="<h1>#ContentNameDerived#</h1>"></cfcase>
										<cfcase value="1202"><cfset Title="<h2>#ContentNameDerived#</h2>"></cfcase>
										<cfcase value="1203"><cfset Title="<h3>#ContentNameDerived#</h3>"></cfcase>
										<cfcase value="1204"><cfset Title="<h4>#ContentNameDerived#</h4>"></cfcase>
										<cfcase value="1205"><cfset Title="<h5>#ContentNameDerived#</h5>"></cfcase>
										<cfcase value="1206"><cfset Title="<h6>#ContentNameDerived#</h6>"></cfcase>
										<cfdefaultcase><cfset Title="<h3>#ContentNameDerived#</h3>"></cfdefaultcase>
									</cfswitch>
								</cfdefaultcase>
							</cfswitch>
						</cfdefaultcase>
					</cfswitch>
				</cfoutput>
			</cfif>
		</cfdefaultcase>
	</cfswitch>
</cfif>
