<!--- declare variables --->
<cfparam name="CategoryID" default="">
<cfparam name="Page" default="">
<cfparam name="URL.pff" default="no">
<cfparam name="URL.prcid" default="">
<cfparam name="URL.pcid" default="">
<cfset PreviewTargetContentID=APPLICATION.utilsObj.SimpleDecrypt(Val(URL.prcid))>
<cfset PreviewSourceContentID=APPLICATION.utilsObj.SimpleDecrypt(Val(URL.pcid))>

<cfset REQUEST.ReCache="1">

<cfif listLen(Page, "/")>
	<cfset pageAlias=getToken(Page,listLen(Page,"/"),"/")>
<cfelse>
	<cfset pageAlias="home">
	<cfset page="/page/home">
</cfif>

<cfswitch expression="#REQUEST.SiteName#">
	<cfcase value="intranet.salco">
		<cfset SiteID="6061">
	</cfcase>
	<cfdefaultcase>
		<cfset SiteID="#APPLICATION.defaultSiteCategoryID#">
	</cfdefaultcase>
</cfswitch>

<cfmodule template="/common/modules/ContentManager/GetContent.cfm"
	CategoryID="#Val(CategoryID)#"
	CategoryAlias="#Page#"
	PreviewTargetContentID="#Val(PreviewTargetContentID)#"
	PreviewSourceContentID="#Val(PreviewSourceContentID)#">

<!--- TODO - is this how this will happen? --->
<cfset sApplicationCategoryID=StructNew()>
<cfset sApplicationCategoryID["1"]="www.salco">
<cfset sApplicationCategoryID["6061"]="intranet.salco">
<cfif ListLen(CategoryThreadList) GTE "2" AND ListFindNoCase(StructKeyList(sApplicationCategoryID),ListGetAt(CategoryThreadList,2))>
	<cfif sApplicationCategoryID[ListGetAt(CategoryThreadList,2)] IS NOT APPLICATION.ApplicationName>
		<cflocation url="http://#APPLICATION.sLocation[sApplicationCategoryID[ListGetAt(CategoryThreadList,2)]]##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addtoken="No">
	</cfif>
</cfif>

<!--- TODO - this section handles multiple display instances based up on application name --->
<cfswitch expression="#TemplateID#">
	<cfdefaultcase>
		<cfswitch expression="#APPLICATION.ApplicationName#">
			<cfcase value="intranet.salco">
				<cfinclude template="/common/modules/display/templates/intranet/dsp_content.cfm">
			</cfcase>
			<cfdefaultcase>
				<cfinclude template="/common/modules/display/templates/dsp_content.cfm">
			</cfdefaultcase>
		</cfswitch>
	</cfdefaultcase>
</cfswitch>