<cfobject component="com.ContentManager.CommentHandler"
	name="MyCommentHandler">
<cfset MyCommentHandler.init()>

<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Comment Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Comment Manager">
	<div class="dashModuleWide">
	<div class="box2">
	<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">COMMENTS</div>
			<div class="ModuleBody2">
<cfif isdefined("form.cancel")>
	<cflocation url="/common/admin/CommentManager/">
</cfif>
<cfif IsDefined("FORM.Submit")>
	<cfquery name="DeleteHighlight" datasource="#APPLICATION.USER_DSN#">
		update t_Comment 
		set HideURL=0
		WHERE EntityName = <cfqueryparam cfsqltype="cf_sql_carchar" value="#URL.EntityName#">
		AND EntityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EntityID#">
	</cfquery>
	<cfif IsDefined("FORM.commentID") AND FORM.commentID NEQ "">
		<cfquery name="deleteComments" datasource="#APPLICATION.USER_DSN#">
			DELETE FROM t_Comment 
			WHERE CommentID IN (<cfqueryparam value="#FORM.commentID#" cfsqltype="cf_sql_integer" list="yes">)
		</cfquery>
		<p><strong>The selected comments were deleted.</strong></p>
	</cfif>
	<cfif IsDefined("FORM.HideURLCommentID") AND FORM.HideURLCommentID NEQ "">
		<cfquery name="HighlightComments" datasource="#APPLICATION.USER_DSN#">
			update t_Comment 
			set HideURL=1
			WHERE CommentID IN (<cfqueryparam value="#FORM.HideURLCommentID#" cfsqltype="cf_sql_integer" list="yes">)
		</cfquery>
		<p><strong>The selected comments were updated.</strong></p>
	</cfif>
	<cfloop index="i" list="#form.Fieldnames#">
		<cfif findnocase("commentname",i)>
			<cfset CommentID = Replace(i,"COMMENTNAME_","")>
			<cfset CommentName = "form.#i#">
			<cfset CommentName = "#evaluate(commentname)#">
			<cfif CommentName NEQ "">
				<cfquery name="UpdateComments" datasource="#APPLICATION.USER_DSN#">
					Update T_Comment
					Set name = '#CommentName#'
					Where CommentID = #CommentID#
				</cfquery>
			</cfif>
		</cfif>
		<cfif findnocase("commenttext",i)>
			<cfset CommentID = Replace(i,"COMMENTTEXT_","")>
			<cfset CommentName = "form.#i#">
			<cfset CommentName = "#evaluate(commentname)#">
			<cfif CommentName NEQ "">
				<cfquery name="UpdateComments" datasource="#APPLICATION.USER_DSN#">
					Update T_Comment
					Set Comment = '#CommentName#'
					Where CommentID = #CommentID#
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<script language="javascript">
function selectAll(bool){
	if(isNaN(document.getElementById('commentForm').commentID.length))
		document.getElementById('commentForm').commentID.checked = bool;
	else{
		for(i=0;i<document.getElementById('commentForm').commentID.length;i++){
			document.getElementById('commentForm').commentID[i].checked = bool;
		}
	}
}
function confirmDelete(){
	return confirm('Are you sure you want to update/delete the selected comments?');
}
</script>

<cfquery name="getComments" datasource="#APPLICATION.USER_DSN#">
	SELECT LinkURL,Comment,DateCreated,Name,CommentID,HideURL, UserFirstName, UserLastName, EmailAddress FROM qry_GetComment 
	WHERE EntityName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.EntityName#">
	AND EntityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EntityID#">
	ORDER BY DateCreated DESC
</cfquery>
<cfparam name="form.name" default="">
<cfoutput>
<form action="?EntityID=#URL.EntityID#&EntityName=#URL.EntityName#" method="post" id="commentForm" name="commentForm">
</cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td colspan="3" align="right">
		<a href="/common/admin/CommentManager/">Back to list</a> / 
		<a href="javascript:selectAll(true);">Select All</a> / <a href="javascript:selectAll(false);">Deselect All</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;<input type="submit" name="submit" value="Update Selected" onClick="return confirmDelete();">
	&nbsp;&nbsp;
	<cfif IsDefined("FORM.Submit")>
		<input type="submit" name="cancel" value="Cancel">
	<cfelse>
		<input type="button" name="cancel" value="Cancel" onclick="javascript:history.go(-1)">
	</cfif></td>
</tr>
<tr><td colspan="3">
		<div class="RuleSolid1"/>
	</td></tr>
<script type="text/javascript" src="/common/scripts/instantedit.js"></script>
<script type="text/javascript">
  setVarsForm("");
</script>

<cfoutput query="getComments">
<tr>
	<td valign="top">#CurrentRow#.</td>
	<td>
		<span style="float:left">
			by #Name# (<a href="mailto:#EmailAddress#">#EmailAddress#</a>)
			<input type="Hidden" name="commentname_#CommentID#" id="name_#CommentID#" value="">
			<cfif linkURL NEQ "">
				(<a href="#linkURL#" target="_blank">#linkURL#</a>)
			</cfif>
			<em>#DateFormat(DateCreated,'ddd mmm dd, yyyy')#</em>
		</span>
		<p>&nbsp;</p>
		<span id="commenttext_#CommentID#" class="editText" style="background-color:E9E9E9;">#MyCommentHandler.formatComment(comment)#</span>
		<input type="Hidden" name="commenttext_#CommentID#" id="comment_#CommentID#" value="">
	</td>
	<td valign="top" width="20%" align="right">
	<cfif linkURL NEQ "">
		Hide URL?<input type="checkbox" name="HideURLCommentID" value="#CommentID#" <cfif HideURL IS "1">checked</cfif>>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	</cfif>
	Delete? <input type="checkbox" name="commentID" value="#CommentID#"></td>
</tr>
<tr><td colspan="3">
		<div class="RuleDotted1"/>
	</td></tr>
</cfoutput>
<tr>
	<td colspan="3" align="right">
	<a href="/common/admin/CommentManager/">Back to list</a>&nbsp;/&nbsp;
		<a href="javascript:selectAll(true);">Select&nbsp;All</a> / <a href="javascript:selectAll(false);">Deselect&nbsp;All</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;<input type="submit" name="submit" value="Update Selected" onClick="return confirmDelete();">
	&nbsp;&nbsp;
	<cfif IsDefined("FORM.Submit")>
		<input type="submit" name="cancel" value="Cancel">
	<cfelse>
		<input type="button" name="cancel" value="Cancel" onclick="javascript:history.go(-1)">
	</cfif></td>
</tr>
</table>
</form>

		</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>
</cfmodule>