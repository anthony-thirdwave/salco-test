<cfparam name="ATTRIBUTES.CategoryID" default="-1">
<cfparam name="ATTRIBUTES.CategoryThreadList" default="-1">

<cfset URL.CategoryID=ATTRIBUTES.CategoryID>
<cfset URL.CategoryThreadList=ATTRIBUTES.CategoryThreadList>

<div id="productNav">
<cfinclude template="dsp_NavProductHelper.cfm">
</div>