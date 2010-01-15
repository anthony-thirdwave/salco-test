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
			<cfset thisPageTitle = thisPageTitle & Application.CompanyName>
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


		
	
	<!--- returns a spelled out number --->
	<cffunction name="getNumberAsWords">
		<cfargument name="theNum" type="numeric" required="true">
		<cfargument name="getAsOrdinal" type="boolean" default="false">
	
		<cfset var local = structNew() />
		
		<!--- only handles positive numbers under 100,000 and rounds floats --->
		<cfif arguments.theNum gt 99999 or arguments.theNum lt 0>
			<cfreturn arguments.theNum />
		<cfelse>
			<cfset arguments.theNum = round(arguments.theNum) />
		</cfif>
		
		<!--- create some variables which will be used based upon how large the number is --->
		<cfset local.ones = right(arguments.theNum,1) />
		
		<cftry>
			<cfset local.tens = mid(arguments.theNum, len(arguments.theNum) -1, 1) />
			<cfset local.teens = right(arguments.theNum, 2) />
			<cfset local.hundreds = mid(arguments.theNum, len(arguments.theNum) -2, 1) />
			<cfset local.thousands = mid(arguments.theNum, len(arguments.theNum) - 3, 1) />
			<cfset local.tenThousands = mid(arguments.theNum, len(arguments.theNum) - 4, 1) />
			<cfset local.tenThousandTeens = mid(arguments.theNum, len(arguments.theNum) - 4, 2) />
			<cfcatch>
				<!--- do nothing --->
			</cfcatch>
		</cftry>
			
		<!--- dashes for twenty-one through ninety-nine --->
		<cfif not local.ones or (structKeyExists(local, "tens") and not local.tens)>
			<cfset local.tensDash = "" />
		<cfelse>
			<cfset local.tensDash = "-" />
		</cfif>
		
		<!--- only display " hundred " where needed --->
		<cfif structKeyExists(local, "hundreds") and local.hundreds>
			<cfset local.hundredsHolder = " hundred " />
		<cfelse>
			<cfset local.hundredsHolder = "" />
		</cfif>
		
		<!--- only display " thousand " where needed --->
		<cfif structKeyExists(local, "thousands") and local.thousands or structKeyExists(local, "tenThousands") and local.tenThousands>
			<cfset local.thousandsHolder = " thousand " />
		<cfelse>
			<cfset local.thousandsHolder = "" />
		</cfif>
		
		<!--- dashes for twenty-one through ninety-nine thousand --->
		<cfif (structKeyExists(local, "thousands") and not local.thousands) or (structKeyExists(local, "tenThousands") and not local.tenThousands)>
			<cfset local.tenThousandsDash = "" />
		<cfelse>
			<cfset local.tenThousandsDash = "-" />
		</cfif>
		
		<!--- we'll always have a onesString   --->
		<cfif local.ones eq 0 and not structKeyExists(local, "tens") >
			<cfif not arguments.getAsOrdinal>
				<cfset local.onesString = "zero" />
			<cfelse>
				<cfset local.onesString = "zeroth" />
			</cfif>
		<cfelse>
			<!--- this always uses the passed getAsOrdinal value --->
			<cfset local.onesString = ones(local.ones, arguments.getAsOrdinal) />
		</cfif>
		
		<!--- try to format the tens column --->
		<cftry>
			
			<!--- if no ones, then pass the getAsOrdinal boolean --->
			<cfif not len(trim(local.onesString)) or (structKeyExists(local, "tens") and local.tens eq 1)>
				<cfset local.tensOrdinals = arguments.getAsOrdinal />
			<cfelse>
				<cfset local.tensOrdinals = false />
			</cfif>
			
			<!--- decide between tens and teens --->
			<cfif local.tens eq 1>
				<cfset local.tensString = teens(local.teens, local.tensOrdinals) />
			<cfelse>
				<cfset local.tensString = tens(local.tens, local.tensOrdinals) & local.tensDash & local.onesString />
			</cfif>
			
			<cfcatch>
				<!--- return a string version of a number less than 100 --->
				<cfif arguments.theNum lt 10>
					<cfreturn trim(local.onesString) />
				<cfelse><!--- else, there was a problem, return the original value --->
					<cfreturn arguments.theNum />
				</cfif>
			</cfcatch>
		</cftry>
		
		<!--- try to format the hundreds column --->
		<cftry>
			
			<!--- if no tens and getAsOrdinal, display with "th" --->
			<cfif not len(trim(local.tensString)) and arguments.getAsOrdinal and len(trim(local.hundredsHolder))>
				<cfset local.hundredsString = ones(local.hundreds) & " hundredth" />
			<cfelse>
				<cfset local.hundredsString = ones(local.hundreds) & local.hundredsHolder & local.tensString />
			</cfif>
			
			<cfcatch>
				<!--- return a string version of a number less than 100 --->
				<cfif arguments.theNum lt 100>
					<cfreturn trim(local.tensString) />
				<cfelse> <!--- else, there was a problem, return the original value --->
					<cfreturn arguments.theNum />
				</cfif>
			</cfcatch>
		</cftry>
		
		<!--- try to format the thousands column --->
		<cftry>
			
			<!--- if no hundreds and getAsOrdinal, display with "th" --->
			<cfif not len(trim(local.hundredsString)) and arguments.getAsOrdinal>
				<cfset local.thousandsHolder = " thousandth" />
			</cfif>
		
			<cfset local.thousandsString = ones(local.thousands) & local.thousandsHolder & local.hundredsString />
			
			<cfcatch>
				<!--- return a string version of a number less than 1000 --->
				<cfif arguments.theNum lt 1000>
					<cfreturn trim(local.hundredsString) />
				<cfelse> <!--- else, there was a problem, return the original value --->
					<cfreturn arguments.theNum />
				</cfif>
			</cfcatch>
		</cftry>
		
		<!--- try to format the tenThousands column --->
		<cftry>
			
			<cfif local.tenThousands eq 1>
				<cfset local.tenThousandsString = teens(local.tenThousandTeens) & local.thousandsString />
			<cfelse>
				<cfset local.tenThousandsString = tens(local.tenThousands) & local.tenThousandsDash & local.thousandsString />
			</cfif>
		
			<cfcatch>
				<!--- return a string version of a number less than 10000 --->
				<cfif arguments.theNum lt 10000>
					<cfreturn trim(local.thousandsString) />
				<cfelse> <!--- else, there was a problem, return the original value --->
					<cfreturn arguments.theNum />
				</cfif>
			</cfcatch>
		</cftry>
		
		<!--- this is a high as we go --->
		<cfreturn trim(local.tenThousandsString) />
	</cffunction>

	<cffunction name="ones">
		<cfargument name="num" type="numeric">
		<cfargument name="getAsOrdinal" type="boolean" default="false">
		
		<cfset var local = structNew() />
		
		<cfsavecontent variable="local.numAsString">
			<cfif not arguments.getAsOrdinal>
				<cfswitch expression="#arguments.num#">
					<cfcase value="1">one</cfcase>
					<cfcase value="2">two</cfcase>
					<cfcase value="3">three</cfcase>
					<cfcase value="4">four</cfcase>
					<cfcase value="5">five</cfcase>
					<cfcase value="6">six</cfcase>
					<cfcase value="7">seven</cfcase>
					<cfcase value="8">eight</cfcase>
					<cfcase value="9">nine</cfcase>
				</cfswitch>
			<cfelse>
				<cfswitch expression="#arguments.num#">
					<cfcase value="1">first</cfcase>
					<cfcase value="2">second</cfcase>
					<cfcase value="3">third</cfcase>
					<cfcase value="4">fourth</cfcase>
					<cfcase value="5">fifth</cfcase>
					<cfcase value="6">sixth</cfcase>
					<cfcase value="7">seventh</cfcase>
					<cfcase value="8">eighth</cfcase>
					<cfcase value="9">ninth</cfcase>
				</cfswitch>
			</cfif>
		</cfsavecontent>
		
		<cfreturn trim(local.numAsString) />
	</cffunction>
	
	
	<cffunction name="tens">
		<cfargument name="num" type="numeric">
		<cfargument name="getAsOrdinal" type="boolean" default="false">
		
		<cfset var local = structNew() />
		
		<cfsavecontent variable="local.numAsString">
			<cfif not arguments.getAsOrdinal>
				<cfswitch expression="#arguments.num#">
					<cfcase value="1">ten</cfcase>
					<cfcase value="2">twenty</cfcase>
					<cfcase value="3">thirty</cfcase>
					<cfcase value="4">forty</cfcase>
					<cfcase value="5">fifty</cfcase>
					<cfcase value="6">sixty</cfcase>
					<cfcase value="7">seventy</cfcase>
					<cfcase value="8">eighty</cfcase>
					<cfcase value="9">ninety</cfcase>
				</cfswitch>
			<cfelse>
				<cfswitch expression="#arguments.num#">
					<cfcase value="1">tenth</cfcase>
					<cfcase value="2">twentieth</cfcase>
					<cfcase value="3">thirtieth</cfcase>
					<cfcase value="4">fortieth</cfcase>
					<cfcase value="5">fiftieth</cfcase>
					<cfcase value="6">sixtieth</cfcase>
					<cfcase value="7">seventieth</cfcase>
					<cfcase value="8">eightieth</cfcase>
					<cfcase value="9">ninetieth</cfcase>
				</cfswitch>
			</cfif>
		</cfsavecontent>
		
		<cfreturn trim(local.numAsString) />
	</cffunction>
	
	<cffunction name="teens">
		<cfargument name="num" type="numeric">
		<cfargument name="getAsOrdinal" type="boolean" default="false">
		
		<cfset var local = structNew() />
		
		<cfsavecontent variable="local.numAsString">
			<cfif not arguments.getAsOrdinal>
				<cfswitch expression="#arguments.num#">
					<cfcase value="10">ten</cfcase>
					<cfcase value="11">eleven</cfcase>
					<cfcase value="12">twelve</cfcase>
					<cfcase value="13">thirteen</cfcase>
					<cfcase value="14">fourteen</cfcase>
					<cfcase value="15">fifteen</cfcase>
					<cfcase value="16">sixteen</cfcase>
					<cfcase value="17">seventeen</cfcase>
					<cfcase value="18">eighteen</cfcase>
					<cfcase value="19">nineteen</cfcase>
				</cfswitch>
			<cfelse>
				<cfswitch expression="#arguments.num#">
					<cfcase value="10">tenth</cfcase>
					<cfcase value="11">eleventh</cfcase>
					<cfcase value="12">twelveth</cfcase>
					<cfcase value="13">thirteenth</cfcase>
					<cfcase value="14">fourteenth</cfcase>
					<cfcase value="15">fifteenth</cfcase>
					<cfcase value="16">sixteenth</cfcase>
					<cfcase value="17">seventeenth</cfcase>
					<cfcase value="18">eighteenth</cfcase>
					<cfcase value="19">nineteenth</cfcase>
				</cfswitch>
			</cfif>
		</cfsavecontent>
		
		<cfreturn trim(local.numAsString) />
	</cffunction>

	<!--- convert a number to an ordinal --->
	<cffunction name="getNumberAsOrdinal" returntype="string">
		<cfargument name="num" type="numeric">
		
		<cfset var local = structNew() />
		<cfset local.numAsOrdinal = "" />
		
		<!--- get the last two digits --->
		<cfset local.lastTwo = right(arguments.num, 2) />
		
		<!--- determine the suffix --->
		<cfif right(local.lastTwo, 1) eq 1 and local.lastTwo neq 11>
			<cfset local.numAsOrdinal = arguments.num & "st" />
		<cfelseif right(local.lastTwo, 1) eq 2 and local.lastTwo neq 12>
			<cfset local.numAsOrdinal = arguments.num & "nd" />
		<cfelseif right(local.lastTwo, 1) eq 3 and local.lastTwo neq 13>
			<cfset local.numAsOrdinal = arguments.num & "rd" />
		<cfelse>
			<cfset local.numAsOrdinal = arguments.num & "th" />
		</cfif>
		
		<cfreturn trim(local.numAsOrdinal) />
	</cffunction>

</cfcomponent>