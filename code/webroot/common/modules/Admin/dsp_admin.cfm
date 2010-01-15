<cfparam name="ATTRIBUTES.AcceptGroupIDList" default="#APPLICATION.AdminUserGroupID#,#APPLICATION.ContentEditorUserGroupID#">
<cfparam name="ATTRIBUTES.Secure" default="Yes">
<cfparam name="ATTRIBUTES.Page" default="">
<cfparam name="ATTRIBUTES.PageHeader" default="#ATTRIBUTES.Page#">
<cfparam name="ATTRIBUTES.IncludeOverlibJS" default="No">
<cfparam name="ATTRIBUTES.IncludeTopMenu" default="Yes">
<cfparam name="ATTRIBUTES.ExecutionMode" default="#ThisTag.ExecutionMode#">

<cfif IsDefined("REQUEST.AdminHeaderDisplayed")>
	<cfset ATTRIBUTES.ExecutionMode="End">
</cfif>

<cfif IsDefined("FORM.NewAdminLocaleID")>
	<cfset SESSION.AdminCurrentAdminLocaleID=FORM.NewAdminLocaleID>
	<cflocation url="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" addToken="no">
</cfif>
<cfparam name="SESSION.AdminUserLocaleID" default="-1">

<cfif ATTRIBUTES.ExecutionMode IS "Start">
	<cfinclude template="/common/modules/Admin/_AdminNavigation.cfm">
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
	<title>ADMIN : <cfoutput>#ATTRIBUTES.Page#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="/common/styles/admin.css" title="docProperties">
	<script type="text/javascript" src="/common/scripts/swfupload.js"></script>
	<script type="text/javascript" src="/common/scripts/handlers.js"></script>
	</head>
	<body bgcolor="#F1F2E8" topmargin=0 leftmargin=0 marginwidth="0" marginheight="0" link="#0099FF" vlink="navy" alink="003333">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<TR bgcolor="33393C" height="41">
			<TD width="42"  class="border1" style="width:41px;">&nbsp;</TD>
			<TD width="95" class="border1">&nbsp;<img src="/common/images/admin/companyLogoTransparent.png" style="position:absolute;top:0px;left:52px;"></TD>
			<TD width="845" class="border1">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="SiteTitle">
					<tr valign="middle">
						<TD style="padding-left:10px;">MasterView</TD>
						<td align="right"><small><cfif SESSION.AdminUserID IS NOT "">Welcome, <cfoutput>#SESSION.AdminUserLogin#</cfoutput></small> <a href="/common/admin/logoff.cfm" style=""><img src="/common/images/admin/button_logout.gif" class="logoutBut" border="0" align="absmiddle" style="" alt=""></A></cfif></td>
					</TR>
				</table>
			</TD>
			<TD class="border1">&nbsp;</TD>
		</TR>
		<TR bgcolor="4A5154" height="56">
			<TD width="42">&nbsp;</TD>
			<TD width="95">&nbsp;</TD>
			<TD width="845">
			<cfif SESSION.AdminUserID IS NOT "">
				<table width="100%" height="56" border="0" cellspacing="0" cellpadding="0"><TR><TD><table height="56" border="0" cellspacing="0" cellpadding="0"><tr valign="top">
				<cfif ATTRIBUTES.IncludeTopMenu>
					<cfloop index="ThisElt" list="#sMenuList#">
						<cfset DisplayLink="yes">
						<cfif sMenu[ThisElt].lUserGroupID is not "all">
							<Cf_venn
								ListA="#sMenu[ThisElt].lUserGroupID#"
								ListB="#SESSION.AdminUserGroupIDList#"
								AandB="Intersection">
							<cfif ListLen(Intersection) IS "0">
								<cfset DisplayLink="No">
							</cfif>
						</cfif>
						<cfif DisplayLink>
							<cfoutput><TD class="MenuAdmin" width="94">
								<a href="#sMenu[ThisElt].Link#" <cfif Left(sMenu[ThisElt].Link,5) is "http:">target="_blank"</cfif> title="#sMenu[ThisElt].Description#"><strong>#sMenu[ThisElt].Name#</strong></A></TD>
							</cfoutput>
						</cfif>
					</cfloop>
				</cfif>
				</TR></table></TD>
				<form action="/common/admin/search/index.cfm" method="get"><input name="newSearch" value="1" type="hidden"><input name="searchBy" value="title" type="hidden"><td align="right" valign="middle">
				<input type="text" class="adminSearchField" name="searchText" size="25" maxlength="100"> <input class="adminSearchSubmitBut" type="image" src="/common/images/admin/button_search.gif" border="0" style="">
				</td></form></tr></table>
			</cfif>
			</TD>
			<TD>&nbsp;</TD>
		</TR>
		<cfif Application.GetAllLocale.RecordCount GT "1">
			<TR bgcolor="33393C">
				<TD width="42">&nbsp;</TD>
				<TD width="95">&nbsp;</TD>
				<cfif CGI.SCRIPT_NAME IS "/common/admin/Masterview/index.cfm">
					<cfset ThisFormAction="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
				<cfelse>
					<cfset ThisFormAction="/common/admin/index.cfm">
				</cfif>
				<cfoutput><form action="#ThisFormAction#" method="post"></cfoutput>
				<td width="845" align="right">
				<cfif Val(SESSION.AdminUserID) GT "0">
					<cfif SESSION.AdminUserLocaleID IS NOT "1">
						<cfoutput><strong>Locale: #SESSION.CurrentAdminLocaleName#</strong></cfoutput>
					<cfelse>
						<select name="NewAdminLocaleID">
					  	<cfoutput query="Application.GetAllLocale">
							<option value="#LocaleID#" <cfif SESSION.AdminCurrentAdminLocaleID IS LocaleID>selected</cfif>>#LocaleName#</option>
						</cfoutput>
				      </select>
				      <input type="image" src="/common/images/admin/button_search.gif" border="0">
					</cfif>
				</cfif>
				</TD>
				</form>
				<TD>&nbsp;</TD>
			</TR>
		</cfif>
		<tr valign="bottom" height="53">
			<TD width="42">&nbsp;</TD>
			<TD width="940" style="border-bottom:1px solid black" colspan="2">
				<table width="940" border="0" cellspacing="0" cellpadding="0">
					<TR><TD class="pagetitle"><cfoutput>#ATTRIBUTES.Page#</cfoutput></TD><TD>&nbsp;</TD></TR>
				</table>
			<TD>&nbsp;</TD>
		
		</TR>
		
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-top:15px;">
		<TR>
			<TD width="42" style="width:42px;">&nbsp;</TD>
			<TD width="940">
	
	
	
	  <cfset REQUEST.AdminHeaderDisplayed="1">
 <cfelse>
 	&nbsp;<br>
	
 	</TD><TD>&nbsp;</TD>
	<TR bgcolor="33393C">
		<TD class="border1">&nbsp;</TD>
		<TD class="border1" align="center" class="FooterAdmin2">
		<p style="color:white;text-transform:uppercase;font-weight:bold;"><cfoutput>#ATTRIBUTES.Page#</cfoutput><br>
		</p>
		&nbsp;
		</TD>
		<TD class="border1">&nbsp;</TD>
	</TR>
	
	<TR bgcolor="33393C">
		<TD>&nbsp;</TD>
		<TD align="center" class="FooterAdmin2">
		<p>All content copyright 2003-<cfoutput>#Year(Now())#, #APPLICATION.CompanyName# </cfoutput>unless otherwise noted. All rights reserved.<br>
		<cfoutput><a href="/" target="_blank">#APPLICATION.CompanyName#</a> / <a href="/content.cfm/privacy" target="_blank">Terms of Service &amp; Privacy Policy</A> / Version #APPLICATION.CMSVersion#</cfoutput><br>
		&nbsp;</p>
		</TD>
		<TD>&nbsp;</TD>
	</TR>
	<!-- To activate script needed for transparent pngs to work in IE 6 -->
    <!--[if lte IE 6]>
		<script type="text/javascript" src="/common/scripts/pngfix.js"></script>
    <![endif]-->
	</body>
	</html>
 </cfif>
 