function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
  highlightitem="";
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function tmt_findObj(n){
	var x,t; if((n.indexOf("?"))>0&&parent.frames.length){t=n.split("?");
	x=eval("parent.frames['"+t[1]+"'].document.getElementById('"+t[0]+"')");
	}else{x=document.getElementById(n)}return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments;
  document.MM_sr=new Array; 
  for(i=0;i<(a.length-2);i+=3){
   if ((x=MM_findObj(a[i]))!=null) {
   	document.MM_sr[j++]=x;
	//alert(show_props(x, 'this'));
	if(!x.oSrc) {x.oSrc=x.src;}
	x.src=a[i+2];
	}
   }
}
var isMinNS4 = (navigator.appName.indexOf("Netscape") >= 0 && parseFloat(navigator.appVersion) >= 4) ? 1 : 0;
function img_act(img1Name,state) {
  window.status = " ";
  if (document.images) {
  	if (img1Name.length > 0) {
  		document[img1Name].src = eval(img1Name + "_" + state + ".src");
  	}
  }
 }
function MM_showHideLayers() { //v3.0A Modified by Al Sparber and Massimo Foti for NN6 Compatibility
  var i,p,v,obj,args=MM_showHideLayers.arguments;if(document.getElementById){
   for (i=0; i<(args.length-2); i+=3){obj=tmt_findObj(args[i]);v=args[i+2];
   v=(v=='show')?'visible':(v='hide')?'hidden':v;
   if(obj)obj.style.visibility=v;}} else{
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { //alert(args[i]);
  v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }}
}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}



function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function PopupPic(sPicURL) { 
     window.open(sPicURL, "","resizable=1,HEIGHT=200,WIDTH=200"); 
} 

function SlideShowPopup(sPicURL) { 
    window.open(sPicURL, "","scrollbars=1,resizable=1,HEIGHT=460,WIDTH=535"); 
}

function addBookmark(url,title){
	if( window.external && document.all) { // IE Favorite
		window.external.AddFavorite( url, title); }
	else if(window.sidebar) { // Mozilla Firefox Bookmark
		window.sidebar.addPanel(title, url,"");
	} 
	else if(window.opera && window.print) { // Opera Hotlist
		return true; }	
}

// recent popular module toggling
function togglePopular() {
	if(document.getElementById && document.createTextNode) {
		document.getElementById('recent-comments').className='';
		document.getElementById('recent-popular').className='active';
		document.getElementById('listcom').className='hide';
		document.getElementById('listpop').className='recent-list';
	}
}

function toggleRecent() {
	if(document.getElementById && document.createTextNode) {
		document.getElementById('recent-popular').className='';
		document.getElementById('recent-comments').className='active';
		document.getElementById('listpop').className='hide';
		document.getElementById('listcom').className='recent-list';
	}
}