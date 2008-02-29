<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfquery name="GetAllContent">
	select * from qry_GetContentLocale where ContentTypeID=241 order by ContentID
</cfquery>

<cfoutput query="GetAllContent">
	<cfif isWDDX(ContentBody)>
		<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sContentBody">
			<cfif StructKeyExists(sContentBody,"LinkURL") AND Trim(StructFind(sContentBody,"LinkURL")) is not "">
				<cfinvoke component="/com/ContentManager/ContentHandler"
					method="GetResourceFilePath"
					returnVariable="ReturnValue"
					ContentID="ContentID"
					ResourceType="Generated"
					WebrootPath="#APPLICATION.WebrootPath#">
				<cfhttp url="#LinkURL#" method="get">
				<cfset FileToWrite="#this.GetResourceFilePath('Generated',ARGUMENTS.WebrootPath)#rss_#ContentLocale#.xml">
				<cffile action="WRITE" file="#FileToWrite#" output="#CFHTTP.FileContent#" addnewline="Yes">
			</cfif>
		</cfwddx>
	</cfif>
</cfoutput>


</body>
</html>
