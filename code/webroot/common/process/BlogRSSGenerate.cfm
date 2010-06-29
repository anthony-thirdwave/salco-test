<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>BlogRSSGenerate</title>
</head>

<body>
<cfinvoke component="com.ContentManager.CategoryHandler" 
	method="GetBlog" 
	returnVariable="GetBlogs">
<cfset z=getTimeZoneInfo()>
<cfset MaxRows="10">

<cfloop index="BlogID" list="#ValueList(GetBlogs.BlogID)#">
	
	<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
		<cfprocresult name="GetBlog" maxrows="1">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(BlogID)#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.DefaultLocaleID#" null="No">
		<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="" null="Yes">
	</cfstoredproc>
	
	<cfset RSSDescription="">
	
	<cfif IsWDDX(GetBlog.CategoryLocalePropertiesPacket)>
		<cfwddx action="WDDX2CFML" input="#GetBlog.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
		<cfif StructKeyExists(sCategoryProperties,"MetaDescription") AND Trim(StructFind(sCategoryProperties,"MetaDescription")) IS NOT "">
			<cfset RSSDescription=StructFind(sCategoryProperties,"MetaDescription")>
		</cfif>
	</cfif>
	
	<cfinvoke component="com.ContentManager.BlogHandler" method="GetBlogEntriesByTopic" returnVariable="qGetBlogEntriesByTopic">
		<cfinvokeargument name="BlogID" value="#Val(BlogID)#">
	</cfinvoke>
	
	<cfset lTopic="ALL">
	<cfoutput query="qGetBlogEntriesByTopic" group="TopicID">
		<cfset lTopic=ListAppend(lTopic,TopicID)>
	</cfoutput>
	
	<cfloop index="ThisTopic" list="#lTopic#">
		<cfset DestinationFolder="#APPLICATION.WebRootPath#resources\syndication\">

		<cfif ThisTopic IS "All">
			<cfset DestinationFile="#DestinationFolder##GetBlog.CategoryAlias#.rss">
			<cfset RSSTitle="#APPLICATION.CompanyName#: #GetBlog.CategoryNameDerived#">
			<cfset RSSLink="http://#CGI.HTTP_Host##APPLICATION.utilsObj.parseCategoryUrl(GetBlog.CategoryAlias)#">
		<cfelse>
			<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
				<cfprocresult name="GetTopic" maxrows="1">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ThisTopic)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.DefaultLocaleID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="" null="Yes">
			</cfstoredproc>
			
			<cfset DestinationFile="#DestinationFolder##GetBlog.CategoryAlias#-#GetTopic.CategoryAlias#.rss">
			<cfset RSSTitle="#APPLICATION.CompanyName#: #GetBlog.CategoryNameDerived#: #GetTopic.CategoryNameDerived#">
			<cfset RSSLink="http://#CGI.HTTP_Host##APPLICATION.utilsObj.parseCategoryUrl(GetBlog.CategoryAlias)#?topic=#GetTopic.CategoryAlias#">
		</cfif>
		
		<cfinvoke component="com.ContentManager.BlogHandler" method="GetBlogEntries" returnVariable="GetBlogEntries">
			<cfinvokeargument name="BlogID" value="#Val(BlogID)#">
			<cfif ThisTopic IS NOT "All">
				<cfinvokeargument name="TopicAlias" value="#GetTopic.CategoryAlias#">
			</cfif>
		</cfinvoke>
		
		<cfset dateStr=dateFormat(now(),"yyyy-mm-dd") & "T" & timeFormat(now(),"HH:mm:ss") & "-" & numberFormat(z.utcHourOffset,"00") & ":00">
		<cfsavecontent variable="RDFContent">
		<rdf:RDF
			xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:dc="http://purl.org/dc/elements/1.1/"
			xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
			xmlns:admin="http://webns.net/mvcb/"
			xmlns:cc="http://web.resource.org/cc/"
			xmlns="http://purl.org/rss/1.0/">
		<cfoutput>
			<channel rdf:about="http://#CGI.HTTP_Host#/">
			<title>#XMLFormat(RSSTitle)#</title>
			<link>#RSSLink#</link>
			<description>#XMLFormat(RSSDescription)#</description>
			<dc:language>en-us</dc:language>
			<dc:creator></dc:creator>
			<dc:date>#dateStr#</dc:date>
			<admin:generatorAgent rdf:resource="http://#CGI.HTTP_Host#/" />
		</cfoutput>
		<items>
		<rdf:Seq>
		<cfoutput query="GetBlogEntries" maxrows="#MaxRows#">
			<rdf:li rdf:resource="#XMLFormat("http://#CGI.HTTP_Host##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#")#"/>
		</cfoutput>
		</rdf:Seq>
		</items>
		</channel>
		
		<cfoutput query="GetBlogEntries" maxrows="#MaxRows#">
			<item rdf:about="#XMLFormat("http://#CGI.HTTP_Host##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#")#">
				<title>#XMLFormat(CategoryName)#</title>
				<link>#XMLFormat("http://#CGI.HTTP_Host##APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#")#</link>
				<cfif Thumbnail IS NOT "">
					<cfset ThisDescription="<p><img src=""#Thumbnail#"" width=""440""></p><p>#Abstract# <a href=""#Link#"">read more</a></p>">
				<cfelse>
					<cfset ThisDescription="<p>#Abstract# <a href=""#Link#"">read more</a></p>">
				</cfif>
				<description>#XMLFormat(ThisDescription)#</description>
				<cfif Author IS NOT "">
					<dc:creator>#XMLFormat(Author)#</dc:creator>
				<cfelse>
					<dc:creator>#XMLFormat("http://#CGI.HTTP_Host#/")#</dc:creator>
				</cfif>
				<dc:subject>#ReplaceNoCase(XMLFormat(Topic),",",", ","All")#</dc:subject>
				<cfset dateStr=dateFormat(PublishDateTime,"yyyy-mm-dd") & "T" & timeFormat(PublishDateTime,"HH:mm:ss") & "-" & numberFormat(z.utcHourOffset,"00") & ":00">
				<dc:date>#dateStr#</dc:date>
			</item>
		</cfoutput>
		</rdf:RDF>
		</cfsavecontent>
		<cfif FileExists(DestinationFile)>
			<cffile action="delete" file="#DestinationFile#">
		</cfif>
		<cffile action="write" file="#DestinationFile#" output="#RDFContent#" addnewline="Yes">
		<cfoutput>
			Created File: #DestinationFile#<br />
		</cfoutput>
	</cfloop>
</cfloop>

</body>
</html>
