<cfabort><cfsetting showdebugoutput="1" RequestTimeOut="60000">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
	SELECT *
	from t_ProductAttribute
	Where
	ProductFamilyAttributeID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="12" list="yes">) 
	and AttributeValue like 'W:%'
	order by CategoryID, ProductFamilyAttributeID
</cfquery>

<cfoutput query="GetAttributes">
	<cfif AttributeValue IS NOT "">
		<cfif Left(AttributeValue,"12") IS "W:\DWF Parts">
			<hr>
			Original Value: #AttributeValue#<br>
			<cfset NewValue=Replace(AttributeValue,"W:\DWF Parts","/resources/external/dwfparts")>
			<cfset NewValue=Replace(NewValue,"\","/","All")>
			<cfset Source=ReplaceNoCase(AttributeValue,"W:\","D:\websites.staging\salco\Resources\W\")>
			<cfquery name="SetAttributes1" datasource="#APPLICATION.DSN#">
				update t_ProductAttribute set AttributeValue='#NewValue#'
				where CategoryID=#Val(CategoryID)# and ProductFamilyAttributeID=12
			</cfquery>
			<cfquery name="SelectAttribute" datasource="#APPLICATION.DSN#">
				select * from t_ProductAttribute
				where CategoryID=#Val(CategoryID)# and ProductFamilyAttributeID=23
			</cfquery>
			Source: #Source#<br>
			NewValue: #NewValue#
			<cfif FileExists(Source)>
				<cfif SelectAttribute.RecordCount GT "0">
					<cfquery name="SetAttributes2" datasource="#APPLICATION.DSN#">
						update t_ProductAttribute set AttributeValue='#GetFileInfo(Source).Size#'
						where CategoryID=#Val(CategoryID)# and ProductFamilyAttributeID=23
					</cfquery>
				<cfelse>
					<cfquery name="InsertAttributes" datasource="#APPLICATION.DSN#">
						insert t_ProductAttribute 
						(CategoryID,LanguageID,ProductFamilyAttributeID,AttributeValue)
						VALUES
						(#Val(CategoryID)#,100,23,#Val(GetFileInfo(Source).Size)#)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfif FileExists(ExpandPath(AttributeValue))>
			<cfquery name="SelectAttribute" datasource="#APPLICATION.DSN#">
				select * from t_ProductAttribute
				where CategoryID=#Val(CategoryID)# and ProductFamilyAttributeID=23
			</cfquery>
			<cfif SelectAttribute.RecordCount GT "0">
				<cfquery name="SetAttributes2" datasource="#APPLICATION.DSN#">
					update t_ProductAttribute set AttributeValue='#GetFileInfo(ExpandPath(AttributeValue)).Size#'
					where CategoryID=#Val(CategoryID)# and ProductFamilyAttributeID=23
				</cfquery>
			<cfelse>
				<cfquery name="InsertAttributes" datasource="#APPLICATION.DSN#">
					insert t_ProductAttribute 
					(CategoryID,LanguageID,ProductFamilyAttributeID,AttributeValue)
					VALUES
					(#Val(CategoryID)#,100,23,#Val(GetFileInfo(ExpandPath(AttributeValue)).Size)#)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfoutput>
<cfabort>
<cfinvoke component="/com/product/producthandler" 
	method="GetPublicDrawing" 
	returnVariable="qGetPublicDrawing"
	TopProductFamilyID="-1">
<cfdump var="#qGetPublicDrawing#">

</body>
</html>
