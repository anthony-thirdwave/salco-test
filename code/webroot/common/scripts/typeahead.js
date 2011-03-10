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
			gotoPage()
		}
	});
	
	$("#searchProd").blur(function(e){
			setTimeout("blurred()",1500)
	});
	
	/*$("#searchProd").focus(function(e){
			
	});*/
	
	/*$("#searchProd").bind("blur",function(){clearTimeout(cDown);});*/
});

function blurred(){
	$("#returns").html("");
	$("#returns").attr("style","display:none");
}

var elementStart=1;
function getResults(ec) {
	//clearTimeout(cDown);
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
				getResults();
				elementStart=1;
						
			}
			$("#returns a").eq(0).parent().addClass("selected");
		});
	}
	else {
		if(vals.length==0){
			$("#returns").html("");
			$("#returns").attr("style","display:none");
		}
	}
}
	
function gotoElements(kc){
	$("#returns a").parent().removeClass("selected");
	linkLength=$("#returns a").length-1;
	if(kc==40){
		$("#returns a").eq(elementStart).parent().addClass("selected");
		if(elementStart<linkLength){
			elementStart++;
			}
		else {
			elementStart=0;
		}		
	}
		
	if(kc==38){
		if(elementStart==0){
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