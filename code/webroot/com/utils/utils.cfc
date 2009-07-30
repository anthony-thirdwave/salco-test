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
	
	
	
	<!--- scrub out control characters and whitespace for a web friendly filename --->
	<cffunction name="scrubFileName" returntype="string" output="false">
		<cfargument name="fileName" type="string" required="yes">
		
		<cfset var local = structNew() />
		<cfset local.returnValue=lcase(reReplace(arguments.fileName,"[’\!'/:""+=;?&<>|,]","","all"))>
		<cfset local.returnValue=lcase(reReplace(local.returnValue,"[ ]"," ","all"))>
		<cfset local.returnValue=lcase(reReplace(local.returnValue,"[ ]","-","all"))>
		<cfreturn local.returnValue>
	</cffunction>
	
	
	
	
	<cffunction name="RemoveHTML" returntype="string" output="false">
		<cfargument name="String" default="" type="String" required="true">
		<cfreturn REReplace(Trim(ARGUMENTS.String),"<[^>]*>"," ","All")>
	</cffunction>
	
	
	<cffunction name="RemoveLeadingPTag" returntype="string" output="false">
		<cfargument name="String" default="" type="String" required="true">
		<cfif left(ARGUMENTS.String,3) IS "<P>">
			<cfreturn ReplaceNoCase(ARGUMENTS.String,"<P>","","ONE")>
		<cfelse>
			<cfreturn ARGUMENTS.String>
		</cfif>
	</cffunction>
	
	
	<cffunction name="ReplaceMarks" returntype="string" output="false">
		<cfargument name="String" default="" type="String" required="true">
		<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(TM)","&##8482;","all")>
		<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(R)","&##174;","all")>
		<cfreturn ARGUMENTS.String>
	</cffunction>
	
	
	<cffunction name="SimpleEncrypt" returntype="string" output="false">
		<cfargument name="ID" default="" type="Numeric" required="true">
		<cfset ARGUMENTS.ID=(ARGUMENTS.ID*ARGUMENTS.ID)+430213>
		<cfreturn ARGUMENTS.ID>
	</cffunction>
	
	
	<cffunction name="SimpleDecrypt" returntype="string" output="false">
		<cfargument name="ID" default="" type="Numeric" required="true">
		<cfset var ReturnValue = "">
		<cftry>
			<cfset ReturnValue=Sqr(ARGUMENTS.ID-430213)>
			<cfreturn ReturnValue>
			<cfcatch>
				<cfreturn -1>
			</cfcatch>
		</cftry>
	</cffunction>
	
	
	<cffunction name="GetPathFromURL" returntype="string" output="false">
		<cfargument name="String" default="" type="String" required="true">
		<cfset var ReturnString = "">
		<cfif Left(ARGUMENTS.String,1) IS NOT "/">
			<cfreturn "">
		<cfelse>
			<cfset ReturnString="#APPLICATION.WebrootPath##ReplaceNoCase(ARGUMENTS.String,'/','\','all')#">
			<cfset ReturnString=ReplaceNoCase(ReturnString,"\\","\","all")>
			<cfreturn ReturnString>
		</cfif>
	</cffunction>
	
	
	<cffunction name="GetURLFromPath" returntype="string" output="false">
		<cfargument name="String" default="" type="String" required="true">
		<cfset var ReturnString = "">
		<cfif Len(ARGUMENTS.String) LT Len(APPLICATION.WebrootPath)>
			<cfreturn "">
		<cfelseif Left(ARGUMENTS.String,Len(APPLICATION.WebrootPath)) IS NOT APPLICATION.WebrootPath>
			<cfreturn "">
		<cfelse>
			<cfset ReturnString=ReplaceNoCase(ARGUMENTS.String,APPLICATION.WebrootPath,"/","All")>
			<cfset ReturnString=ReplaceNoCase(ReturnString,"\","/","All")>
			<cfset ReturnString=ReplaceNoCase(ReturnString,"//","/","All")>
			<cfreturn ReturnString>
		</cfif>
	</cffunction>
	
	
	<cffunction name="GeneratePageTitleString" returntype="string" output="false">
		<cfargument name="pageTitleList" default="" type="string" required="true">
			<cfset var thisPageTitle = "">
			<cfset var i = "">
			<cfloop from="#ListLen(ARGUMENTS.pageTitleList)#" to="1" step="-1" index="i">
				<cfif ListGetAt(ARGUMENTS.pageTitleList,i) NEQ "System">
					<cfset thisPageTitle = thisPageTitle & ListGetAt(ARGUMENTS.pageTitleList,i) & ": ">
				</cfif>
			</cfloop>
			<cfset thisPageTitle = thisPageTitle & Application.SiteTitle>
			<cfreturn thisPageTitle>
	</cffunction>
	
	
	<cffunction name="StripChars" returntype="string" output="false">
		<cfargument name="strInput" type="string" required="yes">
		<cfset var RetVal=Trim(ARGUMENTS.strInput)>
		<cfset RetVal=ReplaceNoCase(RetVal,chr(150),"-","All")><!--- en dash --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(151),"-","All")><!--- em dash --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(145),"'","All")><!--- open apostrophe --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(146),"'","All")><!--- close apostrophe --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(147),"""","All")><!--- open double quote --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(148),"""","All")><!--- close double quote --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(8211),"-","All")><!--- en dash --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(8212),"-","All")><!--- em dash --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(8216),"'","All")><!--- open apostrophe --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(8217),"'","All")><!--- close apostrophe --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(8220),"""","All")><!--- open double quote --->
		<cfset RetVal=ReplaceNoCase(RetVal,chr(8221),"""","All")><!--- close double quote --->
		<cfset RetVal=REReplace(RetVal,"[^A-Za-z0-9!""##$%&'()*+,-./:;?@[\\\]_`{|}~ \t\r\n\v\f]","","all")>
		<cfreturn Trim(retVal)>
	</cffunction>

	
	
	<cffunction name="ReplaceExtendedCharacters" returntype="string" output="false">
		<cfargument name="string" default="" type="String" required="true">
	
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(150),"&##8211;","All")><!--- en dash --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(151),"&##8212;","All")><!--- em dash --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(145),"&##8216;","All")><!--- open apostrophe --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(146),"&##8217;","All")><!--- close apostrophe --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(147),"&##8220;","All")><!--- open double quote --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(148),"&##8221;","All")><!--- close double quote --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8482),"&##8482;","All")><!--- (TM) --->
	
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8211),"&##8211;","All")><!--- en dash --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8212),"&##8212;","All")><!--- em dash --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8216),"&##8216;","All")><!--- open apostrophe --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8217),"&##8217;","All")><!--- close apostrophe --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8220),"&##8220;","All")><!--- open double quote --->
		<cfset ARGUMENTS.string=ReplaceNoCase(ARGUMENTS.string,chr(8221),"&##8221;","All")><!--- close double quote --->
	
		<cfreturn ARGUMENTS.string>
	</cffunction>
	
	
	<cffunction name="Scrub" returntype="string" output="false">
		<cfargument name="strInput" type="string" required="yes">
		<cfset var ReturnValue=lcase(ReReplace(ARGUMENTS.strInput,"[’\!'/:"".+=;?&<>|,]","","all"))>
		<cfset ReturnValue=lcase(ReReplace(ReturnValue,"[ ]"," ","all"))>
		<cfset ReturnValue=lcase(ReReplace(ReturnValue,"[ ]","-","all"))>
		<cfreturn ReturnValue>
	</cffunction>
	
	
	<cfscript>
	function TitleCase(str) {
		var wordsCapFirst = "";
		var strTemp = "";
		str = lcase(str);
		for (i=1; i LTE ListLen(str," "); i=i+1) {
			strTemp = ListGetAt(str,i," ");
			strTemp = ucase(left(strTemp,1)) & mid(strTemp,2,len(strTemp)-1);
			wordsCapFirst = ListAppend(wordsCapFirst,strTemp," ");
		}
		return wordsCapFirst;
	}
	</cfscript>
	
	
	<cfscript>
	/**
	 * This function takes a date time object and an offset, and outputs a GMT date/time formatted string.
	 * 
	 * @param aDate 	 A date. 
	 * @param offset 	 A valid GMT offset. 
	 * @return Returns a string. 
	 * @author Mark Andrachek (hallow@webmages.com) 
	 * @version 1, March 21, 2002 
	 */
	function GMTDateFormat (adate,offset) {
	     // adate must be a valid date time object.
	     // the offset must be in the format -0000 or +0000.
	     
	     var dvalue = ""; // the final value.
	     
	     if (IsDate(adate)) {
	          
	          dvalue = DateAdd('h',Left(offset,3),DateAdd('s',Left(offset,1) & Right(offset,2),adate));
	          dvalue = Left( DayOfWeekAsString( DayOfWeek( dvalue ) ), 3) & 
	                  ', ' & 
	                  DateFormat(dvalue,'dd mmm yyyy') &
	                  ' ' &
	                  TimeFormat(dvalue,'HH:mm:ss') &
	                  ' GMT';
	          
	          return dvalue;
	     }
	     
	     else { return; }
	}
	</cfscript>

</cfcomponent>