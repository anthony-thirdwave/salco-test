<cfsilent>
<cfparam name="ATTRIBUTES.RecordCount" default="0">
<cfparam name="ATTRIBUTES.SearchNum" default="0">
<cfparam name="ATTRIBUTES.StartRow" default="0">
<cfparam name="ATTRIBUTES.FieldList" default=""><!--- Valid URLEncodedFormat String --->
<cfparam name="ATTRIBUTES.FontColor" default="black">
<cfset StartRow=ATTRIBUTES.StartRow>
<cfset SearchNum=ATTRIBUTES.SearchNum>
<cfset FieldList=ATTRIBUTES.FieldList>
</cfsilent>
<cfoutput>
	<cfif ATTRIBUTES.RecordCount GT ATTRIBUTES.SearchNum>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr valign="top">
		<td width="50%">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td nowrap>
				
		<CFIF ATTRIBUTES.StartRow GT ATTRIBUTES.SearchNum>
			<cfset NewStartRow=StartRow-(SearchNum*2)>
			<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
			<cf_AddToQueryString querystring="#querystring#" name="SearchNum" value="#SearchNum#">
			<A HREF="#CGI.REQUEST_URI#?#querystring#" class="capsBlackLink">&laquo;PREVIOUS RESULTS</a>
		<cfelse>
			<img src="/common/images/spacer.gif" width="25" height="9" border="0"><span class="capsBlackLink">PREVIOUS RESULTS</span>
		</CFIF></TD>
		<td>&nbsp;&nbsp;&nbsp;</td>
				<td>
				<table border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
		<cfsilent>
		<cfset outputstr="<td></td>">
		<cfloop index="i" from ="1" to="#Ceiling(ATTRIBUTES.RecordCount/ATTRIBUTES.SearchNum)#" step="1">
			<cfif "#Evaluate(ATTRIBUTES.StartRow)#" IS "#Evaluate((1-ATTRIBUTES.SearchNum)+(ATTRIBUTES.SearchNum*i))#">
				<cfset outputstr="#outputstr#<TD>[#i#]</TD>">
			<cfelse>
				<cfset NewStartRow=(1-(2*SearchNum))+(SearchNum*i)>
				<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
				<cf_AddToQueryString querystring="#querystring#" name="SearchNum" value="#SearchNum#">
				<cfset outputstr="#outputstr#<td><a href=""#CGI.REQUEST_URI#?#querystring#"" class=""count"">#i#</a></td>">
			</cfif>
			<cfset outputstr="#outputstr#<td>|</td>">
		</cfloop>
		</cfsilent>
		#outputstr#</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
		<td width="50%" align="right" class="capsBlackLink" nowrap>
		<CFIF ATTRIBUTES.StartRow LT (ATTRIBUTES.RecordCount - (ATTRIBUTES.SearchNum-1))>
			<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
			<cf_AddToQueryString querystring="#querystring#" name="SearchNum" value="#SearchNum#">
			<a href="#CGI.REQUEST_URI#?#querystring#" class="capsBlackLink">NEXT RESULTS &raquo;</a>
		<cfelse>
			<span class="capsBlackLink">NEXT RESULTS</span><img src="/common/images/spacer.gif" width="26" height="9" border="0">
		</CFIF></td></tr></table>
	</cfif>			
</cfoutput>