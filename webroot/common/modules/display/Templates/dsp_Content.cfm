<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/common/styles/salco_global.css" rel="stylesheet" type="text/css" />
<link href="/common/styles/other.css" rel="stylesheet" type="text/css" />
<link href="/common/scripts/projekktor/style.css" rel="stylesheet" type="text/css" />


<script type="text/javascript" src="/common/scripts/jquery-1.5.1.min.js"></script>
<cfswitch expression="#TemplateID#">
	<cfcase value="22"><!--- home --->
		<script type="text/javascript" src="/common/scripts/jquery.cycle.js"></script>
		<script type="text/javascript" src="/common/scripts/jquery-ui-1.8.7.custom.min.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
					if(document.all && $.browser.version != "6.0" || !document.all){ 				   
				$("#tabsRotate").tabs({ fx: { opacity: 'toggle' } });
				$('#tabsRotate').hover(function(){
						$(this).tabs({ fx: { opacity: 'toggle' } });
					}
				);
					}
					
					if(document.all && $.browser.version == "6.0"){
						$("#tabsRotate .content").css({display:"none"});
						$("#tabsRotate .content").eq(0).css({display:"block"});
						setTimeout("rotateBigSplashImgIE6()", 7500);
						$(".homeNavRight li a").bind("click",function(e){e.preventDefault();changeHomePageRightColumnContentIE6($(this).attr("href"))});
						}
			});
		
			$(document).ready(function() { 
				if(document.all && $.browser.version != "6.0" || !document.all){ 
					$('#imageRotate').cycle({
						fx: 'fade', 
						speed: 2500
					});
				
				}
			});
		</script>
		<script type="text/javascript" src="/common/scripts/jquery.client.js"></script>
		<script type="text/javascript" src="/common/scripts/projekktor/projekktor.min.js"></script>
		<script type="text/javascript" src="/common/scripts/common.js"></script>
	</cfcase>
	<cfdefaultcase>
		<script type="text/javascript" src="/common/scripts/jquery.nestedAccordion.js"></script> 
		<script type="text/javascript" src="/common/scripts/jquery.client.js"></script>
		<script type="text/javascript" src="/common/scripts/projekktor/projekktor.min.js"></script>
		<script type="text/javascript" src="/common/scripts/common.js"></script>
        <script type="text/javascript" src="/common/scripts/lightbox.js"></script>
	</cfdefaultcase>
</cfswitch>

<!--[if lte IE 6]>

<link rel="stylesheet" type="text/css" href="/common/styles/ie6pngFix.css" />
<script type="text/javascript" src="/common/scripts/ie6adjustments.js"></script>

<![endif]-->

<cfif ListFindNoCase("62,64",CategoryTypeID)>
	<cfif ListLen(CategoryThreadList) GTE "5">
		<cfoutput>
			<script type="text/javascript">
				$(document).ready(function() {
					<cfset ThisList="">
					<cfloop index="i" from="5" to="#ListLen(CategoryThreadList)#" step="1">
						<cfset ThisList=ListAppend(ThisList,ListGetAt(CategoryThreadList,i))>
					</cfloop>
					getNavItemsAuto('#ThisList#');
				});
			</script>
		</cfoutput>
	</cfif>
	<script type="text/javascript" src="/common/scripts/jquery.smart_autocomplete.js"></script>
	<script type="text/javascript" src="/common/scripts/typeahead.js"></script>
</cfif>
<cfoutput>
	<!--- These tags are managed by the CMS. --->
	<cfif Trim(PageTitleOverride) EQ "">
		<cfset pageTitleList = ListRest(CategoryThreadName)>
		<cfset thisPageTitle = APPLICATION.utilsObj.generatePageTitleString(pageTitleList)>
	<cfelse>
		<cfset thisPageTitle = PageTitleOverride>
	</cfif>
	<meta name="keywords" content="#MetaKeywords#" />
	<meta name="description" content="#Metadescription#" />
	<meta name="generator" content="#APPLICATION.GeneratorMeta#" />
	<meta name="generator-content" content="#APPLICATION.GeneratorContentMeta#" />
	<meta name="dc.title" content="#HTMLEditFormat(CurrentCategoryName)#" />
	<!--- include meta --->
	<cfif IsDefined("PageType")>
		<meta name="dc.type" content="#PageType#" />
	</cfif>
	<title>#thisPageTitle#</title>
