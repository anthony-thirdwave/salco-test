<cfparam name="ATTRIBUTES.FormAction" default="/content.cfm/Search">
<cfparam name="sc" default="1">
<cfset FormPath=GetToken(ATTRIBUTES.FormAction,1,"?")>
<cfset FormQueryString=GetToken(ATTRIBUTES.FormAction,2,"?")>
<cfparam name="ParamKeywords" default="">
<cf_AddToQueryString QueryString="#FormQueryString#" name="scaoa" value="2">
<cfoutput><form style="display:inline;"  action="#FormPath#?#QueryString#" method="POST" name="searchform">
<input type="text" name="ParamKeywords" value="#ParamKeywords#" size="15" maxlength="35" align="absmiddle">
<input type="submit" value="Search"></form></cfoutput>
