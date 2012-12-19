 
<cfif not structKeyExists(application,"tagCloud") or structKeyExists(url,"resettagcloud")>

    <cfset application.tagCloud = queryNew("tag,tagCount")>
    
    <cfcollection
            action="CategoryList"
            collection="#Application.CollectionName##APPLICATION.LocaleID#"
            name="info"
            >
            
    <cfloop index="strKey" list="#StructKeyList( info.categories )#" delimiters=",">
        <cfset QueryAddRow(application.tagCloud)>
        <cfset temp = querySetCell(application.tagCloud, "tag", strKey)>
        <cfset temp = querySetCell(application.tagCloud, "tagCount", info.categories[strKey])>
    </cfloop>
    
</cfif>

<cfparam name="url.limit" default="0">

<cfquery name="tags" dbtype="query">
    SELECT *
      FROM application.tagCloud
     WHERE tagcount > <cfqueryparam value="#val(url.limit)#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif structKeyExists(url,"showdump")>
    <cfdump var="#tags#">
</cfif>

<!--- calculate our hit ranges etc. --->
<cfset tagValueArray = ListToArray(ValueList(tags.tagCount))>
   <cfset max = ArrayMax(tagValueArray)>
   <cfset min = ArrayMin(tagValueArray)>
   <cfset diff = max - min>
   <!---
      scaleFactor will affect the degree of difference between the different font sizes.
      if you have one really large category and many smaller categories, then set higher.
      if your category count does not vary too much try a lower number.      
   --->   <!---
      scaleFactor will affect the degree of difference between the different font sizes.
      if you have one really large category and many smaller categories, then set higher.
      if your category count does not vary too much try a lower number.      
   --->
   <cfset scaleFactor = 25>
   <cfset distribution = diff / scaleFactor>
   
   <!--- optionally add a range of colors in the CSS color property for each class --->
   <cfoutput>
      <style>
         .smallestTag { font-size: 9px; }
         .smallTag { font-size: 11px; }
         .mediumTag { font-size: 13px; }
         .largeTag { font-size: 16px; }
         .largestTag { font-size: 20px; }
         .tagCloudDiv { margin-left:18px; margin-right:18px; }
      </style>
      
      <div class="tagCloudDiv">
      <cfloop query="tags">
         <cfsilent>
            <cfif tags.tagCount EQ min>
               <cfset class="smallestTag">
            <cfelseif tags.tagCount EQ max>
               <cfset class="largestTag">
            <cfelseif tags.tagCount GT (min + (distribution*2))>
               <cfset class="largeTag">
            <cfelseif tags.tagCount GT (min + distribution)>
               <cfset class="mediumTag">
            <cfelse>
               <cfset class="smallTag">
            </cfif>
         </cfsilent>
         <a href="#APPLICATION.MyCategoryHandler.parseCategoryUrl('search')#?metakeyword=#urlencodedformat(trim(tags.tag))#"><span class="#class#">#lcase(tags.tag)#</span></a>
      </cfloop>
      </div>
   </cfoutput>