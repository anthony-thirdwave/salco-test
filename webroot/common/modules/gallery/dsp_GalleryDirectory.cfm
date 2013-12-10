<cfparam name="ATTRIBUTES.SourceDirectory">
<cfparam name="ATTRIBUTES.FormAction" default="#CGI.REQUEST_URI#?#CGI.Query_String#">

<cfdirectory action="LIST" directory="#ExpandPath(ATTRIBUTES.SourceDirectory)#" name="qDirectory">

<cfquery name="GetLastModified" dbtype="query">
	select max(dateLastModified) as maxDateLastModified from qDirectory
</cfquery>

<cfset maxDateLastModified=getLastModified.maxDateLastModified>

<cfset ExecuteTempFile="#APPLICATION.LocaleID#\+GalleryDirectory_#APPLICATION.LocaleID#_#Hash(ATTRIBUTES.SourceDirectory)#_#DateFormat(getLastModified.maxDateLastModified,'yyyymmdd')##TimeFormat(getLastModified.maxDateLastModified,'HHmmss')#.cfm">


<cfif NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or 1>
	
	<cfset lFieldsTitle="Windows XP Title">
	<cfset lFieldsDescription="Windows XP Comment">
	
	<cfset SearchNum="#qDirectory.RecordCount#">
	
	<cfset FormPath=GetToken(ATTRIBUTES.FormAction,1,"?")>
	<cfset FormQueryString=GetToken(ATTRIBUTES.FormAction,2,"?")>
	
	<cfif NOT IsDefined("StartRow")>
		<cfset StartRow=1>
	</cfif>
	<cfif Val(StartRow) LTE "0">
		<cfset StartRow=1>
	</cfif>
	<cfsaveContent Variable="FileContents">
	
		<cfif qDirectory.RecordCount GT "0">
			<cfmodule template="/common/modules/utils/pagination.cfm"
				StartRow="#StartRow#" SearchNum="#SearchNum#"
				RecordCount="#qDirectory.RecordCount#"
				FieldList="#FormQueryString#"
				Label="Search Results"
				Path="#FormPath#">
				
			<ul>
			<cfoutput query="qDirectory" maxrows="#SearchNUM#" startrow="#StartRow#">
				<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#qDirectory.Name#','.')#",";") GT "0">
					<cfimage name="thisImage" source="#qDirectory.Directory#\#qDirectory.Name#">
					<cfset sImageData=ImageGetEXIFMetadata(thisImage)>
					<cfset thisTitle="">
					<cfset thisDescription="">
					
					<cfloop index="thisField" list="#lFieldsTitle#">
						<cfif thisTitle IS "" and StructKeyExists(sImageData,thisField) and sImageData[thisField] IS NOT "">
							<cfset thisTitle="#sImageData[thisField]#">
						</cfif>
					</cfloop>
					<cfloop index="thisField" list="#lFieldsDescription#">
						<cfif thisDescription IS "" and StructKeyExists(sImageData,thisField) and sImageData[thisField] IS NOT "">
							<cfset thisDescription="#sImageData[thisField]#">
						</cfif>
					</cfloop>
					
					<li><a href="#ATTRIBUTES.SourceDirectory#/#URLEncodedFormat(qDirectory.Name)#" style="background:url('#ATTRIBUTES.SourceDirectory#/#URLEncodedFormat(qDirectory.Name)#')" target="_blank"><!--- <img src="#ATTRIBUTES.SourceDirectory#/#qDirectory.Name#" width="300px"> ---><div class="image-info"><cfif thisTitle IS NOT ""><span>#thisTitle#</span></cfif><cfif thisDescription IS NOT ""><p>#thisDescription#</p></cfif></div></a>
					</li>
				</cfif>
			</cfoutput>
			</ul>
			
			<cfmodule template="/common/modules/utils/pagination.cfm"
				StartRow="#StartRow#" SearchNum="#SearchNum#"
				RecordCount="#qDirectory.RecordCount#"
				FieldList="#FormQueryString#"
				Label="Search Results"
				Path="#FormPath#">
		</cfif>
		
	</cfsaveContent>
	
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>
<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">