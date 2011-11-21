<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cftransaction>
	<cfquery name="GetAllProductPages" datasource="#APPLICATION.DSN#">
		select *, AttributeValue as ProductNumber from qry_GetProduct
		where ProductFamilyAttributeID = 10
		order by AttributeValue,DisplayOrder
	</cfquery>
	
	
	<cfoutput query="GetAllProductPages" group="ProductNumber">
		<cfset lProductID="">
		<cfoutput group="ProductID">
			<cfset lProductID=ListAppend(lProductID,ProductID)>
		</cfoutput>
		
		<cfquery name="GetRepeated" datasource="#APPLICATION.DSN#">
			select CategoryID from t_category
			where SourceID=#ListFirst(lProductID)# and
			CategoryTypeID=80
			Order By DisplayOrder
		</cfquery>
		
		<cfif ProductNumber IS NOT "">
			<cfif ListLen(lProductID) GT "1" or GetRepeated.RecordCount GT "0">
				PRODUCT: #CategoryName# (#ProductNumber#)<br>
				http://#CGI.Server_Name#/common/admin/masterview/index.cfm?MVEid=1&mvcid=#ListFirst(lProductID)#<br>
				<cfif GetRepeated.RecordCount GT "0">
					Repeated:<br>
					<cfloop query="GetRepeated">
						http://#CGI.Server_Name#/common/admin/masterview/index.cfm?MVEid=1&mvcid=#GetRepeated.CategoryID#<br>
					</cfloop>
				</cfif>
				<cfif ListLen(lProductID) GT "1">
					Dupe:<br>
					<cfloop index="ThisProductID" list="#ListRest(lProductID)#">
						http://#CGI.Server_Name#/common/admin/masterview/index.cfm?MVEid=1&mvcid=#ThisProductID#
						<cfif 1>
							<cfquery name="ConvertToRepeated" datasource="#APPLICATION.DSN#">
								update t_category 
								Set 
								CategoryTypeID=80,
								SourceID=#ListFirst(lProductID)#
								Where CategoryID=#ThisProductID#
							</cfquery>
							<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
								UserID="1"
								Entity="Category"
								KeyID="#ThisProductID#"
								Operation="modify"
								EntityName="#CategoryName#">
							-Converted
						</cfif>
						<br>
					</cfloop>
				</cfif>
				<hr>
			</cfif>
		</cfif>
	</cfoutput>
</cftransaction>
</body>
</html>
