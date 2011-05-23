<cfsetting RequestTimeout="60000">

<cfparam name="url.totalRecord" default="">
<cfparam name="url.page" default="">
<cfparam name="url.sort" default="DisplayOrder">
<cfparam name="url.dir" default="">
<cfparam name="url.pName" default="">
<cfparam name="url.PNumber" default="">
<cfparam name="url.ptFamilyName" default="">
<cfparam name="url.Pdescription" default="">


<cfif Not len(url.Sort)>
	<cfset url.sort="DisplayOrder">
</cfif>
<cfif Not len(url.dir)>
	<cfset url.dir="desc">
</cfif>

<cfinvoke component="com.product.productHandler" method="GetProductReport" 
	page="#url.page#"
	pageSize="#url.totalRecord#"
	cfgridsortcolumn="#url.sort#"
	cfgridsortdirection="#url.dir#"
	productName="#url.pName#"
	PartNumber="#url.PNumber#"
	productFamilyName="#url.ptFamilyName#"
	description="#url.Pdescription#"
	returnVariable="QRY_GetProductReport">

<cfquery name="GetProductReport2" dbtype="Query">
	SELECT ProductName,PartNumber,ProductFamilyName,ProductDescription 
	FROM	QRY_GetProductReport
	ORDER BY #url.sort# #url.dir#
</cfquery>

<cfset ExportSheet=SpreadsheetNew("Products")>

<cfset spreadsheetAddRow(ExportSheet, "Product Name,Part Number,Product Family,Description")>
<cfset spreadsheetAddRows(ExportSheet, GetProductReport2)>

<!--- return the orders as an .xls --->
<cfheader name="Content-Disposition" value="filename=productExport.xls" />
<cfcontent type="application/mxexcel" variable="#spreadsheetReadBinary(ExportSheet)#">