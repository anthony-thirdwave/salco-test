<cfcomponent>
	
	<cffunction name="init" returntype="utils">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="extractByToken" output="true" returntype="string">
		<cfargument name="content" required="yes" type="string">
		<cfargument name="startToken" required="no" type="string" default="[[">
		<cfargument name="endToken" required="no" type="string" default="]]">
		<cfargument name="delimiter" required="no" type="string" default=",">
		<cfargument name="duplicates" required="no" type="boolean" default="false">
		
		<cfscript>
			var position = 1;
			var doneSearching = 0;
			var lExtracted = "";
			var count = 1;
			// Clean up special characters for all tokens
			var specialCharacters = "\,.,[,],^,$,?,|,+,*,(,)";
			var sc = "";
			var sExtracted = "";
			var extracted = "";
			for(sc=1;sc LTE listLen(specialCharacters);sc=sc+1){
				arguments.startToken = replace(arguments.startToken,listGetAt(specialCharacters,sc),"\" & listGetAt(specialCharacters,sc),"all");
				arguments.endToken = replace(arguments.endToken,listGetAt(specialCharacters,sc),"\" & listGetAt(specialCharacters,sc),"all");
			}
			while(NOT doneSearching){
				sExtracted = refind("#arguments.startToken#(\S*)#arguments.endToken#",arguments.content,position,1);
				if (sExtracted.len[1] EQ 0 AND sExtracted.pos[1] EQ 0){
					// No more matches found
					doneSearching = 1;
				}
				else{
					extracted = mid(arguments.content,sExtracted.pos[2],sExtracted.len[2]);
					if(not listFind(lExtracted,extracted,arguments.delimiter) OR arguments.duplicates EQ true){
						lExtracted = listAppend(lExtracted,extracted,arguments.delimiter);
					}
					position = sExtracted.pos[1] + 1;
				}
				count = count + 1;
				if(count GT 30){doneSearching = 1;writeoutput("there is a problem with the loop");}
			}
		</cfscript>
		
		<cfreturn "#lExtracted#">
	</cffunction>
	<cffunction name="ReplaceTextInFile" output="true" returntype="boolean">
		<cfargument name="Token" required="yes" type="string">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="SourceExtension" required="yes" type="string">
		<cfargument name="DestinationExtension" required="yes" type="string">
		<cfargument name="Directory" required="yes" type="string">

		<!--- init variables --->
		<cfset var ThisFileContent = "">
		<cfset var ThisDestinationFile = "">
		<cfset var qFiles = "">
		
		<cfif DirectoryExists(ARGUMENTS.Directory)>
			<cfdirectory action="LIST" directory="#ARGUMENTS.Directory#" name="qFiles" filter="*.csst">
			<cfdump var="#qFiles#">
			<cfoutput query="qFiles">
				<cffile action="READ" file="#ARGUMENTS.Directory#\#Name#" variable="ThisFileContent">
				<cfset ThisFileContent=ReplaceNoCase(ThisFileContent,ARGUMENTS.Token,ARGUMENTS.Value,"All")>
				<cfset ThisDestinationFile=Reverse(ListRest(Reverse("#ARGUMENTS.Directory#\#Name#"),"."))>
				<cfset ThisDestinationFile="#ThisDestinationFile#.#ARGUMENTS.DestinationExtension#">
				<cffile action="WRITE" file="#ThisDestinationFile#" output="#ThisFileContent#" addnewline="Yes">
			</cfoutput>
			<cfreturn True>
		</cfif>
		<cfreturn false>
		
	</cffunction>
	
	
	<!--- this function creates a 33 character unique id
			1. hyphens are removed from the generated UUID to prevent javascript difficulties 
			2. prefixed with "G" so it can be used as a variable name --->
	<cffunction name="createUniqueId" output="true" returntype="string">
		<cfset var newId = "G#replace(createUUID(), '-', '', 'all')#" />
		<cfreturn newId />		
	</cffunction>
	
	
	
	<!--- insert a delimiter after each character in a string  --->
	<cffunction name="explodeString" returntype="string">
		<cfargument name="string" default="">
		<cfargument name="delimiter" default="\">
		
		<cfset var local = structNew() />	
		<cfset local.returnString = "">
		
		<!--- loop through each character in the passed string --->
		<cfloop from="1" to="#len(arguments.string)#" index="local.itr">
			<cfset local.returnString = local.returnString & mid(arguments.string,local.itr,1) & arguments.delimiter />
		</cfloop>

		<!--- return the exploded string --->
		<cfreturn local.returnString />
	</cffunction>
</cfcomponent>