<cfparam name="ATTRIBUTES.PDFFile" default="">
<cfif ATTRIBUTES.PDFFile IS NOT ""><cfoutput>
<object width="495" height="678" type="application/pdf" data="#ATTRIBUTES.PDFFile#?##zoom=52.1&amp;scrollbar=0&amp;toolbar=1&amp;navpanes=0">
<iframe frameborder="0" src="http://docs.google.com/gview?url=http%3A%2F%2F#CGI.Server_Name##ATTRIBUTES.PDFFile#&amp;embedded=true" style="width:495px; height:678px;"></iframe>
</object>
</cfoutput></cfif>