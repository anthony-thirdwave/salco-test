<cfparam name="ATTRIBUTES.CategoryID" default="">
<cfparam name="ATTRIBUTES.ContentID" default="">
<cfparam name="EmployeeName" default="">
<cfparam name="EmployeeLink" default="">

<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetNewsContent">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(ATTRIBUTES.ContentID)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
</cfstoredproc>

<cfset sContentBody=StructNew()>
<cfset newsImagesThumbnail="">
<cfset newsImagesLarge="">

<cfoutput query="GetNewsContent">
	<cfif IsWDDX(GetNewsContent.ContentBody)>
		<cfwddx action="WDDX2CFML" input="#GetNewsContent.ContentBody#" output="sContentBody">
	</cfif>
</cfoutput>

<cfset newsImagesLarge="">
<cfset newsImageThumbnail="">
<cfif StructKeyExists(sContentBody,"aFile") AND IsArray(sContentBody.aFile) AND ArrayLen(sContentBody.aFile) GT 0>
	<cfset aFile=sContentBody.aFile>
	<cfsavecontent variable="newsImagesThumbnail">
		<cfoutput>
			<cfloop from="1" to="#ArrayLen(aFile)#" index="i">
				<cfset sFile=aFile[i]>
				<cfif IsStruct(sFile) AND StructKeyExists(sFile,"ThumbnailPath") AND sFile.ThumbnailPath NEQ "" AND FileExists(application.utilsObj.GetPathFromURL(sFile.ThumbnailPath))>
					<cfif StructKeyExists(sFile,"FileCaption") AND sFile.FileCaption NEQ "">
						<cfset ThisCaption="#sFile.FileCaption#">
					<cfelse>
						<cfset ThisCaption="">
					</cfif>
					<img class="curveMe" src="#sFile.ThumbnailPath#" align="left" style="display:block" alt="#ThisCaption#" title="#ThisCaption#">
				</cfif>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
	<cfsavecontent variable="newsImagesLarge">
		<cfoutput>
			<cfloop from="1" to="#ArrayLen(aFile)#" index="i">
				<cfset sFile=aFile[i]>
				<cfif IsStruct(sFile) AND StructKeyExists(sFile,"FilePath") AND sFile.FilePath NEQ "" AND FileExists(application.utilsObj.GetPathFromURL(sFile.FilePath))>
					<cfif StructKeyExists(sFile,"FileCaption") AND sFile.FileCaption NEQ "">
						<cfset ThisCaption="#sFile.FileCaption#">
					<cfelse>
						<cfset ThisCaption="">
					</cfif>
					<img src="#sFile.FilePath#" alt="#ThisCaption#" >
				</cfif>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
</cfif>

<cfset newsContent="">
<cfif StructKeyExists(sContentBody,"HTML")>
	<cfset newsContent="#application.utilsObj.ReplaceMarks(sContentBody.HTML)#">
</cfif>	

<cfinvoke component="com.ContentManager.NewsHandler"
 	method="GetNews"
	newsID="#ATTRIBUTES.CategoryID#"
	returnVariable="qryNews">

<cfif len(qryNews.SubTitle)>					
	<cfif listlen(qryNews.subTitle,"&") gte 2>
		<cfset EmployeeName=listGetAt(qryNews.subTitle,2,"&")>
		<cfset EmployeeLink=listGetAt(qryNews.subTitle,1,"&")>
	</cfif>
</cfif>				
	
<cfoutput query="qryNews">
	<article class="news">
		<div class="inArt">
			<cfif len(newsImagesThumbnail)>
				<div class="alignLeft">
					#newsImagesThumbnail#
				</div>
			</cfif>
			<cfif APPLICATION.ApplicationName EQ "www.salco">
			<div class="byline"><cfif len(EmployeeName)>#EmployeeName#</cfif></div>
			<cfelse>
			<h1 style="">#qryNews.title#</h1>
			<div class="byline"><cfif len(EmployeeName)><a href="#APPLICATION.utilsObj.parseCategoryUrl(EmployeeLink)#">#EmployeeName#</a></cfif></div>
			</cfif>
			<div class="date">#DateFormat(qryNews.publishDate,"m/dd/yyyy")#</div>
			<cfif len(newsContent)>
				<div class="artContent">
					#newsContent#
				</div>
			</cfif>
			<div class="clearit"></div>
		</div>
	</article>
</cfoutput>
<div class="lrgImgs">
	<cfoutput>
		#newsImagesLarge#
	</cfoutput>
</div>