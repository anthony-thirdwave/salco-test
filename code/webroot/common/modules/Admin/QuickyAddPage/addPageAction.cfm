<cfif IsDefined("FORM.qpa_WasSubmitted")>
	<cfif Trim(FORM.qpa_PageName) EQ "">
		<cfset ValMsg = ValMsg & "<li>Please enter a page name.</li>">
	</cfif>
	<cfif FORM.qpa_ParentID EQ "">
		<cfset ValMsg = ValMsg & "<li>Please select a location.</li>">
	</cfif>
	
	<cfif ValMsg EQ "">
		<!--- CREATE CATEGORY --->
		<cfset MyCategory=CreateObject("component","com.ContentManager.Category")>
		<cfset MyCategory.Constructor()>
		<cfset MyCategory.SetProperty("ParentID",FORM.qpa_ParentID)>
		<cfset MyCategory.SetProperty("CategoryName",Trim(FORM.qpa_PageName))>
		<cfset MyCategory.SetProperty("CategoryTypeID",60)>
		<cfset MyCategory.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
		
		<cfset MyCategoryID = MyCategory.GetProperty("CategoryID")>
		
		<!--- CREATE CATEGORY LOCALE --->
		<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
		<cfset MyCategoryLocale.Constructor()>
		<cfset MyCategoryLocale.SetProperty("CategoryID",MyCategoryID)>
		<cfset MyCategoryLocale.SetProperty("LocaleID",SESSION.AdminCurrentAdminLocaleID)>
		<cfset MyCategoryLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
		
		<cfif Trim(FORM.qpa_PlaceholderContent) NEQ "">
			<!--- CREATE CONTENT ITEM --->
			<cfset ThisContent=CreateObject("component","com.ContentManager.Content")>
			<cfset ThisContent.Constructor()>
			<cfset ThisContent.SetProperty("CategoryID",MyCategoryID)>
			<cfset ThisContent.SetProperty("ContentName","Place Holder Content")>
			<cfset ThisContent.SetProperty("ContentTypeID",201)>
			<cfset ThisContent.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
			
			<cfset thisContentID = ThisContent.GetProperty("ContentID")>
			
			<!--- CREATE CONTENTLOCALE --->
			<cfset ThisContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
			<cfset ThisContentLocale.Constructor()>
			<cfset ThisContentLocale.SetContentPositionID("401")>
			<cfset ThisContentLocale.SetProperty("ContentID",thisContentID)>
			<cfset ThisContentLocale.SetProperty("LocaleID",SESSION.AdminCurrentAdminLocaleID)>
			<cfset ThisContentLocale.SetProperty("HTML",FORM.qpa_PlaceholderContent)>
			<cfset ThisContentLocale.SetContentTypeID(201)>
			<cfset ThisContentLocale.Save(APPLICATION.WebrootPath,SESSION.AdminUserID)>
		</cfif>
		
		<cfif FORM.qpa_NextSiblingID NEQ "">
			<cfinvoke component="com.ContentManager.CategoryHandler" 
				method="SetLocationAboveSibling"
				CategoryID="#MyCategoryID#"
				SiblingID="#FORM.qpa_NextSiblingID#"
				returnVariable="Success">
		</cfif>
		
		<cflocation addtoken="no" url="#locationURL#">
	</cfif>
</cfif>