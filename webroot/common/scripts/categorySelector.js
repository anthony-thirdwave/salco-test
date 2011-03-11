var count = 0, listCount = -1, results, theItem, theHiddenItem, theDiv = "suggest", listID = "categoryList", txtBox = "txtResource", oktosubmit=1, thisBGColor = "#FFFFCC";

document.write('<script src="/common/scripts/scriptaculous/lib/prototype.js" type="text/javascript"></script><script src="/common/scripts/scriptaculous/src/scriptaculous.js" type="text/javascript"></script><script src="/common/scripts/scriptaculous/src/unittest.js" type="text/javascript"></script>');

function handleHttpResponse() {
	var strData, eName, gogo = true;
	var articleName = "", JSArticleName = ""; junk = "";
	count = 0;
	listCount = -1;
	
	if (http.readyState == 4) {
		// Clear the suggest box
		document.getElementById(theDiv).innerHTML = "";
		//if(http.responseText.indexOf("~||~") != -1){
			results = http.responseText.split("~||~");
			while(gogo) {
				if(results[count].indexOf("%%%") == -1){
					if(results[count].indexOf("~|~") != -1){
						// If its a resource we need to split again to split name and id
						junk = results[count].split("~|~");
						articleName = junk[0];
						JSArticleName = junk[1];
						// place the id into RID
						RID[count] = junk[2];
						// Fill div with list of words
						eName = "results" + count;
						document.getElementById(theDiv).innerHTML = document.getElementById(theDiv).innerHTML + "<div id=\"" + eName + "bg\" style=\" padding-left: 0px;   \"><a id=\"" + eName + "\" style=\"text-decoration:none; color:#000000; /*margin-left: 5px;*/   \" href=\"javascript:addArticle('" + RID[count] + "','" + JSArticleName + "');\">" + articleName + "</a></div>";
					}
					count++;
				}else{
					gogo = false;
				}
				
				HideSelect=document.getElementsByTagName("select")
				for (res=0; res<HideSelect.length;res++){
					
					if(HideSelect[res].name=="ParentID" && document.all){
						HideSelect[res].style.display="none";
					}
				}
			}
			// Hide suggest box if no words are found
			if(count == 0){
				document.getElementById(theDiv).style.visibility = "hidden";
			}else{
				document.getElementById(theDiv).style.visibility = "visible";
			}
			
			if(document.all){
				try{
				if(document.getElementById(theDiv).offsetWidth>400){
					document.getElementById(theDiv).style.width="400px";
					
					document.getElementById(theDiv).style.whiteSpace="normal"
					document.getElementById(theDiv).style.width="400px";
					}
				}
				catch(e){//to catch error
				}
					//alert(document.getElementById("suggest").offsetWidth)
				}
			// adjust height of suggest box, 14px per word
			//document.getElementById(theDiv).style.height = (count * 14) + "px";
		//}
	}
	
}

// Handle keyups.  control selection w/ keyboard
function getSuggestions(letters, e) {
	//alert(e.keyCode);
	theItem = letters.name;
	switch(e.keyCode){
		case 40:
			// THE DOWN ARROW WAS PRESSED
			if(listCount < (count - 1)){
				listCount++;
				theE = "results" + listCount + "bg";
				for(x = 0; x < count; x++)
					document.getElementById("results" + x + "bg").style.backgroundColor = thisBGColor;
				document.getElementById(theE).style.background = "#BCCCF3";
			}
			break;
		case 38:
			// THE UP ARROW WAS PRESSED
			if(listCount > 0){
				listCount--;
				theE = "results" + listCount + "bg";
				for(x = 0; x < count; x++)
					document.getElementById("results" + x + "bg").style.backgroundColor = thisBGColor;
				document.getElementById(theE).style.background = "#BCCCF3";
			}else{
				for(x = 0; x < count; x++)
					document.getElementById("results" + x + "bg").style.backgroundColor = thisBGColor;
				listCount = -1;
			}
			break;
		case 13:
			// THE ENTER KEY WAS PRESSED
			if(listCount > -1){
				var tmpSWord;
				tmpSWord = results[listCount].split("~|~");
				addArticle(tmpSWord[2],tmpSWord[0]);
				
				//document.getElementById(theItem).focus();
				return false;
			}else{
				// IF YOU WANT TO SUBMIT WHEN THE ENTER KEY IS PRESSES, PUT IT HERE
				// document.form.submit();
			}
			break;
		default:
			// ANYTHING BESIDES UP, DOWN, OR ENTER WAS PRESSED
			if(letters.value.length < 1){
				document.getElementById(theDiv).style.visibility = "hidden";
			} else {
				document.getElementById(theDiv).style.visibility = "visible";
				http.open("GET", "/common/modules/Article/articleSuggest.cfm?l=" + letters.value + "&e=" + getResults(), true);
				http.onreadystatechange = handleHttpResponse;
				http.send(null);
			}
	}

}
// This functions greates the http object
function getHTTPObject() {
	var ua;
	if(window.XMLHttpRequest) {
		try {
			ua = new XMLHttpRequest();
		} catch(e) {
			ua = false;
		}
	} else if(window.ActiveXObject) {
		try {
			ua = new ActiveXObject("Microsoft.XMLHTTP");
		} catch(e) {
			ua = false;
		}
	}
	return ua;
}
function supressEnterKey(e){
	if(e.keyCode==13){
		return false;
	}
	return true;
}


function addCategory(id,name){
	if(elementExists(id)){
		alert("'" + name + "' has already been added to the list.")
	}
	else{
		ulElem = document.getElementById(listID);
		var newListElem = document.createElement('li');
		newListElem.setAttribute('id', id);
		newListElem.innerHTML = "<span class=\"handle\">" + name + "ZZZZ</span>";
		ulElem.appendChild(newListElem);
		Sortable.create(listID,{ghosting:true,handle:'handle',constraint:false});
		document.getElementById(theDiv).style.visibility = "hidden";
		document.getElementById(txtBox).value = "";
	}
} 

function elementExists(id){
	if(document.getElementById(id) == null)
		return false;
	else
		return true;
}

function removeArticle(id){
	ulElem = document.getElementById(listID);
	removeElem = document.getElementById(id);
	ulElem.removeChild(removeElem);
}

function getResults(){
	ulElem = document.getElementById(listID);
	resultsText = "";
	for(i=0;i<ulElem.childNodes.length;i++){
		resultsText += ulElem.childNodes[i].getAttribute('id');
		if(i<ulElem.childNodes.length-1)
			resultsText += ","
	}
	return resultsText;
} 

// set variable to check if http object was created in the functions
var http = getHTTPObject();
var sType = "int";
var RID = new Array(7);
var selectedRID = 0;

// Slopppy, but I think we'll need to do this
RID[0] = 0;
RID[1] = 0;
RID[2] = 0;
RID[3] = 0;
RID[4] = 0;
RID[5] = 0;
RID[6] = 0;