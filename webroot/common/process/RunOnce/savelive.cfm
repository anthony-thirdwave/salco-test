<cfabort><cfset lCategoryID="4038,3098,4381,676,689,5542">

<cfloop index="ThisCategoryID" list="#lCategoryID#">
	<cfset MyProduct=CreateObject("component","com.Product.Product")>
	<cfset MyProduct.Constructor(Val(ThisCategoryID),100)>
	<cfset MyProduct.SaveToProduction(APPLICATION.WebrootPath,1)>
</cfloop>