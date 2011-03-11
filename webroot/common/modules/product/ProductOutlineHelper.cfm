<cfparam name="ATTRIBUTES.NodeID" default="-1">
<cfparam name="ATTRIBUTES.Level" default="1">

<cfquery name="GetDetail" datasource="#APPLICATION.DSN#">
	select * from qry_GetProductsProto where NodeID=<cfqueryparam value="#val(ATTRIBUTES.NodeID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery name="GetList" datasource="#APPLICATION.DSN#">
	select * from qry_GetProductsProto where NodeParentID=<cfqueryparam value="#val(ATTRIBUTES.NodeID)#" cfsqltype="CF_SQL_INTEGER">
	order by NodeName
</cfquery>

<cfif ATTRIBUTES.Level IS NOT "0">
	<cfoutput query="GetDetail"><li>#GetDetail.NodeName# <cfif fdescript IS NOT "">/ #fdescript#</cfif> (#NodeID#)</cfoutput>
</cfif>
<cfif GetList.recordcount GT "0">
	<ul>
	<cfoutput query="GetList">
		<cfmodule template="/common/modules/product/ProductOutlineHelper.cfm" 
			NodeID="#val(GetList.NodeID)#"
			Level="#ATTRIBUTES.Level+1#">
	</cfoutput>
	</ul>
</cfif>
<cfif GetList.recordcount IS "0" and Trim(GetDetail.ID) IS "">
	<strong>NO PRODUCTS</strong>
	<cfset REQUEST.lProblemID=ListAppend(REQUEST.lProblemID,GetDetail.NodeID)>
</cfif>
<cfif ATTRIBUTES.Level IS NOT "0"></li></cfif>

