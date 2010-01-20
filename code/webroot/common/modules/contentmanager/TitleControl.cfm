<cfparam name="ATTRIBUTES.TitleTypeID" default="-1">
<cfparam name="ATTRIBUTES.ContentTypeID" default="-1">
<cfparam name="ATTRIBUTES.ContentPositionID" default="-1">
<cfparam name="ATTRIBUTES.ContentNameDerived" default="-1">
<cfparam name="ATTRIBUTES.returnVariable" default="Title">

<cfset Title="">
<cfswitch expression="#ATTRIBUTES.ContentTypeID#">
	<cfdefaultcase>
		<cfif ATTRIBUTES.TitleTypeID IS not "1200"><!--- 1200 is hidden --->
			<cfswitch expression="#APPLICATION.ApplicationName#">
				<cfdefaultcase>
					<cfswitch expression="#ATTRIBUTES.ContentPositionID#">
						<cfdefaultcase>
							<cfswitch expression="#ATTRIBUTES.TitleTypeID#">
								<cfcase value="1201"><cfset Title="<h1>#ATTRIBUTES.ContentNameDerived#</h1>"></cfcase>
								<cfcase value="1202"><cfset Title="<h2>#ATTRIBUTES.ContentNameDerived#</h2>"></cfcase>
								<cfcase value="1203"><cfset Title="<h3>#ATTRIBUTES.ContentNameDerived#</h3>"></cfcase>
								<cfcase value="1204"><cfset Title="<h4>#ATTRIBUTES.ContentNameDerived#</h4>"></cfcase>
								<cfcase value="1205"><cfset Title="<h5>#ATTRIBUTES.ContentNameDerived#</h5>"></cfcase>
								<cfcase value="1206"><cfset Title="<h6>#ATTRIBUTES.ContentNameDerived#</h6>"></cfcase>
								<cfdefaultcase><cfset Title="<h3>#ATTRIBUTES.ContentNameDerived#</h3>"></cfdefaultcase>
							</cfswitch>
						</cfdefaultcase>
					</cfswitch>
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cfdefaultcase>
</cfswitch>

<cfset SetVariable("CALLER.#ATTRIBUTES.returnVariable#",Title)>