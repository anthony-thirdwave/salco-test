<cfcomponent displayname="BlogHandler" output="true">
	
	<cffunction name="init" returntype="BlogHandler" output="false">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="GetBlogEntriesByTopic" output="false" returntype="query">
		<cfargument name="BlogID" default="" type="numeric" required="true">
		<cfargument name="TopicAlias" default="" type="string" required="false">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="LOCAL.GetRoot" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ARGUMENTS.BlogID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
		</cfstoredproc>
		
		<cfquery name="LOCAL.GetBlogEntriesByTopic" datasource="#APPLICATION.DSN#">
			SELECT	t_TopicRelated.TopicID, t_Category_1.CategoryName AS TopicName, t_Category_1.CategoryAlias AS TopicAlias, t_TopicRelated.EntityID, 
					t_TopicRelated.EntityName, t_Category_2.CategoryID, t_Category_2.CategoryName, t_Category_2.CategoryAlias, t_Category_2.DisplayLevel, 
					t_Category_2.DisplayOrder, t_Category_2.CategoryActive, t_Category_1.DisplayOrder AS TopicDisplayOrder, t_Category_2.CategoryTypeID
			FROM    t_Category AS t_Category_1 RIGHT OUTER JOIN
					t_TopicRelated ON t_Category_1.CategoryID = t_TopicRelated.TopicID RIGHT OUTER JOIN
					t_Category AS t_Category_2 ON t_TopicRelated.EntityID = t_Category_2.CategoryID AND 
					t_TopicRelated.EntityName = <cfqueryparam value="t_category" cfsqltype="CF_SQL_VARCHAR"> AND 
					t_Category_2.CategoryTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="77">
			WHERE 	
					t_Category_2.DisplayOrder like <cfqueryparam value="#LOCAL.GetRoot.DisplayOrder#%" cfsqltype="CF_SQL_VARCHAR"> AND
					t_Category_2.CategoryActive=<cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
					t_Category_2.CategoryTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="77">
			<cfif ARGUMENTS.TopicAlias IS NOT "">
				And t_Category_1.CategoryAlias=<cfqueryparam value="#ARGUMENTS.TopicAlias#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			ORDER BY
					TopicDisplayOrder
		</cfquery>
		<cfreturn LOCAL.GetBlogEntriesByTopic>
	</cffunction>
	
	<cffunction name="GetBlogEntries" output="false" returntype="query">
		<cfargument name="BlogID" default="" type="numeric" required="true">
		<cfargument name="month" default="0" type="numeric" required="false">
		<cfargument name="year" default="0" type="numeric" required="false">
		<cfargument name="TopicAlias" default="" type="string" required="false">
		<cfargument name="Quick" default="No" type="boolean" required="false">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="LOCAL.GetRoot" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ARGUMENTS.BlogID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
		</cfstoredproc>
		
		<cfif ARGUMENTS.TopicAlias IS NOT "">
			<cfinvoke component="com.ContentManager.BlogHandler" method="GetBlogEntriesByTopic" returnVariable="LOCAL.qGetBlogEntriesByTopic">
				<cfinvokeargument name="BlogID" value="#ARGUMENTS.BlogID#">
				<cfinvokeargument name="TopicAlias" value="#ARGUMENTS.TopicAlias#">
			</cfinvoke>
		</cfif>
		
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="LOCAL.GetThesePagesPrime">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="displayOrder" value="#LOCAL.GetRoot.DisplayOrder#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfif ARGUMENTS.TopicAlias IS NOT "" and LOCAL.qGetBlogEntriesByTopic.RecordCount GT "0">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="#ValueList(LOCAL.qGetBlogEntriesByTopic.CategoryID)#" null="No">
			<cfelse>
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			</cfif>
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="77" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
		</cfstoredproc>
		
		<cfquery name="LOCAL.GetThesePages" dbtype="query">
			select *, '' as Link, '' as Thumbnail, '' as Abstract, '' as Author, '' as GroupDate, '' as CallToAction, '' as Topic
			from [LOCAL].GetThesePagesPrime 
			<cfif Isdate("#Val(ARGUMENTS.Month)#/1/#Val(ARGUMENTS.Year)#")>
				<cfset ThisDate=CreateDate(Val(ARGUMENTS.Year),Val(ARGUMENTS.Month),1)>
				where PublishDateTime>=<cfqueryparam value="#ThisDate#" cfsqltype="CF_SQL_DATE">
				AND   PublishDateTime<<cfqueryparam value="#DateAdd('m','1',ThisDate)#" cfsqltype="CF_SQL_DATE">
			</cfif>
			order by PublishDateTime Desc
		</cfquery>
		
		<cfoutput query="LOCAL.GetThesePages">
			<cfif Trim(LOCAL.GetThesePages.CategoryURL) IS "">
				<cfset LOCAL.ThisURL="#APPLICATION.utilsObj.parseCategoryUrl(LOCAL.GetThesePages.CategoryAlias)#">
			<cfelse>
				<cfset LOCAL.ThisURL="#LOCAL.GetThesePages.CategoryURL#">
			</cfif>
			<cfset LOCAL.ThisImage="">
			<cfset LOCAL.ThisAbstract="">
			<cfset LOCAL.ThisAuthor="">
			<cfset LOCAL.ThisCallToAction="">
			<cfset LOCAL.ThisTopic="">
			<cfif IsWDDX(LOCAL.GetThesePages.CategoryLocalePropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#LOCAL.GetThesePages.CategoryLocalePropertiesPacket#" output="LOCAL.sCategoryProperties">
				<cfif StructKeyExists(LOCAL.sCategoryProperties,"CategoryImageRepresentative") AND Trim(StructFind(LOCAL.sCategoryProperties,"CategoryImageRepresentative")) IS NOT "">
					<cfset LOCAL.ThisImage=StructFind(LOCAL.sCategoryProperties,"CategoryImageRepresentative")>
				</cfif>
				<cfif StructKeyExists(LOCAL.sCategoryProperties,"MetaDescription") AND Trim(StructFind(LOCAL.sCategoryProperties,"MetaDescription")) IS NOT "">
					<cfset LOCAL.ThisAbstract=StructFind(LOCAL.sCategoryProperties,"MetaDescription")>
				</cfif>
				<cfif StructKeyExists(LOCAL.sCategoryProperties,"CallToAction") AND Trim(StructFind(LOCAL.sCategoryProperties,"CallToAction")) IS NOT "">
					<cfset LOCAL.ThisCallToAction=StructFind(LOCAL.sCategoryProperties,"CallToAction")>
				</cfif>
			</cfif>
			<cfif NOT ARGUMENTS.Quick>
				<cfquery name="LOCAL.GetCatProps" datasource="#APPLICATION.DSN#">
					select PropertiesPacket from t_Properties
					WHERE PropertiesID=<cfqueryparam value="#Val(LOCAL.GetThesePages.CategoryPropertiesID)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
				<cfif IsWDDX(LOCAL.GetCatProps.PropertiesPacket)>
					<cfwddx action="WDDX2CFML" input="#LOCAL.GetCatProps.PropertiesPacket#" output="LOCAL.sProperties">
					<cfif StructKeyExists(LOCAL.sProperties,"AuthorName") AND Trim(LOCAL.sProperties.AuthorName) IS NOT "">
						<cfset LOCAL.ThisAuthor=LOCAL.sProperties.AuthorName>
					</cfif>
				</cfif>
			</cfif>
			<cfset QuerySetCell(LOCAL.GetThesePages,"Link",LOCAL.ThisURL,CurrentRow)>
			<cfset QuerySetCell(LOCAL.GetThesePages,"Thumbnail",LOCAL.ThisImage,CurrentRow)>
			<cfif LOCAL.ThisAbstract IS "" and NOT ARGUMENTS.Quick>
				<cfquery name="LOCAL.GetFirstHTML" datasource="#APPLICATION.DSN#" maxrows="1">
					select ContentID from qry_GetContentLocaleMeta
					Where
					ContentPositionID=<cfqueryparam value="401" cfsqltype="CF_SQL_INTEGER">
					AND LocaleID=<cfqueryparam value="#APPLICATION.LocaleID#" cfsqltype="CF_SQL_INTEGER">
					AND ContentTypeID=<cfqueryparam value="201" cfsqltype="CF_SQL_INTEGER">
					AND ContentActive=<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER">
					AND CategoryID=(<cfqueryparam value="#LOCAL.GetThesePages.CategoryID#" cfsqltype="cf_sql_integer" list="yes">)
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
						<cfif findNoCase(chr(10),LOCAL.sContentBody.HTML) GT "0">
							<cfset ThisAbstract=left(LOCAL.sContentBody.HTML,findNoCase(chr(10),LOCAL.sContentBody.HTML))>
						<cfelse>
							<cfset ThisAbstract=LOCAL.sContentBody.HTML>
						</cfif>
						<cfset QuerySetCell(LOCAL.GetThesePages,"Abstract",application.utilsObj.RemoveHTML(LOCAL.ThisAbstract),CurrentRow)>
					</cfif>
				</cfif>
			<cfelse>
				<cfset QuerySetCell(LOCAL.GetThesePages,"Abstract",LOCAL.ThisAbstract,CurrentRow)>
			</cfif>
			
			<cfset QuerySetCell(LOCAL.GetThesePages,"Author",LOCAL.ThisAuthor,CurrentRow)>
			<cfif LOCAL.ThisCallToAction IS "">
				<cfset QuerySetCell(LOCAL.GetThesePages,"CallToAction","Read More...",CurrentRow)>
			<cfelse>
				<cfset QuerySetCell(LOCAL.GetThesePages,"CallToAction",LOCAL.ThisCallToAction,CurrentRow)>
			</cfif>
			<cfset QuerySetCell(LOCAL.GetThesePages,"GroupDate",CreateDate(year(LOCAL.GetThesePages.PublishDateTime),month(LOCAL.GetThesePages.PublishDateTime),1),CurrentRow)>
			
			<cfinvoke component="com.Taxonomy.TopicHandler"
				method="GetRelatedTopics"
				EntityID="#Val(LOCAL.GetThesePages.CategoryID)#"
				EntityName="t_Category"
				returnvariable="LOCAL.getTopics">
			<cfset QuerySetCell(LOCAL.GetThesePages,"Topic",ValueList(LOCAL.getTopics.TopicName),CurrentRow)>
		</cfoutput>
		
		<cfreturn LOCAL.GetThesePages>	
	</cffunction>
</cfcomponent>