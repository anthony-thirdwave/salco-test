<cfparam name="ATTRIBUTES.AcceptGroupIDList" default="#APPLICATION.AdminUserGroupID#,#APPLICATION.ContentEditorUserGroupID#">
<cfparam name="ATTRIBUTES.Secure" default="Yes">
<cfparam name="ATTRIBUTES.PageTitle" default="#APPLICATION.SiteTitle#">
<cfparam name="ATTRIBUTES.PageHeader" default="#ATTRIBUTES.PageTitle#">
<cfparam name="ATTRIBUTES.IncludeOverlibJS" default="0">

<cfif ATTRIBUTES.secure>
	<cfset ThisAcceptGroupIDList=ListAppend(ATTRIBUTES.AcceptGroupIDList,APPLICATION.SuperAdminUserGroupID)>
	<cfmodule template="/common/modules/Admin/_secure.cfm"
		AcceptGroupIDList="#ThisAcceptGroupIDList#">
	<cfset CALLER.UserGroupIDList=UserGroupIDList>
<cfelse>
	<cfset CALLER.UserGroupIDList="">
</cfif>


<html>
<head>
<title>ADMIN : <cfoutput>#ATTRIBUTES.PageTitle#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="/common/styles/admin.css" title="docProperties">
</head>
<body bgcolor="White" topmargin=0 leftmargin=0 marginwidth="0" marginheight="0" link="#339999" vlink="#006666" alink="003333">
<cfif ATTRIBUTES.IncludeOverlibJS>
<!-- http://www.bosrup.com/web/overlib/ -->
<DIV ID="overDiv" STYLE="position:absolute; visibility:hide; z-index:1;"></DIV>
<SCRIPT language=JavaScript src="/common/scripts/overlib.js"></SCRIPT>
</cfif>
<table width="760" border="0" cellspacing="0" cellpadding="0">
   <TR>
  	<TD>&nbsp;</TD>
  	<TD><img src="/common/images/thirdwave_logotype.gif"></TD>
  </TR>
  <TR>
  	<TD>&nbsp;</TD>
  	<TD><img src="/common/images/3WCMSlogo.gif"><BR>
	&nbsp;</TD>
  </TR>
  <tr><TD><img src="/common/images/spacer.gif" width="60" height="1"></TD>
    <td width="99%"><font size="3"><cfoutput><b>#ATTRIBUTES.PageTitle#</b></font><BR>#ATTRIBUTES.PageHeader#</cfoutput></td>
  </tr>
  <tr><TD>&nbsp;</TD>
    <td><hr size="1" color="Black" noshade></td>
  </tr>
  <TR><TD>&nbsp;</TD><td valign="top">
  