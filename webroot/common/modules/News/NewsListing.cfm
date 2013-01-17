<cfparam name="APPLICATION.LocaleID" default="-1">
<cfparam name="nlmode" default="Active">
<cfparam name="ATTRIBUTES.NumItems" default=" ">

<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#">
	SELECT     Max(CacheDateTime) as CACHEDATETIME 
	FROM         t_Category
	WHERE     CategoryTypeID=67
</cfquery>

<cfif nlmode IS "Archive">
	<cfset ThisShowInNavigation="0">
<cfelse>
	<cfset ThisShowInNavigation="1">
</cfif>

<CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+NewsList_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm">

<CFIF NOT FileExists("#APPLICATION.ExecuteTempDir##ExecuteTempFile#") OR REQUEST.ReCache>
	
	<cfquery name="GetNewsCats" datasource="#APPLICATION.DSN#" maxrows="1">
		SELECT     CategoryID
		FROM         t_Category
		WHERE     CategoryTypeID=67
	</cfquery>
	
	<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetContentList">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#GetNewsCats.CategoryID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="401" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
	</cfstoredproc>

	<cfif Val(ATTRIBUTES.NumItems) IS "0">
		<cfquery name="GetNews" dbtype="query">
			select * from GetContentList  order by contentdate1
		</cfquery>
	<cfelse>
		<cfquery name="GetNews" dbtype="query" maxrows="#Val(ATTRIBUTES.NumItems)#">
			select * from GetContentList  order by contentdate1
		</cfquery>
	</cfif>

	<cfsaveContent Variable="FileContents">
		
		<cfoutput query="GetNews">
			<cfif Contentdate1 gte DateAdd("d",-1,now())>
				<cfset Text="">
				<cfset LinkURL="">
				<cfset ImageThumbnail="">
				<cfif isWddx(ContentBody)>
					<cfwddx action="WDDX2CFML" input="#ContentBody#" output="sProperties">
					<cfloop index="ThisProp" list="Text,LinkURL,ImageThumbnail"> 
						<cfif StructKeyExists(sProperties,"#ThisProp#") AND Trim(StructFind(sProperties, "#ThisProp#")) IS NOT "">
							<cfset Setvariable("#ThisProp#",StructFind(sProperties, "#ThisProp#"))>
						</cfif>
					</cfloop>
				</cfif>
				<p><cfif ImageThumbnail IS NOT ""><img src="#ImageThumbnail#" align="left"/></cfif>
				
				<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#application.utilsObj.RemoveLeadingPTag(Text)#" NumChars="100" varname="Thistext">
				<cfset Display="<b>#ContentNameDerived#</b> (#DateFormat(ContentDate1)#)<BR>#ThisText#">
				<cfif LinkURL IS NOT ""><a href="#LinkURL#" <cfif Left(LinkURL,4) IS "http">target="_blank"</cfif>>#Display#</A>
				<cfelse>#Display#
				</cfif>
				
				<hr size="1" noshade /></p>
			</cfif>
		</cfoutput>
		
		</cfsavecontent>
	<cffile action="WRITE" file="#APPLICATION.ExecuteTempDir##ExecuteTempFile#" output="#FileContents#" addnewline="Yes">
</cfif>

<cfinclude template="#APPLICATION.TempMapping##ExecuteTempFile#">