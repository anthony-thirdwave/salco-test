
<!--- <cfparam name="form.quarterSelect" default="#Quarter(now())#,#Year(now())#">
<cfset form.quarterSelect=Replace(form.quarterSelect,",","_","all")>

<cfset selectedquarter=ListGetAt (form.quarterSelect, 1, "_")>
<cfset selectedYear=ListGetAt (form.quarterSelect, 2, "_")>

<cfswitch expression="#selectedquarter#">
	<cfcase value="1">
		<cfset monthList="1,2,3">
	</cfcase>
	<cfcase value="2">
		<cfset monthList="4,5,6">
	</cfcase>
	<cfcase value="3">
		<cfset monthList="7,8,9">
	</cfcase>
	<cfcase value="4">
		<cfset monthList="10,11,12">
	</cfcase>
</cfswitch> --->

<script type="text/javascript">
	optIDs=["ordersMonth"];
	fauxOptIDs=["orderMonths-fancy"];

	$(window).load(function () {
  		//
		fauxSelects.init();
	});
</script>
<script type="text/javascript">
$(document).ready(function(){
   $('#ordersMonth').change(function(){
      $(this).closest("form").submit();
    });
});
</script>
<cfquery name="qryQuarter" datasource="#APPLICATION.Data_DSN#">
	SELECT	quarter,
	convert (varchar(4),2000+convert(int,right([quarter],2))) +
	case left([quarter],3) 
	when 'Jan' then 'Q1'
	when 'Apr' then 'Q2'
	when 'Aul' then 'Q3'
	when 'Oct' then 'Q4'
	end as QuarterLabel,
	2000+convert(int,right([quarter],2)) as quarterYear,
	case left([quarter],3) 
		when 'Jan' then 'Q1'
		when 'Apr' then 'Q2'
		when 'Aul' then 'Q3'
		when 'Oct' then 'Q4'
		end as quarterNum
	FROM	rp_ordershipmentAccuracy
	order by quarterYear desc, quarterNum desc
</cfquery>
<cfparam name="form.quarterSelect" default="#qryQuarter.Quarter#">

<cfquery name="qryData" datasource="#APPLICATION.Data_DSN#">
	SELECT	*
	FROM	rp_ordershipmentAccuracy
	WHERE	Quarter=<cfqueryparam value="#form.quarterSelect#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfquery name="qryDataYTD" datasource="#APPLICATION.Data_DSN#">
	SELECT	*
	FROM	rp_ordershipmentAccuracy
	WHERE	Quarter=<cfqueryparam value="#form.quarterSelect#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="qryOrderYTD" dbtype="query">
	SELECT SUM(TotalOrders) AS totalOrder
	FROM	qryDataYTD
</cfquery>

<cfquery name="qryOrder" dbtype="query">
	SELECT SUM(TotalOrders) AS totalOrder
	FROM	qryData
</cfquery>
<cfquery name="qryRMA" dbtype="query">
	SELECT SUM(RMACount) AS totalRMA
	FROM	qryData
</cfquery>
<cfquery name="qryInquires" dbtype="query">
	SELECT SUM(InquiryCount) AS totalInquires
	FROM	qryData
</cfquery>

<cfquery name="qryInAccurateDataYTD" dbtype="query">
	SELECT SUM(CustomerOrderedWrongPartTotalsIllinois
		+ CustomerOrderedWrongPartTotalsTexas
		+ DamagedDefectiveTotalsIllinois
		+ DamagedDefectiveTotalsTexas
		+ DataEntryErrorTotalsIllinois
		+ DataEntryErrorTotalsTexas
		+ DuplicateOrderTotalsIllinois
		+ DuplicateOrderTotalsTexas
		+ EngineeringIssueTotals
		+ PartExchangeTotals
		+ PartsNoLongerNeededTotals
		+ PickingErrorTotalsIllinois
		+ PickingErrorTotalsTexas
		+ ProductionErrorTotalsIllinois
		+ ProductionErrorTotalsTexas
		+ PurchasingErrorTotalsIllinois
		+ PurchasingErrorTotalsTexas
		+ QualifiedWrongPartTotalsIllinois
		+ QualifiedWrongPartTotalsTexas
		+ TrialPartTotals
		+ VendorErrorTotalsIllinois
		+ VendorErrorTotalsTexas
		+ QualityIssueTotalsIllinois
		+ QualityIssueTotalsTexas
		+ InventoryControlTotalsIllinois
		+ InventoryControlTotalsTexas) AS total
	FROM	qryDataYTD
</cfquery>

<cfif qryInAccurateDataYTD.total gt 0 and qryOrderYTD.totalOrder gt 0>
	<cfset Accuracy=100 * (1 - ( qryInAccurateDataYTD.total/qryOrderYTD.totalOrder))>
