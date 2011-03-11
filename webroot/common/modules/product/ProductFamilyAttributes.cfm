<cfsetting requesttimeout="20000">
<cfquery name="getlangs" datasource="#APPLICATION.DSN#">
	select * from t_label where LabelGroupID = 60 order by labelPriority
</cfquery>
<cfparam name="siteID" default="524">
<cfset Request.Recache="0">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/common/styles/admin.css" title="docProperties">
	<title>Product Sheet</title>
	<script language="JavaScript" type="text/JavaScript" src="/common/scripts/common.js"></script>
<script language=javascript src="/common/scripts/mm4.js"></script> 
</head>
<body>

<form action="ProductSheet.cfm" method="post">
<table width="100%" cellspacing="3" cellpadding="3"><TR><TD>
Site: <select name="SiteID">
	<option value="524" <cfif SiteID IS 524>selected</cfif>>Commercial</option>
	<option value="451" <cfif SiteID IS 451>selected</cfif>>Home</option>
</select>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="submit" name="ButSubmitSavePassThru" value="Load Product Families">
	
</TD></TR></table>
</form>
<cfquery name="GetTopDOS" datasource="#APPLICATION.DSN#">
	select DIsplayOrder from t_Category where CategoryID=#Val(SiteID)#
</cfquery>
<cfquery name="GetCats" datasource="#APPLICATION.DSN#">
	select CategoryID, CategoryName FRom t_Category
	where 
	DisplayOrder like '#GetTopDOS.DisplayORder#%' and 
	DisplayOrder not like '004001003%' and 
	CategoryTypeID IN (62)
	order by DisplayORder
</cfquery>	
<cfloop query="GetCats">
	<cfoutput><h3>#GetCats.CategoryName#</h3></cfoutput>
	<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
		SELECT * FROM qry_GetProductFamilyAttribute
		WHERE CategoryID=#Val(GetCats.CategoryID)#
		order by ProductFamilyAttributePriority, ProductFamilyAttributeID ,LanguageID asc
	</cfquery>
	<cfset aBlank=ArrayNew(1)>
	<table border="1">
	<TR><TD>Product Family Attribute ID</TD>
	<cfoutput query="getLangs">
		<TD>#Labelname#</TD>
	</cfoutput>
	</TR>
	<cfoutput query="GetItems" group="ProductFamilyAttributeID">
		<TR><TD>#ProductFamilyAttributeID#</TD>
		<cfset sAttrElement=StructNew()>
		<cfloop index="ThisLanguageID" list="#ValueList(getlangs.LabelID)#">
			<cfset StructInsert(sAttrElement,ThisLanguageID,"[none]",1)>
		</cfloop>
		<cfoutput group="LanguageID">
			<cfif ProductFamilyAttributeName IS "">
				<cfset StructInsert(sAttrElement,LanguageID,"[blank]",1)>
			<cfelse>
				<cfset StructInsert(sAttrElement,LanguageID,ProductFamilyAttributeName,1)>
			</cfif>
		</cfoutput>
		<cfset ArrayAppend(aBlank,sAttrElement)>
		<cfloop index="ThisLanguageID" list="#ValueList(getlangs.LabelID)#">
			<TD>#sAttrElement[ThisLanguageID]#</TD>
		</cfloop>
		</Tr>
	</cfoutput>
	</table>
	<cfflush>
</cfloop>

</body>
</html>
