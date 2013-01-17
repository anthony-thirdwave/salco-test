// JavaScript Document



var ie8Load={
		init:function(){
			//fix image dimension instead of background image cause ie8 just can't do it.
			ieFlash='<div id="background_swfHolder"><img src="/common/images/intranet/template/intranet-BG.png"  width="100%" /></div>';
			$("body").prepend(ieFlash);
			
			//try to prevent ugly page load in IE8
			$("body").css({opacity:0,display:"block"});
			$("body").animate({opacity:1}, 1000);
			
			//fix multiple columns for ie8, so they wrap correctly may need to be updated depending on how it deploys
			$("#contentContainer #centerColumn .centerInner .building-blocks[_pieId$=5]").addClass("ieLastTile");
			//fix empty spaces when dd.name is empty so they remain the proper size, done with styles for ie9 and up
			$("#home #contentContainer #centerColumn .centerInner .building-blocks dl dd.name:empty").html("&nbsp;"); 
			
			//fix lack of bg in phonelist table
			$("article.phonelist tr:nth-child(even)").addClass("extensionOdd");
		}
	}

var fauxSelects={
		init:function(){console.log(optIDs)
			fauxTemp=""; 
			for(i=0;i<optIDs.length;i++){
				//alert($("#"+optIDs+" option").length);
				
				for(bb=0;bb<$("#"+optIDs[i]+" option").length;bb++){
					$("#"+fauxOptIDs[i]+" .fauxOption").append('<a href="'+$("#"+optIDs[i]+" option").eq(bb).val()+'" data-posa="'+i+'" data-number="'+bb+'" data-eid="'+optIDs[i]+'">'+$("#"+optIDs[i]+" option").eq(bb).html()+'</a>');
					
				}
				 if(!document.all){
				$("style").eq(0).append("article #"+fauxOptIDs[i]+".fauxSelect.active{height:"+$("#"+optIDs[i]+" option").length*21+"px}");
				 }else{
					$("head").eq(0).append("<style> article #"+fauxOptIDs[i]+".fauxSelect.active{height:"+$("#"+optIDs[i]+" option").length*21+"px}"+"</style>") 
				}
				/*$("#"+fauxOptIDs[i]).bind("click",function(){
					$(this).toggleClass("active");
				});*/
				
				curPos=$("#"+optIDs[i]+" option:selected").index();
				
				if(curPos>0){
					$("article #"+fauxOptIDs[i]+".fauxSelect .fauxOption").css({marginTop:"-"+curPos*21+"px"});	
				}
				$("article #"+fauxOptIDs[i]+".fauxSelect .fauxOption a").bind("click", function(event){
					event.preventDefault();
					//if($(this).parent().parent().attr("id") )
					for(zz=0;zz<$(".fauxSelect").length;zz++){
						if($(this).parent().parent().attr("id")!= $(".fauxSelect").eq(zz).attr("id") ){
							$(".fauxSelect").eq(zz).removeClass("active")
						}
					}
					
					if($(this).parent().parent().hasClass("active")==false){
						$(this).parent().parent().addClass("active");
					}else{
						$(this).parent().parent().removeClass("active");
						fauxSelects.changeOption($(this).data("eid"),$(this).data("number"),$(this).data("posa"));
					}
					
				})
			}
			
			//check position of select
			for(xs=0;xs<$("#"+optIDs+" option").length;xs++){
				if($("#"+optIDs+" option").eq(xs).attr("select")==""){
					$("article #"+fauxOptIDs+".fauxSelect .fauxOption").css({marginTop:"-"+xs*21+"px"})
				}
			}
		},
		changeOption:function(eid,num,pas){
			//alert(eid+" "+num);
			$("#"+eid+" option").attr("selected","");
			
			$("#"+eid+" option").eq(num).attr("selected","selected");
			//alert($("#"+eid+" option").parent().parent())
			$("#"+eid+" option").parent().parent().submit();
			if($("body").attr("id")=="orders"){
				$("#"+eid+" option").parent().parent().parent().submit();
			}
			
			if(num==0){
					$("article #"+fauxOptIDs[pas]+".fauxSelect .fauxOption").css({marginTop:"0px"});	
				}
			
			if(num>0){
					$("article #"+fauxOptIDs[pas]+".fauxSelect .fauxOption").css({marginTop:"-"+num*21+"px"});	
				}/**/
				
				//$("#"+eid).parent().submit();
				
		}
		
	}
	
