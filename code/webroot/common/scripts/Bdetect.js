// Browser Detect

var ua = navigator.userAgent.toLowerCase();
var os,browser,version,data;

if (detect('konqueror')) {browser = "Konqueror"; os = "Linux";}
else if (detect('safari')) browser = "Safari";
else if (detect('omniweb')) browser = "OmniWeb";
else if (detect('netscape')) browser = "Netscape";
else if (detect('firefox')) browser = "Firefox";
else if (detect('opera')) browser = "Opera";
else if (detect('webtv')) browser = "WebTV";
else if (detect('icab')) browser = "iCab";
else if (detect('msie')) browser = "Internet Explorer";
else if (!detect('compatible')) {browser = "Netscape Navigator"; version = ua.charAt(8);}
else browser = "An unknown browser";

if (!version) version = ua.charAt(stringposition + data.length);

if (!os) {
   if (detect('linux')) os = "Linux";
   else if (detect('x11')) os = "Unix";
   else if (detect('mac')) os = "Mac";
   else if (detect('win')) os = "Windows";
   else os = "An unknown operating system";
}

function detect(text) {
   stringposition = ua.indexOf(text) + 1;
   data = text;
   return stringposition;
   }