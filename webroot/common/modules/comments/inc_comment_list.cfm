<cfset GetComments=MyCommentHandler.getPublicComments(ATTRIBUTES.EntityName,ATTRIBUTES.EntityID)>

<cfif getComments.RecordCount GT 0>
	<div class="body">
	<h3>Comments<a name="commentsheader"></a></h3>
	<ol>
	<cfoutput query="getComments">
		<li>
			<a name="#CommentID#"></a><a href="#CGI.Request_URI####CommentID#" class="com-link" title="Link to this comment" style="display:none;"><img src="/common/images/template/icon-comment.gif" alt="link to this comment" /></a>
			#MyCommentHandler.formatComment(comment)#
			<em>Posted by:
			<cfif Val(SenderID) GT "0">
				<cfset ThisName="#UserFirstName# #UserMiddleName# #UserLastName#">
			<cfelse>
				<cfset ThisName="#Name#">
			</cfif>
			<cfif linkURL NEQ "" and HideURL IS NOT "1">
				<cfif Left(LinkURL,"7") is not "http://">
					<cfset ThisLink="http://#linkURL#">
				<cfelse>
					<cfset ThisLink="#linkURL#">
				</cfif>
				<a href="#ThisLink#" target="_blank">#ThisName#</a>
			<cfelse>
				#ThisName#
			</cfif> on #DateFormat(DateCreated,'mm.dd.yy')# at #TimeFormat(DateCreated,'hh:mm')#</em>
		</li>
	</cfoutput>
	</ol>
	</div>
</cfif>