<cfmodule template="/common/modules/admin/dsp_Admin.cfm" 
	Page="Product Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Product Manager">
	
<cfparam name="ProductName" default="">
<cfparam name="PartNumber" default="">
<cfparam name="ProductFamilyName" default="">
<cfparam name="Description" default="">

<div class="dashModuleWide">
	<div class="box2">
		<div class="boxtop2"><div></div></div>
		<div class="ModuleTitle2" style="border-bottom:1px solid #97AEB8;">Users</div>
		<div class="ModuleBody2">
<cfoutput>
	<cfform action="#CGI.SCRIPT_NAME#" method="post" name="productSearchForm">
		<table cellspacing="0px" cellpadding="3px">
			<tr>
				<th>&nbsp;</th>
				<th>Product Name</th>
				<th>Part Number</th>
				<th>Product Family Name</th>
				<th>Description</th>
			</tr>
			<tr bgcolor="##666666">
				<td>
					<font color="##FFFFFF"><strong>Search By:</strong></font>
				</td>
				<td>
					<cfinput type="text" name="ProductName" value="#ProductName#">
				</td>
				<td>
					<cfinput type="text" name="PartNumber" value="#PartNumber#">
				</td>
				<td>
					<cfinput type="text" name="ProductFamilyName" value="#ProductFamilyName#">
				</td>
				<td>
					<cfinput type="text" name="Description" value="#Description#">
				</td>
			</tr>
			<tr>
				<td colspan="6"><strong>Results</strong>
				<div style="float:right"><a href="/common/admin/masterview/index.cfm?MVEid=1&mvcid=7">Add New Product</a></div>
				</td>
			</tr>

			<tr>
				<td colspan="6">
					<!--- display the users in a cfgrid tag - this is bound both to the cfgrid
					controls and the form controls above --->
					<cfgrid format="html" name="productReprot" gridLines="yes"
							selectmode="row" pagesize="20" stripeRowColor="##e0e0e0" stripeRows="yes"
							appendKey="true"
							bind="cfc:com.product.productHandler.GetProductReport({cfgridpage}, {cfgridpagesize}, {cfgridsortcolumn}, 
								{cfgridsortdirection}, {ProductName@keyup}, {PartNumber@keyup}, {ProductFamilyName@keyup}, 
								{Description@keyup})">
						<cfgridcolumn name="ProductID" display="no" />
						<cfgridcolumn name="ProductName" header="Product Name" width="200" />
						<cfgridcolumn name="PartNumber" header="Part Number" width="100" />
						<cfgridcolumn name="ProductFamilyName" header="Product Family Name" width="200" />
						<cfgridcolumn name="Description" header="Description" width="200" />
						<cfgridcolumn name="edit" header="" width="24" href="/common/admin/MasterView/CategoryModify.cfm?PageAction=Edit" hrefKey="productID"/>
					</cfgrid>
				</td>
			</tr>
		</table>
			
	</cfform>
		
</cfoutput>
</div>
		<div class="boxbottom2"><div></div></div>
	</div>
</div>
<p>&nbsp;</p>


</cfmodule>