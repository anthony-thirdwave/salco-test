<cfparam name="ATTRIBUTES.RecordCount" default="0">
<cfparam name="ATTRIBUTES.SearchNum" default="0">
<cfparam name="ATTRIBUTES.StartRow" default="0">
<cfparam name="ATTRIBUTES.FieldList" default=""><!--- Valid URLEncodedFormat String --->
<cfparam name="ATTRIBUTES.FontColor" default="black">
<cfset StartRow=Val(ATTRIBUTES.StartRow)>
<cfset SearchNum=Val(ATTRIBUTES.SearchNum)>
<cfset FieldList=ATTRIBUTES.FieldList>

<cfoutput>
	<cfif ATTRIBUTES.RecordCount GT ATTRIBUTES.SearchNum>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr valign="top">
		<td width="50%">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td nowrap>
				
		<CFIF ATTRIBUTES.StartRow GT ATTRIBUTES.SearchNum>
			<cfset NewStartRow=ATTRIBUTES.StartRow-ATTRIBUTES.SearchNum>
			<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
			<A HREF="#CGI.REQUEST_URI#?#querystring#" class="capsBlackLink">&laquo; PREVIOUS</a>
		<cfelse>
			<span class="capsBlackLink">&laquo; PREVIOUS</span>
		</CFIF></TD>
		<td>&nbsp;&nbsp;&nbsp;</td>
				<td>
				<table border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
		<cfset outputstr="">
		<cfloop index="i" from ="1" to="#Ceiling(ATTRIBUTES.RecordCount/ATTRIBUTES.SearchNum)#" step="1">
			<cfif "#Evaluate(ATTRIBUTES.StartRow)#" IS (SearchNum*(i-1))+1>
				<cfset outputstr="#outputstr##i#">
			<cfelse>
				<cfset NewStartRow=(SearchNum*(i-1))+1>
				<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
				<cfset outputstr="#outputstr#<a href=""#CGI.REQUEST_URI#?#querystring#"">#i#</a>">
			</cfif>
			<cfset outputstr="#outputstr# ">
		</cfloop>
		#outputstr#</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="50%" align="right" class="capsBlackLink" nowrap>
		<CFIF ATTRIBUTES.StartRow LT (ATTRIBUTES.RecordCount - (ATTRIBUTES.SearchNum-1))>
			<cfset NewStartRow=ATTRIBUTES.StartRow+ATTRIBUTES.SearchNum>
			<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
			<a href="#CGI.REQUEST_URI#?#querystring#" class="capsBlackLink">NEXT &raquo;</a>
		<cfelse>
			<span class="capsBlackLink">NEXT &raquo;</span>
		</CFIF></td></tr></table>
	</cfif>			
</cfoutput>