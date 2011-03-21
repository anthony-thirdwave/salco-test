/*
 * this file is part of: 
 * projekktor zwei
 * http://www.projekktor.com
 *
 * Copyright 2010, Sascha Kluger, Spinning Airwhale Media, http://www.spinningairwhale.com
 * under GNU General Public License
 * http://www.projekktor.com/license/
 */ 
jQuery(function($) {


// apply IE8 html5 fix - thanx to Remy Sharp - http://remysharp.com/2009/01/07/html5-enabling-script/
if ($.browser.msie) {
    (function(){
	if(!/*@cc_on!@*/0) return;
	var e = "div,audio,video,source".split(',');
	for(var i=0;i<e.length;i++){document.createElement(e[i])}}
    )();
    if(!Array.prototype.indexOf){
	Array.prototype.indexOf=function(obj,start){
	    for(var i=(start||0),j=this.length;i<j;i++){
		if(this[i]==obj){return i;}
	    }
	    return -1;
	}
    }
}
    
// container for player instances
var projekktors = [];

// this object is returned when multiple player's are requested 
function Iterator(arr) {
    this.length = arr.length;
    this.each = function(fn) {$.each(arr, fn);};
    this.size = function() {return arr.length;};	
};

window.projekktor = window.$p = function() {
    
    var arg = arguments[0];	
    var instance = null;

    if (!arguments.length) {
	return projekktors[0] || null;
    } 
	
    // get instances

    // projekktor(idx:number);
    if (typeof arg == 'number') { 
	return projekktors[arg];	
    }

    // by string selection unqiue "id" or "*"
    if (typeof arg == 'string') {
	// get all instances
	if (arg == '*') {
	    return new Iterator(projekktors);	
	}
	// get instance by Jquery OBJ or 'containerId';
	$.each(projekktors, function() {
	    try {
		if (this.getId() == arg.id || this.getId() == arg || this.getParent() == arg)  {
		    instance = this;
		}
	    } catch(e){}
	});
	if (instance!==null) return instance;
    }

    // build instances
    if (instance===null) {	
	var cfg = arguments[1] || {};
	if (typeof arg == 'string') {
		var count=0;
		var player;
		$.each($(arg), function() {
		    player = new PPlayer($(this), cfg);
		    projekktors.push(player);
		    count++;
		});
		return (count>1) ? new Iterator(projekktors) : player;
	// arg is a DOM element
	} else if (arg) {
	    projekktors.push(new PPlayer(arg, cfg));
	    return new Iterator(projekktors);
	}
    }    
    return null;

    function PPlayer(srcNode, cfg) {

	this.config = $.extend({
	    
	    /**************************************************************
		Config options to be customized prior initialization only:
	    ***************************************************************/
	    
	    /* sets name of the cookie to store playerinformation in */
	    cookieName:			'projekktor',
	    
	    /* days to keep cookie alive */
	    cookieExpiry:		356,	    
	    
	    /* Plugins to load on instance initialization, plugins are automatically extening the projekktorPluginInterface class.
	    The order of the plugins added here is important because they are added from index 0 to n one by one to the player DOM.
	    As such it is usefull to add the "Display" plugin always first.
	    */
	    plugins: 			['Display', 'Controlbar'],
	
	    /* just an ordinary version info string (btw: "r" is for "revision" not "release candidate" */
	    version: 			'0.8.18',
	    
	    /* custom reel parser (data:JSObject) */
	    reelParser:			function(data){return data;},
	    
	    /* Prefix prepended to all css-Classnames used by the player in order to avoid conflicts with existing site layouts */	
	    cssClassPrefix: 		'pp',
	    
	    /* set if to prefer native video before flash or vise versa */
	    platformPriority:		['native', 'flash'],

	    /* path to the MP4 Flash-player fallback component */
	    playerFlashMP4:		'jarisplayer.swf',
	        
	    /* path to the MP3 Flash-player fallback component */
	    playerFlashMP3:		'jarsiplayer.swf',
	    
	    /* enable/disable automatic flash fallback */
	    enableFlashFallback:	true,
	    
	    /* enable/disable native players */
	    enableNativePlayback:	true,	
	    
	    /* enable/disable fetching of keyboard events - works in "fullscreen" only */
	    enableKeyboard:		true,		
	    
	    /* enable/disable the possibility to toggle to FULLSCREEN mode */
	    enableFullscreen: 		true,
	    
	    /* if testcard is disabled, the player will force a filedowload in case no native- or flashplayer
	    is available. oterhwise a testcard with an errormessage is shown in case of issues */
	    enableTestcard:		true,
    
	    /*
	    Firefox requires special treatment whenever flash objects are
	    resized while any parent element gets a new "overflow" value.
	    You can force to skip projekktorÂ´s workaround by setting the following var to "true"
	    */
	    bypassFlashFFFix:		false,	
					    
	    /* poster image to show in case none is provided in or item config (or media tag on single files) */
	    defaultPoster:		'default-poster.jpg',
		    
	    /* force full viewport -  setting this "true" and the player will fill as much of the window it can get */
	    forceFullViewport:		false,
	    
	    /* if set to true, projekktor assumes to live within an iframe and will act accordingly (used for embedding) */
	    sandBox: 			false,
		    
	    /* looping scheduled media elements -  will be overwritten by loop-attribute of the replaced <video> tag. */
	    loop: 			false,
	    
	    /* automatically start playback once page has loaded -  will be overwritten by autoplay-attribute of the replaced <video> tag. */
	    autoplay: 			false,
	    
	    /* if more than one item is scheduled, true will automatically start playback of the next item in line once current one completed */	
	    continuous:			true,
	    
	    /* URL to poster image -  will be overwritten by poster-attribute of the replaced media tag. */
	    poster: 			false,		
	    
	    /* a title is a title is a title */	
	    title:			'',
	    
	    /* An array of URL segments which are matched agains content URLs. If no match the specific (playlist) content will be discarded */
	    allowPlaybackFrom:		[],
	    
	    /*
		setting this will allow you to provide a single base-name for your media files, 
		the player will automatically replace (*)-tags and create URL variants accordingly to
		the file-extensions set below. e.g:	   
		dynamicTypeExtensions: 	[
		    {ext:'mytheora.ogv', type:'video/ogg'},
		    {ext:'.h264.mp4', type: 'video/mp4'}
		],
	    */
	    dynamicTypeExtensions: 		false,	
	    
	    /* a string which separates the media-source URL from the poster image ( <iframe URL>#<media url><separator><poster url> ) */
	    FilePosterSeparator:	';',
	    
	    /* all error messages waiting for your translation */
	    messages: 	{
		0:'An unknown error occurred. ',
		1:'You aborted the media playback. ',
		2:'A network error caused the media download to fail part-way. ',
		3:'The media playback was aborted due to a corruption problem. ',
		4:'The media ({src}) could not be loaded because the server or network failed.',
		5:'Sorry, your browser does not support the media format of the requested file ({type}).',
		6:'You need to update your Flash Plugin to a newer version!',
		7:'No media scheduled.',
		8:'! Invalid media model configured !',
		97:'No media scheduled.',
		98:'Invalid or malformed playlist data!',
		99:'Click display to proceed. '
	    },
	    
	    /* false => OFF, console=>console.log, <string>=>ID of DOMcontainer to pump text into */
	    debug: 			false,
	    debugLevel: 		1,
	    
	    /* path to a helper 	background grid for theming purposes */
	    desginGrid:			'style/layout_grid.gif',
	    
	    /* setting this to true will force the player to "freeze" on startup and to show all control elements */
	    designMode:			false,
    
    
	    
	    /**************************************************************
		Config options available per playlist item:
	    ***************************************************************/
	    
	    /* unique itemID for the item currently played - dynamically generated if not provided via config */
	    ID:				0,
	    
	    /* disable controls -  will be overwritten by controls-attribute of the replaced <video> tag. */
	    controls: 			false,
	    
	    /* start offset in seconds for randomly seekable media. */
	    start: 			false,
    
	    /* stop endpoint in seconds for randomly seekable media. */
	    stop: 			false,			
	    
	    /* initial volume on player-startup, 0=muted, 1=max */
	    volume: 			0.5,
	    
	    /* a cover which will the current poster on audio-only playback */
	    cover: 			'',	    
			    
	    /* enable/disable the possibility to PAUSE the video once playback started. */
	    disablePause:		false,
	    
	    /* enable/disable the possibility to skip the video by hitting NEXT or using the SCRUBBER */
	    disallowSkip:		false,
	    
	    /* if set to TRUE users can not change the volume of the player - neither via API nor through controls */
	    fixedVolume:		false,
	    
	    /* scaling used for images (playlist items and posters) "fill" or "aspectratio" */
	    imageScaling:		'aspectratio',
	    
	    /* scaling used for videos (flash and native, not youtube) "fill" or "aspectratio" */
	    videoScaling:		'aspectratio',
		    
	    /* FLASH video model - you shouldnÂ´t mess with this */
	    flashVideoModel:		'videoflash',
	    
	    /* FLASH audio model - you shouldnÂ´t mess with this */
	    flashAudioModel:		'audioflash',
	    		    
	    /* defines the streamtype of the current item.
		'file': 	progressive download streaming (http, default)
		'http':		http pseudo streaming
		'rtmp':		RTMP streaming - requires "flashRTMPServer" to be set.
	    */
	    flashStreamType:		'file',
	    
	    /* it flashStreamType is 'rtmp' you have to provide the serverURL here. */
	    flashRTMPServer:		'',	    		    
		    
	    /* optional flash vars applied to (alernate) fallback component */
	    flashVars: 			null,
	    
	    /* the width of the player - 0= use destNodeÂ´s width */
	    width: 			0,
	    
	    /* guess what.... the hight of the player - 0= use destNodeÂ´s width */
	    height:			0

	}, cfg || {} );
	
	this._dynamicConfOpts = [
	    'ID',
	    'title',
	    'cover',
	    'controls',
	    'start',
	    'stop',
	    'volume',
	    'poster',
	    'disablePause',
	    'disallowSkip',
	    'fixedVolume',
	    'imageScaling',
	    'videoScaling',
	    'flashVars',
	    'flashAudioModel',
	    'flashVideoModel',
	    'playerFlashMP4',
	    'playerFlashMP3',
	    'flashStreamType',
	    'flashRTMPServer'	    
	];
	
	this._persistentConfOpts = [
	    'volume',
	    'enableNativePlayback',
	    'enableFlashFallback'
	];	
	
	this._queue = [];
	
	this.env = {
	    inFullscreen: false,
	    playerStyle: null,
	    scrollTop: null,
	    scrollLeft: null,
	    bodyOverflow: null,
	    playerDom: null,
	    mediaContainer: null,
	    agent: 'standard',
	    clientConfig: {
		supportsOverlays: true,
		modelExtensions:{}
	    },
	    mouseIsOver: false,
	    loading: false
	    
	};
	
	this.mediaTypes = {
	    0: {ext:'NaN', type:'none/none', model:'NA', platform:'native'},
	    1: {ext:'json', type:'text/json', model:'playlist', platform:'internal'},
	    2: {ext:'xml', type:'text/xml', model:'playlist', platform:'internal'},	
	    3: {ext:'ogv', type:'video/ogg', model:'video', platform:'native'},
	    4: {ext:'m4v', type:'video/mp4', model:'video', platform:'flash'},	
	    5: {ext:'webm',type:'video/webm', model:'video', platform:'native'},
	    6: {ext:'ogg', type:'video/ogg', model:'video', platform:'native'},
	    7: {ext:'anx', type:'video/ogg', model:'video', platform:'native'},
	    8: {ext:'jpg', type:'image/jpeg', model:'image', platform:'native'},
	    9: {ext:'gif', type:'image/gif', model:'image', platform:'native'},
	    10: {ext:'png', type:'image/png', model:'image', platform:'native'},        
	    11: {ext:'flv', type:'video/x-flv', model:'videoflash', platform:'flash', fixed: true},
	    12: {ext:'flv', type:'video/flv', model:'videoflash', platform:'flash', fixed: true},
	    13: {ext:'mp4', type:'video/mp4', model:'videoflash', platform:'flash'},
	    14: {ext:'mov', type:'video/quicktime', model:'videoflash', platform:'flash'},
	    15: {ext:'youtube.com', type:'video/youtube', model:'youtube', platform:'flash', fixed:'maybe'},
	    16: {ext:'ogg', type:'audio/ogg', model:'audio', platform:'native'},
	    17: {ext:'oga', type:'audio/ogg', model:'audio', platform:'native'},
	    18: {ext:'mp3', type:'audio/mp3', model:'audioflash', platform:'flash'},
	    19: {ext:'html', type:'text/html', model:'html', platform:'internal'}
	};
	
	this.clientConfig = {
	    0: {regex: 'iPhone', agent: 'iphone', supportsCookies: false, modelExtensions:{video:'mobile_apple', youtube:'mobile_apple'}},
	    1: {regex: 'iPad', agent: 'ipad', supportsCookies: false, modelExtensions:{video:'mobile_apple', youtube:'mobile_apple'}},
	    2: {regex: 'iPod', agent: 'ipod', supportsCookies: false, modelExtensions:{video:'mobile_apple', youtube:'mobile_apple'}}
	};
       
	this.media = [null];
	this.plugins = [];
	this.listeners = [];     
	this.mediaGrid = {}; 
	this.playerModel = {};
	
	this._isReady = false;
	this._isInFullscreen = false;
	
	this._currentItem = 0;
	this._playlistServer = '';
	this._id = '';	

	this._FFreinit = false;
	this._initialConfig = {};
		    
	/* asynchronously loads external XML and JSON data from server */
	this.getFromUrl = function(url, dest, callback, customParser) {
	    
	    var dataType=null, data = null, ref=this;
	    
	    if (dest==ref) {
		this._bubbleEvent('scheduleLoading', 1+this.getItemCount());
	    }
	    
	    $.ajax({
		url: url,
		complete: function( xhr, status ) {		    
		    dataType = (xhr.getResponseHeader("Content-Type").indexOf('xml')>-1) ? 'xml' : null;
		    dataType = (xhr.getResponseHeader("Content-Type").indexOf('json')>-1 && dataType===null) ? 'json' : dataType;

		    // on error, bypass IE xml header issue:
		    switch (dataType) {
			case 'xml':			    
			    // Create the xml document from the responseText string.
			    if( window.DOMParser ) {			
				data=DOMParser().parseFromString( xhr.responseText,"text/xml" ) ;
			    }
			    else { // Internet Explorer			
				data=new ActiveXObject( "Microsoft.XMLDOM" ) ;
				data.async = "false" ;
				data.loadXML( xhr.responseText ) ;
			    }
			    data = _xmlParser(data);
			    break;
			
			case 'json':
			    data = xhr.responseText;
			    if (typeof data == 'string') {
				data = $.parseJSON(data);
			    }
			    break;
			
			default:			
			    data = xhr.responseText;
			    break;
		    }
		    if (dest==ref) {
			try {data = customParser(data, xhr.responseText);} catch(e){}
		    }
		    dest[callback](data);
		},		
		error: function(data) {
		    dest[callback](false);
		}
	    });
	    
	    return this;
	};

	
	/* apply incoming playlistdata to  */
	this._reelUpdate = function(obj) {
	
	    this.env.loading = true;
	    
	    if (typeof obj != 'object') {
		obj = [{'file':'none', 'type':'NA', 'errorCode': 98}];
	    } else {
		try {
		    if (obj.length==0) 
			obj = [{'file':'none', 'type':'NA', 'errorCode': 97}];
		}
		catch(e){};
	    }
    
	    var ref = this;
	    var data = obj;
	
	    this.media = [];	   

	    // gather and set alternate config from reel:
	    try {
		var changes = false;
		for(var props in data.config) {
		    if (typeof data.config[props].indexOf('objectfunction')>-1) continue; // IE SUCKZ
		    this.config[props] = this._cleanValue( data.config[props] );
		    changes=true;		   
		}        	
		delete(data.config);
		if (changes===true) {
		    this._debug('Updated config var: '+props+' to '+this.config[props]);
		    this._bubbleEvent('configModified');
		}
	    } catch(e) {}
		
	    
	    // add media items
	    var files = data.playlist || data;	    
	    
	    for(var item in files) {
		if (typeof files[item]=='function') continue; // IE
		if (typeof files[item]==undefined) continue;
		if (files[item]) {
		    this._addItem(this._prepareMedia({file:files[item], config:files[item].config || {}, errorCode: files[item].errorCode}));
		}
	    }
	    
	    this.env.loading = false;
	    this._bubbleEvent('scheduled', this.getItemCount());
	    this._syncWithPlugins(function(){ref.setActiveItem(0);})
	};
	

	this._addItem = function(data, idx, replace) {

	    var resultIdx = 0;
	    // replace "error dummy" if any:
	    if (this.media.length===1 && this.media[0].mediaModel=='NA') {
		this._detachplayerModel();
		this.media = [];
	    }
	    
	    // inject or append:
	    if (idx===undefined || idx<0 || idx>this.media.length-1) {
		this.media.push(data);
		resultIdx = this.media.length-1;
	    } else {
		this.media.splice(idx, (replace===true) ? 1 : 0,data);
		resultIdx = idx;
	    }

	    if (this.env.loading===false) 
		this._bubbleEvent('scheduleModified', this.getItemCount());
		
	    return resultIdx;
	};
	
	this._removeItem = function(idx) {
	    
	    var resultIdx = 0;
	     
	    if (this.media.length===1) {
		
		// keep "error dummy", nothing to do:
		if (this.media[0].mediaModel=='NA') {
		    return 0;
		} else {		
		    // replace last one with "error dummy"
		    this.media[0] = this._prepareMedia({file:''});
		    return 0;
		}
	    }
	    
	    
	    if (idx===undefined || idx<0 || idx>this.media.length-1) {
		this.media.pop();
		resultIdx = this.media.length;
	    }
	    else {
		this.media.splice(idx, 1);
		resultIdx = idx;
	    }
	    
	    if (this.env.loading===false) 
		this._bubbleEvent('scheduleModified', this.getItemCount());
		
	    return resultIdx;
	};	
	
	/* apply available data and playout models */
	this._prepareMedia = function(data) {

	    var mediaFile = '', choosenIndex = 0, mediaType = '', mediaModel = 'NA', fileExt = '', extTypes = {}, typesModels = {}, errorCode = data.errorCode || 7, lastLevel = 100;

	    // build regex string and filter dublicate extensions:
	    var extRegEx = [];
	    for(var i in this.mediaTypes) {
		extRegEx.push( '.'+this.mediaTypes[i].ext );
		extTypes[this.mediaTypes[i].ext] = this.mediaTypes[i];
		typesModels[this.mediaTypes[i].type] = this.mediaTypes[i];
	    }
	    extRegEx = '^.*\.('+extRegEx.join('|')+")$";

	    // file only, no array        
	    if (typeof data.file=='string') {
		data.file = [{'src':data.file}];
		if (typeof data.type=='string') {
		    data.file = [{'src':data.file, 'type':data.type}];
		}
	    }

	    if (data.file===false) {
		data.file = [{'src':''}];
	    }

	    try {
		var dynConf = this.config.dynamicTypeExtensions;
		var tagsUsed, tag, filename;
		if (dynConf) {
		    
		    filename = data.file[0].src+'';
		   
		    if (data.file.length==1) {
			// apply file extension to string
			for(var j in dynConf) {			    
			    if (filename.match('{*}')) {
				if (!data.file[j]) data.file[j] = {};
				data.file[j].src = filename.replace('{*}', dynConf[j].ext);				
				// apply properties to object
				for (var k in dynConf[j]) {
				    if (k=='ext') continue;
				    data.file[j][k] = dynConf[j][k];
				}
			    }
			}
		    }
		}

		for (var i in data.file) {
		    tagsUsed = data.file[0][i].src.match(/\{[a-z\*]*\}/gi);			
		    tag = '';
		    if (tagsUsed) {
			for(var i=0; i<tagsUsed.length; i++) {
			    tag = tagsUsed[i].replace("{", '').replace("}", '');
			    if (this.getItemConfig(tag)!==false) {
				data.file[0][i].src = data.file[0][i].src.replace('{'+tag+'}',this.getItemConfig(tag));
			    } else {
				data.file[0][i].src = data.file[0][i].src.replace('{'+tag+'}', '');
			    }
			}
		    }
		}

	    } catch(e){}

	    // loop through available fallback alternativ - prefer models of higher "levels"
	    var sourceObj = {};

	    for(var index in data.file) {
		if (index=='config') continue;

		sourceObj = data.file[index];
		if (typeof sourceObj=='string') {
		    sourceObj = {'src':sourceObj};
		}
    
		if (sourceObj.src==undefined) {
		    continue;
		}

		indexChoosen = index;
    
		// get file extension:
		try {
		    fileExt = sourceObj.src.match( new RegExp(extRegEx))[1];
		    fileExt = (!fileExt) ? 'NaN' : fileExt.replace('.','');
		} catch(e) { fileExt='NaN'; }
    
		// get type. if no type attribute set try to find by filename extension:
		if (sourceObj['type']===undefined || sourceObj['type']===''){
		    if (extTypes[fileExt]) {
			$.extend(sourceObj,extTypes[fileExt]);			    
		    }		
		} else {
		    // type set... remember codec (if any) and clean up type string
		    try {
			var codecMatch = sourceObj['type'].split(' ').join('').split(/[\;]codecs=.([a-zA-Z0-9\,]*)[\'|\"]/i);		    
			if (codecMatch[1]!==undefined) {
			    sourceObj['codec'] = codecMatch[1];
			    sourceObj['type'] = codecMatch[0];
			}
		    } catch(e){}

		    if (typesModels[sourceObj['type']]) {
			$.extend(sourceObj,typesModels[sourceObj['type']]);			
		    }		    
		}

		// try to find the highest priorised platform:
		if (lastLevel===100) {
		    mediaFile = sourceObj.src;
		}
		
		if (lastLevel > this.config.platformPriority.indexOf(sourceObj.platform) && this.mediaGrid[sourceObj.type]!='NA' ) {
		    lastLevel = this.config.platformPriority.indexOf(sourceObj.platform);
		    try {
			mediaModel = this.mediaGrid[sourceObj.type].toUpperCase();
		    } catch(e) {
			mediaModel = "NA";
		    }
		    mediaFile = sourceObj.src;
		    mediaType = sourceObj.type;
		    
		}
		
		if (index==="src") {
		    break;
		}		
		
	    }

	    // avoid invalid models
	    if (typeof eval('playerModel'+mediaModel)!=='function') {
		mediaModel='NA';
		errorCode=0;
	    // makesure that FLASH is choosen in case of RTMP-mess
	    } else if (data.config.flashStreamType=='rtmp' && mediaModel.indexOf('FLASH')==-1) {
		mediaModel += 'FLASH';
	    // add modelExtension (for mobile exceptions and stuff)		
	    } else {		
		try {
		    if (this.env.clientConfig.modelExtensions[this.mediaGrid[mediaType]]!=undefined) {
			mediaModel += "_"+(this.env.clientConfig.modelExtensions[this.mediaGrid[mediaType]].toUpperCase());  
		    }
		} catch(e){}	
	    }
   	    
	    // perform security check
	    var block = 0;
	    if (this.config.allowPlaybackFrom.length>0) {
		for(var i=0; i<this.config.allowPlaybackFrom.length;i++) {
		    if (mediaFile.indexOf(this.config.allowPlaybackFrom[i])>-1) {
			block++;
		    }
		}
		if (block==0) {
		    mediaFile = '';
		}
	    }	

	    data._originalConfig = data.file;
	    data.fileConfig =  data.file[indexChoosen];	    
	    data.file = this.toAbsoluteURL(mediaFile);
	    data.mediaModel = mediaModel;
	    data.mediaType = mediaType;
	    data.errorCode = errorCode;
	    data.ID = this.randomId(8);
	    data._VALIDATED = true;
	    data.config = data.config || {};
	    this._debug("Set item of type: "+mediaType+" Model: "+data.mediaModel+" File:"+data.file+" Priority: "+lastLevel);
	    return data;
	 
	};    
	
	/* media element update listener */
	this._modelUpdateListener = function(type, value) {
	    var ref = this;
	    
	    if (!this.playerModel.init) return;
	    if (type!='time' && type!='progress') {		
		this._debug("Received model Update: '"+type+"' ("+value+") while handling '"+this.playerModel.getFile()+"' using '"+this.playerModel.getModelName()+"'");	    	   
	    }
	    
	    
	    switch(type) {
		case 'state':
		    this._bubbleEvent('state', value); // IMPORTANT: promote first!
		    switch (value) {
			case 'IDLE':
			    break;
		    
			case 'AWAKENING':					
			    break;
		    
			case 'BUFFERING':
			    break;			    
		    
			case 'ERROR':
			    break;				    
			
			case 'PLAYING':
			    break;
			
			case 'STOPPED':
			    this._bubbleEvent('stopped', {});
			    break;
			
			case 'PAUSED':            
			    if (this.getItemConfig('disablePause')===true) {
				this.playerModel.applyCommand('play', 0);
			    }
			    break;
		    
			case 'COMPLETED':
			    // all items in PL completed:
			    if (this._currentItem+1>=this.media.length) {
				this._bubbleEvent('done', {});
			    }
			    // next one, pls:
			    this.setActiveItem('next');
			    break;
		    }	
		    break;
		
		case 'buffer':
		    this._bubbleEvent('buffer', value);
		    // update time and progress 
		    this._bubbleEvent('time', value);
		    break;
					
		case 'displayReady':		
		    this._bubbleEvent('displayReady', true);
		    this._addGUIListeners();	
		    this._syncWithPlugins();		    
		    break;
		
		case 'FFreinit':		
		    break;
		
		case 'seek':
		    this._bubbleEvent('seek', {dest:value});
		    break;
		
		case 'volume':
		    this.setItemConfig({volume: value});             
		    this._bubbleEvent('volume', value);
		    break;
		
		case 'progress':
		    this._bubbleEvent('progress', value);
		    break;
		
		case 'time':
		    this._bubbleEvent('time', value);
		    break;
		
		case 'fullscreen':
		    this._bubbleEvent('fullscreen', value);	    
		    break;
		
		case 'resize':
		    this.playerModel.applyCommand('resize');
		    this._bubbleEvent('resize', value);	    
		    break;		
    
		case 'playlist':		
		    this.setFile(value, true);
		    break;
		
		case 'config':
		    this.setItemConfig(value);
		    break;
	    }
    
	};
    
	this._syncWithPlugins = function(callback) {
	    // wait for all plugins to re-initialize properly
	    var ref = this;
	    this.env.loading = true;
	    if (this.plugins.length==0) {
		this._debug('Plugins Ready!');
		this._bubbleEvent('pluginsReady', {});
		this.env.loading = false;
		callback();
		return;
	    }
	    (function() {
		try{
		    for(var i=0; i<ref.plugins.length; i++) {
			if (ref.plugins[i].pluginReady!==true) {
			    setTimeout(arguments.callee,80);
			    return;
			}			
		    }
		    ref._debug('Plugins Ready!');
		    ref.env.loading = false;
		    ref._bubbleEvent('pluginsReady', {});
		    try {callback();}catch(e){}
		} catch(e) {}
	    })();	
	}
	
	/* attach mouse-listeners to GUI elements */
	this._addGUIListeners = function() {
	    var ref = this;
	    
	    this.env.playerDom.unbind();
	    this.env.playerDom.mousemove(function(event){ref._displayMousemoveListener(event); });	
	    this.env.playerDom.mouseenter(function(event){ref._displayMouseEnterListener(event); });
	    this.env.playerDom.mouseleave(function(event){ref._displayMouseLeaveListener(event); });	
        
	    // keyboard interface get rid of this moz.warning
	    if (this.config.enableKeyboard===true) {
		if (!$.browser.mozilla) {		
		    $(document.documentElement).unbind('keydown.pp'+this._id);
		    $(document.documentElement).bind('keydown.pp'+this._id, function(evt){
			ref._keyListener(evt);
		    });
		} else {
		    $(document.documentElement).unbind('keypress.pp'+this._id);		    
		    $(document.documentElement).bind('keypress.pp'+this._id,function(evt){
			ref._keyListener(evt);
		    });
		}
	    }
    
	};
	
	/* remove mouse-listeners */
	this._removeGUIListeners = function() {
	    $("#"+this.getId()).unbind();
	    this.env.playerDom.unbind();
	};
    
	/* add plugin objects to the bubble-event queue */
	this._registerPlugins = function() {
	    // nothing to do / we donÂ´t do this twice
	    if (this.config.plugins.length>0 && this.plugins.length==0) {
		for(var i=0; i<this.config.plugins.length; i++) {
		    var pluginName = "projekktor"+this.config.plugins[i];
		    var pluginObj = $.extend(true, {}, new projekktorPluginInterface(), eval(pluginName).prototype);
		    pluginObj.name = this.config.plugins[i].toLowerCase();
		    pluginObj.player = this;
		    pluginObj.playerDom = this.env.playerDom; 	
		    pluginObj._init( this.config['plugin_'+this.config.plugins[i].toLowerCase()] || {} );
		    this.plugins.push( pluginObj );
		}
	    }
	};
	
	/* removes some or all eventlisteners from registered plugins */
	this._unbindPlugins = function(rmvPl) {
	    if (this.plugins.length==0) return;
	    var pluginsToRemove = rmvPl ||[];	
	    for (var j=0; j<this.plugins.length; j++){
		if ($.inArray(j, pluginsToRemove) || pluginsToRemove.length===0) {
		    $(this.plugins[j]).unbind();
		}
	    }    	        
	};
	
    
	/* promote an event to all registered plugins */
	this._bubbleEvent = function(evt, value) {

	    var event = evt, pluginData={};
	    if (typeof event=='object') {
		if (!event._plugin) return;
		value.PLUGIN = event._plugin+"";
		value.EVENT = event._event+""
		event = 'pluginevent'
	    }
	    
	    
	    if (event!='time' && event!='progress' && event!='mousemove') {		
		this._debug("Fireing :"+event);
	    }
	    
	    // fire on plugins
	    if (this.plugins.length>0) {
		for(var i in this.plugins) {
		    try{
		        this.plugins[i][event+"Handler"](value, this);
		    } catch(e){};
		}
	    }
	    // fire on custom listeners
	    if (this.listeners.length>0) {
		for(var i in this.listeners) {
		    try{
			if ( this.listeners[i]['event']==event || this.listeners[i]['event']=='*' ) {
			    this.listeners[i]['callback'](value, this);
			}
		    } catch(e){};
		}
	    }
	};    
	
	/* destoy, reset, break down to rebuild */ 
	this._detachplayerModel = function() {
	    this._isReady = false;

	    try {
		$(this).unbind();
		this._unbindPlugins();
		this._removeGUIListeners();	   	    
		this.playerModel.destroy();		
	    } catch(e) {
		this.playerModel = new playerModel();
		this.playerModel.init({controller:this, autoplay: false});
	    }

	    this._bubbleEvent('detach', {});	
	};
	    
	
	/*******************************
	      GUI LISTENERS
	*******************************/    
	this._displayMousemoveListener = function(evt) {
	    this._bubbleEvent('mousemove', {});
	    // if($.browser.msie) {evt.cancelBubble=true;} else {evt.stopPropagation();}
	};
	    
	
	this._displayMouseEnterListener = function(evt) {
	    this._bubbleEvent('mouseenter', {});
	    this.env.mouseIsOver = true;
	    if($.browser.msie) {evt.cancelBubble=true;} else {evt.stopPropagation();}
	};
	
	
	this._displayMouseLeaveListener = function(evt) {
	    this._bubbleEvent('mouseleave', {});
	    this.env.mouseIsOver = false;
	    if($.browser.msie) {evt.cancelBubble=true;} else {evt.stopPropagation();}
	};    
	    
	this._keyListener = function(evt) {
	    if (this.env.mouseIsOver!==true) return false;
	    if($.browser.msie) {evt.cancelBubble=true;} else {evt.stopPropagation();}
	    evt.preventDefault();
	    
	    this._debug('Keypress: '+evt.keyCode);
	    // escape from fullscreen
	    this._bubbleEvent('key', evt.keyCode);
	    switch( evt.keyCode ) {
		case 27: // esc
		    this.setFullscreen(false);
		    break;
		case 13: // enter
		    this.setFullscreen(true);
		    break; 
		case 39: // right arrow		    
		    this.setActiveItem('next');
		    break;
		case 37: // left arrow		
		    this.setActiveItem('previous');
		    break;   
		case 0: // everything else
		    this.setPlayPause();
		    break;
	    };
	    return false;
	};
	
	/*****************************************
	    DOM Manipulations
	*****************************************/
	/* make player fill the whole window viewport */
	this._enterFullViewport = function() {
	    
	    // nothing to do
	    if (this.env.inFullscreen===true) {
		return;
	    }
	    
	    // remember current attributes
	    this.env.scrollTop = $(window).scrollTop();
	    this.env.scrollLeft = $(window).scrollLeft();
	    this.env.playerStyle = this.env.playerDom.attr('style');
	    this.env.bodyOverflow = $('body').css('overflow');	
			    
	    // prepare window:
	    $(window).scrollTop(0);
	    $(window).scrollLeft(0);
	    $('body').css('overflow', 'hidden');
	    
	    // prepare player
	    this.env.playerDom.css({
		position: 'fixed',
		display: 'block',
		top: 0,
		left: 0,
		width: '100%',
		height: '100%',
		zIndex: 99997
	    });
	
	    // widdy well
	    this.env.inFullscreen = true;
	};
	
	/* reset player from "full window viewport" */
	this._exitFullViewport = function() {
    
	    // nothing to do
	    if (this.env.inFullscreen===false) {
		return;
	    }
	    
	    // reset player
	    this.env.playerDom.attr('style', this.env.playerStyle);
	    
	    // reset window
	    $('body').css('overflow', this.env.bodyOverflow)   
	    $(window).scrollTop(this.env.scrollTop);
	    $(window).scrollLeft(this.env.scrollLef);
	  
	    // widdy well
	    this.env.inFullscreen = false;	
	};
	
	/* make sandbox fill the whole parent window viewport */
	this._enterSandboxFullViewport = function() {
	    
	    // nothing to do
	    if (this.env.inFullscreen===true) {
		return;
	    }
		    
	    // get relevant elements
	    var win = this.getSandboxWindow();
	    var iframe = this.getSandboxIframe();

	    if (!win || !iframe) return;
	    
	    // remember relevant attributes
	    this.env.scrollTop = win.scrollTop();
	    this.env.scrollLeft = win.scrollLeft();
	    this.env.playerStyle = iframe.attr('style');
	    this.env.sandBoxWidth = iframe.attr('width');
	    this.env.sandBoxHeight = iframe.attr('height');
	    this.env.bodyOverflow = $(win[0].document.body).css('overflow');	
		    
	    // prepare parent window
	    win.scrollTop(0);
	    win.scrollLeft(0);
	    $(win[0].document.body).css('overflow', 'hidden');
	    
	    // prepare player
	    iframe.css({
		position: 'fixed',
		display: 'block',
		top: 0,
		left: 0,
		width: '100%',
		height: '100%',
		zIndex: 9999
	    });
	
	    // widdy well
	    this.env.inFullscreen = true;
	};
	
	/* reset player from "full parent window viewport" sandbox thing */
	this._exitSandboxFullViewport = function() {
	    	    
	    // nothing to do
	    if (this.env.inFullscreen===false) {
		return;
	    }
		    
	    // get relevant elements
	    var win = this.getSandboxWindow();
	    var iframe = this.getSandboxIframe();
    	    
	    if (!win || !iframe) return;
	    
	    // reset 
	    win.scrollTop(this.env.scrollTop);
	    win.scrollLeft(this.env.scrollLef);
	    $(win[0].document.body).css('overflow', this.env.bodyOverflow)

	    iframe.attr('width', this.env.sandBoxWidth+"px");
	    iframe.attr('height', this.env.sandBoxHeight+"px");
	    iframe.attr('style', (this.env.playerStyle==undefined) ? '' : this.env.playerStyle );
	    
	    // widdy well
	    this.env.inFullscreen = false;	
	};
	    
    
	
	
	/*******************************
	public (API) methods GETTERS
	*******************************/
	this.getItemConfig = function(name, itemIdx) {

	    var idx = itemIdx || this._currentItem;
	    var result = false;
    
	    if (this.config[name]!==undefined) {
		
		// grab defaults
		result = this.config[name];
		
		// get value from user config
		if ($.inArray(name, this._persistentConfOpts)>-1) {
		    if (this._cookie(name)!==null) {
			result = this._cookie(name);
		    }
		}

		// get value from item-specific config (beats them all)
		if ($.inArray(name, this._dynamicConfOpts)>-1 || name.indexOf('plugin_')>-1) {
		    try {
			if (this.media[idx]['config'][name]!==undefined && this.media[idx]['config'][name]!==false) {
			    result = this.media[idx]['config'][name];
			}
		    } catch(e){}
		}	    
		
	    } else {
		// pass through plugin config parameters
		try {
		    if (this.media[idx]['config'][name]) {
			result = this.media[idx]['config'][name];
		    }
		} catch(e){}
	    }
	    
	    return result;
	};    
	    
	this.getItemCount = function() {
	    return this.media.length;
	};
    
    
	this.getState = function() {
	    try {
		return this.playerModel.getState();
	    }
	    catch(e) {return 'IDLE'}
	};
	    
	this.getIsAutoslide = function() {
	    return this.playerModel.getIsAutoslide();
	};
	    
	this.getLoadProgress = function() {	
	    try {return this.playerModel.getLoadProgress();}
	    catch(e) {return 0;}  
	};
	
	this.getKbPerSec = function() {	
	    try {return this.playerModel.getKbPerSec();}
	    catch(e) {return 0;}  
	};
	
	this.getItemId = function(idx) {
	    if (this.config.poster===undefined) {
		if (idx==undefined) return this.media[this._currentItem].ID;
		return this.media[idx].ID;
	    } else {
		if (idx==undefined) return this.media[this._currentItem+1].ID;
		return this.media[idx+1].ID;	    
	    }
	};
	
	this.getItemIdx = function() {
	    return this._currentItem;
	};
	
	this.getItem = function() {
	    arg = arguments[0] || 'current';
	    
	    switch(arg) {
		case 'next':
		    return $.extend(true, [], this.media[this._currentItem+1]);	
		case 'prev':
		    return $.extend(true, [], this.media[this._currentItem-1]);
		case 'current':
		    return $.extend(true, [], this.media[this._currentItem]);
		case '*':
		    return $.extend(true, [], this.media);
		default:
		    return $.extend(true, [], this.media[arg]);
	    }
	    
	};
	
	this.getVolume = function() {
	    return (this.getItemConfig('fixedVolume')===true)
		? this.config.volume
		: this.getItemConfig('volume');
	};    
	
	this.getTrackId = function() {
	    if (this.getItemConfig('trackId')) {
		return this.config.trackId;
	    }
	    if (this._playlistServer!=null) {
		return "pl"+this._currentItem;
	    }
	    return null;
	};
	    
	this.getLoadPlaybackProgress = function() {
	    try {return this.playerModel.getLoadPlaybackProgress()}
	    catch(e) {return 0;}  
	};
	
	this.getDuration = function() {
	    try {return this.playerModel.getDuration();}
	    catch(e) {return 0;}  
	};
	
	this.getPosition = function() {
	    try {return this.playerModel.getPosition() || 0;}
	    catch(e) {return 0;}  
	};
    
	this.getTimeLeft = function() {
	    try {return this.playerModel.getDuration() - this.playerModel.getPosition();}
	    catch(e) {return this.media[this._currentItem].duration;}  
	};
    
	this.getInFullscreen = function() {
	    return this.env.inFullscreen;
	}
	
	this.getMediaContainer = function() {
	    
	    // return "buffered" media container
	    if (this.env.mediaContainer==null) {
		this.env.mediaContainer = $('#'+this.getMediaContainerId());
	    }
	    
	    // if mediacontainer does not exist ...	    
	    if (this.env.mediaContainer.length==0) {
		// and thereÂ´s a "display", injectz media container
		if ( this.env.playerDom.find('.'+this.config.cssClassPrefix+'display').length>0 ) {
		    this.env.mediaContainer = $(document.createElement('div'))
			.attr({'id':this.getId()+"_media"}) // IMPORTANT IDENTIFIER
			.css({
			    position: 'absolute',
			    overflow: 'hidden',
			    height: '100%',
			    width: '100%',
			    top: 0,
			    left: 0,
			    padding: 0,
			    margin: 0,
			    display: 'block'
			})
			.appendTo( this.env.playerDom.find('.'+this.config.cssClassPrefix+'display') );
		}
		
		// elsewise create a 1x1 pixel dummy somewhere
		else {
		    this.env.mediaContainer = $(document.createElement('div'))
			.attr({id: this.getMediaContainerId()})
			.css({width: '1px', height: '1px'})
			.appendTo( $(document.body) );
		}
		
	    }
	    
	    // go for it
	    return this.env.mediaContainer;
	};

	this.getMediaContainerId = function() {
	    return this.getId()+"_media";
	};      
    
	this.getMediaType = function() {
	    return this.media[this._currentItem].mediaType;
	};

	this.getUsesFlash = function() {
	    return (this.playerModel.requiresFlash !==false)
	};
	
	this.getModel = function() {
	    return this.media[this._currentItem].mediaModel;
	};	
	
	this.getSandboxWindow = function() {
	    try {
		return $(parent.window);
	    } catch(e) {
		return false;
	    }
	};
    
	this.getSandboxIframe = function() {
	    try {
		return window.$(frameElement);
	    } catch(e) {
		return false;
	    }
	};    
    
	this.getPlaylist = function() {
	    return this.getItem('*');
	};

	/* returns the version of the flash player installed for userÂ´s browser. returns 0 on none. */
	this.getFlashVersion = function() {      
	    try {
		try {
		    // avoid fp6 minor version lookup issues
		    // see: http://blog.deconcept.com/2006/01/11/getvariable-setvariable-crash-internet-explorer-flash-6/
		    var axo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash.6');
		    try { axo.AllowScriptAccess = 'always';	} 
		    catch(e) { return '6,0,0'; }				
		} catch(e) {}
		return new ActiveXObject('ShockwaveFlash.ShockwaveFlash').GetVariable('$version').replace(/\D+/g, ',').match(/^,?(.+),?$/)[1].match(/\d+/g)[0];
	    } catch(e) {
		try {
		    if(navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin){
			return (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]).description.replace(/\D+/g, ",").match(/^,?(.+),?$/)[1].match(/\d+/g)[0];
		    }
		} catch(e) {}		
	    }
	    return '0,0,0'.match(/\d+/g)[0];
	};       
       
	this.getCanPlayNatively = function(type) {
	    var checkFor = []
		compTable = this._testMediaSupport(true);
	    if (typeof type=='string') {
		checkFor.push(type);
	    }
	    if (typeof type=='array') {
		checkFor = type;
	    } 	    
	    for(var i in this.mediaGrid) {
		if (compTable[i]=='video' || compTable[i]=='audio') {
		    if (arguments.length===0) {
			return true;
		    } else if ($.inArray(i, checkFor)>-1) {
			return true;
		    }
		}
	    }
	    return false;
	};
	
	this.getId = function() {
	    return this._id;
	};
	
	this.getCssClass = function() {
	    return this.config.cssClassPrefix;  
	};
	
	/*******************************
	public (API) methods SETTERS
	*******************************/	
	this.setActiveItem = function(mixedData) {
    
	    var newItem = 0;
	    var lastItem = this._currentItem;
	    
	    if (this.env.loading===true) {
		return this;
	    }

	    if (typeof mixedData=='string') {
		// prev/next shortcuts
		switch(mixedData) {
		    case 'previous':
			if (this.getItemConfig('disallowSkip')==true && this.getState()!=='COMPLETED') return this;
			newItem = this._currentItem-1;
			break;		
		    case 'next':
			if (this.getItemConfig('disallowSkip')==true && this.getState()!=='COMPLETED') return this;
			newItem = this._currentItem+1;		   
			break;
		    default:
		    case 'poster': {
			result = 0;
			break;
		    }
		}	
	    } else if (typeof mixedData=='number') {
		// index number given		
		newItem = parseInt(mixedData);
	    } else {
		// default
		newItem = 0;
	    }

	    // item change requested...
	    if (newItem!=this._currentItem) {
		// and denied... gnehe
		if (this.getItemConfig('disallowSkip')==true && this.getState()!=='COMPLETED') {
		    return this;
		}	
		this._detachplayerModel();	
	    }    
	    
	    // do we have an autoplay situation?
	    var ap = false;
	    
	    // regular "autoplay" on:
	    if (newItem===0 && lastItem==0 && this.config.autoplay===true) {
		ap = true;
	    }
	    //  "continuous" playback?
	    else if (this.getItemCount()>1 && newItem!=lastItem && this.config.continuous===true && newItem<this.getItemCount()) {
		ap = true;
	    }
	    
	    // always "loop" playlist and disallow illegal indexes:
	    if (newItem >= this.getItemCount() || newItem<0) {
		ap = this.config.loop;
		newItem = 0;
	    }	    

	    // set new item
	    this._currentItem = newItem;
	    
	    // create player instance
	    var newModel = this.media[this._currentItem].mediaModel;	
	    if (newModel=='AUDIOFLASH') {
		newModel = this.getItemConfig('flashAudioModel');
	    } else if (newModel=='VIDEOFLASH') {
		 newModel = this.getItemConfig('flashVideoModel')
	    }
	    
	    newModel = newModel.toUpperCase();
	    
	    // model does not exist or is faulty:
	    try {
		if (typeof eval('playerModel'+newModel)!=='function') {
		    newModel='NA';
		    this.media[this._currentItem].mediaModel = newModel;
		    this.media[this._currentItem].errorCode = 8;
		}
	    } catch(e) {
		newModel='NA';
		this.media[this._currentItem].mediaModel = newModel;
		this.media[this._currentItem].errorCode = 8;
	    }

	    // start model:
	    this.playerModel = new playerModel();
	    this.playerModel = $.extend(true, {}, new playerModel(), eval('playerModel'+newModel).prototype);
	    this.playerModel.init({
		media: $.extend(true, {}, this.media[this._currentItem]),
		model: newModel,
		controller: this,
		environment: $.extend(true, {}, this.env),
		autoplay: ap
	    });
	    	    
	    // send notice to plugins
	    this._bubbleEvent('item', this._currentItem);
	    
	    return this;
	};
	
	this._enqueue = function(command, params)  {
	    this._queue.push({command:command, params:params});
	    this._processQueue();
	};
	
	this._clearqueue = function(command, params)  {
	    this._queue = [];
	};
		
	
	this._processQueue = function() {
	    var ref = this;
	    if (this._processing===true) return;
	    this._processing = true;
	    (function() {
		if (ref.env.loading!==true && ref.playerModel.getIsReady()) {
		    var msg = ref._queue.shift();
		    if (!msg){
			ref._processing = false;
			return;
		    }
		    if (typeof msg.command=='string') {
			ref.playerModel.applyCommand(msg.command, msg.params);
		    } else {
			msg.command();
		    }
		    arguments.callee();
		    return;
		}
		setTimeout(arguments.callee,80);
	    })();		
	}
	
	this.getIsLastItem = function() {
	    return ( (this._currentItem==this.media.length-1) && this.config.loop!==true )
	};

	this.getIsFirstItem = function() {
	    return ( (this._currentItem==0) && this.config.loop!==true )
	};

	this.getIsMobileClient = function() {
	    var uagent = navigator.userAgent.toLowerCase();
	    var mobileAgents = ['android', "windows ce", 'blackberry', 'palm'];

	    for (var i=0; i<mobileAgents.length; i++) {
		if (uagent.indexOf(mobileAgents[i])>-1) {
		    // if (uagent.indexOf('webkit')>-1) return false;
		    return true;
		}
	    }
	    return false;	
	};
	
	/* queue ready */
	this.setPlay = function() {
	    this._enqueue('play', false);
	    return this;
	};
    
	/* queue ready */
	this.setPause = function() {
	    this._enqueue('pause', false);
	    return this;
	};
    
	/* queue ready */
	this.setStop = function() {
	    this._enqueue('stop', false);
	    return this;
	};
	
	/* queue ready */
	this.setPlayPause = function() {
	    if (this.getState()!=='PLAYING') {	    
		this.setPlay();
	    } else {
		this.setPause();
	    }
	    return this;	
	};

	/* queue ready */
	this.setVolume = function(vol) {
	
	    if (this.getItemConfig('fixedVolume')==true) {
		return this;
	    }
 
	    if (typeof vol == 'string') {
		var dir = vol.substr(0,1);
		vol = parseFloat(vol.substr(1));
		vol =  (vol>1) ? vol/100 : vol;
		if (dir=='+') {
		    vol = this.getVolume()+vol;
		} else if (dir=='-') {
		    vol = this.getVolume()-vol;
		} else {
		    vol = this.getVolume();
		}
	    }

	    if (typeof vol == 'number') {		
		vol =  (vol>1) ? 1 : vol;
		vol = (vol<0) ? 0 : vol;
		this._enqueue('volume', vol);
	    }

	    return this;
	};	
   
   	/* queue ready */
	this.setPlayhead = function(position) {    
	    if (this.getItemConfig('disallowSkip')==true) return this;	    
	    if (typeof position == 'string') {
		var dir = position.substr(0,1);
		position = parseFloat(position.substr(1));
		
		if (dir=='+') {
		    position = this.getPosition()+position;
		} else if (dir=='-') {
		    position = this.getPosition()-position;
		} else {
		    position = this.getPosition();
		}
	    }	    
	    if (typeof position == 'number') {
		this._enqueue('seek', position);
	    }	    
	    return this;
	};

	/* queue ready */
	this.setPlayerPoster = function(url) {	   
	    var ref = this;
	    this._enqueue(function() {ref.setItemConfig({poster:url},0);});
	    return this;
	};
	
	this.setItemConfig = function() {
	    var ref = this;
	    var args = arguments;
	    this._enqueue(function() {ref._setItemConfig(args[0] || null, args[1] || null)});
	    return this;	    
	};
	
	this._setItemConfig = function() {
	
	    if (!arguments.length) {
		return result;
	    } 	    
	    
	    var confObj = arguments[0];	
	    var dest = '*';
	    
	    if (typeof confObj != 'object') {
		return this;
	    }

	    if (arguments[1] == 'string' || arguments[1] == 'number') {
		dest = arguments[1];
	    } else {
		dest = this._currentItem;
	    }

	    var value = false;
	    for (var i in confObj) {
		if ($.inArray(i, this._persistentConfOpts)>-1) {
		    this._cookie(i, this._cleanValue(confObj[i]));
		}
		
		if ($.inArray(i, this._dynamicConfOpts)===-1) continue;
		value = this._cleanValue(confObj[i]);
		if (dest == '*') {
		    $.each(this.media, function() {
			if (this.config == undefined) {
			    this.config = {};
			}
			this.config[i] = value;			
		    });
		    continue;
		}
		
		if (this.media[dest] == undefined) return this;
		
		if (this.media[dest]['config'] == undefined) {
		    this.media[dest]['config'] = {};
		}

		this.media[dest]['config'][i] = value;
	    }
	    return this;
	};
	
	this.setFullscreen = function(full) {
	    if (full==this.getInFullscreen()) return this;
            if (!this.config.enableFullscreen) return this;
            if (this.config.sandBox!==false) {
                if (full==true) this._enterSandboxFullViewport();
                else this._exitSandboxFullViewport();    
            } else {
                if (full==true) this._enterFullViewport();
                else this._exitFullViewport();
            }           
            this.playerModel.applyCommand('fullscreen', full);
            return this;
        };
	
	this.setResize = function() {
	    this._modelUpdateListener('resize');
	    return this;
	};
	
	this.addListener = function(evt, callback) {
	    var ref=this;
	    this._enqueue(function() {ref._addListener(evt, callback)});
	};
	this._addListener = function(evt, callback) {
	    var listenerObj = {event:evt, callback:callback}
	    this.listeners.push(listenerObj);
	    return this;
	};    

	
	/* removes an JS object from the bubble-event queue */
	this.removeListener = function(evt, callback) {
	    var len = this.listeners.length;
	    for (var i=0; i<len;i++) {
		if (this.listeners[i].event!=evt && evt!=='*') continue;	   
		if (this.listeners[i].callback!=callback && callback!==undefined) continue;
		this.listeners.splice(i,1);		
	    }
	    return this;
	};
	
	this.setItem = function() {
	    // arg0 -> item obj 
	    // arg1 -> position (int)
	    // arg2 -> replace (bool)
	    
	    var itemData = arguments[0];
	    var affectedIdx = 0;
	    
	    this._clearqueue();
	    
	    if (this.env.loading===true) {
		return this;
	    }
	    
	    if (itemData==null) {
		// remove item
		affectedIdx = this._removeItem(arguments[1]);
		if (affectedIdx===this._currentItem) {
		    this.setActiveItem('previous');
		}
	    }
	    else {
		// add/set item
		affectedIdx = this._addItem( this._prepareMedia({file:itemData, config:itemData.config || {}}), arguments[1], arguments[2]);
		if (affectedIdx===this._currentItem) {
		    this.setActiveItem(this._currentItem);		  
		} 
	    }
	    return this;
	};
    
	this.setFile = function(arg, ext, dt) {

	    var data = arg || {};
	    var externalData = ext || false;
	    var result = {};
	    var dataType = dt || false;
	    
	    this._clearqueue();
	    
	    if (this.env.loading===true) return this;		    
	    if (typeof data=='object' && data.length==0) {
		return false;
	    }
	    this.env.loading = true;
	    this._detachplayerModel();
 
	    // arg could be an object - built out of a JSON playlist for example.
	    // or as extracted out of the origin media tag
	    if (typeof data=='object') {
		if (data.length==0) {		     
		    this._reelUpdate({});
		    return false;
		}
		this._debug('Applying incoming JS Object', data);
		this._reelUpdate(data);
		return this;
	    }	
    
	    // data could be a string - for hashed iframe URLs, you know.
	    if (typeof data=='string') {
		var splt = [];
		splt[0] = data;
	      
		// two in one?
		if (data.indexOf(this.config.FilePosterSeparator)>-1) {
		    splt = data.split(this.config.FilePosterSeparator)
		    data.config = {poster:splt[1]};
		} else {
		    result[0] = {};
		    result[0].file = data;
		}

		if (externalData===false) {
		    this._debug('Applying incoming single file:'+result[0]['file'], data);
		    this._reelUpdate(result);
		} 
		else {
		    this._debug('Loading external data from '+splt[0]);		    
		    this._playlistServer = splt[0];
		    this.getFromUrl(splt[0], this, '_reelUpdate', this.config.reelParser);
		}
	    }	
	    return this;
	};
    
	/**
	* Completly usesless junk
	* @public
	* @return {Object}
	*/    	    
    	this.ping = function() {
	    alert("pong");
	    return this;
	}
		
	/**
	* Removes THIS Projekktor and reconstructs original DOM
	*
	* ENQUEUED
	* 
	* @public
	* @return {Object} this
	*/
	this.selfDestruct = function() {
	    var ref = this;
	    this._enqueue(function() {ref._selfDestruct();});
	    return this;
	},    	
	this._selfDestruct = function() {
	    var ref = this;
	    $(this).unbind();
	    this._unbindPlugins();
	    this._removeGUIListeners();
	    this.env.playerDom.replaceWith(this.env.srcNode);
	    $.each(projekktors, function(idx) {
		try {
		    if (this.getId() == ref.getId() || this.getId() == ref.getId() || this.getParent() == ref.getId())  {
			projekktors.splice(idx, 1);
			return;
		    }
		} catch(e){}
	    });	    
	    return this
	}
	
	/**
	* Removes THIS Projekktor and reconstructs original DOM
	*
	* ENQUEUED
	* 
	* @public
	* @return {Object} this
	*/
	this.reset = function() {
	    var ref = this;
	    this._enqueue(function() {ref._reset();});
	    return this;
	},
	
	this._reset = function() {
	    var ref = this;
	    $(this).unbind();
	    this._unbindPlugins();
	    this._removeGUIListeners();
	    // prepare compatibility-table
	    this.mediaGrid = this._testMediaSupport();		    
	    this._reelUpdate(this.config.playlist);
	    return this;
	},
    
	/********************************************************************************************
		GENERAL HELPERS
	*********************************************************************************************/
	/**
	 * _cookie; heavily inspired by jQuery Cookie plugin
	 * by (c) 2010 Klaus Hartl (stilbuero.de)
	 */
	this._cookie = function (key, value) {

	    var options = {};
	    
	    // iphone will fail if you try to set a cookie this way:
	    if (this.env.clientConfig.supportsCookies===false)
		return;
	    
	    // set cookie:
	    if (arguments.length > 1 && (value === null || typeof value !== "object")) {		

		// delete cookie on value NULL
		if (value === null) {
		    options.expires = -1;
		}
	
		if (typeof options.expires === 'number') {
		    var days = options.expires, t = options.expires = new Date();
		    t.setDate(t.getDate() + days);
		}
	
		return (document.cookie = [
		    encodeURIComponent(this.config.cookieName+"_"+key), '=',
		    options.raw ? String(value) : encodeURIComponent(String(value)),
		    options.expires ? '; expires=' + this.config.cookieExpiry.toUTCString() : '', // use expires attribute, max-age is not supported by IE
		    options.path ? '; path=' + options.path : '',
		    options.domain ? '; domain=' + options.domain : '',
		    options.secure ? '; secure' : ''
		].join(''));
	    }

	    // get cookie data:
	    options = value || {};
	    var result, decode = options.raw ? function (s) { return s; } : decodeURIComponent;
	    var returnthis =  (result = new RegExp('(?:^|; )' + encodeURIComponent(this.config.cookieName+"_"+key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
	   
	    return (returnthis!=null) ?  this._cleanValue(returnthis) : null;
	    
	};

	
	/* generates an array of mediatype=>playertype relations depending on browser capabilities */
	this._testMediaSupport = function(foceTest) {
	    var result = [];
	    var hasNativeAudio = false;
	    var hasFlash = (this.getFlashVersion()>0);	
	    var nativeElementType = '';
    
	    for (i in this.mediaTypes) {         	    
		
		// per default we canÂ´t play anything 
		result[this.mediaTypes[i]['type']] = 'NA';
		
		// we love all images
		if (this.mediaTypes[i]['model']=='image' && this.mediaTypes[i]['platform']=='native') {
		    result[this.mediaTypes[i]['type']] = 'image';  
		    continue;
		}
		
		// we love our own universe of thoughts even more
		if (this.mediaTypes[i]['platform']=='internal') {
		    result[this.mediaTypes[i]['type']] = this.mediaTypes[i]['model'];  
		    continue;
		}	    
		
		// flash plugin available
		if ( (hasFlash==true || this.mediaTypes[i]['fixed']==='maybe') && this.mediaTypes[i]['platform']=='flash') {
		    if (this.mediaTypes[i]['model'].indexOf('flash')>-1) {
			if (this.getItemConfig('enableFlashFallback')==true || foceTest===true) {
			    result[this.mediaTypes[i]['type']] = (this.mediaTypes[i]['type'].indexOf('audio')>-1)
				? 'audioflash'
				: 'videoflash'
			}
		    }
		    else {
			result[this.mediaTypes[i]['type']] = this.mediaTypes[i]['model'];
		    }
		}	    
			
		// check if we can handle this with html5 - which is prefered
		if (this.mediaTypes[i]['fixed']!==true && (this.getItemConfig('enableNativePlayback')!==false || foceTest===true)) {
		    if ((this.mediaTypes[i]['type'].indexOf('video')>-1 || this.mediaTypes[i]['type'].indexOf('audio')>-1)) {
			try {        				
			    nativeElementType = (this.mediaTypes[i]['type'].indexOf('video')>-1) ? 'video' : 'audio';
			    var testObject = document.createElement(nativeElementType); 
			    if (testObject.canPlayType!=false) {
				switch ( testObject.canPlayType(this.mediaTypes[i]['type']) ) {
				    case "no": break
				    case "": break;
					
				    // optimizm now:
				    case "maybe":
					if ($.browser.opera) { break; }
				    case "probably":
				    default:
					result[this.mediaTypes[i]['type']] = nativeElementType;
				}
			    }    		
			} catch (e) {}
		    }
		}
	    }
	    
	    this._debug('Client media support matrix:', result);
	    return result;
	};    
	
	/* generates a random string of <length> */
	this.randomId = function(length) {
	    var chars = "abcdefghiklmnopqrstuvwxyz";
	    var result = '';
	    for (var i=0; i<length; i++) {
		    var rnum = Math.floor(Math.random() * chars.length);
		    result += chars.substring(rnum,rnum+1);
	    }
	    return result;
	};    
	
    
	this.toAbsoluteURL = function (s) {
	    var l = location, h, p, f, i;
	    if (/^\w+:/.test(s)) {
		return s;
	    }
	    
	    h = l.protocol + '//' + l.host;
	    if (s.indexOf('/') == 0) {
		return h + s;
	    }
	    
	    p = l.pathname.replace(/\/[^\/]*$/, '');
	    f = s.match(/\.\.\//g);
	    if (f) {
		s = s.substring(f.length * 3);
		for (i = f.length; i--;) {
		    p = p.substring(0, p.lastIndexOf('/'));
		}
	    }
	    
	    return h + p + '/' + s;
	};
    
	/**
	* replaces {}-tags with parameter equialents
	* @private
	* @param (String) Da string to get processed
	* @param (Object) Object holding data to fill in
	* @return (String) Da parsed string
	*/      
	this.parseTemplate = function(template, data) {
	    var i;
	    if (data.length==0 || typeof data != 'object') return template;
	    for(i in data) {
		template = template.replace(new RegExp('{'+i+'}', 'gi'), data[i]);
	    }
	    template = template.replace(/{(.*?)}/gi, '');
	    return template;
	};  
    
	/* format strings to proper interpreter values */
	this._cleanValue = function(value) {
	    switch (value) {
		case 'false': return false; 
		case 'true': return true; 
		case 'null': return null; 
		case 'undefined': return '';
		case undefined: return false;
		default: return (typeof value != 'string' && typeof value != 'number' && typeof value != 'boolean' ) ? false : value;
	    }
	    
	};
	
	this._getFilesFromHash = function(idx) {
    
	    var data = window.location.hash.substring(1);
    
	    if (data==undefined || data==null) return false;
	    
	    if (data.indexOf(this.config.FilePosterSeparator)>-1) {
		data = data.split(this.config.FilePosterSeparator);
	    }

	    if (data[1] && idx==1) {
		return data[1];	
	    }
	    else if (idx==0) {
		return data[0];
	    }
	    
	    return false;
	    
	};
	
	this._getTypeFromFileExtension = function(url) {
    
	    var fileExt = '', extRegEx = [], extTypes = {}, extRegEx = []	
	    
	    // build regex string and filter dublicate extensions:	    
	    for(var i in this.mediaTypes) {
		extRegEx.push( '.'+this.mediaTypes[i].ext );
		extTypes[this.mediaTypes[i].ext] = this.mediaTypes[i];		
	    }
	    extRegEx = '^.*\.('+extRegEx.join('|')+")$";		    
   	
	    try {
		fileExt = url.match( new RegExp(extRegEx))[1];
		fileExt = (!fileExt) ? 'NaN' : fileExt.replace('.','');
	    } catch(e) { fileExt='NaN'; }	
    
	    return extTypes[fileExt].type;
	    
	};    
	    
	this._debug = function(desc, data) {	
	    
	    // disabled
	    if (this.config.debug===false) return;
    
	    // debug to console
	    if (this.config.debug=='console') {
		try {
		    if (desc) console.log(desc);
		    if (data && this.config.debugLevel>1) console.log(data);
		}catch(e){}
		return;
	    }
	    
	    // debug to dom container
	    var result = '<pre><b>'+desc+"</b>\n";
	    
	    // textify objects 
		if (data && this.config.debugLevel>1) {
		switch(typeof data){
		    case 'undefined':
			break;
		    case 'object':
			var temp = '';
			// temp =this.parseMyJSON(data);
			if (temp=='') {
			    temp = '';
			    for(var i in data){
				temp += i+' : '+data[i]+"\n";
			    }
			}
			result += temp;
			break;
		    case 'string':
			result += data;
		}
		result += '</pre>';
	    }
	    try {$('#'+this.config._debug).prepend(result);}catch(e){}
	};
	
	this._init = function(srcNode) {

	    var ref = this, files=[];
	    
	    this._id = srcNode[0].id || this.randomId(8);
	    srcNode[0].id = this._id;
	    
	    this.env.srcNode = $.extend(true, {}, srcNode);
	     
	    // prepare instance constants
	    if (this.config.width==0) {
		this.config.width = (srcNode.attr('width')) ? srcNode.attr('width') : srcNode.width();
	    }
    
	    if (this.config.height==0) {
		this.config.height = (srcNode.attr('height')) ? srcNode.attr('height') : srcNode.height();
	    }	    
    
	    // get config from tag - Safari does not supply default-bools here:
	    this.config.autoplay = (this.config.autoplay || (srcNode.attr('autoplay')!==undefined && srcNode.attr('autoplay')!==false) );
	    this.config.controls = ((srcNode.attr('controls')!==undefined && srcNode.attr('controls')!==false) || this.config.controls===true);
	    this.config.loop = (srcNode.attr('loop')!==undefined && srcNode.attr('loop')!==false) ? true : this.config.loop;    
	    this.config.title = (srcNode.attr('title')!=='' && srcNode.attr('title')!==undefined && srcNode.attr('title')!==false) ? srcNode.attr('title') : false;                       
	    this.config.poster = ($(srcNode).attr('poster')!=='' && srcNode.attr('poster')!==undefined && srcNode.attr('poster')!==false) ? $(srcNode).attr('poster') : this.config.poster;

	    $(window).resize(function() {
		ref._modelUpdateListener('resize');
	    });
			    
	    // IE7+8 does not keep attributes w/o values:
	    if ($.browser.msie) {
		var htmlTag = srcNode.html().toLowerCase();
		var attr = ['autoplay', 'controls', 'loop'];
		for (var i=0; i<attr.length; i++) {
		    if (htmlTag.indexOf(attr[i])==-1) continue;
		    this.config[attr[i]] = true;
		}
	    }
	    
	    files[0] = [];	    

	    // gather possible data sources
	    if (this.config.sandBox!==false) {		
		// from URL hash (shareable player)
		files[0].push({
		    src: this._getFilesFromHash(0),
		    type: $(this).attr('type') || this._getTypeFromFileExtension(this._getFilesFromHash(0))
		});
		this.config.poster = this._getFilesFromHash(1);
	    }
	    
	    if(srcNode[0].tagName.toUpperCase() == 'VIDEO' || srcNode[0].tagName.toUpperCase() == 'AUDIO') {
				
		// source from media tag
		if (srcNode.attr('src')) {
		    files[0].push({
			src: srcNode.attr('src'),
			type: srcNode.attr('type') || this._getTypeFromFileExtension(srcNode.attr('src'))
		    });            
		} 	
	

		// media tagÂ´s children
		if ($.browser.msie) {
		    // lame browser
		    var childNode = srcNode;
		    do {
			
			childNode = childNode.next('source');
			if (childNode.attr('src')) {
			    files[0].push({
				src: childNode.attr('src'),
				type: childNode.attr('type') || this._getTypeFromFileExtension(childNode.attr('src'))
			    });
			} 			
		    } while (childNode.attr('src'))		    
		} else {
		    // good browsers
		    srcNode.children('source').each( function(){
			if ($(this).attr('src')) {
			    files[0].push({
				src: $(this).attr('src'),
				type: $(this).attr('type') || ref._getTypeFromFileExtension($(this).attr('src'))
			    });
			}                        
		    })
		}
	    }
	    else {
		if ( this.config.playlist ) {
		    files = this.config.playlist;
		}
	    }

	    // mysterious "designer mode"
	    if (this.config.designMode===true) {
		this.config.poster = this.config.desginGrid;	    
	    }
	    	    
	    // agent detection
	    for (var i in this.clientConfig) {
		if (navigator.userAgent.match(new RegExp(this.clientConfig[i].regex))) {
		    this.env.clientConfig = this.clientConfig[i];
		    this._debug('Using alternate config for '+this.env.clientConfig.agent)
		    break;
		}
	    }
		    
	    if (srcNode[0].nodeName=='VIDEO' || srcNode[0].nodeName=='AUDIO')
	    {
		// swap videotag->playercontainer
		this.env.playerDom = $(document.createElement('div'))
		    .attr({
			'id': srcNode[0].id,
			'class': srcNode[0].className,
			'style': srcNode.attr('style')
		    })
		    .css('overflow', 'hidden') // required for plugin canvas
		    .css('width', this.config.width+"px")
		    .css('height', this.config.height+"px");
		    
		srcNode.replaceWith( this.env.playerDom );
	    }
	    else {
		this.env.playerDom = srcNode;
		this.env.playerDom.css('overflow', 'hidden'); // required for plugin canvas
		
		if (!this.env.playerDom.hasClass('speakker')) {
		    this.env.playerDom
			.css('width', this.config.width+"px")
			.css('height', this.config.height+"px");
		}
	    }
	    	    
	    // prepare compatibility-table
	    this.mediaGrid = this._testMediaSupport();	
	    
	    // pubish version info
	    try {$('#projekktorver').html("V"+this.config.version);} catch(e){};
		    		    
	    // load and initialize pluginsÂ´
	    this._registerPlugins();		    
		    
	    // forced full viewport for using player as module in pXL	
	    if (this.config.forceFullViewport==true && this.config.sandBox!==true) {
		this.config.enableFullscreen = false;
		this._enterFullViewport();
	    
	    }
	    
	    // set up sandboxed environment
	    if (this.config.sandBox!==false) {
		// wait for parent window:
		if (this.getSandboxWindow()) {
		    this.getSandboxWindow().ready(function() {
			ref._enterFullViewport();
			ref.env.inFullscreen = false;
		    });
		} else {
		    ref._enterFullViewport();
		    ref.env.inFullscreen = false;
		    this.config.disableFullscreen = true;
		}
	    }

	    // playlist?
	    for (var i in files[0]) {
		// we prefer playlists - search one:
		if (files[0][i].type=='text/json' || files[0][i].type=='text/xml' ) {
		    var dataType = null;
		    try {dataType = files[0][i].type.split('/')[1];} catch(e) {}
		    this.setFile(files[0][i].src, true, dataType);
		    return this;
		}		
	    }
	    
	    
	    
	    if (files.length==undefined)
		this._reelUpdate(this.config.playlist);
	    else 
	        this._reelUpdate((files[0].length>0 && files!==this.config.playlist) ? files : this.config.playlist);
	
	    return this;
	};
	
	return this._init(srcNode);    
    };
    
}});