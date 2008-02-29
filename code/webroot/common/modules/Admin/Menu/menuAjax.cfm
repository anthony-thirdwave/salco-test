<cfif ThisTag.ExecutionMode IS "Start">
	<cfparam name="ATTRIBUTES.isAutoCollapse" default="1">
	<cfparam name="ATTRIBUTES.isParentChooser" default="0">
	<cfparam name="ATTRIBUTES.style" default="">
	<!--- JSFunctionName used to replace default menu link with a javascript function call  ---->
	<cfparam name="ATTRIBUTES.JSFunctionName" default="">
	<!--- isNewPage is a flag to determine if this module is used to choose a new page location ---->
	<cfparam name="ATTRIBUTES.isNewPage" default="">
	<cfparam name="ATTRIBUTES.MVEid" default="1">
	<!--- idPrefix used to keep js fuctions and variables, as well as div ids unique when multiple menus exist on same page ---->
	<cfparam name="ATTRIBUTES.idPrefix" default="">
	<cfif IsDefined("URL.mvcid") AND NOT IsDefined("ATTRIBUTES.mvcid")>
		<cfset ATTRIBUTES.mvcid = URL.mvcid>
	<cfelse>
		<cfparam name="ATTRIBUTES.mvcid" default="1">
	</cfif>
	
	<cfset idPrefix = ATTRIBUTES.idPrefix>
	<!--- include icon image information --->
	<cfinclude template="menuAjaxIconStructInc.cfm">
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm" ThisCategoryID="#ATTRIBUTES.mvcid#" NameList="" IDList="#ATTRIBUTES.mvcid#">
	<cfif idlist EQ "0,-1">
		<cfset idlist = "-1">
	</cfif>
	
	
	<style>
		.childContent{
			padding-left: 10px;
		}
	</style>
	<cfoutput>
	<script language="javascript" type="text/javascript">
	
	function #idPrefix#getMenuHTTPObj() {
		var ua;
	
		if(window.XMLHttpRequest) {
			try {
				ua = new XMLHttpRequest();
			} catch(e) {
				ua = false;
			}
		} else if(window.ActiveXObject) {
			try {
				ua = new ActiveXObject("Microsoft.XMLHTTP");
			} catch(e) {
				ua = false;
			}
		}
		return ua;
	}
	
	<!--- store icon image information from cf structs into js arrays --->
		#idPrefix#aCollapsedIcons = new Array();
		<cfloop list="#StructKeyList(sIconsCollapsed)#" index="sKey">
		#idPrefix#aCollapsedIcons['#sKey#'] = "#StructFind(sIconsCollapsed,sKey)#";
		</cfloop>
		#idPrefix#aExpandedIcons = new Array();
		<cfloop list="#StructKeyList(sIconsExpanded)#" index="sKey">
		#idPrefix#aExpandedIcons['#sKey#'] = "#StructFind(sIconsExpanded,sKey)#";
		</cfloop>
	
	
	<!--- get icon path given category type and 'collapsed' status --->
	function #idPrefix#getIcon(typeID,isCollapsed){
		if(isCollapsed){
			if(typeof(#idPrefix#aCollapsedIcons[typeID]) == 'undefined'){
				return #idPrefix#aCollapsedIcons['default'];
			}
			else
				return #idPrefix#aCollapsedIcons[typeID];
		}
		else{
			if(typeof(#idPrefix#aExpandedIcons[typeID]) == 'undefined'){
				return #idPrefix#aExpandedIcons['default'];
			}
			else
				return #idPrefix#aExpandedIcons[typeID];
		}
	
	}
	
	#idPrefix#getMenuHTTPCall = #idPrefix#getMenuHTTPObj();
	<!--- inProgress: global var true if ajax call is currently in progress  --->
	#idPrefix#inProgress = false;
	<!--- responseDiv: global var to store id of div that ajax content is loaded into --->
	#idPrefix#responseDiv = null;
	<!--- hrefOpenArray: array to store 'open' href call --->
	#idPrefix#hrefOpenArray = new Array();
	<!--- hrefCloseArray: array to store 'close' href call --->
	#idPrefix#hrefCloseArray = new Array();
	<!--- hrefCloseArray: array to store category type of page (used to get icon) --->
	#idPrefix#typeIDArray = new Array();
	
	
	<!--- doChildCategories: initial ajax call to get child categories --->
	function #idPrefix#doChildCategories(catID,catTypeID){
		if(!#idPrefix#inProgress){
			#idPrefix#inProgress = true;
			#idPrefix#responseDiv = '#idPrefix#categoryChildContainer_'+catID;
			document.getElementById(#idPrefix#responseDiv).innerHTML='loading...';
			document.getElementById(#idPrefix#responseDiv).style.display='block';
			<cf_addToqueryString querystring="#REQUEST.CGIQueryString#" name="MVEid" value="#ATTRIBUTES.MVEid#" omitlist="MVEid,thisCatID,isAutoCollapse,MVSearchTerms,mvcid,hlid,ugid,cid,mvsla">
			#idPrefix#getMenuHTTPCall.open("GET", "/common/modules/admin/menu/menuAjaxGetChildCategories.cfm?#QueryString#&isAutoCollapse=#ATTRIBUTES.isAutoCollapse#<cfif ATTRIBUTES.JSFunctionName NEQ "">&JSFunctionName=#ATTRIBUTES.JSFunctionName#</cfif><cfif ATTRIBUTES.isNewPage NEQ "">&isNewPage=#ATTRIBUTES.isNewPage#</cfif><cfif idPrefix NEQ "">&idPrefix=#idPrefix#</cfif>&thisCatID=" + catID, true);
			#idPrefix#getMenuHTTPCall.onreadystatechange = #idPrefix#handleThisHttpResponse;
			#idPrefix#getMenuHTTPCall.send(null);
			<cfif ATTRIBUTES.isAutoCollapse EQ 1>
			collapseCall = document.getElementById('#idPrefix#catagoryAnchor_'+catID).href.split(";")[1] + ";";
			</cfif>
			#idPrefix#hrefOpenArray[catID] = "javascript:#idPrefix#openThisDiv('" + catID + "');"<cfif ATTRIBUTES.isAutoCollapse EQ 1> + collapseCall</cfif>;
			#idPrefix#hrefCloseArray[catID] = "javascript:#idPrefix#closeThisDiv('" + catID + "');";
			#idPrefix#typeIDArray[catID] = catTypeID;
			document.getElementById('#idPrefix#catagoryAnchor_'+catID).href = #idPrefix#hrefCloseArray[catID];
			document.getElementById('#idPrefix#catagoryBullet_'+catID).src = #idPrefix#getIcon(catTypeID,false);
		}
	}
	<!--- handleThisHttpResponse: stores response in appropriate div --->
	function #idPrefix#handleThisHttpResponse(){
		if (#idPrefix#getMenuHTTPCall.readyState == 4) {
			results = #idPrefix#getMenuHTTPCall.responseText;
			if(results == 'session timeout')
				window.location.href = "/common/admin/";
			document.getElementById(#idPrefix#responseDiv).innerHTML=results;
			#idPrefix#inProgress = false;
		}
	}
	<!---  closeThisDiv: collapses appropriate div, changes icon and href--->
	function #idPrefix#closeThisDiv(id){
		document.getElementById('#idPrefix#categoryChildContainer_'+id).style.display='none';
		document.getElementById('#idPrefix#catagoryAnchor_'+id).href = #idPrefix#hrefOpenArray[id];
		document.getElementById('#idPrefix#catagoryBullet_'+id).src = #idPrefix#getIcon(#idPrefix#typeIDArray[id],true);
	}
	<!---  openThisDiv: expands appropriate div, changes icon and href--->
	function #idPrefix#openThisDiv(id){
		document.getElementById('#idPrefix#categoryChildContainer_'+id).style.display='block';
		document.getElementById('#idPrefix#catagoryAnchor_'+id).href = #idPrefix#hrefCloseArray[id];
		document.getElementById('#idPrefix#catagoryBullet_'+id).src = #idPrefix#getIcon(#idPrefix#typeIDArray[id],false);
	}
	
	function #idPrefix#isDivExpanded(id){
		if(document.getElementById('#idPrefix#categoryChildContainer_'+id).style.display == 'block')
			return true;
		else
			return false;
	}
	
	<!---  IF menu is in auto colapse mode, include collapse function --->
	<cfif ATTRIBUTES.isAutoCollapse EQ 1>
	<!---  collapses all divs in idlist except thisid --->
	function #idPrefix#collapse(IdList,thisId){
		idArray = IdList.split(",");
		for(i=0;i<idArray.length;i++){
			if(idArray[i] != thisId){
				try {
					if(document.getElementById('#idPrefix#catagoryAnchor_'+idArray[i]).href.substr("javascript:".length,"#idPrefix#closeThis".length) == "#idPrefix#closeThis")
						#idPrefix#closeThisDiv(idArray[i]);
				} catch(e) {
				}
			}
		}
	}
	</cfif>
	</script>
	
	<div<cfif ATTRIBUTES.style NEQ ""> style="#ATTRIBUTES.style#"</cfif>>
	</cfoutput>
	<cfif ATTRIBUTES.IsParentChooser AND ATTRIBUTES.mvcid GT 0>
		<cfset ParentChooserInitID = ATTRIBUTES.mvcid>
	<cfelse>
		<cfset ParentChooserInitID = "none">
	</cfif>
		<cfmodule template="menuAjaxGetChildCategories.cfm" ParentChooserInitID="#ParentChooserInitID#" isTopLevel="1" thisCatID="#ListFirst(idlist)#" thisCatIDInitList="#ListRest(idlist)#" isAutoCollapse="#ATTRIBUTES.isAutoCollapse#" MVEid="#ATTRIBUTES.MVEid#" JSFunctionName="#ATTRIBUTES.JSFunctionName#" idPrefix="#idPrefix#" isNewPage="#Val(ATTRIBUTES.isNewPage)#">
	</div>
</cfif>