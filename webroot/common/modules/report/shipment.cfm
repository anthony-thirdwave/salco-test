<cfquery name="qryGetMonthMax" datasource="#APPLICATION.Data_DSN#" maxrows="1">
	SELECT	month, year, convert(varchar,year) + right('00'+convert(varchar,month),2) AS GroupDate
	FROM	rp_sales order by GroupDate desc
</cfquery>

<cfparam name="form.selectedMonthYear" default="#qryGetMonthMax.month# #qryGetMonthMax.Year#">
<cfset selectedYear=ListGetAt (form.selectedMonthYear, 2, " ")>
<cfset selectedMonth=ListGetAt (form.selectedMonthYear, 1, " ")>

<cfquery name="qryGetMonth" datasource="#APPLICATION.Data_DSN#">
	SELECT	distinct month, year
	FROM	rp_shipment
</cfquery>
<cfquery name="qryData" datasource="#APPLICATION.Data_DSN#">
	SELECT	*
	FROM	rp_shipment
	WHERE	year=<cfqueryparam value="#selectedYear#" cfsqltype="cf_sql_integer">
	AND		month=<cfqueryparam value="#selectedMonth#" cfsqltype="cf_sql_integer">
	<!--- AND		week=<cfqueryparam value="#selectedWeek#" cfsqltype="cf_sql_integer"> --->
</cfquery>

<cfquery name="getAmount" dbtype="query">
	select SUM(shipment) as shipmentTotal, SUM(Processed) as processedTotal
	FROM	qryData
</cfquery>

<cfquery name="qryAnnualshipment" datasource="#APPLICATION.Data_DSN#">
	SELECT	SUM(shipment) as shipmentByMonth, SUBSTRING('JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (month * 4) - 3, 3) as dmonth
	FROM	rp_shipment
	WHERE	year=<cfqueryparam value="#selectedYear#" cfsqltype="cf_sql_integer">
	Group  By month
	Order by month
</cfquery>
<cfquery name="qryAnnualProcessed" datasource="#APPLICATION.Data_DSN#">
	SELECT	SUM(Processed) as ProcessedByMonth, SUBSTRING('JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (month * 4) - 3, 3) as dmonth
	FROM	rp_shipment
	WHERE	year=<cfqueryparam value="#selectedYear#" cfsqltype="cf_sql_integer">
	Group  By month
	Order by month
</cfquery>

<cfquery name="qryMaxAnnualShipment" dbtype="query">
	select max(shipmentByMonth) as MaxAnnualShipment from qryAnnualshipment
</cfquery>

<script type="text/javascript">
	optIDs=["selectedMonthYear"];
	fauxOptIDs=["orderMonths-fancy"];

	$(window).load(function () {
  		//
		fauxSelects.init();
	});
</script>
<script type="text/javascript">
$(document).ready(function(){
   $('#selectedMonthYear').change(function(){
      $(this).closest("form").submit();
    });
});
</script>
<article class="goalsProgess">
    <div class="inArt"> 
	<h1>Goals &amp; Progress</h1>
	<div class="selects">
		<div class="selectsLeft quarters">
			<h3>Choose a month</h3>
			<div class="fauxSelect" id="orderMonths-fancy">
				<div class="fauxOption">
					
				</div><img src="/common/images/Intranet/template/fauxSelectArrow.png" class="fauxArrow">
			</div>
			<form name="reportPeriodSelect" enctype="multipart/form-data" method="post" action="">
				<select id="selectedMonthYear" style="/*margin-top:30px;*/ width:25px; margin-left:10px;" name="selectedMonthYear">
						<cfoutput query="qryGetMonth">
							<cfset thisMonth=MonthAsString(qryGetMonth.month)>
							<cfset thisYear=qryGetMonth.Year>
							<cfset thisValue="#qryGetMonth.month# #qryGetMonth.year#">
						<option value="#thisValue#"<cfif form.selectedMonthYear eq thisValue >selected</cfif>>#thisMonth# #thisYear#</option>
						</cfoutput>
				</select>
			</form>
		</div>
	</div>
	<h3 class="subTitle">Shipments</h3>
	<div class="tileHolderSmall">
		<div class="miniTile">
			<h4>Number of <br>Shipments</h4>
			<div><cfoutput>#NumberFormat(getAmount.ShipmentTotal,",")#</cfoutput></div>
		</div>
		
		<div class="miniTile">
			<h4>Number of <br>
				Packages Processed</h4>
			<div><cfoutput>#NumberFormat(getAmount.ProcessedTotal,",")#</cfoutput></div>
		</div>
	</div>
	<div class="goalProgressTableHolder">
	<table cellpadding="0" cellspacing="0" class="accuracy">
		<thead>
			<tr><th>NUMBER OF SHIPMENTS</th></tr>
		</thead>
		<tbody>
			<tr>
				<td>
				<cfchart showborder="no" chartHeight="300" chartWidth="400" backgroundColor="##ffffff"
					showLegend="Yes" scaleTo="#Val(qryMaxAnnualShipment.MaxAnnualShipment)+500#">
					<cfchartseries 
						type="line"
						markerStyle="circle" 
						paintStyle="light" 
						query="qryAnnualShipment" 
						itemcolumn="dmonth" 
						valuecolumn="shipmentByMonth"
						seriesLabel="Shipments">
					<cfchartseries 
						type="line" 
						markerStyle="circle" 
						paintStyle="light" 
						query="qryAnnualProcessed" 
						itemcolumn="dmonth" 
						valuecolumn="ProcessedByMonth"
						seriesLabel="Processed">
				</cfchart>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
</div>
</article>