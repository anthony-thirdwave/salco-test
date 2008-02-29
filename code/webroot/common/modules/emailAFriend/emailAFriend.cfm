<!--- this is the feedback form called from the feedback link
	in the footer - it occurs in a pop up window and has the 
	following specs
	
	- from, defaulted to user name and email
	- subject pulldown with 2 choices 
		'general'
		'this page (whatever that page is)'
	- comments
	
	this will post to the db in a table called t_Feedback then forward 
	to (or just display) a confifmation message with a close option --->
	
<!--- lets establish some params --->
<cfparam name="FORM.FromName" default=#session.UserCommonName#/>
<cfparam name="FORM.FromEmail" default=#session.UserEmailAddress#/>
<cfparam name="FORM.Comments" default=""/>
<cfparam name="FORM.ToFirstName" default=""/>
<cfparam name="FORM.ToLastName" default=""/>
<cfparam name="FORM.ToEmail" default=""/>
<cfparam name="FORM.Subject" default=""/>
<cfparam name="ErrMessage" default=""/>
<cfparam name="Success" default=0/>
<cfparam name="ThisTitle" default=""/>
<cfparam name="Form.submitted" default="0"/>

<!--- we need the category id, going to need to look into where exactly this is  --->
<cfset thisCategoryId = simpledecrypt(#val(url.cid)#)/>
<!--- use that to query the title --->
<cfif thisCategoryId neq "">
	<cfquery name="GetTitle" datasource="#application.dsn#">
		SELECT CategoryName from t_Category where CategoryID = <cfqueryparam value="#thisCategoryID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset ThisTitle = GetTitle.CategoryName/>
<cfelse>
	<cfset ThisTitle = ""/>
</cfif> <!--- got a category id --->


<cfif form.submitted eq "1"> <!--- form submitted --->
	<cfset valid = 1/> <!--- default this to good, then check the required --->
	<cfif FORM.FromName eq "">
		<cfset ErrMessage = ErrMessage & application.crlf & "Sender name is required."/>
		<cfset valid = 0/>
	</cfif> <!--- From Name --->
	<cfif FORM.FromEmail eq "">
		<cfset ErrMessage = ErrMessage & application.crlf & "Sender email is required."/>
		<cfset valid = 0/>
	</cfif> <!--- From Email --->
	<cfif FORM.ToFirstName eq "">
		<cfset ErrMessage = ErrMessage & application.crlf & "Recipient first name is required."/>
		<cfset valid = 0/>
	</cfif> <!---  Recipient First Name --->
	<cfif FORM.ToLastName eq "">
		<cfset ErrMessage = ErrMessage & application.crlf & "Recipient last name is required."/>
		<cfset valid = 0/>
	</cfif> <!---  Recipient Last Name --->
	<cfif FORM.ToEmail eq "">
		<cfset ErrMessage = ErrMessage & application.crlf & "Recipient email name is required."/>
		<cfset valid = 0/>
	</cfif> <!---  Recipient Email --->
	<cfif FORM.Subject eq "">
		<cfset ErrMessage = ErrMessage & application.crlf & "Subject is required."/>
		<cfset valid = 0/>
	</cfif> <!--- Subject First Name --->
	<cfif valid eq 1> 
		<cfset OpenerURL = ""/>
		<cfquery name="GetAlias" datasource="#application.dsn#">
			SELECT categoryAlias from t_category where categoryid = <cfqueryparam value="#thisCategoryId#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		
		<!--- lets get the url of the opener --->
		<cfset thisLink = APPLICATION.protocol & REQUEST.BaseDomainName & "/content.cfm/" & #getAlias.categoryAlias#/>
		
		<cftry>
			<!--- here we want to go ahead and shoot off an email --->
			<cfmail to="#FORM.ToEmail#" 
				from="#APPLICATION.DoNotReplyEmail#"
				replyto="#FORM.FromEmail#"
				subject="#FORM.Subject#" type="html">#FORM.ToFirstName# #FORM.ToLastName#<br><br>
				<cfif form.comments NEQ "">#FORM.Comments#<br><br></cfif>
				Page: #ThisTitle#<br><br>
				Link: <a href="#thisLink#">#thisLink#</a><br><br><br>
				--#FORM.FromName#
				</cfmail>
				
			<cfset success = 1/>
			<cfcatch type="any">
				<cfset success = 0/>
			</cfcatch>
		</cftry>
	</cfif> <!--- end is valid --->
</cfif> <!--- form submitted --->
<!--- now lets let out the html --->
<table border="0" cellpadding="0" cellspacing="0" width="300">
	<cfoutput>
		<cfif success is 1>
			<tr><td colspan="2"><p class="bodyClass">Your message has been sent!</p><p>Click <a href="javascript:window.close();">here to close this window</a>.</p></td></tr>
		<cfelse> <!--- no success - show form --->
			<cfif ErrMessage neq "">
				<tr><td colspan="2" class="bodyClass">#ErrMessage#</td></tr>
			</cfif>
			<form method="post">
			<input type="hidden" name="submitted" value="1"/>
			<tr>
				<td class="bodyClass" width="40" rowspan="2" valign="top"><strong>FROM: </strong> </td>
				<td align="left"><input class="bodyClass fwidth1ong" type="text" name="FromName" value="#FORM.FromName#"/><br>name</td>
			</tr>
			<tr>
				<td align="left" colspan="2"><input class="bodyClass fwidth1ong" type="text" name="FromEmail" value="#FORM.FromEmail#"/><br>email address</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="bodyClass" valign="top"><strong>RECIPIENT: </strong> </td>
				<td align="left" valign="top">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top"><input class="bodyClass fwidthshort" type="text" name="ToFirstName" value="#FORM.ToFirstName#" size="10"/><br>first name </td>
						<td>&nbsp;</td>
						<td align="left" valign="top"><input class="bodyClass fwidthshort" type="text" name="ToLastName" value="#FORM.ToLastName#" size="10"/><br>last name </td>
					</tr>
				</table></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="left"><input class="bodyClass fwidth1ong" type="text" name="ToEmail" value="#FORM.ToEmail#"/><br>email address</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="bodyClass"><strong>SUBJECT: </strong> </td>
				<td align="left"><input class="bodyClass fwidth1ong" type="text" name="Subject" value="#FORM.Subject#"/></td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="bodyClass" valign="top"><strong>COMMENTS:</strong> </td>
				<td align="left" valign="top"><textarea class=" fwidth1ong" name="Comments" rows="10" cols="15">#FORM.Comments#</textarea></td>
			</tr>
			
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="bodyClass" colspan="2" align="center"><input class="bodyClass" type="Submit" value="SUBMIT"/></td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			</form>
		</cfif> <!--- successfully submitted? --->
	</cfoutput>
</table>
