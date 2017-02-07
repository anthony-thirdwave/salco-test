<cfsetting showdebugoutput="0">
<cfparam name="q" default="">
<cfquery name="LookupProductFamilies" datasource="#APPLICATION.DSN#" maxrows="10">
	select CategoryName, CategoryAlias, CategoryThreadName from qry_GetCategoryWithThreadName where 
	CategoryName like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#q#%"> AND
	CategoryActive=<cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
	ShowInNavigation=<cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
	CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="62">
	order by DisplayOrder
</cfquery>
<cfquery name="LookupProducts" datasource="#APPLICATION.DSN#" maxrows="10">
	select CategoryName, CategoryAlias, CategoryThreadName, AttributeValue from qry_GetProductLookup where 
	(CategoryName like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#q#%"> OR
	 AttributeValue like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#q#%"> 
	)
	AND
	CategoryActive=<cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
	ShowInNavigation=<cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
	CategoryTypeID=<cfqueryparam cfsqltype="cf_sql_integer" value="64">
	order by DisplayOrder
</cfquery>
<cfif LookupProductFamilies.RecordCount GT "0" or LookupProducts.RecordCount GT "0">
<ul id="LookupResults">
	<cfif LookupProductFamilies.RecordCount GT "0">
		<li>Product Family
			<ul>
				<cfoutput query="LookupProductFamilies">
					<li>#ListChangeDelims(ListRest(ListRest(CategoryThreadName))," &gt; ")# &gt; <a href="#APPLICATION.utilsObj.parseCategoryUrl(LookupProductFamilies.CategoryAlias)#">#LookupProductFamilies.CategoryName#</a></li>
				</cfoutput>
			</ul>
		</li>
	</cfif>
	<cfif LookupProducts.RecordCount GT "0">
		<li>Products
			<ul>
				<cfoutput query="LookupProducts">
					<li>#ListChangeDelims(ListRest(ListRest(ListDeleteAt(CategoryThreadName,ListLen(CategoryThreadName))))," &gt; ")# &gt; <a href="#APPLICATION.utilsObj.parseCategoryUrl(LookupProducts.CategoryAlias)#">#LookupProducts.CategoryName# (#LookupProducts.AttributeValue#)</a></li>
				</cfoutput>
			</ul>
		</li>
	</cfif>
</ul>
</cfif>