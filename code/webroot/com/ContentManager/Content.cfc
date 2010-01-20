<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="ContentID" type="numeric" default="">
	<cfproperty name="CategoryID" type="numeric" default="">
	<cfproperty name="ContentName" type="string" default="">
	<cfproperty name="ContentTypeID" type="numeric" default="">
	<cfproperty name="ContentActive" type="boolean" default="">
	<cfproperty name="ContentIndexed" type="boolean" default="">
	<cfproperty name="PropertiesID" type="numeric" default="">
	<cfproperty name="ContentPriority" type="numeric" default="">
	<cfproperty name="SourceID" type="numeric" default="">
	<cfproperty name="InheritID" type="numeric" default="">
	<cfproperty name="ContentDate1" type="date" default="">
	<cfproperty name="ContentDate2" type="date" default="">
	
	<!--- Custom Properties  --->	
	<cfproperty name="ContentAbstract" type="string" default="">
	<cfproperty name="ShowProductRangeID" type="numeric" default="">
	<cfproperty name="ShowNavigationRangeID" type="numeric" default="">
	<cfproperty name="DisplayModeID" type="numeric" default="">
	<cfproperty name="ShowQuestionRangeID" type="numeric" default="">
	<cfproperty name="lArticleID" type="string" default="">
	<cfproperty name="lRelatedCategoryID" type="string" default="">
	<cfproperty name="SourceCategoryID" type="numeric" default="">
	<cfproperty name="OwnerEmail" type="string" default="">
	<cfproperty name="OwnerName" type="string" default="">
	
	<cfset structInsert(sPropertyDisplayName,"ContentID","content ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryID","category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentName","content name",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentTypeID","display template ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentActive","content active",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentIndexed","content indexed",1)>
	<cfset structInsert(sPropertyDisplayName,"PropertiesID","properties ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentPriority","content priority",1)>
	<cfset structInsert(sPropertyDisplayName,"SourceID","source content ID",1)>
	<cfset structInsert(sPropertyDisplayName,"InheritID","inherit ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentDate1","date",1)>
	<cfset structInsert(sPropertyDisplayName,"ContentDate2","date",1)>
	
	<!--- Custom Properties  --->
	<cfset structInsert(sPropertyDisplayName,"ContentAbstract","content abstract",1)>
	<cfset structInsert(sPropertyDisplayName,"ShowProductRangeID","show product range",1)>
	<cfset structInsert(sPropertyDisplayName,"ShowNavigationRangeID","show navigation range",1)>
	<cfset structInsert(sPropertyDisplayName,"DisplayModeID","display mode",1)>
	<cfset structInsert(sPropertyDisplayName,"ShowQuestionRangeID","show question range",1)>
	<cfset structInsert(sPropertyDisplayName,"lArticleID","article list",1)>
	<cfset structInsert(sPropertyDisplayName,"lRelatedCategoryID","related categories",1)>
	<cfset structInsert(sPropertyDisplayName,"SourceCategoryID","source category id",1)>
	<cfset structInsert(sPropertyDisplayName,"OwnerEmail","Owner Email",1)>
	<cfset structInsert(sPropertyDisplayName,"OwnerName","Owner Name",1)>
	
	<cfset this.sFields=StructNew()>
	<cfset BaseFieldList="ContentName,CategoryID,ContentTypeID,ContentPositionID,ContentActive,propertiesID,ContentPriority,ContentAbstract"><!--- charlie --->
	<cfloop index="ThisContentTypeID" list="200,201,206,207,212,217,218,221,222,232,233,228,230,234,235,236,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266">
		<cfswitch expression="#ThisContentTypeID#">
			<cfcase value="206"><!--- Repeated Content --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,SourceID,InheritID">
			</cfcase>
			<cfcase value="245"><!--- Banner --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,SourceID,InheritID">
			</cfcase>
			<cfcase value="233"><!--- Content Template --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="234"><!--- Templatized Content --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,InheritID,ContentIndexed,SourceID">
			</cfcase>
			<cfcase value="221"><!--- News Item --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,ContentDate1">
			</cfcase>
			<cfcase value="235"><!--- Event --->
				<!--- Source ID used differently here, fk to t_Event. --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,SourceID">
			</cfcase>
			<cfcase value="239,240"><!--- Event Related --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="238"><!--- Event Calendar --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,InheritID">
			</cfcase>
			<cfcase value="236"><!--- Event Listing --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,ShowNavigationRangeID,DisplayModeID,InheritID">
			</cfcase>
			<cfcase value="242,243,244"><!--- job Related --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="249"><!--- Gallery Thumbnail Navigation --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,SourceID">
			</cfcase>
			<cfcase value="250"><!--- Gallery Display --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,SourceID">
			</cfcase>
			<cfcase value="251"><!--- Event Registraiton --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,SourceID">
			</cfcase>
			<cfcase value="254"><!--- Content List (manual) --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="256"><!--- Article Listing --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="257"><!--- Design Archives --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="258"><!--- Header Banner --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="259"><!--- Search Results --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="264"><!--- RSS --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,DisplayModeID">
			</cfcase>
			<cfcase value="266"><!--- List of Files w/RSS --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,OwnerEmail,OwnerName">
			</cfcase>
			<cfcase value="265"><!--- Article List (manual) --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="230"><!---Related Content --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,DisplayModeID,InheritID">
			</cfcase>
			<cfdefaultcase><!--- Default --->
				<cfset this.sFields[ThisContentTypeID]="#BaseFieldList#,InheritID,ContentIndexed">
			</cfdefaultcase>
		</cfswitch>
	</cfloop>
	
	<cffunction name="GetRestrictionsPropertyList" returnType="string" output="false">
		
		<!--- init variables --->
		<cfset var ReturnString = "">
		
		<cfif ListFindNoCase(StructKeyList(this),"ContentTypeID")>
			<cfset ReturnString=this.sFields[this.ContentTypeID]>
		<cfelse>
			<cfset ReturnString=this.sFields["-1"]>
		</cfif>
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="constructor" returntype="boolean" output="false">
		<cfargument name="ID" default="0" type="numeric" required="false">
		
		<!--- init variables --->
		<cfset var ThisProperty = "">
		<cfset var GetItems = "">
		<cfset var GetContentProperties = "">
		<cfset var sProperties = "">
		
		<!--- Typically, use set methods in contructor. --->
		<cfset this.SetProperty("ContentID","-1")>
		<cfset this.SetProperty("CategoryID","-1")>
		<cfset this.SetProperty("ContentName","")>
		<cfset this.SetProperty("ContentTypeID","201")>
		<cfset this.SetProperty("ContentActive","1")>
		<cfset this.SetProperty("ContentIndexed","1")>
		<cfset this.SetProperty("PropertiesID","-1")>
		<cfset this.SetProperty("ContentPriority","-1")>
		<cfset this.SetProperty("SourceID","-1")>
		<cfset this.SetProperty("InheritID","1800")>
		<cfset this.SetProperty("ContentDate1","#Now()#")>
		<cfset this.SetProperty("ContentDate2","")>
		
		<!--- Custom Properties  --->
		<cfset this.SetProperty("ContentAbstract","")>
		<cfset this.SetProperty("ShowProductRangeID","")>
		<cfset this.SetProperty("ShowNavigationRangeID","1400")>
		<cfset this.SetProperty("DisplayModeID","2100")>
		<cfset this.SetProperty("ShowQuestionRangeID","1")>
		<cfset this.SetProperty("lArticleID","-1")>
		<cfset this.SetProperty("lRelatedCategoryID","-1")>
		<cfset this.SetProperty("SourceCategoryID","0")>
		<cfset this.SetProperty("OwnerEmail","")>
		<cfset this.SetProperty("OwnerName","")>
		
		<cfif Val(ARGUMENTS.ID) GT 0>
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_Content
				WHERE ContentID=<cfqueryparam value="#Val(ARGUMENTS.ID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetItems.recordcount EQ 1>
				<cfoutput query="GetItems">
					<cfset this.SetProperty("ContentID",ContentID)>
					<cfset this.SetProperty("CategoryID",CategoryID)>
					<cfset this.SetProperty("ContentName",ContentName)>
					<cfset this.SetProperty("ContentTypeID",ContentTypeID)>
					<cfset this.SetProperty("ContentActive",ContentActive)>
					<cfset this.SetProperty("ContentIndexed",ContentIndexed)>
					<cfset this.SetProperty("PropertiesID",PropertiesID)>
					<cfset this.SetProperty("ContentPriority",ContentPriority)>
					<cfset this.SetProperty("SourceID",SourceID)>
					<cfset this.SetProperty("InheritID",InheritID)>
					<cfset this.SetProperty("ContentDate1",ContentDate1)>
					<cfset this.SetProperty("ContentDate2",ContentDate2)>
					<!--- Custom Properties --->
					<cfquery name="GetContentProperties" datasource="#APPLICATION.DSN#">
						SELECT * FROM t_Properties WHERE PropertiesID = <cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif isWDDX(GetContentProperties.PropertiesPacket)>
						<cfwddx action="WDDX2CFML" input="#GetContentProperties.PropertiesPacket#" output="sProperties">
						<cfloop index="ThisProperty" list="ContentAbstract,ShowProductRangeID,ShowNavigationRangeID,DisplayModeID,ShowQuestionRangeID,lArticleID,lRelatedCategoryID,SourceCategoryID,OwnerEmail,OwnerName">
							<cfif StructKeyExists(sProperties,"#ThisProperty#")>
								<cfset this.SetProperty("#ThisProperty#",sProperties["#ThisProperty#"])>
							</cfif>
						</cfloop>
					</cfif>
				</cfoutput>

				<cfreturn true>
			<cfelse>
				<cfreturn false>
				<!--- If id is not present, return false. --->
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="save" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">
		
		<!--- init variables --->
		<cfset var thisContentID = "">
		<cfset var thisCategoryID = "">
		<cfset var thisContentName = "">
		<cfset var thisContentTypeID = "">
		<cfset var thisContentActive = "">
		<cfset var thisContentIndexed = "">
		<cfset var thisPropertiesID = "">
		<cfset var thisInheritID = "">
		<cfset var thisContentDate1 = "">
		<cfset var thisContentDate2 = "">
		<cfset var thisContentPriority = "">
		<cfset var thisSourceID = "">
		<cfset var ThisContentAbstract = "">
		<cfset var ThisShowProductRangeID = "">
		<cfset var ThisShowNavigationRangeID = "">
		<cfset var ThisDisplayModeID = "">
		<cfset var ThisShowQuestionRangeID = "">
		<cfset var ThislArticleID = "">
		<cfset var ThislRelatedCategoryID = "">
		<cfset var ThisSourceCategoryID = "">
		<cfset var ThisOwnerEmail = "">
		<cfset var ThisOwnerName = "">
		<cfset var sProperties = "">
		<cfset var DevNull = "">
		<cfset var InsertProperties = "">
		<cfset var GetNextPriority = "">
		<cfset var InsertContent = "">
		<cfset var UpdateContent = "">
		<cfset var GetProperties = "">
		<cfset var GetLocales = "">
		<cfset var success = "">
		<cfset var wProperties = "">
		
		<cfif IsCorrect()>
			<cfset thisContentID=this.GetProperty("ContentID")>
			<cfset thisCategoryID=this.GetProperty("CategoryID")>
			<cfset thisContentName=this.GetProperty("ContentName")>
			<cfset thisContentTypeID=this.GetProperty("ContentTypeID")>
			<cfset thisContentActive=this.GetProperty("ContentActive")>
			<cfset thisContentIndexed=this.GetProperty("ContentIndexed")>
			<cfset thisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset thisInheritID=this.GetProperty("InheritID")>
			<cfset thisContentDate1=this.GetProperty("ContentDate1")>
			<cfset thisContentDate2=this.GetProperty("ContentDate2")>
			<cfif Val(this.GetProperty("ContentPriority")) LTE "0">
				<cfset thisContentPriority="NULL">
			<cfelse>
				<cfset thisContentPriority=Val(this.GetProperty("ContentPriority"))>
			</cfif>
			<cfset thisSourceID=Val(this.GetProperty("SourceID"))>
			
			<cfset ThisContentAbstract=this.GetProperty("ContentAbstract")>
			<cfset ThisShowProductRangeID=this.GetProperty("ShowProductRangeID")>
			<cfset ThisShowNavigationRangeID=this.GetProperty("ShowNavigationRangeID")>
			<cfset ThisDisplayModeID=this.GetProperty("DisplayModeID")>
			<cfset ThisShowQuestionRangeID=this.GetProperty("ShowQuestionRangeID")>
			<cfset ThislArticleID=this.GetProperty("lArticleID")>
			<cfset ThislRelatedCategoryID=this.GetProperty("lRelatedCategoryID")>
			<cfset ThisSourceCategoryID=this.GetProperty("SourceCategoryID")>
			<cfset ThisOwnerEmail=this.GetProperty("OwnerEMail")>
			<cfset ThisOwnerName=this.GetProperty("OwnerName")>
			
			<cfif Val(thisContentID) LTE "0">
				<cftransaction>
					<cfquery name="InsertProperties" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_Properties (PropertiesPacket)
						VALUES ('')
						SELECT NewTeaserID=@@Identity
					</cfquery>
					<cfset thisPropertiesID=InsertProperties.NewTeaserID>
					<cfset this.SetProperty("PropertiesID",InsertProperties.NewTeaserID)>
					
					<cfif Val(ThisContentPriority) IS "0">
						<cfquery name="GetNextPriority" datasource="#APPLICATION.DSN#">
							SELECT max(ContentPriority) as MaxPriority FROM t_Content WHERE CategoryID=#Val(thisCategoryID)#
						</cfquery>
						<cfset ThisContentPriority=Val(GetNextPriority.MaxPriority)+10>
						<cfset this.SetProperty("ContentPriority",ThisContentPriority)>
					</cfif>
					
					<cfquery name="InsertContent" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_Content (
						CategoryID,
						ContentName,
						ContentActive,
						ContentPriority,
						ContentTypeID,
						ContentIndexed,
						PropertiesID,
						SourceID,
						InheritID,
						ContentDate1,
						ContentDate2
						) VALUES (
						<cfqueryparam value="#ThisCategoryID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#trim(ThisContentName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Val(ThisContentActive)#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Val(ThisContentPriority)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisContentTypeID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisContentIndexed)#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Val(ThisPropertiesID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisSourceID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisInheritID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#ThisContentDate1#" cfsqltype="cf_sql_date" null="#not isDate(thisContentDate1)#">,
						<cfqueryparam value="#ThisContentDate2#" cfsqltype="cf_sql_date" null="#not isDate(thisContentDate2)#">
						)
						SELECT NewContentID=@@Identity
					</cfquery>
					<cfset ThisContentID=InsertContent.NewContentID>
					<cfset this.SetProperty("ContentID",InsertContent.NewContentID)>
					<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
					
				</cftransaction>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="Content"
						KeyID="#thisContentID#"
						Operation="create"
						EntityName="#ThisContentName#">
				</cfif>
			<cfelse>
				<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
					UPDATE t_Content
					SET
					ContentName=<cfqueryparam value="#trim(ThisContentName)#" cfsqltype="cf_sql_varchar">,
					CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
					ContentActive=<cfqueryparam value="#Val(ThisContentActive)#" cfsqltype="cf_sql_bit">,
					ContentIndexed=<cfqueryparam value="#Val(ThisContentIndexed)#" cfsqltype="cf_sql_bit">,
					ContentPriority=<cfqueryparam value="#Val(ThisContentPriority)#" cfsqltype="cf_sql_integer">,
					ContentTypeID=<cfqueryparam value="#Val(ThisContentTypeID)#" cfsqltype="cf_sql_integer">,
					SourceID=<cfqueryparam value="#Val(ThisSourceID)#" cfsqltype="cf_sql_integer">,
					InheritID=<cfqueryparam value="#Val(ThisInheritID)#" cfsqltype="cf_sql_integer">,
					ContentDate1=<cfqueryparam value="#ThisContentDate1#" cfsqltype="cf_sql_date" null="#not isDate(thisContentDate1)#">,
					ContentDate2=<cfqueryparam value="#ThisContentDate2#" cfsqltype="cf_sql_date" null="#not isDate(thisContentDate2)#">
					WHERE ContentID=<cfqueryparam value="#val(ThisContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="Content"
						KeyID="#thisContentID#"
						Operation="modify"
						EntityName="#ThisContentName#">
				</cfif>
			</cfif>
			<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
				SELECT	t_Properties.PropertiesID,t_Properties.PropertiesPacket
				FROM	t_Properties 
				WHERE	PropertiesID = <cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif isWDDX(GetProperties.PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfelse>
				<cfset sProperties=StructNew()>
			</cfif>

			<cfset DevNull=StructInsert(sProperties,"ContentAbstract","#Trim(ThisContentAbstract)#",1)>
			<cfset DevNull=StructInsert(sProperties,"ShowProductRangeID","#val(ThisShowProductRangeID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"ShowNavigationRangeID","#val(ThisShowNavigationRangeID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"DisplayModeID","#val(ThisDisplayModeID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"ShowQuestionRangeID","#val(ThisShowQuestionRangeID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"lArticleID","#trim(ThislArticleID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"lRelatedCategoryID","#trim(ThislRelatedCategoryID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"SourceCategoryID","#trim(ThisSourceCategoryID)#",1)>
			<cfset DevNull=StructInsert(sProperties,"OwnerEMail","#trim(ThisOwnerEmail)#",1)>
			<cfset DevNull=StructInsert(sProperties,"OwnerName","#trim(ThisOwnerName)#",1)>
			
			<cfwddx action="CFML2WDDX" input="#sProperties#" output="wProperties">
			<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
				UPDATE t_Properties
				SET PropertiesPacket=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_varchar">
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfif ThisInheritID GT "1800"><!--- If this elt is inherited, then update all sub pages' cache timestamp --->
				<CF_getbranch item="#ThisCategoryID#" DataSource="#APPLICATION.DSN#" 
					table="t_Category" Column="CategoryID" ParentColumn="ParentID">
				<cfloop index="ThisCategoryID" list="#Branch#">
					<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
						Lookup="Category"
						KeyID="#ThisCategoryID#">
					<cfif Val(ARGUMENTS.UserID) GT "0">
						<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
							UserID="#ARGUMENTS.UserID#"
							Entity="Category"
							KeyID="#thisCategoryID#"
							Operation="Touch"
							EntityName="#ThisContentName#">
					</cfif>
				</cfloop>
			<cfelse>
				<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
					Lookup="Content"
					KeyID="#thisContentID#">
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="/com/utils/tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="Category"
						KeyID="#thisCategoryID#"
						Operation="Touch"
						EntityName="#ThisContentName#">
				</cfif>
			</cfif>
			
			<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
				select * from t_locale
			</cfquery>
			
			<cfif ThisContentTypeID IS "235">
				<cfoutput query="GetLocales">
					<cfinvoke component="com.ContentManager.ContentHandler" method="UpdatePriorityByEventDate" returnVariable="success"
						CategoryID="#ThisCategoryID#"
						LocaleID="#LocaleID#">
				</cfoutput>
			</cfif>
			
			<cfif ThisContentTypeID IS "221">
				<cfoutput query="GetLocales">
					<cfinvoke component="com.ContentManager.ContentHandler" method="UpdatePriorityByContentDate" returnVariable="success"
						CategoryID="#ThisCategoryID#"
						LocaleID="#LocaleID#">
				</cfoutput>
			</cfif>
			
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="AdjustPriorities" returntype="boolean" output="false">
		<cfargument name="sNewPriorities" required="true">
		
		<!--- init variables --->
		<cfset var ThisContentID = "">
		<cfset var UpdateRank = "">
		<cfset var GetCategoryID = "">
		<cfset var GetCatsAgain = "">
		<cfset var UpdateAgain = "">
		
		<cfif IsStruct(ARGUMENTS.sNewPriorities) AND ListLen(StructKeyList(sNewPriorities)) GT "0">
			<cfloop index="ThisContentID" list="#StructKeyList(sNewPriorities)#">
				<cfquery name="UpdateRank" datasource="#APPLICATION.DSN#">
					UPDATE t_Content
					SET ContentPriority = <cfqueryparam value="#val(sNewPriorities[ThisContentID])#" cfsqltype="cf_sql_integer">
					WHERE ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfloop>
			<cfquery name="GetCategoryID" datasource="#APPLICATION.DSN#" maxrows="1">
				select CategoryID from t_Content where ContentID=<cfqueryparam value="#Val(ListFirst(StructKeyList(sNewPriorities)))#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="GetCatsAgain" datasource="#APPLICATION.DSN#">
				select * from t_Content where CategoryID=<cfqueryparam value="#Val(GetCategoryID.CategoryID)#" cfsqltype="cf_sql_integer"> order by ContentPriority
			</cfquery>
			<cfoutput query="GetCatsAgain">
				<cfquery name="UpdateAgain" datasource="#APPLICATION.DSN#">
					UPDATE t_Content
					SET ContentPriority = <cfqueryparam value="#val(evaluate('#CurrentRow#*10'))#" cfsqltype="cf_sql_integer">
					WHERE ContentID=<cfqueryparam value="#Val(ContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfoutput>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="SetProperty" returntype="boolean" output="false">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">
		
		<!--- init variables --->
		<cfset var Test = "">
		
		<cfset ARGUMENTS.Property=Trim(ARGUMENTS.Property)>
				
		<cfif IsSimpleValue(ARGUMENTS.Value)>
			<cfset ARGUMENTS.Value=Trim(ARGUMENTS.Value)>

			<cfif ListFindNoCase("ContentID,CategoryID,PropertiesID,ContentTypeID,ContentPriority,ContentPositionID,SourceID,InheritID",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsNumeric(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid number.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("ContentDate1,ContentDate2",ARGUMENTS.Property) AND ARGUMENTS.VALUE IS NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("ContentName",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("CategoryID,ContentTypeID,ContentPositionID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>
			
			<cfif ListFindNoCase("ContentName",ARGUMENTS.Property)>
				<cfif Len(ARGUMENTS.Value) GT "128">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 128 characters long.")>
					<cfreturn false>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("SourceID",ARGUMENTS.Property)>
				<cfif StructKeyExists(this,"ContentTypeID") and ListFindNoCase("206,245",this.ContentTypeID)>
					<cfif val(ARGUMENTS.Value) LTE "0">
						<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# is required.")>
						<cfreturn false>
					</cfif>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("lArticleID",ARGUMENTS.Property)>
				<cfif StructKeyExists(this,"ContentTypeID") and this.ContentTypeID IS "214">
					<cfif trim(ARGUMENTS.Value) IS "">
						<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# is required.")>
						<cfreturn false>
					</cfif>
				</cfif>
			</cfif>
			
			<cfif ListFindNoCase("CategoryID,ContentTypeID,ContentPositionID,InheritID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="CategoryID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Category">
								<cfinvokeargument name="FieldName" value="CategoryID">
								<cfinvokeargument name="FieldValue" value="#Val(ARGUMENTS.Value)#">
								<cfinvokeargument name="SortFieldName" value="CategoryAlias">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ContentTypeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="70,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
							<cfset This.ContentIndexed="0">
						</cfcase>
						<!--- <cfcase value="ContentPositionID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="90,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase> --->
						<cfcase value="ShowProductRangeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="180,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ShowNavigationRangeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="2000,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ShowQuestionRangeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="220,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="SourceID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Content">
								<cfinvokeargument name="FieldName" value="ContentID">
								<cfinvokeargument name="FieldValue" value="#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="ContentID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="InheritID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="230,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelID">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
					</cfswitch>
				<cfelse>
					<cfset ARGUMENTS.Value="-1">
				</cfif>
			</cfif>
		</cfif>
		
		<cfset SetVariable("this.#ARGUMENTS.Property#","#ARGUMENTS.Value#")>
		<cfset deleteError(ARGUMENTS.Property)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="GetProperty" returntype="Any" output="false">
		<cfargument name="Property" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfif IsInError(ARGUMENTS.Property)>
			<cfreturn GetErrorValue(ARGUMENTS.Property)>
		<cfelse>
			<cfset ReturnValue=this["#ARGUMENTS.Property#"]>
			<cfreturn ReturnValue>
		</cfif>
	</cffunction>
	
	<cffunction name="CreateResourcePath" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfinvoke component="com.ContentManager.ContentHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			ContentID="#this.GetProperty('ContentID')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfinvoke component="com.ContentManager.ContentHandler"
			method="GetResourcePath"
			returnVariable="ReturnValue"
			ContentID="#this.GetProperty('ContentID')#"
			ResourceType="#ARGUMENTS.ResourceType#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">
		
		<!--- init variables --->
		<cfset var ReturnValue = "">
		
		<cfinvoke component="com.ContentManager.ContentHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			ContentID="#this.GetProperty('ContentID')#"
			ResourceType="#ARGUMENTS.ResourceType#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>
	
	<cffunction name="GetContentTypeName" returnType="String" output="false">
		<cfset var ReturnString="">
		<cfset var Test="">
		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Label">
			<cfinvokeargument name="FieldName" value="LabelID">
			<cfinvokeargument name="FieldValue" value="#this.GetProperty('ContentTypeID')#">
		</cfinvoke>
		<cfset ReturnString="#ValueList(Test.LabelName)#">
		<cfreturn ReturnString>
	</cffunction>
	
	<cffunction name="GetSiblingQuery" returnType="query" output="false">
		
		<!--- init variables --->
		<cfset var ThisCategoryID = "">
		<cfset var GetSiblingQuery = "">
		
		<cfset ThisCategoryID=this.GetProperty("CategoryID")>
		<cfif ThisCategoryID LTE "0">
			<cfset ThisCategoryID="-1">
		</cfif>
		<cfquery name="GetSiblingQuery" datasource="#APPLICATION.DSN#" dbtype="ODBC">
			SELECT * FROM qry_GetContent WHERE CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer"> order by ContentPriority
		</cfquery>
		<cfreturn GetSiblingQuery>
	</cffunction>
	
	<cffunction name="Delete" returnType="boolean" output="1">
		<cfargument name="TrashPath" required="true">
		<cfargument name="UserID" required="true">
		
		<!--- init variables --->
		<cfset var ThisContentID = "">
		<cfset var MyContentLocale = "">
		<cfset var MyContent = "">
		<cfset var DirDone = "">
		<cfset var DirectoryToCreate = "">
		<cfset var DestImages = "">
		<cfset var DestDocs = "">
		<cfset var SourceImages = "">
		<cfset var SourceDocs = "">
		<cfset var RemoteDirectories = "">
		<cfset var ThisDirectory = "">
		<cfset var i = "">
		<cfset var GetContentLocale = "">
		<cfset var GetContentRepeated = "">
		<cfset var SelectProps = "">
		<cfset var deleteContent1 = "">
		<cfset var deleteContent3 = "">
		<cfset var SelectContentFromProd = "">
		<cfset var DeleteContent = "">
		<cfset var DeleteContentProps = "">
		<cfset var success = "">
		<cfset var sProductionSiteInformation = "">
		<cfset var List = "">
		
		<cfif ARGUMENTS.TrashPath IS NOT "" and this.GetProperty("ContentID") GT "0">
			<cfset ThisContentID=this.GetProperty("ContentID")>
			<!--- First delete content locale records --->
			<cfquery name="GetContentLocale" datasource="#APPLICATION.DSN#">
				select ContentLocaleID from t_ContentLocale Where ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfoutput query="GetContentLocale">
				<cfset MyContentLocale=CreateObject("component","com.ContentManager.ContentLocale")>
				<cfset MyContentLocale.Constructor(Val(ContentLocaleID))>
				<cfset MyContentLocale.Delete(ARGUMENTS.TrashPath,ARGUMENTS.UserID)>
			</cfoutput>
			<!--- Then delete content records that have this content as its source, AKA recurring content. --->
			<cfif 0>
				<cfquery name="GetContentRepeated" datasource="#APPLICATION.DSN#">
					select ContentID from t_Content Where SourceID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfoutput query="GetContentRepeated">
					<cfset MyContent=CreateObject("component","com.ContentManager.Content")>
					<cfset MyContent.Constructor(Val(ContentID))>
					<cfset MyContent.Delete(ARGUMENTS.TrashPath,ARGUMENTS.UserID)>
				</cfoutput>
			</cfif>
			
			<cftransaction>
				<!--- Create trash paths --->
				<cfset DirDone="">
				<cfloop index="i" from="1" to="#Len(ThisContentID)#" step="1">
					<cfset DirectoryToCreate="#ARGUMENTS.TrashPath##APPLICATION.ContentResourcesPath##DirDone##Mid(ThisContentID,i,1)#">
					<cfset DirDone="#DirDone##Mid(ThisContentID,i,1)#\">
					<cftry>
						<cfdirectory action="CREATE" directory="#DirectoryToCreate#">
						<cfdirectory action="CREATE" directory="#DirectoryToCreate#/images/">
						<cfdirectory action="CREATE" directory="#DirectoryToCreate#/documents/">
						<cfcatch></cfcatch>
					</cftry>
				</cfloop>
				<cfset DestImages="#DirectoryToCreate#\images\">
				<cfset DestDocs="#DirectoryToCreate#\documents\">
				
				<cfquery name="SelectProps" datasource="#APPLICATION.DSN#">
					SELECT PropertiesID FROM t_Content WHERE ContentID=<cfqueryparam value="#ThisContentID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent1" datasource="#APPLICATION.DSN#">
					DELETE FROM t_Content WHERE ContentID=<cfqueryparam value="#val(ThisContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent1" datasource="#APPLICATION.DSN#">
					DELETE FROM t_ContentLocaleMeta WHERE ContentID=<cfqueryparam value="#val(ThisContentID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="deleteContent3" datasource="#APPLICATION.DSN#">
					DELETE FROM t_properties WHERE PropertiesID=<cfqueryparam value="#Val(SelectProps.PropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				
				
				<cfset DirDone="">
				<cfloop index="i" from="1" to="#Len(ThisContentID)#" step="1">
					<cfset DirectoryToCreate="#APPLICATION.WebRootPath##APPLICATION.ContentResourcesPath##DirDone##Mid(ThisContentID,i,1)#">
					<cfset DirDone="#DirDone##Mid(ThisContentID,i,1)#\">
				</cfloop>
				<cfset SourceImages="#DirectoryToCreate#\images\">
				<cfset SourceDocs="#DirectoryToCreate#\documents\">
				<CF_DIRECTORYTREE ACTION="copytree" SOURCE="#SourceImages#" DESTINATION="#DestImages#" NAMECONFLICT="overwrite">
				<CF_DIRECTORYTREE ACTION="copytree" SOURCE="#SourceDocs#" DESTINATION="#DestDocs#" NAMECONFLICT="overwrite">
				<cfif DirectoryExists("#SourceImages#")>
					<cf_deletedirectory directory="#SourceImages#">
					<cfdirectory action="CREATE" directory="#SourceImages#">
				</cfif>
				<cfif DirectoryExists("#SourceDocs#")>
					<cf_deletedirectory directory="#SourceDocs#">
					<cfdirectory action="CREATE" directory="#SourceDocs#">
				</cfif>
			</cftransaction>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Content"
				KeyID="#thisContentID#">
				
			<cfif Val(ARGUMENTS.UserID) GT "0">
				<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
					UserID="#ARGUMENTS.UserID#"
					Entity="Content"
					KeyID="#this.GetProperty('ContentID')#"
					Operation="delete"
					EntityName="#This.GetProperty('ContentName')#">
			</cfif>
			
			<cfinvoke component="com.ContentManager.CategoryHandler" 
				method="GetProductionSiteInformation"
				returnVariable="sProductionSiteInformation"
				CategoryID="#this.GetProperty('CategoryID')#">
				
			<cfif IsStruct(sProductionSiteInformation)>
				<cftransaction>
					<cfquery name="SelectContentFromProd" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SELECT ContentID, PropertiesID FROM t_content where ContentID=<cfqueryparam value="#Val(ThisContentID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfoutput query="SelectContentFromProd">
						<cfquery name="DeleteContent" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_Content WHERE ContentID=<cfqueryparam value="#Val(ContentID)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery name="DeleteContentProps" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_Properties WHERE PropertiesID=<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfoutput>
				</cftransaction>
				<cfset RemoteDirectories=ArrayNew(1)>
				<cfset RemoteDirectories[1]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('images')#">
				<cfset RemoteDirectories[2]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('documents')#">
				<cfset RemoteDirectories[3]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('generated')#">
				<cfloop index="i" from="1" to="3" step="1">
					<cfset ThisDirectory=Replace(RemoteDirectories[i],"//","/","All")>
					<cfftp action="LISTDIR" server="#sProductionSiteInformation.ProductionFTPHost#" 
						username="#sProductionSiteInformation.ProductionFTPUserLogin#"
						password="#sProductionSiteInformation.ProductionFTPPassword#" 
						stoponerror="No" name="List" directory="#ThisDirectory#"
						connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#"
						Passive="No">
					<cfoutput query="List">
						<cfif NOT IsDirectory>
							<cfftp action="REMOVE" server="#sProductionSiteInformation.ProductionFTPHost#"
								username="#sProductionSiteInformation.ProductionFTPUserLogin#"
								password="#sProductionSiteInformation.ProductionFTPPassword#" 
								stoponerror="No"
								item="#Path#"
								connection="FTP_#ReplaceNoCase(sProductionSiteInformation.ProductionFTPHost,'.','','all')#"
								Passive="No">
						</cfif>
					</cfoutput>
				</cfloop>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveToProduction" returntype="string" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="UserID" required="true">

		<!--- init variables --->
		<cfset var ThisContentID = "">
		<cfset var ThisPropertiesID = "">
		<cfset var ThisCategoryID = "">
		<cfset var GetProps = "">
		<cfset var DeleteContentOnProduction2 = "">
		<cfset var UpdateContentOnProduction4 = "">
		<cfset var sProductionSiteInformation = "">
		<cfset var success = "">
		<cfset var SaveResults = "">
		
		<cfinvoke component="com.ContentManager.CategoryHandler" 
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="#this.GetProperty('CategoryID')#">
		
		<cfif IsCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisContentID=this.GetProperty("ContentID")>
			<cfset ThisPropertiesID=this.GetProperty("PropertiesID")>
			
			
			<cfinvoke component="com.PostToProduction.postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisContentID#">
			     <cfinvokeargument name="columnList" value="ContentID">
			     <cfinvokeargument name="tableName" value="t_Content">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>
			
			<cfquery name="GetProps" datasource="#APPLICATION.DSN#">
				select * from t_Properties Where PropertiesID=<cfqueryparam value="#Val(ThisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfoutput query="GetProps">
				<cfquery name="DeleteContentOnProduction2" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					DELETE FROM t_Properties WHERE PropertiesID=<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="UpdateContentOnProduction4" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					SET IDENTITY_INSERT t_Properties ON
					INSERT INTO t_Properties (
					PropertiesPacket,
					PropertiesID
					) VALUES (
					<cfqueryparam value="#Trim(PropertiesPacket)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					)
					SET IDENTITY_INSERT t_Properties OFF
				</cfquery>
			</cfoutput>
			
			<cfif this.GetProperty("InheritID") GT "1800"><!--- If this elt is inherited, then update all sub pages' cache timestamp --->
				<CF_getbranch item="#this.GetProperty('CategoryID')#" DataSource="#sProductionSiteInformation.ProductionDBDSN#" 
					table="t_Category" Column="CategoryID" ParentColumn="ParentID">
				<cfloop index="ThisCategoryID" list="#Branch#">
					<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
						Lookup="Category"
						KeyID="#ThisCategoryID#"
						datasource="#sProductionSiteInformation.ProductionDBDSN#">
				</cfloop>
			</cfif>

			<!--- Create the directories on the production server --->
			<!--- Open connection to the ftp server --->
			<cfinvoke component="com.ContentManager.ContentHandler" method="CreateRemoteFolders" returnVariable="success"
				ContentID="#ThisContentID#"
				FTPHost="#sProductionSiteInformation.ProductionFTPHost#"
				FTPRootPath="#sProductionSiteInformation.ProductionFTPRootPath#"
				FTPUserLogin="#sProductionSiteInformation.ProductionFTPUserLogin#"
				FTPPassword="#sProductionSiteInformation.ProductionFTPPassword#">
			
			<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
				UserID="#ARGUMENTS.UserID#"
				Entity="Content"
				KeyID="#ThisContentID#"
				Operation="savelive"
				EntityName="#This.Getproperty('ContentName')#">
				
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="GetContentTypeIDSetQuery" returnType="Query" output="false">
		
		<!--- init variables --->
		<cfset var GetParentCategory = "">
		<cfset var GetCategoryTypes = "">
		
		<cfquery name="GetParentCategory" datasource="#APPLICATION.DSN#">
			SELECT CategoryTypeID,CategoryName,CategoryAlias FROM t_Category 
			WHERE CategoryID=<cfqueryparam value="#val(this.GetProperty('CategoryID'))#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfquery name="GetCategoryTypes" datasource="#APPLICATION.DSN#">
			SELECT * FROM t_Label WHERE LabelGroupID=70 AND 
			<cfswitch expression="#GetParentCategory.CategoryTypeID#">
				<cfcase value="73"><!--- Gallery --->
					LabelID IN (212)<!--- Only image --->
				</cfcase>
				<cfcase value="71"><!--- Event List --->
					LabelID IN (235)<!--- Only event --->
				</cfcase>
				<cfcase value="67"><!--- Event List --->
					LabelID IN (221)<!--- Only event --->
				</cfcase>
				<cfcase value="66"><!--- Article --->
					LabelID IN (222,255)<!--- Only article body, list of files, list of links --->
				</cfcase>
				<cfdefaultcase><!---  --->
					LabelID NOT IN (235,221)
				</cfdefaultcase>
			</cfswitch>
			ORDER BY labelPriority
		</cfquery>
		<cfreturn GetCategoryTypes>
	</cffunction>
</cfcomponent>