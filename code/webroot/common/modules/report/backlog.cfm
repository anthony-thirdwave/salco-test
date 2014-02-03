<cfset StartDate=CreateDate(Year(now()),month(now()),1)>
<cfset EndDate=DateAdd("yyyy",1,StartDate)>

<cfquery name="qryGetMonth" datasource="#APPLICATION.Data_DSN#">
	SELECT	distinct month, year
	FROM	rp_backlog order by year desc, month desc
</cfquery>

<cfquery name="qryValuePrime" datasource="#APPLICATION.Data_DSN#" maxrows="12">
	SELECT	SUM(value) as valueByMonth, month, year,
	SUBSTRING('JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC ', (month * 4) - 3, 3) + ' ' + convert(varchar,year) as dmonth,
	convert(varchar,year) + right('00'+convert(varchar,month),2) AS GroupDate
	FROM	rp_backlog
	Group By month, year
	Order by year desc, month desc
</cfquery>

<cfquery name="qryValue" dbtype="query">
	select * from qryValuePrime 
	WHERE	
	GroupDate >= '#year(StartDate)##NumberFormat(month(StartDate),'00')#' and
	GroupDate <= '#year(EndDate)##NumberFormat(month(EndDate),'00')#'
	order by [year], [month]
</cfquery>

<cfquery name="qryMaxValue" dbtype="query">
	select max(valueByMonth) as MaxValueByMonth from qryValue
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
	<h3 class="subTitle">Booked Sales</h3>
	<div class="goalProgressTableHolder">
	<table cellpadding="0" cellspacing="0" class="accuracy">
		<thead>
			<tr><th>Booked Sales</th></tr>
		</thead>
		<tbody>
			<tr>
				<td>
				<cfchart showborder="no" chartHeight="300" chartWidth="400" backgroundColor="##ffffff"
					scaleTo="#Val(qryMaxValue.MaxValueByMonth)+100000#" labelFormat="currency">
					<cfchartseries 
						type="bar"
						paintStyle="light" 
						query="qryValue" 
						itemcolumn="dMonth" 
						valuecolumn="valueByMonth"
						seriesLabel="Backlog">
				</cfchart>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
</div>
<cfquery name="GetLastUpdated" datasource="#APPLICATION.Data_DSN#">
	Select DateTimeLastUpdated from rp_status where reportid=5
</cfquery>
<cfif IsDate(GetLastUpdated.DateTimeLastUpdated)>
	<p align="center"><small style="font-size:x-small;"><cfoutput>Last Updated: #DateFormat(GetLastUpdated.DateTimeLastUpdated,"long")# #TimeFormat(GetLastUpdated.DateTimeLastUpdated)#</cfoutput></small></p>
</cfif>
</article>