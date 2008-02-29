<cfsetting showdebugoutput="No">
<cffile action="UPLOAD" 
	filefield="new_file" 
	destination="#APPLICATION.WebrootPath#common\incoming" 
	nameconflict="MAKEUNIQUE">
<cfoutput>/common/incoming/#File.ServerFile#</cfoutput>