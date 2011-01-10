<cfparam name="ATTRIBUTES.ProductID" default="-1">

<cfif IsDefined("APPLICATION.LanguageID")>
	<cfparam name="ATTRIBUTES.LanguageID" default="#APPLICATION.LanguageID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LanguageID" default="100">
</cfif>


<cfif IsDefined("APPLICATION.LocaleID")>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.LocaleID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
</cfif>



<cfif Val(ATTRIBUTES.ProductID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProduct">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
	</cfstoredproc>
	<cfsilent>
		<cfset MyProduct=CreateObject("component","lifefitness.com.Product.Product")>
		<cfset MyProduct.Constructor(Val(ATTRIBUTES.ProductID),ATTRIBUTES.LanguageID)>
		<cfset aView=MyProduct.GetProperty("aProductView")>
		
		<cfset lProps="ProductThumbnailPath">
		<cfloop index="ThisProp" list="#lProps#">
			<cfset SetVariable("This#ThisProp#",MyProduct.GetProperty(ThisProp))>
		</cfloop>
		
	</cfsilent>
	<cfoutput>
	<div>
	
	<cfif ThisProductThumbnailPath iS NOT "">
		<table border="0" cellspacing="0" cellpadding="0" style="border: 1px solid silver;padding:10px;"><tr valign="top"><td>Thumbnail</TD><TD><img src="#ThisProductThumbnailPath#" alt="#REQUEST.GetPathFromURL(ThisProductThumbnailPath)#" border="0"></div></TD></TR></table>
	</cfif>&nbsp;
	<cfif ArrayLen(aView) GT "0">
		<cfloop index="i" from="1" to="#ArrayLen(aView)#">
			<table border="0" cellspacing="0" cellpadding="0" style="border: 1px solid silver;padding:10px;"><tr valign="top"><td>#REQUEST.ReplaceMarks(aView[i].ResourceName)#</TD>
			<TD><img src="#aView[i].MainFilePath#" alt="#REQUEST.GetPathFromURL(aView[i].MainFilePath)#"></TD></TR></table>&nbsp;
		</cfloop>
	</cfif>
	
	</div>
	</cfoutput>
</cfif>