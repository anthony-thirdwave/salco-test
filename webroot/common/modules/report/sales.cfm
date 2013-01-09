<cfquery name="qryGetMonthMax" datasource="#application.DSN#" maxrows="1">
	SELECT	month, year, convert(varchar,year) + right('00'+convert(varchar,month),2) AS GroupDate
	FROM	rp_sales order by GroupDate desc
</cfquery>

<cfquery name="qryGetMonth" datasource="#application.DSN#">
	SELECT	month, year, convert(varchar,year) + right('00'+convert(varchar,month),2) AS GroupDate
	FROM	rp_sales order by GroupDate desc
</cfquery>

<cfparam name="form.selectedMonthYear" default="#qryGetMonthMax.month# #qryGetMonthMax.year#">
<cfset monthSelect = ListGetAt(form.selectedMonthYear, 1, " ")>
<cfset yearSelect = ListGetAt(form.selectedMonthYear, 2, " ")>
<cfset quarterSelect = Quarter(form.selectedMonthYear)>

<cfswitch expression="#quarterSelect#">
	<cfcase value="1">
		<cfset quarterMonthList = "1,2,3">
	</cfcase>
	<cfcase value="2">
		<cfset quarterMonthList = "4,5,6">
	</cfcase>
	<cfcase value="3">
		<cfset quarterMonthList = "7,8,9">
	</cfcase>
	<cfcase value="4">
		<cfset quarterMonthList = "10,11,12">
	</cfcase>
</cfswitch>

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

<cfquery name="AnnualSalesTotal" datasource="#application.DSN#">
	SELECT	Distinct AnnualSalesGoal
	FROM	rp_sales
	WHERE	year = <cfqueryparam value="#yearSelect#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="qryYearData" datasource="#application.DSN#">
	SELECT	Sum(ActualSales) as actualSalesTotal
	FROM	rp_sales
	WHERE	year = <cfqueryparam value="#yearSelect#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="qryQuterTotal" datasource="#application.DSN#">
	SELECT	Distinct QuarterlySalesGoal
	FROM	rp_sales
	WHERE	month in (<cfqueryparam value="#quarterMonthList#" cfsqltype="cf_sql_varchar" list="Yes">)
	AND		year = <cfqueryparam value="#yearSelect#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="qryQuterData" datasource="#application.DSN#">
	SELECT	Sum(ActualSales) as actualSalesTotal
	FROM	rp_sales
	WHERE	month in (<cfqueryparam value="#quarterMonthList#" cfsqltype="cf_sql_varchar" list="Yes">)
	AND		year = <cfqueryparam value="#yearSelect#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="qryMonthData" datasource="#application.DSN#">
	SELECT	Sum(MonthlySalesGoal) as MonthlySalesGoal,Sum(ActualSales) as actualSalesTotal
	FROM	rp_sales
	WHERE	month = <cfqueryparam value="#monthSelect#" cfsqltype="cf_sql_varchar">
	AND		year = <cfqueryparam value="#yearSelect#" cfsqltype="cf_sql_integer">
</cfquery>
<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script src="http://code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
<style>
    .ui-progressbar .ui-progressbar-value {
			background-image: url(/common/images/Intranet/template/pbar-ani.gif); 
	}
</style>

