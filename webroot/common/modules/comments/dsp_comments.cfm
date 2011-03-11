<cfparam name="URL.pff" default="0">
<cfif URL.pff NEQ 2>
	
	<cfobject component="com.ContentManager.CommentHandler"
		name="MyCommentHandler">
	<cfset MyCommentHandler.init()>

	<cfparam name="ATTRIBUTES.EntityName" default="">
	<cfparam name="ATTRIBUTES.EntityID" default="">
	<cfparam name="ATTRIBUTES.AllowComments" default="1">
	<cfparam name="ATTRIBUTES.DisplayArchiveMessage" default="0">
	<cfparam name="ATTRIBUTES.CommentNotificationEmail" default="">
	<cfparam name="ATTRIBUTES.PageTitle" default="">
	<cfif ATTRIBUTES.EntityName NEQ "" AND ATTRIBUTES.EntityID NEQ "">
		<cfinclude template="inc_form_action.cfm">
		<cfif isPreview>
			<cfinclude template="inc_preview.cfm">
		<cfelse>
			<cfinclude template="inc_comment_list.cfm">
			<cfif Val(ATTRIBUTES.DisplayArchiveMessage)>
				<div class="body">
					<p><h3>Add a Comment</h3></p>
					<p><em>Comments may no longer be added to this page. If you feel the discussion has been archived in error, please <a href="/content.cfm/about-contact">contact us</a>.</em></p>
				</div>
			</cfif>
			<cfif Val(ATTRIBUTES.AllowComments)>
				<cfinclude template="inc_form.cfm">
			</cfif>
		</cfif>
	</cfif>
</cfif>