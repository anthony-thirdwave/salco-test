<cfsilent>
<cfparam name="ATTRIBUTES.RecordCount" default="0">
<cfparam name="ATTRIBUTES.SearchNum" default="0">
<cfparam name="ATTRIBUTES.StartRow" default="0">
<cfparam name="ATTRIBUTES.FieldList" default=""><!--- Valid URLEncodedFormat String --->
<cfparam name="ATTRIBUTES.FontColor" default="black">
<cfparam name="thisImagePath" default="">
<cfparam name="thisTopCount" default="">
<cfset StartRow=ATTRIBUTES.StartRow>
<cfset SearchNum=ATTRIBUTES.SearchNum>
<cfset FieldList=ATTRIBUTES.FieldList>



</cfsilent>
<!----- figure out records left ---->
<cfif (Attributes.StartRow) + Attributes.SearchNum - 1 LT Attributes.RecordCount>
	<!----- <cfif Attributes.StartRow EQ 1><cfdump var="#ATTRIBUTES.StartRow#"> ----->
		<cfset thisTopCount = (#Attributes.StartRow# + #Attributes.SearchNum#) -1>
	<!----- <cfelse><cfdump var="#ATTRIBUTES.StartRow#"> -----2
		<cfset thisTopCount = (#Attributes.StartRow# + #Attributes.SearchNum#) -2> ----->
	<!----- </cfif> ----->
<cfelse>
	<cfset thisTopCount = #Attributes.StartRow# + (#Attributes.RecordCount# - #Attributes.StartRow#)>
</cfif>

<cfoutput>
	<cfif ATTRIBUTES.RecordCount GT ATTRIBUTES.SearchNum>

			<div class="start"><span></span></div>

				<table align="right" border="0" width="495">
				<tr>
					<td valign="top" align="left" colspan="2"><hr /></td>
				</tr>
				<tr>
				<td valign="top" align="left" width="330"><strong>#Attributes.StartRow# - #thisTopCount# of #Attributes.RecordCount#</strong></td>

				<td valign="top" align="right" width="165">
				<table align="right" border="0">
				<tr>
					<td valign="top" align="left"><CFIF ATTRIBUTES.StartRow GT ATTRIBUTES.SearchNum>
						<cfset NewStartRow=StartRow-(SearchNum*2)>
						<cf_AddToQueryString QueryString="#FieldList#" name="StartRow" value="#NewStartRow#">
						<cf_AddToQueryString QueryString="#querystring#" name="SearchNum" value="#SearchNum#">
						<a href="#CGI.SCRIPT_NAME#?#querystring#">&lt; Previous page</a>&nbsp;&nbsp;&nbsp;
					<cfelse>
						<a class="inactive">&lt; Previous page</a>&nbsp;&nbsp;&nbsp;
					</CFIF></td>

					<!----- <td valign="top" align="right">
					<cfsilent>
					<cfset outputstr="">
					<cfloop index="i" from="1" to="#Ceiling(ATTRIBUTES.RecordCount/ATTRIBUTES.SearchNum)#" step="1">
						<cfif "#Evaluate(ATTRIBUTES.StartRow)#" IS "#Evaluate((1-ATTRIBUTES.SearchNum)+(ATTRIBUTES.SearchNum*i))#">
							<cfset outputstr="#outputstr#<span class=""current"">&nbsp;<strong><a>#i#</a></strong>&nbsp;</span>">
						<cfelse>
							<cfset NewStartRow=(1-(2*SearchNum))+(SearchNum*i)>
							<cfmodule template="/common/modules/utils/AddToQueryString.cfm" QueryString="#FieldList#" varname="StartRow" value="#NewStartRow#">
							<cfmodule template="/common/modules/utils/AddToQueryString.cfm" QueryString="#querystring#" varname="SearchNum" value="#SearchNum#">
							<cfset outputstr="#outputstr#&nbsp;<a href=""#CGI.SCRIPT_NAME#?#querystring#"">#i#</a>&nbsp;">

						</cfif>
						<cfif (i NEQ 1) AND (i MOD 15) EQ 0><cfset outputstr="#outputstr#<BR>"></cfif>
						<cfset outputstr="#outputstr#">
					</cfloop>
					</cfsilent>
					#outputstr#</td> ----->



					<td valign="top" align="left"><CFIF ATTRIBUTES.StartRow LT (ATTRIBUTES.RecordCount - (ATTRIBUTES.SearchNum-1))>
						<cf_AddToQueryString QueryString="#FieldList#" name="StartRow" value="#StartRow#">
						<cf_AddToQueryString QueryString="#querystring#" name="SearchNum" value="#SearchNum#">
						<a href="#CGI.SCRIPT_NAME#?#querystring#" class="capsBlackLink">Next page &gt;</a>
					<cfelse>
						<a class="inactive">Next page &gt;</a>
					</CFIF>
						</td></tr></table>
					</td></tr></table>

			<div class="end"><span></span></div>

	</cfif>
</cfoutput>