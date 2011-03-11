<cfparam name="ATTRIBUTES.FormAction" default="#CGI.SCRIPT_NAME#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="errorstring" default="">
<cfparam name="QueryString" default="#CGI.QUERY_STRING#"/>
<cfparam name="Attributes.PageTitle" default=""/>
<cfparam name="FORM.FeedBackSearch" default=""/>
<cfif attributes.pageTitle neq "General Feedback">
	<cfset CategoryID = Val(MVCid)/>
<cfelse>
	<cfset CategoryId = 0/>
</cfif>
<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>
<cfset CheckMark="<b style=""color:green;font-family:courier new;"">*</b>">
<cfset NoCheckMark="<b style=""color:red;"">x</b>">

<cfif Isdefined("form.mvpa")>
	<cfswitch expression="#form.mvpa#">
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="Modify">
		</cfcase>
	</cfswitch>
</cfif>
<cfparam name="ThisPage" default=0/>
<cfif isDefined("session.FeedbackFilter") and session.FeedbackFilter neq "">
<cfelse>
	<cfset Session.FeedbackFilter = ""/>
</cfif>
<cfset Session.FeedSortBy = "DateEntered"/>
<cfset Session.FeedSortDir = "ASC"/>
<cfif not isDefined("Session.feedbacksearch")>
	<cfset session.feedbacksearch = ""/>
</cfif>
<!--- their are two forms here - filter and change status updater - lets handle filter first --->
<cfif isDefined("form.ChangeFeedbackFilter") and form.ThisFilter neq "">
	<cfif form.ThisFilter eq "-1">
		<cfset Session.FeedbackFilter = ""/>
	<cfelse>
		<cfset Session.FeedbackFilter = Form.ThisFilter/>
	</cfif>
</cfif> <!--- change filter - easy enough --->
<!--- lets handle the updates now --->
<cfif isDefined("form.UpdateFeedbackStatus") and form.UpdateFeedBackStatus eq "1">
	<cfloop list="#FORM.FeedbackID#" index="i">
		<cfquery name="UpdateFeedbackStatus" datasource="#application.dsn#">
			UPDATE	t_Feedback
			SET		StatusID = <cfqueryparam value="#evaluate("form.#i#_StatusID")#" cfsqltype="cf_sql_integer">
			WHERE	FeedbackID = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfloop>
