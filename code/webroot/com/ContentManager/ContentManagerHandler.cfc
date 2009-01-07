<cfcomponent displayname="ContentManagerHandler" output="true">

	<cffunction name="init" returntype="ContentManagerHandler">
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="getFlattenedCategories" returntype="query" access="remote">
		<cfargument name="categoryId" required="true" type="string">
		<cfargument name="localeId" required="true" type="numeric">
		<cfargument name="getByParentId" required="false" type="boolean" default="false">
		
		<cfset var local = structNew()>
				
		<cfset local.getCategories = "">
		<cfset local.flattenedCategories = "">
		<cfset local.i = "">
		<cfset local.cLPPColumnName = "">
		<cfset local.cLPPColumnValue = "">
		<cfset local.cLPPproperties = "">
		<cfset local.j = "">
		<cfset local.cPPcolumnName = "">
		<cfset local.cPPcolumnValue = "">
		<cfset local.cPPproperties = "">
				
		<cfif arguments.getByParentId>
		
			<cfquery name="local.getCategories" datasource="#application.dsn#">
				SELECT *
				  FROM qry_getCategoryWithCategoryLocale
				 WHERE parentId = <cfqueryparam value="#val(arguments.categoryId)#"  cfsqltype="cf_sql_integer"/>
	     		   AND localeId = <cfqueryparam value="#arguments.localeId#"  cfsqltype="cf_sql_integer"/>
	          ORDER BY displayOrder ASC			  
			</cfquery>
		
		<cfelse>
		
			<cfquery name="local.getCategories" datasource="#application.dsn#">
				SELECT *
				  FROM qry_getCategoryWithCategoryLocale
				 WHERE categoryId IN (<cfqueryparam value="#arguments.categoryId#" list="true" cfsqltype="cf_sql_integer"/>)
	     		   AND localeId = <cfqueryparam value="#arguments.localeId#"  cfsqltype="cf_sql_integer"/>
	     	</cfquery>
	     	
		</cfif>
		
		
		<!--- create a new query based on the old one --->
		<cfset local.flattenedCategories = duplicate(local.getCategories)>
		
		<!--- loop through the query to get the CATEGORYLOCALEPROPERTIESPACKET, CATEGORYPROPERTIESPACKET packets--->
		<cfloop query="local.getCategories">
					
			<cfwddx action="wddx2cfml" input="#local.getCategories.categoryLocalePropertiesPacket#" output="local.cLPPproperties">
			
			<cfloop index="local.i" list="#StructKeyList(local.cLPPproperties)#" delimiters=",">
				<!--- set the column name and value --->
				<cfset local.cLPPColumnName = local.i>
				<cfset local.cLPPColumnValue = local.cLPPproperties[local.i]>
				
				<!--- if the columnValue is not complex, then add it to the query --->				
				<cfif not isStruct(local.cLPPColumnValue) AND not isArray(local.cLPPColumnValue)>
				
					<!--- if the column doesn't exist, create it --->	
					<cfif not structKeyExists(local.flattenedCategories,local.cLPPColumnName)>
						<cfset queryAddColumn(local.flattenedCategories,local.cLPPColumnName,"varchar",arrayNew(1))>
					</cfif>
					<!--- set the cell value --->
					<cfset querySetCell(local.flattenedCategories,local.cLPPColumnName,local.cLPPColumnValue,local.getCategories.currentrow)> 
				
				</cfif>
				
			</cfloop>	
			
			<cfwddx action="wddx2cfml" input="#local.getCategories.categoryPropertiesPacket#" output="local.cPPproperties">
			
			<cfloop index="local.j" list="#StructKeyList(local.cPPproperties)#" delimiters=",">
				<!--- set the column name and value --->
				<cfset cPPColumnName = local.j>
				<cfset cPPColumnValue = local.cPPproperties[local.j]>
				
				<!--- if the columnValue is not complex, then add it to the query --->				
				<cfif not isStruct(local.cPPColumnValue) AND not isArray(local.cPPColumnValue)>
				
					<!--- if the column doesn't exist, create it --->	
					<cfif not structKeyExists(local.flattenedCategories,local.cPPColumnName)>
						<cfset queryAddColumn(local.flattenedCategories,local.cPPColumnName,"varchar",arrayNew(1))>
					</cfif>
					<!--- set the cell value --->
					<cfset querySetCell(local.flattenedCategories,local.cPPColumnName,local.cPPColumnValue,local.getCategories.currentrow)> 
				
				</cfif>
				
			</cfloop>		
			
			
		</cfloop>		
		
		
		<cfif arguments.getByParentId >
		
			<cfreturn local.flattenedCategories>
			
		<!--- need to return this ordered by the list of categoryId arg --->	
		<cfelse>
			<cfset local.flattenedCategoriesSorted = queryNew("#local.getCategories.columnlist#")>
			
			
			<cfset local.counter = 1>		
			<cfloop list="#arguments.categoryId#" delimiters="," index="local.k">
				<cfquery name="local.getCategoryById" dbtype="query">
					SELECT *
					  FROM [local].flattenedCategories
				     WHERE categoryId = <cfqueryparam value="#local.k#"  cfsqltype="cf_sql_integer"/>
				</cfquery>
				
				<cfset queryAddRow(local.flattenedCategoriesSorted,1)>
			
				<cfloop list="#local.getCategoryById.columnlist#" delimiters="," index="local.l">
					<cfif not structKeyExists(local.flattenedCategoriesSorted,local.l)>
						<cfset queryAddColumn(local.flattenedCategoriesSorted,local.l,"varchar",arrayNew(1))>
					</cfif>
															
					<cfset querySetCell(local.flattenedCategoriesSorted,local.l,evaluate("local.getCategoryById.#local.l#"))>
				</cfloop>				
			</cfloop>
			
			<cfreturn local.flattenedCategoriesSorted>
		
		</cfif>
	
	</cffunction>
	
		
	<cffunction name="getFlattenedContents" returntype="query" access="remote">
		<cfargument name="categoryId" required="true" type="numeric">
		<cfargument name="contentPositionId" required="true" type="string">
		<cfargument name="localeId" required="true" type="numeric">
		<cfargument name="contentActive" required="false" default="1" type="string">
		<cfargument name="sortColumn" required="false" default="">
		<cfargument name="sortOrder" required="false" default="ASC">
		
		<cfset var getContents = "">
		<cfset var flattenedContents1 = "">
		<cfset var flattenedContents2 = "">
		<cfset var i = "">
		<cfset var columnName = "">
		<cfset var columnValue = "">
		<cfset var properties = "">
		<cfset var getFlattenedContentBlocks = "">
		
		<!--- get the content blocks based on args --->
		<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
			<cfprocresult name="getContents">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#arguments.localeId#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#arguments.categoryId#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="#arguments.contentPositionId#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="#arguments.contentActive#" null="No">
		</cfstoredproc>
		
		<!---<cfdump var="#getContents#">--->
		
		<!--- create a new query based on the old one --->
		<cfset flattenedContents1 = duplicate(getContents)>
		
		<!--- loop through the query to get the content body packet--->
		<cfloop query="getContents">
					
			<cfwddx action="wddx2cfml" input="#getContents.ContentBody#" output="properties">
			
			<cfloop index="i" list="#StructKeyList(properties)#" delimiters=",">
				<!--- set the column name and value --->
				<cfset columnName = i>
				<cfset columnValue = properties[i]>
				
				<!--- if the columnValue is not complex, then add it to the query --->				
				<cfif not isStruct(columnValue) AND not isArray(columnValue)>
				
					<!--- if the column doesn't exist, create it --->	
					<cfif not structKeyExists(flattenedContents1,columnName)>
						<cfset queryAddColumn(flattenedContents1,columnName,"varchar",arrayNew(1))>
					</cfif>
					<!--- set the cell value --->
					<cfset querySetCell(flattenedContents1,columnName,columnValue,getContents.currentrow)> 
				
				</cfif>
				
			</cfloop>		
			
			
		</cfloop>
		
		 <!--- create a new query based on the old one --->
		<cfset flattenedContents2 = duplicate(flattenedContents1)>
		
		<!--- do what we just did for the content body for the properties packet --->
		<cfloop query="flattenedContents1">
			
			<cfquery name="getProperties" datasource="#application.dsn#">
				SELECT propertiesPacket
				  FROM t_properties
				 WHERE propertiesId = <cfqueryparam value="#flattenedContents1.contentPropertiesId#"  cfsqltype="cf_sql_integer"/>
			</cfquery>
			
			<!--- 
				just for debugging, not needed in the production query, since it will be flattened
			<cfif not structKeyExists(flattenedContents2,"PropertiesPacket")>
				<cfset queryAddColumn(flattenedContents2,"PropertiesPacket","varchar",arrayNew(1))>
			</cfif>
			<!--- set the cell value --->
			<cfset querySetCell(flattenedContents2,"PropertiesPacket","#getProperties.propertiesPacket#",flattenedContents1.currentrow)> 
			<!--- end of debugging --->
			 --->
				
			<cfwddx action="wddx2cfml" input="#getProperties.propertiesPacket#" output="properties">
			
			<cfloop index="i" list="#StructKeyList(properties)#" delimiters=",">
				<!--- set the column name and value --->
				<cfset columnName = i>
				<cfset columnValue = properties[i]>
								
				<!--- if the column doesn't exist, create it --->	
				<cfif not structKeyExists(flattenedContents2,columnName)>
					<cfset queryAddColumn(flattenedContents2,columnName,"varchar",arrayNew(1))>
				</cfif>
				<!--- set the cell value --->
				<cfset querySetCell(flattenedContents2,columnName,columnValue,flattenedContents1.currentrow)> 
				
			</cfloop>		
		
		</cfloop>		
		
		<!--- apply any ordering --->
		<cfquery name="getFlattenedContentBlocks" dbtype="query">
			SELECT *
			  FROM flattenedContents2
		  <cfif len(arguments.sortColumn) GT 0>
		  ORDER BY #arguments.sortColumn# #arguments.sortOrder#
		  </cfif> 
		</cfquery>
			
		
		<cfreturn getFlattenedContentBlocks>
	
	</cffunction>


	<cffunction name="create_sitemap_xml">
		
		<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
			select DisplayOrder from t_Category Where CategoryID=1
		</cfquery>
		
		<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT     MAX(CacheDateTime) AS CacheDateTime
			FROM         t_Category
			WHERE     DisplayOrder like '#GetDisplayOrder.DisplayOrder#%'
		</cfquery>
		
		<!--- <CFSET ExecuteTempFile="#APPLICATION.LocaleID#\+SiteMap_#ATTRIBUTES.SiteCategoryID#_#APPLICATION.LocaleID#_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#.cfm"> --->
		
		<cfset myArray = ArrayNew(1)>
		<cfset myDoc = xmlNew() />
		
		<cfinvoke method="sitemap_help_xml" URL_array="#myArray#" returnvariable="array_to_xml"/>	
		
		<cfset myDoc.xmlRoot = xmlElemNew(myDoc, "Urlset") />
		
		<cfloop from="1" to="#ArrayLen(array_to_xml)#" index="j">
			
			<cfset URL1 = xmlElemNew(myDoc, "URL") />
			
			<cfset loc = xmlElemNew(myDoc, "loc") />
			<cfset loc.xmlText = "#array_to_xml[j].url#" />

			<cfset priority = xmlElemNew(myDoc, "priority") />
			<cfset priority.xmlText = "#round(DecimalFormat(1/array_to_xml[j].priority) * 10)/10#" />

			<cfset lastmod = xmlElemNew(myDoc, "lastmod") />
			<cfset lastmod.xmlText = #DateFormat(now(), "yyyy-mm-dd")# />
			
			<cfset changefreq = xmlElemNew(myDoc, "changefreq") />
			<cfset changefreq.xmlText = "weekly" />
			
			
			<cfset arrayAppend(URL1.xmlChildren, loc) />
			<cfset arrayAppend(URL1.xmlChildren, priority) />
			<cfset arrayAppend(URL1.xmlChildren, lastmod) />
			<cfset arrayAppend(URL1.xmlChildren, changefreq) />
			
			<cfset arrayAppend(myDoc.xmlRoot.xmlChildren, URL1) /> 

		</cfloop>
		
		 <cffile action="write"  file="#application.webrootpath#\sitemap.xml" output="#ToString(mydoc)#">
		
	</cffunction>
	
	<cffunction name="sitemap_help_xml">
		<cfargument name="ThisCategoryID" default="1">
		<cfargument name="rank" default="1">
		<cfargument name="URL_array" type="array">
	
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="getdetail" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(ThisCategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
		</cfstoredproc>
		
		<cfif getdetail.CategoryActiveDerived IS "1" AND ThisCategoryID neq 1>
		
			<!--- This is used to keep track of how important the page is higher rank = more important--->
			<cfset arguments.rank = arguments.rank + 1>
			
			<cfif Trim(getdetail.CategoryURLDerived) iS NOT "">
				<cfset sitemap_info.url = "http://#REQUEST.CGIHTTPHost##GetDetail.CategoryURL#">
				
				<cfif find("/home", sitemap_info.url) neq 0>
					<cfset sitemap_info.priority = 1>
				<cfelse>	
					<cfset sitemap_info.priority = arguments.rank>
				</cfif>
				
				<cfset #ArrayAppend(arguments.URL_array, duplicate(sitemap_info))#>
					<!--- <URL><loc>/#GetDetail.CategoryURL#</loc></URL> --->
			<cfelse>
				<cfset sitemap_info.url = "http://#REQUEST.CGIHTTPHost#/content.cfm/#GetDetail.CategoryAlias#">
				
				<cfif find("/home", sitemap_info.url) neq 0>
					<cfset sitemap_info.priority = 1>
				<cfelse>	
					<cfset sitemap_info.priority = arguments.rank>
				</cfif>

				<cfset #ArrayAppend(arguments.URL_array, duplicate(sitemap_info))#>
					<!--- <URL><loc>/content.cfm/#GetDetail.CategoryAlias#</loc></URL> --->
			</cfif>
			
		</cfif>
		
		
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="GetcategoryList">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ThisCategoryID#" null="NO">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="no">
		</cfstoredproc>
		
		
		<cfif GetcategoryList.recordcount GT "0">
			<cfloop query="GetcategoryList">
				<cfinvoke method="sitemap_help_xml" ThisCategoryID="#CategoryID#" URL_array="#arguments.URL_array#" rank="#arguments.rank#" returnvariable="arguments.URL_array"> 	
			</cfloop>	
		</cfif>
		
		<cfreturn arguments.URL_array>
	</cffunction>
</cfcomponent>