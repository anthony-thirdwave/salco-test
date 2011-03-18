preventer=false
$(document).ready(function(){
	$("#searchProd").bind("keyup",function(e){
		getResults(e.keyCode)
		if (e.keyCode == 40 || e.keyCode == 38) { 
			e.preventDefault();
			gotoElements(e.keyCode);
			return false;
		}
		if(e.keyCode==13){
			e.preventDefault();
			gotoPage();
			return false;
		}
	});
	
	$("#searchProd").blur(function(e){
			setTimeout("blurred()",1500)
	});
	
	
});





function blurred(){
	$("#returns").html("");
	$("#returns").attr("style","display:none");
}

var elementStart=1;
function getResults(ec) {
	if(ec != 13){
	$("#returns").attr("style","display:block");
	vals=$("#searchProd").val();
	uvals=vals;
	vals=escape(vals);
	$("#q").html(vals);
	/*alert(vals)*/
	if(vals.length>0 && preventer==false && ec != 40 && ec !== 38) {
		preventer=true;
		$("#returns").load("/common/modules/product/productlookup.cfm?q="+vals, function() {
			preventer=false;
			if(uvals!= $("#searchProd").val()){
				$("#returns").attr("style","display:block");
				getResults(ec);
				elementStart=1;
						
			}
			$("#returns a").eq(0).parent().addClass("selected");
			
			$("#returns li li").hover(function(){
											$("#returns li li").removeClass("selected")
											arrDir="down";
											elementStart=$("#returns li").index(this);
											$(this).attr("class","selected");
											})
			
			$("#returns li").bind("click", function(e){
													e.preventDefault();
													
						if($(this).children("a").eq(0).attr("href")!=null){
														
						window.location=$(this).children("a").eq(0).attr("href");
													}
			});
		});
	}
	else {
		if(vals.length==0){
			$("#returns").html("");
			$("#returns").attr("style","display:none");
		}
	}
  }
}
	var arrDir="";
function gotoElements(kc){
	$("#returns a").parent().removeClass("selected");
	linkLength=$("#returns a").length-1;
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
		$("#returns a").eq(elementStart).parent().addClass("selected");
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
		$("#returns a").eq(elementStart).parent().addClass("selected");
		if(elementStart>0){
			elementStart--
		}
		else {
			elementStart=linkLength;
		}
	}
}

function gotoPage(){
	
	if($("#returns li.selected a").length>0){
		window.location=$("#returns li.selected a").attr("href");
	}
}