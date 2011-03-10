<cfcomponent>
	<cffunction name="GetProductFamilyAttributeStructure" output="false" returntype="struct">
		<cfargument name="CategoryID" default="" type="numeric" required="true">
		<cfargument name="LanguageID" default="" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfset LOCAL.sReturn=StructNew()>
		<cfquery name="LOCAL.Get" datasource="#APPLICATION.DSN#">
			SELECT ProductFamilyAttributeID, ProductFamilyAttributeName,LanguageID FROM qry_GetProductFamilyAttribute 
			WHERE 
			CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and 
			LanguageID=<cfqueryparam value="#Val(ARGUMENTS.LanguageID)#" cfsqltype="cf_sql_integer">
			order by ProductFamilyAttributeID,LanguageID DESC
		</cfquery>
		<!--- In the query get english (100) last.  --->
		<cfoutput query="LOCAL.Get" group="ProductFamilyAttributeID">
			<cfset LOCAL.ThisName="">
			<cfoutput group="LanguageID">
				<cfif LOCAL.Get.ProductFamilyAttributeName IS NOT "" and LOCAL.ThisName IS "">
					<cfset LOCAL.ThisName=LOCAL.Get.ProductFamilyAttributeName>
				</cfif>
			</cfoutput>
			<cfset StructInsert(LOCAL.sReturn,LOCAL.Get.ProductFamilyAttributeID,LOCAL.ThisName)>
		</cfoutput>
		<cfreturn LOCAL.sReturn>
	</cffunction>
	
	<cffunction name="GetDefaultLanguageID" output="false" returntype="numeric">
		<cfargument name="LocaleID" default="" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.test" datasource="#APPLICATION.DSN#">
			SELECT	t_Locale.LanguageID AS LanguageID
			FROM	t_Locale 
			WHERE	LocaleID=<cfqueryparam value="#Val(ARGUMENTS.LocaleID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif LOCAL.test.RecordCount IS NOT "0">
			<cfreturn LOCAL.test.LanguageID>
		<cfelse>
			<cfreturn APPLICATION.DefaultLanguageID>
		</cfif>
	</cffunction>
	
	<cffunction name="GetProductFamilyLanguages" returntype="query" output="false">
		<cfargument name="CategoryID" default="" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="LOCAL.GetLanguages" datasource="#APPLICATION.DSN#">
			select LabelID as LanguageID, LabelName as LanguageName from 
			dbo.t_Label INNER JOIN
			dbo.t_ProductAttribute ON dbo.t_Label.LabelID = dbo.t_ProductAttribute.LanguageID
			Where 
			CategoryID=<cfqueryparam value="#Val(ARGUMENTS.CategoryID)#" cfsqltype="cf_sql_integer"> and 
			ProductFamilyAttributeID=<cfqueryparam value="515" cfsqltype="cf_sql_integer">
			order by LanguageName
		</cfquery>
		<cfreturn LOCAL.GetLanguages>
	</cffunction>
	
	<cffunction name="GetProductListBasic" returntype="query" output="false">
		<cfargument name="ProductFamilyID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="#APPLICATION.LocaleID#" type="numeric" required="true">
		<cfargument name="LanguageID" default="#APPLICATION.LanguageID#" type="numeric" required="true">
		<cfargument name="StartRow" type="numeric">
		<cfargument name="MaxRows" type="numeric">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfif APPLICATION.GetAllLocale.RecordCount GT "1">
			<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
				<cfprocresult name="LOCAL.GetProductListPrime">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(ARGUMENTS.LocaleID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(ARGUMENTS.ProductFamilyID)#" null="NO">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="64" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="1" null="No">
			</cfstoredproc>
		<cfelse>
			<cfquery name="LOCAL.GetProductListPrime" datasource="#APPLICATION.DSN#">
				select *, CategoryName as CategoryNameDerived from t_Category
				where ParentID=<cfqueryparam value="#val(ARGUMENTS.ProductFamilyID)#" cfsqltype="cf_sql_integer"> AND
				CategoryTypeID=<cfqueryparam value="64" cfsqltype="cf_sql_integer"> AND
				CategoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer"> AND
				ShowInNavigation=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		
		<cfset SetVariable("REQUEST.GetProductListPrime_#Val(ARGUMENTS.ProductFamilyID)#_#val(ARGUMENTS.LocaleID)#",LOCAL.GetProductListPrime)>
		
		<cfreturn LOCAL.GetProductListPrime>
	</cffunction>
	
	<cffunction name="GetProductList" returntype="query" output="false">
		<cfargument name="ProductFamilyID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="#APPLICATION.LocaleID#" type="numeric" required="true">
		<cfargument name="LanguageID" default="#APPLICATION.LanguageID#" type="numeric" required="true">
		<cfargument name="StartRow" type="numeric">
		<cfargument name="MaxRows" type="numeric">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfif IsDefined("REQUEST.GetProductListPrime_#Val(ARGUMENTS.ProductFamilyID)#_#val(ARGUMENTS.LocaleID)#")>
			<cfset SetVariable("LOCAL.GetProductListPrime",Evaluate("REQUEST.GetProductListPrime_#Val(ARGUMENTS.ProductFamilyID)#_#val(ARGUMENTS.LocaleID)#"))>
		<cfelse>
			<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
				<cfprocresult name="LOCAL.GetProductListPrime">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(ARGUMENTS.LocaleID)#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(ARGUMENTS.ProductFamilyID)#" null="NO">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="64" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
			</cfstoredproc>
		</cfif>
		
		<cfset LOCAL.lCategoryID="">
		<cfoutput query="LOCAL.GetProductListPrime">
			<cfset LOCAL.lCategoryID=ListAppend(LOCAL.lCategoryID,LOCAL.GetProductListPrime.CategoryID)>
		</cfoutput>
		
		<cfquery name="LOCAL.GetProductList" dbtype="query">
			select * from [LOCAL].GetProductListPrime
			order by CategoryID
		</cfquery>
		
		<cfif IsDefined("ARGUMENTS.StartRow") and Val(ARGUMENTS.StartRow) GT "0" and IsDefined("ARGUMENTS.MaxRows") and Val(ARGUMENTS.MaxRows) GT "0" AND Val(ARGUMENTS.StartRow) LTE LOCAL.GetProductListPrime.RecordCount>
			<cfset LOCAL.ThisLCategoryID="">
			<cfloop index="LOCAL.i" from="#ARGUMENTS.StartRow#" to="#ARGUMENTS.StartRow+ARGUMENTS.MaxRows-1#" step="1">
				<cfif LOCAL.i LTE GetProductListPrime.RecordCount>
					<cfset LOCAL.ThisLCategoryID=ListAppend(ThisLCategoryID,ListGetAt(LOCAL.lCategoryID,LOCAL.i))>
				</cfif>
			</cfloop>
			<cfset LOCAL.lCategoryID=LOCAL.ThisLCategoryID>
			<cfquery name="LOCAL.GetProductList" dbtype="query">
				select * from [LOCAL].GetProductListPrime
				where CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.lCategoryID#" List="Yes">)
				order by CategoryID
			</cfquery>
			
		</cfif>
		
		<cfinvoke component="/com/product/productHandler" 
			method="GetProductAttributeStruct" 
			returnVariable="LOCAL.sAttributeID">
			
		<cfset LOCAL.lAttributeID="">
		<cfloop index="LOCAL.ThisKey" list="#StructKeyList(LOCAL.sAttributeID)#">
			<cfset LOCAL.lAttributeID=ListAppend(LOCAL.lAttributeID,LOCAL.sAttributeID[LOCAL.ThisKey])>
			<cfset QueryAddColumn(LOCAL.GetProductList,LOCAL.ThisKey,"VarChar",ArrayNew(1))>
		</cfloop>
		
		<cfset LOCAL.sAttribute=StructNew()>
		<cfloop index="LOCAL.ThisKey" list="#StructKeyList(LOCAL.sAttributeID)#">
			<cfset StructInsert(LOCAL.sAttribute,LOCAL.sAttributeID[LOCAL.thisKey],LOCAL.ThisKey,1)>
		</cfloop>
		
		<cfquery name="LOCAL.GetItems" datasource="#APPLICATION.DSN#">
			SELECT CategoryID,ProductFamilyAttributeID,AttributeValue FROM t_ProductAttribute
			WHERE 
			ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.lAttributeID#" List="yes">) AND 
			CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.lCategoryID#" List="Yes">) and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
			Order by CategoryID
		</cfquery>
		
		<cfoutput query="LOCAL.GetProductList">
			<cfquery name="LOCAL.GetItemsPrime" dbtype="query">
				select * from [LOCAL].GetItems where CategoryID=<cfqueryparam value="#LOCAL.GetProductList.CategoryID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfloop query="LOCAL.GetItemsPrime">
				<cfset QuerySetCell(LOCAL.GetProductList,LOCAL.sAttribute[LOCAL.GetItemsPrime.ProductFamilyAttributeID],LOCAL.GetItemsPrime.AttributeValue,LOCAL.GetProductList.CurrentRow)>
			</cfloop>
		</cfoutput>
		
		<cfquery name="LOCAL.GetView" datasource="#APPLICATION.DSN#">
			select ResourceID,ResourceName,ResourceText,MainFilePath,ResourceSize,ThumbnailFilePath,SpecificationSetID,KeyID,ResourcePriority from qry_GetResource
			WHERE
			KeyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.lCategoryID#" List="Yes">) and 
			Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> and
			ResourceTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="9000">
			Order by keyID,ResourcePriority
		</cfquery>
		
		<cfset QueryAddColumn(LOCAL.GetProductList,"aView",ArrayNew(1))>
		
		<cfoutput query="LOCAL.GetProductList">
			<cfquery name="LOCAL.GetViewPrime" dbtype="query">
				select * from [LOCAL].GetView where KeyID=<cfqueryparam value="#LOCAL.GetProductList.CategoryID#" cfsqltype="cf_sql_integer">
				order by ResourcePriority
			</cfquery>
			<cfset LOCAL.aBlank=ArrayNew(1)>
			<cfloop query="LOCAL.GetViewPrime">
				<cfset LOCAL.sViewElt=StructNew()>
				<cfset StructInsert(LOCAL.sViewElt,"ResourceID",LOCAL.GetViewPrime.ResourceID,1)>
				<cfset StructInsert(LOCAL.sViewElt,"ResourceName",LOCAL.GetViewPrime.ResourceName,1)>
				<cfset StructInsert(LOCAL.sViewElt,"ResourceText",LOCAL.GetViewPrime.ResourceText,1)>
				<cfset StructInsert(LOCAL.sViewElt,"MainFilePath",LOCAL.GetViewPrime.MainFilePath,1)>
				<cfset StructInsert(LOCAL.sViewElt,"MainFileSize",LOCAL.GetViewPrime.ResourceSize,1)>
				<cfset StructInsert(LOCAL.sViewElt,"ThumbnailFilePath",LOCAL.GetViewPrime.ThumbnailFilePath,1)>
				<cfset StructInsert(LOCAL.sViewElt,"SpecificationSetID",LOCAL.GetViewPrime.SpecificationSetID,1)>
				<cfset arrayAppend(LOCAL.aBlank,LOCAL.sViewElt)>
			</cfloop>
			<cfset QuerySetCell(LOCAL.GetProductList,"aView",LOCAL.aBlank,LOCAL.GetProductList.CurrentRow)>
		</cfoutput>
		
		<cfquery name="LOCAL.GetDownload" datasource="#APPLICATION.DSN#">
			select ResourceID,ResourceName,ResourceText,MainFilePath,ResourceSize,ThumbnailFilePath,SpecificationSetID,KeyID,ResourcePriority from qry_GetResource
			WHERE 
			KeyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.lCategoryID#" List="Yes">) and 
			Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> and
			ResourceTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="9001">
			Order by keyID,ResourcePriority
		</cfquery>
		
		<cfset QueryAddColumn(LOCAL.GetProductList,"aDownload",ArrayNew(1))>
		
		<cfoutput query="LOCAL.GetProductList">
			<cfquery name="LOCAL.GetDownloadPrime" dbtype="query">
				select * from [LOCAL].GetDownload where KeyID=<cfqueryparam value="#LOCAL.GetProductList.CategoryID#" cfsqltype="cf_sql_integer">
				order by ResourcePriority
			</cfquery>
			<cfset LOCAL.aBlank=ArrayNew(1)>
			<cfloop query="LOCAL.GetDownloadPrime">
				<cfset LOCAL.sDownloadElt=StructNew()>
				<cfset StructInsert(LOCAL.sDownloadElt,"ResourceID",LOCAL.GetDownloadPrime.ResourceID,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"ResourceName",LOCAL.GetDownloadPrime.ResourceName,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"ResourceText",LOCAL.GetDownloadPrime.ResourceText,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"MainFilePath",LOCAL.GetDownloadPrime.MainFilePath,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"MainFileSize",LOCAL.GetDownloadPrime.ResourceSize,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"ThumbnailFilePath",LOCAL.GetDownloadPrime.ThumbnailFilePath,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"SpecificationSetID",LOCAL.GetDownloadPrime.SpecificationSetID,1)>
				<cfset arrayAppend(LOCAL.aBlank,LOCAL.sDownloadElt)>
			</cfloop>
			<cfset QuerySetCell(LOCAL.GetProductList,"aDownload",LOCAL.aBlank,LOCAL.GetProductList.CurrentRow)>
		</cfoutput>
		
		<cfquery name="LOCAL.GetProductList" dbtype="query">
			select * from [LOCAL].GetProductList
			order by DisplayOrder
		</cfquery>
		
		<cfreturn LOCAL.GetProductList>
	</cffunction>
	
	<cffunction name="GetProductFamilyList" returntype="query" output="false">
		<cfargument name="ParentProductFamilyID" default="" type="numeric" required="true">
		<cfargument name="LocaleID" default="#APPLICATION.LocaleID#" type="numeric" required="true">
		<cfargument name="LanguageID" default="#APPLICATION.LanguageID#" type="numeric" required="true">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
			<cfprocresult name="LOCAL.GetProductFamilyListPrime">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#val(ARGUMENTS.LocaleID)#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="" null="yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#val(ARGUMENTS.ParentProductFamilyID)#" null="NO">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="62" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="ShowInNavigation" value="" null="Yes">
		</cfstoredproc>
		
		<cfquery name="LOCAL.GetProductFamilyList" dbtype="query">
			select * from [LOCAL].GetProductFamilyListPrime
			order by CategoryID
		</cfquery>
		
		<cfinvoke component="/com/product/productFamilyHandler" 
			method="GetProductFamilyAttributeStruct" 
			returnVariable="LOCAL.sAttributeID">
			
		<cfset LOCAL.lAttributeID="">
		<cfloop index="LOCAL.ThisKey" list="#StructKeyList(LOCAL.sAttributeID)#">
			<cfset LOCAL.lAttributeID=ListAppend(LOCAL.lAttributeID,LOCAL.sAttributeID[LOCAL.ThisKey])>
			<cfset QueryAddColumn(LOCAL.GetProductFamilyList,LOCAL.ThisKey,"VarChar",ArrayNew(1))>
		</cfloop>
		
		<cfset LOCAL.sAttribute=StructNew()>
		<cfloop index="LOCAL.ThisKey" list="#StructKeyList(LOCAL.sAttributeID)#">
			<cfset StructInsert(LOCAL.sAttribute,LOCAL.sAttributeID[LOCAL.thisKey],LOCAL.ThisKey,1)>
		</cfloop>
		
		<cfquery name="LOCAL.GetItems" datasource="#APPLICATION.DSN#">
			SELECT CategoryID,ProductFamilyAttributeID,AttributeValue FROM t_ProductAttribute
			WHERE 
			ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#LOCAL.lAttributeID#" List="yes">) AND 
			CategoryID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(LOCAL.GetProductFamilyList.CategoryID)#" List="Yes">) and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#">
			Order by CategoryID
		</cfquery>
		
		<cfoutput query="LOCAL.GetProductFamilyList">
			<cfquery name="LOCAL.GetItemsPrime" dbtype="query">
				select * from [LOCAL].GetItems where CategoryID=<cfqueryparam value="#LOCAL.GetProductFamilyList.CategoryID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfloop query="LOCAL.GetItemsPrime">
				<cfset QuerySetCell(LOCAL.GetProductFamilyList,LOCAL.sAttribute[LOCAL.GetItemsPrime.ProductFamilyAttributeID],LOCAL.GetItemsPrime.AttributeValue,LOCAL.GetProductFamilyList.CurrentRow)>
			</cfloop>
		</cfoutput>
		
		<cfquery name="LOCAL.GetView" datasource="#APPLICATION.DSN#">
			select ResourceID,ResourceName,ResourceText,MainFilePath,ResourceSize,ThumbnailFilePath,SpecificationSetID,KeyID,ResourcePriority from qry_GetResource
			WHERE 
			KeyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(LOCAL.GetProductFamilyList.CategoryID)#" List="Yes">) and 
			Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> and
			ResourceTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="9000">
			Order by keyID,ResourcePriority
		</cfquery>
		
		<cfset QueryAddColumn(LOCAL.GetProductFamilyList,"aView",ArrayNew(1))>
		
		<cfoutput query="LOCAL.GetProductFamilyList">
			<cfquery name="LOCAL.GetViewPrime" dbtype="query">
				select * from [LOCAL].GetView where KeyID=<cfqueryparam value="#LOCAL.GetProductFamilyList.CategoryID#" cfsqltype="cf_sql_integer">
				order by ResourcePriority
			</cfquery>
			<cfset LOCAL.aBlank=ArrayNew(1)>
			<cfloop query="LOCAL.GetViewPrime">
				<cfset LOCAL.sViewElt=StructNew()>
				<cfset StructInsert(LOCAL.sViewElt,"ResourceID",LOCAL.GetViewPrime.ResourceID,1)>
				<cfset StructInsert(LOCAL.sViewElt,"ResourceName",LOCAL.GetViewPrime.ResourceName,1)>
				<cfset StructInsert(LOCAL.sViewElt,"ResourceText",LOCAL.GetViewPrime.ResourceText,1)>
				<cfset StructInsert(LOCAL.sViewElt,"MainFilePath",LOCAL.GetViewPrime.MainFilePath,1)>
				<cfset StructInsert(LOCAL.sViewElt,"MainFileSize",LOCAL.GetViewPrime.ResourceSize,1)>
				<cfset StructInsert(LOCAL.sViewElt,"ThumbnailFilePath",LOCAL.GetViewPrime.ThumbnailFilePath,1)>
				<cfset StructInsert(LOCAL.sViewElt,"SpecificationSetID",LOCAL.GetViewPrime.SpecificationSetID,1)>
				<cfset arrayAppend(LOCAL.aBlank,LOCAL.sViewElt)>
			</cfloop>
			<cfset QuerySetCell(LOCAL.GetProductFamilyList,"aView",LOCAL.aBlank,LOCAL.GetProductFamilyList.CurrentRow)>
		</cfoutput>
		
		<cfquery name="LOCAL.GetDownload" datasource="#APPLICATION.DSN#">
			select ResourceID,ResourceName,ResourceText,MainFilePath,ResourceSize,ThumbnailFilePath,SpecificationSetID,KeyID,ResourcePriority from qry_GetResource
			WHERE 
			KeyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(LOCAL.GetProductFamilyList.CategoryID)#" List="Yes">) and 
			Entity=<cfqueryparam cfsqltype="cf_sql_varchar" value="t_Category"> and 
			languageID=<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(ARGUMENTS.LanguageID)#"> and
			ResourceTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="9001">
			Order by keyID,ResourcePriority
		</cfquery>
		
		<cfset QueryAddColumn(LOCAL.GetProductFamilyList,"aDownload",ArrayNew(1))>
		
		<cfoutput query="LOCAL.GetProductFamilyList">
			<cfquery name="LOCAL.GetDownloadPrime" dbtype="query">
				select * from [LOCAL].GetDownload where KeyID=<cfqueryparam value="#LOCAL.GetProductFamilyList.CategoryID#" cfsqltype="cf_sql_integer">
				order by ResourcePriority
			</cfquery>
			<cfset LOCAL.aBlank=ArrayNew(1)>
			<cfloop query="LOCAL.GetDownloadPrime">
				<cfset LOCAL.sDownloadElt=StructNew()>
				<cfset StructInsert(LOCAL.sDownloadElt,"ResourceID",LOCAL.GetDownloadPrime.ResourceID,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"ResourceName",LOCAL.GetDownloadPrime.ResourceName,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"ResourceText",LOCAL.GetDownloadPrime.ResourceText,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"MainFilePath",LOCAL.GetDownloadPrime.MainFilePath,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"MainFileSize",LOCAL.GetDownloadPrime.ResourceSize,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"ThumbnailFilePath",LOCAL.GetDownloadPrime.ThumbnailFilePath,1)>
				<cfset StructInsert(LOCAL.sDownloadElt,"SpecificationSetID",LOCAL.GetDownloadPrime.SpecificationSetID,1)>
				<cfset arrayAppend(LOCAL.aBlank,LOCAL.sDownloadElt)>
			</cfloop>
			<cfset QuerySetCell(LOCAL.GetProductFamilyList,"aDownload",LOCAL.aBlank,LOCAL.GetProductFamilyList.CurrentRow)>
		</cfoutput>
		
		<!--- CMS Properties --->
		<cfset QueryAddColumn(LOCAL.GetProductFamilyList,"CategoryImageRepresentative",ArrayNew(1))>
		<cfset QueryAddColumn(LOCAL.GetProductFamilyList,"CategoryImageRollover",ArrayNew(1))>
		<cfoutput query="LOCAL.GetProductFamilyList">
			<cfif LOCAL.GetProductFamilyList.CategoryLocalePropertiesPacket IS NOT "" AND  IsWDDX(LOCAL.GetProductFamilyList.CategoryLocalePropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#LOCAL.GetProductFamilyList.CategoryLocalePropertiesPacket#" output="LOCAL.sCategoryLocaleProperties">
				<cfloop index="LOCAL.ThisProp" list="CategoryImageRepresentative,CategoryImageRollover">
					<cfif StructKeyExists(LOCAL.sCategoryLocaleProperties,"#LOCAL.ThisProp#") AND Trim(StructFind(LOCAL.sCategoryLocaleProperties, "#LOCAL.ThisProp#")) IS NOT "">
						<cfset QuerySetCell(LOCAL.GetProductFamilyList,"#LOCAL.ThisProp#",StructFind(LOCAL.sCategoryLocaleProperties, "#ThisProp#"),LOCAL.GetProductFamilyList.CurrentRow)>
					</cfif>
				</cfloop>
			</cfif>
		</cfoutput>
		
		<!--- Has sub product families --->
		<cfquery name="LOCAL.GetChildrenPrime" datasource="#APPLICATION.DSN#">
			select 	Count(CategoryID) as Count, ParentID from t_Category
			Where	ParentID IN (<cfqueryparam value="#ValueList(LOCAL.GetProductFamilyList.CategoryID)#" cfsqltype="cf_sql_integer" list="yes">)
			and		CategoryTypeID=<cfqueryparam value="62" cfsqltype="cf_sql_integer">
			Group By ParentID
			ORDER BY ParentID
		</cfquery>
		<cfset QueryAddColumn(LOCAL.GetProductFamilyList,"HasSubProductFamilies",ArrayNew(1))>
		<cfoutput query="LOCAL.GetProductFamilyList">
			<cfquery name="LOCAL.GetChildren" dbtype="query">
				select * from [LOCAL].GetChildrenPrime where ParentID=<cfqueryparam value="#LOCAL.GetProductFamilyList.CategoryID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif LOCAL.GetChildren.RecordCount GT "0">
				<cfset QuerySetCell(LOCAL.GetProductFamilyList,"HasSubProductFamilies",1,LOCAL.GetProductFamilyList.CurrentRow)>
			<cfelse>
				<cfset QuerySetCell(LOCAL.GetProductFamilyList,"HasSubProductFamilies",0,LOCAL.GetProductFamilyList.CurrentRow)>
			</cfif>
		</cfoutput>
		
		<cfquery name="LOCAL.GetProductFamilyList" dbtype="query">
			select * from [LOCAL].GetProductFamilyList
			order by DisplayOrder
		</cfquery>
		
		<cfreturn LOCAL.GetProductFamilyList>
	</cffunction>
	
	<cffunction name="GetProductFamilyAttributeStruct" returntype="struct" output="false">
		
		<cfset VAR LOCAL=StructNew()>
		<cfset LOCAL.sAttributeID=StructNew()>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductFamilyDescription","18",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductViewLabel","19",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductFamilyBrochurePath","20",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductFamilyBenchMarkDate","21",1)>
		<cfset StructInsert(LOCAL.sAttributeID,"ProductFamilyBrochurePathOverride","22",1)>
		
		<cfreturn LOCAL.sAttributeID>
	</cffunction>
	
</cfcomponent>