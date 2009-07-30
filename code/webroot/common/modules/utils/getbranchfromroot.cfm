<cfsilent><!-- Begin getbranchfromroot.cfm -->
<cfparam name="ATTRIBUTES.AliasList" default="">
<cfquery name="GetDetailOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
	SELECT parentid FROM t_Category WHERE CategoryID=#val(ATTRIBUTES.ThisCategoryID)#
</cfquery>
<cfquery name="GetParentOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,0,30)#">
	SELECT CategoryName,CategoryID,CategoryAlias FROM t_Category WHERE CategoryID=#val(Evaluate("GetDetailOf#IncrementVAlue(Val(ATTRIBUTES.ThisCategoryID))#.parentid"))#
</cfquery>
<cfif Evaluate("GetParentOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#.recordcount") IS NOT "0">
	<cfset NameList=ListPrepend(ATTRIBUTES.NameList, application.utilsObj.RemoveHTML(Replace(Evaluate("GetParentOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#.CategoryName"),","," ","all")))>
	<cfset IDList=ListPrepend(ATTRIBUTES.IDList, Evaluate("GetParentOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#.CategoryID"))>
	<cfset AliasList=ListPrepend(ATTRIBUTES.AliasList, Evaluate("GetParentOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#.CategoryAlias"))>
	<cfmodule template="getbranchfromroot.cfm" ThisCategoryID="#Evaluate('GetParentOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#.CategoryID')#" NameList="#NameList#" IDList="#IDList#" AliasList="#AliasList#">
	<cfset CALLER.NameList=NameList>
	<cfset CALLER.IDList=IDList>
	<cfset CALLER.AliasList=AliasList>
<cfelse>
	<!--- Get out of here --->
	<cfset CALLER.NameList=ATTRIBUTES.NameList>
	<cfset CALLER.IDList=ListPrepend(ATTRIBUTES.IDList,val(Evaluate("GetDetailOf#IncrementValue(Val(ATTRIBUTES.ThisCategoryID))#.parentid")))>
	<cfset CALLER.AliasList=ATTRIBUTES.AliasList>
</cfif>
<!-- End getbranchfromroot.cfm --></cfsilent>