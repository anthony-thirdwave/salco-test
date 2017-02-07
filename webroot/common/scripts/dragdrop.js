/* Customize Sensitivity Below(in pixels). */
var play = 30;
var columnX = new Array();
columnX[1] = 330;
columnX[2] = 657;
columnX[3] = 984;
var rowDifference = 167;

/* Don't touch these */
var ie=document.all;
var nn6=document.getElementById&&!document.all;
var isdrag=false;
var x,y;
var dobj;
var absoluteX = new Array();
var absoluteY = new Array();
var totalElements = 0;
var relativeX = new Array();
var relativeY = new Array();
var swapped = false;
var lastObject = 1;
var numRealRows = new Array();
numRealRows[1] = 0;
numRealRows[2] = 0;
numRealRows[3] = 0;
var lowestPos = new Array();
lowestPos[1] = 0;
lowestPos[2] = 0;
lowestPos[3] = 0;
var highestPos = 0;

function movemouse(e) {
	var realX, realY, elementNumber;
	swapped = false;
	document.title = x + ', ' + y;
	elementNumber = dobj.id.replace('dragme', '');
	lastObject = elementNumber;
	if (isdrag) {
		dobj.style.left = nn6 ? tx + e.clientX - x : tx + event.clientX - x;
		dobj.style.top  = nn6 ? ty + e.clientY - y : ty + event.clientY - y;
		
		realX = getX(eval("dragme" + elementNumber));
		realY = getY(eval("dragme" + elementNumber));
		
		for(z=1;z<=absoluteY.length;z++) {
			if( z != elementNumber) {
				if( (Math.abs(realX - absoluteX[z]) < play) && (Math.abs(realY - absoluteY[z]) < play) ) {
					dobj.style.left = ((absoluteX[z] - absoluteX[elementNumber]) + relativeX[elementNumber]) + 'px';
					dobj.style.top = ((absoluteY[z] - absoluteY[elementNumber]) + relativeY[elementNumber]) + 'px';
					
					if( document.getElementById('dragme' + z) ) {
						document.getElementById('dragme' + z).style.left =
							((absoluteX[elementNumber] - absoluteX[z]) + relativeX[z]) + 'px';
					} else {
						absoluteX[z] = absoluteX[elementNumber];
					}
					
					if( document.getElementById('dragme' + z) ) {
						document.getElementById('dragme' + z).style.top =
							((absoluteY[elementNumber] - absoluteY[z]) + relativeY[z]) + 'px';
					} else {
						absoluteY[z] = absoluteY[elementNumber];
					}
					
					getPositions(totalElements);
					swapped = true;
					return false;
				}
			}
		}
		return false;
	}
}


function selectmouse(e) {
	var fobj = nn6 ? e.target : event.srcElement;
	var topelement = nn6 ? "HTML" : "BODY";
	while (fobj.tagName != topelement && fobj.className != "dragme") {
		fobj = nn6 ? fobj.parentNode : fobj.parentElement;
	}
	if (fobj.className=="dragme") {
		isdrag = true;
		dobj = fobj;
		tx = parseInt(dobj.style.left+0,10);
		ty = parseInt(dobj.style.top+0,10);
		x = nn6 ? e.clientX : event.clientX;
		y = nn6 ? e.clientY : event.clientY;
		document.onmousemove=movemouse;
		return false;
	}
}


function upmouse(e) {
	isdrag = false;
	if( !swapped ) {
		for(i=1;i<=totalElements;i++) {
			document.getElementById('dragme' + i).style.left = relativeX[i];
			document.getElementById('dragme' + i).style.top = relativeY[i];
		}
	}
}


function getY( oElement ) {
	var iReturnValue = 0;
	while( oElement != null ) {
		iReturnValue += oElement.offsetTop;
		oElement = oElement.offsetParent;
	}
	return iReturnValue;
}


function getX( oElement ) {
	var iReturnValue = 0;
	while( oElement != null ) {
		iReturnValue += oElement.offsetLeft;
		oElement = oElement.offsetParent;
	}
	return iReturnValue;
}


function getLowestPostitions() {
	for(j=1;j<=totalElements;j++) {
		if( absoluteX[j] == columnX[1] ) {
			if( absoluteY[j] > lowestPos[1] ) {
				lowestPos[1] = absoluteY[j];
			}
		} else if( absoluteX[j] == columnX[2] ) {
			if( absoluteY[j] > lowestPos[2] ) {
				lowestPos[2] = absoluteY[j];
			}
		} else if( absoluteX[j] == columnX[3] ) {
			if( absoluteY[j] > lowestPos[3] ) {
				lowestPos[3] = absoluteY[j];
			}
		}
		
		highestPos = absoluteY[1];
		
		for(u=1;u<4;u++) {
			numRealRows[u] = (lowestPos[u] - highestPos);
			if( numRealRows[u] == 0 ) {
				numRealRows[u] = 1;
			} else if( numRealRows[u] < 0 ) {
				numRealRows[u] = 0;
			} else {
				numRealRows[u] = (((lowestPos[u] - highestPos) / rowDifference) + 1);
			}
		}
		
		document.title = numRealRows[1] + ' ' + numRealRows[2] + ' ' + numRealRows[3];
	}
	createSafetyPositions();
}


function createSafetyPositions() {
	for(w=1;w<4;w++) {
		if( (numRealRows[w] > 0) && (totalElements > 0) ){
			for(t=1;t<=(totalElements - numRealRows[w]);t++){
				absoluteY[totalElements + t] = lowestPos[w] + (rowDifference * t);
				absoluteX[totalElements + t] = columnX[w];
			}
		}
	}
}


function getPositions(numElements) {
	isdrag = false;
	for(m=1;m<=numElements;m++) {
		absoluteX[m] = getX(eval('dragme' + m));
		absoluteY[m] = getY(eval('dragme' + m));
		if(document.getElementById('dragme' + m).style.left != "") {
			relativeX[m] = parseInt(document.getElementById('dragme' + m).style.left.replace('px',''));
		} else {
			relativeX[m] = 0;
		}
		if(document.getElementById('dragme' + m).style.top != "") {
			relativeY[m] = parseInt(document.getElementById('dragme' + m).style.top.replace('px',''));
		} else {
			relativeY[m] = 0;
		}
	}
	totalElements = numElements;
	getLowestPostitions();
}

function refreshDebug(){
	document.getElementById("debug").innerHTML = "<h3>Positions</h3>";
	for(b=1;b<absoluteY.length;b++) {
		document.getElementById("debug").innerHTML = document.getElementById("debug").innerHTML
			+ absoluteX[b] + ', ' + absoluteY[b] + '<br />';
	}
}

document.onmousedown=selectmouse;
document.onmouseup=upmouse;
setTimeout("refreshDebug();", 1000);