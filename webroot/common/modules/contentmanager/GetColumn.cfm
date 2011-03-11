<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
<cfparam name="ATTRIBUTES.ContentPositionID" default="400">
<cfparam name="ATTRIBUTES.CategoryThreadList" default="-1">
<cfparam name="ATTRIBUTES.PreviewSourceContentID" default="-1">
<cfparam name="ATTRIBUTES.PreviewTargetContentID" default="-1">
<cfparam name="ATTRIBUTES.returnVariable" default="FileContents">

<cfinvoke component="#REQUEST.MyContentManager#"
	method="GetColumnContentIDList"
	returnVariable="lContentID"
	CategoryID="#ATTRIBUTES.CategoryID#"
	LocaleID="#ATTRIBUTES.LocaleID#"
	ContentPositionID="#ATTRIBUTES.ContentPositionID#"
	CategoryThreadList="#ATTRIBUTES.CategoryThreadList#">

<cfinvoke component="#APPLICATION.MyCategoryHandler#"
	method="GetCategoryBasicDetails"
	returnVariable="GetCategory"
	CategoryID="#ATTRIBUTES.CategoryID#">

<cfset FileContents="">
<cfset ContentCounter="0">

<cfloop index="ThisContentID" list="#lContentID#">
	<cfif Val(ATTRIBUTES.PreviewSourceContentID) GT "0" and val(ATTRIBUTES.PreviewTargetContentID) GT "0" and val(ATTRIBUTES.PreviewTargetContentID) IS ThisContentID>
		<cfset ThisContentIDPrime=Val(ATTRIBUTES.PreviewSourceContentID)>
	<cfelse>
		<cfset ThisContentIDPrime=Val(ThisContentID)>
	</cfif>

	<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetContent">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(ThisContentIDPrime)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
	</cfstoredproc>

	<cfoutput query="GetContent">
		<cfif IsWDDX(GetContent.ContentBody)>
			<cfwddx action="WDDX2CFML" input="#GetContent.ContentBody#" output="sContentBody">
		<cfelse>
			<cfset sContentBody=StructNew()>
		</cfif>
		<cfmodule template="/common/modules/ContentManager/ContentControl.cfm"
			scontentbody="#sContentBody#"
			currentcategoryid="#ATTRIBUTES.CategoryID#"
			currentcategorytypeid="#GetCategory.CategoryTypeID#"
			contenttypeid="#GetContent.ContentTypeID#"
			contentid="#GetContent.ContentID#"
			ContentLocaleID="#GetContent.ContentLocaleID#"
			positionid="#ATTRIBUTES.ContentPositionID#"
			returnvariable="TheseFileContents">
		<cfif Trim(TheseFileContents) IS NOT "">
			<cfset ContentCounter=ContentCounter+1>
			<cfif StructKeyExists(sContentBody,"TitleTypeID")>
				<cfmodule template="/common/modules/ContentManager/TitleControl.cfm"
					returnVariable="Title"
					TitleTypeID="#Val(sContentBody.TitleTypeID)#"
					ContentTypeID="#Val(GetContent.ContentTypeID)#"
					ContentPositionID="#Val(ATTRIBUTES.ContentPositionID)#"
					ContentNameDerived="#ContentNameDerived#">
			</cfif>
			<cfif StructKeyExists(sContentBody,"CSSID") and sContentBody["CSSID"] IS NOT "">
				<cfset ThisCSSID=sContentBody["CSSID"]>
			<cfelse>
				<cfset ThisCSSID="ContentElement#GetContent.ContentID#">
			</cfif>
			<cfif StructKeyExists(sContentBody,"CSSClass") and sContentBody["CSSClass"] IS NOT "">
				<cfset ThisAdditionalCSSClass="#sContentBody['CSSClass']# ">
			<cfelse>
				<cfset ThisAdditionalCSSClass="">
			</cfif>
			<cfswitch expression="#APPLICATION.ApplicationName#">
				<cfdefaultcase>
					<cfif Trim("#FileContents##Title##TheseFileContents#") IS NOT "">
						<cfsavecontent variable="FileContents">
							#FileContents#
							<!-- START OF "#GetContent.ContentNameDerived#" CONTENT BLOCK (#GetContent.ContentID#) -->
							<div id="#ThisCSSID#" class="#lcase(application.utilsObj.scrub(GetContent.ContentTypeName))# #ThisAdditionalCSSClass# position#ContentCounter#">
								#Title# #TheseFileContents#
							</div>
							<!-- END OF "#GetContent.ContentNameDerived#" CONTENT BLOCK -->
						</cfsavecontent>
					</cfif>
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cfoutput>
</cfloop>

<cfset SetVariable("CALLER.#ATTRIBUTES.returnVariable#",FileContents)>