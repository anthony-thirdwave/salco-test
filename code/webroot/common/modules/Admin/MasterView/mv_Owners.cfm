<cfparam name="ATTRIBUTES.FormAction" default="#CGI.Path_Info#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="ATTRIBUTES.CurrentCategoryID" default="-1">
<cfparam name="NewName" default="">
<cfparam name="NewEmail" default="">


<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>

<cfif Isdefined("mvoa")>
	<cfswitch expression="#mvoa#">
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="Modify">
		</cfcase>
	</cfswitch>
</cfif>

<cfset MyCategory=CreateObject("component","//com/ContentManager/Category")>
<cfset MyCategory.Constructor(Val(ATTRIBUTES.CurrentCategoryID))>

<cfset lErrors="">

<cfif IsDefined("FORM.NumOwners")>
	<cfset aOwner=ArrayNew(1)>
	<cfloop index="i" from="1" to="#NumOwners#" step="1">
		<cfset ThisName=Evaluate("Name_#i#")>
		<cfset ThisEmail=Evaluate("Email_#i#")>
		<cfmodule name="3w.errorcheck.validateemail" email="#ThisEmail#">
		<cfif IsDefined("Delete_#i#") or (ThisName IS "" and ThisEmail IS "")>
		<cfelse>
			<cfset sOwnerElt=StructNew()>
			<cfset StructInsert(sOwnerElt,"Name",ThisName,1)>
			<cfset StructInsert(sOwnerElt,"Email",ThisEmail,1)>
			<cfset ArrayAppend(aOwner,sOwnerElt)>
		</cfif>
		<cfif ValidateEmailStatus GTE "200">
			<cfset lErrors=ListAppend(lErrors,i)>
		</cfif>
	</cfloop>
	<cfmodule name="3w.errorcheck.validateemail" email="#NewEmail#">
	<cfif NewName IS NOT "" and (NewEmail IS not "" and ValidateEmailStatus LTE "200")>
		<cfset sOwnerElt=StructNew()>
		<cfset StructInsert(sOwnerElt,"Name",NewName,1)>
		<cfset StructInsert(sOwnerElt,"Email",NewEmail,1)>
		<cfset ArrayAppend(aOwner,sOwnerElt)>
		<cfset NewName="">
		<cfset NewEmail="">
	</cfif>
	<cfif ValidateEmailStatus GTE "200" and NewEmail IS NOT "">
		<cfset lErrors=ListAppend(lErrors,"New")>
	</cfif>
	<cfset MyCategory.SetProperty("aOwner",aOwner)>
</cfif>

<!--- Update permission--->
<cfif ATTRIBUTES.ObjectAction IS "Modify" and lErrors IS "">
	<cfset MyCategory.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
	<cf_AddToQueryString queryString="#FormQueryString#" Name="mvoa" value="1" Omitlist="ugid,cid">
	<cflocation url="#FormPage#?#QueryString#" addtoken="No">
</cfif>

<cfset aOwner=MyCategory.GetProperty("aOwner")>

<!--- NEW TABLE --->
<table width="100%">
<tr valign="top" bgcolor="BAC0C9">
	<TD colspan="2"><b>Owner Details</b></TD>
	</tr><tr bgcolor="EAEAEA">
	<td bgcolor="bac0c9">&nbsp;</td>
	<TD align="center" bgcolor="eaeaea">
<cfoutput>
<cf_AddToQueryString queryString="#FormQueryString#" Name="mvoa" value="2">
<form action="#FormPage#?#QueryString#" method="post" name="form_permissions">
<!--- begin the loop of groups --->
<table width="100%"  border="0" cellpadding="0" bgcolor="white">
<tr bgcolor="bac0c9">
<td><strong>Name</strong></td>
<td><strong>Email Address </strong></td>
<td><strong>Delete?</strong></td>
</tr>
<cfloop index="i" from="1" to="#ArrayLen(aOwner)#" step="1">
	 <tr bgcolor="eaeaea">
        <td><input name="Name_#i#" type="text" value="#aOwner[i].Name#" size="20" maxlength="255"></td>
        <td><input name="Email_#i#" type="text" value="#aOwner[i].EMail#" size="40" maxlength="255"><cfif ListFind(lErrors,i)><BR>Please enter a valid email address</cfif></td>
        <td><input type="checkbox" name="Delete_#i#" value="checkbox"></td>
      </tr>
</cfloop>
<tr bgcolor="eaeaea">
<td><br>New<br>
<input type="text" name="NewName" size="20" maxlength="255" value="#NewName#"></td>
<td><br>&nbsp;<br><input name="NewEmail" type="text"  size="40" maxlength="255" value="#NewEmail#"><cfif ListFind(lErrors,"New")><BR>Please enter a valid email address</cfif></td>
<td>&nbsp;</td>
</tr></table>

<input type="hidden" name="NumOwners" value="#ArrayLen(aOwner)#">
<tr bgcolor="EAEAEA">
<td bgcolor="bac0c9">&nbsp;</td>
<TD align="center" bgcolor="eaeaea"><div align="left"><input type="image" src="/common/images/ContentManager/but_update.gif" width="58" height="17"></div></TD></tr>
</table>
</form>
</cfoutput>

