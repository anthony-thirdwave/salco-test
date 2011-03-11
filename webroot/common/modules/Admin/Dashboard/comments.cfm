<cfquery name="commentCount" datasource="#APPLICATION.USER_DSN#">
SELECT Count(CommentID) AS thisCount FROM t_Comment
WHERE DateCreated > #CreateODBCDateTime(DateAdd('d',-1,now()))#
</cfquery>
There have been <cfoutput>#commentCount.thisCount#</cfoutput> comments posted in the past 24 hours.
<br><a href="/common/admin/CommentManager"><strong>Manage Comments</strong></a>
