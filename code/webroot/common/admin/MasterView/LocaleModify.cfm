<cfparam name="PageAction" default="Edit">
<cfparam name="ATTRIBUTES.DrawHTML" default="1">
<cfparam name="EditLocaleID" default="#SESSION.AdminCurrentAdminLocaleID#">
<cfparam name="EditChapterID" default="#SESSION.CurrentAdminChapterID#">
<cfparam name="CurrentLanguageID" default="100">
<cfset OpenAndCloseFormTables="no">

<cfif IsDefined("ATTRIBUTES.PageAction")>
	<cfset PageAction=ATTRIBUTES.PageAction>
</cfif>
<cfparam name="FormAction" default="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
<cfif IsDefined("ATTRIBUTES.FormAction")>
	<cfset FormAction=ATTRIBUTES.FormAction>
</cfif>
<cfif IsDefined("FORM.PageAction")>
	<cfset PageAction=FORM.PageAction>
</cfif>

<cfif IsDefined("URL.lid")>
	<cfset EditLocaleID=Decrypt(URL.lid,APPLICATION.Key)>
</cfif>

<cfset lid=Encrypt(EditLocaleID,APPLICATION.Key)>

<cfparam name="FORM.LocaleActive" default="0">

<cfset MyLocale=CreateObject("component","com.ContentManager.Locale")>
<cfset MyLocale.Constructor(Val(EditLocaleID))>
<cfif PageAction IS "Add" and val(EditChapterID) GT "0">
	<cfset MyLocale.SetProperty("ChapterID",EditChapterID)>
</cfif>

<cfif IsDefined("FORM.TemplateID")>
	
	<!--- if the form is submitted, load the form values into the object --->

	<!--- Handling MyLocale --->
	<cfloop index="ThisProperty" list="TemplateID,DefaultEventRegistrationModeID,VerisignID,CustomHeadHTML"><!--- juno --->
		<cfparam name="FORM.#ThisProperty#" default="">
		<cfset MyLocale.SetProperty("#ThisProperty#","#Evaluate('FORM.#ThisProperty#')#")>
	</cfloop>
</cfif>

<cfset PageAction=Trim(PageAction)>

<cfif PageAction IS "ValidateEdit" OR PageAction IS "ValidateAdd">
	<cfif NOT IsDefined("FORM.ButSubmit")>
		<cfset PageAction=ReplaceNoCase(PageAction,"Validate","","All")>
	</cfif>
</cfif>


<cfset PageTitle="Add Locale">
<cfif EditLocaleID GT "0">
	<cfset PageTitle="#MyLocale.GetProperty('LocaleName')# Settings">
</cfif>
<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Page Details"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | #PageTitle#">

<cfif ListFindNoCase("Add,Edit,ValidateDelete",PageAction) AND NOT IsDefined("ReturnURL")>
	<cfset ReturnURL=CGI.HTTP_Referer>
</cfif>

<cfswitch expression="#Trim(PageAction)#">
	<cfcase value="Add,Edit">
		<cfset FormMode="ShowForm">
		<table bgcolor="silver">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" Omitlist="PageAction">
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
			<input type="hidden" name="PageAction" value="Validate#PageAction#">
		</cfoutput>
		
		<tr valign="top">
		<TD bgcolor="white" width="100%"><table width="100%" cellspacing="1" cellpadding="2">
		<cfset FormMode="ShowForm">
		
		<cfinclude template="/common/modules/ContentManager/Locale/form.cfm">
		</table></TD></TR>
		<TR><TD bgcolor="white">
		<div align="right"><input type="submit" name="ButSubmit" value="Apply"></div></form>
		
		
		<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="SaveToProduction">
			<p align="right"><form action="#Location#?#querystring#" method="post"><input type="submit" value="Save Settings to Production"></form></p>
		</TD></TR></table>
	</cfcase>
	<cfcase value="ValidateEdit,ValidateAdd">
		<cfset FormMode="Validate">
		<table bgcolor="silver"><tr valign="top">
		<TD bgcolor="white"><table width="100%">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cfif PageAction IS "ValidateAdd">
				
			<cfelse>
				<cf_AddToQueryString querystring="#QueryString#" name="lid" value="#lid#">
			</cfif>
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#" omitlist="PageAction">
			<form action="#Location#?#querystring#" method="post" enctype="multipart/form-data">
		</cfoutput>
		<cfinclude template="/common/modules/ContentManager/Locale/form.cfm">
		</table>
		<cfif MyLocale.isCorrect()>
			<cfset MyLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
						
			<cfif Trim(ReturnURL) IS "">
				<cfset Location=GetToken(ATTRIBUTES.ListPage,1,"?")>
				<cfset querystring=GetToken(ATTRIBUTES.ListPage,2,"?")>
				<!---<cf_AddToQueryString querystring="#QueryString#" name="UpperIDList" value="#UpperIDList#">--->
				<cflocation url="#Location#?#querystring#" addtoken="No">
			<cfelse>
				<cflocation url="#ReturnURL#" addtoken="No">
			</cfif>
		<cfelse>
			<cfoutput><input type="hidden" name="PageAction" value="#PageAction#"></cfoutput>
		</cfif>
		<div align="right"><input type="submit" name="ButSubmit" value="Apply"></div>
		</TD></form></TR></table>
	</cfcase>
	<cfcase value="CommitAdd,CommitEdit">
	
	</cfcase>
	<cfcase value="ValidateDelete">
		<cfoutput>
			<cfset Location=GetToken(FormAction,1,"?")>
			<cfset querystring=GetToken(FormAction,2,"?")>
			<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="CommitDelete">
			<cf_AddToQueryString querystring="#QueryString#" name="ReturnURL" value="#ReturnURL#">
			<form action="#Location#?#querystring#" method="post">
		</cfoutput>
		<cfif MyLocale.ValidateDelete()>
			<cfoutput><P>Are you sure you want to delete the Locale "#MyLocale.GetProperty('LocaleName')#" and its associated localized records from both staging and production?</P></cfoutput>
			<input type="submit" value="Delete">
		<cfelse>
			<cfoutput><P>You cannot delete the Locale "#MyLocale.GetProperty('LocaleName')#" since it still contains content.</P></cfoutput>
		</cfif>
		</form>
	</cfcase>
	<cfcase value="CommitDelete">
		<cfif MyLocale.ValidateDelete()>
			<cfset MyLocale.Delete(APPLICATION.TrashPath,SESSION.AdminUserID)>
		</cfif>
		<cfif Trim(ReturnURL) IS "">
			<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
		<cfelse>
			<cflocation url="#ReturnURL#" addtoken="No">
		</cfif>
	</cfcase>
	<cfcase value="View">
		<cfset FormMode="View">
		<table bgcolor="silver"><tr valign="top">
		<TD bgcolor="white"><table width="100%">
		<cfinclude template="/common/modules/ContentManager/Locale/form.cfm">
		</table>
		<cfset Location=GetToken(FormAction,1,"?")>
		<cfset querystring=GetToken(FormAction,2,"?")>
		<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="Edit">
		<cfoutput>
			<p align="right"><form action="#Location#?#querystring#" method="post"><input type="submit" value="Edit"></form>
			<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="SaveToProduction">
			<form action="#Location#?#querystring#" method="post"><input type="submit" value="Save Settings to Production"></form></p>
		</cfoutput>
		</table>
	</cfcase>
	<cfcase value="LocaleList">
		<cflocation url="#ATTRIBUTES.ListPage#" addtoken="No">
	</cfcase>
</cfswitch>

</cfmodule>

