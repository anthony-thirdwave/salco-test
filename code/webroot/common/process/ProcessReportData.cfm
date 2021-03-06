<cfset sReports=StructNew()>

<cfif APPLICATION.Staging>
	<cfset BaseFileLocation="D:\websites.staging\salco\Resources\Intranet Files\">
<cfelse>
	<cfset BaseFileLocation="#ExpandPath('/development/intranet_reports/templates/')#">
</cfif>
<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","ordershipmentAccuracy",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Order-Shipment Accuracy-RMA Data REVISED.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_ordershipmentAccuracy",1)>
<cfset StructInsert(sReportElt,"FieldLists",
"Quarter,TotalOrders,IncidentCount,DeliveryDamW,DeliveryDamWO,DocumentationW,DocumentationWO,HardDataEntryW,HardDataEntryWO,LateDeliveryW,LateDeliveryWO,NonconformingW,NonconformingWO,OrderEntryErrorW,OrderEntryErrorWO,PoorCommW,PoorCommWO,ProductMarkingW,ProductMarkingWO,SalcoWebsiteW,SalcoWebsiteWO,ShippingPackagingW,ShippingPackagingWO,VendorWebsiteW,VendorWebsiteWO,WrongLocationW,WrongLocationWO,WrongProductW,WrongProductWO,WrongQuantityW,WrongQuantityWO",1)>
<cfset StructInsert(sReports,1,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","orders",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Orders.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_Order",1)>
<cfset StructInsert(sReportElt,"FieldLists","Date,Email,Fax,Phone,Cons,VIP,Promo,LI",1)>
<cfset StructInsert(sReports,2,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","sales",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Sales.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_Sales",1)>
<cfset StructInsert(sReportElt,"FieldLists","Year,Month,AnnualSalesGoal,QuarterlySalesGoal,MonthlySalesGoal,ActualSales",1)>
<cfset StructInsert(sReports,3,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","Shipment",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Shipments.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_Shipment",1)>
<cfset StructInsert(sReportElt,"FieldLists","year,month,week,Shipment,Processed",1)>
<cfset StructInsert(sReports,4,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","Backlog",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Backlog.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_backlog",1)>
<cfset StructInsert(sReportElt,"FieldLists","[SO Count],value,month,year",1)>
<cfset StructInsert(sReports,5,sReportElt,1)>