</cfoutput>

<cfif APPLICATION.Production>
	<script type="text/javascript">

		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-8851532-4']);
		_gaq.push(['_trackPageview']);
		
		(function() {
		   	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		   	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
	</script>
</cfif>

</head>
<cfoutput>
	<body id="#CSSID#" class="#CSSClass#"><a name="top"></a>
</cfoutput>

<div class="holderCenter">
	<div id="holderMastHead">
		<div id="holderNavMain">
			<div style="padding-left:22px"><cfoutput><a href="#APPLICATION.utilsObj.parseCategoryUrl('/')#"><img src="/common/images/template/salco_logo_masthead.png" alt="salco" /></a></cfoutput></div>
			<cfinclude template="/common/modules/Display/Navigation/dsp_NavGlobal.cfm">
		</div>
		<div id="holderNavSearch" style="padding-right:25px;">
			<cfoutput>
			<form action="#APPLICATION.utilsObj.parseCategoryUrl('advanced-search-1')#" method="get">
				<input class="backSearch" name="searchTxt" type="text" <cfif IsDefined("URL.searchTxt")> value="#HTMLEditFormat(URL.searchTxt)#"</cfif>/><input class="btnSearch" type="submit"/>
			</form>
			</cfoutput>
			<cfmodule template="/common/modules/Display/Navigation/dsp_NavSub.cfm"
				ParentID="14"
				CSSID=""
				CSSClass="nav searchLinks">
		</div>
		<div class="clearFix"></div>
		<div class="redLine"></div>
		<div class="hazarsolve"><a href="http://www.hazarsolve.com/" target="_blank" onclick="_gaq.push(['_trackPageview', '/custom_outbound_hazarsolvelink']);">Hazarsolve A Division of Salco Products</a></div>
		<cfmodule template="/common/modules/Display/Navigation/dsp_NavSub.cfm"
			ParentID="7"
			CSSID="subNav"
			CSSClass="nav">
	</div>
	
	<cfswitch expression="#TemplateID#">
		<cfcase value="22">
			<div class="subBackHome">
				<div class="contentHome">
					<div class="homeLeft">
						<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
						<div id="pageFooter">
							<cfinclude template="/common/modules/Display/Navigation/dsp_NavFooter.cfm">
						</div>
					</div>
					<div class="homeRight">
						<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
					</div>
					<div class="clearFix"></div>
				</div>
			</div>
		</cfcase>
		<cfcase value="23,1502"><!--- "Left" template --->
			<div class="subBack">
				<div class="holderFull">
					<div class="holderFullHeaderSp png">
						<div class="spHolder">	
							<div class="pad40">
								<cfinclude template="/common/modules/display/navigation/dsp_NavBreadCrumb.cfm">
								<cfoutput><h1>#CurrentCategoryName#</h1></cfoutput>
							</div>
						</div>
						<div class="clearFix"></div>
					</div>
					<div class="holderFullSp">
						<div class="spLeft">
							<div style="padding:0px 40px 60px 40px">
								<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
							</div>
						</div>
						<cfsavecontent variable="RightContent">
							<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
						</cfsavecontent>
						<cfif Trim(RightContent) IS NOT "">
							<div class="spRight">
								<img src="common/images/side_bar_top_sp.png"/>
								<div style="padding: 0 15px 0 15px;">
									<cfoutput>#RightContent#</cfoutput>
								</div>
							</div>
						</cfif>
						<div class="clearFix"></div>
					</div>
				</div>
			</div>
		</cfcase>
		<cfdefaultcase>
			<div class="subBack">
				<div class="contBack">
					<div class="gradSM">
						<!---- START CONTENT --->
						<cfif ListFind("62,64",CategoryTypeID)>
							<div id="typeahead">
                                <input id="searchProd" value="Product Search..." />
                                <div id="q"></div>
                                <div id="returns"></div>
                            </div>
							<cfif ListLen(CategoryThreadList) GTE "4">
								<ul id="acc3">
								<li class="treeHeader"><cfoutput>#ListGetAt(CategoryThreadName,3)#</cfoutput></li>
								<cfmodule template="/common/modules/display/navigation/dsp_NavProduct.cfm" CategoryID="#ListGetAt(CategoryThreadList,4)#">
								</ul>
							</cfif>
						<cfelseif ListLen(CategoryThreadList) GTE "3">
							<cfsavecontent variable="LeftNav">
								<cfmodule template="/common/modules/display/navigation/dsp_NavR.cfm" CategoryID="#ListGetAt(CategoryThreadList,3)#">
							</cfsavecontent>
							<cfif Trim(LeftNav) IS NOT "">
								<cfoutput>#LeftNav#</cfoutput>
							<cfelse>
								<div id="emptyleftcolumn"></div>
							</cfif>
						<cfelse>
							<div id="emptyleftcolumn"></div>
						</cfif>
						<div class="holderWide">
							<div class="holderWideHeader png">&nbsp;</div>
							<div class="holderWideBack">
								<div class="fade">
									<cfinclude template="/common/modules/display/navigation/dsp_NavBreadCrumb.cfm">
									<cfif ListFind("62,64",CategoryTypeID) IS "0"><cfoutput><h1>#CurrentCategoryName#</h1></cfoutput></cfif>
									<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="401">
									<cfswitch expression="#AllowComments#">
										<cfcase value="1"><!--- Allow comments --->
											<cfmodule template="/common/modules/Comments/dsp_comments.cfm" 
												EntityName="t_Category" 
												EntityID="#CurrentCategoryID#"
												CommentNotificationEmail="#CommentNotificationEmail#"
												PageTitle="#CurrentCategoryName#">
										</cfcase>
										<cfcase value="2"><!--- Display comments but not form --->
											<cfmodule template="/common/modules/Comments/dsp_comments.cfm" 
												EntityName="t_Category" 
												EntityID="#CurrentCategoryID#" 
												AllowComments="0"
												CommentNotificationEmail="#CommentNotificationEmail#"
												PageTitle="#CurrentCategoryName#">
										</cfcase>
										<cfcase value="3"><!--- Display comments and archive message but not form --->
											<cfmodule template="/common/modules/Comments/dsp_comments.cfm" 
												EntityName="t_Category" 
												EntityID="#CurrentCategoryID#" 
												AllowComments="0"
												DisplayArchiveMessage="1"
												CommentNotificationEmail="#CommentNotificationEmail#"
												PageTitle="#CurrentCategoryName#">
										</cfcase>
									</cfswitch>
                                        <!--[if IE 7]>
                                        <div class="ie7AccordionSpacerFix">&nbsp;</div>
                                        <![endif]-->
									</div>
								</div>
							</div>
							<cfif sIncludeFileBlank[402] IS NOT "1">
								<cfsavecontent variable="ThisRightColumnContent">
									<cfmodule template="/common/modules/contentManager/ContentPositionOutput.cfm" PositionID="402">
								</cfsavecontent>
								<cfif Trim(ThisRightColumnContent) IS NOT "">
									<div class="sideBar">
										<div class="sideBarTop png"></div>
										<div class="sideBarContent ">
											<cfoutput>#ThisRightColumnContent#</cfoutput>
										</div>
										<div class="sideBarBot png"></div>
									</div>
								</cfif>
							</cfif>
							<div class="clearFix"></div>
						</div>
					</div>
					<div class="holderWideFooter png"></div>
				</div>
				<div id="pageFooter">
					<cfinclude template="/common/modules/Display/Navigation/dsp_NavFooter.cfm">
				</div>
				
			</cfdefaultcase>
		</cfswitch>
	</div>
</body>
</html>
<!--- clear the variables scope to slow coldfusion memory leak --->
<cfset structClear(variables)>
