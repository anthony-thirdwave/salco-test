<cfcomponent>
	<cffunction name="GetProductSpecs" returntype="query" output="false" access="remote">
		<cfargument name="ProductAlias" default="" type="string" required="true">
		<cfargument name="LanguageID" default="" type="numeric" required="true">
		<cfargument name="SpecificationSetID" default="8000" type="numeric" required="true">
		
		<cfquery name="GetProductID" datasource="#APPLICATION.DSN#" maxrows="1">
			select CategoryID from t_category
			WHERE CategoryAlias=<cfqueryparam value="#Trim(ARGUMENTS.ProductAlias)#" cfsqltype="CF_SQL_VARCHAR" maxlength="128">
		</cfquery>
		
		<cfset ThisProductID=Val(GetProductID.CategoryID)>
		
		<cfinvoke component="/com/Product/ProductHandler"
			method="GetProductFamilyID"
			returnVariable="CurrentProductFamilyID"
			ProductID="#Val(ThisProductID)#">
		
		<cfset ProductIDList=Val(ThisProductID)>
		<cfset sProductSet=StructNew()>
		<cfloop index="ThisProductID" list="#Val(ProductIDList)#">
			<cfif ARGUMENTS.LanguageID IS APPLICATION.DefaultLanguageID>
				<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
					select * from qry_GetProductAttribute 
					WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And 
					LanguageID=#Val(ARGUMENTS.LanguageID)# and AttributeLanguageID=#Val(ARGUMENTS.LanguageID)#
					AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
					ORDER By  ProductFamilyAttributePriority
				</cfquery>
			<cfelse>
				<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
					select * from qry_GetProductAttribute 
					WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And 
					LanguageID=#Val(ARGUMENTS.LanguageID)# and AttributeLanguageID=#Val(ARGUMENTS.LanguageID)#
					AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
					ORDER By  ProductFamilyAttributePriority, AttributeLanguageID desc
				</cfquery>
				<cfif GetAttributes.RecordCount IS "0" and ListFindNoCase("104,103",ARGUMENTS.LanguageID)>
					<cfquery name="GetAttributes" datasource="#APPLICATION.DSN#">
						select * from qry_GetProductAttribute 
						WHERE CategoryID=#Val(CurrentProductFamilyID)# And ProductID=#Val(ThisProductID)# And 
						LanguageID=#Val(APPLICATION.DefaultLanguageID)# and AttributeLanguageID=#Val(APPLICATION.DefaultLanguageID)#
						AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
						ORDER By  ProductFamilyAttributePriority
					</cfquery>
				</cfif>
			</cfif>
			<cfset sValues=StructNew()>
			<cfoutput query="GetAttributes" group="ProductFamilyAttributeID">
				<cfset sValueElt=StructNew()>
				<cfset StructInsert(sValueElt,"AttributeValueID",AttributeValueID,1)>
				<cfset StructInsert(sValueElt,"AttributeValue",AttributeValue,1)>
				<cfset StructInsert(sValues,ProductFamilyAttributeID,sValueElt,1)>
			</cfoutput>
			<cfset StructInsert(sProductSet,ThisProductID,sValues,1)>
		</cfloop>
		
		<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
			SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID,ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute 
			WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(ARGUMENTS.LanguageID)#
				AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
			order by ProductFamilyAttributePriority
		</cfquery>
		<cfif GetCols.RecordCount IS "0" and ListFindNoCase("104,103",ARGUMENTS.LanguageID)>
			<cfquery name="GetCols" datasource="#APPLICATION.DSN#">
				SELECT ProductFamilyAttributeID, ProductFamilyAttributeTypeID,ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute 
				WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(APPLICATION.DefaultLanguageID)#
					AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
				order by ProductFamilyAttributePriority
			</cfquery>
		</cfif>
		
		<cfquery name="GetIfLegend" datasource="#APPLICATION.DSN#">
			SELECT ProductFamilyAttributeID FROM qry_GetProductFamilyAttribute 
			WHERE CategoryID=#Val(CurrentProductFamilyID)# AND LanguageID=#Val(ARGUMENTS.LanguageID)# and ProductFamilyAttributeTypeID=602
				AND SpecificationSetID = #Val(ARGUMENTS.SpecificationSetID)#
		</cfquery>
		
		<cfset sCode1=StructNew()>
		<cfset StructInsert(sCode1,-1,"-",1)>
		<cfset StructInsert(sCode1,700,"S",1)>
		<cfset StructInsert(sCode1,701,"O",1)>
		<cfset StructInsert(sCode1,702,"-",1)>
		<cfset sCode2=StructNew()>
		<cfset StructInsert(sCode2,"ATTRVAL_S","S",1)>
		<cfset StructInsert(sCode2,"ATTRVAL_O","O",1)>
		<cfset StructInsert(sCode2,"ATTRVAL_U","-",1)>
		
		<cfset MajorCounter="1">
				
		<cfset ColumnList="ItemName,ItemValue">
		<cfset qReturn=QueryNew(ColumnList)>
		
		<cfoutput query="GetCols">
			<cfset QueryAddRow(qReturn,1)>
			<cfset QuerySetCell(qReturn,"ItemName",REQUEST.ReplaceMarks(ProductFamilyAttributeName))>
			<cfswitch expression="#ProductFamilyAttributeTypeID#">
				<cfcase value="602,603">
					<cfloop index="ii" from="1" to="#ListLen(ProductIDList)#" step="1">
						<cfif StructKeyExists(sProductSet[ListGetAt(ProductIDList,ii)],ProductFamilyAttributeID)>
							<cfif ProductFamilyAttributeTypeID IS "602">
								<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValueID>
								<cfset Answer=sCode1[Answer]>
							<cfelse>
								<cfset Answer=sProductSet[ListGetAt(ProductIDList,ii)][ProductFamilyAttributeID].AttributeValue>
								<cfif ListFind("ATTRVAL_S,ATTRVAL_O,ATTRVAL_U",Answer)>
									<cfset Answer=sCode2[Answer]>
								</cfif>
							</cfif>
						<cfelse>
							<cfset Answer="">
						</cfif>
						<cfset QuerySetCell(qReturn,"ItemValue",Answer)>
					</cfloop>
				</cfcase>
			</cfswitch>
		</cfoutput>
		
		<cfreturn qReturn>
	</cffunction>
</cfcomponent>