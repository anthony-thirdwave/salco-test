<cfcomponent>

<cffunction name="init" returntype="xml2struct">
	<cfreturn this>
</cffunction>

<!--- 
This function converts XML variables into Coldfusion Structures. It also
returns the attributes for each XML node.
--->
<cffunction name="ConvertXmlToStruct" access="public" returntype="struct" output="true"
				hint="Parse raw XML response body into ColdFusion structs and arrays and return it.">
	<cfargument name="xmlNode" type="string" required="true" />
	<cfargument name="str" type="struct" required="true" />
	<!---Setup local variables for recurse: --->
	<cfset var i = 0 />
	<cfset var axml = arguments.xmlNode />
	<cfset var astr = arguments.str />
	<cfset var n = "" />
	<cfset var tmpContainer = "" />

	<cfset axml = XmlSearch(XmlParse(arguments.xmlNode),"/node()")>
	<cfset axml = axml[1] />
	<!--- For each children of context node: --->
	<cfloop from="1" to="#arrayLen(axml.XmlChildren)#" index="i">
		<!--- Read XML node name without namespace: --->
		<cfset n = replace(axml.XmlChildren[i].XmlName, axml.XmlChildren[i].XmlNsPrefix&":", "") />
		<!--- If key with that name exists within output struct ... --->
		<cfif structKeyExists(astr, n)>
			<!--- ... and is not an array... --->
			<cfif not isArray(astr[n])>
				<!--- ... get this item into temp variable, ... --->
				<cfset tmpContainer = astr[n] />
				<!--- ... setup array for this item because we have multiple items with same name, ... --->
				<cfset astr[n] = arrayNew(1) />
				<!--- ... and reassing temp item as a first element of new array: --->
				<cfset astr[n][1] = tmpContainer />
			<cfelse>
				<!--- Item is already an array: --->
				
			</cfif>
			<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>
					<!--- recurse call: get complex item: --->
					<cfset astr[n][arrayLen(astr[n])+1] = ConvertXmlToStruct(axml.XmlChildren[i], structNew()) />
			<cfelse>
					<!--- else: assign node value as last element of array: --->
					<cfset astr[n][arrayLen(astr[n])+1] = xmlUnformat(axml.XmlChildren[i].xmlCData, "html") />
			</cfif>
		<cfelse>
			<!---
				This is not a struct. This may be first tag with some name.
				This may also be one and only tag with this name.
			--->
			<!---
					If context child node has child nodes (which means it will be complex type): --->
			<cfif arrayLen(axml.XmlChildren[i].XmlChildren) gt 0>
				<!--- recurse call: get complex item: --->
				<cfset astr[n] = ConvertXmlToStruct(axml.XmlChildren[i], structNew()) />
			<cfelse>
				<cfif IsStruct(aXml.XmlAttributes) AND StructCount(aXml.XmlAttributes)>
					<cfset at_list = StructKeyList(aXml.XmlAttributes)>
					<cfloop from="1" to="#listLen(at_list)#" index="atr">
						 <cfif ListgetAt(at_list,atr) CONTAINS "xmlns:">
							 <!--- remove any namespace attributes--->
							<cfset Structdelete(axml.XmlAttributes, listgetAt(at_list,atr))>
						 </cfif>
					 </cfloop>
					 <!--- if there are any atributes left, append them to the response--->
					 <cfif StructCount(axml.XmlAttributes) GT 0>
						 <cfset astr['_attributes'] = axml.XmlAttributes />
					</cfif>
				</cfif>
				<!--- else: assign node value as last element of array: --->
				<!--- if there are any attributes on this element--->
				<cfif IsStruct(aXml.XmlChildren[i].XmlAttributes) AND StructCount(aXml.XmlChildren[i].XmlAttributes) GT 0>
					<!--- assign the text --->
					<cfset astr[n] = xmlUnformat(axml.XmlChildren[i].xmlCData, "html") />
						<!--- check if there are no attributes with xmlns: , we dont want namespaces to be in the response--->
					 <cfset attrib_list = StructKeylist(axml.XmlChildren[i].XmlAttributes) />
					 <cfloop from="1" to="#listLen(attrib_list)#" index="attrib">
						 <cfif ListgetAt(attrib_list,attrib) CONTAINS "xmlns:">
							 <!--- remove any namespace attributes--->
							<cfset Structdelete(axml.XmlChildren[i].XmlAttributes, listgetAt(attrib_list,attrib))>
						 </cfif>
					 </cfloop>
					 <!--- if there are any atributes left, append them to the response--->
					 <cfif StructCount(axml.XmlChildren[i].XmlAttributes) GT 0>
						 <cfset astr[n&'_attributes'] = axml.XmlChildren[i].XmlAttributes />
					</cfif>
				<cfelse>
					 <cfset astr[n] = xmlUnformat(axml.XmlChildren[i].xmlCData, "html") />
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<!--- return struct: --->
	<cfreturn astr />
</cffunction>





<!--- replaces special characters created by xmlFormat  --->
<cffunction name="xmlUnformat" returntype="string" output="false">
	<cfargument name="xmlString" default="">
	<cfargument name="formatType" default="htmlDisplay">
	
	<!--- replace characters for html --->
	<cfif arguments.formatType eq "html">
		<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&apos;", "&##39;", "all")>
	
	<!--- replace characters for htmlDisplay --->
	<cfelseif arguments.formatType eq "htmlDisplay">
		<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&apos;", "&##39;", "all")>
		<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "#chr(10)#", "<br>", "all")>
		
	<!--- replace characters for text --->
	<cfelseif arguments.formatType eq "text">
		<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&apos;", "'", "all")>
	    <cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&quot;", """", "all")>
	    <cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&lt;", "<", "all")>
	    <cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&gt;", ">", "all")>
	    <cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&amp;", "&", "all")>
	</cfif>

	<!--- replace characters for all --->
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xa1;", "¡", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC0;", "À", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC1;", "Á", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC2;", "Â", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC3;", "Ã", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC4;", "Ä", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC5;", "Å", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC7;", "Ç", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC8;", "È", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xC9;", "É", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xCA;", "Ê", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xCB;", "Ë", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xCC;", "Ì", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xCD;", "Í", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xCE;", "Î", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xCF;", "Ï", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD1;", "Ñ", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD2;", "Ò", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD3;", "Ó", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD4;", "Ô", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD5;", "Õ", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD6;", "Ö", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD8;", "Ø", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xD9;", "Ù", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xDA;", "Ú", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xDB;", "Û", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xDC;", "Ü", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##x0178;", "Ÿ", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE0;", "à", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE1;", "á", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE2;", "â", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE3;", "ã", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE4;", "ä", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE5;", "å", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE7;", "ç", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE8;", "è", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xE9;", "é", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xEA;", "ê", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xEB;", "ë", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xEC;", "ì", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xED;", "í", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xEE;", "î", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xEF;", "ï", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF1;", "ñ", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF2;", "ò", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF3;", "ó", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF4;", "ô", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF5;", "õ", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF6;", "ö", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF8;", "ø", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xF9;", "ù", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xFA;", "ú", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xFB;", "û", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xFC;", "ü", "all")>
	<cfset arguments.xmlString = replaceNoCase(arguments.xmlString, "&##xFF;", "ÿ", "all")>

	<!--- return the formatted string --->
	<cfreturn arguments.xmlString>
</cffunction>



</cfcomponent>