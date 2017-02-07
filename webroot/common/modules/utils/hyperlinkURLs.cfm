<cfsilent>
<cfparam name="attributes.stringToMarkup" default="">
<cfparam name="attributes.hrefTarget" default="_self">
<cfparam name="attributes.hyperlinkClass" default="">
<cfparam name="attributes.replaceLineBreaks" default="False" type="boolean">

<cfscript>
	// Check to see if you should add CLASS
	if (len(trim(attributes.hyperlinkClass))){classParam=" class=""" & attributes.hyperlinkClass & """";}
	else {classParam="";}

	hyperlinkedString="";
	WebPattern = "\b((http)\S+)\b";
	EmailPattern = "\b((\S+@)\S+)\b";
	// Replace HREF Links
	hyperlinkedString = REReplace(attributes.stringToMarkup,WebPattern,"<a href=""\1"" target=""#attributes.hrefTarget#""#classParam#>\1</a>","ALL");
	// Replace Email Addresses
	hyperlinkedString = REReplace(hyperlinkedString,EmailPattern,"<a href=""mailto:\1""#classParam#>\1</a>","ALL"); 
	// Replace Line Breaks
	if(attributes.replaceLineBreaks){
		hyperlinkedString = REReplace(hyperlinkedString,"(\r|\n)","<br>","ALL"); 
	}
</cfscript>
<cfset caller.hyperlinkedString=hyperlinkedString>
</cfsilent>