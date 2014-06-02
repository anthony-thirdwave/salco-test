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
	<cfset VideoHost="intranet.salco.dev09.thirdwavellc.com/TrainingVideos">
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

<!--- <cfif IsDebugMode()>
	<cfoutput><p><strong>dir: #Dir#</strong></p></cfoutput>
</cfif> --->

<cfif Left(dir,Len(ATTRIBUTES.DirectoryHome)) is not ATTRIBUTES.DirectoryHome>
	<!--- Current directory is not in home --->
<cfelse>
	<cfif DirectoryExists(dir)>
		<cfset qDir1=GetDir(dir)>
		
		<cfset qDirPrime=QueryNew("#qDir1.ColumnList#,ListingType,Thumbnail,LinkURL")>
		<cfoutput query="qDir1">
			<cfif left(Name,1) is not "_">
				<cfset QueryAddRow(qDirPrime)>
		
				<cfloop index="ThisCol" list="#qDir1.ColumnList#">
					<cfset QuerySetCell(qDirPrime,ThisCol,qDir1[ThisCol][CurrentRow])>
				</cfloop>
				
				<cfif Type IS "dir">
					<cfset ThisThumbnail=GetThumbnail("#dir#\#qDir1.Name#",ATTRIBUTES.DirectoryHome)>
					<cfif ThisThumbnail IS NOT "">
						<cfset QuerySetCell(qDirPrime,"Thumbnail","http://#VideoHost##APPLICATION.utilsObj.GetURLFromPath('#ThisThumbnail#',ATTRIBUTES.DirectoryHome)#")>
						<cfset QuerySetCell(qDirPrime,"ListingType","A")>
					<cfelse>
						<cfset QuerySetCell(qDirPrime,"Thumbnail","")>
						<cfset QuerySetCell(qDirPrime,"ListingType","B")>
					</cfif>
					<cfset qDir2=GetDir("#dir#\#qDir1.Name#")>
					<cfquery name="TestIfVideo" dbtype="query">
						select * from qDir2 where name='OpenMe.html' and type='File'
					</cfquery>
					<cfif TestIfVideo.RecordCount GT "0">
						<cfset QuerySetCell(qDirPrime,"LinkURL","http://#VideoHost##APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome)#/OpenMe.html")>
					<cfelse>
						<cf_AddToQueryString queryString="#PageQueryString#" name="d" value="#APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome)#">
						<cf_AddToQueryString queryString="#QueryString#" name="h" value="#hash(APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome))#">
						<cfset QuerySetCell(qDirPrime,"LinkURL","#PagePath#?#Querystring#")>
					</cfif>
				<cfelse>
					<cfset QuerySetCell(qDirPrime,"ListingType","B")>
					<cfset QuerySetCell(qDirPrime,"Thumbnail","")>
					<cfset QuerySetCell(qDirPrime,"LinkURL","http://#VideoHost##APPLICATION.utilsObj.GetURLFromPath('#dir#\#qDir1.Name#',ATTRIBUTES.DirectoryHome)#")>
				</cfif>
			</cfif>
		</cfoutput>
		
		<cfquery name="qDir2" dbtype="query">
			select * from qDirPrime 
			where ListingType='A'
			order by ListingType,Type,Name
		</cfquery>
		
		<cfsavecontent variable="Contents1">
			<div>
			<ul class="trainingLinks">
			<cfoutput query="qDir2">
				<li>
				<a href="#qDir2.linkURL#"<cfif Left(qDir2.linkURL,4) IS "http"> target="_blank"</cfif>>
				<cfif qDir2.Thumbnail IS NOT "">
					<img src="#qDir2.Thumbnail#">
				</cfif>
				<span>#qDir2.Name#</span></a></li>
			</cfoutput>
			</ul>
			</div>
		</cfsavecontent>
		<cfoutput>#Contents1#</cfoutput>
		
		<cfquery name="qDir3" dbtype="query">
			select * from qDirPrime
			where ListingType='B'
			order by ListingType,Type,Name
		</cfquery>
		
		<cfsavecontent variable="Contents1">
			<div class="listing">
			<ul class="trainingLinks">
			<cfoutput query="qDir3">
				<cfif Right(qDir3.linkURL,Len("OpenMe.html")) IS "OpenMe.html">
					<cfset ThisLIClass="listingVideo">
				<cfelseif qDir3.type is "dir">
					<cfset ThisLIClass="listingDir">
				<cfelse>
					<cfset ThisLIClass="listingFile">
				</cfif>
				<li class="#ThisLIClass#">
				<a href="#qDir3.linkURL#"<cfif Left(qDir3.linkURL,4) IS "http"> target="_blank"</cfif>>
				<cfif qDir3.Thumbnail IS NOT "">
					<img src="#qDir3.Thumbnail#">
				</cfif>
				<span>#qDir3.Name#</span></a></li>
			</cfoutput>
			</ul>
			</div>
		</cfsavecontent>
		<cfoutput>#Contents1#</cfoutput>
	</cfif>
</cfif>

<cffunction name="GetThumbnail" returntype="string" output="false">
	<cfargument name="directory" default="" type="String" required="true">
	<cfargument name="directoryHome" default="" type="String" required="true">
	
	<cfset LOCAL=StructNew()>
	
	<cfset LOCAL.ReturnValue="">
	
	<cfloop index="LOCAL.ThisTarget" list="thumbnail.png,thumbnail.gif,thumbnail.jpg">
		<cfif FileExists("#ARGUMENTS.directory#\#LOCAL.ThisTarget#")>
			<cfset LOCAL.ReturnValue="#ARGUMENTS.directory#\#LOCAL.ThisTarget#">
			<cfreturn LOCAL.ReturnValue>
		</cfif>
	</cfloop>
	
	<cfreturn LOCAL.ReturnValue>
</cffunction>

<cffunction name="GetDir" returntype="query" output="false">
	<cfargument name="directory" default="" type="String" required="true">

	<cfset LOCAL=StructNew()>
	
	<cfset LOCAL.QueryName="#ReplaceNoCase(ARGUMENTS.directory,'\','_','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,' ','_','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,'-','_','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,',','_','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,':','_','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,'.','_','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,'(','','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,')','','all')#">
	<cfset LOCAL.QueryName="#ReplaceNoCase(LOCAL.QueryName,'&','','all')#">
	<cfset LOCAL.QueryName="APPLICATION.GetDirv1_#LOCAL.QueryName#_#DateFormat(Now(),'yyyymmdd')#">

	<cfif Not IsDefined(LOCAL.QueryName) or not APPLICATION.Production>
		<cfdirectory action="LIST" directory="#ARGUMENTS.directory#" name="#LOCAL.QueryName#" sort="type,name">
		<cfset LOCAL.UseCache="0">
	<cfelse>
		<cfset LOCAL.UseCache="1">
	</cfif>
	
	<cfreturn Evaluate(LOCAL.QueryName)>
	
</cffunction>