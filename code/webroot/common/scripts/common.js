var browserWars=$.client.browser;

$(document).ready(function() {

	browserWars=browserWars.toLowerCase();			   	   
	$(".pagList .pagination .pagination a").bind("click",function(event) {event.preventDefault(); getPage($(this).attr("href"), $(this).parent().parent().parent().parent().attr("id"));});
	$("body").addClass(browserWars);

	initNav();	
	getHash=location.hash;

	if(getHash.length>0){
		splithash=getHash.split("#")
		$("#linkEx"+splithash[1]).click();
	}
	$(".sideBarContent a.email").bind("click",function(e){e.preventDefault(); 
		
		getNameinfo=$(this).text();
		getNameinfo=getNameinfo.split(" ");
		document.location="/page/contact-us-form?contact="+getNameinfo[1]+"_"+getNameinfo[2];
																		   
	});
	
	$(".sideBarContent a.alphaemail").bind("click",function(e){e.preventDefault(); 
		
		getNameinfo=$(this).text();
		getNameinfo=getNameinfo.split(" ");
		document.location="/page/contact-us-form?contact="+getNameinfo[0]+"_"+getNameinfo[1];
																		   
	});
	
	$("input#searchProd").bind("focus", function(e) {e.preventDefault(); 
		if(this.value == "Product Search..." || this.value == "Product Search...") {
			this.value = "";
		}
	});
	
	$("input#searchProd").bind("blur", function(e) {e.preventDefault(); 
		if(this.value == "") {
			this.value = "Product Search...";
		}
	});
	
	
	if(document.all && $.browser.version == "6.0"){
			
		$("body").addClass("ie6");
	}
	
	if(document.all && $.browser.version == "7.0"){
		//
		runIECorrections();
		$("body").addClass("ie7");
	}
	
	if(document.all && $.browser.version == "8.0"){
		//
		$("body").addClass("ie8");
	}
	
	if(document.all && $.browser.version == "9.0"){
		
		$("body").addClass("ie9");
	}
	
	if(browserWars=="explorer" && $.browser.version == "6.0"){
		bchk=false;
		}else{
			bchk=true;
		}
	
	
		/**/
			
			if($(".holderGallery").length==1 && bchk==false){
				
				
				for(i=0;i<$(".holderGallery a").length;i++){
								tempFile=$(".holderGallery a").eq(i).attr("href");
								tempDescription=$(".holderGallery a").eq(i).attr("title");
								tempName=$(".holderGallery a").eq(i).attr("rel");
								
								$(".holderGallery a").eq(i).attr("href","javascript:openIE6Modal('"+tempFile+"','"+tempDescription+"','"+tempName+"')");
							}
				
			}
	if($(".holderGallery").length==1 && bchk==true){
			$(function() {
				$('.holderGallery a').lightBox();
				}); 
			}
	
 	});
						   
	function runIECorrections(){
		
			if($("body").attr("class")=="product-family explorer" || $("body").attr("class")=="product explorer"){
				getNav=$("#productNav").html();
				$("#productNav").remove();
				createLI=document.createElement("li");
				$(createLI).attr("id","productNav");
				$(createLI).html(getNav);
				$("#acc3").append(createLI);
				$(".expander").bind("click",function(e){e.preventDefault(); getNavItems($(this).attr("href"));$(this).html("- ");$(this).blur();
																																			  });
				$("body").addClass("ie7");
			}
		}
	
	
	function getPage(pagetoget,pid){setit=" #"+pid+" div"; 
			/*$("#"+pid).load(pagetoget+" "+setit, function(response, status, xhr){addAj(pid);alert(response)
																																								   			});*/
			//alert(pid)
			$.get(pagetoget, function(data) {  displayPContent(pid,data);  });
		}
		
	function  displayPContent(pid,content){
			$("#"+pid).replaceWith(content);
			addAj(pid);
		}
		
	
	function addAj(pid){
		$("#"+pid+" .pagination .pagination a").bind("click",function(event) {event.preventDefault(); getPage($(this).attr("href"), $(this).parent().parent().parent().parent().attr("id"))});
		}


