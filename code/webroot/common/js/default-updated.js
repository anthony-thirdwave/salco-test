// Default Scripts

$(document).ready(function(e) {
	//set active main nav links
	
	globalNavItems=globalNavItems.split(",");
	
	for(i=2;i<globalNavItems.length;i++){
		
		$("#nav-toggle-container a").each(function(index, element) {
			if(globalNavItems[i]==$(this).attr("data-categoryid")){
				$(this).addClass("navActive");
			}
		});		
	}
	
	$('input#search-text').focus(function() {
		if(this.value == "Search Salco Products..." || this.value == "search") {
			this.value = "";
		}
	});

	$('input#search-text').blur(function() {
		if(this.value == "") {
			this.value = "Search Salco Products...";
		}
	});
	// make sure search form is not blank or contains "Search Salco Products..."
	$( 'form[action="/page/Search"]' ).submit(function( event ) {
  		
		if($('input#search-text').val()=="" || $('input#search-text').val()=="Search Salco Products..."){
			event.preventDefault();
			}
	});
	
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
		
		$("#feature-prod-nav li").each(function(index, element) {
		
			if($(this).children('a').attr('data-id')==""){
				
				$($(this).children('a').attr('href')).css({cursor:"default"});
			}
		});
		
		$(".feat-prods").bind("click",function(){
			featprodstitle=$(this).find("h4").html(); 
			if($("#feat-prods #feature-prod-nav .on a").attr("data-id")!=""){
				_gaq.push(['_trackEvent', 'Featured', 'Clicks', featprodstitle]);
				//alert(featprodstitle)
				document.location=$("#feat-prods #feature-prod-nav .on a").attr("data-id");
				
			}
			
		});
		
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
		setTimeout("modalooo.init()",1000);
		
		/* ie8 fixes literature download */
		if($("#literature-downloads").length>0&&$("html").hasClass("ie8")==true){
			$(".featuredDownloads tbody tr td:nth-child(1)").addClass("lit-table-col-1");
			$(".featuredDownloads tbody tr td:nth-child(2)").addClass("lit-table-col-2");
			$(".featuredDownloads tbody tr td:nth-child(3)").addClass("lit-table-col-3");
			$(".featuredDownloads tbody tr td:nth-child(3) a:nth-child(2)").addClass("downloadLink");
		}
		
		/* faq */
		if($("#faq").length>0){
			
			setTimeout("faqf.init()",500);
			
		}
		
		/* video landing binding */
		$(".vidTable td").bind("click", function(){
			window.location=$(this).find("a").attr("href");
		});
		
		$(".contactAlpha a.alphaemail").bind("click",function(e){e.preventDefault(); 
		
		getNameinfo=$(this).text();
		//getNameinfo=getNameinfo.split(" ");
		//document.location="/page/contact-us-form?contact="+getNameinfo[0]+"_"+getNameinfo[1];
		allContacts.alphaListUpdate(getNameinfo);
																		   
	});
		
		$("#contact-us-aside a.email").bind("click",function(e){e.preventDefault(); 
		
		getNameinfo=$(this).attr("data-name");
		//getNameinfo=getNameinfo.split(" ");
		document.location="/page/contact-us-form?contact="+getNameinfo;//[1]+"_"+getNameinfo[2];
																		   
	});		
	if($("body").hasClass("product-family")==true || $("body").hasClass("product")==true ){
		initNav();
	}
	
	
	/* pagination bindings */ 
	
	$(".pagList .pagination p a").bind("click", function(event){
		event.preventDefault(); getPage($(this).attr("href"), $(this).parent().parent().parent().attr("id")); location.hash="#"+$(this).attr("href")+"^"+$(this).parent().parent().parent().attr("id");
	});
	
			   	   
	$(".pagList .pagination .pagination a").bind("click",function(event) {event.preventDefault(); getPage($(this).attr("href"), $(this).parent().parent().parent().parent().attr("id"));  location.hash="#"+$(this).attr("href")+"^"+$(this).parent().parent().parent().parent().attr("id");});
	
	
	
	//, .product-family #center-content .featuredDownloads tbody tr td
	$(".product #center-content .featuredDownloads tbody tr, .product-family #center-content .featuredDownloads tbody tr").bind("click", function(){
			window.location=$(this).children("td").eq(0).children().attr("href");
		})
	
	});
	
	/*var trackingStuff={
		urlTracks:["/resources/content/5/8/documents/Salco-Calculator-2-3-2.xls","/resources/content/1/1/3/documents/Gasket-material-matrix_2.pdf", "/resources/content/1/2/documents/2014-Calendar.pdf", "/content.cfm/terms-and-conditions", "/resources/content/1/5/documents/Technical-Consulting-Services2_1.pdf"],
		typeTracks:["Technical Information","Technical Information", "About Us", "Services", "Services"],
		labelTracks:["Salco Torque Calculator ver2.3.2","Gasket Material Matrix", "Salco Holiday Calendar", "Terms and Conditions", "Technical Consulting"],
		init:function(){
			$("#site-wrapper a").each(function(index, element) {
				for(i=0;i<trackingStuff.urlTracks.length;i++){
					if($(this).attr("href")==trackingStuff.urlTracks[i]){
						
						tempStuffhold1=trackingStuff.typeTracks[i];
						tempStuffhold2=trackingStuff.labelTracks[i];
						$(this).bind("click",function(){ 
							alert(tempStuffhold1+" - "+tempStuffhold2)
							_gaq.push(['_trackEvent', tempStuffhold1, 'Clicks', tempStuffhold2]);
						})
					}
				}
			});
		}
	}*/
	
	$(window).load(function(){
	
		contactUsMap.init();
		/*trackingStuff.init();*/
		
		
		//airslide fix for chrome
		if($("body").attr("id")=="air-slide" && $("html").hasClass("chrome")==true){ 
			chromereset=$("#product-hero-image").css("padding-top").replace("px","")-2;
			$("#product-hero-image").css({paddingTop:chromereset+"px"});
		}
		
		setTimeout(function(){
			$("#main-navigation ul ul.level-2").each(function(index, element) {
				$(this).css({height:"auto"});
				//alert($(this).parent().children().children().html());
				tempWidt="";
				switch (index){
					case 0:
					tempHH=140;
					break;
					case 1:
					tempHH=186;
					tempWidt='width:120px;';
					break;
					case 2:
					tempHH=80;
					break;
					
				}
                
                tempSecL=0
                 $(this).children().each(function(index, element) {
                    // alert($(this).children().height()); 
                    tempSecL=tempSecL+$(this).children().height(); 
                });
				
				//alert(tempSecL)
                
               
               
                  tempHH=tempSecL*2;
                  if(index==1){
                      tempHH=tempSecL*2.25;
                  }
               
                //alert(tempSecL);
				
				$("<style>#hasSubNav-"+index+" ul{width:"+$(this).parent().width()+"px;} #hasSubNav-"+index+":hover ul {height:"+tempHH+"px; "+tempWidt+"}</style>").insertBefore(this);
				$(this).attr("style","");
				$(this).parent().attr("id","hasSubNav-"+index);
				
			});
			
			
			$("#products-navigation ul ul.level-2").each(function(index, element) {
				$(this).css({height:"auto"});
				 //alert($(this).children().height());
                 tempSecL=0
                 $(this).children().each(function(index, element) {
                    tempSecL=tempSecL+$(this).height();
                    
                });
                // 
                $(this).attr("data-height",tempSecL);
                $(this).css({minHeight:tempSecL+"px"});
                
                
				temperHi=0;
				$(this).children().children().each(function(index, element) {
					moomoo=$(this).children().children().offset();
					temperHi=temperHi+$(this).children().height();
					//if($(this).parent().hasClass("level-3")==false){
					//alert($(this).html());
					//}
				});
				
								
				tempWidthCarrot=$(this).parent().width();
				
				
				
				switch (index){
					case 0:
					tempHH=100;
					break;
					case 1:
					tempHH=100;
					break;
					case 2:
					tempHH=110;
					break;
					case 3:
					tempHH=150;
					break;
					
				}
				
				tempSecL=0
                 $(this).children().each(function(index, element) {
                    // alert($(this).children().height()); 
                    tempSecL=tempSecL+$(this).children().height(); 
                });
				
				//alert(tempSecL)
                
                //tempHH=tempSecL*1.85;
                 if(index==2){
                  tempHH=tempSecL*2; 
                  //alert(tempHH) 
                }else{
                  tempHH=tempSecL*1.85;
                }
				
				$("<style>#hasSubNavP-"+index+" ul{width:"+($(this).parent().width()+24)+"px !important;} #hasSubNavP-"+index+" ul li{width:"+($(this).parent().width()+14)+"px !important;} #hasSubNavP-"+index+" ul li a{width:"+($(this).parent().width()+5)+"px !important;} #hasSubNavP-"+index+" ul .level-3{width:"+($(this).parent().width()+16)+"px !important;margin-left:"+($(this).parent().width()+20)+"px !important;} #hasSubNavP-"+index+":hover ul {height:"+tempHH+"px;}</style>").insertBefore(this);
				$(this).attr("style","");
				$(this).parent().attr("id","hasSubNavP-"+index);
				
			});
			
			$(".level-2 li").not(".level-3 li").each(function(index, element) {
					//alert($(this).height());
					
					$(this).find(".level-3").css({marginTop:"-"+($(this).height()+11)+"px"})
				});

			
		},500);
		
		
		if($("body").attr("id")=="about-us"){
			modalooo.initAboutUs();
		}
		
		if($("body").hasClass("product")==true){
			
			tempsTitleSwitch1=$("#center-content h3 + h2 + h1").html();
			tempsTitleSwitch2=$("#center-content h3 + h2 + h1 + div h1").html();
			$("#center-content h3 + h2 + h1").html(tempsTitleSwitch2);
			$("#center-content h3 + h2 + h1 + div h1").html(tempsTitleSwitch1);
		}
	
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
			
			//news picture modal setup
			$(".inArt .alignLeft .curveMe").each(function(index, element) {
				$(this).attr("data-id",$("body").attr("id")+"-"+index);
				
				$("#modal-holder").wrapAll('<div id="'+$("body").attr("id")+"-"+index+'"></div>');
				$("#modal-content").append('<img class="'+$("body").attr("id")+'-'+index+'" src="'+$(".lrgImgs img").eq(index).attr("src")+'" >');
				tempClassy="."+$("body").attr("id")+"-"+index;
				tempH=$(tempClassy).height();
				tempW=$(tempClassy).width();
				
				tempH2=$(tempClassy).height()+50;
				tempW2=$(tempClassy).width()+20;
				
				tempsCSS+="#"+$("body").attr("id")+'-'+index+":target #modal-background{height:100%; width:100%; z-index:100; opacity:1;}#"+$("body").attr("id")+'-'+index+":target #modal-outer{height:"+tempH2+"px; width:"+tempW2+"px; z-index:110; opacity:1;} ."+$("body").attr("id")+'-'+index+"{display:none} #"+$("body").attr("id")+'-'+index+":target ."+$("body").attr("id")+'-'+index+"{display:block; height:"+tempH+"px; width:"+tempW+"px;}";
			});
			
			$(".inArt .alignLeft .curveMe").bind("click",function(){
				location.hash=$(this).attr("data-id");
			});
			
			$("style").eq(0).append(tempsCSS);
		},
		closing:function(){
			location.hash="";
			$("#modal-holder").removeClass("closing");
		},
		initAboutUs:function(){
			$(".prop a").bind("click", function(event){
				event.preventDefault();
				$("#modal-content").html($(this).html());
				$("#modal-content img").attr("height","");
				$("#modal-content img").attr("width","");
				
				$("#modal-outer").css({height:$("#modal-content").height()+"px", width:($("#modal-content img").width()+60)+"px"});
				$("#modal-holder").addClass("open");
				
				$("#modal-close a").unbind("click").bind("click",function(event){
					event.preventDefault();
					$("#modal-holder").addClass("closing");
					
					setTimeout(function(){
						$("#modal-holder").removeClass("open");
						$("#modal-holder").removeClass("closing");
						$("#modal-content").html($(this).html());
						$("#modal-outer").attr("style","");
						
					},750);
				});
				
				$("#modal-background").unbind("click").bind("click",function(event){
					event.preventDefault();
					$("#modal-holder").addClass("closing");
					
					setTimeout(function(){
						$("#modal-holder").removeClass("open");
						$("#modal-holder").removeClass("closing");
						$("#modal-content").html($(this).html());
						$("#modal-outer").attr("style","");
						
					},750);
				});
			});
		}
	}
	
