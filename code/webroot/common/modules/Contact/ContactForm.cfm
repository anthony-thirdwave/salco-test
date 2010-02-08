<cfparam name="FormAction" default="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
<cfparam name="action" default="0">
<cfparam name="question" default="">
<cfparam name="name" default="">
<cfparam name="email" default="">
<cfparam name="membershipID" default="">
<cfparam name="message" default="">
<cfparam name="thisWord" default="">
<cfparam name="chlortho" default="">
<cfparam name="capText" default="">
<cfparam name="ATTRIBUTES.ConfirmLocation" default="#APPLICATION.utilsObj.parseCategoryUrl('/contactconfirm')#">
<cfset errorMessage = "">



<cfset AlphaList="abcdefghjkmnpqrstuvwxyz23456789">
<cfset thisWord="">
<cfloop index="i" from="1" to="5" step="1">
 <cfset thisWord="#thisWord##Mid(AlphaList,RandRange(1,len(AlphaList)),1)#">
</cfloop>






<cfscript>
questionArray = arraynew(1);
questionArray[1] = "Generic Question";

emailArray = arraynew(1);

emailArray[1] = "webmaster@thirdwavellc.com";

</cfscript>

<cfif action EQ 1>


	<!--- trim all form values --->
	<cfloop index="x" list="#Form.FieldNames#">
		<cfset temp = SetVariable("#x#","#trim(form[x])#")>
	</cfloop>
	
	<cfif question EQ "">
		<cfset errorMessage = errorMessage & "\n -Please select what you have a question about">
	</cfif>
	
	<cfif name EQ "">
		<cfset errorMessage = errorMessage & "\n -Please enter your name">
	</cfif>
	
	<cfif email EQ "">
		<cfset errorMessage = errorMessage & "\n -Please enter your email">
	<cfelse>
		<!--- If entered, make sure that the Email Address is valid --->
		<cfmodule template="/common/modules/utils/validateEmail.cfm" email="#email#">
		<CFIF ValidateEmailStatus GTE 200>
			<cfset errorMessage = errorMessage & "\n -Your email has an invalid format">
		</CFIF>
	</cfif>

	<cfif message EQ "">
		<cfset errorMessage = errorMessage & "\n -Please enter a message">
	</cfif>
	
	<cfset chlortho="#decrypt(chlortho,APPLICATION.Key)#">
	
	<cfif capText EQ "">
		<cfset errorMessage = errorMessage & "\n -Please enter the text as seen in the image">
	<cfelse>
		<cfif chlortho NEQ capText>
			<cfset errorMessage = errorMessage & "\n -The text you entered does not match that in the image">
		</cfif>
	</cfif>
	
	<cfif errorMessage EQ ""><!--- #emailArray[question]# --->
		<cfmail to="#emailArray[question]#" from="#email#" subject="Contact Form Question - #questionArray[question]#">
Name: #name#
Email: #email#
Question Type: #questionArray[question]#
Membership ID: <cfif Trim(membershipID) EQ "">(not given)<cfelse>#membershipID#</cfif>

Message:
#message#
		</cfmail>
		<cflocation url="#ATTRIBUTES.ConfirmLocation#" addtoken="no">
		<!--- send email and locate to confirmation page here --->
	<cfelse>
		<cfset errorMessage = "Your form subission had the following errors:" & errorMessage>
		<cflocation url="/common/modules/utils/_MessageBox.cfm?Location=Back&StatusMessage=#URLEncodedFormat(errorMessage)#" addtoken="no">
	</cfif>

</cfif>

<cfset Location=GetToken(FormAction,1,"?")>
<cfset querystring=GetToken(FormAction,2,"?")>

<cfoutput>
<form action="#location#?#querystring#" method="post" name="contactForm">
<input type="hidden" name="chlortho" value="#HTMLEditFormat(encrypt(thisWord,APPLICATION.KEY))#" />
<table cellpadding="0" cellspacing="0" border="0">
<tr>
	<td align="left" valign="top">I have a question about</td>
	<td><img src="/common/images/spacer.gif" width="20" height="1"></td>
	<td align="left" valign="top">
		<select name="question" style="width:200px">
			<option value="">select one...</option>
			<cfloop from="1" to="#arrayLen(questionArray)#" step="1" index="i">
				<option value="#i#"<cfif question EQ i> selected</cfif>>#questionArray[i]#</option>
			</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td align="left" valign="top">Your name</td>
	<td><img src="/common/images/spacer.gif" width="20" height="1"></td>
	<td align="left" valign="top"><input type="text" name="name" value="#name#" style="width:200px;"></td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td align="left" valign="top">Your email</td>
	<td><img src="/common/images/spacer.gif" width="20" height="1"></td>
	<td align="left" valign="top"><input type="text" name="email" value="#email#" style="width:200px;"></td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td align="left" valign="top">Your message</td>
	<td><img src="/common/images/spacer.gif" width="20" height="1"></td>
	<td align="left" valign="top"><textarea name="message" style="width:200px; overflow:auto;" rows="5">#message#</textarea></td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td align="left" valign="top"></td>
	<td><img src="/common/images/spacer.gif" width="20" height="1"></td>
	<td align="left" valign="top"><cfscript>
	captcha = createObject("component", "com.utils.Captcha").init();
	captcha.captchaToFile("#APPLICATION.WebrootPath#common/images/captcha/captcha.jpg","#thisWord#",200,50,30,10,35,45,60);
</cfscript><img src="/common/images/captcha/captcha.jpg"></td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td align="left" valign="top">Please enter the text you<BR />see in the image above</td>
	<td><img src="/common/images/spacer.gif" width="20" height="1"></td>
	<td align="left" valign="top"><input type="text" name="capText" value="" style="width:200px;"></td>
</tr>
<tr>
	<td colspan="3"><img src="/common/images/spacer.gif" width="1" height="20"></td>
</tr>
<tr>
	<td colspan="2">&nbsp;</td>
	<td align="left" valign="top"><input type="hidden" name="action" value="1" /><input type="reset" value="Clear" name="clear">&nbsp;<input type="submit" name="submit" value="Send message"></td>
</tr>
</table>
</form>
</cfoutput>

