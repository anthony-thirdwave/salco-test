<cfsetting RequestTimeout="60000">


<cfinvoke component="/com/product/producthandler" method="GetProductReport" 
	returnVariable="GetProductReport">

<cfquery name="GetProductReport2" dbtype="Query">
	select ProductName,PartNumber,ProductFamilyName,ProductDescription from
	GetProductReport
	order by DisplayOrder
</cfquery>


<cfset ExportSheet=SpreadsheetNew("Products")>

<cfset spreadsheetAddRow(ExportSheet, "Product Name,Part Number,Product Family,Description")>
<cfset spreadsheetAddRows(ExportSheet, GetProductReport2)>

<!--- return the orders as an .xls --->
<cfheader name="Content-Disposition" value="filename=productExport.xls" />
<cfcontent type="application/mxexcel" variable="#spreadsheetReadBinary(ExportSheet)#">