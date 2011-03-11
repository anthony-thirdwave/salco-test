<cfparam name="SESSION.UserName" default="">
<cfparam name="FORM.name" default="#ReReplace(SESSION.UserName,'[ ]',' ','all')#">
<cfparam name="FORM.emaulAddress" default="">
<cfparam name="FORM.emailAddress" default="">
<cfparam name="FORM.linkURL" default="">
<cfparam name="FORM.comment" default="">
<cfparam name="FORM.UserTxt" default="">
<cfparam name="commentError" default="">
<cfparam name="isPreview" default="0">
<cfset thisDomain="http://#CGI.HTTP_Host#">

<cfif IsDefined("FORM.btn_comment_submit") AND Left(CGI.HTTP_REFERER,Len(thisDomain)) EQ thisDomain>
	<cfset FORM.name=Trim(FORM.name)>
	<cfset FORM.emaulAddress=Trim(FORM.emaulAddress)>
	<cfset FORM.linkURL=Trim(FORM.linkURL)>
	<cfset FORM.comment=Trim(FORM.comment)>
	
	<cfif Val(SESSION.UserID) LTE "0">
		<cfif FORM.name EQ "">
			<cfset commentError=commentError & "<li>Please enter your name.</li>">
		</cfif>
		<cfif FORM.emaulAddress EQ "">
			<cfset commentError=commentError & "<li>Please enter your email address.</li>">
		<cfelse>
			<cfmodule name="3w.errorcheck.validateemail" email="#FORM.emaulAddress#">
			<!--- check if valid format --->
			<cfif ValidateEmailStatus GTE "200">
				<cfset commentError=commentError & "<li>Please enter a valid email address.</li>">
			</cfif>
		</cfif>
	</cfif>
	<cfif FORM.comment EQ "">
		<cfset commentError=commentError & "<li>Please enter a comment.</li>">
	</cfif>
	
	<cfif FORM.btn_comment_submit IS "Post" And commentError EQ "" and FORM.EMailAddress IS "">
		<cfset thisLocation="#CGI.request_uri#?#CGI.Query_String#">
		<cfinvoke component="#MyCommentHandler#" 
			method="InsertComment"
			EntityName="#ATTRIBUTES.EntityName#"
			EntityID="#ATTRIBUTES.EntityID#"
			CommenterName="#FORM.name#"
			emailAddress="#FORM.emaulAddress#"
			linkURL="#FORM.linkURL#"
			comment="#FORM.comment#"
			senderID="#Val(SESSION.UserID)#"
			returnVariable="InsertComment">
		
		<cfif ATTRIBUTES.CommentNotificationEmail IS NOT "">
			<cfmail to="#ATTRIBUTES.CommentNotificationEmail#" from="#APPLICATION.contactEmail#" subject="New comment posted to ""#ATTRIBUTES.PageTitle#""">
NAME: #FORM.name# (#FORM.emaulAddress#)

POSTED TO: #ATTRIBUTES.PageTitle#
http://#CGI.HTTP_Host#/#thisLocation#

COMMENT:
#FORM.comment#

#Now()#
			</cfmail>
		</cfif>
		<cflocation addtoken="no" url="#thisLocation###commentsheader">
	<cfelse>
		<cfif commentError EQ "">
			<cfset isPreview="1">
		</cfif>
	</cfif>
</cfif>
