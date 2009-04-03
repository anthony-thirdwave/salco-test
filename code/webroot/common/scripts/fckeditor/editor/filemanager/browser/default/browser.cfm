<!--
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003-2005 Frederico Caldeira Knabben
 * 
 * Licensed under the terms of the GNU Lesser General Public License:
 * 		http://www.opensource.org/licenses/lgpl-license.php
 * 
 * For further information visit:
 * 		http://www.fckeditor.net/
 * 
 * File Name: browser.html
 * 	This page compose the File Browser dialog frameset.
 * 
 * File Authors:
 * 		Frederico Caldeira Knabben (fredck@fckeditor.net)
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>FCKeditor - Resources Browser</title>
		<link href="browser.css" type="text/css" rel="stylesheet">
		<script type="text/javascript" src="js/fckxml.js"></script>
		<script language="javascript">

function GetUrlParam( paramName )
{
	var oRegex = new RegExp( '[\?&]' + paramName + '=([^&]+)', 'i' ) ;
	var oMatch = oRegex.exec( window.top.location.search ) ;
	
	if ( oMatch && oMatch.length > 1 )
		return oMatch[1] ;
	else
		return '' ;
}

function GetUrlParam2( paramName )
{
	var oRegex = new RegExp( '[\?&]' + paramName + '=([^&]+)', 'i' ) ;
	var oMatch = oRegex.exec( window.location.search ) ;
	
	if ( oMatch && oMatch.length > 1 )
		return oMatch[1] ;
	else
		return '' ;
}

var oConnector = new Object() ;
oConnector.CurrentFolder	= '/' ;

var sConnUrl = GetUrlParam( 'Connector' ) ;

// Gecko has some problems when using relative URLs (not starting with slash).
if ( sConnUrl.substr(0,1) != '/' && sConnUrl.indexOf( '://' ) < 0 )
	sConnUrl = window.location.href.replace( /browser.cfm.*$/, '' ) + sConnUrl ;

oConnector.ConnectorUrl		= sConnUrl + '?' ;

var sServerPath = GetUrlParam( 'ServerPath' ) ;
if ( sServerPath.length > 0 )
	oConnector.ConnectorUrl += 'ServerPath=' + escape( sServerPath ) + '&' ;

oConnector.ResourceType		= GetUrlParam( 'Type' ) ;
oConnector.ShowAllTypes		= ( oConnector.ResourceType.length == 0 ) ;

if ( oConnector.ShowAllTypes )
	oConnector.ResourceType = 'File' ;
	
var userdir = GetUrlParam2( 'userdir' ) ;
oConnector.SendCommand = function( command, params, callBackFunction )
{
	var sUrl = this.ConnectorUrl + 'Command=' + command ;
	sUrl += '&Type=' + this.ResourceType ;
	sUrl += '&CurrentFolder=' + escape( this.CurrentFolder ) ;
	sUrl += '&userdir=' + userdir ;
	
	if ( params ) sUrl += '&' + params ;

	var oXML = new FCKXml() ;
	//alert(sUrl);
	if ( callBackFunction )
		oXML.LoadUrl( sUrl, callBackFunction ) ;	// Asynchronous load.
	else
		return oXML.LoadUrl( sUrl ) ;
}

var oIcons = new Object() ;

oIcons.AvailableIconsArray = [ 
	'ai','avi','bmp','cs','dll','doc','exe','fla','gif','htm','html','jpg','js',
	'mdb','mp3','pdf','ppt','rdp','swf','swt','txt','vsd','xls','xml','zip' ] ;
	
oIcons.AvailableIcons = new Object() ;

for ( var i = 0 ; i < oIcons.AvailableIconsArray.length ; i++ )
	oIcons.AvailableIcons[ oIcons.AvailableIconsArray[i] ] = true ;

oIcons.GetIcon = function( fileName )
{
	var sExtension = fileName.substr( fileName.lastIndexOf('.') + 1 ).toLowerCase() ;

	if ( this.AvailableIcons[ sExtension ] == true )
		return sExtension ;
	else
		return 'default.icon' ;
}
		</script>
	</head>
	<frameset cols="150,*" class="Frame" framespacing="3" bordercolor="#f1f1e3" frameborder="yes">
		<frameset rows="50,*" framespacing="0">
			<frame src="frmresourcetype.html" scrolling="no" frameborder="no">
			<frame name="frmFolders" src="frmfolders.html" scrolling="auto" frameborder="yes">
		</frameset>
		<frameset rows="50,*,50" framespacing="0">
			<frame name="frmActualFolder" src="frmactualfolder.html" scrolling="no" frameborder="no">
			<frame name="frmResourcesList" src="frmresourceslist.html" scrolling="auto" frameborder="yes">
			<frameset cols="150,*,0" framespacing="0" frameborder="no">
				<frame name="frmCreateFolder" src="frmcreatefolder.html" scrolling="no" frameborder="no">
				<frame name="frmUpload" src="frmupload.html?userdir=<cfoutput>#userdir#</cfoutput>" scrolling="no" frameborder="no">
				<frame name="frmUploadWorker" src="UntitledFrame-1" scrolling="no" frameborder="no">
			</frameset>
		</frameset>
	</frameset><noframes></noframes>
</html>