$(document).ready(function() {
	$("#main").accordion({
	  obj: "div", 
	  wrapper: "div", 
	  el: ".h", 
	  head: "h4", 
	  next: "div", /*
	  initShow : "div.outer:first",*/
	  event : "click",
	  collapsible : true
	});

	//Default Action
	$(".downloadContent").hide(); //Hide all content
	$(".downloadContent:first").show(); //Show first tab content
	
	//On Click Event
	$("ul#tabsDownloads li a").click(function() {
		$("ul#tabsDownloads li a").removeClass("tabActive"); //Remove any "active" class
		$(this).addClass("tabActive"); //Add "active" class to selected tab
		$(".downloadContent").hide(); //Hide all tab content
		var activeTab = $(this).attr("href"); //Find the rel attribute value to identify the active tab + content
		$(activeTab).show(); //Fade in the active content
		return false;
	});

	projekktor('#salcoPlayer', {
		playerFlashMP4: '/common/flash/jarisplayer.swf'
	});
	
	if(!document.all){
	adjVideoTitles()/**/}else{setTimeout("adjVideoTitles()",1500)}
});

$("html").addClass("js");

try{

$.fn.accordion.defaults.container = false; }
catch(e){
	//stiffle
	}
$(function() {
		   if(!$("body").hasClass("product-family") || !$("body").hasClass("product")){
	$("#acc3").accordion({initShow : "#current"});
	$("html").removeClass("js");
		   }
});

//to adjust video titles lengths
function adjVideoTitles(){
	numberofVideos=$(".holderCenter .vidTable td").length;
	
	
	for(i=0;i<numberofVideos;i++){
		
		if($(".holderCenter .vidTable td").eq(i).children().children().html() !=null){
		tempL=$(".holderCenter .vidTable td").eq(i).children().children().html().length;
		
			tempTitle=$(".holderCenter .vidTable td").eq(i).children().children().html().toString();
			
			if(tempL>55){
				$(".holderCenter .vidTable td").eq(i).children().children().attr("title", tempTitle);
				if(document.all){
					tempTitle=tempTitle.replace(/&nbsp;/,' ')
					
					}
				try{	
				$(".holderCenter .vidTable td").eq(i).children().children().html(tempTitle.slice(0,54)+"  &#8230;");
				}
				catch(e){
					//fails on ie for what seems to be unrelated reason
					//alert(e.message)
					//stiffling error messages for that reason.
					}
				tempTitle="test";
			}
		}
	}
	
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
					$(createA).attr("class","expander");
					$(createA).attr("id","linkEx"+hodCat);
					$(createA).html("+ ");
					
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
		$(".expander").bind("click",function(e){e.preventDefault(); getNavItems($(this).attr("href"));$(this).html("- ");$(this).blur();});
		
		
	}
	
var doublejep=false;

function getNavItems(nn){
	if(document.all && $.browser.version == "7.0" || $.browser.version == "8.0"){
			nn=nn.toString();
			nn=nn.split("/");
			nn=nn[nn.length-1];
			
		}
	if(doublejep==true){
		
		}
	if(doublejep==false){
		$("#expander"+nn).addClass("navLoading");
		$("#expander"+nn).removeClass("empty");
		pathtomenu="/common/modules/display/Navigation/dsp_NavProductHelper.cfm?CategoryID="
		$("#expander"+nn).load(pathtomenu+nn+" ul", function(){initNav(); rebinder(nn);});
	}
}

var stopAt="";
var startAt=0;
function getNavItemsAuto(nnn){
		pathtomenu="/common/modules/display/Navigation/dsp_NavProductHelper.cfm?CategoryID="
		nnn=nnn.toString();
		nnnf=nnn.split(",");
		stopAt=nnnf.length;
		$("#expander"+nnnf[startAt]).addClass("navLoading");
		$("#expander"+nnnf[startAt]).removeClass("empty");
		$("#linkEx"+nnnf[startAt]).html("- ");
		
		$("#expander"+nnnf[startAt]).load(pathtomenu+nnnf[startAt]+" ul", function(){initNav(); rebinder(nnnf[startAt]); startAt++; if(startAt<stopAt){getNavItemsAuto(nnnf);}});
	
}


