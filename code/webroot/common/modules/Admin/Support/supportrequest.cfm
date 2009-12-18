<!--- feedbacksubmission module --->
<cfparam name="ATTRIBUTES.ObjectAction" default="">
<cfparam name="ATTRIBUTES.NextPage" default="">
<cfparam name="ATTRIBUTES.EmailAddressValidationMessage" default="Please enter a valid email address">
<cfparam name="txtName" default="">
<cfparam name="txtEmail" default="">
<cfparam name="txtEmail" default="">
<cfparam name="txtPhone" default="">
<cfparam name="txtIssueType" default="">
<cfparam name="txtIssue" default="">


<cfset sErrorMessage=StructNew()>

<cfset StructInsert(sErrorMessage,100,"Please enter your name.")>
<cfset StructInsert(sErrorMessage,200,"Please enter a valid email address.")>
<cfset StructInsert(sErrorMessage,300,"Please enter your phone number.")>
<cfset StructInsert(sErrorMessage,400,"Please select a type of issue.")>
<cfset StructInsert(sErrorMessage,500,"Please enter your issue.")>

<cfswitch expression="#ATTRIBUTES.ObjectAction#">
	<cfcase value="Page1">

		<cfquery datasource="#APPLICATION.DSN#" name="OS">
			SELECT LabelID, LabelName FROM t_Label WHERE LabelGroupID = 6000 order by LabelName
		</cfquery>
		
		<cfif isDefined("URL.txtName")>
			<cfset txtName = URL.txtName>
		</cfif>
		
		<cfif isDefined("URL.txtEmail")>
			<cfset txtEmail = URL.txtEmail>
		</cfif>
		
		<cfif isDefined("URL.txtPhone")>
			<cfset txtPhone = URL.txtPhone>
		</cfif>
		
		<cfif isDefined("URL.txtIssueType")>
			<cfset txtIssueType = URL.txtIssueType>
		</cfif>
		
		
		<cfif isDefined("URL.txtIssue")>
			<cfset txtIssue = URL.txtIssue>
		</cfif>
		
		<cfif isDefined("URL.txtBrowser")>
			<cfset txtBrowser = URL.txtBrowser>
		<cfelse>
			<cfset txtBrowser = "#CGI.HTTP_USER_AGENT#">
			<cfif CGI.HTTP_USER_AGENT CONTAINS "Windows">
				<cfset URL.Platform="6000">
			<cfelse>
				<cfset URL.Platform="6001">
			</cfif>
		</cfif>
		
		<cfset Location=GetToken(ATTRIBUTES.NextPage,1,"?")>
		<cfset querystring=GetToken(ATTRIBUTES.NextPage,2,"?")>
		<cf_AddToQueryString querystring="#querystring#" name="submitted" value="1" Omitlist="txtname,txtemail,txtphone,txtissue,txtbrowser,txtIssueType,platform">
		<table border="0">
			<form name="supportForm" id="supportForm" method="post" action="<cfoutput>#Location#?#QueryString#</cfoutput>">
			<tr>
				<td colspan="2">
				<p>* Required fields</p>
				</td>
			</tr>
			<cfif Isdefined("URL.EC")>
				<tr>
					<td colspan="2" align="left">
						<p style="color:red"><cfloop index="ThisErrorCode" list="#URL.EC#">
							<cfoutput>#sErrorMessage[ThisErrorCode]#</cfoutput><BR>
						</cfloop></p>
					</td>
				</tr>
			</cfif>
			<tr>
				<td>Your name*</td>
				<td><input type="text" name="txtName" id="txtName" value="<cfoutput>#txtName#</cfoutput>"  maxlength="200"/></td>
			</tr>
			<tr>
				<td>Your email address*</td>
				<td><input type="text" name="txtEmail" id="txtEmail" value="<cfoutput>#txtEmail#</cfoutput>"   maxlength="200"/></td>
			</tr>
			<tr>
				<td>Your phone number*</td>
				<td><input type="text" name="txtPhone" id="txtPhone" value="<cfoutput>#txtPhone#</cfoutput>"   maxlength="20"/></td>
			</tr>
			<tr>
				<td>Type of issue*</td>
				<td><input type="text" name="txtIssueType" id="txtIssueType" value="<cfoutput>#txtIssueType#</cfoutput>"  maxlength="200"/>
				</td>
			</tr>
			<tr valign="top">
				<td>Your issue*</td>
				<td><textarea  name="txtIssue" id="txtIssue" rows="10" cols="35"><cfoutput>#txtIssue#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td>Your platform</td>
				<td>
					<select name="platform" id="platform"  >
						<option value="0">Select one</option>
						<cfoutput query="OS">
							<option value="#LabelID#" <cfif isDefined("URL.platform") and URL.platform IS LabelID>selected</cfif>>#LabelName#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>Browser you are using</td>
				<td><input type="text" name="txtBrowser" id="txtBrowser" value="<cfoutput>#txtBrowser#</cfoutput>" maxlength="100" /></td>
			</tr>
			<tr>
				<td><input class="submitButton" type="submit" value="Submit">&nbsp;</td>
				<td align="right"></td>
			</tr>
			</form>
		</table>
		
	</cfcase>
	<cfcase value="Page1ValidateAndSave">
	
		<cfif Form.txtName IS "">
			<cfset ECValue = "100">
		</cfif>

		<cfmodule name="3w.errorcheck.validateemail" email="#Form.txtEmail#">  
		<cfif ValidateEmailStatus GTE "200">
			<cfset ShowForm="1">
			<cfif isDefined("ECValue")>
				<cfset ECValue = ECValue & ",200">
			<cfelse>
				<cfset ECValue = "200">
			</cfif>
		</cfif>

		<cfif Form.txtPhone IS "">
			<cfif isDefined("ECValue")>
				<cfset ECValue = ECValue & ",300">
			<cfelse>
				<cfset ECValue = "300">
			</cfif>
		</cfif>

		<cfif Form.txtIssueType IS "">
			<cfif isDefined("ECValue")>
				<cfset ECValue = ECValue & ",400">
			<cfelse>
				<cfset ECValue = "400">
			</cfif>
		</cfif>

		<cfif Form.txtIssue IS "" OR len(Form.txtIssue) GT 3000>
			<cfif isDefined("ECValue")>
				<cfset ECValue = ECValue & ",500">
			<cfelse>
				<cfset ECValue = "500">
			</cfif>
		</cfif>
		
		<cfif isDefined("ECValue")>
			<cflocation url="#ATTRIBUTES.PrevPage#?txtName=#URLEncodedFormat(Form.txtName)#&txtEmail=#URLEncodedFormat(Form.txtEmail)#&txtPhone=#URLEncodedFormat(Form.txtPhone)#&txtIssueType=#URLEncodedFormat(FORM.txtIssueType)#&txtIssue=#URLEncodedFormat(Form.txtIssue)#&platform=#URLEncodedFormat(Form.platform)#&txtBrowser=#URLEncodedFormat(Form.txtBrowser)#&EC=#URLEncodedFormat(ECValue)#" addtoken="No">
		</cfif>
		
		<cfquery datasource="#APPLICATION.DSN#" name="OS">
			SELECT LabelName FROM t_Label WHERE LabelID =
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.platform#">
		</cfquery>
		
		<cfoutput query="OS">
			<cfset varOS = #LabelName#>
		</cfoutput>

		<cfset supportMail = "thomas.sychay@thirdwavellc.com">
		<cfif APPLICATION.Staging>
			<cfset Subject="New CMS support request from #txtname#">
		<cfelse>
			<cfset Subject="TESTING: New CMS support request from #txtname#">
		</cfif>
		
		<cfoutput>Subject#Subject#</cfoutput>
		<cfmail to="#supportMail#" from="#Form.txtEmail#" subject="#Subject#">

NAME: #txtName#
FROM: #txtEmail#
PHONE: #txtPhone#
PLATFORM: #varOS#
ISSUE TYPE: #txtIssueType#
			
ISSUE: 
#txtIssue#

BROWSER: #txtBrowser#


Logged in user: <cfif Trim(SESSION.AdminUserLogin) IS "">none<cfelse>#SESSION.AdminUserLogin#</cfif>
		</cfmail>
		<cfif Trim(SESSION.AdminUserLogin) IS "">
			<cfset varUser = "none">
		<cfelse>
			<cfset varUser = SESSION.AdminUserLogin>
		</cfif>
		<cfquery datasource="#APPLICATION.DSN#" name="updateSupport">
			INSERT INTO
				t_SupportRequest(
				requestorName, requestorEmail, requestorPhone, supportIssueType,
				supportIssue, requestorPlatformID, requestorBrowser, requestorUser, supportRequestStatus)
			VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtEmail#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtPhone#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtIssueType#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtIssue#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.platform#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtBrowser#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#varUser#">, 7000)
		</cfquery>
		<cflocation url="#ATTRIBUTES.NextPage#" addtoken="No">
	</cfcase>
	<cfdefaultcase>
	</cfdefaultcase>
</cfswitch>
