<cfcomponent>
	<cffunction name="ParseRSSItems" output="false" returntype="query">
		<cfargument name="RSSXML" required="yes" type="string">
		
		<!--- init variables --->
		<cfset var XMLVALIDATION = true>
		<cfset var qReturn=QueryNew("Title,Author,Link,Description")>
		<cfset var objRSS = "">
		<cfset var XMLRoot = "">
		<cfset var Item_Length= "">
		<cfset var tmp_Item = "">
		<cfset var item_title = "">
		<cfset var item_link = "">
		<cfset var item_description = "">
		<cfset var item_author = "">
		<cfset var itms = "">
		
		<cftry>
			<!--- Create the XML object --->
			<cfset objRSS = xmlParse(ARGUMENTS.RSSXML)>
			<cfcatch type="any">
				<!--- If the document retrieved in the CFHTTP
				is not valid set the validation flag to false. --->
				<cfset XMLVALIDATION = false>
			</cfcatch>
		</cftry>
		
		<cfif XMLVALIDATION>
			<!--- If the validation flag is true continue parsing --->
		
			<!--- Set the XML Root --->
			<cfset XMLRoot = objRSS.XmlRoot>
		
			<!--- Retrieve the number of items in the channel --->
			<cfif StructKeyExists(XMLRoot.channel,"items")><!--- RDF --->
				<cfset XMLRoot = xmlParse(replace(ARGUMENTS.RSSXML,"dc:","dc_","all"))>
				<cfset Item_Length = arraylen(XMLRoot.rdf.item)>
				<cfloop index="itms" from="1" to="#Item_Length#">
					<!--- Retrieve the current Item in the loop --->
					<cfset tmp_Item = XMLRoot.rdf.item[itms]>
					<!--- Retrieve the item data --->
					<cfset item_title = tmp_item.title.xmltext>
					<cfset item_link = tmp_item.link.xmltext>
					<cfset item_description = tmp_item.description.xmltext>
					<cfif StructKeyExists(tmp_item,"dc_creator")>
						<cfset item_author = tmp_item.dc_creator.xmltext>
					<cfelse>
						<cfset item_author="">
					</cfif>
			
					<!--- Output the items in the browser --->
					<cfset QueryAddRow(qReturn,1)>
					<cfset QuerySetCell(qReturn,"Title",item_title)>
					<cfset QuerySetCell(qReturn,"Link",item_link)>
					<cfset QuerySetCell(qReturn,"Description",item_description)>
					<cfset QuerySetCell(qReturn,"Author",item_author)>
				</cfloop>
			<cfelse>
				<cfset Item_Length = arraylen(XMLRoot.channel.item)>
				<!--- Loop through all the items --->
				<cfloop index="itms" from="1" to="#Item_Length#">
					<!--- Retrieve the current Item in the loop --->
					<cfset tmp_Item = XMLRoot.channel.item[itms]>
			
					<!--- Retrieve the item data --->
					<cfset item_title = tmp_item.title.xmltext>
					<cfset item_link = tmp_item.link.xmltext>
					<cfset item_description = tmp_item.description.xmltext>
			
					<!--- Output the items in the browser --->
					<cfset QueryAddRow(qReturn,1)>
					<cfset QuerySetCell(qReturn,"Title",item_title)>
					<cfset QuerySetCell(qReturn,"Link",item_link)>
					<cfset QuerySetCell(qReturn,"Description",item_description)>
					<cfset QuerySetCell(qReturn,"Author","")>
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn qReturn>
		
	</cffunction>
	
	<cffunction name="ParseRSSDescription" output="true" returntype="query">
		<cfargument name="RSSXML" required="yes" type="string">
		
		<!--- init variables --->
		<cfset var XMLVALIDATION = true>
		<cfset var qReturn=QueryNew("Title,Link,Description")>
		<cfset var objRSS = "">
		<cfset var XMLRoot = "">
		<cfset var doc_title= "">
		<cfset var doc_link = "">
		<cfset var doc_description = "">
		
		<cftry>
			<!--- Create the XML object --->
			<cfset objRSS = xmlParse(ARGUMENTS.RSSXML)>
			<cfcatch type="any">
				<!--- If the document retrieved in the CFHTTP
				is not valid set the validation flag to false. --->
				<cfset XMLVALIDATION = false>
			</cfcatch>
		</cftry>
		
		<cfif XMLVALIDATION>
			<!--- If the validation flag is true continue parsing --->
		
			<!--- Set the XML Root --->
			<cfset XMLRoot = objRSS.XmlRoot>
		
			<!--- Retrieve the document META data --->
			<cfset doc_title = XMLRoot.channel.title.xmltext>
			<cfset doc_link = XMLRoot.channel.link.xmltext>
			<cfset doc_description = XMLRoot.channel.description.xmltext>
			<cfset QueryAddRow(qReturn,1)>
			<cfset QuerySetCell(qReturn,"Title",doc_title)>
			<cfset QuerySetCell(qReturn,"Link",doc_link)>
			<cfset QuerySetCell(qReturn,"Description",doc_description)>
		</cfif>
		<cfreturn qReturn>
	</cffunction>
</cfcomponent>