<cfsilent>
	<!--- declare variables --->
	<cfparam name="CategoryID" default="">
	<cfparam name="Page" default="">
	<cfparam name="URL.ShowContentOnly" default="No">
	<cfparam name="URL.pff" default="no">
	<cfparam name="ForceNew" default="0">

</cfsilent>
<cfif APPLICATION.Production>
	<cfsilent>
		<cfmodule template="/common/modules/ContentManager/GetContent.cfm"
			CategoryID="#CategoryID#"
			CategoryAlias="#Page#">
	</cfsilent>
<cfelse>
	<cfmodule template="/common/modules/ContentManager/GetContent.cfm"
		CategoryID="#CategoryID#"
		CategoryAlias="#Page#">
</cfif>

<cfsilent>
	<!--- TODO - is this how this will happen? --->
	<cfset sApplicationCategoryID=StructNew()>
	<cfset sApplicationCategoryID["1"]="www.#Application.UniqueName#.com">
	<cfif ListLen(CategoryThreadList) GTE "2" AND ListFindNoCase(StructKeyList(sApplicationCategoryID),ListGetAt(CategoryThreadList,2))>
		<cfif sApplicationCategoryID[ListGetAt(CategoryThreadList,2)] IS NOT APPLICATION.ApplicationName>
			<cflocation url="http://#APPLICATION.sLocation[sApplicationCategoryID[ListGetAt(CategoryThreadList,2)]]##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addtoken="No">
		</cfif>
	</cfif>
</cfsilent>

<cfif Val(URL.ShowContentOnly)>
	<cfinclude template="/common/modules/display/templates/dsp_SimpleContent.cfm">
<cfelse>

	<!--- TODO - this section handles multiple display instances based up on application name --->
	<cfswitch expression="#TemplateID#">
		<cfdefaultcase>
			<cfswitch expression="#APPLICATION.ApplicationName#">
				<cfdefaultcase>
					<cfinclude template="/common/modules/display/templates/dsp_content.cfm">
				</cfdefaultcase>
			</cfswitch>
		</cfdefaultcase>
	</cfswitch>
</cfif>