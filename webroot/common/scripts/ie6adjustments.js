// ie6 adjustments

$(document).ready(function() {
						   changeSideBar();
						   $('#acc3').click(function() {
  								setTimeout("checkHeight()",3000);
							});
						   setTimeout("checkHeight()",5000);
});


function changeSideBar(){
	
	$('.sideBar').remove().insertBefore('.holderCenter');
	$('.sideBar').css({position:"absolute",marginLeft:"680px",marginTop:"270px",zIndex:"9000"});
	//$('.sideBarContent').removeClass("png")
	//$('.sideBar a').css({position:"relative",zIndex:"9100"});
	
	//$('.holderCenter').css({display:"none"});
}

function checkHeight(){
	sideNavH=$('#acc3').height();
	contHeight=$(".fade").height();
	if(contHeight<sideNavH){
		adjH=sideNavH-contHeight;
		adjH=adjH+contHeight+100;
		$(".fade").css({height:adjH+"px"});
		
		}
	}