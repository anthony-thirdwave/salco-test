<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="Comment Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Comment Manager">
	<div class="dashModuleWide">
	<div class="box2">
	<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">COMMENTS</div>
			<div class="ModuleBody2">

<cfset categorylist="">

<cfquery name="getCommentCount" datasource="#APPLICATION.USER_DSN#">
	SELECT TOP 100 PERCENT MAX(CM.DateCreated) AS MostRecentComment, 
	COUNT(CM.CommentID) AS CommentCount, C.CategoryAlias, C.CategoryName, 
	      C.SourceID, cm.EntityID, cm.EntityName
	FROM         t_Category C INNER JOIN
	                    t_Comment CM ON CM.EntityID = C.SourceID AND CM.EntityName = 't_Article' OR CM.EntityID = C.CategoryID AND 
	                    CM.EntityName = 't_Category'
	<cfif listfind(session.adminusergroupidlist,19005) and categorylist is not "">
		WHERE   C.categoryid in (#categorylist#)
	</cfif>
	GROUP BY C.CategoryAlias, C.SourceID, cm.EntityID, C.CategoryName,cm.EntityName
	ORDER BY MostRecentComment DESC
</cfquery>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>&nbsp;</td>
		<td><strong>Page</strong></td>
		<td><strong>Comment Count</strong></td>
		<td><strong>Most Recent Comment</strong></td>
		<td>&nbsp;</td>
		<!--- <td>Active Comment Count</td> --->
	</tr>
	<tr><td colspan="6">
		<div class="RuleSolid1"/>
	</td></tr>
	<cfoutput query="getCommentCount">
	<tr>
		<td>#CurrentRow#.</td>
		<td><a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank">#CategoryName#</a></td>
		<td>#CommentCount#</td>
		<td>#DateFormat(MostRecentComment,'m/dd/yyyy')# #TimeFormat(MostRecentComment,'h:mm tt')#</td>
		<td><a href="CommentModify.cfm?EntityID=#Val(EntityID)#&entityName=#URLEncodedFormat(EntityName)#"><img src="/common/images/admin/icon_edit.gif" border="0"> Edit Comments</a></td>
		<!--- <td>#ActiveCommentCount#</td> --->
	</tr>
	<tr><td colspan="6">
		<div class="RuleDotted1"/>
	</td></tr>
	</cfoutput>
	</table>
	
	
</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>
</cfmodule>