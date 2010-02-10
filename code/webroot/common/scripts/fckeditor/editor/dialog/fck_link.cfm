<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2007 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * Link dialog window.
-->
<html>
	<head>
		<title>Link Properties</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="robots" content="noindex, nofollow" />
		<script src="common/fck_dialog_common.js" type="text/javascript"></script>
		<script src="fck_link/fck_link.js" type="text/javascript"></script>
		<script>
		var count = 0, listCount = -1, results, theItem, theHiddenItem, theDiv;
		function handleHttpResponse() {
			var strData, eName, gogo = true;
			var tooManyVars = ""; junk = "";
			count = 0;
			listCount = -1;
			// Clear the suggest box
			document.getElementById(theDiv).innerHTML = "";
			if (http.readyState == 4) {
				results = http.responseText.split(",");
				while(gogo) {
					if(results[count].indexOf("%%%") == -1){
						if(results[count].indexOf(";") != -1){
							
							// If its a resource we need to split again to split name and id
							junk = results[count].split(";");
							tooManyVars = junk[0];
							// place the id into RID
							RID[count] = junk[1];
						}else{
							tooManyVars = results[count];
						}
						// Fill div with list of words
						eName = "word" + count;
						document.getElementById(theDiv).innerHTML = document.getElementById(theDiv).innerHTML + "<div id=\"" + eName + "bg\" class=\"wordbg\"><a id=\"" + eName + "\" class=\"words\" href=\"javascript: setWord('" + tooManyVars + "'\); setID(" + RID[count] + ");\">" + tooManyVars + "</a></div>";
						count++;
					}else{
						gogo = false;
					}
				}
				// Hide suggest box if no words are found
				if(count == 0){
					document.getElementById(theDiv).style.visibility = "hidden";
				}else{
					document.getElementById(theDiv).style.visibility = "visible";
				}
				// adjust height of suggest box, 14px per word
				document.getElementById(theDiv).style.height = (count * 14) + "px";
			}
		}
		
		function setWord(theWord){
			// Place selected word in textbox, hide suggestions, focus on the textbox
			document.getElementById(theItem).value = theWord;
			document.getElementById(theDiv).style.visibility = "hidden";
			document.getElementById(theItem).focus();
			document.getElementById(theItem).value = theWord;
		}
		
		function setID(theID){
			// Place resource id into the hidden field
			document.getElementById("hidResource").value = theID;
		}
		
		// Handle keyups.  control selection w/ keyboard
		function getSuggestions(letters, e, thi, td, suggestType) {
			//alert(e.keyCode);
			sType = suggestType;
			theItem = letters.name;
			theDiv = td;
			theHiddenItem = thi;
			switch(e.keyCode){
				case 40:
					// THE DOWN ARROW WAS PRESSED
					if(listCount < (count - 1)){
						listCount++;
						theE = "word" + listCount + "bg";
						for(x = 0; x < count; x++)
							document.getElementById("word" + x + "bg").style.background = "transparent";
						document.getElementById(theE).style.background = "#BCCCF3";
					}
					break;
				case 38:
					// THE UP ARROW WAS PRESSED
					if(listCount > 0){
						listCount--;
						theE = "word" + listCount + "bg";
						for(x = 0; x < count; x++)
							document.getElementById("word" + x + "bg").style.background = "transparent";
						document.getElementById(theE).style.background = "#BCCCF3";
					}else{
						for(x = 0; x < count; x++)
							document.getElementById("word" + x + "bg").style.background = "transparent";
						listCount = -1;
					}
					break;
					// ENTER KEY doesn't want to work with FCKeditor
					// for now, I'll use the right and left arrows
					// to select a word with the keyboard. Selecting with
					// the mouse appears to work fine.  -dk
					
					// WAIT, I think I got it now -dk
				case 13:
					// THE ENTER KEY WAS PRESSED
					if(listCount > -1){
						var tmpSWord;
						//alert("'" + results[listCount].replace(/^\s*|\s*$/g,"") + "'");
						tmpSWord = results[listCount].split(";");
						setWord(tmpSWord[0].replace(/^\s*|\s*$/g,""));
						
						document.getElementById(theHiddenItem).value = results[listCount];
						selectedRID = RID[listCount];
						document.getElementById("hidResource").value = selectedRID;
						listCount = -1;
						document.getElementById(theItem).focus();
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
						http.open("GET", "/common/scripts/fckeditor/editor/dialog/suggest.cfm?t=" + suggestType + "&l=" + letters.value, true);
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
		
		function popUp(URL, w, h) {
			day = new Date();
			id = day.getTime();
			eval("page" + id + " = window.open(URL, '" + id + "', 'toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=1,resizable=0,width="+w+",height="+h+",left = 390,top = 262');");
		}
		
		</script>
	</head>
	<body scroll="no" style="OVERFLOW: hidden">
		<div id="divInfo" style="DISPLAY: none">
			<span fckLang="DlgLnkType">Link Type</span><br />
			<select id="cmbLinkType" onChange="SetLinkType(this.value);">
				<option value="url" fckLang="DlgLnkTypeURL" selected="selected">External URL</option>
				<option value="inturl" fckLang="DlgLnkTypeIURL">Internal URL</option>
				<option value="resource" fckLang="DlgLnkTypeResource">Resource</option>
				<option value="anchor" fckLang="DlgLnkTypeAnchor">Anchor in this page</option>
				<option value="email" fckLang="DlgLnkTypeEMail">E-Mail</option>
			</select>
			<cfoutput>
			<input type="hidden" name="contentPageInUrl" id="contentPageInUrl" value="#APPLICATION.contentPageInUrl#" />
			</cfoutput>
			<br />
			<br />
			<div id="divLinkTypeUrl">
				<table cellspacing="0" cellpadding="0" width="100%" border="0" dir="ltr">
					<tr>
						<td nowrap="nowrap">
							<span fckLang="DlgLnkProto">Protocol</span><br />
							<select id="cmbLinkProtocol">
								<option value="http://" selected="selected">http://</option>
								<option value="https://">https://</option>
								<option value="ftp://">ftp://</option>
								<option value="news://">news://</option>
								<option value="" fckLang="DlgLnkProtoOther">&lt;other&gt;</option>
							</select>
						</td>
						<td nowrap="nowrap">&nbsp;</td>
						<td nowrap="nowrap" width="100%">
							<span fckLang="DlgLnkURL">URL</span><br />
							<input id="txtUrl" style="WIDTH: 100%" type="text" onKeyUp="OnUrlChange();" onChange="OnUrlChange();" />
						</td>
					</tr>
				</table>
				<br />
				<div id="divBrowseServer">
				<input type="button" value="Browse Server" fckLang="DlgBtnBrowseServer" onClick="BrowseServer();" />
				</div>
			</div>
			<div id="divLinkTypeIntUrl"  style="DISPLAY: none">
				<table cellspacing="0" cellpadding="0" width="100%" border="0" dir="ltr">
					<tr>
						<td nowrap="nowrap" width="100%" colspan="3">
							<!-- I didn't take the time to translate alias -dk -->
							<span>Alias</span><br />
							<input type="hidden" name="hidSuggest" id="hidSuggest" />
							<input id="txtAlias" name="txtAlias" style="WIDTH: 300px" type="text" onKeyUp="getSuggestions(this, event, 'hidSuggest', 'suggest', 'int');" />
							<br />
							<div id="suggest" class="sBox"></div>
						</td>
					</tr>
				</table>
			</div>
			<div id="divLinkTypeAnchor" style="DISPLAY: none" align="center">
				<div id="divSelAnchor" style="DISPLAY: none">
					<table cellspacing="0" cellpadding="0" border="0" width="70%">
						<tr>
							<td colspan="3">
								<span fckLang="DlgLnkAnchorSel">Select an Anchor</span>
							</td>
						</tr>
						<tr>
							<td width="50%">
								<span fckLang="DlgLnkAnchorByName">By Anchor Name</span><br />
								<select id="cmbAnchorName" onChange="GetE('cmbAnchorId').value='';" style="WIDTH: 100%">
									<option value="" selected="selected"></option>
								</select>
							</td>
							<td>&nbsp;&nbsp;&nbsp;</td>
							<td width="50%">
								<span fckLang="DlgLnkAnchorById">By Element Id</span><br />
								<select id="cmbAnchorId" onChange="GetE('cmbAnchorName').value='';" style="WIDTH: 100%">
									<option value="" selected="selected"></option>
								</select>
							</td>
						</tr>
					</table>
				</div>
				<div id="divNoAnchor" style="DISPLAY: none">
					<span fckLang="DlgLnkNoAnchors">&lt;No anchors available in the document&gt;</span>
				</div>
			</div>
			<div id="divLinkTypeEMail" style="DISPLAY: none">
				<span fckLang="DlgLnkEMail">E-Mail Address</span><br />
				<input id="txtEMailAddress" style="WIDTH: 100%" type="text" /><br />
				<span fckLang="DlgLnkEMailSubject">Message Subject</span><br />
				<input id="txtEMailSubject" style="WIDTH: 100%" type="text" /><br />
				<span fckLang="DlgLnkEMailBody">Message Body</span><br />
				<textarea id="txtEMailBody" style="WIDTH: 100%" rows="3" cols="20"></textarea>
			</div>
		</div>
		<div id="divUpload" style="DISPLAY: none">
			<form id="frmUpload" method="post" target="UploadWindow" enctype="multipart/form-data" action="" onSubmit="return CheckUpload();">
				<span fckLang="DlgLnkUpload">Upload</span><br />
				<input id="txtUploadFile" style="WIDTH: 100%" type="file" size="40" name="NewFile" /><br />
				<br />
				<input id="btnUpload" type="submit" value="Send it to the Server" fckLang="DlgLnkBtnUpload" />
				<iframe name="UploadWindow" style="DISPLAY: none" src="javascript:void(0)"></iframe>
			</form>
		</div>
		<div id="divTarget" style="DISPLAY: none">
			<table cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr>
					<td nowrap="nowrap">
						<span fckLang="DlgLnkTarget">Target</span><br />
						<select id="cmbTarget" onChange="SetTarget(this.value);">
							<option value="" fckLang="DlgGenNotSet" selected="selected">&lt;not set&gt;</option>
							<option value="frame" fckLang="DlgLnkTargetFrame">&lt;frame&gt;</option>
							<option value="popup" fckLang="DlgLnkTargetPopup">&lt;popup window&gt;</option>
							<option value="_blank" fckLang="DlgLnkTargetBlank">New Window (_blank)</option>
							<option value="_top" fckLang="DlgLnkTargetTop">Topmost Window (_top)</option>
							<option value="_self" fckLang="DlgLnkTargetSelf">Same Window (_self)</option>
							<option value="_parent" fckLang="DlgLnkTargetParent">Parent Window (_parent)</option>
						</select>
					</td>
					<td>&nbsp;</td>
					<td id="tdTargetFrame" nowrap="nowrap" width="100%">
						<span fckLang="DlgLnkTargetFrameName">Target Frame Name</span><br />
						<input id="txtTargetFrame" style="WIDTH: 100%" type="text" onKeyUp="OnTargetNameChange();"
							onchange="OnTargetNameChange();" />
					</td>
					<td id="tdPopupName" style="DISPLAY: none" nowrap="nowrap" width="100%">
						<span fckLang="DlgLnkPopWinName">Popup Window Name</span><br />
						<input id="txtPopupName" style="WIDTH: 100%" type="text" />
					</td>
				</tr>
			</table>
			<br />
			<table id="tablePopupFeatures" style="DISPLAY: none" cellspacing="0" cellpadding="0" align="center"
				border="0">
				<tr>
					<td>
						<span fckLang="DlgLnkPopWinFeat">Popup Window Features</span><br />
						<table cellspacing="0" cellpadding="0" border="0">
							<tr>
								<td valign="top" nowrap="nowrap" width="50%">
									<input id="chkPopupResizable" name="chkFeature" value="resizable" type="checkbox" /><label for="chkPopupResizable" fckLang="DlgLnkPopResize">Resizable</label><br />
									<input id="chkPopupLocationBar" name="chkFeature" value="location" type="checkbox" /><label for="chkPopupLocationBar" fckLang="DlgLnkPopLocation">Location
										Bar</label><br />
									<input id="chkPopupManuBar" name="chkFeature" value="menubar" type="checkbox" /><label for="chkPopupManuBar" fckLang="DlgLnkPopMenu">Menu
										Bar</label><br />
									<input id="chkPopupScrollBars" name="chkFeature" value="scrollbars" type="checkbox" /><label for="chkPopupScrollBars" fckLang="DlgLnkPopScroll">Scroll
										Bars</label>
								</td>
								<td></td>
								<td valign="top" nowrap="nowrap" width="50%">
									<input id="chkPopupStatusBar" name="chkFeature" value="status" type="checkbox" /><label for="chkPopupStatusBar" fckLang="DlgLnkPopStatus">Status
										Bar</label><br />
									<input id="chkPopupToolbar" name="chkFeature" value="toolbar" type="checkbox" /><label for="chkPopupToolbar" fckLang="DlgLnkPopToolbar">Toolbar</label><br />
									<input id="chkPopupFullScreen" name="chkFeature" value="fullscreen" type="checkbox" /><label for="chkPopupFullScreen" fckLang="DlgLnkPopFullScrn">Full
										Screen (IE)</label><br />
									<input id="chkPopupDependent" name="chkFeature" value="dependent" type="checkbox" /><label for="chkPopupDependent" fckLang="DlgLnkPopDependent">Dependent
										(Netscape)</label>
								</td>
							</tr>
							<tr>
								<td valign="top" nowrap="nowrap" width="50%">&nbsp;</td>
								<td></td>
								<td valign="top" nowrap="nowrap" width="50%"></td>
							</tr>
							<tr>
								<td valign="top">
									<table cellspacing="0" cellpadding="0" border="0">
										<tr>
											<td nowrap="nowrap"><span fckLang="DlgLnkPopWidth">Width</span></td>
											<td>&nbsp;<input id="txtPopupWidth" type="text" maxlength="4" size="4" /></td>
										</tr>
										<tr>
											<td nowrap="nowrap"><span fckLang="DlgLnkPopHeight">Height</span></td>
											<td>&nbsp;<input id="txtPopupHeight" type="text" maxlength="4" size="4" /></td>
										</tr>
									</table>
								</td>
								<td>&nbsp;&nbsp;</td>
								<td valign="top">
									<table cellspacing="0" cellpadding="0" border="0">
										<tr>
											<td nowrap="nowrap"><span fckLang="DlgLnkPopLeft">Left Position</span></td>
											<td>&nbsp;<input id="txtPopupLeft" type="text" maxlength="4" size="4" /></td>
										</tr>
										<tr>
											<td nowrap="nowrap"><span fckLang="DlgLnkPopTop">Top Position</span></td>
											<td>&nbsp;<input id="txtPopupTop" type="text" maxlength="4" size="4" /></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="divAttribs" style="DISPLAY: none">
			<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<tr>
					<td valign="top" width="50%">
						<span fckLang="DlgGenId">Id</span><br />
						<input id="txtAttId" style="WIDTH: 100%" type="text" />
					</td>
					<td width="1"></td>
					<td valign="top">
						<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
							<tr>
								<td width="60%">
									<span fckLang="DlgGenLangDir">Language Direction</span><br />
									<select id="cmbAttLangDir" style="WIDTH: 100%">
										<option value="" fckLang="DlgGenNotSet" selected>&lt;not set&gt;</option>
										<option value="ltr" fckLang="DlgGenLangDirLtr">Left to Right (LTR)</option>
										<option value="rtl" fckLang="DlgGenLangDirRtl">Right to Left (RTL)</option>
									</select>
								</td>
								<td width="1%">&nbsp;&nbsp;&nbsp;</td>
								<td nowrap="nowrap"><span fckLang="DlgGenAccessKey">Access Key</span><br />
									<input id="txtAttAccessKey" style="WIDTH: 100%" type="text" maxlength="1" size="1" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td valign="top" width="50%">
						<span fckLang="DlgGenName">Name</span><br />
						<input id="txtAttName" style="WIDTH: 100%" type="text" />
					</td>
					<td width="1"></td>
					<td valign="top">
						<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
							<tr>
								<td width="60%">
									<span fckLang="DlgGenLangCode">Language Code</span><br />
									<input id="txtAttLangCode" style="WIDTH: 100%" type="text" />
								</td>
								<td width="1%">&nbsp;&nbsp;&nbsp;</td>
								<td nowrap="nowrap">
									<span fckLang="DlgGenTabIndex">Tab Index</span><br />
									<input id="txtAttTabIndex" style="WIDTH: 100%" type="text" maxlength="5" size="5" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td valign="top" width="50%">&nbsp;</td>
					<td width="1"></td>
					<td valign="top"></td>
				</tr>
				<tr>
					<td valign="top" width="50%">
						<span fckLang="DlgGenTitle">Advisory Title</span><br />
						<input id="txtAttTitle" style="WIDTH: 100%" type="text" />
					</td>
					<td width="1">&nbsp;&nbsp;&nbsp;</td>
					<td valign="top">
						<span fckLang="DlgGenContType">Advisory Content Type</span><br />
						<input id="txtAttContentType" style="WIDTH: 100%" type="text" />
					</td>
				</tr>
				<tr>
					<td valign="top">
						<span fckLang="DlgGenClass">Stylesheet Classes</span><br />
						<input id="txtAttClasses" style="WIDTH: 100%" type="text" />
					</td>
					<td></td>
					<td valign="top">
						<span fckLang="DlgGenLinkCharset">Linked Resource Charset</span><br />
						<input id="txtAttCharSet" style="WIDTH: 100%" type="text" />
					</td>
				</tr>
			</table>
			<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<tr>
					<td>
						<span fckLang="DlgGenStyle">Style</span><br />
						<input id="txtAttStyle" style="WIDTH: 100%" type="text" />
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>
