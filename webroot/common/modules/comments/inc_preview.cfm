<cfoutput>
	<div class="body">
	<h3>Comments<a name="addcomment"></a>: Preview</h3>
	<p style="padding:5px 0px 0px 0px;">To post this comment, click the "Post" button below.</p>
	<ol>
		<li>
		<a href="#CGI.Request_URI#" class="com-link" title="Link to this comment" style="display:none;"><img src="/common/images/template/icon-comment.gif" alt="link to this comment" /></a>
		#MyCommentHandler.formatComment(HTMLEditFormat(FORM.comment))#
		<em>Posted by:
		<cfif linkURL NEQ "">
			<cfif Left(LinkURL,"7") is not "http://">
				<cfset ThisLink="http://#linkURL#">
			<cfelse>
				<cfset ThisLink="#linkURL#">
			</cfif>
			<a href="#ThisLink#" target="_blank">#HTMLEditFormat(FORM.Name)#</a>
		<cfelse>
			#HTMLEditFormat(FORM.Name)#
		</cfif> on #DateFormat(Now(),'mm.dd.yy')# at #TimeFormat(now(),'hh:mm')#</em>
		</ol>
		<form id="comment-form" action="#CGI.Request_URI#?#CGI.Query_String###addcomment" method="post">
			<input type="hidden" id="commentMethod" name="commentMethod" value="post" />
			<input type="hidden" name="name" value="#HTMLEditFormat(FORM.name)#" />
			<input type="hidden" name="emaulAddress" value="#HTMLEditFormat(FORM.emaulAddress)#" />
			<input type="hidden" name="emailAddress" value="#HTMLEditFormat(FORM.emailAddress)#" />
			<input type="hidden" name="linkURL" value="#HTMLEditFormat(FORM.linkURL)#" />
			<input type="hidden" name="comment" value="#HTMLEditFormat(FORM.comment)#" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td align="right" valign="top" colspan="3"><input type="submit" name="btn_comment_submit" value="Post"></td></tr>
			</table>
			</p>
		</form>
	</div>
</cfoutput>