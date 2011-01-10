<cfsetting requesttimeout="25000">
<cfparam name="LocaleIDValue" default="-1">
<cfparam name="SiteID" default="2215">
<cfparam name="ShowAll" default="No">
<cfparam name="DontFlush" default="0">
<cfquery name="getlocales" datasource="#APPLICATION.DSN#">
	select * from t_locale order by localename
</cfquery>
<cfset Request.Recache="0">
<cfmodule template="#Application.Mapping#common/modules/admin/dsp_AdminHeader.cfm" 
	secure="Yes" 
	PageHeader="<a href=""/common/admin/"" class=""white"">Admin Menu</A> | Product Sheet"
	PageTitle="Product Sheet">
	<script language="JavaScript" type="text/JavaScript" src="/common/scripts/common.js"></script>
<script language=javascript src="/common/scripts/mm4.js"></script> 

<form action="ProductSheet.cfm" method="post">
<table width="100%" cellspacing="3" cellpadding="3"><TR><TD>
Site: <select name="SiteID">
	<option value="2215" <cfif SiteID IS 2215>selected</cfif>>Commercial</option>
	<option value="2214" <cfif SiteID IS 2214>selected</cfif>>Home</option>
</select>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

Locale: <select name="LocaleIDValue">
		<cfoutput query="getlocales">
			<option value="#LocaleID#" <cfif LocaleIDValue IS LocaleID>selected</cfif>> #LocaleName#</option>
		</cfoutput>
	</select>
	
	
	
	
	Show: <select name="ShowAll">
	<option value="yes" <cfif ShowAll>selected</cfif>>Product Family & Product</option>
	<option value="no" <cfif Not ShowAll>selected</cfif>>Product Family Only</option>
</select>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" name="ButSubmitSavePassThru" value="Load Products">

	
</TD></TR></table>
</form>

<cfif LocaleIDValue GT "0">
	<cfquery name="GetLang" datasource="#APPLICATION.DSN#">
		select LanguageID from t_locale Where localeID=#Val(LocaleIDValue)#
	</cfquery>
	<cfset LanguageIDValue=GetLang.LanguageID>
	<cfif SiteID IS "2215">
		<cfset REQUEST.Site="Commercial">
	<cfelse>
		<cfset REQUEST.Site="Home">
	</cfif>
	<cfquery name="GetTopDOS" datasource="#APPLICATION.DSN#">
		select DIsplayOrder from t_Category where CategoryID=#Val(SiteID)#
	</cfquery>
	<cfquery name="GetCats" datasource="#APPLICATION.DSN#">
		select * FRom t_Category
		where 
		DisplayOrder like '#GetTopDOS.DisplayOrder#%' and 
		CategoryTypeID IN 
		<cfif ShowAll>(62,64) <cfelse>(62)</cfif>
		order by DisplayORder
	</cfquery>
	<cfoutput query="GetCats">
		<cfif CategoryTypeID IS "62">
			<hr size="5" noshade>
			<h3>Product Family: #CategoryName# (#CategoryID#)</h3>
			<cfmodule template="#APPLICATION.Mapping#common/modules/product/ProductFamilyChart.cfm"
				ProductFamilyID="#CategoryID#"
				LocaleID="#LocaleIDValue#"
				LanguageID="#LanguageIDValue#"
				ShowProductRange="ProductFamily"
				Formatting="0">
		<cfelse>
			<HR size="2" noshade>
			<h3>Product: #CategoryName# (#CategoryID#)</h3>
			<cfmodule template="#APPLICATION.Mapping#common/modules/product/productDetail.cfm" 
				ProductID="#CategoryID#"
				LocaleID="#LocaleIDValue#"
				LanguageID="#LanguageIDValue#">
		</cfif>
		<cfif NOT DontFlush>
			<cfflush>
		</cfif>
	</cfoutput>
</cfif>

<cfmodule template="#Application.Mapping#common/modules/admin/dsp_AdminFooter.cfm">