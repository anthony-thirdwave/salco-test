<cfsetting showdebugoutput="0" RequestTimeOut="60000">
<cfparam name="ATTRIBUTES.NodeID" default="1">
<cfparam name="REQUEST.MaxRows" default="200000">
<cfparam name="REQUEST.Counter" default="0">

<cfdump var="#REQUEST.MaxRows#"><br>
<cfdump var="#ATTRIBUTES.NodeID#">

<cfset REQUEST.sNewCategoryID=StructNew()>
<cfset StructInsert(REQUEST.sNewCategoryID,"1","23",1)>
<cfset StructInsert(REQUEST.sNewCategoryID,"2733","2757",1)>
<cfset StructInsert(REQUEST.sNewCategoryID,"3083","2758",1)>
<cfset StructInsert(REQUEST.sNewCategoryID,"5944","2759",1)>

<cfquery name="GetExisting" datasource="#APPLICATION.DSN#">
	select * from t_ProductsHierarchy
</cfquery>

<cfoutput query="GetExisting">
	<cfset StructInsert(REQUEST.sNewCategoryID,ID,CategoryID,1)>
</cfoutput>

<cfif 0>
	<cfoutput>
		<p>CategoryIDToStart: #CategoryIDToStart#-#ThisDisplayLevel#<br>
		#ATTRIBUTES.CategoryThreadList#</p>
	</cfoutput>
</cfif>
<cfsavecontent variable="ProductList">
<cfmodule template="/common/modules/product/ProductImportHelper.cfm"
	NodeID="#ATTRIBUTES.NodeID#"
	Level="1">
</cfsavecontent>
<cfoutput>#ProductList#</cfoutput>