$(window).load(function() {
	// launch browser detect script
	BrowserDetect.init();
	//initiate maximus scripts
	maximusPortable.init();
	
	
});

var ieFixes={
	init:function(){
		$("#utilityNavigation ul li").eq(0).addClass("ult-adp");
		$("#utilityNavigation ul li").eq(1).addClass("ult-halfHoliday");
		$("#utilityNavigation ul li").eq(2).addClass("ult-phonelist");
		$("#utilityNavigation ul li").eq(3).addClass("ult-salcoHome");
	}
}
	
var maximusPortable={
	init:function(){
		// get browser details
	    	bOS=BrowserDetect.OS;
		bOS=bOS.toLowerCase();
		bBO=BrowserDetect.browser;
		bBO=bBO.toLowerCase();
		//add classes to html and body tags
		$("html").addClass(bOS);
		//alert(bOS);
		$("html").addClass(bBO); 
		$("html").addClass(bBO+BrowserDetect.version);
		if(bBO=="explorer"){
			$("html").addClass("ie"+BrowserDetect.version);
		}
		$("body").addClass("bVer"+BrowserDetect.version);
		//run ie8 fixes
		if($("html").hasClass("ie8")){
			ieFixes.init();
			ie8Load.init();
		}
		
		
	}
	
	
};
	
//browser detect script from quircksmode
// http://www.quirksmode.org/js/detect.html

var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{
			string: navigator.userAgent,
			subString: "Chrome",
			identity: "Chrome"
		},
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			prop: window.opera,
			identity: "Opera",
			versionSearch: "Version"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			   string: navigator.userAgent,
			   subString: "iPhone",
			   identity: "iPhone/iPod"
	    },
		{
			   string: navigator.userAgent,
			   subString: "iPad",
			   identity: "iPad"
	    },
		{
			string: navigator.userAgent,
			subString: "Android",
			identity: "Android"
		},
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};

