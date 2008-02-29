/* 
Methods for resizing the flash stage at runtime.

setFlashWidth(divid, newW)
divid: id of the div containing the flash movie.
newW: new width for flash movie

setFlashWidth(divid, newH)
divid: id of the div containing the flash movie.
newH: new height for flash movie

setFlashSize(divid, newW, newH)
divid: id of the div containing the flash movie.
newW: new width for flash movie
newH: new height for flash movie

canResizeFlash()
returns true if browser supports resizing flash, false if not. 
*/
function setFlashWidth(divid, newW){
	document.getElementById(divid).style.width = newW+"px";
}
function setFlashHeight(divid, newH)
{
	document.getElementById(divid).style.height = newH+"px";		
}
function setFlashSize(divid, newW, newH){
	setFlashWidth(divid, newW);
	setFlashHeight(divid, newH);
}
function canResizeFlash(){
	var ua = navigator.userAgent.toLowerCase();
	var opera = ua.indexOf("opera");
	var safari = ua.indexOf( "safari" );
		//alert(ua.substr((safari+7),5))
	if( document.getElementById ){
		
		if(opera == -1)
		{
				
			if( safari != -1 )
		{
			//if safari.version >= 3 return "true", else return "false"
			if(ua.substr((safari+7),5)>=522.1){
			return "true";}else{
				return "false";
				}
			
		}else{return "true"; }
		}
						
		else 
		if(parseInt(ua.substr(opera+6, 1)) >= 7)
		{
			return "true";
		}
	}
	return "false";	
}