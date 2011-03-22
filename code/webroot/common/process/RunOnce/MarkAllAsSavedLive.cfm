<cfoutput query="GetAllCats">
	select * from t_category order by CategoryID
</cfoutput>

<cfoutput query="GetAllCats">
	<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
		UserID="1"
		Entity="Category"
		KeyID="#CategoryID#"
		Operation="savelive"
		EntityName="#CategoryName#">
</cfoutput>