$(window).load(function() {
	
   if($(".event-listing .artContent").length==1){
	   document.location="#title_"+HighlightMonth;
   }
   
  // Handler for .load() called.
  $(".opcl").bind("click",function(event){
	  
	  if(location.hash!="" || location.hash!="#"){
		event.preventDefault();
		window.location="#";  
	  }
   });
   
   if($("object").length>0){
	   $("#wrapper").addClass("pdf-flash");
	   if($("object embed").length>0 && $(window).width() > 1890){
		   $("object").attr("width",700);
		   $("object embed").attr("width",700);
		   
		   $("object").attr("height",550);
		   $("object embed").attr("height",550);
		   
		   
		   
		}
	}else{
		$("#wrapper").attr("class","");
	}
	
	
		if($(window).width() > 1890){   
		   if($("#halfdays-amp-holidays").length==1){
		   	tempSrc=$("object").attr("data");
			console.log(tempSrc);
			rep=tempSrc.replace(/zoom=52.1/,"zoom=100");
			$("object").attr("data",rep);
		   }
		}
   
   $("span.opcl:before").bind("click",function(event){
	  alert("check")
	  if(location.hash!="" || location.hash!="#"){
		event.preventDefault();
		window.location="#";  
	  }
   });
   
   /* for news and other sections with blurb links */
   $(".building-blocks").bind("click",function(){
	   if($(this).find("dl dd.blurb").length==1){
		   document.location=$(this).find("dl dd.blurb a").attr("href");
	   }
	});
	
	/* window load funcitonality */
	$("body").addClass("loaded");
	
	console.log($(window).width());
	// add kiosk timeout
	var ttimer;
	if($("html").hasClass("firefox")==true && $(window).width() > 1890){
		
		if($("div").hasClass("employees")==true || $("article").hasClass("employee")==true){
			$("body").addClass("employees-listing");
			$("#empl-nav-title").html("employees list s:")
			for(ia=0;ia<$("#empl-nav ul li").length;ia++){
				if($("#empl-nav ul li").eq(ia).children().length==0){
					$("#empl-nav ul li").eq(ia).remove();
				}	
			}
		}
		
		if($("div").hasClass("employees")==true){
			$(".employees a").bind("click",function(event){
					event.preventDefault();
					tempLink=$(this).attr("href");
					$.ajax({
					  url:$(this).attr("href"),
					  statusCode: {
					    200:function(){
						 document.location=tempLink;
					    },	  
					    404: function() {
						 alert("Employee detail not found");
					    }
					  }
					});
				});
		}
		
		$('<script />', {
		    src: '/common/scripts/intranet/jquery.idletimer.js',
		    type: 'text/javascript'
		}).appendTo('head');
		
		$('<script />', {
		    src: '/common/scripts/intranet/jquery.idletimeout.js',
		    type: 'text/javascript'
		}).appendTo('head');
		
		$('<script />', {
		    src: '/common/scripts/intranetSlideShow.js',
		    type: 'text/javascript'
		}).appendTo('head');
		
		$('<div />', {
		    id: 'idletimeout',
		}).appendTo('body');
		
		$('<a />', {
		    href: '#tty',
		}).appendTo('#idletimeout');
		
		$.idleTimeout('#idletimeout', '#idletimeout a', {
				idleAfter: 300,
				pollingInterval: 60,
				keepAliveURL: '/common/scripts/intranet/ping.html',
				serverResponseEquals: 'OK',
				onIdle: function(){
					//window.location = "/";
					kioskPageSaver.changePage();
				},
				onResume: function(){
			 
					console.log("resuming");
					//$("body").unbind("click");
					//window.clearTimeout(ttimer);
			 
				}
			});
	}
	
	if($("#centerColumn div[class='employees']")){
		$('.employees a span img[src=""]').attr("src","/common/images/Intranet/template/temp-genericPerson.png");
	}
	
	if($(".empl-left").length==1 && $(".empl-left img").attr("src")==""){
		$(".empl-left img").attr("src","/common/images/Intranet/template/temp-genericPersonLrg.png");
		$(".empl-left img").attr("width","191");
	}
	
	if($(".empl-right").length==1){
		if($(".empl-right .empl-phone").html()==""){
			$(".empl-right .empl-phone").remove();
			$(".empl-right .emp-phone-title").remove();
		}
		
		if($(".empl-right .empl-ext").html()==""){
			$(".empl-right .empl-ext").remove();
			$(".empl-right .empl-ext-title").remove();
		}
		
		if($(".empl-right .empl-email").html()=='<a href="mailto:"></a>'){
			$(".empl-right .empl-email").remove();
			$(".empl-right .empl-email-title").remove();
		}
		
		if($(".empl-right .empl-bday").html()==""){
			$(".empl-right .empl-bday").remove();
			$(".empl-right .empl-bday-title").remove();
		}
		
		if($(".empl-right .empl-hiredate").html()==""){
			$(".empl-right .empl-hiredate").remove();
			$(".empl-right .empl-hiredate-title").remove();
		}
		
		if($(".empl-right .empl-about").html()=="" || $(".empl-right .empl-about").html()=="&nbsp;"){
			$(".empl-right .empl-about").remove();
			$(".empl-right .empl-about-title").remove();
		}
	}
	
	$(".seRow").not(".seRow.titleRow").bind("click",function(){
		window.location=$(this).children("h3").children().attr("href");
	});
	
	
	
	if($(".searchResults .footSePa .pagination ul li:last-child").children().length==0){
		$(".searchResults .footSePa .pagination ul li:last-child").remove();
	}else{
		$(".searchResults .footSePa .pagination ul li:last-child a.capsBlackLink").html("next");
	}
	
	if($(".searchResults .footSePa .pagination ul li:first-child").children().length==0){
		$(".searchResults .footSePa .pagination ul li:first-child").remove();
	}else{
		$(".searchResults .footSePa .pagination ul li:first-child a").html("previous");
	}
	
	
	
	
	if($("#centerColumn article").hasClass("news")==true){
		//alert($("#centerColumn article .alignLeft").length);
		$("body").prepend('<style id="newsStyles"></style>');
		
		imgArray=new Array();
		
		if($("#centerColumn article .alignLeft img").length == 1){
				
				$("#centerColumn article .alignLeft").css({marginRight: "20px"});
			}
		
		if($("#centerColumn article .alignLeft").length > 0){
			for(i=0;i<$("#centerColumn article .alignLeft img").length;i++){
				$("#centerColumn article .alignLeft img").eq(i).wrapAll('<a href="#image-'+i+'"></a>');
				$("#wrapper").wrapAll('<div id="image-'+i+'"></div>');
				
				$("#newsStyles").append('#image-'+i+':target #modalBG{display:block; width:100%; height:100%; opacity:.85; cursor:pointer;}');
				$("#newsStyles").append('#image-'+i+':target .news-item .lrgImgs #lrgImg-'+i+' img{ opacity:1; z-index:50; background:#fff; width:auto; height:auto; top:120px;}');
				
				$("#newsStyles").append('#image-'+i+':target .news-item .lrgImgs #lrgImg-'+i+'{ opacity:1;  background:#fff; width:auto; height:auto; }');
				
				$("#newsStyles").append('#image-'+i+':target .news-item .lrgImgs { opacity:1; z-index:50; background:#fff; width:auto; height:auto; top:120px;}');
				
				$("#newsStyles").append('#image-'+i+':target .news-item .lrgImgs #lrgImg-'+i+'.bigs .closeGal { display:inline-block !important; z-index:40;}');
				
				$("#newsStyles").append('#image-'+i+':target .news-item .lrgImgs #lrgImg-'+i+'.bigs .imgNav { z-index:30; display:inline-block; }');
				
				$("#newsStyles").append('#image-'+i+':target .news-item .lrgImgs .bigs:hover .closeGal { opacity:1;}');
				
				$(".lrgImgs img").eq(i).wrapAll('<div id="lrgImg-'+i+'" class="bigs"  data-title="'+$("#centerColumn article .alignLeft img").eq(i).attr("title")+'"></div>');
				$(".lrgImgs #lrgImg-"+i).append('<a href="#" class="closeGal" Title="Close"></a>');
				
				if($("#centerColumn article .alignLeft img").length > 1){
					if(i==0){
						$(".lrgImgs #lrgImg-"+i).append('<a href="#image-'+(i+1)+'" class="nextImg imgNav"><span>&raquo;</span></a>');
					}else if(i>0 && i < $("#centerColumn article .alignLeft img").length){
						$(".lrgImgs #lrgImg-"+i).prepend('<a href="#image-'+(i-1)+'" class="preImg imgNav"><span>&laquo;</span></a>');
						if(i < ($("#centerColumn article .alignLeft img").length-1)){
							$(".lrgImgs #lrgImg-"+i).append('<a href="#image-'+(i+1)+'" class="nextImg imgNav"><span>&raquo;</span></a>');
						}
					}
					
					
				}
				imgArray[i]=new Image();
				imgArray[i].src=$(".lrgImgs #lrgImg-"+i+" img").attr("src");
				
				//alert(imgArray[i].height)
				
				tempHei=(imgArray[i].height-40)/2;
				$(".lrgImgs #lrgImg-"+i+" a.imgNav span").css({marginTop:tempHei+"px"});
				
			}
			
			
			
			
			$("#centerColumn .centerInner").append('<div id="modalBG"></div>');
			$("#modalBG").bind("click",function(){window.location="#"});
			tempHei2=($(window).height()-(imgArray[0].height+20))/2;
			$(".lrgImgs").css({top:tempHei2+"px"})
		}
		
		
	}
	
	
		
		if($("#centerColumn div.building-blocks").length>0){
			if(!document.all){
				for(i=0;i<$("#centerColumn div.building-blocks").length;i++){
					$("#centerColumn div.building-blocks .image").eq(i).attr("style", 'background:url('+$("#centerColumn div.building-blocks .image").eq(i).children().attr("src")+') no-repeat center center;');		 
					//alert($("#centerColumn div[class='building-blocks'] .image").eq(i).height());
				}
			}
			
			if(document.all){
				setTimeout("ieFixListNewImg.init()",10);
			}
		}
		
		if($("html").hasClass("ie8")==true && $("div.employees").length==1){
			$(".employees a:nth-child(5n+5)").addClass("endOfRow");
			
		}
   /**/
});