<article class="goalsProgess">
	 <div class="inArt"> 
	<h1>Goals &amp; Progress</h1>
	<div class="selects">
		<div class="selectsLeft">
			<h3>Choose Month</h3>
			<div id="orderMonths-fancy" class="fauxSelect">
				<div class="fauxOption">
				</div><img class="fauxArrow" src="/common/images/Intranet/template/fauxSelectArrow.png" />
			</div>
			<form name="reportPeriodSelect" enctype="multipart/form-data" method="post" action="">
				<select id="selectedMonthYear" style="/*margin-top:30px;*/ width:25px; margin-left:10px;" name="selectedMonthYear">
					<cfoutput query="qryGetMonth">
						<cfset thisMonth = MonthAsString(qryGetMonth.month)>
						<cfset thisYear = qryGetMonth.Year>
						<cfset thisValue = "#qryGetMonth.month# #qryGetMonth.year#">
					<option value="#thisValue#" <cfif form.selectedMonthYear eq thisValue>selected</cfif>>#thisMonth# #thisYear#</option>
					</cfoutput>
				</select>
			</form>
		</div>
	</div>
	<h3 class="subTitle">Sales</h3>
	<div class="goalProgressTableHolder">
		<table cellpadding="0" cellspacing="0" class="accuracy">
			<thead>
				<th>ANNUAL SALES GOAL: $<cfoutput>#NumberFormat(AnnualSalesTotal.AnnualSalesGoal,",")#</cfoutput></th>
			</thead>
			<tbody>
				<tr>
					<td>
						<cfset annualPercentage = Val(qryYearData.actualSalesTotal) / Val(AnnualSalesTotal.AnnualSalesGoal) * 100 >
						<div class="tileHolderSmall">
							<div class="miniTile">
								<div class="percentageLrg"><cfoutput>#NumberFormat(annualPercentage,'_____.__')#</cfoutput></div>
								$<cfoutput>#NumberFormat(qryYearData.actualSalesTotal,",")#</cfoutput>
							</div>
						</div>
					</td>
				</tr>
				<script>
					$(document).ready(function() {
						<cfoutput>
						$("##progressbarannualPercentage").progressbar({value:#annualPercentage#})
						</cfoutput>
					});
				</script>
				<tr>
					<td>
						<div id="progressbarannualPercentage"></div>
					</td>
				</tr>
			</table>
		</table>
	</div>
	<div class="goalProgressTableHolder">
		<table cellpadding="0" cellspacing="0" class="accuracy">
			<thead>
				<th>QUARTERLY SALES GOAL: $<cfoutput>#NumberFormat(qryQuterTotal.QuarterlySalesGoal,",")#</cfoutput></th>
			</thead>
			<tbody>
				<tr>
					<td>
						<cfset quarterPercentage = (qryQuterData.actualSalesTotal / qryQuterTotal.QuarterlySalesGoal) * 100 >
						<div class="tileHolderSmall">
							<div class="miniTile">
								<div class="percentageLrg"><cfoutput>#NumberFormat(quarterPercentage,'_____.__')#</cfoutput></div>
								$<cfoutput>#NumberFormat(qryQuterData.actualSalesTotal,",")#</cfoutput>
							</div>
						</div>
					</td>
				</tr>
				<script>
					$(document).ready(function() {
						<cfoutput>
						$("##progressbarquarterPercentage").progressbar({value:#quarterPercentage#})
						</cfoutput>
					});
				</script>
				<tr>
					<td>
						<div id="progressbarquarterPercentage"></div>
					</td>
				</tr>
			</table>
		</table>
	</div>
	<div class="goalProgressTableHolder">
		<table cellpadding="0" cellspacing="0" class="accuracy">
			<thead>
				<th>MONTHLY SALES GOAL: $<cfoutput>#NumberFormat(qryMonthData.MonthlySalesGoal,",")#</cfoutput></th>
			</thead>
			<tbody>
				<tr>
					<td>
						<cfset monthPercentage = (qryMonthData.actualSalesTotal / qryMonthData.MonthlySalesGoal) * 100 >
						<div class="tileHolderSmall">
							<div class="miniTile">
								<div class="percentageLrg"><cfoutput>#NumberFormat(monthPercentage,'_____.__')#</cfoutput></div>
								$<cfoutput>#NumberFormat(qryMonthData.actualSalesTotal,",")#</cfoutput>
							</div>
						</div>
					</td>
				</tr>
				<script>
					$(document).ready(function() {
						<cfoutput>
						$("##progressbarmonthPercentage").progressbar({value:#monthPercentage#})
						</cfoutput>
					});
				</script>
				<tr>
					<td>
						<div id="progressbarmonthPercentage"></div>
					</td>
				</tr>
			</table>
		</table>
	</div>
</article>