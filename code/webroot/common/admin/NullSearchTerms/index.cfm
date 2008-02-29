<cfset CheckAdminResourceID="1">

<cfmodule template="/common/modules/admin/dsp_AdminHeader.cfm" 
	PageTitle="Search Terms" IncludeOverlibJS="1"
	PageHeader="<a href='/common/admin/' class=""white"">Main Menu</A> | Search Terms">

	
	
<cfparam name="paramTrackingType" default="">
<cfparam name="paramName" default="">
<cfparam name="paramStatus" default="34">

<cfset DevNull=DeleteClientVariable("OrderBy")>
<cfset DevNull=DeleteClientVariable("OrderAsc")>

<cfparam name="OrderBy" default="TrackingTypeName">
<cfparam name="OrderAsc" default="1">
<cfparam name="ShowOnly" default="all">
<cfparam name="ShowOnlyProductID" default="all">
<cfparam name="daterange" default="thisweek">

<cfquery name="GetTrackingStatus" datasource="#APPLICATION.DSN#">
	SELECT * FROM t_Label Where LabelGroupID=1000 order by labelpriority
</cfquery>
<cfquery name="GetTrackingType" datasource="#APPLICATION.DSN#">
	SELECT * FROM t_Label Where LabelGroupID=900 order by labelpriority
</cfquery>
<cfquery name="GetSearchTerms" datasource="#APPLICATION.DSN#">
	SELECT * FROM qry_GetSearchTracking WHERE 1=1 
	<cfswitch expression="#daterange#">
		<cfcase value="Today">
			AND DateLastUpdated >= #CreateDate(Year(now()),Month(now()),Day(now()))#
		</cfcase>
		<cfcase value="yesterday">
			AND DateLastUpdated >= #DateAdd("d",-1,CreateDate(Year(now()),Month(now()),Day(now())))#
			AND DateLastUpdated < #CreateDate(Year(now()),Month(now()),Day(now()))#
		</cfcase>
		<cfcase value="thisweek">
			<cfset firstofweek=CreateODBCDate(DateAdd("d", 1-DayOfWeek(Now()),CreateDate(Year(now()),Month(now()),Day(now()))))>
			<cfset endofweek=CreateODBCDate(DateAdd("d", 7, firstofweek))>
			AND DateLastUpdated >= #firstofweek#
		</cfcase>
		<cfcase value="lastweek">
			<cfset firstofweek=CreateODBCDate(DateAdd("d", 1-DayOfWeek(Now()), Now()))>
			<cfset firstofweek=DateAdd("ww",-1,firstofweek)>
			<cfset endofweek=CreateODBCDate(DateAdd("d", 7, firstofweek))>
			AND DateLastUpdated >= #firstofweek#
			AND DateLastUpdated < #endofweek#
		</cfcase>
		<cfcase value="thismonth">
			<cfset firstofmonth=CreateODBCDate(CreateDate(year(Now()), month(now()), 1))>
			<cfset endofmonth=CreateODBCDate(DateAdd("d", DaysInMonth(Now()), firstofmonth))>
			AND DateLastUpdated >= #firstofmonth#
		</cfcase>
		<cfcase value="lastmonth">
			<cfset firstofmonth=CreateODBCDate(CreateDate(year(Now()), month(now()), 1))>
			<cfset firstofmonth=DateAdd("m",-1,FirstOfMonth)>
			<cfset endofmonth=CreateODBCDate(DateAdd("d", DaysInMonth(Now()), firstofmonth))>
			AND DateLastUpdated >= #firstofmonth#
			AND DateLastUpdated < #endofmonth#
		</cfcase>
		<cfcase value="thisyear">
			<cfset firstofyear=CreateODBCDate(CreateDate(year(Now()), 1, 1))>
			<cfset endofyear=CreateODBCDate(DateAdd("d", DaysInMonth(Now()), firstofyear))>
			AND DateLastUpdated >= #firstofyear#
		</cfcase>
	</cfswitch>
	AND
	<cfif TRim(ParamName) IS NOT "">
		(
		<cfloop index="ThisParam" list="#ParamName#" delimiters=" ">		
			(TrackingKeywords like '%#ThisParam#%') OR
		</cfloop>1=0)
	<cfelse>
		1=1
	</cfif>
	AND
	<cfif ParamStatus IS "" OR ParamStatus IS "All">
		1=1
	<cfelse>
		TrackingStatusID=#Val(ParamStatus)#
	</cfif>
	AND
	<cfif paramTrackingType IS "" OR paramTrackingType IS "All">
		1=1
	<cfelse>
		TrackingTypeID=#Val(paramTrackingType)#
	</cfif>
	
	ORDER BY #OrderBy# <cfif OrderAsc> ASC<Cfelse> DESC</cfif> <cfif OrderBy IS NOT "TrackingCount">,TrackingCount</cfif> 
	
