<cfparam name="ATTRIBUTES.ProductID" default="-1">
<cfparam name="ATTRIBUTES.SpecificationSetID" default="8000">
<cfif IsDefined("APPLICATION.LanguageID")>
	<cfparam name="ATTRIBUTES.LanguageID" default="#APPLICATION.LanguageID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LanguageID" default="100">
</cfif>

<cfif IsDefined("APPLICATION.LocaleID")>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.LocaleID#">
<cfelse>
	<cfparam name="ATTRIBUTES.LocaleID" default="#APPLICATION.DefaultLocaleID#">
</cfif>

<cfif Val(ATTRIBUTES.ProductID) GT "0" AND Val(ATTRIBUTES.LanguageID) GT "0">
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetProduct">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ATTRIBUTES.ProductID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#ATTRIBUTES.LocaleID#" null="No">
	</cfstoredproc>
	<cfinvoke component="/com/Product/ProductHandler"
		method="GetProductFamilyID"
		returnVariable="CurrentProductFamilyID"
		ProductID="#ATTRIBUTES.ProductID#">
	<cfquery name="GetCache" datasource="#APPLICATION.DSN#">
		SELECT     MAX(CacheDateTime) AS CacheDateTime
		FROM         t_Category
		WHERE     CategoryID IN (#ATTRIBUTES.ProductID#,#Val(CurrentProductFamilyID)#)
	</cfquery>
	<CFSET ExecuteTempFile="#ATTRIBUTES.LocaleID#/ProductDetailOther_v1.0_#ATTRIBUTES.ProductID#_loc#ATTRIBUTES.LocaleID#_#DateFormat(GetCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetCache.CacheDateTime,'HHmmss')#.cfm">
	<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") or REQUEST.ReCache>
		<cfsaveContent Variable="FileContents">
			<cfset MyProduct=CreateObject("component","com.Product.Product")>
			<cfset MyProduct.Constructor(Val(ATTRIBUTES.ProductID),ATTRIBUTES.LanguageID)>
			<cfset aView=MyProduct.GetProperty("aProductView")>
			
			<cfset tempArray = ArrayNew(1)>
			<cfloop index="i" from="1" to="#ArrayLen(aView)#" step="1">
				<cfif aView[i].SpecificationSetID EQ ATTRIBUTES.SpecificationSetID or aView[i].SpecificationSetID IS "">
					<cfset ArrayAppend(tempArray,aView[i])>
				</cfif>
			</cfloop>
			<cfset aView = tempArray>
			
			<cfoutput>
				<cfif ArrayLen(aView) GT "0">
					<script type="text/javascript">document.write("<style type='text/css'> ##gallery { display: none; } </style>");</script>
					<!--[if lt IE 6]><style media="screen,projection" type="text/css">##gallery { display: block; }</style><![endif]-->
					<script type="text/javascript">
						var gal = {
							init : function() {
								if (!document.getElementById || !document.createElement || !document.appendChild) return false;
								if (document.getElementById('gallery')) document.getElementById('gallery').id = 'jgal';
								var li = document.getElementById('jgal').getElementsByTagName('li');
								li[0].className = 'activeThm';
								for (i=0; i<li.length; i++) {
									li[i].style.backgroundImage = 'url(' + li[i].getElementsByTagName('img')[0].src + ')';
									li[i].style.backgroundRepeat = 'no-repeat';
									li[i].title = li[i].getElementsByTagName('img')[0].alt;
									gal.addEvent(li[i],'click',function() {
										var im = document.getElementById('jgal').getElementsByTagName('li');
										for (j=0; j<im.length; j++) {
											im[j].className = '';
										}
										this.className = 'activeThm';
									});
								}
							},
							addEvent : function(obj, type, fn) {
								if (obj.addEventListener) {
									obj.addEventListener(type, fn, false);
								}
								else if (obj.attachEvent) {
									obj["e"+type+fn] = fn;
									obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
									obj.attachEvent("on"+type, obj[type+fn]);
								}
							}
						}
						
						gal.addEvent(window,'load', function() {
							gal.init();
						});
					</script>
			
					<div class="holderGallery">
					<ul id="gallery">
					<cfloop index="i" from="1" to="#ArrayLen(aView)#" step="1">
						<li><a href="#aView[i].MainFilePath#" target="_blank"><cfif aView[i].ThumbnailFilePath IS NOT "">#aView[i].ThumbnailFilePath#<cfelse>#aView[i].ResourceName#</cfif></a></li>
					</cfloop>
					</ul>
					</div>
				</cfif>
				
			</cfoutput>
		</cfsavecontent>
		<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
	</cfif>
	<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">
</cfif>