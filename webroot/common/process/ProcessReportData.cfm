<cfset sReports=StructNew()>
<cfset BaseFileLocation="\development\intranet_reports\templates\">
<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","ordershipmentAccuracy",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Order-Shipment Accuracy-RMA Data.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_ordershipmentAccuracy",1)>
<cfset StructInsert(sReportElt,"FieldLists","Quarter,TotalOrders,RMACount,InquiryCount,CustomerOrderedWrongPartTotalsIllinois,CustomerOrderedWrongPartTotalsTexas,DamagedDefectiveTotalsIllinois,DamagedDefectiveTotalsTexas,DataEntryErrorTotalsIllinois,DataEntryErrorTotalsTexas,DuplicateOrderTotalsIllinois,DuplicateOrderTotalsTexas,EngineeringIssueTotals,PartExchangeTotals,PartsNoLongerNeededTotals,PickingErrorTotalsIllinois,PickingErrorTotalsTexas,ProductionErrorTotalsIllinois,ProductionErrorTotalsTexas,PurchasingErrorTotalsIllinois,PurchasingErrorTotalsTexas,QualifiedWrongPartTotalsIllinois,QualifiedWrongPartTotalsTexas,TrialPartTotals,VendorErrorTotalsIllinois,VendorErrorTotalsTexas,QualityIssueTotalsIllinois,QualityIssueTotalsTexas,InventoryControlTotalsIllinois,InventoryControlTotalsTexas",1)>
<cfset StructInsert(sReports,1,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","orders",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Orders.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_Order",1)>
<cfset StructInsert(sReportElt,"FieldLists","Date,Email,Fax,Phone,Cons,VIP,Promo",1)>
<cfset StructInsert(sReports,2,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","sales",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Sales.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_Sales",1)>
<cfset StructInsert(sReportElt,"FieldLists","Year, Month,AnnualSalesGoal,QuarterlySalesGoal,MonthlySalesGoal,ActualSales",1)>
<cfset StructInsert(sReports,3,sReportElt,1)>

<cfset sReportElt=StructNew()>
<cfset StructInsert(sReportElt,"ReportName","Shipment",1)>
<cfset StructInsert(sReportElt,"FileLocation","#BaseFileLocation#",1)>
<cfset StructInsert(sReportElt,"FileName","Template-Shipments.csv",1)>
<cfset StructInsert(sReportElt,"TableName","rp_Shipment",1)>
<cfset StructInsert(sReportElt,"FieldLists","year,month,week,Shipment,Processed",1)>
<cfset StructInsert(sReports,4,sReportElt,1)>

<cfloop index="ThisReport" list="#StructKeyList(sReports)#">
	<cfset thisFilePath = ExpandPath("#sReports[ThisReport].FileLocation#\#sReports[ThisReport].FileName#")>
	<cfif FileExists(thisFilePath)>
		<cffile action="read" file="#thisFilePath#" variable="orderCSVFile">
		<cfinvoke component="/com/utils/utils"
			method="CSVToQuery"
			returnVariable="qResult"
			CSV="#Trim(orderCSVFile)#">

		<cftransaction>
			<cfquery name="rp_OrderDelete" datasource="#APPLICATION.Data_DSN#">
				DELETE FROM #sReports[ThisReport].TableName#
			</cfquery>
			
			<cfloop query="qResult" startRow="2">
				<cfquery name="#sReports[ThisReport].TableName#_Insert" datasource="#APPLICATION.Data_DSN#">
					INSERT INTO #sReports[ThisReport].TableName# (#sReports[ThisReport].FieldLists#)
					VALUES	(
					<cfloop index="i" from="1" to="#listlen(sReports[ThisReport].FieldLists)#">
						<cfif i neq 1>,</cfif>
						<cfif ThisReport eq 2 and i eq 1>
							<cfqueryparam value="#dateformat(column_1,'mm-dd-yyyy')#"  cfsqltype="cf_sql_date">
						<cfelseif ThisReport eq 1 and i eq 1>
							<cfqueryparam value="#evaluate('column_#i#')#"  cfsqltype="cf_sql_varchar">
						<cfelse>
							<cfqueryparam value="#Val(evaluate('column_#i#'))#" cfsqltype="cf_sql_integer">
						</cfif>
					</cfloop>
					)
				</cfquery>
			</cfloop>
		</cftransaction>
	</cfif>
</cfloop>
	
Done