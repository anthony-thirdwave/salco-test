<cfset sSearchCategory=StructNew()>

<cfset sSearchCategory["Product-hopper-car"]="Hopper Car">
<cfset sSearchCategory["Product-intermodal-containers"]="Intermodal Container">
<cfset sSearchCategory["Product-railyard-accessories"]="Rail/Yard Accessories">
<cfset sSearchCategory["Product-tank-car"]="Tank Car">
<cfset sSearchCategory["SiteContent"]="Site">


<cfif NOT IsDefined("lsc")>
	<cfquery name="GetContentSearchCategory" dbtype="query">
		select distinct(Category) from ContentSearch
		order by Category
	</cfquery>
	<cfset lsc=ValueList(GetContentSearchCategory.Category)>
	<cfif lsc IS "">
		<cfset lsc="#StructKeyList(sSearchCategory)#">
	</cfif>
<cfelse>
	<cfset lsc="#StructKeyList(sSearchCategory)#">
</cfif>

<cfif ListLen(lsc) GT "1">
	<cfoutput>
		<form action="#APPLICATION.utilsObj.parseCategoryUrl('search')#">
		<input type="hidden" name="lsc" value="#lsc#">
		<div class="formRow">
			<label for="SearchTxt">Search Term</label>
			<input type="text" name="SearchTxt" id="SearchTxt" value="#HTMLEditFormat(SearchTxt)#">
		</div>
		
		<div class="formRow">
			<label for="SearchCategory">Filter</label>
			<select name="SearchCategory" id="SearchCategory">
				<option value="" <cfif SearchCategory IS "">selected</cfif>>All</option>
			<cfloop index="ThisSearchCategory" list="#lsc#">
				<cfif StructKeyExists(sSearchCategory,ThisSearchCategory)>
					<option value="#ThisSearchCategory#" <cfif SearchCategory IS ThisSearchCategory>selected</cfif>>#sSearchCategory[ThisSearchCategory]#</option>
				</cfif>
			</cfloop>
			</select>
		</div>
		<div class="formRow submit rightSubmit">
			<input type="submit" value="Search">
		</div>
		</form>
	</cfoutput>
</cfif>