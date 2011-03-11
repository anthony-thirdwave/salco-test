<cfparam name="ATTRIBUTES.RecordCount" default="0">
<cfparam name="ATTRIBUTES.SearchNum" default="0">
<cfparam name="ATTRIBUTES.StartRow" default="0">
<cfparam name="ATTRIBUTES.FieldList" default=""><!--- Valid URLEncodedFormat String --->
<cfparam name="ATTRIBUTES.Path" default="">
<cfparam name="ATTRIBUTES.Label" default="">
<cfset StartRow=Val(ATTRIBUTES.StartRow)>
<cfset SearchNum=Val(ATTRIBUTES.SearchNum)>
<cfset FieldList=ATTRIBUTES.FieldList>

<cfset NumPages=Ceiling(ATTRIBUTES.RecordCount/ATTRIBUTES.SearchNum)>
<cfset currentPage=Fix(ATTRIBUTES.StartRow/ATTRIBUTES.SearchNum)+1>

<cfset Start="1">
<cfif NumPages GT "11">
	<cfset Start=currentPage-5>
	<cfif Start LTE "1">
		<cfset Start="1">
	</cfif>
	<cfif currentPage+5 GT NumPages>
		<Cfset Start=NumPages-10>
	</cfif>
</cfif>
<cfset End=Start+10>
<cfif NumPages LTE End>
	<cfset End=NumPages>
</cfif>

<cfoutput>
	<cfif ATTRIBUTES.RecordCount GT ATTRIBUTES.SearchNum>
		<div class="pagination">
		<p>
		<cfoutput>
		#ATTRIBUTES.Label# #ATTRIBUTES.StartRow#&ndash;<cfif ATTRIBUTES.StartRow+DecrementValue(ATTRIBUTES.SearchNum) GT ATTRIBUTES.RecordCount>#ATTRIBUTES.RecordCount#<cfelse>#ATTRIBUTES.StartRow+DecrementValue(ATTRIBUTES.SearchNum)#</cfif> of #ATTRIBUTES.RecordCount#
		</cfoutput>
		</p>
		<ul class="pagination">
			<CFIF ATTRIBUTES.StartRow GT ATTRIBUTES.SearchNum>
				<cfset NewStartRow=ATTRIBUTES.StartRow-ATTRIBUTES.SearchNum>
				<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
				<li><a href="#ATTRIBUTES.Path#?#querystring#">&laquo;</a></li>
			<cfelse>
				<li>&laquo;</li>
			</CFIF>
			<cfset outputstr="">
			<cfif NumPages GT 1>
				<cfif Start IS NOT "1">
					<cfset outputstr="#outputstr#<li>...</li>">
				</cfif>
				<cfloop from="#Start#" to="#End#" index="i">
					<cfif i IS CurrentPage>
						<cfset outputstr="#outputstr#<li>#i#</li>">
					<cfelse>
						<cfset NewStartRow=(SearchNum*(i-1))+1>
						<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
						<cfset outputstr="#outputstr#<li><a href=""#ATTRIBUTES.Path#?#querystring#"">#i#</a></li>">
					</cfif>
				</cfloop>
				<cfif End LT NumPages>
					<cfset outputstr="#outputstr#<li>...</li>">
				</cfif>
			</cfif>
			#outputstr#
			<CFIF ATTRIBUTES.StartRow LT (ATTRIBUTES.RecordCount - (ATTRIBUTES.SearchNum-1))>
				<cfset NewStartRow=ATTRIBUTES.StartRow+ATTRIBUTES.SearchNum>
				<cf_AddToQueryString querystring="#FieldList#" name="StartRow" value="#NewStartRow#">
				<li><a href="#ATTRIBUTES.Path#?#querystring#" class="capsBlackLink">&raquo;</a></li>
			<cfelse>
				<li>&raquo;</li>
			</CFIF>
			
		</ul></div>
	</cfif>
</cfoutput>