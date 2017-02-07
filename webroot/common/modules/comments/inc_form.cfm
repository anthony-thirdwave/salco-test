<cfoutput>
	<div class="body">
	<cf_AddToQueryString querystring="#CGI.Query_String#" name="r" value="#CreateUUID()#">
	<form id="comment-form" action="#CGI.request_uri#?#querystring###addcomment" method="post">
	<h3><label for="com-comment">Add a Comment</label><a name="addcomment"></a></h3>
	<cfif commentError NEQ "">
		<p class="form-note">Your form submission contained the following errors:</p>
		<ul class="form-note">#commentError#</ul>
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0">
	<cfif Val(SESSION.UserID) LTE "0">
		<tr>
		<td align="left" valign="top" width="115">Your Name</td>
		<td valign="top"><input id="com-name" name="name" value="#HTMLEditFormat(FORM.name)#" type="text" class="commentField" /></td>
		</tr>
		<tr>
		<td align="left" valign="top">Your Email Address <br /><em>(not made public)</em></td>
		<td><input id="com-email" name="emaulAddress" value="#HTMLEditFormat(FORM.emaulAddress)#" type="text" class="commentField" /></td>
		</tr>
	</cfif>
	<tr class="winnie">
		<td align="left" valign="top">Your Email Address <em>(not made public)</em></td>
		<td valign="top"><input id="com-email" name="emailAddress" value="#HTMLEditFormat(FORM.emailAddress)#" type="text" class="commentField" /></td>
	</tr>
	<tr>
	<td align="left" valign="top">Your Comment</td>
	<td valign="top"><textarea id="com-comment" rows="10" name="comment" cols="50" class="commentField">#HTMLEditFormat(FORM.comment)#</textarea></td>
	</tr>
	<tr>
	<td align="right" valign="top" colspan="2"><input type="submit" name="btn_comment_submit" value="Preview"></td></tr>

	</table>
	</form>
	</div>
</cfoutput>