<cfsetting showdebugoutput="0" RequestTimeOut="60000">
<cfset lProblemID ="2104,2105,2087,2100,2117,2139,2148,2140,2035,652,710,759,707,773,774,780,630,79,114,206,1134,1323,1335,2738,2760,2789,2783,2784,2785,2786,2790,5962,5979,5982,5988,3415,3322,3369,3364,3358,4712,4554,4569,4601,4645,4392,4388,4437,4278,4286,4308,4475,4476,4477,4478,4480,4481,4483,4484,4486,4487,4489,4493,4494,4495,4496,4498,4499,4503,4502,4504,4505,4506,4507,4500,4516,4527,4528,5156,5157,5239,5162,5163,5172,5202,5204,5209,5216,5223">

<table>

<cfquery name="GetCategory" datasource="#APPLICATION.DSN#">
	select * from t_category Where SourceID IN (#lProblemID#)
	order by displayorder
</cfquery>
<cfoutput query="GetCategory">
	<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
		thiscategoryid="#GetCategory.CategoryID#"
		namelist="#GetCategory.CategoryName#"
		idlist="#GetCategory.CategoryID#"
		aliaslist="#GetCategory.CategoryAlias#">
	<tr><td>#CurrentRow#</td><td>#ListChangeDelims(ListRest(NameList),"&gt;")#</td></tr>
</cfoutput>

</table>