var ieFixListNewImg={
	init:function(){
		for(io=0;io<$(".image").length;io++){
					if($("html").hasClass("ie8")==true){
						//alert($(".image").eq(io).children("img").attr("src"))
						$(".image").eq(io).attr("style", 'background:url('+$(".image").eq(io).children("img").attr("src")+') no-repeat center center');
					}else{
						$(".image").eq(io).attr("style", 'background:url('+$(".image").eq(io).children().attr("src")+') no-repeat center center');
					}
				}
	}
};

var inclimateWeather={
	message:"",
	date:"",
	html:"",
	init:function(){
		if($(".building-blocks").eq(0).children().children().html()=="Inclement Weather Closings"){
			$('.blurb ul').nextAll().remove();
			$(".building-blocks").eq(0).children().append('<dd class="image" style="background-image:url(/common/images/Intranet/template/weatherClosing/ClosingPage-weatherRain.png),url(/common/images/Intranet/template/weatherClosing/ClosingPage-weatherSnow.png),url(/common/images/Intranet/template/weatherClosing/ClosingPage-weatherLight.png),url(/common/images/Intranet/template/weatherClosing/ClosingPageBG.png); margin-top:5px; height: 175px;"></dd>');
			
			inclimateWeather.message=$('.blurb').eq(0).html();
				inclimateWeather.date=$('.date').eq(0).html();
				inclimateWeather.html='<div id="inclWHolder"><div id="inclmWAlertClosing"><a href="javascript:void(0)" id="inclmWClose"></a><dl id="inclmWDetail"><dt>Inclement Weather Closings</dt><dd><h4>Salco Products</h4><time>'+inclimateWeather.date+'</time>'+inclimateWeather.message+'</dd></dl></div></div><div id="inclmWOverlay"></div>';
			
			$(".building-blocks").eq(0).unbind("click").bind("click",function(){inclimateWeather.relauch()});
			}
			
			// check for weather alert
			if($(".building-blocks").eq(0).hasClass("incmWeather")==true){
				$('.blurb ul').nextAll().remove();
				$(".building-blocks").eq(0).children().append('<dd class="image" style="background-image:url(/common/images/Intranet/template/weatherClosing/ClosingPage-weatherRain.png),url(/common/images/Intranet/template/weatherClosing/ClosingPage-weatherSnow.png),url(/common/images/Intranet/template/weatherClosing/ClosingPage-weatherLight.png),url(/common/images/Intranet/template/weatherClosing/ClosingPageBG.png); margin-top:5px; height: 175px;"></dd>');
				inclimateWeather.message=$('.blurb').eq(0).html();
				inclimateWeather.date=$('.date').eq(0).html();
				inclimateWeather.html='<div id="inclWHolder"><div id="inclmWAlertClosing"><a href="javascript:void(0)" id="inclmWClose"></a><dl id="inclmWDetail"><dt>Inclement Weather Closings</dt><dd><h4>Salco Products</h4><time>'+inclimateWeather.date+'</time>'+inclimateWeather.message+'</dd></dl></div></div><div id="inclmWOverlay"></div>';
				
				if($("body").attr("id")=="home-1"){
					$("#wrapper").prepend(inclimateWeather.html);
				}
				
				$("#inclmWClose").bind("click",function(){
					$('#inclWHolder').animate({opacity:0},1000,function(){$('#inclWHolder').remove();});
					$('#inclmWOverlay').animate({opacity:0},1000,function(){$('#inclmWOverlay').remove();})
				});
				
				$(".building-blocks.incmWeather").unbind("click").bind("click",function(){inclimateWeather.relauch()});
				
			}
			
		
		
	},
	relauch:function(){
		$("#wrapper").prepend(inclimateWeather.html);
				
				$("#inclmWClose").bind("click",function(){
					$('#inclWHolder').animate({opacity:0},1000,function(){$('#inclWHolder').remove();});
					$('#inclmWOverlay').animate({opacity:0},1000,function(){$('#inclmWOverlay').remove();})
				});
	}
};

