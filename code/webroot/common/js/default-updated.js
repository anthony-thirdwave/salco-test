// Default Scripts

$(document).ready(function(e) {
	
		/* homepage right links statements */
		
		$("#statements-navigation a").bind("click",function(event){
			event.preventDefault();
			
			$(".ss-statements").each(function(index, element) {
				$(this).removeClass("on");
			});
			
			$("#statements-navigation a").each(function(index, element) {
				$(this).removeClass("on");
			});
			
			$($(this).attr("href")).addClass("on");
			$(this).addClass("on");
		});
		//
		
		$("#feature-prod-nav li a").bind("click",function(event){
			event.preventDefault();
			
			$(".feat-prods").each(function(index, element) {
				$(this).removeClass("on");
			});
			
			$("#feature-prod-nav a").each(function(index, element) {
				$(this).parent().removeClass("on");
			});
			
			$($(this).attr("href")).addClass("on");
			$(this).parent().addClass("on");
			
		});
	
		/* binds for modal links */
		$(".modal-link").bind("click",function(event){
			event.preventDefault();
			temps=$(this).attr("href");
			
			$("#modal-content").load(temps+" #modal-content",function(){
				location.hash=temps;
			});
			temps=temps.split(".");
			temps=temps[0]+"_"+temps[1];
			
			
			
		});
		
		$("#modal-background").bind("click",function(event){
			$("#modal-holder").addClass("closing");
			setTimeout("modalooo.closing()",950);
		});
		
		$("#modal-close a").bind("click",function(event){
			event.preventDefault();
			$("#modal-holder").addClass("closing");
			setTimeout("modalooo.closing()",950);
		});
		var browserWars=$.client.browser;
		
		browserSet.init();
		modalooo.init();
		
	});
	
	/* browser assigning */
	
	browserSet={
		browser:$.client.browser,
		os:$.client.os,
		ieVerTest:function(){
			rv=-1;
			userAgent = navigator.userAgent.toLowerCase();
			var pattern =new RegExp("msie ([0-9]{1,}[\.0-9]{0,})");
			//return pattern.test(userAgent);
			if (pattern.exec(userAgent) != null){
				    rv = parseFloat( RegExp.$1 );
				     
			   }
			  
			return rv;
		},
		init:function(){
			//console.log(browserSet.browser+" "+browserSet.os+" "+browserSet.ieVerTest());
			
			$("html").addClass(browserSet.browser.toLowerCase());
			$("html").addClass(browserSet.os.toLowerCase());
			if(browserSet.ieVerTest()!=-1){
				$("html").addClass("ie"+browserSet.ieVerTest());
				if($("html").hasClass("ie8")==true || $("html").hasClass("ie9")==true){
					hpslides.init();
				}
			}else if(browserSet.browser=="Explorer" && browserSet.ieVerTest()==-1){
				$("html").addClass("ie11");
			}
		}
	}
	
	/* homepage animations for ie8 and ie9 */
	
	var hpslides={
		init:function(){
			n=0;
			
			if($("html").hasClass("ie8")==true){
				$(".ie8 #content-wrapper-home #left-content ul li").eq(0).css({display:"block"});
				$(".ie8 #content-wrapper-home #left-content img.hpfades").eq(0).css({display:"block"});
			}
			setTimeout("hpslides.rotit(0)",15000);
		},
		rotit:function(n){
			en=$("#content-wrapper-home #left-content ul li").length-1;
			if(n<en){
					n++;
				}else{
					n=0;
				}
				
				$("#content-wrapper-home #left-content ul li").animate({opacity:0});
				$("#content-wrapper-home #left-content ul li").css({display:"block"});
				$("#content-wrapper-home #left-content ul li").eq(n).animate({opacity:1});
				//console.log($("#content-wrapper-home #left-content ul li").eq(n).html());
				$("#content-wrapper-home #left-content img.hpfades").animate({opacity:0});
				$("#content-wrapper-home #left-content img.hpfades").css({display:"block"});
				$("#content-wrapper-home #left-content img.hpfades").eq(n).animate({opacity:1});
				setTimeout("hpslides.rotit("+n+")",15000);
		}
		
	}
	
	
	/* script for modals */
	var modalooo={
		init:function(){
			tempsCSS="";
			$(".modal-link").each(function(index, element) {
				//alert($(this).attr("href"));
				temps=$(this).attr("href");
				temps=temps.split(".html");
				temps=temps[0]+"_html";
				//alert(temps)
				
				$("#modal-holder").wrapAll('<div id="'+temps+'"></div>');
				
				tempsCSS+="#"+temps+":target #modal-background{height:100%; width:100%; z-index:100; opacity:1;}#"+temps+":target #modal-outer{height:490px; width:430px; z-index:110; opacity:1;}"
				
			});
			
			$("style").eq(0).append(tempsCSS);
		},
		closing:function(){
			location.hash="";
			$("#modal-holder").removeClass("closing");
		}
	}