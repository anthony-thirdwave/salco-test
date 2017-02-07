<cfparam name="ATTRIBUTES.QS" default="">
<cfparam name="ATTRIBUTES.showFirst" default="0">
<cfparam name="ATTRIBUTES.showLast" default="0">
<cfparam name="ATTRIBUTES.CurrentPageNum" default="0">
<cfparam name="ATTRIBUTES.LastPageNum" default="0">
<cfoutput>
<ul>
	<li><cfif ATTRIBUTES.showFirst><cf_AddToQueryString querystring="#ATTRIBUTES.QS#" name="pageNum" value="1" omitList="x,y"><a href="?#QueryString#">first</a><cfelse>first</cfif></li>
	<li><cfif ATTRIBUTES.showFirst><cf_AddToQueryString querystring="#ATTRIBUTES.QS#" name="pageNum" value="#ATTRIBUTES.CurrentPageNum-1#" omitList="x,y"><a href="?#QueryString#">&##171; prev</a><cfelse>&##171; prev</cfif></li>
	<li><cfif ATTRIBUTES.showLast><cf_AddToQueryString querystring="#ATTRIBUTES.QS#" name="pageNum" value="#ATTRIBUTES.CurrentPageNum+1#" omitList="x,y"><a href="?#QueryString#">next &##187;</a><cfelse>next &##187;</cfif></li>
	<li class="last"><cfif ATTRIBUTES.showLast><cf_AddToQueryString querystring="#ATTRIBUTES.QS#" name="pageNum" value="#ATTRIBUTES.LastPageNum#" omitList="x,y"><a href="?#QueryString#">last</a><cfelse>last</cfif></li>
</ul>
</cfoutput>