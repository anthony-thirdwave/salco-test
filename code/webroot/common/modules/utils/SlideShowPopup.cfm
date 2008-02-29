<cfsetting showdebugoutput="1" >
<cfparam name="Index" default="1">
<cfparam name="ThisImage" default="">
<cfparam name="ThisTitle" default="">
<cfparam name="EditArticleID" default="-1">
<cfparam name="SourceFile" default="">
<cfparam name="lPath" default="">
<cfset sComments=StructNew()>
<cfif IsDefined("URL.sf") AND URL.sf neq ""><!--- If we are passed an article id, then we can pick up the category id from that. --->
	<cftry>
		<cfset SourceFile=URL.sf>
		<cfcatch><cfset SourceFile=""></cfcatch>
	</cftry>
</cfif>
<cfif SourceFile IS NOT "" and FileExists("#APPLICATION.ExecuteTempDir##SourceFile#")>
	<cffile action="READ" file="#APPLICATION.ExecuteTempDir##SourceFile#" variable="wSlideShow">
	<cfif isWDDX(wSlideShow)>
		<cfwddx action="WDDX2CFML" input="#wSlideShow#" output="sSlideShow">
	</cfif>
	<cfset lPath=sSlideShow.lImages>
	<cfset ThisTitle=sSlideShow.Title>
	<cfset sComments=sSlideShow.sComments>
	<cfset LinkString="sf=#URLEncodedFormat(SourceFile)#">
</cfif>
<cfif Trim(lPath) IS NOT "">
	<cfset ThisImage=ListGetAt(lPath,Index)>
<cfelse>
	<cfset ThisImage="">
</cfif>
<cfif ListLen(lPath) GT "1">
	<cfif Index IS "1">
		<cfset PrevIndex=ListLen(lPath)>
		<cfset NextIndex="2">
	<cfelseif Index IS ListLen(lPath)>
		<cfset PrevIndex=DecrementValue(ListLen(lPath))>
		<cfset NextIndex="1">
	<cfelse>
		<cfset PrevIndex=DecrementValue(Index)>
		<cfset NextIndex=IncrementValue(Index)>
	</cfif>
<cfelse>
	<cfset PrevIndex="-1">
	<cfset NextIndex="-1">
</cfif>

<html>
<head>
<cfoutput><title>#ThisTitle#</title></cfoutput>
<link rel="stylesheet" type="text/css" href="/common/styles/legacy.css">
</head>

<body leftmargin="5" topmargin="5">
<table cellpadding="0" cellspacing="0">
<tr><td><cfoutput><span class="bhead">#ThisTitle#</span></cfoutput></td></tr>
<tr>
  <td class="child">
  <cfif IsDefined("sSlideShow") AND ListLen(sSlideShow.lImages) GT "1">
  	<cfoutput><a href="SlideShowPopup.cfm?#LinkString#&Index=#PrevIndex#">&lt;</a>
	  <cfloop index="i" from="1" to="#ListLen(sSlideShow.lImages)#" step="1">
	  	<cfif i IS Index>
			#i#
		<cfelse>
			<a href="SlideShowPopup.cfm?#LinkString#&Index=#i#">#i#</a>
		</cfif>
	  </cfloop>
	  <a href="SlideShowPopup.cfm?#LinkString#&Index=#NextIndex#">&gt;</a> </cfoutput>
  </cfif>
    </td>
  </tr>
  <tr>
    <cfoutput><td><img src="#ThisImage#" name="Image1" vspace="0" hspace="0"></td></cfoutput>
  </tr>
    <tr>
    <td><img src="/common/images/spacer.gif" height="4"><table width="370" cellspacing="0" cellpadding="0" border="0">
        <tr>
          <td class="caption3"><cfif StructKeyExists(sComments,"#ThisImage#")><cfoutput>#sComments["#ThisImage#"]#</cfoutput></cfif></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td class="foot"> &copy; <cfoutput>#APPLICATION.CompanyName# #Year(Now())#</cfoutput> </td>
  </tr>
</table>
</body>
</html>