<cfloop index="ThisReport" list="#structKeyList(sReports)#">
	<cfoutput>Working on #sReports[ThisReport].ReportName#...<br></cfoutput>
	<cfset thisFilePath="#sReports[ThisReport].FileLocation#\#sReports[ThisReport].FileName#">
	<cfif FileExists(thisFilePath)>
		<cfoutput>Import file exists (#sReports[ThisReport].FileName#)...<br></cfoutput>
		<cffile action="read" file="#thisFilePath#" variable="orderCSVFile">

		<cfif ThisReport IS "1">
			<cfset orderCSVFile=Replace(orderCSVFile,"Quarter,Total Orders,Incident  Count,Delivery Dam W,Delivery Dam WO,Documentation W,Documentation WO,Hard Data Entry W,Hard Data Entry WO,Late Delivery W,Late Delivery WO,Nonconforming W,Nonconforming WO,Order Entry Error W,Order Entry Error WO,Poor Comm W,Poor Comm WO,Product Marking W,Product Marking WO,Salco Website W,Salco Website WO,Shipping Packaging W,Shipping Packaging WO,Vendor Website W,Vendor Website WO,Wrong Location W,Wrong Location WO,Wrong Product W,Wrong Product WO,Wrong Qunatity W,Wrong Quantity WO",sReports[ThisReport].FieldLists,"one")>
		</cfif>

		<cfinvoke component="/com/utils/utils"
			method="CSVToQuery"
			returnVariable="qResult"
			CSV="#Trim(orderCSVFile)#">

		<cftransaction>
			<cfquery name="SelectOriginal" datasource="#APPLICATION.Data_DSN#">
				select * from #sReports[ThisReport].TableName#
			</cfquery>
			
			<cfset TotalData="">
			
			<cfoutput query="SelectOriginal">
				<cfloop index="ThisColumn" list="#SelectOriginal.ColumnList#">
					<cfset TotalData="#TotalData##Trim(SelectOriginal[Thiscolumn][CurrentRow])#">
				</cfloop>
			</cfoutput>
			<cfset ThisHash=Hash(TotalData)>
			<cfoutput>Calculating hash of data...(#ThisHash#)<br></cfoutput>
			<cfquery name="SelectStatus" datasource="#APPLICATION.Data_DSN#">
				select * from rp_status where ReportID=<cfqueryparam value="#ThisReport#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif SelectStatus.RecordCount IS "0">
				<cfquery name="InsertStatus" datasource="#APPLICATION.Data_DSN#">
					INSERT INTO rp_status 
					(ReportID, Hash, DateTimeLastUpdated)
					VALUES
					(<cfqueryparam value="#ThisReport#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#ThisHash#" cfsqltype="cf_sql_varchar">, GetDate())
				</cfquery>
			<cfelseif SelectStatus.Hash is not ThisHash>
				Hash does not match last import's hash, marking this report as updated...<br>
				<cfquery name="SelectStatus" datasource="#APPLICATION.Data_DSN#">
					update rp_status 
					SET
					Hash=<cfqueryparam value="#ThisHash#" cfsqltype="cf_sql_varchar">,
					DateTimeLastUpdated=GetDate()
					where ReportID=<cfqueryparam value="#ThisReport#" cfsqltype="cf_sql_integer">
				</cfquery>
			<cfelse>
				<cfoutput>Hash matches last import's hash (#SelectStatus.Hash#)...<br></cfoutput>
			</cfif>
			
			
			<cfquery name="rp_OrderDelete" datasource="#APPLICATION.Data_DSN#">
				DELETE FROM #sReports[ThisReport].TableName#
			</cfquery>
			Importing data...<br>
			<cfloop query="qResult" startRow="2">
				<cfdump var="#qResult#">
				<cfquery name="#sReports[ThisReport].TableName#_Insert" datasource="#APPLICATION.Data_DSN#">
					INSERT INTO #sReports[ThisReport].TableName# (#sReports[ThisReport].FieldLists#)
					VALUES	(
					<cfloop index="i" from="1" to="#listlen(sReports[ThisReport].FieldLists)#">
						<cfif i neq 1>,</cfif>
						<cfif ThisReport eq 2 and i eq 1>
							<cfqueryparam value="#dateformat(column_1,'mm-dd-yyyy')#" cfsqltype="cf_sql_date">
						<cfelseif ThisReport eq 1 and i eq 1>
							<cfqueryparam value="#evaluate('column_#i#')#" cfsqltype="cf_sql_varchar">
						<cfelseif ThisReport eq 5 and i eq 3>
							<cfset ThisValue="#evaluate('column_#i#')#">
							<cfset ThisValue=Replace(ThisValue,"$","","all")>
							<cfqueryparam value="#ThisValue#" cfsqltype="cf_sql_varchar">
						<cfelse>
							<cfqueryparam value="#Val(evaluate('column_#i#'))#" cfsqltype="cf_sql_integer">
						</cfif>
					</cfloop>
					)
				</cfquery>
			</cfloop>
			Done...<br>
		</cftransaction>
	</cfif>
	<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
		UserID="1"
		Entity="Reports"
		KeyID="#ThisReport#"
		Operation="modify"
		EntityName="#sReports[ThisReport].ReportName#">
	<hr>
</cfloop>

<p>Done with all.</p>

<p>Completed: <cfoutput>#DateFormat(now())# #TimeFormat(now())#</cfoutput></p>