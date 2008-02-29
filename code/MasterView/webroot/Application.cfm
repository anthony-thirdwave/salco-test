<cfsilent>

<!---
	3WCMSv1 :: Application.cfm
	Coded by Thomas Sychay
	06/13/02 PWK, New form of error page installed
	06/13/02 PWK, Application and Session scopes now fully locked
	06/13/02 PWK, All white space suppressed
--->

<cfinclude template="/common/modules/Application/ApplicationSetup.cfm">

<cfset ThisHTTPHost="#CGI.HTTP_HOST#">


<cfswitch expression="#ListFirst(ReplaceNoCase(ThisHTTPHost,'www.','','one'),'.')#">
	<cfdefaultcase>
		<cfset ThisApplicationName="www.#ThisUniqueName#.com">
	</cfdefaultcase>
</cfswitch>

<cfapplication name="#ThisApplicationName#" 
	clientmanagement="Yes"
	sessionmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout="#CreateTimeSpan(0,1,0,0)#"
	applicationtimeout="#CreateTimeSpan(1,0,0,0)#"
	clientstorage="#ThisClientStorage#">
<cfset APPLICATION.LocaleID="1">
<cfset APPLICATION.LanguageID="100">
<cfinclude template="/common/modules/Application/ApplicationSettings.cfm">

<!---
<!--- Clean up URL variables and prevent script attacks --->
<cfloop index="ThisVar" list="#StructKeyList(URL)#">
	<cfif Right(ThisVar,2) IS NOT "ID">
		<cfset SetVariable("URL.#ThisVar#",HTMLEditFormat(StructFind(URL,ThisVar)))>
	</cfif>
</cfloop>--->


</cfsilent>