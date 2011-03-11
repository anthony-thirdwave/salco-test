<cfsetting showdebugoutput="0" RequestTimeOut="60000">
<cfparam name="ATTRIBUTES.NodeID" default="-1">
<cfparam name="ATTRIBUTES.Level" default="1">

<cfquery name="GetDetail" datasource="#APPLICATION.DSN#">
	select * from qry_GetProductsProto where NodeID=<cfqueryparam value="#val(ATTRIBUTES.NodeID)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfquery name="GetList" datasource="#APPLICATION.DSN#">
	select * from qry_GetProductsProto 
	<cfif Val(REQUEST.MaxRows) GT "0" and REQUEST.MaxRows LT REQUEST.Counter>
		where NodeParentID=<cfqueryparam value="-1000" cfsqltype="CF_SQL_INTEGER">
	<cfelse>
		where NodeParentID=<cfqueryparam value="#val(ATTRIBUTES.NodeID)#" cfsqltype="CF_SQL_INTEGER">
	</cfif>
	order by NodeName
</cfquery>

<cfif ATTRIBUTES.Level IS NOT "0">
	<cfif Val(REQUEST.MaxRows) GT "0" and REQUEST.MaxRows LT REQUEST.Counter>
	
	<cfelse>
		<cfoutput query="GetDetail"><li>#GetDetail.NodeName# <cfif fdescript IS NOT "">/ #fdescript#</cfif> (#NodeID#-#REQUEST.Counter#)</cfoutput>
		<cfif Val(GetDetail.CategoryID) GT "0">
			<cfset ThisCategoryID=Val(GetDetail.CategoryID)>
		<cfelse>
			<cfset ThisCategoryID="-1">
		</cfif>
			
		<cfif Val(ThisCategoryID) GTE "0">
			<br>importing...
			<cfhttp url="http://www.salco.dev09.thirdwavellc.com/common/modules/product/productImportHelper2.cfm?NodeID=#GetDetail.NodeID#" method="GET" resolveurl="false" Timeout="60000">
			results(<cfoutput>#Trim(CFHTTP.FileContent)#</cfoutput>)
			done!
		<cfelse>
			<br>Already imported into CategoryID: <cfoutput>#ThisCategoryID#</cfoutput>
		</cfif>
	</cfif>
	<cfset REQUEST.Counter=REQUEST.Counter+1>
</cfif>
<cfif GetList.recordcount GT "0">
	<ul>
	<cfoutput query="GetList">
		<cfmodule template="/common/modules/product/ProductImportHelper.cfm" 
			NodeID="#val(GetList.NodeID)#"
			Level="#ATTRIBUTES.Level+1#">
	</cfoutput>
	</ul>
</cfif>
<cfif ATTRIBUTES.Level IS NOT "0"></li></cfif>

