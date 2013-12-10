<cfcomponent displayname="NewsHandler" output="true">
	
	<cffunction name="init" returntype="NewsHandler" output="false">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="GetNews" output="false" returntype="query">
		<cfargument name="homePageDisplay" default="0" type="numeric" required="false">
		<cfargument name="TopicID" default="0" type="numeric" required="false">
		<cfargument name="newsID" default="0" type="numeric" required="false">
		<cfargument name="rowNumber" default="0" type="numeric" required="false">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfinvoke component="com.ContentManager.NewsHandler"
			method="GetAllNews"
			NewsTopCategoryID="#APPLICATION.NewsCategoryID#"
			returnVariable="qGetAllNews">

		<cfquery name="LOCAL.qGetNews" dbtype="query">
			SELECT	*
			FROM	qGetAllNews
			WHERE	1=1
			<cfif val(ARGUMENTS.NewsID) gt 0>
				AND newsID=<cfqueryparam value="#ARGUMENTS.newsID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif val(ARGUMENTS.rowNumber) gt 0>
				AND rowNumber=<cfqueryparam value="#ARGUMENTS.rowNumber#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif val(ARGUMENTS.homePageDisplay) eq 1>
				AND	homePageDisplayFlag=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif val(ARGUMENTS.TopicID) gt 0>
				AND CONTAINS (TopicIDList, '#ARGUMENTS.TopicID#') > 0
			</cfif>
		</cfquery>
		
		<cfreturn LOCAL.qGetNews>
	</cffunction>
	
	<cffunction name="GetAllNews" output="false" returntype="query">
		<cfset VAR LOCAL=StructNew()>
		
		<cfif NOT IsDefined("REQUEST.GetAllNews")>
			<cfquery name="LOCAL.GetNewsPages" datasource="#APPLICATION.DSN#">
				SELECT     CategoryID
				FROM       t_Category
				WHERE      CategoryTypeID=<cfqueryparam value="82" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset lNewsPageID=valueList(LOCAL.GetNewsPages.CategoryID)>
			
			<cfset LOCAL.qryGetNews=QueryNew("rowNumber,newsID,title,subTitle,Topics,topicIDList,Description,headerImage,publishDate,link,homePageDisplayFlag,EmergencyAlert") />
			
			<cfif ListLen(lNewsPageID)>
				<cfquery name="LOCAL.GetNews" datasource="#APPLICATION.DSN#">
					SELECT	c.categoryID,c.categoryAlias,c.parentID,c.categoryName,p.PropertiesPacket as CategoryLocalePropertiesPacket, 
							c.publishDateTime,
							CASE isNull(cl.categoryLocaleName,'0')  
							 WHEN '' THEN c.categoryName  
							 WHEN '0' THEN c.categoryName  
							 ELSE cl.categoryLocaleName  
							 END as categoryNameDerived  
					FROM	t_category c JOIN t_categoryLocale cl on c.categoryID=cl.categoryID
					JOIN t_Properties p ON  cl.PropertiesID=p.PropertiesID
					WHERE	c.categoryID in (<cfqueryparam value="#lNewsPageID#" cfsqltype="cf_sql_integer" list="yes">)
					AND		c.CategoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
					ORDER BY	c.PublishDateTime DESC
				</cfquery>
				<!--- Create a new query. --->
				<cfset rowCount=0>
				<cfloop query="LOCAL.GetNews">
					<cfif IsWDDX(CategoryLocalePropertiesPacket)>
						<cfset rowCount=rowCount + 1>
						<cfset QueryAddRow(qryGetNews)>
						<cfset thisNewsID=LOCAL.GetNews.categoryID>
						<cfset thisNewstitle=LOCAL.GetNews.categoryNameDerived>
						<cfset thisNewslink=LOCAL.GetNews.categoryAlias>
						<cfset thisPublishDate= LOCAL.GetNews.PublishDateTime>
						
						<cfinvoke component="com.Taxonomy.TopicHandler"
							method="GetRelatedTopics"
							EntityID="#Val(thisNewsID)#"
							EntityName="t_Category"
							returnvariable="LOCAL.getTopics">
						
						<cfset thisTopicIDs= ValueList(LOCAL.getTopics.TopicID)>
						<cfset thisTopicList= ValueList(LOCAL.getTopics.TopicName)>
	
						<cfset QuerySetCell(LOCAL.qryGetNews,"rowNumber",rowCount)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"newsID",thisNewsID)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"title",thisNewstitle)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"link",thisNewslink)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"publishDate",thisPublishDate)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"topicIDList",thisTopicIDs)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"Topics",thisTopicList)>
						
						<cfwddx action="WDDX2CFML" input="#LOCAL.GetNews.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
	
						<cfif StructKeyExists(sCategoryProperties,"CategoryImageRepresentative") AND Trim(sCategoryProperties.CategoryImageRepresentative) IS NOT "">
							<cfset ThisNewsImage=Trim(sCategoryProperties.CategoryImageRepresentative)>
						<cfelse>
							<cfset ThisNewsImage="">
						</cfif>
						<cfif StructKeyExists(sCategoryProperties,"MetaDescription") AND Trim(sCategoryProperties.MetaDescription) IS NOT "">
							<cfset ThisNewsDescription=Trim(sCategoryProperties.MetaDescription)>
						<cfelse>
							<cfset ThisNewsDescription="">
						</cfif>
						
						<cfif StructKeyExists(sCategoryProperties,"SubTitle") AND Trim(sCategoryProperties.SubTitle) IS NOT "">
							<cfset ThisNewsSubTitle=Trim(sCategoryProperties.SubTitle)>
						<cfelse>
							<cfset ThisNewsSubTitle="">
						</cfif>
											
						<cfif StructKeyExists(sCategoryProperties,"HomePageDisplay") AND Trim(sCategoryProperties.HomePageDisplay) eq 1>
							<cfset ThishomePageDisplayFlag=1>
						<cfelse>
							<cfset ThishomePageDisplayFlag=0>
						</cfif>
						
						<cfif StructKeyExists(sCategoryProperties,"EmergencyAlert") AND Trim(sCategoryProperties.EmergencyAlert) eq 1>
							<cfset ThisEmergencyAlert=1>
						<cfelse>
							<cfset ThisEmergencyAlert=0>
						</cfif>
						
						<cfset QuerySetCell(LOCAL.qryGetNews,"subTitle",ThisNewsSubTitle)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"headerImage",ThisNewsImage)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"homePageDisplayFlag",ThishomePageDisplayFlag)>
						<cfset QuerySetCell(LOCAL.qryGetNews,"EmergencyAlert",ThisEmergencyAlert)>
						
						<cfif ThisEmergencyAlert or ThisNewsDescription IS "">
							<cfquery name="LOCAL.GetFirstHTML" datasource="#APPLICATION.DSN#" maxrows="1">
								select ContentID from qry_GetContentLocaleMeta
								Where
								ContentPositionID=<cfqueryparam value="401" cfsqltype="CF_SQL_INTEGER">
								AND LocaleID=<cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
								AND ContentTypeID=<cfqueryparam value="221" cfsqltype="CF_SQL_INTEGER">
								AND ContentActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
								AND CategoryID=(<cfqueryparam value="#LOCAL.GetNews.CategoryID#" cfsqltype="cf_sql_integer" list="yes">)
								order by ContentLocalePriority
							</cfquery>
							<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
								<cfprocresult name="LOCAL.GetContent">
								<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(LOCAL.GetFirstHTML.ContentID)#" null="No">
								<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
								<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
							</cfstoredproc>
							<cfif IsWDDX(LOCAL.GetContent.ContentBody)>
								<cfwddx action="WDDX2CFML" input="#LOCAL.GetContent.ContentBody#" output="LOCAL.sContentBody">
								<cfif StructKeyExists(LOCAL.sContentBody,"HTML") and LOCAL.sContentBody.HTML is NOT "">
									<cfset ThisNewsDescription=LOCAL.sContentBody.HTML>
								</cfif>
							</cfif>
						</cfif>
						<cfset QuerySetCell(LOCAL.qryGetNews,"Description",ThisNewsDescription)>
					</cfif> 
				</cfloop>
			</cfif>
			<cfset REQUEST.GetAllNews=LOCAL.qryGetNews>
		<cfelse>
			<cfset LOCAL.qryGetNews=REQUEST.GetAllNews>
		</cfif>
		
		<cfreturn LOCAL.qryGetNews>
	</cffunction>
</cfcomponent>