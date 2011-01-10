<cfquery name="GetDisplayOrder" datasource="#APPLICATION.DSN#">
	select DisplayOrder from t_Category Where CategoryID=#Val(ATTRIBUTES.CurrentCategoryID)#
</cfquery>
<cfstoredproc procedure="sp_GetPages" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetProductSeries">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayOrder" Value="#GetDisplayOrder.DisplayOrder#" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="categoryActiveDerived" value="1" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ParentID" value="#ATTRIBUTES.CurrentCategoryID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="DisplayLevelList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryIDList" value="" null="Yes">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="CategoryTypeIDList" value="62,63" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="NotCategoryTypeIDList" value="" null="Yes">
</cfstoredproc>

<cfif GetProductSeries.RecordCount GT "0">
	<div>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr valign="top"><cfset Counter1="1">
			<cfset Counter2="1">
			<cfoutput query="GetProductSeries">
				<cfset CategoryImageRepresentative="">
				<cfset ProductFamilyDescription="">
				<cfif isWddx(CategoryLocalePropertiesPacket)>
					<cfwddx action="WDDX2CFML" input="#CategoryLocalePropertiesPacket#" output="sProperties">
					<cfif StructKeyExists(sProperties,"CategoryImageRepresentative")>
						<cfset CategoryImageRepresentative=sProperties.CategoryImageRepresentative>
					</cfif>
					<cfif StructKeyExists(sProperties,"ProductFamilyDescription")>
						<cfset ProductFamilyDescription=sProperties.ProductFamilyDescription>
					</cfif>
				</cfif>
				<cfif Trim(CategoryURLDerived) IS "">
					<cfset ThisURL="/content.cfm/#CategoryAlias#">
				<cfelse>
					<cfset ThisURL="#CategoryURLDerived#">
				</cfif>
				<td><table border="0" cellspacing="0" cellpadding="0"><TR><TD><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr valign="top"><TD width="26"><img name="imageindex_#CategoryID#" src="/common/images/global/btn.arrowblock.1.gif" width="26" height="36" border="0"></TD><TD class="sectarrwpad"><a href="#ThisURL#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('imageindex_#CategoryID#','','/common/images/global/btn.arrowblock.#Counter1#-o.gif',1)" class="secthead">#Ucase(CategoryNameDerived)#</a></TD></TR></table></TD></TR>
				<TR><TD style="padding-right:10px;"><img src="#CategoryImageRepresentative#"></TD></TR>
				<TR><TD><strong>#CategoryNameDerived#</strong><BR>#ProductFamilyDescription#
				</TD></TR>
				</table></td>
				<cfif Counter1 GT "4">
					<cfset Counter1="1">
				<cfelse>
					<cfset Counter1=Counter1+1>
				</cfif>
				<cfif Counter2 MOD "4" iS "0">
					</TR><tr valign="top">
				</cfif>
				<cfset Counter2=Counter2+1>
			</cfoutput>
			</TR>
	</table>
	</div>
</cfif>