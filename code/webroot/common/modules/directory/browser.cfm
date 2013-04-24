<cfparam name="ATTRIBUTES.PageAction" default="#CGI.Path_Info#?#CGI.Query_String#">

<cfif APPLICATION.Production>
	<cfparam name="ATTRIBUTES.DirectoryHome" default="D:\websites.staging\salco\TrainingVideos\">
	<cfparam name="ATTRIBUTES.DirectoryStart" default="#ATTRIBUTES.DirectoryHome#">
	<cfset VideoHost="128.1.1.103">
<cfelseif APPLICATION.Staging>
	<cfparam name="ATTRIBUTES.DirectoryHome" default="D:\websites.staging\salco\TrainingVideos\">
	<cfparam name="ATTRIBUTES.DirectoryStart" default="#ATTRIBUTES.DirectoryHome#">
	<cfset VideoHost="128.1.1.103">
<cfelse>
	<cfparam name="ATTRIBUTES.DirectoryHome" default="d:\websites\salco\TrainingVideos">
	<cfparam name="ATTRIBUTES.DirectoryStart" default="#ATTRIBUTES.DirectoryHome#">
	<cfset VideoHost="Z:\websites.dev09\Salco\TrainingVideos">
</cfif>

<cfparam name="ATTRIBUTES.FileFilter" default="html">
<cfparam name="dir" default="#ATTRIBUTES.DirectoryStart#">
<cfparam name="h" default="">

<cfset PagePath=ListFirst(ATTRIBUTES.PageAction,"?")>
<cfset PageQueryString="">
<cfif ListLen(ATTRIBUTES.PageAction,"?") IS "2">
	<cfset PageQueryString=ListLast(ATTRIBUTES.PageAction,"?")>
</cfif>

<cfif Isdefined("url.d") and Trim(URL.d) is not "" and hash(URL.d) IS h>
	<cfset Dir=APPLICATION.utilsObj.GetPathFromURL(URL.d,ATTRIBUTES.DirectoryHome)>
</cfif>

<cfif IsDebugMode()>
	<cfoutput><p><strong>dir: #Dir#</strong></p></cfoutput>
</cfif>

<cfif Left(dir,Len(ATTRIBUTES.DirectoryHome)) is not ATTRIBUTES.DirectoryHome>
	<!--- Current directory is not in home --->
<cfelse>
	<cfif DirectoryExists(dir)>
		<cfsavecontent variable="Contents1">
			<cfset qDir1=GetDir(dir)>
			<ul>
			<cfoutput query="qDir1">
				<cfif left(Name,1) is not "_">
					<cfif Type IS "dir">
						<cfset qDir2=GetDir("#dir#\#qDir1.Name#")>
						<cfquery name="TestIfVideo" dbtype="query">
							select * from qDir2 where name='OpenMe.html' and type='File'
						</cfquery>
						<cfif TestIfVideo.RecordCount GT "0">
							<!--- This is a video page --->
							<li><a href="http://#VideoHost##APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome)#/OpenMe.html" target="_blank">#qDir1.Name#</a></li>
						<cfelse>
							<cf_AddToQueryString queryString="#PageQueryString#" name="d" value="#APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome)#">
							<cf_AddToQueryString queryString="#QueryString#" name="h" value="#hash(APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome))#">
							<li><a href="#PagePath#?#Querystring#">#qDir1.Name#</a></li>
						</cfif>
					</cfif>
				</cfif>
			</cfoutput>
			</ul>
		</cfsavecontent>
		<cfoutput>#Contents1#</cfoutput>
	</cfif>
</cfif>


<cffunction name="GetDir" returntype="query" output="false">
	<cfargument name="directory" default="" type="String" required="true">

	<cfset QueryName="#ReplaceNoCase(ARGUMENTS.directory,'\','_','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,' ','_','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,'-','_','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,',','_','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,':','_','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,'.','_','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,'(','','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,')','','all')#">
	<cfset QueryName="#ReplaceNoCase(QueryName,'&','','all')#">
	<cfset QueryName="APPLICATION.GetDirv1_#QueryName#_#DateFormat(Now(),'yyyymmdd')#">

	<cfif Not IsDefined(QueryName) or not APPLICATION.Production>
		<cfdirectory action="LIST" directory="#ARGUMENTS.directory#" name="#QueryName#" sort="type,name">
		<cfset UseCache="0">
	<cfelse>
		<cfset UseCache="1">
	</cfif>
	
	<cfreturn Evaluate(QueryName)>
	
</cffunction>