<cfelse>
	<cfset Accuracy=0>
</cfif>



<article class="goalsProgess">
    <div class="inArt"> 
	<h1>Goals &amp; Progress</h1>
	<div class="selects">
		<div class="selectsLeft quarters">
			<h3>Choose a Quarter</h3>
			<div id="orderMonths-fancy" class="fauxSelect">
				<div class="fauxOption">
					
				</div><img class="fauxArrow" src="/common/images/Intranet/template/fauxSelectArrow.png" />
			
			<form name="reportPeriodSelect" enctype="multipart/form-data" method="post" action="">
				<select id="ordersMonth" style="/*margin-top:30px;*/ width:25px; margin-left:10px;" name="quarterSelect">
					<cfloop query="qryQuarter">
						<cfoutput>
						<option value="#qryQuarter.Quarter#"<cfif form.quarterSelect eq Quarter>select</cfif>>#Quarter#</option>
						</cfoutput>
					</cfloop>
				</select>
			</form>
			</div>
		</div>
	</div>
	<h3 class="subTitle">Order/Shipment Accuracy</h3>
	<cfoutput>
	<div class="tileHolderSmall">
		<div class="miniTile">
			<h4>Accuracy (YTD)</h4>
			<div class="percentageLrg">#NumberFormat(Accuracy,'_____.__')#</div>
		</div>
		
		<div class="miniTile">
			<h4>Number of <br>
				Orders</h4>
			<div>#NumberFormat(qryOrder.totalOrder,",")#</div>
		</div>
		
		<div class="miniTile shortenTile">
			<h4>Number of <br>
				RMA's &amp; Inquiries</h4>
			<div class="botLeft">#NumberFormat(qryRMA.totalRMA,",")#<br>RMA's</div>
			<div class="botLeft">#NumberFormat(qryInquires.totalInquires,",")#<br>Inquires</div>
		</div>
	
	</div>
	</cfoutput>
	<div class="goalProgressTableHolder">
		<table cellpadding="0" cellspacing="0" class="accuracy">
		<thead>
			<tr>
				<th>Category</th>
				<th>Total</th>
				<th>Illinois</th>
				<th>Tomball</th>
			</tr>
		</thead>
		<cfoutput>
		<tbody>
			<cfquery name="qryCustomerOrderWrongPart" dbtype="query">
				SELECT SUM(CustomerOrderedWrongPartTotalsIllinois + CustomerOrderedWrongPartTotalsTexas) AS total
						, SUM(CustomerOrderedWrongPartTotalsIllinois) as Illinois, SUM(CustomerOrderedWrongPartTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>CUSTOMER ORDERED WRONG PART TOTALS</td>
				<td>#NumberFormat(qryCustomerOrderWrongPart.total,",")#</td>
				<td>#NumberFormat(qryCustomerOrderWrongPart.Illinois,",")#</td>
				<td>#NumberFormat(qryCustomerOrderWrongPart.Tomball,",")#</td>
			</tr>
			<cfquery name="qryDamaged" dbtype="query">
				SELECT SUM(DamagedDefectiveTotalsIllinois + DamagedDefectiveTotalsTexas) AS total
					, SUM(DamagedDefectiveTotalsIllinois) as Illinois, SUM(DamagedDefectiveTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>DAMAGED/DEFECTIVE TOTALS</td>
				<td>#qryDamaged.total#</td>
				<td>#qryDamaged.Illinois#</td>
				<td>#qryDamaged.Tomball#</td>
			</tr>
			<cfquery name="qryDataEntryError" dbtype="query">
				SELECT SUM(DataEntryErrorTotalsIllinois + DataEntryErrorTotalsTexas) AS total
				, SUM(DataEntryErrorTotalsIllinois) as Illinois, SUM(DataEntryErrorTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>DATA ENTRY ERROR TOTALS</td>
				<td>#qryDataEntryError.total#</td>
				<td>#qryDataEntryError.Illinois#</td>
				<td>#qryDataEntryError.Tomball#</td>
			</tr>
			<cfquery name="qryDuplicateOrder" dbtype="query">
				SELECT SUM(DuplicateOrderTotalsIllinois + DuplicateOrderTotalsTexas) AS total
				, SUM(DuplicateOrderTotalsIllinois) as Illinois, SUM(DuplicateOrderTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>DUPLICATE ORDER TOTALS</td>
				<td>#qryDuplicateOrder.total#</td>
				<td>#qryDuplicateOrder.Illinois#</td>
				<td>#qryDuplicateOrder.Tomball#</td>
			</tr>
			<tr>
				<td>ENGINEERING ISSUE</td>
				<td>#qryData.EngineeringIssueTotals#</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td>PART EXCHANGE</td>
				<td>#qryData.PartExchangeTotals#</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td>PARTS NO LONGER NEEDED</td>
				<td>#qryData.PartsNoLongerNeededTotals#</td>
				<td></td>
				<td></td>
			</tr>
			<cfquery name="qryPickingError" dbtype="query">
				SELECT SUM(PickingErrorTotalsIllinois + PickingErrorTotalsTexas) AS total
				, SUM(PickingErrorTotalsIllinois) as Illinois, SUM(PickingErrorTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>PICKING ERROR TOTALS</td>
				<td>#qryPickingError.total#</td>
				<td>#qryPickingError.Illinois#</td>
				<td>#qryPickingError.Tomball#</td>
			</tr>
			<cfquery name="qryProductionError" dbtype="query">
				SELECT SUM(ProductionErrorTotalsIllinois + ProductionErrorTotalsTexas) AS total
				, SUM(ProductionErrorTotalsIllinois) as Illinois, SUM(ProductionErrorTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>PRODUCTION ERROR TOTALS</td>
				<td>#qryProductionError.total#</td>
				<td>#qryProductionError.Illinois#</td>
				<td>#qryProductionError.Tomball#</td>
			</tr>
			<cfquery name="qryPurchasingError" dbtype="query">
				SELECT SUM(PurchasingErrorTotalsIllinois + PurchasingErrorTotalsTexas) AS total
				, SUM(PurchasingErrorTotalsIllinois) as Illinois, SUM(PurchasingErrorTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>PURCHASING ERROR TOTALS</td>
				<td>#qryPurchasingError.total#</td>
				<td>#qryPurchasingError.Illinois#</td>
				<td>#qryPurchasingError.Tomball#</td>
			</tr>
			<cfquery name="qryQualifiedWrongParts" dbtype="query">
				SELECT SUM(QualifiedWrongPartTotalsIllinois + QualifiedWrongPartTotalsTexas) AS total
				, SUM(QualifiedWrongPartTotalsIllinois) as Illinois, SUM(QualifiedWrongPartTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>QUALIFIED WRONG PART TOTALS</td>
				<td>#qryQualifiedWrongParts.total#</td>
				<td>#qryQualifiedWrongParts.Illinois#</td>
				<td>#qryQualifiedWrongParts.Tomball#</td>
			</tr>
			<tr>
				<td>TRIAL PART</td>
				<td>#qryData.TrialPartTotals#</td>
				<td></td>
				<td></td>
			</tr>
			<cfquery name="qryVendorError" dbtype="query">
				SELECT SUM(VendorErrorTotalsIllinois + VendorErrorTotalsTexas) AS total
				, SUM(VendorErrorTotalsIllinois) as Illinois, SUM(VendorErrorTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>VENDOR ERROR TOTALS</td>
				<td>#qryVendorError.total#</td>
				<td>#qryVendorError.Illinois#</td>
				<td>#qryVendorError.Tomball#</td>
			</tr>
			<cfquery name="qryQualityIssue" dbtype="query">
				SELECT SUM(QualityIssueTotalsIllinois + QualityIssueTotalsTexas) AS total
				, SUM(QualityIssueTotalsIllinois) as Illinois, SUM(QualityIssueTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>QUALITY ISSUE TOTALS</td>
				<td>#qryQualityIssue.total#</td>
				<td>#qryQualityIssue.Illinois#</td>
				<td>#qryQualityIssue.Tomball#</td>
			</tr>
			
			<cfquery name="qryInventoryControl" dbtype="query">
				SELECT SUM(InventoryControlTotalsIllinois + InventoryControlTotalsTexas) AS total
				, SUM(InventoryControlTotalsIllinois) as Illinois, SUM(InventoryControlTotalsTexas) as Tomball
				FROM	qryData
			</cfquery>
			<tr>
				<td>INVENTORY CONTROL TOTALS</td>
				<td>#qryInventoryControl.total#</td>
				<td>#qryInventoryControl.Illinois#</td>
				<td>#qryInventoryControl.Tomball#</td>
			</tr>
			</cfoutput>
		</tbody>
		
		</table>
		</div>
	</div>

	<cfquery name="GetLastUpdated" datasource="#APPLICATION.Data_DSN#">
		Select DateTimeLastUpdated from rp_status where reportid=1
	</cfquery>
	<cfif IsDate(GetLastUpdated.DateTimeLastUpdated)>
		<p align="center"><small style="font-size:x-small;"><cfoutput>Last Updated: #DateFormat(GetLastUpdated.DateTimeLastUpdated,"long")# #TimeFormat(GetLastUpdated.DateTimeLastUpdated)#</cfoutput></small></p>
	</cfif>
</article>
