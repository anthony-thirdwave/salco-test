<cfcomponent>
	<cffunction name="ConvertDWFtoPDF" returntype="string" output="false">
		<cfargument name="SourceDWFPath" required="1">
		<cfargument name="TargetDirectory" required="1">

		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		
		<cfset LOCAL.SourceDWFFile=GetFileFromPath(ARGUMENTS.SourceDWFPath)>
		<cfset LOCAL.SourceDWFFileNamePart=ListFirst(LOCAL.SourceDWFFile,".")>
		<cfset LOCAL.TargetPDFFile="#LOCAL.SourceDWFFileNamePart#.pdf">
		<cfset LOCAL.TargetPDFPath="#ExpandPath(ARGUMENTS.TargetDirectory)#\#LOCAL.TargetPDFFile#">
		<cfset LOCAL.TargetPDFURL="#ARGUMENTS.TargetDirectory#/#LOCAL.TargetPDFFile#">
		
		<cfexecute 
		    name="#APPLICATION.RootPath#com\dwg2vec.exe"
		    arguments="-colormode 0 ""#SourceDWFPath#"" ""#LOCAL.TargetPDFPath#"""
		    timeout="30"
			variable="Output">
		</cfexecute>
		
		<cfset LOCAL.ReturnValue="#LOCAL.TargetPDFURL#">
		
		<cfif FileExists(LOCAL.TargetPDFPath)>
			<cfpdf action="deletepages"
				pages="1"
				source="#LOCAL.TargetPDFPath#"
				overwrite="1"
				destination="#LOCAL.TargetPDFPath#">
		<cfelse>
			<cfset LOCAL.ReturnValue="">
		</cfif>
		
		<cfreturn LOCAL.ReturnValue>
	</cffunction>
</cfcomponent>
