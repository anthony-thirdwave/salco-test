<cfparam name="REQUEST.GlobalNavURLPrefix" default="">
<cfscript>
	aTopNav = ArrayNew(1);
	sNavElem = StructNew();

	sNavElem["name"] = "About";
	sNavElem["alias"] = "about";
	sNavElem["id"] = 917;
	ArrayAppend(aTopNav,Duplicate(sNavElem));
</cfscript>

<!-- Main Navigation Snippet -->
<div id="mainNavigation">
    <ul class="menuCSS">
		<cfloop from="1" to="#ArrayLen(aTopNav)#" index="i">
			<cfoutput>
				<cfset thisNavElem = aTopNav[i]>
				<cfset class = "">
				<cfif ListFind(CategoryThreadList,thisNavElem.id)>
					<cfset class = "active">
				</cfif>
				<cfif i EQ ArrayLen(aTopNav)>
					<cfif class NEQ "">
						<cfset class = "#class# last">
					<cfelse>
						<cfset class = "last">
					</cfif>
				</cfif>
				<li<cfif class NEQ ""> class="#class#"</cfif>><a href="#REQUEST.GlobalNavURLPrefix##APPLICATION.contentPageInUrl#/#thisNavElem.alias#">#thisNavElem.name#</a></li>
			</cfoutput>
		</cfloop>
	</ul>



<!--- create main nav struct - nav elements will display in order listed --->
<cfscript>
	aMainNav = ArrayNew(1);
	sNavElem = StructNew();

	sNavElem["name"] = "Inspiration";
	sNavElem["alias"] = "inspiration";
	sNavElem["id"] = 1160;
	sNavElem["styleid"] = "n-insp";
	ArrayAppend(aMainNav,Duplicate(sNavElem));


</cfscript>

	<ul id="nav-main">
		<cfloop from="1" to="#ArrayLen(aMainNav)#" index="i">
			<cfoutput>
				<cfset thisNavElem = aMainNav[i]>
				<li id="#thisNavElem.styleid#"<cfif ListFind(CategoryThreadList,thisNavElem.id)> class="active"</cfif>><a href="#REQUEST.GlobalNavURLPrefix##APPLICATION.contentPageInUrl#/#thisNavElem.alias#">#thisNavElem.name#</a></li>
			</cfoutput>
		</cfloop>
	</ul>
</div> <!-- end #header -->

