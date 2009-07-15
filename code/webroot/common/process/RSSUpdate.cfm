<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<!--- get the content of rss type --->
<cfquery name="GetAllContent" datasource="#APPLICATION.DSN#">
	select * from qry_GetContentLocale where ContentTypeID=241 order by ContentID
</cfquery>

<cfoutput query="GetAllContent">
	<cfif isWDDX(GetAllContent.ContentBody)>
		
		<cfwddx action="WDDX2CFML" input="#GetAllContent.ContentBody#" output="sContentBody" />
		
		<!--- check for the linkUrl param --->
		<cfif StructKeyExists(sContentBody,"LinkURL") AND len(sContentBody.LinkUrl)>
			
			<!--- get the path where the file will reside --->
			<cfinvoke component="com.ContentManager.ContentHandler"
				method="GetResourceFilePath"
				returnVariable="ReturnValue"
				ContentID="#GetAllContent.ContentID#"
				ResourceType="Generated"
				WebrootPath="#APPLICATION.WebrootPath#">
			
			<!--- get the content of the link --->	
			<cfhttp url="#sContentBody.LinkURL#" method="get">
			
			<!--- define the path and file name --->
			<cfset FileToWrite = ReturnValue & "rss_#GetAllContent.ContentLocaleId#.xml">
			
			<!--- write the file --->
			<cffile action="WRITE" file="#FileToWrite#" output="#request.stripChars(CFHTTP.FileContent)#" addnewline="Yes">
		</cfif>
	</cfif>
</cfoutput>


</body>
</html>
