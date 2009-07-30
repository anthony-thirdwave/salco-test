<!---
<cffunction name="RemoveHTML" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfreturn REReplace(Trim(ARGUMENTS.String),"<[^>]*>"," ","All")>
</cffunction>
<cfset request.RemoveHTML=RemoveHTML>

<cffunction name="RemoveLeadingPTag" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfif left(ARGUMENTS.String,3) IS "<P>">
		<cfreturn ReplaceNoCase(ARGUMENTS.String,"<P>","","ONE")>
	<cfelse>
		<cfreturn ARGUMENTS.String>
	</cfif>
</cffunction>
<cfset request.RemoveLeadingPTag=RemoveLeadingPTag>

<cffunction name="ReplaceMarks" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(TM)","&##8482;","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(R)","&##174;","all")>
	<!--- <cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(C)","&##169;","all")> --->
	<cfreturn ARGUMENTS.String>
</cffunction>
<cfset request.ReplaceMarks=ReplaceMarks>

<cffunction name="SimpleEncrypt" returntype="string" output="false">
	<cfargument name="ID" default="" type="Numeric" required="true">
	<cfset ARGUMENTS.ID=(ARGUMENTS.ID*ARGUMENTS.ID)+430213>
	<cfreturn ARGUMENTS.ID>
</cffunction>
<cfset request.SimpleEncrypt=SimpleEncrypt>

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
<cfset request.SimpleDecrypt=SimpleDecrypt>

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
<cfset request.GetPathFromURL=GetPathFromURL>

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
<cfset request.GetURLFromPath=GetURLFromPath>

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
<cfset request.generatePageTitleString=GeneratePageTitleString>

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
	<!--- <cfset RetVal=REReplace(RetVal,"[^[A-Za-z0-9!""##$%&'()*+,-./:;?@[\\\]_`{|}~]]","","all")> --->
	<!--- <cfreturn REReplace(Trim(ARGUMENTS.String),"<[^>]*>"," ","All")> --->
	<cfset RetVal=REReplace(RetVal,"[^A-Za-z0-9!""##$%&'()*+,-./:;?@[\\\]_`{|}~ \t\r\n\v\f]","","all")>
	<cfreturn Trim(retVal)>
</cffunction>
<cfset request.StripChars=StripChars>


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
<cfset request.ReplaceExtendedCharacters=ReplaceExtendedCharacters>


<cffunction name="Scrub" returntype="string" output="false">
	<cfargument name="strInput" type="string" required="yes">
	<cfset var ReturnValue=lcase(ReReplace(ARGUMENTS.strInput,"[’\!'/:"".+=;?&<>|,]","","all"))>
	<cfset ReturnValue=lcase(ReReplace(ReturnValue,"[ ]"," ","all"))>
	<cfset ReturnValue=lcase(ReReplace(ReturnValue,"[ ]","-","all"))>
	<cfreturn ReturnValue>
</cffunction>
<cfset request.Scrub=Scrub>

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
<cfset request.titleCase=TitleCase>

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
<cfset request.GMTDateFormat=GMTDateFormat>
--->