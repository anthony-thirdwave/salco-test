
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

<style>
	article.goalsProgess .goalProgressTableHolder table.accuracy tr th.table-header-small {
		padding: 0 10px;
		padding-bottom: 12px;
		font-size: 12px;
	}
</style>

<cfquery name="qryQuarter" datasource="#APPLICATION.Data_DSN#">
	SELECT	quarter,
	convert (varchar(4),2000+convert(int,right([quarter],2))) +
	case left([quarter],3) 
	when 'Jan' then 'Q1'
	when 'Apr' then 'Q2'
	when 'Jul' then 'Q3'
	when 'Oct' then 'Q4'
	end as QuarterLabel,
	2000+convert(int,right([quarter],2)) as quarterYear,
	case left([quarter],3) 
		when 'Jan' then 'Q1'
		when 'Apr' then 'Q2'
		when 'Jul' then 'Q3'
		when 'Oct' then 'Q4'
		end as quarterNum
	FROM	rp_ordershipmentAccuracy
	where TotalOrders > <cfqueryparam value="0" cfsqltype="cf_sql_numeric">
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
	SELECT TotalOrders AS totalOrder
	FROM	qryData
</cfquery>

<!--- <cfquery name="qryRMA" dbtype="query">
	SELECT SUM(RMACount) AS totalRMA
	FROM	qryData
</cfquery> --->

<cfquery name="qryIncidentCount" dbtype="query">
	SELECT IncidentCount AS totalIncidents
	FROM	qryData
</cfquery>


<cfquery name="qryInAccurateDataYTD" dbtype="query">
	SELECT SUM(
		+ DeliveryDamW
		+ DeliveryDamWO
		+ DocumentationW
		+ DocumentationWO
		+ HardDataEntryW
		+ HardDataEntryWO
		+ LateDeliveryW
		+ LateDeliveryWO
		+ NonconformingW
		+ NonconformingWO
		+ OrderEntryErrorW
		+ OrderEntryErrorWO
		+ PoorCommW
		+ PoorCommWO
		+ ProductMarkingW
		+ ProductMarkingWO
		+ SalcoWebsiteW
		+ SalcoWebsiteWO
		+ ShippingPackagingW
		+ ShippingPackagingWO
		+ VendorWebsiteW
		+ VendorWebsiteWO
		+ WrongLocationW
		+ WrongLocationWO
		+ WrongProductW
		+ WrongProductWO
		+ WrongQuantityW
		+ WrongQuantityWO) AS total
	FROM	qryDataYTD
</cfquery>

