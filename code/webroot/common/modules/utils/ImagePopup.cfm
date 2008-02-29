<cfsetting showdebugoutput="No" >
<cfparam name="ThisImage" default="">
<cfif IsDefined("URL.Image") AND URL.Image IS NOT "">
	<cfset ThisImage=URL.Image>
</cfif>

<HTML> 
<HEAD> 
 <TITLE><cfoutput>#APPLICATION.CompanyName#</cfoutput></TITLE>
 <script language='javascript'> 
   var arrTemp=self.location.href.split("?"); 
   var picUrl = (arrTemp.length>0)?arrTemp[1]:""; 
   var NS = (navigator.appName=="Netscape")?true:false; 
<cfif listLast(ThisImage,".") is "swf">
	function FitPic() {
       iWidth = (NS)?window.innerWidth:document.body.clientWidth; 
       iHeight = (NS)?window.innerHeight:document.body.clientHeight; 
       iWidth = 550 - iWidth; 
       iHeight = 400 - iHeight; 
       window.resizeBy(iWidth, iHeight); 
       self.focus(); 
     }; 
<cfelse>
     function FitPic() { 
       iWidth = (NS)?window.innerWidth:document.body.clientWidth; 
       iHeight = (NS)?window.innerHeight:document.body.clientHeight; 
       iWidth = document.images[0].width - iWidth; 
       iHeight = document.images[0].height - iHeight; 
       window.resizeBy(iWidth, iHeight); 
       self.focus(); 
     }; 
</cfif>
 </script>
</HEAD> 
<BODY onload="FitPic();" leftmargin=0 topmargin=0 marginwidth="0" marginheight="0">
<cfoutput>
<cfif listLast(ThisImage,".") is "swf">
		<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,0,0" width="550" height="400" id="selectedPopUp" align="middle">
	<param name="allowScriptAccess" value="sameDomain" />
	<param name="movie" value="#ThisImage#" />
	<param name="quality" value="high" />
	<param name="bgcolor" value="white" />
	<embed src="#ThisImage#" quality="high" bgcolor="white" width="550" height="400" name="selectedPopUp" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
	</object>
<cfelse>
	<img src="#ThisImage#" border="0" alt="">
</cfif>
</cfoutput>
</BODY> 
</HTML>