$(window).load(function () {
		 inclimateWeather.init();
		$("#calendar .calendar-nav a").bind("click",function(event){
				event.preventDefault();
				jsCal.updateCal($(this).attr("href"));
			});
			
		$(".telSwitch").bind("click",function(event){
			event.preventDefault();
			if($(this).attr("href")=="#extensions"){
				$("#left").show();
				$("#center").show();
				$("#right").show();
				$("#cellphones").hide();
			}
			else{
				$("#left").hide();
				$("#center").hide();
				$("#right").hide();
				$("#cellphones").show();
			}
		});
			/*jsCal.init();
			$("#jseCal a").bind("click",function(){
				$("#jseCal").removeClass("eventSelected");
				$(this).parent().addClass("eventSelected");
			});*/
	});
	
	
	
	var jsCal={
		init:function(){
		
			$("<h3 class='jsDateAdj'>"+jsMonth+jsYear+"</h3>").insertAfter("#prevArrow");
			$(".event_calendar").attr("cellpadding",0);
			$(".event_calendar").attr("cellspacing",0);
			$("#jseCal").addClass("show");
			
			if($("#jseCal td.today a").length==0){
				$("#jseCal td.today").removeClass("eventSelected");
			};
		},
		updateCal:function(pa){
			
			var jscalL=pa+" .eventbox";
			  
			  
			  
			$("#calendar").load(jscalL,function(response, status, xhr){
				
				
				
				
				$("#calendar .calendar-nav a").bind("click",function(event){
					event.preventDefault();
					jsCal.updateCal($(this).attr("href"));
				});
				
				$('<div id="calendarInlineEventsDisplay"><div id="EventCalendarList" class="upcomingEvents"></div></div>').insertAfter(".eventbox");
				console.log($(".calendar-row .today").length);
				if($(".calendar-row .today").length>0){
					/*if($(".calendar-row .today a").length>0){
						$(".calendar-row .today a").click();
						//$(".calendar-row .today a").attr("href")
					}else{
					
					//do something


					}*/
					
					tempCalDate=new Date();
					getCurYear=tempCalDate.getFullYear();
					getCurDate=tempCalDate.getDate();
					getCurMonth=tempCalDate.getMonth()+1;
					
					if(getCurDate < 10){
						tempStD="0"+getCurDate;
					}else{
						tempStD=getCurDate;
					}
					
					if(getCurMonth < 10){
						tempStM="0"+getCurMonth;
					}else{
						tempStM=getCurMonth;
					}
					
					showDate(getCurYear+""+tempStM+""+tempStD);
				}
				
				
				if($(".eventDate a").length>0 && $(".calendar-row .today").length==0){
					
					tempMonthsArray = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
					
					//console.log($(".monthYr .month").html())
					
					splitMonth=$(".monthYr .month").html();
					splitMonth=splitMonth.split(" ");
					
					//console.log(jQuery.inArray(splitMonth[0], tempMonthsArray))
					
					monthLinks=jQuery.inArray(splitMonth[0], tempMonthsArray)+1;
					
					$("#EventCalendarList").append('<div id="eventsInlineSeeAll"><a href="/page/events?ecdm='+monthLinks+'&amp;ecdy='+splitMonth[1]+'">See all '+splitMonth[0]+' Events</a></div>');
				}
				
				
				/*$("#jseCal .eventbox h3").insertAfter("#prevArrow");
				$(".event_calendar").attr("cellpadding",0);
				$(".event_calendar").attr("cellspacing",0);
				$("#jseCal .eventbox h3").insertAfter("#prevArrow");
				$("#jseCal .eventbox h3").addClass("jsDateAdj");
				$("#jseCal").addClass("show");
				$('<ul id="EventCalendarList" class="upcomingEvents"></ul>').insertAfter(".eventbox");
				$("#jseCal td a").bind("click",function(){
					$("#jseCal td").removeClass("eventSelected");
					$(this).parent().addClass("eventSelected");
				});
				
				if($("#jseCal td.today a").length==0){
					$("#jseCal td.today").removeClass("eventSelected");
				};
				*/
				/*
				if($("#jseCal td.today a").length==1){
					tempC=$("#jseCal td.today a").eq(0).attr("href");
					
					tempC=tempC.split("'");
					
					showDate(tempC[1]);
					
					/*$("#js-eCal td.today a").click();*/
				/*};*/
				
			});
		}
		
	};
	
	function showDate(ID){
		if(navigator.appName == "Microsoft Internet Explorer") {
			httpSimple = new ActiveXObject("Microsoft.XMLHTTP");
		} else {
			httpSimple = new XMLHttpRequest();
		} 
		
		httpSimple.abort();
		httpSimple.open("GET", "/common/modules/calendar/EventCalendarHelper.cfm?dateStr=" + ID, true);
		httpSimple.onreadystatechange=function() {
			if(httpSimple.readyState==4) {
				document.getElementById('EventCalendarList').innerHTML=httpSimple.responseText;
				
			}
		}
		httpSimple.send(null); 
	}