<cfif qryIncidentCount.totalIncidents gt 0 and qryOrderYTD.totalOrder gt 0>
	<cfset Accuracy=100 * (1 - ( (qryIncidentCount.totalIncidents)/qryOrderYTD.totalOrder))>
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
			<h4>Accuracy</h4>
			<div class="percentageLrg">#NumberFormat(Accuracy,'_____.__')#</div>
		</div>
		
		<div class="miniTile">
			<h4>Number of <br>
				Orders</h4>
			<div>#NumberFormat(qryOrder.totalOrder,",")#</div>
		</div>
		
		<div class="miniTile shortenTile">
			<h4>Number of <br> Incidents</h4>
			<div class="botLeft">#NumberFormat(qryIncidentCount.totalIncidents, ",")#<br>&nbsp;</div>
		</div>
	
	</div>
	</cfoutput>
	<div class="goalProgressTableHolder">
		<table cellpadding="0" cellspacing="0" class="accuracy">
		<thead>
			<tr>
				<th>Category</th>
				<th>Total</th>
				<th class="table-header-small">With material return</th>
				<th class="table-header-small">Without material return</th>
			</tr>
		</thead>
		<cfoutput>
		<tbody>
			<cfquery name="qryDamaged" dbtype="query">
				SELECT SUM(DeliveryDamW + DeliveryDamWO) AS total
					, SUM(DeliveryDamW) as with, SUM(DeliveryDamWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Delivery Damage </td>
				<td>#qryDamaged.total#</td>
				<td>#qryDamaged.with#</td>
				<td>#qryDamaged.without#</td>
			</tr>

			<cfquery name="qryDocumentation" dbtype="query">
				SELECT SUM(DocumentationW + DocumentationWO) AS total
					, SUM(DocumentationW) as with, SUM(DocumentationWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Documentation Wrong/Missing </td>
				<td>#qryDocumentation.total#</td>
				<td>#qryDocumentation.with#</td>
				<td>#qryDocumentation.without#</td>
			</tr>

			<cfquery name="qryHardDataEntry" dbtype="query">
				SELECT SUM(HardDataEntryW + HardDataEntryWO) AS total
					, SUM(DocumentationW) as with, SUM(DocumentationWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Hard Data Entry Error </td>
				<td>#qryHardDataEntry.total#</td>
				<td>#qryHardDataEntry.with#</td>
				<td>#qryHardDataEntry.without#</td>
			</tr>

			<cfquery name="qryLateDelivery" dbtype="query">
				SELECT SUM(LateDeliveryW + LateDeliveryWO) AS total
					, SUM(LateDeliveryW) as with, SUM(LateDeliveryWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Late Delivery </td>
				<td>#qryLateDelivery.total#</td>
				<td>#qryLateDelivery.with#</td>
				<td>#qryLateDelivery.without#</td>
			</tr>

			<cfquery name="qryNonconforming" dbtype="query">
				SELECT SUM(NonconformingW + NonconformingWO) AS total
					, SUM(NonconformingW) as with, SUM(NonconformingWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Nonconforming Product </td>
				<td>#qryNonconforming.total#</td>
				<td>#qryNonconforming.with#</td>
				<td>#qryNonconforming.without#</td>
			</tr>

			<cfquery name="qryOrderEntryError" dbtype="query">
				SELECT SUM(OrderEntryErrorW + OrderEntryErrorWO) AS total
					, SUM(OrderEntryErrorW) as with, SUM(OrderEntryErrorWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Order Entry Error </td>
				<td>#qryOrderEntryError.total#</td>
				<td>#qryOrderEntryError.with#</td>
				<td>#qryOrderEntryError.without#</td>
			</tr>

			<cfquery name="qryPoorComm" dbtype="query">
				SELECT SUM(PoorCommW + PoorCommWO) AS total
					, SUM(PoorCommW) as with, SUM(PoorCommWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Poor Communication/Responsivness </td>
				<td>#qryPoorComm.total#</td>
				<td>#qryPoorComm.with#</td>
				<td>#qryPoorComm.without#</td>
			</tr>

			<cfquery name="qryProductMarking" dbtype="query">
				SELECT SUM(ProductMarkingW + ProductMarkingWO) AS total
					, SUM(ProductMarkingW) as with, SUM(ProductMarkingWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Product Marking Wrong/Missing </td>
				<td>#qryProductMarking.total#</td>
				<td>#qryProductMarking.with#</td>
				<td>#qryProductMarking.without#</td>
			</tr>

			<cfquery name="qryHardDataEntry" dbtype="query">
				SELECT SUM(HardDataEntryW + HardDataEntryWO) AS total
					, SUM(HardDataEntryW) as with, SUM(HardDataEntryWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Salco Website Problem </td>
				<td>#qryHardDataEntry.total#</td>
				<td>#qryHardDataEntry.with#</td>
				<td>#qryHardDataEntry.without#</td>
			</tr>

			<cfquery name="qryShippingPackaging" dbtype="query">
				SELECT SUM(ShippingPackagingW + ShippingPackagingWO) AS total
					, SUM(ShippingPackagingW) as with, SUM(ShippingPackagingWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Shipping Packaging Issue </td>
				<td>#qryShippingPackaging.total#</td>
				<td>#qryShippingPackaging.with#</td>
				<td>#qryShippingPackaging.without#</td>
			</tr>

			<cfquery name="qryVendorWebsite" dbtype="query">
				SELECT SUM(VendorWebsiteW + VendorWebsiteWO) AS total
					, SUM(VendorWebsiteW) as with, SUM(VendorWebsiteWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Vendor Website Problem </td>
				<td>#qryVendorWebsite.total#</td>
				<td>#qryVendorWebsite.with#</td>
				<td>#qryVendorWebsite.without#</td>
			</tr>

			<cfquery name="qryWrongLocation" dbtype="query">
				SELECT SUM(WrongLocationW + WrongLocationWO) AS total
					, SUM(WrongLocationW) as with, SUM(WrongLocationWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Wrong Location </td>
				<td>#qryWrongLocation.total#</td>
				<td>#qryWrongLocation.with#</td>
				<td>#qryWrongLocation.without#</td>
			</tr>

			<cfquery name="qryWrongProduct" dbtype="query">
				SELECT SUM(WrongProductW + WrongProductWO) AS total
					, SUM(WrongProductW) as with, SUM(WrongProductWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Wrong Product </td>
				<td>#qryWrongProduct.total#</td>
				<td>#qryWrongProduct.with#</td>
				<td>#qryWrongProduct.without#</td>
			</tr>

			<cfquery name="qryWrongQuantity" dbtype="query">
				SELECT SUM(WrongQuantityW + WrongQuantityWO) AS total
					, SUM(WrongQuantityW) as with, SUM(WrongQuantityWO) as without
				FROM	qryData
			</cfquery>
			<tr>
				<td>Wrong Quantity </td>
				<td>#qryWrongQuantity.total#</td>
				<td>#qryWrongQuantity.with#</td>
				<td>#qryWrongQuantity.without#</td>
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