// Browser Detection for All browsers except IE related
// Writen for Thirdwave LLC
// By Tad Renstrom
// June 16, 2008

var ua = navigator.userAgent.toLowerCase();
var stringpositionOS,browser,version,data;

//Please note this is for use with none Internet Explorer Browsers
//If you want to have special style sheets for IE please use IE Comment Hack.

//Browser Defined
// firefox = Firefox
// opera = Opera
// netscape = Netscape
// camino = Camino
// konqueror = Konqueror
// safari = Safari

//OS Defined
// linux = Linux
// x11 = Unix
// mac = Mac
// win = Windows
// any = Any OS

function detect(os,browser,path) {
   stringpositionOS = ua.indexOf(os) + 1;
   data = os;
   //return stringpositionOS;
   
   stringpositionBrowser= ua.indexOf(browser) + 1;
   //alert(ua)
   //alert(stringpositionOS+" "+stringpositionBrowser)
   //If browser and os is found to be required create style import
   if(stringpositionOS > 0 && stringpositionBrowser > 0 && browser != "safari" || os == "any" && stringpositionBrowser > 0 && browser != "safari"){
	    //selects header tag in HTML
		headerSpace=document.getElementsByTagName("head")[0];
		//create Styles tag
		createStyle=document.createElement('style');
		//adds attribute for CSS
		createStyle.setAttribute('type', 'text/css');
		//Sets import of style sheet
		createStyle.innerHTML="@import url("+path+");";
		//Inserts into page
	  	headerSpace.appendChild(createStyle);
	   }
	 
	//For Safari only as it is almost as stupid as IE 
	if(stringpositionOS > 0 && stringpositionBrowser > 0 && browser == "safari" || os == "any" && stringpositionBrowser > 0 && browser == "safari"){
		//alert("safari")
		theTag='<style type="text/css">@import url('+path+');</style>';
		document.write(theTag)
		}
   
   }