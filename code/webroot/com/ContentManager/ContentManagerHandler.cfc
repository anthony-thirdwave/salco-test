<cfcomponent displayname="ContentManagerHandler" output="true">

	<cffunction name="init" returntype="ContentManagerHandler">
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="getFlattenedCategories" returntype="query" access="remote">
		<cfargument name="categoryId" required="true" type="string">
		<cfargument name="localeId" required="true" type="numeric">
		<cfargument name="getByParentId" required="false" type="boolean" default="false">
		
		<cfset var local = structNew()>
				
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
				<cfset local.cPPColumnName = local.j>
				<cfset local.cPPColumnValue = local.cPPproperties[local.j]>
				
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
		
		<cfset var local = structNew()>
		
		<cfset var getContents = "">
		<cfset var flattenedContents1 = "">
		<cfset var flattenedContents2 = "">
		<cfset var i = "">
		<cfset var columnName = "">
		<cfset var columnValue = "">
		<cfset var properties = "">
		
		<!--- get the content blocks based on args --->
		<cfstoredproc procedure="sp_GetContents" datasource="#APPLICATION.DSN#">
			<cfprocresult name="local.getContents">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#arguments.localeId#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#arguments.categoryId#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentPositionID" value="#arguments.contentPositionId#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="#arguments.contentActive#" null="No">
		</cfstoredproc>
		
		<!--- create a new query based on the old one --->
		<cfset local.flattenedContents1 = duplicate(local.getContents)>
		
		<!--- loop through the query to get the content body packet--->
		<cfloop query="local.getContents">
					
			<cfwddx action="wddx2cfml" input="#local.getContents.ContentBody#" output="local.properties">
			
			<cfloop index="local.i" list="#StructKeyList(local.properties)#" delimiters=",">
				<!--- set the column name and value --->
				<cfset local.columnName = local.i>
				<cfset local.columnValue = local.properties[local.i]>
				
				<!--- if the columnValue is not complex, then add it to the query --->				
				<cfif not isStruct(local.columnValue) AND not isArray(local.columnValue)>
				
					<!--- if the column doesn't exist, create it --->	
					<cfif not structKeyExists(local.flattenedContents1,local.columnName)>
						<cfset queryAddColumn(local.flattenedContents1,local.columnName,"varchar",arrayNew(1))>
					</cfif>
					<!--- set the cell value --->
					<cfset querySetCell(local.flattenedContents1,local.columnName,local.columnValue,local.getContents.currentrow)> 
				</cfif>
			</cfloop>		
		</cfloop>
		
		 <!--- create a new query based on the old one --->
		<cfset local.flattenedContents2 = duplicate(local.flattenedContents1)>
		
		<!--- do what we just did for the content body for the properties packet --->
		<cfloop query="local.flattenedContents1">
			
			<cfquery name="local.getProperties" datasource="#application.dsn#">
				SELECT propertiesPacket
				  FROM t_properties
				 WHERE propertiesId = <cfqueryparam value="#local.flattenedContents1.contentPropertiesId#"  cfsqltype="cf_sql_integer"/>
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
				
			<cfwddx action="wddx2cfml" input="#local.getProperties.propertiesPacket#" output="local.properties">
			
			<cfloop index="local.i" list="#StructKeyList(local.properties)#" delimiters=",">
				<!--- set the column name and value --->
				<cfset local.columnName = local.i>
				<cfset local.columnValue = local.properties[local.i]>
								
				<!--- if the column doesn't exist, create it --->	
				<cfif not structKeyExists(local.flattenedContents2,local.columnName)>
					<cfset queryAddColumn(local.flattenedContents2,local.columnName,"varchar",arrayNew(1))>
				</cfif>
				<!--- set the cell value --->
				<cfset querySetCell(local.flattenedContents2,local.columnName,local.columnValue,local.flattenedContents1.currentrow)> 
				
			</cfloop>
		</cfloop>		
		
		<!--- apply any ordering --->
		<cfquery name="local.getFlattenedContentBlocks" dbtype="query">
			SELECT *
			  FROM [local].flattenedContents2
		  <cfif len(arguments.sortColumn) GT 0>
		  ORDER BY #arguments.sortColumn# #arguments.sortOrder#
		  </cfif> 
		</cfquery>
			
		
		<cfreturn local.getFlattenedContentBlocks>
	
	</cffunction>


	<!--- generates the sitemap.xml file --->
	<cffunction name="create_sitemap_xml">
		
		<cfset var local = structNew() />
		
		<cfquery name="local.GetDisplayOrder" datasource="#APPLICATION.DSN#">
			SELECT	DisplayOrder 
			FROM	t_Category 
			WHERE	CategoryID = 1
		</cfquery>
		
		<cfset local.myArray = ArrayNew(1)>
		<cfset local.myDoc = xmlNew() />
		
		<cfinvoke method="sitemap_help_xml" URL_array="#local.myArray#" returnvariable="local.array_to_xml"/>	
		
		<cfset local.myDoc.xmlRoot = xmlElemNew(local.myDoc, "urlset") />
		<cfset local.myDoc.xmlRoot.xmlAttributes["xmlns"] = "http://www.sitemaps.org/schemas/sitemap/0.9" />
		
		<cfloop from="1" to="#ArrayLen(local.array_to_xml)#" index="local.j">
			
			<cfset local.URL1 = xmlElemNew(local.myDoc, "url") />
			
			<cfset local.loc = xmlElemNew(local.myDoc, "loc") />
			<cfset local.loc.xmlText = "#local.array_to_xml[local.j].url#" />

			<cfset local.priority = xmlElemNew(local.myDoc, "priority") />
			<cfset local.priority.xmlText = "#round(DecimalFormat(1/local.array_to_xml[local.j].priority) * 10)/10#" />

			<cfset local.lastmod = xmlElemNew(local.myDoc, "lastmod") />
			<cfset local.lastmod.xmlText = dateFormat(now(), "yyyy-mm-dd") />
			
			<cfset local.changefreq = xmlElemNew(local.myDoc, "changefreq") />
			<cfset local.changefreq.xmlText = "weekly" />
			
			
			<cfset arrayAppend(local.URL1.xmlChildren, local.loc) />
			<cfset arrayAppend(local.URL1.xmlChildren, local.priority) />
			<cfset arrayAppend(local.URL1.xmlChildren, local.lastmod) />
			<cfset arrayAppend(local.URL1.xmlChildren, local.changefreq) />
			
			<cfset arrayAppend(local.myDoc.xmlRoot.xmlChildren, local.URL1) /> 

		</cfloop>
		
		<cffile action="write"  file="#application.webrootpath#\sitemap.xml" output="#toString(local.mydoc)#">
		
	</cffunction>
	
	
	
	
	
	<!--- determines how and if a link should be added to sitemap.xml --->
	<cffunction name="sitemap_help_xml">
		<cfargument name="ThisCategoryID" default="1">
		<cfargument name="rank" default="1">
		<cfargument name="URL_array" type="array">

		<cfset var local = structNew() />
	
		<cfstoredproc procedure="sp_GetPage" datasource="#APPLICATION.DSN#">
			<cfprocresult name="local.getdetail" maxrows="1">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="CategoryID" value="#Val(arguments.ThisCategoryID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="categoryActiveDerived" value="1" null="No">
		</cfstoredproc>
		
		<cfif local.getdetail.CategoryActiveDerived IS "1" AND arguments.ThisCategoryID neq 1>
		
			<!--- This is used to keep track of how important the page is higher rank = more important--->
			<cfset arguments.rank = arguments.rank + 1>
			
			<!--- if the categoryURLDerived is not empty, make sure it's a root relative link - sitemap.xml can't have links
			to other hosts --->
			<cfif len(trim(local.getdetail.CategoryURLDerived)) and not isValid("url", local.getdetail.CategoryURLDerived)>
			
				<cfset local.sitemap_info.url = "http://#CGI.HTTP_HOST##local.getDetail.CategoryURL#">
				
				<cfif findNoCase("/home", local.sitemap_info.url) neq 0>
					<cfset local.sitemap_info.priority = 1>
				<cfelse>	
					<cfset local.sitemap_info.priority = arguments.rank>
				</cfif>
				
				<cfset arrayAppend(arguments.URL_array, duplicate(local.sitemap_info))>
			<cfelseif not len(trim(local.getdetail.CategoryURLDerived))>
				<cfset local.sitemap_info.url = "http://#CGI.HTTP_HOST##APPLICATION.contentPageInUrl#/#local.GetDetail.CategoryAlias#">
				
				<cfif findNoCase("/home", local.sitemap_info.url) neq 0>
					<cfset local.sitemap_info.priority = 1>
				<cfelse>	
					<cfset local.sitemap_info.priority = arguments.rank>
				</cfif>

				<cfset arrayAppend(arguments.URL_array, duplicate(local.sitemap_info))>
			</cfif>
			
		</cfif>
		
		
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="local.getCategoryList">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#arguments.ThisCategoryID#" null="NO">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="#APPLICATION.lVisibleCategoryTypeID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="no">
		</cfstoredproc>
		
		
		<cfif local.getCategoryList.recordcount gt "0">
			<cfloop query="local.getCategoryList">
				<cfinvoke method="sitemap_help_xml" ThisCategoryID="#local.getCategoryList.CategoryID#" URL_array="#arguments.URL_array#" rank="#arguments.rank#" returnvariable="arguments.URL_array"> 	
			</cfloop>	
		</cfif>
		
		<cfreturn arguments.URL_array>
	</cffunction>
</cfcomponent>