var faqf={
		init:function(){
		 acstyle="";
		$(".outer").children().each(function(index, element) {
				//alert($(this).height())
				$(this).parent().css({display:"block"});
				$(this).parent().attr("id","outer-"+index);
				$(this).parent().addClass("fixed");
				acstyle+=".expanded #outer-"+index+'{height:'+$(this).height()+'px;} ';
				
			});
			
			$("h4.h a").attr("style","");
			
			$("body").prepend('<style>'+acstyle+'</style>');
			
			$("h4.h").not(".subAcHd").bind("click",function(){
				if($(this).parent().hasClass("expanded")==false){
					$(this).parent().addClass("expanded");
				}else{
					$(this).parent().removeClass("expanded");
				}
			});	
			
			$("h4.h").bind("click", function(event){
				event.preventDefault();
			});
		}
	}
	
/* contact map */

function highlightRegion(region){
	
	$("#contact-us-aside .office").each(function(index, element) {
		$(this).parent().addClass("hidden");
		//$(this).removeClass("shown");
		//console.log($(this).parent().attr("id"));
		
	});
	
	$("#"+region).removeClass("hidden");
	//$("#"+region).addClass("shown");
}

var contactUsMap={
	ieOverItRegion:function(ieClasser){
				holdingC=ieClasser;
				holdingC=holdingC.split(" ");
				holdingC=holdingC[1];
				rO=holdingC;
				
				rO=rO.split("-");
				rO=rO[1];
				rO="rOffice-"+rO;
				if($("."+rO).eq(0).attr("fill")!="#000000"){
					$("."+rO).eq(0).attr("fill","#300000");
					$("."+rO).eq(0).attr("stroke","#300000");
					$("."+rO).eq(1).attr("stroke","#300000");
				}
				
				
				
				
				if($("."+holdingC).attr("fill")!="#c1272d"){
					$("."+holdingC).attr("fill","#e8858c");
					
					if($(this).attr("class")=="regions region-11"){
						if($("#il-in-upper-us").attr("fill")!="#c1272d"){
							$("#il-in-upper-us").attr("fill","#959595");
						}
						$("#il-in-upper-us").attr("stroke","white");
						$("#il-upper-border-us").attr("stroke","none");
					}
					
					/*if($(this).attr("class")=="regions region-7"){
						$("#il-in-upper-us").attr("stroke","white");
						$("#il-upper-border-us").attr("stroke","none");
						if($("#il-in-upper-us").attr("fill")!="#c1272d"){
							$("#il-in-upper-us").attr("fill","#e8858c");
							
						}
						
						
					}*/
					
					if($(this).attr("class")=="regions region-12" || $(this).attr("class")=="regions region-13"){
						$("#tx-northern-us-line").attr("stroke","#fff");
					}
					
					
					if($(this).attr("class")=="regions region-11" || $(this).attr("class")=="regions region-1"){
						$("#pa-western-us").attr("stroke","#fff");
					}
					
				}
	},
	ieOffItRegion:function(ieClasser){
				holdingC=ieClasser;
				holdingC=holdingC.split(" ");
				holdingC=holdingC[1];
				
				rO=holdingC;
				
				rO=rO.split("-");
				rO=rO[1];
				rO="rOffice-"+rO;
				if($("."+rO).eq(0).attr("fill")!="#000000"){
					$("."+rO).eq(0).attr("fill","transparent");
					$("."+rO).eq(0).attr("stroke","transparent");
					$("."+rO).eq(1).attr("stroke","transparent");
				}
				
				if($("."+holdingC).attr("fill")!="#c1272d"){
					$("."+holdingC).attr("fill","#959595");
					
				}
				
				if($("#il-in-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
				}
				
				if($("#in-us").attr("fill")=="#959595" && $("#il-in-upper-us").attr("fill")!="#c1272d"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
				}
				
				if($("#il-in-upper-us").attr("fill")=="#c1272d" && $("#il-in-upper-us").attr("fill")=="#c1272d"){	
					$("#il-upper-border-us").attr("stroke","#959595");
				}
				
				if($("#tx-northern-us").attr("fill")!="#c1272d" && $("#tx-us").attr("fill")!="#c1272d"){
					$("#tx-northern-us-line").attr("stroke","none");
				}
				
				if($("#pa-western-us").attr("fill")!="#c1272d" && $("#pa-us").attr("fill")!="#c1272d"){
					$("#pa-western-us").attr("stroke","none");
				}
	},
	init:function(){
		tech.init();
		highlightRegion('region0');
		$("svg rect").bind("click",function(){contactUsMap.resetit();});
		if(document.all){
			
			
			//$( ".office-dot" ).hover(function(){alert("m00m00")});
			
			
			$( ".office-dot" ).each(function(index, element) {
				$(this).attr("onmouseover","contactUsMap.ieOverItOffices('"+$(this).attr('id')+"')");
			});
			
			$( ".office-dot" ).each(function(index, element) {
				$(this).attr("onmouseout","contactUsMap.ieLeaveItOffices('"+$(this).attr('id')+"')");
			});
			
			$( ".regions" ).each(function(index, element) {
				$(this).attr("onmouseover","contactUsMap.ieOverItRegion('"+$(this).attr('class')+"')");
			});
			
			$( ".regions" ).each(function(index, element) {
				$(this).attr("onmouseout","contactUsMap.ieOffItRegion('"+$(this).attr('class')+"')");
			});
			
		}
		$(".office-dot").click(function(){
			contactUsMap.resetit();
			getOffice="#"+$(this).attr("id")+"-selected";
			$(".office-circle").attr("class","office-circle");
			$(".office-circle").attr("stroke","transparent");
			
			$(getOffice).attr("class","office-circle office-active");
			$(".ncOffices").attr("fill","none");
			$(".ncOffices").attr("stroke","none");
			$("#il-in-upper-us").attr("fill","none");
			$("#il-in-upper-us").attr("stroke","none");
			//$("#region-id").html($(getOffice).attr("id"));
			
			if($(getOffice).attr("id")=="chicago-office-selected"){
				highlightRegion('region13');
			}else if($(getOffice).attr("id")=="houston-office-selected"){
				highlightRegion('region12');
			}else if($(getOffice).attr("id")=="sioux-city-office-selected"){
				highlightRegion('region16');
			}else if($(getOffice).attr("id")=="sarnia-on-ca-office-selected"){
				highlightRegion('region1');
			}
			
			$(getOffice).attr("stroke","#000000");
		}).mouseenter(function(){
			$(".regions").each(function(index, element) {
				if($(this).attr("fill")!="#c1272d"){
					$(this).attr("fill","#959595");
				}
			});
			
			$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			if($("#il-in-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					}/**/
			
			/*if($("#il-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-upper-us").attr("stroke","none");
					}*/

			
			getOffice="#"+$(this).attr("id")+"-selected";
			$(getOffice).attr("stroke","#000000");
		}
		
		).mouseleave(function(){
			$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			if($("#il-in-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					}
					
			/*if($("#il-upper-us").attr("fill")!="#c1272d" && $("#il-upper-us").attr("fill")!="#959595"){
						$("#il-upper-us").attr("stroke","none");
					}*/
			
		});
		
		$(".regions").click(function(){
			
			$(".regions").attr("fill","#959595");
			$(".ncOffices").attr("stroke","transparent");
			$(".ncOffices").each(function(index, element) {
				if($(this).attr("fill")!="none"){
					$(this).attr("fill","transparent");
				}
			});
			//$(this).attr("fill","#c1272d");
			holdingC=$("#"+$(this).attr("id")).attr("class");
			
			
			holdingC=holdingC.split(" ");
			holdingC=holdingC[1];
			
			$("."+holdingC).attr("fill","#c1272d");
			
			if($(this).attr("class")!="regions region-19"){
				$("#il-in-upper-us").attr("fill","none");
				$("#il-in-upper-us").attr("stroke","none");
				/*$("#il-upper-us").attr("stroke","none");*/
			}
			if($(this).attr("class")=="regions region-19"){
				$("#il-in-upper-us").attr("fill","#c1272d");
				$("#il-in-upper-us").attr("stroke","white");
				/*$("#il-upper-border-us").attr("stroke","none");*/
			}
			
			if($(this).attr("class")=="regions region-11"){
				$("#il-in-upper-us").attr("fill","#959595");
				$("#il-in-upper-us").attr("stroke","white");
				/*$("#il-upper-border-us").attr("stroke","none");*/
			}
			
			/*if($(this).attr("class")=="regions region-7"){
				$("#il-in-upper-us").attr("stroke","white");
				$("#il-in-upper-us").attr("fill","#c1272d");
				$("#il-upper-border-us").attr("stroke","#959595");
			}
			
			if($(this).attr("class")=="regions region-8"){
				$("#il-upper-us").attr("stroke","white");
				$("#il-upper-border-us").attr("stroke","none");
			}*/
			
			if($(this).attr("class")=="regions region-12" || $(this).attr("class")=="regions region-13"){
						$("#tx-northern-us-line").attr("stroke","#fff");
			}else{
				$("#tx-northern-us-line").attr("stroke","none");
			}
			
			if($(this).attr("class")=="regions region-11" || $(this).attr("class")=="regions region-1"){
						$("#pa-western-us").attr("stroke","#fff");
			}else{
				$("#pa-western-us").attr("stroke","none");
			}
			
			
			//$("#region-id").html(holdingC);
			
			switch(holdingC){
				case "region-1":
				highlightRegion('region4')
				tech.sale('region18');
				break;
				case "region-2":
				highlightRegion('region8')
				tech.sale('region18');
				break;
				case "region-3":
				highlightRegion('region2')
				tech.sale('region18');
				break;
				case "region-4":
				highlightRegion('region3')
				tech.sale('region18');
				break;
				case "region-5":
				highlightRegion('region10')
				tech.sale('region18');
				break;
				case "region-6":
				highlightRegion('region16')
				tech.sale('region18');
				break;
				case "region-7":
				highlightRegion('region6')
				break;
				case "region-8":
				highlightRegion('region15')
				tech.sale('region18');
				break;
				case "region-9":
				highlightRegion('region1')
				break;
				case "region-11":
				highlightRegion('region9')
				tech.sale('region18');
				break;
				case "region-12":
				highlightRegion('region5')
				tech.sale('region18');
				break;
				case "region-13":
				highlightRegion('region11')
				tech.sale('region18');
				break;
				case "region-14":
				highlightRegion('region17')
				break;
				case "region-19":
				highlightRegion('region19')
				tech.sale('region18');
				break;
				
			}
			
			$(".office-circle").attr("stroke","transparent");
			$(".office-circle").attr("class","office-circle");
			rO=holdingC;
			rO=rO.split("-");
				rO=rO[1];
				rO="rOffice-"+rO;
				
					$("."+rO).eq(0).attr("fill","#000000");
					$("."+rO).eq(0).attr("stroke","#000000");
					$("."+rO).eq(1).attr("stroke","#000000");
				
			
		}).mouseenter(function(){
				
				holdingC=$(this).attr("class");
				holdingC=holdingC.split(" ");
				holdingC=holdingC[1];
				rO=holdingC;
				
				rO=rO.split("-");
				rO=rO[1];
				rO="rOffice-"+rO;
				if($("."+rO).eq(0).attr("fill")!="#000000"){
					$("."+rO).eq(0).attr("fill","#300000");
					$("."+rO).eq(0).attr("stroke","#300000");
					$("."+rO).eq(1).attr("stroke","#300000");
				}
				
				
				
				
				if($("."+holdingC).attr("fill")!="#c1272d"){
					$("."+holdingC).attr("fill","#e8858c");
					
					if($(this).attr("class")=="regions region-11"){
						if($("#il-in-upper-us").attr("fill")!="#c1272d"){
							$("#il-in-upper-us").attr("fill","#959595");
						}
						$("#il-in-upper-us").attr("stroke","white");
						$("#il-upper-border-us").attr("stroke","none");
					}
					
					/*if($(this).attr("class")=="regions region-7"){
						$("#il-in-upper-us").attr("stroke","white");
						$("#il-upper-border-us").attr("stroke","#959595");
						if($("#il-in-upper-us").attr("fill")!="#c1272d"){
							$("#il-in-upper-us").attr("fill","#e8858c");
							
						}
						
						
					}*/
					
					if($(this).attr("class")=="regions region-12" || $(this).attr("class")=="regions region-13"){
						$("#tx-northern-us-line").attr("stroke","#fff");
					}
					
					
					if($(this).attr("class")=="regions region-11" || $(this).attr("class")=="regions region-1"){
						$("#pa-western-us").attr("stroke","#fff");
					}
					
				}
			}).mouseleave(function(){
				holdingC=$(this).attr("class");
				holdingC=holdingC.split(" ");
				holdingC=holdingC[1];
				
				rO=holdingC;
				
				rO=rO.split("-");
				rO=rO[1];
				rO="rOffice-"+rO;
				if($("."+rO).eq(0).attr("fill")!="#000000"){
					$("."+rO).eq(0).attr("fill","transparent");
					$("."+rO).eq(0).attr("stroke","transparent");
					$("."+rO).eq(1).attr("stroke","transparent");
				}
				
				if($("."+holdingC).attr("fill")!="#c1272d"){
					$("."+holdingC).attr("fill","#959595");
					
				}
				
				if($("#il-in-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						/*$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");*/
						
						
				}
				
				
				if($("#il-in-upper-us").attr("fill")=="#c1272d" && $("#il-in-upper-us").attr("fill")=="#c1272d"){	
					$("#il-upper-border-us").attr("stroke","#959595");
				}
				
				if($("#in-us").attr("fill")=="#959595" && $("#il-in-upper-us").attr("fill")!="#c1272d"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
				}
				
				
				if($("#tx-northern-us").attr("fill")!="#c1272d" && $("#tx-us").attr("fill")!="#c1272d"){
					$("#tx-northern-us-line").attr("stroke","none");
				}
				
				if($("#pa-western-us").attr("fill")!="#c1272d" && $("#pa-us").attr("fill")!="#c1272d"){
					$("#pa-western-us").attr("stroke","none");
				}
				
			});
			
			
			
			
			
			$("polygon:not(.regions)").bind("click", function(){
				contactUsMap.resetit();
			});
			
			
			
	},
	
	initIE:function(){
		//future
		
	},
	
	resetit:function(){
		highlightRegion('region0');
		$(".regions").attr("fill","#959595");
		$("#il-upper-border-us").attr("stroke","none");
		$("#il-upper-us").attr("stroke","none");
		$(".ncOffices").attr("fill","none");
		$(".ncOffices").attr("stroke","none");
		$("#il-in-upper-us").attr("fill","none");
		$("#il-in-upper-us").attr("stroke","none");
		$(".office-circle").attr("stroke","transparent");

		$("#pa-western-us").attr("stroke","none");
		$("#tx-northern-us-line").attr("stroke","none");
	},
	
	resetit2:function(){
		$(".regions").attr("fill","#959595");
		$("#il-upper-border-us").attr("stroke","none");
		$("#il-upper-us").attr("stroke","none");
		$(".ncOffices").attr("fill","none");
		$(".ncOffices").attr("stroke","none");
		$("#il-in-upper-us").attr("fill","none");
		$("#il-in-upper-us").attr("stroke","none");
		$(".office-circle").attr("stroke","transparent");

		$("#pa-western-us").attr("stroke","none");
		$("#tx-northern-us-line").attr("stroke","none");
	}, 
	ieOverItOffices:function(ieOO){
		
		$(".regions").each(function(index, element) {
				if($(this).attr("fill")!="#c1272d"){
					$(this).attr("fill","#959595");
				}
			});
			
			$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			if($("#il-in-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					}
			
			if($("#il-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-upper-us").attr("stroke","none");
					}

			
			getOffice="#"+ieOO+"-selected";
			$(getOffice).attr("stroke","#000000");/* */
	},
	
	ieLeaveItOffices:function(ieLO){
		$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			if($("#il-in-upper-us").attr("fill")!="#c1272d" && $("#il-in-upper-us").attr("fill")!="#959595"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					}
					
			if($("#il-upper-us").attr("fill")!="#c1272d" && $("#il-upper-us").attr("fill")!="#959595"){
						$("#il-upper-us").attr("stroke","none");
					}
	}
	
}

var allContacts={
	init:function(){
		$( "#contAlpha .alphaemail" ).mouseover(function() {
  			//console.log("in "+$(this).html());
			allContacts.rollover($(this).html());
			
		}).mouseout(function() {
		  	//console.log("out "+$(this).html());
			allContacts.clearit();
		});
	},
	rollover:function(nn){
		
		switch(nn){
			case "Randy Bowman":
				//alert("hi Randy");
				regionSet="region-11";
			break;
			case "Todd Waggoner":
				regionSet="region-6";
			break;
			case "Joshua Chesser":
				regionSet="region-7";
			break;
			case "Al Isenegger":
				regionSet="region-9";
			break;
			case "Jim McLaughlin":
				regionSet="region-8";
			break;
			case "Pete Petersen":
				regionSet="region-1";
			break;
			case "Scottie Primeaux":
				regionSet="region-3";
			break;
			case "Dennis Rivardo":
				regionSet="region-4";
			break;
			case "Tony Segovia":
				regionSet="region-13";
			break;
			case "Scott Swanson":
				regionSet="region-5";
			break;
			case "Stoy Taylor":
				regionSet="region-2";
			break;
			case "Edwin Luper":
				regionSet="region-12";
			break;
			case "Jan Marino":
				regionSet="region-19";
			break;
			case "Steve Van Nocken":
				regionSet="region-14";
			break;
			case "Tyler Jepsen":
				regionSet="region-9";/* none */
			break;
		}
		
		
		
		$(".regions").each(function(index, element) {
				if($(this).attr("fill")!="#c1272d"){
					$(this).attr("fill","#959595");
				}
			});
			
			$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			if($("#il-in-upper-us").attr("fill")!="#c1272d" && regionSet!="region-11"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					}
			if(regionSet!="none"){
				$("."+regionSet).attr("fill","#e8858c");
			}
	},
	clearit:function(){
		$(".regions").each(function(index, element) {
				if($(this).attr("fill")!="#c1272d"){
					$(this).attr("fill","#959595");
				}
			});
			
			$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					
	},
	alphaListUpdate:function(nn){
		
		switch(nn){
			case "Randy Bowman":
				//alert("hi Randy");
				regionSet="region-11";
				
			break;
			case "Todd Waggoner":
				regionSet="region-6";
			break;
			case "Joshua Chesser":
				regionSet="region-7";
			break;
			case "Al Isenegger":
				regionSet="region-9";
			break;
			case "Jim McLaughlin":
				regionSet="region-8";
			break;
			case "Pete Petersen":
				regionSet="region-1";
			break;
			case "Scottie Primeaux":
				regionSet="region-3";
			break;
			case "Dennis Rivardo":
				regionSet="region-4";
			break;
			case "Tony Segovia":
				regionSet="region-13";
			break;
			case "Scott Swanson":
				regionSet="region-5";
			break;
			case "Stoy Taylor":
				regionSet="region-2";
			break;
			case "Edwin Luper":
				regionSet="region-12";
			break;
			case "Jan Marino":
				regionSet="region-19";
				$("#il-in-upper-us").attr("fill","#c1272d");
			break;
			case "Steve Van Nocken":
				regionSet="region-14";
			break;
			case "Tyler Jepsen":
				regionSet="region-9";/* none */
			break;
		}
		
		//$("."+regionSet).click();
		
		$(".regions").each(function(index, element) {
				if($(this).attr("fill")!="#c1272d"){
					$(this).attr("fill","#959595");
				}
			});
			
			$(".office-circle").each(function(index, element) {
				if($(this).attr("class")=="office-circle"){
					$(this).attr("stroke","transparent");
				}
			});
			
			if($("#il-in-upper-us").attr("fill")!="#c1272d" && regionSet!="region-11"){
						$("#il-in-upper-us").attr("fill","none");
						$("#il-in-upper-us").attr("stroke","none");
						$("#il-upper-border-us").attr("stroke","none");
					}
					
			
			if(regionSet!="none"){//alert(regionSet);
				$("."+regionSet).attr("fill","#c1272d");
				setTimeout(function(){
					$("."+regionSet).attr("fill","#c1272d");
					
					
					if(regionSet=="region-11"){
						$("#il-in-upper-us").attr("fill","#959595");
						$("#il-in-upper-us").attr("stroke","#fff");
						$("#il-upper-border-us").attr("stroke","none");
					}
					
					},100);
					
				
			}
			
			
		
		/* if(regionSet!="region-9"){
			$("."+regionSet).attr("fill","#c1272d");
		}*/
		
		switch(regionSet){
				case "region-1":
				highlightRegion('region4')
				//tech.sale('region18');
				break;
				case "region-2":
				highlightRegion('region8')
				//tech.sale('region18');
				break;
				case "region-3":
				highlightRegion('region2')
				//tech.sale('region18');
				break;
				case "region-4":
				highlightRegion('region3')
				//tech.sale('region18');
				break;
				case "region-5":
				highlightRegion('region10')
				//tech.sale('region18');
				break;
				case "region-6":
				highlightRegion('region16')
				//tech.sale('region18');
				break;
				case "region-7":
				highlightRegion('region6')
				break;
				case "region-8":
				highlightRegion('region15')
				//tech.sale('region18');
				break;
				case "region-9":
				highlightRegion('region1')
				break;
				case "region-11":
				highlightRegion('region9')
				//tech.sale('region18');
				break;
				case "region-12":
				highlightRegion('region5')
				//tech.sale('region18');
				break;
				case "region-13":
				highlightRegion('region11')
				//tech.sale('region18');
				break;
				case "region-14":
				highlightRegion('region17')
				break;
				case "region-19":
				highlightRegion('region19')
				//tech.sale('region18');
				break;
		}
		//highlightRegion(regionSet);
		
	}
}

tech={
	init:function(){
		if($("body").attr("id")=="contact-us"){
			tempHoldTS=$("#region18").html();
			//$("#contact-us-aside .inner-content").append('<div id="region-1ts" class="hidden">'+tempHoldTS+'</div>');
			$("#region1").html(tempHoldTS);
			$("#region1 .regionTitle").html("Contact");
			allContacts.init();
			//console.log($("#right-aside .sideBarContent ").html())
			setTimeout(function(){
				
				$("#contact-us-aside a.email").bind("click",function(e){e.preventDefault(); 
		
		getNameinfo=$(this).attr("data-name");
		//getNameinfo=getNameinfo.split(" ");
		document.location="/page/contact-us-form?contact="+getNameinfo;//[1]+"_"+getNameinfo[2];
																		   
	});
				
				},500);
		}
	},
	sale:function(r){
		$("#"+r).removeClass("hidden");
	}
}

if(navigator.userAgent.indexOf("WebKit")==-1){
			jQuery(function ($) {
				$(".product-family #center-content > h1").attr("data-pattern","/common/images/template-updated/gradient-text.png");
				$(".product-family #center-content > h1").patternizer();
				
				$(".product-landing h1").patternizer();
				
				
				$(".product #center-content > h3").attr("data-pattern","/common/images/template-updated/gradient-text.png");
				$(".product #center-content > h3").patternizer();
				
				
			});
		}
		
// function for ajax nav
function initNav(){
	
		for(i=0;i<$("#productNav ul li").length;i++){
			if($("#productNav ul li").eq(i).attr("class") != "mm"){
				hodCat=$("#productNav ul li").eq(i).children().attr("data-CategoryID");
				hasChildren=$("#productNav ul li").eq(i).children().attr("data-haschildren");
				if(hasChildren=="true"){
					createA=document.createElement("a");
					$(createA).attr("href",hodCat);
					$(createA).attr("class","expander expandable");
					$(createA).attr("id","linkEx"+hodCat);
					$(createA).html("&nbsp;");
					
					createDiv=document.createElement("div");
					$(createDiv).attr("id","expander"+hodCat);
					$(createDiv).attr("class","empty");
					
					tempHolds=$("#productNav ul li").eq(i).html();
					
					$("#productNav ul li").eq(i).html("<div class='keepingitReal'>"+tempHolds+"</div>");
					$("#productNav ul li").eq(i).children().prepend(createA);
					$("#productNav ul li").eq(i).append(createDiv);
					$("#productNav ul li").eq(i).attr("class","mm");
					
				}
				
				if(hasChildren=="false"){
					createA2=document.createElement("span");
					$(createA2).attr("class","expander-span");
					$(createA2).html("&nbsp;&nbsp;");
					tempHolds=$("#productNav ul li").eq(i).html();
					$("#productNav ul li").eq(i).html("<div class='keepingitReal'>"+tempHolds+"</div>");
					$("#productNav ul li").eq(i).children().prepend(createA2);
				}
			}
		}
		$(".expander").bind("click",function(e){
			e.preventDefault(); 
			getNavItems($(this).attr("href"),$(this).next().attr("data-categorythreadlist"));
			$(this).addClass("expanded");
			$(this).blur();
		});
		
		
	}
	
var doublejep=false;

function getNavItems(nn,dc){
	/*if(document.all && $.browser.version == "7.0" || $.browser.version == "8.0"){
			nn=nn.toString();
			nn=nn.split("/");
			nn=nn[nn.length-1];
			
		}*/
	if(doublejep==true){
		
		}
	if(doublejep==false){
		$("#expander"+nn).addClass("navLoading");
		$("#expander"+nn).removeClass("empty");
		pathtomenu="/common/modules/display/Navigation/dsp_NavProductHelper.cfm?CategoryThreadList="+dc+"&CategoryID="
		$("#expander"+nn).load(pathtomenu+nn+" ul", function(){initNav(); rebinder(nn);
			ajuH=$("#acc3").height()+120;
			if(ajuH>=$("#center-content").height()){
				
				$("#center-content").animate({height:ajuH+"px"})
			}
		});
	}
}

var stopAt="";
var startAt=0;
function getNavItemsAuto(nnn,dc){
		pathtomenu="/common/modules/display/Navigation/dsp_NavProductHelper.cfm?CategoryThreadList="+dc+"&CategoryID="
		nnn=nnn.toString();
		nnnf=nnn.split(",");
		stopAt=nnnf.length;
		$("#expander"+nnnf[startAt]).addClass("navLoading");
		$("#expander"+nnnf[startAt]).removeClass("empty");
		/* $("#linkEx"+nnnf[startAt]).html("- "); */
		$("#linkEx"+nnnf[startAt]).addClass("expanded");
		
		$("#expander"+nnnf[startAt]).load(pathtomenu+nnnf[startAt]+" ul", function(){initNav(); rebinder(nnnf[startAt]); startAt++; if(startAt<stopAt){getNavItemsAuto(nnnf,dc);}
		ajuH=$("#acc3").height()+120;
		if(ajuH>=$("#center-content").height()){
				
				$("#center-content").animate({height:ajuH+"px"})
			}
		
		});
	
}


function closeNavItems(nn){
	doublejep=true;
	testing="a[href='"+nn+"']"
	
	
	$("#expander"+nn+" a").children().children().unbind();
	
	//$(testing).html("+ ");
	if(document.all && $.browser.version == "7.0" && nn.indexOf("/")>-1){
		nn=nn.split("/");
		nnL=nn.length-1;
		nn=nn[nnL]
	}

	
	$("#expander"+nn).empty();
	
	setTimeout(function(){ reapplieit(testing,nn)},100);
	
	
}

function reapplieit(nn,iefix){
	$(nn).unbind().bind("click",function(e){
																			   e.preventDefault(); 
																			   getNavItems($(this).attr("href"),$(this).next().attr("data-CategoryThreadList"));
																			   /*$(this).html("- ");*/
																			   $(this).addClass("expanded");
																			   $(this).blur(); 														   
																			   });
	/* $(nn).html("+ "); */
	
	$(nn).removeClass("expanded");
	
	$("#expander"+iefix).addClass("empty");
	
	doublejep=false;
}

function rebinder(nn){
	if(doublejep==false){
		$("#expander"+nn).removeClass("navLoading");
		$("#expander"+nn).parent().children().eq(0).children().eq(0).unbind().bind("click",function(e){e.preventDefault(); closeNavItems($(this).attr("href"));$(this).blur();});
	}
	}
	
	
function getPage(pagetoget,pid){setit=" #"+pid+" div"; 
			/*$("#"+pid).load(pagetoget+" "+setit, function(response, status, xhr){addAj(pid);alert(response)
																																								   			});*/
			//alert(pid)
			$.get(pagetoget, function(data) {  displayPContent(pid,data); paginationStyles.init();
				if($("body").hasClass("product")==false){
				 
				 if($("body").hasClass("product-family")==true){
					$(" #"+pid).parent().parent().css({height:($(" #"+pid).parent().height()+20)+"px"});  
				 }else{
					$(" #"+pid).parent().parent().css({height:($(" #"+pid).height()+60)+"px"}); }
				 
				 $(" #"+pid).parent().parent().addClass("open"); 
				 $(" #"+pid).parent().parent().prev ().addClass("open");
				}
				
				
				if($("#center-content").attr("style")!=""){
					heightCH=$("#center-content h1").height()+$("#center-content .text").height();
					if($("#center-content").height()<heightCH){
							$("#center-content").attr("style","");
					}
					
				}
				
			});
		}
		
	function  displayPContent(pid,content){
			$("#"+pid).replaceWith(content);
			addAj(pid);
		}
		
	
	function addAj(pid){
		$(".pagList .pagination p a").bind("click", function(event){
		event.preventDefault(); getPage($(this).attr("href"), $(this).parent().parent().parent().attr("id")); location.hash="#"+$(this).attr("href")+"^"+$(this).parent().parent().parent().attr("id");
	});
		
		$("#"+pid+" .pagination .pagination a").bind("click",function(event) {event.preventDefault(); getPage($(this).attr("href"), $(this).parent().parent().parent().parent().attr("id")); location.hash="#"+$(this).attr("href")+"^"+$(this).parent().parent().parent().parent().attr("id"); });
		}
		
$(function(){

		  // Bind the event.
		  $(window).hashchange( function(){
		    // Alerts every time the hash changes!
		    if(location.hash.indexOf("^")>-1){
				tweakhash=location.hash;
				tweakhash=tweakhash.split("#");
				tweakhash=tweakhash[1].split("^");
				getPage(tweakhash[0],tweakhash[1]);
				
				
				if($("#"+tweakhash[1]).parent().parent().parent().attr("style")!="display: block;"){
					$(".outer").css({display:"none"});
					
					
					$("#"+tweakhash[1]).parent().parent().parent().attr("style","display: block;");
					}
					
					
					
		    }
		  })
		
		  // Trigger the event (useful on page load).
		  $(window).hashchange();
		  paginationStyles.init();
		
	});
	
	paginationStyles={
		init:function(){
			$(".pagination li").removeClass("none-link");
			$(".pagination li").each(function(index, element) {
				if($(this).children().length==0 && $(this).html()!="..."){
					$(this).addClass("none-link");
				}else if($(this).html()=="..."){
					$(this).addClass("elipses-nav");
				}
				//alert($(this).html())
				if($(this).html()=="| &lt;" || $(this).html()=="&lt;" || $(this).html()=="&gt;"){
					$(this).addClass("elipses-nav");
					$(this).removeClass("none-link");
				}
			});
		}
	}
	
	$(document).ready(function(e) {
		if($("#center-content .subordion").length>0){
			setTimeout("productSubAccordian.init()",100);
		}
		
		if($(".product-nav ul li").length>=4){
			$(".product-nav").addClass("lotsofproducts");
		}
	});
	
	productSubAccordian={
		init:function(){
			tmp="";
			
			$(".product-landing script").remove();
			
			$(".subordion h4.subAcHd").each(function(index, element) {
				if($(this).find("a").length==0){
					$(this).removeClass("subAcHd");
					$(this).addClass("subAccAcc");
				}
			});
			
			$(".subordion h4").not(".subAcHd").bind("click",function(){
				//alert($(this).next().hasClass("open"))
				if($(this).next().hasClass("open")==false){
					$(this).addClass("open");
					$(this).next().addClass("open");
					howdy=$(this);
					
					
					
					if($(howdy).hasClass("subAccAcc")==true){
						setTimeout(function(){
							//alert($(howdy).parent().parent().height()+" "+$(howdy).parent().height());
							
							$(howdy).parent().parent().css({height:$(howdy).parent().height()+"px"});
							
							
							
						},510);
					}
					
					setTimeout(function(){
						//alert($(howdy).next().height()+" "+$(howdy).next().children().height())
						if($(howdy).next().height() < $(howdy).next().children().height() && $("body").hasClass("product")==false){
							$(howdy).next().css({height:($(howdy).next().children().height()+30)+"px"});
							}
						},500);
				}else{
					$(this).removeClass("open");
					$(this).next().removeClass("open");
					$(this).next().attr("style","");
					howdy=$(this);
					if($(howdy).hasClass("subAccAcc")==true){
						setTimeout(function(){
							$(howdy).parent().parent().css({height:$(howdy).parent().height()+"px"});
							
						},510);
					}
					
					
				}
			setTimeout(function(){	
			if($("#center-content").attr("style")!=""){
					heightCH=$("#center-content h1").height()+$("#center-content .text").height();
					if($("#center-content").height()<heightCH){
							$("#center-content").attr("style","");
					}
					
				}},520);
				
			});
			
			$(".subordion h4.subAcHd").bind("click",function(){
				window.location=$(this).find("a").attr("href");
			});
			
			
			
			$(".subordion .inner").each(function(index, element) {
				$(this).attr("id", "pID-"+index);
				//alert($(this).children().height());
				tmp+="#pID-"+index+".open{height:"+($(this).children().height()+30)+"px;} "
			});
			
			$(".subordion").prepend('<style>'+tmp+'</style>')
			
			
		}
		
		
	}
	
	$(document).ready(function(e) {
		
		if($("body").hasClass("news")==true){
			$( '<h2 class="news-title" data-pattern="/common/images/template-updated/gradient-text.png">NEWS</h2>' ).insertAfter( "#newsStoryNav" );
			$(".news-title").patternizer();
		}
		
		if($(".building-blocks").length>0){
			news.init();
			
			if(navigator.userAgent.indexOf("WebKit")==-1){
			jQuery(function ($) {
				$(".news-listing #center-content > h1").attr("data-pattern","/common/images/template-updated/gradient-text.png");
				$(".news-listing #center-content > h1").patternizer();
				
				
			});
		}
			
		}
		
		
	if($("html").hasClass("ie8")==true){
		$(".product-nav ul li:last-child").addClass("ie8-last-prod-nav")
	}
	});
	
	news={
		init:function(){
			if($("html").hasClass("ie8")==true){
				$(".building-blocks:nth-child(2n+2)").addClass("ie8BuildingBlox2");
			}	
			
			$(".building-blocks").bind("click", function(){
				window.location=$(this).find("a").attr("href");
			});
		}	
	}
	

/* json search returning */

$(document).ready(function(e) {
	
	searchJ.init();
	
});
var elementStart=0;
var arrDir="";
var highli=false;
searchJ={
	init:function(){
		$(".backSearch").bind("keyup",function(e){
			
				
				if (e.keyCode == 40 || e.keyCode == 38) { 
					e.preventDefault();
					searchJ.gotoElement(e.keyCode);
					highli=true;
					return false;
				}else if(e.keyCode==13){
					e.preventDefault();
					searchJ.gotoPage();
					return false;
				} else if (e.keyCode != 40 || e.keyCode != 38) {
					searchJ.getReturns();
				}
				
				
				
				}).bind("blur",function(){
					setTimeout(function(){$("#json-return").html("")},1500);/**/
				});
			
		},
		gotoElement:function(kc){
			$("#json-return a").parent().removeClass("selected");
				linkLength=$("#json-return a").length-1;
				if(kc==40){
				if(arrDir=="up"){
					if(elementStart<linkLength){
						
					elementStart=elementStart+2;
						
					}
				else {
					elementStart=0;
				}
				
			}
				arrDir="down";
		$("#json-return a").eq(elementStart).parent().addClass("selected");
		if(elementStart<linkLength){
			elementStart++;
			}
		else {
			elementStart=0;
		}		
	}
		
	if(kc==38){
		if(arrDir=="down"){
				if(elementStart>0){
					elementStart=elementStart-2;
				}
				else {
					elementStart=linkLength;
				}
			
		}
		arrDir="up";
		if(elementStart<0){
			elementStart=linkLength;
		}
		$("#json-return a").eq(elementStart).parent().addClass("selected");
		if(elementStart>0){
			elementStart--
		}
		else {
			elementStart=linkLength;
		}
	}			
		},
		
	getReturns:function(){
		
		if($(".backSearch").val().length>0){
					$.getJSON( "/common/modules/search/searchSuggest.cfm?st="+$("#search-type").val()+"&s="+$(".backSearch").val(), function( data ) {
					  var items = [];
					  $.each( data, function( key, val ) {
						if(key==0){
							setClassname="";//"class='selected'";
						}else{
							setClassname="";
						}
					    items.push( "<li id='num" + key + "' "+setClassname+"><a href='"+val.Value+"'>" + val.Name + "</a></li>" );
					  });
			 
					$("#json-return").html("");
				 
					  $( "<ul/>", {
					    "class": "product-returns",
					    html: items.join( "" )
					  }).appendTo("#json-return");
					});
				}else if ($(".backSearch").val().length==0){
					$("#json-return").html("");
				}
	},
	gotoPage:function(){
		if($("#json-return li.selected a").length>0){
			window.location=$("#json-return li.selected a").attr("href");
		}
	}
	
}