</cfquery>


<cfset FieldNameList="paramTrackingType,paramstatus,paramname,ParamOrder,showonly,daterange">
<cfset FieldList="">
<cfloop index="ThisFieldName" list="#FieldNameList#">
	<cfif isdefined("#ThisFieldName#")>
		<cfif Len(trim(Evaluate("#ThisFieldName#"))) IS NOT "0">
			<cfset FieldList=ListAppend(FieldList,"#ThisFieldName#=#URLEncodedFormat(evaluate('#ThisFieldName#'))#","&")>
		</cfif>
	</cfif>
</cfloop>
<table cellspacing="0" cellpadding="3">
<tr valign="top" bgcolor="#bac0c9">
<cfoutput>
<cfif OrderAsc>
	<cfset ThisOrderAsc="0">
	<cfset arrowimage="/common/images/widget_arrow_down2.gif">
<cfelse>
	<cfset ThisOrderASc="1">
	<cfset arrowimage="/common/images/widget_arrow_up2.gif">
</cfif>

<cfset l_Col="TrackingTypeName,StatusName,DateLastUpdated,TrackingKeywords,TrackingCount">
<cfset l_ColDescr="Type,Status, Date Last Searched,Phrase,Count">
<cfloop index="i" from="1" to="#ListLen(l_Col)#" step="1">
	<cfset ThisCol=ListGetAt(l_Col,i)>
	<Cfset ThisColDescr=ListGetAt(l_ColDescr,i)>
	<td valign="top" bgcolor="##999BB4">
	<cfif orderBy IS ThisCol>
		<p><b><cfif ThisCol IS "ChapterName" OR ThisCol IS "LastName"><cfelse><a href="index.cfm?OrderBy=#ThisCol#&OrderAsc=#ThisOrderAsc#&#FieldList#"><img src="#arrowimage#" border=0 alt=""></a></cfif>#ThisColDescr#</b></p>
	<cfelse>
		<p><b><cfif ThisCol IS "ChapterName" OR ThisCol IS "LastName"><cfelse><a href="index.cfm?OrderBy=#ThisCol#&OrderAsc=#OrderAsc#&#FieldList#"></cfif>#ThisColDescr#</A></b></p>
	</cfif>
	</td>
</cfloop>
<TD>&nbsp;</TD>
<cfset FieldNameList="OrderBy,OrderASC">
<cfloop index="ThisFieldName" list="#FieldNameList#">
	<cfif isdefined("#ThisFieldName#")>
		<cfif Len(trim(Evaluate("#ThisFieldName#"))) IS NOT "0">
			<cfset FieldList=ListAppend(FieldList,"#ThisFieldName#=#URLEncodedFormat(evaluate('#ThisFieldName#'))#","&")>
		</cfif>
	</cfif>
</cfloop>

</tr><form action="index.cfm" method="post"><input type="hidden" name="OrderAsc" value="#OrderAsc#">
<tr>
<td>
<select name="ParamTrackingType" onchange="this.form.submit();">
	<option value="ALL" <cfif ParamTrackingType IS "all">selected</cfif>>All</option>
	<cfloop query="GetTrackingType">
		<option value="#LabelID#" <cfif ParamTrackingType IS LabelID>selected</cfif>>#LabelName#</option>
	</cfloop>
</select>
</td>
<td>
<select name="ParamStatus" onchange="this.form.submit();">
	<option value="ALL" <cfif ParamStatus IS "all">selected</cfif>>All</option>
	<cfloop query="GetTrackingStatus">
		<option value="#LabelID#" <cfif ParamStatus IS LabelID>selected</cfif>>#LabelName#</option>
	</cfloop>
