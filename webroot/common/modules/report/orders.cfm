<cfquery name="qryGetMonth" datasource="#APPLICATION.Data_DSN#">
	SELECT  month(Date) as Month, year(Date) year, date
	FROM rp_order order by date desc
</cfquery>

<cfquery name="qryGetMaxDate" datasource="#APPLICATION.Data_DSN#" maxrows="1">
	SELECT date as MaxDate
	FROM rp_order order by date desc
</cfquery>

<cfparam name="form.selectedMonth" default="#month(qryGetMaxDate.MaxDate)# #Year(qryGetMaxDate.MaxDate)#">
<cfparam name="FORM.SelectedWeek" default="">

<cfset thisMonth=listGetAt(form.selectedMonth, 1, " ")>
<cfset thisYear=listGetAt(form.selectedMonth, 2, " ")>
<cfset dtThisMonth=Fix(CreateDate(thisYear,thisMonth,1)) />
<cfset dtWeek=Week(dtThisMonth)>
<!--- <cfset dtLastDay=(DateAdd("m", 1, dtThisMonth) - 1) />
<cfset dtMonday=(dtLastDay - DayOfWeek(dtLastDay) + 2)>

<cfif (Month( dtMonday ) NEQ Month( dtThisMonth ))>
	<cfset dtMonday=(dtMonday - 7) />
</cfif>
 --->

<cfset SelectedDate=CreateDate(thisYear,thisMonth,1)>
<cfset aWeek=ArrayNew(1)>
<cfset aWeek[1]=DateAdd("d",1-DayOfWeek(SelectedDate),SelectedDate)>
<cfset aWeek[2]=DateAdd("d",7,aWeek[1])>
<cfset TempDate=aWeek[2]>
<cfset myVar="0">
<cfloop condition="myVar eq 0">
	<cfset TempDate=DateAdd("d",7,aWeek[ArrayLen(aWeek)])>
	<cfif month(TempDate) NEQ month(SelectedDate)>
		<cfset myVar="1">
	<cfelse>
		<cfset ArrayAppend(aWeek,TempDate)>
	</cfif>
</cfloop>