var kioskPageSaver={
	pages:[""],
	changePage:function(){
		kioskPageSaver.pages=SlideShow; 
		arl=kioskPageSaver.pages.length;
		if(arl>0){
			var randomnumber=Math.floor(Math.random()*arl);
			console.log(randomnumber);
			console.log(kioskPageSaver.pages[randomnumber]);
			$("body").removeClass("fadein");
			$("body").addClass("fadeout");
			
			$("body").load(kioskPageSaver.pages[randomnumber]+" #wrapper", function(){
				$("#wrapper").attr("class","");
				//$("body").removeClass("fadeout");
				$("body").addClass("fadein");
				//$('#idletimeout a').click();
				setTimeout("kioskPageSaver.changePage()",10000);
				$("body").bind("click", function(){
					document.location=document.location;
					
				});
				$("body").attr("id",kioskPageSaver.pages[randomnumber]);
				if($("#centerColumn div.building-blocks").length>0){
					if(!document.all){
						for(i=0;i<$("#centerColumn div.building-blocks").length;i++){
							$("#centerColumn div.building-blocks .image").eq(i).attr("style", 'background:url('+$("#centerColumn div.building-blocks .image").eq(i).children().attr("src")+') no-repeat center center;');		 
							//alert($("#centerColumn div[class='building-blocks'] .image").eq(i).height());
						}
					}
				
				}
				if(kioskPageSaver.pages[randomnumber]=="employees"){
					$('.employees a span img[src=""]').attr("src","/common/images/Intranet/template/temp-genericPerson.png");
				}
				
			});
		}else{
			document.location="/";
		}
	}
}

