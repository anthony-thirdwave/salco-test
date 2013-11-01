<cfparam name="ATTRIBUTES.Mode" default="Default">

<cfparam name="ProductName" default="">
<cfparam name="PartNumber" default="">
<cfparam name="ProductFamilyName" default="">
<cfparam name="Description" default="">

<cfif IsDefined("URL.searchTxt") and URL.searchTxt IS NOT "">
	<cfset ProductName=URL.searchTxt>
</cfif>

<script>
	function ExportToExcel() {
		var mygrid = ColdFusion.Grid.getGridObject('productReport');
		//var mydata = mygrid.getDataSource();	//For Coldfusion 8
		var mydata = mygrid.getStore();		 //For Coldfusion 9
		var params = mydata.lastOptions.params;
		var PName = document.productSearchForm.ProductName.value;
		var PNumber = document.productSearchForm.PartNumber.value;
		var PFamilyName = document.productSearchForm.ProductFamilyName.value;
		var PDescription = document.productSearchForm.Description.value;
		var sort = params.sort;
		var dir = params.dir;
		var page = params.start/params.limit+1;
		var pageSize = params.limit;
		var totalRecord = mydata.totalLength;
		window.location = '/common/modules/product/ProductExport.cfm?page='+page+'&sort='+sort+'&dir='+dir+'&pagesize='+pageSize+'&PName='+PName+'&PNumber='+PNumber+'&PFamilyName='+PFamilyName+'&PDescription='+PDescription;
	}
</script>

<cfoutput>
	<cfform action="#CGI.SCRIPT_NAME#" method="post" name="productSearchForm">
		<!--- <h4>Search By</h4> --->
		<table style="padding:8px;" width="90%" align="center">
			<thead>
			<tr>
				<th align="center" valign="middle"><b>Product</b></th>
				<th align="center" valign="middle"><b>Part No.</b></th>
				<th align="center" valign="middle"><b>Product Family</b></th>
				<th align="center" valign="middle"><b>Description</b></th>
			</tr>
			<tr>
				<th align="left" valign="middle"><cfinput type="text" name="ProductName" value="#ProductName#" style="width:179px;"></th>
				<th align="center" valign="middle"><cfinput type="text" name="PartNumber" value="#PartNumber#" style="width:96px;"></th>
				<th align="center" valign="middle"><cfinput type="text" name="ProductFamilyName" value="#ProductFamilyName#" style="width:196px;"></th>
				<th align="center" valign="middle"><cfinput type="text" name="Description" value="#Description#" style="width:200px;"></th>
			</tr>
			<cfif ATTRIBUTES.Mode IS "admin">
			<tr><td colspan="4" height="10">&nbsp;&nbsp;</td></tr>
			<tr><td colspan="4" height="10"><strong>Results</strong></td></tr>
			<tr>
				<td colspan="4" valign="baseline">
					+ <a href="/common/admin/masterview/index.cfm?MVEid=1&mvcid=7">Add New Product</a>
					<div style="float:right">
						<cfinput type="button" name="btnExport" value="Export To Excel" onClick="ExportToExcel()">
					</div>
				</td>
			</tr>
			</cfif>
			</thead>
		</table>
		<table class="grid"  width="90%" align="center">
			<tr><td>
			<!--- display the users in a cfgrid tag - this is bound both to the cfgrid
			controls and the form controls above --->
			<cfif ATTRIBUTES.Mode IS "admin">
				<cfgrid format="html" name="productReport" gridLines="yes"
						selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
						appendKey="true"
						bind="cfc:com.product.productHandler.GetProductReport({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn}, 
							{cfgridsortdirection}, {ProductName@keyup}, {PartNumber@keyup}, {ProductFamilyName@keyup}, 
							{Description@keyup})">
					<cfgridcolumn name="ProductID" display="no" />
					<cfgridcolumn name="ProductName" header="Product" width="200" />
					<cfgridcolumn name="PartNumber" header="Part No." width="100" />
					<cfgridcolumn name="ProductFamilyName" header="Product Family" width="200" />
					<cfgridcolumn name="Description" header="Description" width="300" />
					<cfgridcolumn name="edit" header="" width="24" href="/common/admin/MasterView/CategoryModify.cfm?PageAction=Edit" hrefKey="productID"/>
				</cfgrid>
				 <!--- <cfinput type="button" name="btnExport" value="Export To Excel" onClick="ExportToExcel()"> --->
			<cfelse>
				<cfgrid format="html" name="productReport" gridLines="yes"
						selectmode="row" pagesize="20" stripeRowColor="##EBEBEB" stripeRows="yes"
						appendKey="false" href="ProductAlias"
						bind="cfc:com.product.productHandler.GetProductReport({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn}, 
							{cfgridsortdirection}, {ProductName@keyup}, {PartNumber@keyup}, {ProductFamilyName@keyup}, 
							{Description@keyup})">
					<cfgridcolumn name="ProductID" display="no"/>
					<cfgridcolumn name="ProductName" header="Product" width="200" />
					<cfgridcolumn name="PartNumber" header="Part No." width="100" />
					<cfgridcolumn name="ProductFamilyName" header="Product Family" width="200" />
					<cfgridcolumn name="Description" header="Description" width="200" />
				</cfgrid>
			</cfif>
			</td></tr>
		</table>
	</cfform>
</cfoutput>