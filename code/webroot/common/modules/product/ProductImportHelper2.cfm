<cfsetting showdebugoutput="0" RequestTimeOut="60000">
<cfparam name="URL.NodeID" default="-1000">

<cfquery name="GetDetail" datasource="#APPLICATION.DSN#">
	select * from qry_GetProductsProto where NodeID=<cfqueryparam value="#val(URL.NodeID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfset REQUEST.sNewCategoryID=StructNew()>

<cfquery name="GetExisting" datasource="#APPLICATION.DSN#">
	select * from t_ProductsHierarchy
</cfquery>

<cfoutput query="GetExisting">
	<cfset StructInsert(REQUEST.sNewCategoryID,ID,CategoryID,1)>
</cfoutput>

<cfif Val(GetDetail.CategoryID) GT "0">
	<cfset ThisCategoryID=Val(GetDetail.CategoryID)>
<cfelse>
	<cfset ThisCategoryID="-1">
</cfif>

<cfif Trim(GetDetail.ID) IS "">
	<cfset ThisProductFamilyID=62>
<cfelse>
	<cfset ThisProductFamilyID=64>
</cfif>


<cfif ThisProductFamilyID IS "64">
	<cfset MyProduct=CreateObject("component","com.Product.Product")>
	<cfset MyProduct.Constructor(Val(ThisCategoryID),APPLICATION.DefaultLanguageID)>
	<cfset MyProduct.SetProperty("PartNumber",GetDetail.FPartNo)>
	<cfset MyProduct.Save(APPLICATION.WebrootPath,1)>
</cfif>

Success!