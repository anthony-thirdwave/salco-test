
//script by http://www.yvoschaap.com

//XMLHttpRequest class function
function datosServidor() {
};
datosServidor.prototype.iniciar = function() {
	try {
		// Mozilla / Safari
		this._xh = new XMLHttpRequest();
	} catch (e) {
		// Explorer
		var _ieModelos = new Array(
		'MSXML2.XMLHTTP.5.0',
		'MSXML2.XMLHTTP.4.0',
		'MSXML2.XMLHTTP.3.0',
		'MSXML2.XMLHTTP',
		'Microsoft.XMLHTTP'
		);
		var success = false;
		for (var i=0;i < _ieModelos.length && !success; i++) {
			try {
				this._xh = new ActiveXObject(_ieModelos[i]);
				success = true;
			} catch (e) {
			}
		}
		if ( !success ) {
			return false;
		}
		return true;
	}
}

datosServidor.prototype.ocupado = function() {
	estadoActual = this._xh.readyState;
	return (estadoActual && (estadoActual < 4));
}

datosServidor.prototype.procesa = function() {
	if (this._xh.readyState == 4 && this._xh.status == 200) {
		this.procesado = true;
	}
}

datosServidor.prototype.enviar = function(urlget,datos) {
	if (!this._xh) {
		this.iniciar();
	}
	if (!this.ocupado()) {
		this._xh.open("GET",urlget,false);
		this._xh.send(datos);
		if (this._xh.readyState == 4 && this._xh.status == 200) {
			return this._xh.responseText;
		}
		
	}
	return false;
}


var urlBase = "/common/admin/CommentManager/update.cfm";
var formVars = "";
var changing = false;


function fieldEnter(campo,evt,idfld) {
	evt = (evt) ? evt : window.event;
	if (evt.keyCode == 13 && campo.value!="") {
		elem = document.getElementById( idfld );
		remotos = new datosServidor;
		//nt = remotos.enviar(urlBase + "?fieldname=" +encodeURI(elem.id)+ "&content="+encodeURI(campo.value)+"&"+formVars,"");
		//remove glow
		noLight(elem);
		elem.innerHTML = formatstring(campo.value);
		changing = false;
		return false;
	} else {
		return true;
	}
}
  
function nl2br(text){
		text = escape(text);
		if(text.indexOf('%0D%0A') > -1){
			re_nlchar = /%0D%0A/g ;
     	}else if(text.indexOf('%0A') > -1){
			re_nlchar = /%0A/g ;
      	}else if(text.indexOf('%0D') > -1){
      		re_nlchar = /%0D/g ;
		}
		else {
			re_nlchar = "";
		}
		
		if (re_nlchar ==""){
			return unescape(text);
		}
		else{
     	 return unescape( text.replace(re_nlchar,'<br />') );
		}
      }

function fieldBlur(campo,idfld) {
	if (campo.value!="") {
		elem = document.getElementById( idfld );
		remotos = new datosServidor;
		//nt = remotos.enviar(urlBase + "?fieldname=" +escape(elem.id)+ "&content="+escape(campo.value)+"&"+formVars,"");
		elem.innerHTML = nl2br(campo.value);
		//alert (elem.innerHTML);
		var mystring = elem.id
		var myid = mystring.split("_");
		var newid = myid[1];
		var newfield = myid[0];
		if (newfield == "commentname"){
			document.getElementById("name_"+newid).value = campo.value;
			}
		else if (newfield = "commenttext"){
			document.getElementById("comment_"+newid).value = campo.value;
		}
		changing = false;
		return false;
	}
}

function formatstring(str) {
      return (str+'').replace(/<br>/gi, '\n');
	  }


//edit field created
function editBox(actual) {
	//alert(actual.nodeName+' '+changing);
	if(!changing){
		width = widthEl(actual.id) + 50;
		height =heightEl(actual.id) + 15;

		 if(height < 30){
			if(width < 100)	width = 200;
			if(height < 50) height = 20;
			actual.innerHTML = "<input id=\""+ actual.id +"_field\" style=\"width: "+width+"px; height: "+height+"px;\" maxlength=\"254\" type=\"text\" value=\"" + formatstring(actual.innerHTML) + "\" onkeypress=\"return fieldEnter(this,event,'" + actual.id + "')\" onfocus=\"highLight(this);\" onblur=\"noLight(this); return fieldBlur(this,'" + actual.id + "');\" />";
		}
		else{
			if(width < 70) width = 90;
			if(height < 50) height = 50;
			// somehow replace <br>'s with \n (CRLF);
			actual.innerHTML = "<textarea name=\"textarea\" id=\""+ actual.id +"_field\" style=\"width: "+width+"px; height: "+height+"px;\" onfocus=\"highLight(this);\" onblur=\"noLight(this); return fieldBlur(this,'" + actual.id + "');\">" + formatstring(actual.innerHTML) + "</textarea>";
		}
		changing = true;
	}

		actual.firstChild.focus();
}

//find all span tags with class editText and id as fieldname parsed to update script. add onclick function
function editbox_init(){
	if (!document.getElementsByTagName){ return; }
	var spans = document.getElementsByTagName("span");

	// loop through all span tags
	for (var i=0; i<spans.length; i++){
		var spn = spans[i];

        	if (((' '+spn.className+' ').indexOf("editTextname") != -1) && (spn.id)) {
			spn.onclick = function () { editBox(this); }
			spn.style.cursor = "pointer";
			spn.title = "Click to edit!";	
       		}
			if (((' '+spn.className+' ').indexOf("editText") != -1) && (spn.id)) {
			spn.onclick = function () { editBox(this); }
			spn.style.cursor = "pointer";
			spn.title = "Click to edit!";	
       		}
	}


}

//crossbrowser load function
function addEvent(elm, evType, fn, useCapture)
{
  if (elm.addEventListener){
    elm.addEventListener(evType, fn, useCapture);
    return true;
  } else if (elm.attachEvent){
    var r = elm.attachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Please upgrade your browser to use full functionality on this page");
  }
}

//get width of text element
function widthEl(span){

	if (document.layers){
	  w=document.layers[span].clip.width;
	} else if (document.all && !document.getElementById){
	  w=document.all[span].offsetWidth;
	} else if(document.getElementById){
	  w=document.getElementById(span).offsetWidth;
	}
return w;
}

//get height of text element
function heightEl(span){

	if (document.layers){
	  h=document.layers[span].clip.height;
	} else if (document.all && !document.getElementById){
	  h=document.all[span].offsetHeight;
	} else if(document.getElementById){
	  h=document.getElementById(span).offsetHeight;
	}
return h;
}

function highLight(span){
            //span.parentNode.style.border = "2px solid #D1FDCD";
           // span.parentNode.style.padding = "0";
            span.style.border = "1px solid #808080";      
}

function noLight(span){
       // span.parentNode.style.border = "0px";
       // span.parentNode.style.padding = "2px";
        span.style.border = "0px";   
}

//sets post/get vars for update
function setVarsForm(vars){
	formVars  = vars;
}

addEvent(window, "load", editbox_init);