<article class="goalsProgess">
    <div class="inArt"> 
	<h1>Goals &amp; Progress</h1>
	<div class="selects">
		<div class="selectsLeft">
			<!--- <h3>Choose Month&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Choose Week</h3> --->
			<!--- 
			--->
			<form name="reportPeriodSelect" enctype="multipart/form-data" method="post" action="">
				<div class="ordersSLeft"><h3>Choose Month:</h3>
				
				<div id="orderMonths-fancy" class="fauxSelect">
					<div class="fauxOption">
					</div><img class="fauxArrow" src="/common/images/Intranet/template/fauxSelectArrow.png" />
				</div>
				
				<select id="selectedMonth"  name="selectedMonth" style="visibility:hidden">
					<cfoutput query="qryGetMonth" group="year">
						<cfoutput group="month">
							<cfset thisYear=qryGetMonth.Year>
							<cfset thisValue="#qryGetMonth.month# #qryGetMonth.year#">
							<cfset thisdisplayValue="#MonthAsString(qryGetMonth.month)# #qryGetMonth.year#">
							<option value="#thisValue#"<cfif form.selectedMonth eq thisValue >selected</cfif>>#thisdisplayValue#</option>
						</cfoutput>
					</cfoutput>
				</select>
				</div>
			</form>
			<form name="reportPeriodSelect" enctype="multipart/form-data" method="post" action="">
				<div class="ordersSRight">
				<h3>Choose week:</h3>
				<div id="orderWeeks-fancy" class="fauxSelect">
					<div class="fauxOption">
					</div><img class="fauxArrow" src="/common/images/Intranet/template/fauxSelectArrow.png" />
				</div> 
				<select id="selectedWeek" name="selectedWeek" style="visibility:hidden">
					<option value="">Whole Month</option>
					<cfloop index="i" from="1" to="#ArrayLen(aWeek)#" step="1">
						<cfoutput><option value="#DateFormat(aWeek[i],'mm/dd/yyyy')#" <cfif SelectedWeek IS DateFormat(aWeek[i],"mm/dd/yyyy")>selected</cfif>>Week #i#: #DateFormat(aWeek[i],"mmm d")#-#DateFormat(DateAdd("d",6,aWeek[i]),"mmm d")# </option></cfoutput>
					</cfloop>
				</select>
				</div>
			</form>
			
		</div>
	</div>
	<h3 class="subTitle">Orders</h3>
	<cfquery name="qryReport" datasource="#APPLICATION.Data_DSN#">
		SELECT	Date, Email, Fax, Phone, Cons, VIP, Promo
		FROM	rp_order
		<cfif FORM.SelectedWeek IS NOT "">
			where date between
			<cfqueryparam value="#SelectedWeek#" cfsqltype="cf_sql_date"> AND
			<cfqueryparam value="#DateAdd('d',6,SelectedWeek)#" cfsqltype="cf_sql_date">
		<cfelse>
			where month(date)=<cfqueryparam value="#month(SelectedDate)#" cfsqltype="cf_sql_integer"> and
			year(date)=<cfqueryparam value="#year(SelectedDate)#" cfsqltype="cf_sql_integer">
		</cfif>
		<!--- WHERE	order date between  --->
	</cfquery>
	<div class="goalProgressTableHolder">
		<table cellpadding="0" cellspacing="0" class="orders">
		<thead>
			<tr>
				<th>Date</th>
				<th># of<br>orders</th>
				<th>email</th>
				<th>fax</th>
				<th>phone</th>
				<th>cons</th>
				<th>vip</th>
				<th>promo/<br>lit</th>
			</tr>
		</thead>
		<tbody>
			<cfset emailTotal=0>
			<cfset faxTotal=0>
			<cfset phoneTotal=0>
			<cfset consTotal=0>
			<cfset VIPTotal=0>
			<cfset promoTotal=0>
			<cfset weeklyTotal=0>
			
			<cfoutput query="qryReport">
			<cfset order=qryReport.Email + qryReport.Fax + qryReport.Phone + qryReport.Cons + qryReport.VIP + qryReport.Promo>
			<cfset emailTotal=emailTotal + qryReport.Email>
			<cfset faxTotal=faxTotal + qryReport.Fax>
			<cfset phoneTotal=phoneTotal + qryReport.Phone>
			<cfset consTotal=consTotal + qryReport.Cons>
			<cfset VIPTotal=VIPTotal + qryReport.VIP>
			<cfset promoTotal=promoTotal + qryReport.Promo>
			<cfset weeklyTotal=weeklyTotal + order>
			
			<tr>
				<td>#dateformat(Date, "mm/dd/yyyy")#</td>
				<td>#NumberFormat(order,",")#</td>
				<td>#NumberFormat(qryReport.Email,",")#</td>
				<td>#NumberFormat(qryReport.Fax,",")#</td>
				<td>#NumberFormat(qryReport.Phone,",")#</td>
				<td>#NumberFormat(qryReport.Cons,",")#</td>
				<td>#NumberFormat(qryReport.VIP,",")#</td>
				<td>#NumberFormat(qryReport.Promo,",")#</td>
			</tr>
			</cfoutput>
		</tbody>
		<cfquery name="qryTotal" datasource="#APPLICATION.Data_DSN#">
			SELECT	SUM (Email+Fax+Phone+Cons+VIP+Promo) as total, SUM(Email) as emailTotalToYear
			,SUM(Fax) as FaxTotalToYear ,SUM(Phone) as PhoneTotalToYear, SUM(Cons) as ConsTotalToYear
			,SUM(VIP) as VIPTotalToYear ,SUM(Promo) as PromoTotalToYear
			FROM	rp_order
			WHERE	year(date)= <cfqueryparam value="#thisYear#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfoutput>
		<tfoot>
			<tr>
				<td><cfif FORM.SelectedWeek IS "">Month<cfelse>Week</cfif><br>Total</td>
				<td>#NumberFormat(weeklyTotal,",")#</td>
				<td>#NumberFormat(emailTotal,",")#</td>
				<td>#NumberFormat(faxTotal,",")#</td>
				<td>#NumberFormat(phoneTotal,",")#</td>
				<td>#NumberFormat(consTotal,",")#</td>
				<td>#NumberFormat(VIPTotal,",")#</td>
				<td>#NumberFormat(promoTotal,",")#</td>
			</tr>
														
			<tr>
				<td>Year to Date<br>total</td>
				<td>#NumberFormat(qryTotal.total,",")#</td>
				<td>#NumberFormat(qryTotal.emailTotalToYear,",")#</td>
				<td>#NumberFormat(qryTotal.FaxTotalToYear,",")#</td>
				<td>#NumberFormat(qryTotal.PhoneTotalToYear,",")#</td>
				<td>#NumberFormat(qryTotal.ConsTotalToYear,",")#</td>
				<td>#NumberFormat(qryTotal.VIPTotalToYear,",")#</td>
				<td>#NumberFormat(qryTotal.PromoTotalToYear,",")#</td>
			</tr>
			
			<tr>
				<td>line items<br>total</td>
				<td>#NumberFormat(qryTotal.total,",")#</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			</cfoutput>
		</tfoot>
		</table>
	</div>
</div>
</article>
<script type="text/javascript">
	optIDs=["selectedMonth","selectedWeek"];
	fauxOptIDs=["orderMonths-fancy","orderWeeks-fancy"];
	
	

	$(window).load(function () {
  		//
		fauxSelects.init();
	});
</script>