<cffunction name="RemoveHTML" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfreturn REReplace(Trim(ARGUMENTS.String),"<[^>]*>"," ","All")>
</cffunction>
<cfset REQUEST.RemoveHTML=RemoveHTML>

<cffunction name="AddBreaks" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfreturn ReplaceNoCase(ARGUMENTS.String,"#Chr(10)#", "<BR>","ALL")>
</cffunction>
<cfset REQUEST.AddBreaks=AddBreaks>

<cffunction name="RemoveLeadingPTag" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfif left(ARGUMENTS.String,3) IS "<P>">
		<cfreturn ReplaceNoCase(ARGUMENTS.String,"<P>","","ONE")>
	<cfelse>
		<cfreturn ARGUMENTS.String>
	</cfif>
</cffunction>
<cfset REQUEST.RemoveLeadingPTag=RemoveLeadingPTag>

<cffunction name="RemoveTrailingPTag" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfif Len(ARGUMENTS.String) GT "4" AND right(ARGUMENTS.String,4) IS "</P>">
		<cfreturn Left(ARGUMENTS.String,len(ARGUMENTS.String)-4)>
	<cfelse>
		<cfreturn ARGUMENTS.String>
	</cfif>
</cffunction>
<cfset REQUEST.RemoveTrailingPTag=RemoveTrailingPTag>

<cffunction name="OutputText" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<p>","PPPPOPENPPPP","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</p>","PPPPCLOSEPPPP","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<BR>","BRBRBRBRBR","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<B>","BBBBOPENBBBB","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</B>","BBBBCLOSEBBBB","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<strong>","STRONGOPENSTRONG","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</strong>","STRONGCLOSESTRONG","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<i>","IIIIOPENIIII","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</i>","IIIICLOSEIIII","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<u>","UUUUOPENUUUU","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</u>","UUUUCLOSEUUUU","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<h1>","H1H1OPENH1H1","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</h1>","H1H1CLOSEH1H1","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<h2>","H2H2OPENH2H2","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</h2>","H2H2CLOSEH2H2","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<h3>","H3H3OPENH3H3","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</h3>","H3H3CLOSEH3H3","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<h4>","H4H4OPENH4H4","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</h4>","H4H4CLOSEH4H4","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<h5>","H5H5OPENH5H5","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</h5>","H5H5CLOSEH5H5","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<h6>","H6H6OPENH6H6","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</h6>","H6H6CLOSEH6H6","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<ol>","OLOLOPENOLOL","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</ol>","OLOLCLOSEOLOL","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<ul>","ULULOPENULUL","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</ul>","ULULCLOSEULUL","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<li>","LILIOPENLILI","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</li>","LILICLOSELILI","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<a","AAAAOPENAAAA","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</A>","AAAACLOSEAAAA","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"<span","SPANOPENSPAN","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"</span>","SPANCLOSESPAN","all")>
	<cfset ARGUMENTS.String=REQUEST.RemoveHTML(ARGUMENTS.String)>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"PPPPOPENPPPP","<p>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"PPPPCLOSEPPPP","</p>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"BRBRBRBRBR","<BR>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"BBBBOPENBBBB","<B>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"BBBBCLOSEBBBB","</B>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"STRONGOPENSTRONG","<strong>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"STRONGCLOSESTRONG","</strong>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"IIIIOPENIIII","<i>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"IIIICLOSEIIII","</i>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"UUUUOPENUUUU","<u>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"UUUUCLOSEUUUU","</u>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H1H1OPENH1H1","<h1>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H1H1CLOSEH1H1","</h1>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H2H2OPENH2H2","<h2>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H2H2CLOSEH2H2","</h2>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H3H3OPENH3H3","<h3>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H3H3CLOSEH3H3","</h3>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H3H3OPENH3H3","<h3>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H3H3CLOSEH3H3","</h3>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H4H4OPENH4H4","<h4>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H4H4CLOSEH4H4","</h4>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H5H5OPENH5H5","<h5>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H5H5CLOSEH5H5","</h5>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H6H6OPENH6H6","<h6>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"H6H6CLOSEH6H6","</h6>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"OLOLOPENOLOL","<ol>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"OLOLCLOSEOLOL","</ol>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"ULULOPENULUL","<ul>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"ULULCLOSEULUL","</ul>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"LILIOPENLILI","<li>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"LILICLOSELILI","</li>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"AAAAOPENAAAA","<a","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"AAAACLOSEAAAA","</A>","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"SPANOPENSPAN","<span","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"SPANCLOSESPAN","</span>","all")>
	<cfreturn ARGUMENTS.String>
</cffunction>
<cfset REQUEST.OutputText=OutputText>

<cffunction name="ParseLinks" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfmodule template="/common/modules/utils/hyperlinkURLs.cfm" stringToMarkup="#ARGUMENTS.String#"
		hrefTarget="_blank">
	<cfreturn hyperlinkedString>
</cffunction>
<cfset REQUEST.ParseLinks=ParseLinks>

<cffunction name="ReplaceMarks" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(TM)","&##8482;","all")>
	<cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(R)","&##174;","all")>
	<!--- <cfset ARGUMENTS.String=ReplaceNoCase(ARGUMENTS.String,"(C)","&##169;","all")> --->
	<cfreturn ARGUMENTS.String>
</cffunction>
<cfset REQUEST.ReplaceMarks=ReplaceMarks>

<cffunction name="SimpleEncrypt" returntype="string" output="false">
	<cfargument name="ID" default="" type="Numeric" required="true">
	<cfset ARGUMENTS.ID=(ARGUMENTS.ID*ARGUMENTS.ID)+430213>
	<cfreturn ARGUMENTS.ID>
</cffunction>
<cfset REQUEST.SimpleEncrypt=SimpleEncrypt>

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
<cfset REQUEST.SimpleDecrypt=SimpleDecrypt>

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
<cfset REQUEST.GetPathFromURL=GetPathFromURL>

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
<cfset REQUEST.GetURLFromPath=GetURLFromPath>

<cffunction name="formatExternalURL" returntype="string" output="false">
	<cfargument name="String" default="" type="String" required="true">
	<cfset var thisString = arguments.String>
	<cfif left(thisString,4) EQ "http" OR left(thisString,1) EQ "/">
		<cfreturn thisString>
	<cfelse>
		<cfreturn "http://" & thisString>
	</cfif>
</cffunction>
<cfset REQUEST.formatExternalURL=formatExternalURL>

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
<cfset REQUEST.GeneratePageTitleString=GeneratePageTitleString>

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
<cfset REQUEST.StripChars=StripChars>


<cffunction name="Scrub" returntype="string" output="false">
	<cfargument name="strInput" type="string" required="yes">
	<cfset var ReturnValue=lcase(ReReplace(ARGUMENTS.strInput,"[’\!'/:"".+=;?&<>|,]","","all"))>
	<cfset ReturnValue=lcase(ReReplace(ReturnValue,"[ ]"," ","all"))>
	<cfset ReturnValue=lcase(ReReplace(ReturnValue,"[ ]","-","all"))>
	<cfreturn ReturnValue>
</cffunction>
<cfset REQUEST.Scrub=Scrub>

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
<cfset REQUEST.TitleCase=TitleCase>

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
<cfset REQUEST.GMTDateFormat=GMTDateFormat>