var calendarAccordian={
		init:function(){
			//alert($(".calListing").length)
			
			for(ieea=0;ieea<$(".calListing").length;ieea++){
				//alert($(".calListing").eq(ieea).height()+" "+$(".calListing").eq(ieea).attr("data-titleID"));
				tempH=($(".calListing").eq(ieea).height())+5;///2
				//alert(tempH)
				//if(tempH>50){
				//	tempH=tempH-50;
				//	}
				$('style[title="eventCalStyles"]').append("#"+$(".calListing").eq(ieea).attr("data-titleID")+":target+.calListing{height:"+tempH+"px; display:block; -webkit-transition: all 1s ease-out .75s;-moz-transition: all 1s ease-out .75s;	-o-transition: all 1s ease-out .75s;	transition: all 1s ease-out .75s;}");
			}
			
			$('style[title="eventCalStyles"]').append( ".event-listing .artContent .calListing{height:0px; display:block} ");
			
			for(ii=0;ii<$(".calListing dt").length;ii++){
				$(".calListing dt").eq(ii).attr("data-link",$(".calListing dt").eq(ii).siblings().children().attr("href"))
			}
			
			$(".calListing dt").bind("click",function(){
				//alert($(this).siblings().children().html());
				//$(this).siblings().children().click();attr("href")
			
			});
		}
		
		
	};
	