</select>
</td>
<td>
<select name="daterange" onchange="this.form.submit();">
<option value="today" <cfif DateRange IS "today">selected</cfif>>Today</option>
<option value="yesterday" <cfif DateRange IS "yesterday">selected</cfif>>Yesterday</option>
<option value="thisweek" <cfif DateRange IS "thisweek">selected</cfif>>This Week</option>
<option value="lastweek" <cfif DateRange IS "lastweek">selected</cfif>>Last Week</option>
<option value="thismonth" <cfif DateRange IS "thismonth">selected</cfif>>This Month</option>
<option value="lastmonth" <cfif DateRange IS "lastmonth">selected</cfif>>Last Month</option>
<option value="thisyear" <cfif DateRange IS "thisyear">selected</cfif>>This Year</option>
</select>
</td>
<td> 
<input type="text" name="paramName" value="#paramName#" size="25">
</td>
<td>&nbsp; 

</td><TD>&nbsp;</TD>
</tr>
<TR><td colspan="6" align="left"><input type="Submit" value="Search">&nbsp;&nbsp;<input type="reset"></td></TR>
</form>
</cfoutput>

<cfif GetSearchTerms.RecordCount GT "0">
	<cfset Counter="0">
	<cfoutput query="GetSearchTerms" group="TrackingID">
		<cfif ShowOnlyProductID IS "All">
			<cfset Counter=Counter+1>
			<CFIF (Counter MOD 2) IS 1><cfset BGColor="eaeaea"><cfelse><cfset BGColor="white"></cfif>
			<TR bgcolor="#bgcolor#">
			<TD>#TrackingTypeName#</TD>
			<td valign="top">
			<cfset CaptionText="<form action=\'_StatusChange.cfm?EditTrackingID=#TrackingID#&#FieldList#\' method=\'post\'><select name=\'NewStatus\'>">
			<cfset ThistrackingstatusID=trackingstatusID>
			<cfloop query="GetTrackingStatus">
				<cfif ThistrackingstatusID IS LabelID>
					<cfset CaptionText="#CaptionText#<option value=\'#labelID#\' selected>#LabelName#</option>">
					<cfset StatusName=LabelName>
				<cfelse>
					<cfset CaptionText="#CaptionText#<option value=\'#LabelID#\'>#LabelName#</option>">
				</cfif>
			</cfloop>
			<cfset CaptionText="#CaptionText#</select><BR><input type=\'submit\' value=\'change\'>">
			<cf_wddx_IsPacketValid packet="#PropertiesPacket#">
			<cfif WDDX_IsPacketValid>
				<cfwddx action="WDDX2CFML" input="#PropertiesPacket#" output="sTrackingProperties">
			<cfelse>
				<cfset sTrackingProperties=StructNew()>
			</cfif>
			<cfif StructKeyExists(sTrackingProperties,"aUserComments")>
				<cfset aUserComments=sTrackingProperties.aUserComments>
			<cfelse>
				<cfset aUserComments=ArrayNew(1)>
			</cfif>
			<cfif ArrayLen(aUserComments) GT "0">
				<cfset CaptionText="#CaptionText#<P>If you are changing the status to &quot;resolved&quot;, you may send an email to all those who searched on the term a short message point to new content.</P>subject<BR><input type=\'text\' size=\'20\' maxlength=\'128\' name=\'EditSubject\'><BR>&nbsp;<BR>body<BR><textarea name=\'EditMessage\' cols=\'20\' rows=\'5\'></textarea></form>">
			<cfelse>
				<cfset CaptionText="#CaptionText#</form>">
			</cfif>
			#statusName#<BR>
			<a href="javascript:void(0);" onClick="return overlib('#CaptionText#',STICKY, CAPTION, 'Change Status');">Change</A>
			</td>
			<td valign="top">#DateFormat(DateLAstUpdated)#</td>
			<td valign="top">#TrackingKeywords#</td>
			<td valign="top">#TrackingCount#</td>
			<TD>
			<cfif ArrayLen(aUserComments) GT "0">
				<a href="javascript:void(0);" onclick="window.open('CommentsUser.cfm?Tid=#TrackingID#','splash','toolbar=0,status=0,menubar=0,scrollbars=1,resizable=1,width=400,height=550');">See User Comments (#ArrayLen(aUserComments)#)</A>
			</cfif>
			</TD>
			</TR>
		</cfif>
	</cfoutput>
<cfelse>
	<TR><TD colspan="6" align="center"><b>No Records Found</b></TD></tR>
</cfif>
</table>
<cfmodule template="/common/modules/Admin/dsp_AdminFooter.cfm">