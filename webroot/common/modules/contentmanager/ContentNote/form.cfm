<cfinvoke component="com.ContentManager.ContentNoteHandler" 
	method="GetContentNoteQuery" 
	returnVariable="qryGetContentNoteQuery"
	ContentID="#MyContent.GetProperty('ContentID')#">
<cfif FormMode IS "Validate" and MyContentNote.GetProperty("ContentNote") IS "" and qryGetContentNoteQuery.RecordCount IS "0">
	<cfif qryGetContentNoteQuery.RecordCount GT "0">
		<cfoutput query="qryGetContentNoteQuery">
			<TR valign="top" bgcolor="bac0c9"><TD>&nbsp;</TD>
			<TD>#Userlogin#<BR>#DateFormat(ContentNoteDate)# #TimeFormat(ContentNoteDate)#</TD><TD bgcolor="EAEAEA">
			#Replace(ContentNote,"#Chr(10)#", "<BR>","ALL")#
			</TD></TR>	
		</cfoutput>
	</cfif>
<cfelse>
	<TR valign="top" bgcolor="bac0c9"><TD colspan="3"><b>Notes</b></TR></tr>	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="textarea"
		caption="New Note" 
		ObjectName="MyContentNote"
		PropertyName="ContentNote"
		cols="50" rows="7"
		EscapeCRLF="No"
		Required="N">
</cfif>