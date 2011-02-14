$(document).ready(function() { 
			var browserWars=$.client.browser;	
			browserWars=browserWars.toLowerCase();			   	   
			$("#pagList .pagination .pagination a").bind("click",function(event) {event.preventDefault(); getPage(this.href);});
			$("body").addClass(browserWars);
	 });
	
	function getPage(pagetoget){
			$("#pagList").load(pagetoget+" #pagList", function(){addAj()});
		}
	
	function addAj(){
		$("#pagList .pagination .pagination a").bind("click",function(event) {event.preventDefault(); getPage(this.href)});
		}


$(document).ready(function() {
	$("#main").accordion({
	  obj: "div", 
	  wrapper: "div", 
	  el: ".h", 
	  head: "h4", 
	  next: "div", 
	  initShow : "div.outer:first",
	  event : "click",
	  collapsible : true
	});

	//Default Action
	$(".downloadContent").hide(); //Hide all content
	$("ul#tabsDownloads li a:first").addClass("tabActive").show(); //Activate first tab
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
});

$("html").addClass("js");
$.fn.accordion.defaults.container = false; 
$(function() {
	$("#acc3").accordion({initShow : "#current"});
	$("html").removeClass("js");
});

