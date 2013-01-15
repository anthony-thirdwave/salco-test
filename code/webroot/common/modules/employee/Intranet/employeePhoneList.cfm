<cfinvoke component="com.ContentManager.EmployeeHandler"
	method="qryEmployees"
	orderBy="empFirstName"
	returnVariable="employees">

<cfinvoke component="com.ContentManager.EmployeeHandler"
	method="qryEmployees"
	departmentID="#APPLICATION.DepartmentCategoryID#"
	orderBy="empFirstName"
	returnVariable="departments">

<cfquery name="qryEmployeePhone" dbtype="query">
	SELECT	*
	FROM	employees
	WHERE	empPhoneExt <> ''
</cfquery>

<cfquery name="qryEmployeeCellPhone" dbtype="query">
	SELECT	*
	FROM	employees
	WHERE	empCellPhone <> ''
</cfquery>
<cfset noPerColumn=qryEmployeePhone.recordCount / 2>

<article class="phonelist">
   <div id="extensions">
    <div class="inArt"> 
		<div id="left">
			<table cellpadding="0" cellspacing="0" border="0">
				<caption>Phone List <span>Ext. <a href="#cellphones" class="telSwitch">Cell</a><span class="clearit"></span></span></caption>
					<tbody>
						<cfoutput query="qryEmployeePhone" startrow="1" maxrows="#noPerColumn#">
							<tr>
								<td>#empFirstName# #empLastName#</td>
								<td>#empPhoneExt#</td>
							</tr>
						</cfoutput>
					</tbody>
				</tbody>
			</table>
		</div>
		<div id="center">
			<table cellpadding="0" cellspacing="0" border="0">
				<tbody>
				<cfoutput query="qryEmployeePhone" startrow="#noPerColumn+1#">
					<tr>
						<td>#empFirstName# #empLastName#</td>
						<td>#empPhoneExt#</td>
					</tr>
				</cfoutput>
				</tbody>
			</table>
		</div>
		<div id="right">
			<table cellpadding="0" cellspacing="0" border="0">
			<caption>Phone List. Departments</caption>
				<tbody>
					<cfoutput query="departments">
					<tr>
						<td>#empFirstName#</td>
						<td>#empPhoneExt#</td>
					</tr>
					</cfoutput>
				</tbody>
			</table>
			
			
		</div>
		<div id="cellphones">
			<table cellpadding="0" cellspacing="0" border="0">
			<caption>Phone List <span> <a href="#extensions" class="telSwitch">Ext.</a> Cell  <span class="clearit"></span></span></caption>
				<tbody>
				<cfoutput query="qryEmployeeCellPhone">
					<tr>
						<td>#empFirstName# #empLastName#</td>
						<td>#empCellPhone#</td>
					</tr>
				</cfoutput>
				</tbody>
			</table>
	    </div>
		</div>
		
	</div>
</article>
<style>
caption span{
	font-size:12px;
	display:inline-block;
	width:130px;
	text-align:right;
	position:relative;
	z-index:100;
}</style>