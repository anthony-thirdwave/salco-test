<cfsetting showdebugoutput="No" RequestTimeOut=50000>
<cfparam name="ATTRIBUTES.NodeID" default="0">
<cfset REQUEST.lProblemID="">
<cfif 0>
	<cfoutput>
		<p>CategoryIDToStart: #CategoryIDToStart#-#ThisDisplayLevel#<br>
		#ATTRIBUTES.CategoryThreadList#</p>
	</cfoutput>
</cfif>
<cfsavecontent variable="ProductList">
<cfmodule template="/common/modules/product/ProductOutlineHelper.cfm"
	NodeID="#ATTRIBUTES.NodeID#"
	Level="0">
</cfsavecontent>
<cfdump var="#REQUEST.lProblemID#">
<cfoutput>#ProductList#</cfoutput>