function closeNavItems(nn){
	doublejep=true;
	testing="a[href='"+nn+"']"
	
	
	$("#expander"+nn+" a").children().children().unbind();
	
	$(testing).html("+ ");
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
																			   getNavItems($(this).attr("href"));
																			   $(this).html("- ");
																			   $(this).blur(); 														   
																			   });
	$(nn).html("+ ");
	$("#expander"+iefix).addClass("empty");
	
	doublejep=false;
}

function rebinder(nn){
	if(doublejep==false){
		$("#expander"+nn).removeClass("navLoading");
		$("#expander"+nn).parent().children().eq(0).children().eq(0).unbind().bind("click",function(e){e.preventDefault(); closeNavItems($(this).attr("href"));$(this).blur();});
	}
	}
	
function highlightRegion(region){
	$(".sideBarContent .office").parent().addClass("hidden");
	$("#"+region).removeClass("hidden")
}
var stAT=1;
function rotateBigSplashImgIE6(){
	
	numS=$("#imageRotate div").length-1;
	$("#imageRotate div").css({display:"none"});
	$("#imageRotate div").eq(stAT).css({display:"block"});
	if(stAT < numS){
			stAT++;
		}else{
			stAT=0;
		}
	setTimeout("rotateBigSplashImgIE6()", 7500);
}

function changeHomePageRightColumnContentIE6(tothis){
	$("#tabsRotate div").css({display:"none"});
	$(tothis).css({display:"block"});
	$(".homeNavRight li a").removeClass("active");
	$(".homeNavRight li a[href='"+tothis+"']").addClass("active");
}

// extremely simple ie6 no frills modal window

var ie6ModalWindowHTML='<table id="ie6ModalBG" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"><tr><td>&nbsp;</td></tr></table><div id="ie6ModalContainer"><div id="ie6ModalTopper"><a href="javascript:closeIE6Modal()"><img src="/common/images/template/closeLightbox.png" alt="close" class="modalCloseIE6" /></a><span class="clearit"></span></div><div id="ie6ModalContent"><img id="ie6ModalImage" src="about:blank" alt=""  align="middle" /></div><div id="ie6ModalFooter"></div></div>';

function openIE6Modal(im,imDes,imTitle){
	$("#ie6ModalBG").remove();
	$("#ie6ModalContainer").remove();
	
	$("body").prepend(ie6ModalWindowHTML);
	$("#ie6ModalBG").css({position:"absolute",top:"0px",left:"0px",opacity:".50",width:"100%",height:"100%",background:"#343434 none",zIndex:89000});
	$("#ie6ModalBG").css({height:$(window).height()+"px"});
	$("#ie6ModalImage").attr("src",im);
	var imgTitle=imTitle;
	 imgTitle="<h3>"+imgTitle+"</h3>";
	
	$("#ie6ModalImage").load(function(){
		imgWidth=$("#ie6ModalImage").width();
		windWidth=$(window).width();
		if(windWidth>imgWidth){
			imgC=(windWidth-imgWidth)/2;
			$("#ie6ModalContainer").css({left:imgC+"px",top:20+"px"});
			$(".sideBar").css({marginLeft:"850px"});
		}
	});
	$("#ie6ModalTopper").prepend(imgTitle);
	$("#ie6ModalFooter").prepend(imDes);
	$("html").css({overflow:"hidden"});
	window.scrollTo(0,0);
}

function closeIE6Modal(){
	$("#ie6ModalBG").remove();
	$("#ie6ModalContainer").remove();
	$(".sideBar").css({marginLeft:"680px"});
	$("html").css({overflow:"auto"});
}