</cfif> <!--- update status request --->
<!--- we also need to handle and maintain sorts - best to be done in session --->
<cfif listContains(#QueryString#,"FeedSortBy","&")>
	<cfset session.FeedSortBy = URL.FeedSortBy/>
	<cf_AddToQueryString queryString="#QueryString#" OmitList="FeedSortBy">
</cfif> <!--- handling sort by --->
<cfif listContains(#QueryString#,"FeedSortDir","&")>
	<cfset session.FeedSortDir = URL.FeedSortDir/>
	<cf_AddToQueryString queryString="#QueryString#" OmitList="FeedSortDir">
</cfif> <!--- handle sort direction --->
<!--- gonna handle search --->

<cfif isDefined("FORM.FEEDBACKSEARCH") and FORM.FEEDBACKSEARCH neq "">
	<cfset session.feedbacksearch = form.feedbacksearch/>
</cfif>
<!--- end handling search --->
<!--- always run this - gets all the feedback --->
<cfquery name="GetFeedback" datasource="#application.dsn#">
	SELECT * FROM qry_GetFeedBack
	WHERE
	<cfif Session.FeedbackFilter neq "">StatusId = <cfqueryparam value="#Session.FeedbackFilter#" cfsqltype="cf_sql_integer"> AND</cfif>
	<cfif attributes.pagetitle neq "General Feedback">CategoryId = <cfqueryparam value="#CategoryId#" cfsqltype="cf_sql_integer"> AND</cfif>
	<cfif isDefined("session.FeedBackSearch") and session.FeedBackSearch neq "">
		ThisFeedBackId IN (SELECT FeedbackId from t_Feedback 
							WHERE 	FromName 		LIKE <cfqueryparam value="%#session.FeedBackSearch#%" cfsqltype="cf_sql_varchar">
							OR 		FromEmail 		LIKE <cfqueryparam value="%#session.FeedBackSearch#%" cfsqltype="cf_sql_varchar">
							OR 		Comments 		LIKE <cfqueryparam value="%#session.FeedBackSearch#%" cfsqltype="cf_sql_varchar">
							OR		CategoryName	LIKE <cfqueryparam value="%#session.FeedBackSearch#%" cfsqltype="cf_sql_varchar">) AND
	</cfif>
	1 = 1
	ORDER BY #Session.FeedSortBy# #Session.FeedSortDir#
</cfquery>
<!--- run every time, get status for feedback --->
<cfquery name="GetStatus" datasource="#application.dsn#">
	SELECT LabelID, LabelName FROM t_Label where LabelGroupID = 700 ORDER BY LabelPriority
</cfquery>
<!--- begin display --->
<table width="100%">
	<tr valign="top" bgcolor="BAC0C9"><TD colspan="2"><b><cfif attributes.pagetitle neq "General Feedback">Feedback on this Page<cfelse>General Feedback</cfif> </b></TD></tr>
	<tr bgcolor="EAEAEA"><td bgcolor="bac0c9">&nbsp;</td><TD align="center" bgcolor="eaeaea">
		<div align="left">
			<table width="100%"  border="0" cellpadding="0" bgcolor="white">
				<cfoutput>
					<tr bgcolor="bac0c9">
						<td colspan="<cfif attributes.pagetitle eq "General FeedBack">5<cfelse>4</cfif>">
						<form action="#FormPage#?#QueryString#" method="post" name="form_FeedbackFilter">
						<div align="right">
							<p>Show Feedback with Status
							<input type="hidden" name="CategoryId" value="#CategoryID#"/>
							<input type="hidden" name="MVps" value="2"/>
							<input type="hidden" name="MVEid" value="1"/>
							<input type="hidden" name="ChangeFeedbackFilter" value="1"/>
							<select name="ThisFilter">
								<option value="-1">No Filter</option>
								<cfloop query="GetStatus">
									<option value="#getStatus.labelID#" <cfif Session.FeedbackFilter eq getStatus.labelID>selected</cfif>>#getStatus.LabelName#</option>
								</cfloop>
							</select>
							<input type="submit" name="Submit" value="FILTER"></p>
							<cfif attributes.pagetitle eq "General FeedBack">
								<p>Search Text Fields <input type="text" name="FeedbackSearch" value="#session.FeedBackSearch#"/> <input type="submit" value="SEARCH"/></p>
							</cfif>
						</div></form> <!--- end filter form ---></td>
					</tr>
					<!--- still need to handle the sort direction - this should default to ASC unless otherwise specified --->
					<tr bgcolor="bac0c9"> <!--- headers --->
						<td bgcolor="bac0c9"><strong><a href="#FormPage#?#QueryString#&FeedSortBy=StatusID&FeedSortDir=<cfif session.FeedSortBy eq "StatusID" AND session.FeedSortDir eq "ASC">DESC<cfelse>ASC</cfif>"><cfif session.FeedSortBy eq "StatusID"><cfif session.FeedSortDir eq "DESC"> <img src="/common/images/widget_arrow_down.gif" width="19" height="9" border="0"><cfelse> <img src="/common/images/widget_arrow_up.gif" width="19" height="9" border="0"></cfif></cfif>Status</a></strong></td>
						<cfif attributes.pagetitle eq "General Feedback">
							<td bgcolor="bac0c9"><strong><a href="#FormPage#?#QueryString#&FeedSortBy=CategoryName&FeedSortDir=<cfif session.FeedSortBy eq "CategoryName" AND session.FeedSortDir eq "ASC">DESC<cfelse>ASC</cfif>"><cfif session.FeedSortBy eq "CategoryName"><cfif session.FeedSortDir eq "DESC"> <img src="/common/images/widget_arrow_down.gif" width="19" height="9" border="0"><cfelse> <img src="/common/images/widget_arrow_up.gif" width="19" height="9" border="0"></cfif></cfif>Page</a></strong></td>
						</cfif>
						<td nowrap bordercolor="0" bgcolor="bac0c9"><a href="#FormPage#?#QueryString#&FeedSortBy=DateEntered&FeedSortDir=<cfif session.FeedSortBy eq "DateEntered" AND session.FeedSortDir eq "ASC">DESC<cfelse>ASC</cfif>"><strong><cfif session.FeedSortBy eq "DateEntered"><cfif session.FeedSortDir eq "DESC"> <img src="/common/images/widget_arrow_down.gif" width="19" height="9" border="0"><cfelse> <img src="/common/images/widget_arrow_up.gif" width="19" height="9" border="0"></cfif></cfif>Post Date</strong></a><strong> </strong></td>
						<td bgcolor="bac0c9"><strong><a href="#FormPage#?#QueryString#&FeedSortBy=FromName&FeedSortDir=<cfif session.FeedSortBy eq "FromName" AND session.FeedSortDir eq "ASC">DESC<cfelse>ASC</cfif>"><cfif session.FeedSortBy eq "FromName"><cfif session.FeedSortDir eq "DESC"> <img src="/common/images/widget_arrow_down.gif" width="19" height="9" border="0"><cfelse> <img src="/common/images/widget_arrow_up.gif" width="19" height="9" border="0"></cfif></cfif>Name</a></strong></td>
						<td><strong>Comments</strong></td> <!--- end headers --->
					</tr>
					<form action="#FormPage#?#QueryString#" method="post" name="form_Feedback">
					<input type="hidden" name="CategoryId" value="#CategoryID#"/>
					<input type="hidden" name="MVps" value="2"/>
					<input type="hidden" name="MVEid" value="1"/>
					<input type="hidden" name="UpdateFeedbackStatus" value="1"/>
					<cfloop query="getFeedback">
						<input type="hidden" name="FeedbackID" value="#getFeedback.ThisFeedbackID#"/>
						<tr valign="top" bgcolor="eaeaea">
							<td>
								<select name="#getFeedback.ThisFeedbackID#_StatusID">
									<cfloop query="GetStatus">
										<option value="#getStatus.labelID#" <cfif getFeedback.StatusID eq getStatus.labelID>selected</cfif>>#getStatus.LabelName#</option>
									</cfloop>
								</select></td>
							<cfif attributes.pagetitle eq "General Feedback">
								<td>#getFeedBack.CategoryName#</td>
							</cfif>
							<td nowrap>#APPLICATION.utilsObj.OutputDateTime(getFeedBack.DateEntered)#</td>
							<td nowrap>#getFeedback.FromName#<br>(<a href="mailto:#getFeedback.FromEmail#">#getFeedback.FromEmail#</a>) </td>
							<td><p>#getFeedback.comments#</p></td>
						</tr>
					</cfloop>
					<tr bgcolor="EAEAEA">
						<td bgcolor="bac0c9">&nbsp;</td>
						<TD align="center" bgcolor="eaeaea" <cfif ThisPage eq "General Feedback">colspan="5"<cfelse>colspan="4"</cfif>>
						<div align="left"></div>
						<div align="left"><cfif GetFeedback.Recordcount lt 1>No feedback items meet your criteria.<cfelse><input type="submit" value="UPDATE"/></cfif></div></TD>
					</tr>
					</form>
				</cfoutput>
			</table>
		</div></td>
	</tr>
</table>


