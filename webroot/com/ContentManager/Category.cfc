<cfcomponent extends="com.common.base" output="false">
	<!--- Declare properties. Properties are either string or object
		  (except error which is a struct --->
	<cfproperty name="CategoryID" type="numeric" default="">
	<cfproperty name="ParentID" type="numeric" default="">
	<cfproperty name="CategoryName" type="string" default="">
	<cfproperty name="CategoryAlias" type="string" default="">
	<cfproperty name="CategoryActive" type="boolean" default="">
	<cfproperty name="SourceID" type="numeric" default="">
	<cfproperty name="ShowInNavigation" type="boolean" default="">
	<cfproperty name="CategoryIndexed" type="boolean" default="">
	<cfproperty name="CategoryTypeID" type="numeric" default="">
	<cfproperty name="CategoryURL" type="string" default="">
	<cfproperty name="PropertiesID" type="numeric" default="">
	<cfproperty name="CategoryPriority" type="numeric" default="">
	<cfproperty name="DisplayLevel" type="numeric" default="">
	<cfproperty name="DisplayOrder" type="string" default="">
	<cfproperty name="WorkflowStatusID" type="numeric" default="">
	<cfproperty name="TemplateID" type="numeric" default="">
	<cfproperty name="PublishDateTime" type="date" default="">

	<!--- Custom Properties --->
	<cfproperty name="CategoryImageOff" type="string" default="">
	<cfproperty name="CategoryImageOn" type="string" default="">
	<cfproperty name="CategoryImageRollover" type="string" default="">
	<cfproperty name="CategoryImageHeader" type="string" default="">
	<cfproperty name="CategoryImageTitle" type="string" default="">
	<cfproperty name="AuthorName" type="string" default="">
	<cfproperty name="ArticleSourceID" type="numeric" default="">
	<cfproperty name="AllowComments" type="numeric" default="">
	<cfproperty name="AllowBackToTop" type="boolean" default="">
	<cfproperty name="ProductBrandLogoID" type="numeric" default="">
	<cfproperty name="ProductConsoleTypeID" type="numeric" default="">
	<cfproperty name="ProductProgramTypeID" type="numeric" default="">
	<cfproperty name="ColorID" type="numeric" default="">
	<cfproperty name="PressReleaseDate" type="date" default="">
	<cfproperty name="CommentNotificationEmail" type="string" default="">
	<cfproperty name="sCurrentResourceDetails" type="struct" default="">
	<cfproperty name="aOwner" type="array" default="">
	<cfproperty name="useSSL" type="boolean" default="">
	<cfproperty name="lTopicID" type="string" default="">

	<cfproperty name="ProductionFTPHost" type="string" default="">
	<cfproperty name="ProductionFTPRootPath" type="string" default="">
	<cfproperty name="ProductionFTPUserLogin" type="string" default="">
	<cfproperty name="ProductionFTPPassword" type="string" default="">
	<cfproperty name="ProductionDBServer" type="string" default="">
	<cfproperty name="ProductionDBName" type="string" default="">
	<cfproperty name="ProductionDBDSN" type="string" default="">

	<cfset structInsert(sPropertyDisplayName,"CategoryID","category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ParentID","parent category ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryName","category name",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryAlias","category alias",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryActive","category active",1)>
	<cfset structInsert(sPropertyDisplayName,"SourceID","Source ID",1)>
	<cfset structInsert(sPropertyDisplayName,"ShowInNavigation","show in navigation flag",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryIndexed","indexed flag",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryTypeID","category type ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryURL","category URL",1)>
	<cfset structInsert(sPropertyDisplayName,"PropertiesID","properties ID",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryPriority","category priority",1)>
	<cfset structInsert(sPropertyDisplayName,"DisplayLevel","display level",1)>
	<cfset structInsert(sPropertyDisplayName,"DisplayOrder","display order",1)>
	<cfset structInsert(sPropertyDisplayName,"WorkflowStatusID","workflow status ID",1)>
	<cfset structInsert(sPropertyDisplayName,"TemplateID","default display template id",1)>
	<cfset structInsert(sPropertyDisplayName,"PublishDateTime","publish date",1)>

	<!--- Custom Properties --->
	<cfset structInsert(sPropertyDisplayName,"CategoryImageOff","off image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageOn","on image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageRollover","highlight image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageHeader","header image",1)>
	<cfset structInsert(sPropertyDisplayName,"CategoryImageTitle","title image",1)>
	<cfset structInsert(sPropertyDisplayName,"TemplateID","default display template id",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionFTPHost","production FTP host",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionFTPRootPath","production FTP root path",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionFTPUserLogin","production FTP user login",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionFTPPassword","production FTP password",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionDBServer","production db server",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionDBName","production db name",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductionDBDSN","production db dsn",1)>
	<cfset structInsert(sPropertyDisplayName,"AuthorName","author name",1)>
	<cfset structInsert(sPropertyDisplayName,"ArticleSourceID","article source",1)>
	<cfset structInsert(sPropertyDisplayName,"AllowComments","allow printer friendly",1)>
	<cfset structInsert(sPropertyDisplayName,"AllowBackToTop","allow back to top link",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductBrandLogoID","product brand logo id",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductConsoleTypeID","product console type id",1)>
	<cfset structInsert(sPropertyDisplayName,"ProductProgramTypeID","product program type id",1)>
	<cfset structInsert(sPropertyDisplayName,"ColorID","color id",1)>
	<cfset structInsert(sPropertyDisplayName,"PressReleaseDate","press release date",1)>
	<cfset structInsert(sPropertyDisplayName,"CommentNotificationEmail","email to be sent comment notifications",1)>
	<cfset structInsert(sPropertyDisplayName,"sCurrentResourceDetails","resource details",1)>
	<cfset structInsert(sPropertyDisplayName,"aOwner","owners",1)>
	<cfset structInsert(sPropertyDisplayName,"useSSL","use ssl",1)>
	<cfset structInsert(sPropertyDisplayName,"foober","foo bar",1)><!--- bravo --->
	<cfset structInsert(sPropertyDisplayName,"lTopicID","Topics",1)>

	<!--- Determine field restrictions based on category type --->
	<cfset this.sFields=StructNew()>
	<cfset BaseFieldList="CategoryName,TemplateID,CategoryAlias,CategoryTypeID,CategoryActive,ParentID,PropertiesID,useSSL"><!--- charlie --->
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetAllCategoryType"
		returnVariable="GetAllCategoryType">
	<cfloop index="ThisCategoryTypeID" list="-1,#ValueList(GetAllCategoryType.LabelID)#">
		<cfswitch expression="#ThisCategoryTypeID#">
			<cfcase value="60,63,70"><!--- Content --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,lTopicID,PublishDateTime,ShowInNavigation,CategoryURL,TemplateID,WorkflowStatusID,AllowComments,CommentNotificationEmail">
			</cfcase>
			<cfcase value="78"><!--- Blog --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,lTopicID,ShowInNavigation,CategoryURL,TemplateID,WorkflowStatusID">
			</cfcase>
			<cfcase value="67"><!--- News List --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="71"><!--- event list --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="74"><!--- banner repository --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="75"><!--- BLOGMT --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,ShowInNavigation,CategoryIndexed">
			</cfcase>
			<cfcase value="65"><!--- Website --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer,ProductionDBName,ProductionDBDSN">
			</cfcase>
			<cfcase value="66"><!--- Article --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,lTopicID,ShowInNavigation,CategoryIndexed">
			</cfcase>
			<cfcase value="76"><!--- Topic --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#">
			</cfcase>
			<cfcase value="77"><!--- Blog Entry --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,PublishDateTime,lTopicID,AuthorName,ShowInNavigation,AllowComments,CommentNotificationEmail">
			</cfcase>
			<!--- Not Used --->
				<cfcase value="72"><!--- resource --->
					<cfset this.sFields[ThisCategoryTypeID]="CategoryName,CategoryAlias,CategoryTypeID,CategoryActive,ParentID,PropertiesID,sCurrentResourceDetails">
				</cfcase>
				<cfcase value="68"><!--- Q&A--->
					<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,CategoryURL,TemplateID,WorkflowStatusID">
				</cfcase>
				<cfcase value="69"><!--- Press Release --->
					<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,CategoryURL,TemplateID,WorkflowStatusID,AuthorName,PressReleaseDate">
				</cfcase>
				<cfcase value="61"><!--- System --->
					<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#">
				</cfcase>
				<cfcase value="62"><!--- Product Family --->
					<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,ShowInNavigation,CategoryIndexed">
				</cfcase>
				<cfcase value="64"><!--- Product --->
					<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#,ShowInNavigation,CategoryIndexed">
				</cfcase>
			<!--- End Not Used --->
			<cfdefaultcase><!--- Default --->
				<cfset this.sFields[ThisCategoryTypeID]="#BaseFieldList#">
			</cfdefaultcase>
		</cfswitch>
	</cfloop>

	<cffunction name="constructor" returntype="boolean" output="true">
		<cfargument name="ID" default="0" type="numeric" required="false">

		<!--- init variables --->
		<cfset var sBlank = "">
		<cfset var aBlank = "">
		<cfset var ThisProperty = "">
		<cfset var GetItems = "">
		<cfset var GetCategoryProperties = "">
		<cfset var sProperties = "">

		<!--- Typically, use set methods in contructor. --->
		<cfset this.SetProperty("CategoryID","-1")>
		<cfset this.SetProperty("CategoryTypeID","60")>
		<cfset this.SetProperty("ParentID","-1")>
		<cfset this.SetProperty("CategoryName","")>
		<cfset this.SetProperty("CategoryAlias","")>
		<cfset this.SetProperty("CategoryActive","1")>
		<cfset this.SetProperty("SourceID","")>
		<cfset this.SetProperty("ShowInNavigation","1")>
		<cfset this.SetProperty("CategoryIndexed","1")>
		<cfset this.SetProperty("CategoryURL","")>
		<cfset this.SetProperty("PropertiesID","-1")>
		<cfset this.SetProperty("CategoryPriority","-1")>
		<cfset this.SetProperty("DisplayLevel","")>
		<cfset this.SetProperty("DisplayOrder","")>
		<cfset this.SetProperty("WorkflowStatusID","")>
		<cfset this.SetProperty("TemplateID","1500")>
		<cfset this.SetProperty("PublishDateTime","#Now()#")>

		<!--- Custom Properties --->
		<cfset this.SetProperty("CategoryImageOff","")>
		<cfset this.SetProperty("CategoryImageOn","")>
		<cfset this.SetProperty("CategoryImageRollover","")>
		<cfset this.SetProperty("CategoryImageHeader","")>
		<cfset this.SetProperty("CategoryImageTitle","")>
		<cfset this.SetProperty("ProductionFTPHost","")>
		<cfset this.SetProperty("ProductionFTPRootPath","")>
		<cfset this.SetProperty("ProductionFTPUserLogin","")>
		<cfset this.SetProperty("ProductionFTPPassword","")>
		<cfset this.SetProperty("ProductionDBServer","")>
		<cfset this.SetProperty("ProductionDBName","")>
		<cfset this.SetProperty("ProductionDBDSN","")>
		<cfset this.SetProperty("AuthorName","")>
		<cfset this.SetProperty("ArticleSourceID","-1")>
		<cfset this.SetProperty("AllowComments","0")>
		<cfset this.SetProperty("AllowBackToTop","1")>
		<cfset this.SetProperty("ProductBrandLogoID","-1")>
		<cfset this.SetProperty("ProductConsoleTypeID","-1")>
		<cfset this.SetProperty("ProductProgramTypeID","-1")>
		<cfset this.SetProperty("ColorID","-1")>
		<cfset this.SetProperty("PressReleaseDate","")>
		<cfset this.SetProperty("CommentNotificationEmail","")>
		<cfset sBlank=StructNew()>
		<cfset this.SetProperty("sCurrentResourceDetails",sBlank)>
		<cfset aBlank=ArrayNew(1)>
		<cfset this.SetProperty("aOwner",aBlank)>
		<cfset this.SetProperty("useSSL","0")>
		<cfset this.SetProperty("foobar","")><!--- delta --->
		<cfset this.SetProperty("lTopicID","")>

		<cfif Val(ARGUMENTS.ID) GT 0>
			<!--- If id is greater than 0, load from DB. --->
			<cfquery name="GetItems" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_Category
				WHERE CategoryID=<cfqueryparam value="#Val(ARGUMENTS.ID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetItems.recordcount EQ 1>
				<cfoutput query="GetItems">
					<cfset this.SetProperty("CategoryTypeID",CategoryTypeID)>
					<cfset this.SetProperty("CategoryID",CategoryID)>
					<cfset this.SetProperty("ParentID",ParentID)>
					<cfset this.SetProperty("CategoryName",CategoryName)>
					<cfset this.SetProperty("CategoryAlias",CategoryAlias)>
					<cfset this.SetProperty("CategoryActive",CategoryActive)>
					<cfset this.SetProperty("SourceID",SourceID)>
					<cfset this.SetProperty("ShowInNavigation",ShowInNavigation)>
					<cfset this.SetProperty("CategoryIndexed",Val(CategoryIndexed))>
					<cfset this.SetProperty("CategoryURL",CategoryURL)>
					<cfset this.SetProperty("PropertiesID",PropertiesID)>
					<cfset this.SetProperty("CategoryPriority",CategoryPriority)>
					<cfset this.SetProperty("DisplayLevel",DisplayLevel)>
					<cfset this.SetProperty("DisplayOrder",DisplayOrder)>
					<cfset this.SetProperty("WorkflowStatusID",WorkflowStatusID)>
					<cfset this.SetProperty("TemplateID",TemplateID)>
					<cfset this.SetProperty("PublishDateTime",PublishDateTime)>
					<!--- Custom Properties --->
					<cfquery name="GetCategoryProperties" datasource="#APPLICATION.DSN#">
						SELECT * FROM t_Properties WHERE PropertiesID = <cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif isWDDX(GetCategoryProperties.PropertiesPacket)>
						<cfwddx action="WDDX2CFML" input="#GetCategoryProperties.PropertiesPacket#" output="sProperties">
						<cfloop index="ThisProperty" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle,CategoryImageOff,CategoryImageOff,ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer,ProductionDBName,ProductionDBDSN,AuthorName,ArticleSourceID,AllowComments,AllowBackToTop,ProductBrandLogoID,ProductConsoleTypeID,ProductProgramTypeID,ColorID,PressReleaseDate,CommentNotificationEmail,sCurrentResourceDetails,aOwner,foobar,useSSL"><!--- echo --->
							<cfif StructKeyExists(sProperties,"#ThisProperty#")>
								<cfset this.SetProperty("#ThisProperty#",sProperties["#ThisProperty#"])>
							</cfif>
						</cfloop>
					</cfif>
					<cfinvoke component="com.Taxonomy.TopicHandler"
						method="GetRelatedTopics"
						EntityID="#Val(ARGUMENTS.ID)#"
						EntityName="t_Category"
						returnvariable="getTopics">
					<cfset this.SetProperty("lTopicID",ValueList(getTopics.TopicID))>
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

	<cffunction name="save" returntype="boolean" output="false">
		<cfargument name="WebrootPath" required="false">
		<cfargument name="UserID" required="false">

		<!--- init variables --->
		<cfset var thisCategoryID = "">
		<cfset var thisParentID = "">
		<cfset var thisCategoryName = "">
		<cfset var thisCategoryAlias = "">
		<cfset var thisCategoryActive = "">
		<cfset var thisSourceID = "">
		<cfset var thisShowInNavigation = "">
		<cfset var thisCategoryIndexed = "">
		<cfset var thisCategoryTypeID = "">
		<cfset var thisCategoryURL = "">
		<cfset var thisPropertiesID = "">
		<cfset var thisCategoryPriority = "">
		<cfset var thisDisplayLevel = "">
		<cfset var thisDisplayOrder = "">
		<cfset var thisWorkflowStatusID = "">
		<cfset var thisTemplateID = "">
		<cfset var thisPublishDateTime="">
		<cfset var thisCategoryImageOff = "">
		<cfset var thisCategoryImageOn = "">
		<cfset var thisCategoryImageRollover = "">
		<cfset var thisCategoryImageHeader = "">
		<cfset var thisCategoryImageTitle = "">
		<cfset var thisProductionFTPHost = "">
		<cfset var thisProductionFTPRootPath = "">
		<cfset var thisProductionFTPUserLogin = "">
		<cfset var thisProductionFTPPassword = "">
		<cfset var thisProductionDBServer = "">
		<cfset var thisProductionDBName = "">
		<cfset var thisProductionDBDSN = "">
		<cfset var thisAuthorName = "">
		<cfset var thisArticleSourceID = "">
		<cfset var thisAllowComments = "">
		<cfset var thisAllowBackToTop = "">
		<cfset var thisProductBrandLogoID = "">
		<cfset var thisProductConsoleTypeID = "">
		<cfset var thisProductProgramTypeID = "">
		<cfset var thisColorID = "">
		<cfset var thisPressReleaseDate = "">
		<cfset var thisCommentNotificationEmail = "">
		<cfset var thisSCurrentResourceDetails = "">
		<cfset var thisAOwner = "">
		<cfset var thisUseSSL = "">
		<cfset var thisFoobar = "">
		<cfset var thisLTopicID="">
		<cfset var Destination = "">
		<cfset var Source = "">
		<cfset var DestinationToSave = "">
		<cfset var NextPriority = "">
		<cfset var NewIDList = "">
		<cfset var OldIDList = "">
		<cfset var CommonIDLIst = "">
		<cfset var sProperties = "">
		<cfset var DevNull = "">
		<cfset var ThisImage = "">
		<cfset var GetParent = "">
		<cfset var GetLocales = "">
		<cfset var InsertProperties = "">
		<cfset var GetNextID = "">
		<cfset var InsertCategory = "">
		<cfset var DeleteExisting = "">
		<cfset var Test = "">
		<cfset var GetParentPermissions = "">
		<cfset var InsertCategoryLocaleMeta = "">
		<cfset var GetOriginalParent = "">
		<cfset var UpdateCategory = "">
		<cfset var GetMaxCatPriority = "">
		<cfset var getCommonCategoryID = "">
		<cfset var GetProperties = "">
		<cfset var UpdateContent = "">
		<cfset var TestCategoryLocaleMeta = "">
		<cfset var TestThisCategoryLocaleMeta = "">
		<cfset var Success = "">
		<cfset var wProperties = "">
		<cfset var useSSLUpdated = false>


		<cfif IsCorrect()>
			<cfset thisCategoryID=this.GetProperty("CategoryID")>
			<cfset thisParentID=this.GetProperty("ParentID")>
			<cfset thisCategoryName=this.GetProperty("CategoryName")>
			<cfset thisCategoryAlias=this.GetProperty("CategoryAlias")>
			<cfset thisCategoryActive=this.GetProperty("CategoryActive")>
			<cfset thisSourceID=this.GetProperty("SourceID")>
			<cfset thisShowInNavigation=this.GetProperty("ShowInNavigation")>
			<cfset thisCategoryIndexed=this.GetProperty("CategoryIndexed")>
			<cfset thisCategoryTypeID=this.GetProperty("CategoryTypeID")>
			<cfset thisCategoryURL=this.GetProperty("CategoryURL")>
			<cfset thisPropertiesID=this.GetProperty("PropertiesID")>
			<cfset thisCategoryPriority=this.GetProperty("CategoryPriority")>
			<cfset thisDisplayLevel=this.GetProperty("DisplayLevel")>
			<cfset thisDisplayOrder=this.GetProperty("DisplayOrder")>
			<cfset thisWorkflowStatusID=this.GetProperty("WorkflowStatusID")>
			<cfset thisTemplateID=this.GetProperty("TemplateID")>
			<cfset thisPublishDateTime=this.GetProperty("PublishDateTime")>
			<!--- Custom Properties --->

			<cfset thisCategoryImageOff=this.GetProperty("CategoryImageOff")>
			<cfset thisCategoryImageOn=this.GetProperty("CategoryImageOn")>
			<cfset thisCategoryImageRollover=this.GetProperty("CategoryImageRollover")>
			<cfset thisCategoryImageHeader=this.GetProperty("CategoryImageHeader")>
			<cfset thisCategoryImageTitle=this.GetProperty("CategoryImageTitle")>
			<cfset thisProductionFTPHost=this.GetProperty("ProductionFTPHost")>
			<cfset thisProductionFTPRootPath=this.GetProperty("ProductionFTPRootPath")>
			<cfset thisProductionFTPUserLogin=this.GetProperty("ProductionFTPUserLogin")>
			<cfset thisProductionFTPPassword=this.GetProperty("ProductionFTPPassword")>
			<cfset thisProductionDBServer=this.GetProperty("ProductionDBServer")>
			<cfset thisProductionDBName=this.GetProperty("ProductionDBName")>
			<cfset thisProductionDBDSN=this.GetProperty("ProductionDBDSN")>
			<cfset thisAuthorName=this.GetProperty("AuthorName")>
			<cfset thisArticleSourceID=this.GetProperty("ArticleSourceID")>
			<cfset thisAllowComments=this.GetProperty("AllowComments")>
			<cfset thisAllowBackToTop=this.GetProperty("AllowBackToTop")>
			<cfset thisProductBrandLogoID=this.GetProperty("ProductBrandLogoID")>
			<cfset thisProductConsoleTypeID=this.GetProperty("ProductConsoleTypeID")>
			<cfset thisProductProgramTypeID=this.GetProperty("ProductProgramTypeID")>
			<cfset thisColorID=this.GetProperty("ColorID")>
			<cfset thisPressReleaseDate=this.GetProperty("PressReleaseDate")>
			<cfset thisCommentNotificationEmail=this.GetProperty("CommentNotificationEmail")>
			<cfset thisSCurrentResourceDetails=this.GetProperty("sCurrentResourceDetails")>
			<cfset thisAOwner=this.GetProperty("aOwner")>
			<cfset thisUseSSL=this.GetProperty("useSSL")>
			<cfset thisFoobar=this.GetProperty("foobar")><!--- foxtrot --->
			<cfset thisLTopicID=this.GetProperty("lTopicID")>

			<cfif ListFindNoCase("60,62,63,64,66,71,67,74,75,76",thisCategoryTypeID) IS "0"><!--- Set ShowInNavigation to 1 if not a public category--->
				<cfset thisShowInNavigation=1>
				<cfset thisCategoryIndexed=0>
			</cfif>

			<cfif ThisCategoryAlias IS "">
				<cfinvoke component="com.ContentManager.CategoryHandler"
					method="CreateAlias"
					Name="#thisCategoryName#"
					CategoryID="#Val(ThisCategoryID)#"
					returnVariable="thisCategoryAlias">
			</cfif>

			<cfquery name="GetParent" datasource="#APPLICATION.DSN#">
				SELECT CategoryID,DisplayLevel FROM t_Category WHERE CategoryID=<cfqueryparam value="#Val(thisParentID)#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
				select * from t_locale
			</cfquery>

			<cfif Val(thisCategoryID) LTE "0">
				<cftransaction>
					<cfquery name="InsertProperties" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_Properties (PropertiesPacket)
						VALUES ('')
						SELECT NewTeaserID=@@Identity
					</cfquery>
					<cfset thisPropertiesID=InsertProperties.NewTeaserID>
					<cfset this.SetProperty("PropertiesID",InsertProperties.NewTeaserID)>

					<cfif ThisCategoryPriority IS "">
						<cfquery name="GetNextID" datasource="#APPLICATION.DSN#">
							SELECT max(CategoryPriority) as NextID FROM t_Category WHERE ParentID=<cfqueryparam value="#Val(thisParentID)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset ThisCategoryPriority=Val(GetNextID.NextID)+10>
						<cfset this.SetProperty("CategoryPriority",ThisCategoryPriority)>
					</cfif>
					<cfquery name="InsertCategory" datasource="#APPLICATION.DSN#">
						SET NOCOUNT ON
						INSERT INTO t_Category (
						CategoryTypeID,
						CategoryName,
						ParentID,
						CategoryAlias,
						CategoryActive,
						SourceID,
						ShowInNavigation,
						CategoryIndexed,
						DisplayLevel,
						CategoryURL,
						PropertiesID,
						CategoryPriority,
						WorkflowStatusID,
						TemplateID,
						PublishDateTime
						) VALUES (
						<cfqueryparam value="#Val(ThisCategoryTypeID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#trim(ThisCategoryName)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Val(ThisParentID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#trim(ThisCategoryAlias)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#val(ThisCategoryActive)#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Val(ThisSourceID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisShowInNavigation)#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Val(ThisCategoryIndexed)#" cfsqltype="cf_sql_bit">,
						<cfif GetParent.RecordCount IS "0">
							0,
						<cfelse>
							<cfqueryparam value="#IncrementValue(Val(GetParent.DisplayLevel))#" cfsqltype="cf_sql_varchar">,
						</cfif>
						<cfqueryparam value="#Trim(ThisCategoryURL)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Val(thisPropertiesID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisCategoryPriority)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisWorkflowStatusID)#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Val(ThisTemplateID)#" cfsqltype="cf_sql_integer">,
						<cfif Trim(ThisPublishDateTime) IS "">
							NULL
						<cfelse>
							<cfqueryparam value="#Trim(ThisPublishDateTime)#" cfsqltype="cf_sql_timestamp">
						</cfif>
						)
						SELECT NewCategoryID=@@Identity
					</cfquery>
					<cfset thisCategoryID=InsertCategory.NewCategoryID>
					<cfset this.SetProperty("CategoryID",thisCategoryID)>

					<cfquery name="DeleteExisting" datasource="#APPLICATION.DSN#">
						DELETE From t_Permissions where CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif Val(ThisParentID) LTE "0">

						<!--- add permissions for super admin --->
						<cfquery name="Test" datasource="#APPLICATION.DSN#">
							insert into t_permissions (
							UserGroupID,
							CategoryID,
							pRead,
							pCreate,
							pEdit,
							pDelete,
							pSaveLive,
							pManage
							) VALUES (
							<cfqueryparam value="#APPLICATION.SuperAdminUserGroupID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
							1,
							1,
							1,
							1,
							1,
							1
							)
						</cfquery>

						<!--- add permissions for content editor --->
						<cfquery name="Test" datasource="#APPLICATION.DSN#">
							insert into t_permissions (
							UserGroupID,
							CategoryID,
							pRead,
							pCreate,
							pEdit,
							pDelete,
							pSaveLive,
							pManage
							) VALUES (
							<cfqueryparam value="#APPLICATION.ContentEditorUserGroupID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
							1,
							1,
							1,
							1,
							0,
							0
							)
						</cfquery>
					<cfelse>
						<cfquery name="GetParentPermissions" datasource="#APPLICATION.DSN#">
							SELECT * FROM t_Permissions WHERE CategoryID=<cfqueryparam value="#Val(ThisParentID)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfoutput query="GetParentPermissions">
							<cfquery name="Test" datasource="#APPLICATION.DSN#">
								insert into t_permissions (
								UserGroupID,
								CategoryID,
								pRead,
								pCreate,
								pEdit,
								pDelete,
								pSaveLive,
								pManage
								) VALUES (
								<cfqueryparam value="#UserGroupID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Val(thisCategoryID)#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#pRead#" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#pCreate#" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#pEdit#" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#pDelete#" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#pSaveLive#" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#pManage#" cfsqltype="cf_sql_bit">
								)
							</cfquery>
						</cfoutput>
					</cfif>
				</cftransaction>
				<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
				<!--- Move files to its final resting place --->
				<cfif ARGUMENTS.WebrootPath is not "">
					<cfset Destination=this.GetResourcePath("images")>
					<cfset Destination=ReplaceNoCase("#ARGUMENTS.WebrootPath##Destination#","/","\","all")>
					<cfset Destination=ReplaceNoCase("#Destination#","\\","\","all")>
					<cfloop index="ThisImage" list="CategoryImageOff,CategoryImageOn,CategoryImageRollover,CategoryImageHeader,CategoryImageTitle">
						<cfset Source=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetProperty('#ThisImage#')#","/","\","all")>
						<cfset Source=ReplaceNoCase("#Destination#","\\","\","all")>
						<cfif FileExists(Source)>
							<cffile action="MOVE" source="#Source#" destination="#Destination#">
							<cfset DestinationToSave="#this.GetResourcesPath('images')##ListLast(this.GetProperty('#ThisImage#'),'/')#">
							<cfset DestinationToSave=ReplaceNoCase(DestinationToSave,"//","/","all")>
							<cfset this.SetProperty("#ThisImage#","#DestinationToSave#")>
						</cfif>
					</cfloop>
				</cfif>
				<cfinvoke component="com.ContentManager.CategoryHandler" method="GenerateDisplayOrderString"
					returnVariable="Success"
					SourceParentID="#Val(this.GetProperty('ParentID'))#"
					datasource="#APPLICATION.DSN#">

				<cfoutput query="GetLocales">
					<cfquery name="InsertCategoryLocaleMeta" datasource="#APPLICATION.DSN#">
						INSERT INTO t_CategoryLocaleMeta
						(CategoryID,LocaleID,CategoryLocalePriority,CategoryLocaleDisplayOrder)
						VALUES
						(<cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#val(LocaleID)#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#val(thisCategoryPriority)#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Trim(ThisDisplayOrder)#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfinvoke component="com.ContentManager.CategoryLocaleHandler" method="GenerateDisplayOrderString"
						returnVariable="Success"
						SourceParentID="#Val(this.GetProperty('ParentID'))#"
						datasource="#APPLICATION.DSN#"
						LocaleID="#LocaleID#">
				</cfoutput>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="Category"
						KeyID="#ThisCategoryID#"
						Operation="create"
						EntityName="#this.GetProperty('CategoryName')#">
				</cfif>
			<cfelse>
				<cfquery name="GetOriginalParent" datasource="#APPLICATION.DSN#">
					select ParentID from t_Category where CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="UpdateCategory" datasource="#APPLICATION.DSN#">
					UPDATE t_Category
					SET
					CategoryName=<cfqueryparam value="#trim(ThisCategoryName)#" cfsqltype="cf_sql_varchar">,
					CategoryAlias=<cfqueryparam value="#trim(ThisCategoryAlias)#" cfsqltype="cf_sql_varchar">,
					CategoryTypeID=<cfqueryparam value="#Val(ThisCategoryTypeID)#" cfsqltype="cf_sql_integer">,
					CategoryActive=<cfqueryparam value="#val(ThisCategoryActive)#" cfsqltype="cf_sql_bit">,
					SourceID=<cfqueryparam value="#val(ThisSourceID)#" cfsqltype="cf_sql_integer">,
					ShowInNavigation=<cfqueryparam value="#Val(ThisShowInNavigation)#" cfsqltype="cf_sql_bit">,
					CategoryIndexed=<cfqueryparam value="#Val(ThisCategoryIndexed)#" cfsqltype="cf_sql_bit">,
					ParentID=<cfqueryparam value="#Val(ThisParentID)#" cfsqltype="cf_sql_integer">,
					CategoryURL=<cfqueryparam value="#Trim(ThisCategoryURL)#" cfsqltype="cf_sql_varchar">,
					TemplateID=<cfqueryparam value="#Val(ThisTemplateID)#" cfsqltype="cf_sql_integer">,
					<cfif Trim(ThisPublishDateTime) IS "">
						PublishDateTime=NULL,
					<cfelse>
						PublishDateTime=<cfqueryparam value="#Trim(ThisPublishDateTime)#" cfsqltype="cf_sql_timestamp">,
					</cfif>
					<cfif GetParent.RecordCount IS "0">
						DisplayLevel=0
					<cfelse>
						DisplayLevel=<cfqueryparam value="#IncrementValue(Val(GetParent.DisplayLevel))#" cfsqltype="cf_sql_integer">
					</cfif>
					WHERE CategoryID=<cfqueryparam value="#val(thisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif ThisParentID IS NOT GetOriginalParent.ParentID>
					<!--- If category moved, then redraw all DisplayOrderString's --->
					<cfquery name="GetMaxCatPriority" datasource="#APPLICATION.DSN#">
						select max(CategoryPriority) as prio from t_Category Where ParentID=<cfqueryparam value="#Val(ThisParentID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset NextPriority=GetMaxCatPriority.prio+10>
					<cfquery name="UpdateCategory" datasource="#APPLICATION.DSN#">
						UPDATE t_Category SET
						CategoryPriority=<cfqueryparam value="#NextPriority#" cfsqltype="cf_sql_integer">
						WHERE CategoryID=<cfqueryparam value="#val(thisCategoryID)#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
						ThisCategoryID="#ThisParentID#" NameList="" IDList="#ThisParentID#">
					<cfset NewIDList="#IDList#">
					<cfmodule template="/common/modules/utils/GetBranchFromRoot.cfm"
						ThisCategoryID="#GetOriginalParent.ParentID#" NameList="" IDList="#GetOriginalParent.ParentID#">
					<cfset OldIDList="#IDList#">
					<CF_Venn
						ListA="#OldIDList#"
						ListB="#NewIDList#"
						AAndB="CommonIDList">
					<cfif len(CommonIDList) IS "0">
						<cfset CommonIDLIst="-1">
					</cfif>
					<cfquery name="getCommonCategoryID" datasource="#APPLICATION.DSN#" maxrows="1">
						select CategoryID from T_Category Where CategoryID IN (<cfqueryparam value="#CommonIDLIst#" cfsqltype="cf_sql_integer" list="yes">) order by DisplayLevel Desc
					</cfquery>
					<cfinvoke component="com.ContentManager.CategoryHandler" method="GenerateDisplayOrderString"
						returnVariable="Success"
						SourceParentID="#Val(getCommonCategoryID.CategoryID)#"
						datasource="#APPLICATION.DSN#">updated #getCommonCategoryID.CategoryID# tree
					<cfoutput query="GetLocales">
						<cfinvoke component="com.ContentManager.CategoryLocaleHandler" method="GenerateDisplayOrderString"
							returnVariable="Success"
							SourceParentID="#Val(this.GetProperty('ParentID'))#"
							datasource="#APPLICATION.DSN#"
							LocaleID="#LocaleID#">
					</cfoutput>
				</cfif>
				<cfif Val(ARGUMENTS.UserID) GT "0">
					<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
						UserID="#ARGUMENTS.UserID#"
						Entity="Category"
						KeyID="#ThisCategoryID#"
						Operation="modify"
						EntityName="#this.GetProperty('CategoryName')#">
				</cfif>
			</cfif>

			<!--- update lTopicID --->
			<cfinvoke component="com.taxonomy.TopicHandler"
				method="InsertRelatedTopics"
				EntityID="#Val(ThisCategoryID)#"
				EntityName="t_Category"
				lTopicID="#thisLTopicID#">

			<cfquery name="GetProperties" datasource="#APPLICATION.DSN#">
				SELECT t_Properties.PropertiesID,t_Properties.PropertiesPacket
				FROM t_Properties
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif isWDDX(GetProperties.PropertiesPacket)>
				<cfwddx action="WDDX2CFML" input="#GetProperties.PropertiesPacket#" output="sProperties">
			<cfelse>
				<cfset sProperties=StructNew()>
			</cfif>

			<cfset DevNull=StructInsert(sProperties,"CategoryImageOff","#Trim(ThisCategoryImageOff)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageOn","#Trim(ThisCategoryImageOn)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageRollover","#Trim(ThisCategoryImageRollover)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageHeader","#Trim(ThisCategoryImageHeader)#","1")>
			<cfset DevNull=StructInsert(sProperties,"CategoryImageTitle","#Trim(ThisCategoryImageTitle)#","1")>
			<cfset DevNull=StructInsert(sProperties,"AuthorName","#Trim(ThisAuthorName)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ArticleSourceID","#Trim(ThisArticleSourceID)#","1")>
			<cfset DevNull=StructInsert(sProperties,"AllowComments","#val(ThisAllowComments)#","1")>
			<cfset DevNull=StructInsert(sProperties,"AllowBackToTop","#val(ThisAllowBackToTop)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductBrandLogoID","#val(ThisProductBrandLogoID)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductConsoleTypeID","#val(ThisProductConsoleTypeID)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductProgramTypeID","#val(ThisProductProgramTypeID)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ColorID","#val(ThisColorID)#","1")>
			<cfset DevNull=StructInsert(sProperties,"PressReleaseDate","#ThisPressReleaseDate#","1")>
			<cfset DevNull=StructInsert(sProperties,"CommentNotificationEmail","#ThisCommentNotificationEmail#","1")>
			<cfset DevNull=StructInsert(sProperties,"SCurrentResourceDetails",thisSCurrentResourceDetails,"1")>
			<cfset DevNull=StructInsert(sProperties,"aOwner",thisAOwner,"1")>

			<!--- if useSSL has changed, set the flag so we can update the struct of SSL pages after the save  --->
			<cfif APPLICATION.SSLConfigured and structKeyExists(sProperties, "useSSL") and thisUseSSL neq sProperties.useSSL>
				<cfset useSSLUpdated = true />
			</cfif>

			<cfset DevNull=StructInsert(sProperties,"useSSL",thisUseSSL,"1")>
			<cfset DevNull=StructInsert(sProperties,"foobar",thisFoobar,"1")><!--- golf --->

			<cfset DevNull=StructInsert(sProperties,"ProductionFTPHost","#Trim(ThisProductionFTPHost)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductionFTPRootPath","#Trim(ThisProductionFTPRootPath)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductionFTPUserLogin","#Trim(ThisProductionFTPUserLogin)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductionFTPPassword","#Trim(ThisProductionFTPPassword)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductionDBServer","#Trim(ThisProductionDBServer)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductionDBName","#Trim(ThisProductionDBName)#","1")>
			<cfset DevNull=StructInsert(sProperties,"ProductionDBDSN","#Trim(ThisProductionDBDSN)#","1")>

			<cfwddx action="CFML2WDDX" input="#sProperties#" output="wProperties">
			<cfquery name="UpdateContent" datasource="#APPLICATION.DSN#">
				UPDATE t_Properties
				SET PropertiesPacket=<cfqueryparam value="#Trim(wProperties)#" cfsqltype="cf_sql_longvarchar">
				WHERE PropertiesID=<cfqueryparam value="#val(thisPropertiesID)#" cfsqltype="cf_sql_integer">
			</cfquery>


			<cfquery name="GetLocales" datasource="#APPLICATION.DSN#">
				select * from t_locale
			</cfquery>

			<cfquery name="TestCategoryLocaleMeta" datasource="#APPLICATION.DSN#">
				select * from t_CategoryLocaleMeta
				Where CategoryID=<cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfif GetLocales.RecordCount IS NOT TestCategoryLocaleMeta.RecordCount>
				<cfoutput query="GetLocales">
					<cfquery name="TestThisCategoryLocaleMeta" datasource="#APPLICATION.DSN#">
						select * from t_CategoryLocaleMeta
						Where CategoryID=<cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
						and LocaleID=<cfqueryparam value="#val(LocaleID)#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif TestThisCategoryLocaleMeta.RecordCount IS "0">
						<cfquery name="InsertCategoryLocaleMeta" datasource="#APPLICATION.DSN#">
							INSERT INTO t_CategoryLocaleMeta
							(CategoryID,LocaleID,CategoryLocalePriority,CategoryLocaleDisplayOrder)
							VALUES
							(<cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#val(LocaleID)#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#val(thisCategoryPriority)#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#Trim(ThisDisplayOrder)#" cfsqltype="cf_sql_varchar">
							)
						</cfquery>
					</cfif>
				</cfoutput>
			</cfif>

			<cfinvoke component="com.ContentManager.CategoryHandler" method="UpdateCacheDateTime" returnVariable="success"
				Lookup="Category"
				KeyID="#thisCategoryID#">

			<!--- if the useSSL property was updated, then update APPLICATION.sslCategories --->
			<cfif APPLICATION.SSLConfigured and useSSLUpdated>
				<cflock scope="application" type="exclusive" timeout="30">
					<cfinvoke method="getSSLStruct" returnvariable="APPLICATION.sslCategories" />
				</cflock>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="SetProperty" returntype="boolean" output="false">
		<cfargument name="Property" required="true" type="string">
		<cfargument name="Value" required="true" type="any">

		<!--- init variables --->
		<cfset var Restrictions = this.GetRestrictionsPropertyList()>
		<cfset var ProductionError = "">
		<cfset var ThisProperty = "">
		<cfset var ValidAlias = "">
		<cfset var Test = "">

		<cfset ARGUMENTS.Property=Trim(ARGUMENTS.Property)>

		<cfif IsSimpleValue(ARGUMENTS.Value) and ListFindNoCase(Restrictions,ARGUMENTS.Property)>
			<cfset ARGUMENTS.Value=Trim(ARGUMENTS.Value)>

			<cfif ListFindNoCase("CategoryID,ParentID,CategoryTypeID,PropertiesID,CategoryPriority,DisplayLevel,TemplateID,WorkflowStatusID",ARGUMENTS.Property) and ARGUMENTS.Value is NOT "">
				<cfif NOT IsNumeric(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid number.")>
					<cfreturn false>
				</cfif>
			</cfif>

			<cfif ListFindNoCase("PressReleaseDate,PublishDateTime",ARGUMENTS.Property) AND ARGUMENTS.VALUE IS NOT "">
				<cfif NOT IsDate(ARGUMENTS.Value)>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a valid date.")>
					<cfreturn false>
				</cfif>
			</cfif>

			<cfif ListFindNoCase("CategoryName",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>

			<cfif ListFindNoCase("CategoryTypeID",ARGUMENTS.Property) AND val(ARGUMENTS.Value) LTE "0">
				<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","Please enter a #sPropertyDisplayName[ARGUMENTS.Property]#.")>
				<cfreturn false>
			</cfif>

			<cfif ListFindNoCase("CategoryName,DisplayOrder",ARGUMENTS.Property)>
				<cfif Len(ARGUMENTS.Value) GT "128">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 128 characters long.")>
					<cfreturn false>
				</cfif>
			</cfif>

			<cfif ListFindNoCase("CategoryURL",ARGUMENTS.Property)>
				<cfif Len(ARGUMENTS.Value) GT "512">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 512 characters long.")>
					<cfreturn false>
				</cfif>
			</cfif>

			<cfif ListFindNoCase("ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer",ARGUMENTS.Property) AND Trim(ARGUMENTS.Value) IS "">
				<cfset ProductionError="no">
				<cfloop index="ThisProperty" list="ProductionFTPHost,ProductionFTPRootPath,ProductionFTPUserLogin,ProductionFTPPassword,ProductionDBServer">
					<cfif this.GetProperty("#ThisProperty#") IS NOT "">
						<cfset ProductionError="yes">
					</cfif>
				</cfloop>
				<!--- <cfif ProductionError>
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","You have to set all production parameters.")>
					<cfreturn false>
				</cfif> --->
			</cfif>

			<cfif ListFindNoCase("CategoryAlias,foobar",ARGUMENTS.Property)><!--- hotel --->
				<cfif Len(ARGUMENTS.Value) GT "128">
					<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# can only be 128 characters long.")>
					<cfreturn false>
				</cfif>
				<cfif ARGUMENTS.Value IS NOT "">
					<cfinvoke component="com.ContentManager.CategoryHandler"
						method="CheckDuplicateAlias"
						CandidateAlias="#Trim(ARGUMENTS.Value)#"
						CategoryID="#this.GetProperty('CategoryID')#"
						returnVariable="ValidAlias">
					<cfif NOT ValidAlias>
						<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is a duplicate.")>
						<cfreturn false>
					</cfif>
				</cfif>
				<!--- Make sure there are no special characters in the alias --->
				<cfset ARGUMENTS.Value=lcase(ReReplace(ARGUMENTS.Value,"[’\!'()/:"".;?&<>|, ]","","all"))>
			</cfif>

			<cfif ListFindNoCase("ParentID,CategoryTypeID,TemplateID,WorkflowStatusID,ArticleSourceID,ProductBrandLogoID,ProductConsoleTypeID",ARGUMENTS.Property)>
				<cfif Val(ARGUMENTS.Value) GT "0">
					<cfswitch expression="#ARGUMENTS.Property#">
						<cfcase value="ParentID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Category">
								<cfinvokeargument name="FieldName" value="CategoryID">
								<cfinvokeargument name="FieldValue" value="#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="CategoryAlias">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ProductProgramTypeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Category">
								<cfinvokeargument name="FieldName" value="CategoryID">
								<cfinvokeargument name="FieldValue" value="#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="CategoryAlias">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="CategoryTypeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="40,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="WorkflowStatusID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="80,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ArticleSourceID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="130,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ProductBrandLogoID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="150,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ProductConsoleTypeID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="160,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
								<cfinvokeargument name="SortOrder" value="Asc">
							</cfinvoke>
							<cfif Test.RecordCount IS "0">
								<cfset AddError(ARGUMENTS.Property,"#Trim(ARGUMENTS.Value)#","The #sPropertyDisplayName[ARGUMENTS.Property]# given is not valid.")>
								<cfreturn false>
							</cfif>
						</cfcase>
						<cfcase value="ColorID">
							<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
								<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
								<cfinvokeargument name="TableName" value="t_Label">
								<cfinvokeargument name="FieldName" value="LabelGroupID,LabelID">
								<cfinvokeargument name="FieldValue" value="210,#ARGUMENTS.Value#">
								<cfinvokeargument name="SortFieldName" value="LabelName">
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

		<cfif ListFindNoCase("CategoryPriority",ARGUMENTS.Property)>
			<cfif Val(ARGUMENTS.Value) LTE "0">
				<cfset ARGUMENTS.Value="">
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

		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="CreateResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>

	<cffunction name="GetResourcePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">

		<!--- init variables --->
		<cfset var ReturnValue = "">

		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="GetResourcePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			ResourceType="#ARGUMENTS.ResourceType#">
		<cfreturn ReturnValue>
	</cffunction>

	<cffunction name="GetResourceFilePath" returntype="string" output="false">
		<cfargument name="ResourceType" required="true">
		<cfargument name="WebrootPath" required="true">

		<!--- init variables --->
		<cfset var ReturnValue = "">

		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="GetResourceFilePath"
			returnVariable="ReturnValue"
			CategoryID="#this.GetProperty('CategoryID')#"
			ResourceType="#ARGUMENTS.ResourceType#"
			WebrootPath="#ARGUMENTS.WebrootPath#">
		<cfreturn ReturnValue>
	</cffunction>

	<cffunction name="FormFileUpload" returntype="boolean" output="false">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">
		<cfargument name="FormFileFieldName" required="true">

		<!--- init variables --->
		<cfset var UploadDirectory = "">
		<cfset var UploadedFile = "">
		<cfset var FilePath = "">

		<cfif ARGUMENTS.FormFileFieldName IS "" OR ARGUMENTS.WebrootPath IS "" OR ARGUMENTS.Property IS "">
			<cfreturn false>
		<cfelseif ListFindNoCase(StructkeyList(this),ARGUMENTS.Property) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfif Val(GetProperty("CategoryID")) LTE "0">
				<cfset UploadDirectory="#ARGUMENTS.WebrootPath#common\incoming\">
			<cfelse>
				<cfmodule template="/common/modules/utils/ExplodeString.cfm" String="#this.GetProperty('CategoryID')#" ReturnVarName="PathFragment">
				<cfset UploadDirectory=ReplaceNoCase("#ARGUMENTS.WebrootPath##this.GetResourcePath('images')#","/","\","All")>
				<cfset UploadDirectory=ReplaceNoCase(UploadDirectory,"\\","\","all")>
				<cfset this.CreateResourcePath(ARGUMENTS.WebrootPath)>
			</cfif>
			<cffile action="UPLOAD"
				filefield="#ARGUMENTS.FormFileFieldName#"
				destination="#UploadDirectory#"
				nameconflict="MakeUnique">
			<cfset UploadedFile=application.utilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)>
			<cfif ListFindNoCase("#APPLICATION.ImageFileExtensionList#",".#ListLast('#File.ServerFile#','.')#",";") LTE "0">
				<cffile action="DELETE" file="#UploadedFile#">
				<cfset SetProperty("#ARGUMENTS.Property#","")>
				<cfset AddError(ARGUMENTS.Property,"","The #sPropertyDisplayName[ARGUMENTS.Property]# must be an image.")>
				<cfreturn false>
			<cfelse>
				<cfset FilePath=ReplaceNoCase(UploadedFile,ARGUMENTS.WebrootPath,"/","All")>
				<cfset FilePath=ReplaceNoCase(FilePath,"\","/","All")>
				<cfset FilePath=ReplaceNoCase(FilePath,"//","/","All")>
				<cfset SetProperty("#ARGUMENTS.Property#","#FilePath#")>
				<cfreturn true>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="FileRemove" returnType="boolean" output="false">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="Property" required="true">

		<!--- init variables --->
		<cfset var FileToDelete = "">

		<cfif ARGUMENTS.WebrootPath IS "" OR ARGUMENTS.Property IS "">
			<cfreturn false>
		<cfelseif ListFindNoCase(StructkeyList(this),ARGUMENTS.Property) LTE "0">
			<cfreturn false>
		<cfelse>
			<cfset FileToDelete=this.GetProperty("#ARGUMENTS.Property#")>
			<cfset this.SetProperty("#ARGUMENTS.Property#","")>
			<cfset FileToDelete=ReplaceNoCase("#ARGUMENTS.WebrootPath##FileToDelete#","/","\","All")>
			<cfset FileToDelete=ReplaceNoCase("#FileToDelete#","\\","\","All")>
			<cfif fileExists(FileToDelete)>
				<cffile action="DELETE" file="#FileToDelete#">
			</cfif>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="GetCategoryTypeName" returnType="String" output="false">

		<!--- init variables --->
		<cfset var ReturnString = "">
		<cfset var Test = "">

		<cfinvoke component="com.utils.Database" method="GenericLookup" returnVariable="Test">
			<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
			<cfinvokeargument name="TableName" value="t_Label">
			<cfinvokeargument name="FieldName" value="LabelID">
			<cfinvokeargument name="FieldValue" value="#this.GetProperty('CategoryTypeID')#">
		</cfinvoke>
		<cfset ReturnString="#ValueList(Test.LabelName)#">
		<cfreturn ReturnString>
	</cffunction>

	<cffunction name="GetCategoryTypeIDSetQuery" returnType="Query" output="false">

		<!--- init variables --->
		<cfset var GetParentCategory = "">
		<cfset var GetCategoryTypes = "">

		<cfquery name="GetParentCategory" datasource="#APPLICATION.DSN#">
			SELECT CategoryTypeID,CategoryName,CategoryAlias FROM t_Category WHERE CategoryID=<cfqueryparam value="#val(this.GetProperty('ParentID'))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif GetParentCategory.RecordCount Is "0">
			<cfquery name="GetCategoryTypes" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_Label WHERE LabelGroupID=40 AND LabelID=65
			</cfquery><!--- if no categories present at all, only website type category --->
		<cfelse>
			<cfquery name="GetCategoryTypes" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_Label WHERE LabelGroupID=40 AND
				<cfswitch expression="#GetParentCategory.CategoryTypeID#">
					<cfcase value="65"><!--- Website --->
						LabelID IN (60,61,75,78)<!--- Only content, system --->
					</cfcase>
					<cfcase value="60,78"><!--- Content --->
						LabelID  IN (60,61,62,75,66,77,78) <!--- Content, System, Blog, Article, Journal, blog Entry --->
					</cfcase>
					<cfcase value="61"><!--- system --->
						LabelID IN (60,61,67,71,73,74,66,76,78) <!--- Content, News List, Event List, Gallery, Banner Repository, Article, Topic --->
					</cfcase>
					<cfcase value="76"><!--- topic --->
						LabelID IN (61,76) <!--- System, Topic --->
					</cfcase>
					<cfcase value="62"><!--- Product Family --->
						LabelID IN (62,63,64,60) <!--- System, Topic --->
					</cfcase>
					<cfcase value="63,64"><!--- Product Series, Product--->
						LabelID IN (63,64.60) <!--- System, Topic --->
					</cfcase>
					<cfdefaultcase><!--- --->
						LabelID NOT IN (61,60)
					</cfdefaultcase>
				</cfswitch>
				ORDER BY labelName
			</cfquery>
		</cfif>
		<cfreturn GetCategoryTypes>
	</cffunction>

	<cffunction name="GetParentCategorySetQuery" returnType="Query" output="false">

		<!--- init variables --->
		<cfset var branch = "">
		<cfset var ThisCategoryID = "">
		<cfset var GetCategory = "">

		<cfif this.GetProperty("CategoryID") GT "0">
			<CF_getbranch item="#this.GetProperty('CategoryID')#" DataSource="#APPLICATION.DSN#"
				table="t_Category" Column="CategoryID" ParentColumn="ParentID">
		<cfelse>
			<cfset branch="-1">
		</cfif>
		<cfset ThisCategoryID=Val(this.GetProperty("CategoryID"))>
		<cfquery name="GetCategory" datasource="#APPLICATION.DSN#">
			SELECT * FROM t_Category WHERE CategoryID NOT IN (<cfqueryparam value="#branch#" cfsqltype="cf_sql_integer" list="yes">) AND CategoryID <> <cfqueryparam value="#ThisCategoryID#" cfsqltype="cf_sql_integer"> ORDER BY DisplayOrder
		</cfquery>
		<cfreturn GetCategory>
	</cffunction>

	<cffunction name="GetParentCategoryQuery" returnType="query" output="false">

		<!--- init variables --->
		<cfset var ThisParentID = Val(this.GetProperty("ParentID"))>
		<cfset var GetParentCategory = "">

		<cfquery name="GetParentCategory" datasource="#APPLICATION.DSN#">
			SELECT CategoryTypeID,CategoryName,CategoryAlias FROM t_Category WHERE CategoryID=<cfqueryparam value="#ThisParentID#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn GetParentCategory>
	</cffunction>

	<cffunction name="GetParentCategoryName" returnType="string" output="false">

		<!--- init variables --->
		<cfset var GetParentCategory = "">

		<cfquery name="GetParentCategory" datasource="#APPLICATION.DSN#">
			SELECT CategoryName FROM t_Category WHERE CategoryID=<cfqueryparam value="#val(this.GetProperty('ParentID'))#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn GetParentCategory.CategoryName>
	</cffunction>

	<cffunction name="GetSiblingQuery" returnType="query" output="false">
		<cfargument name="OrderBy" required="false" type="string" default="CategoryPriority">

		<!--- init variables --->
		<cfset var ThisParentID = "">
		<cfset var GetSiblingQuery = "">

		<!--- protect the "ORDER BY" --->
		<cfif ListFindNoCase("CategoryPriority,CategoryName,CategoryAlias",ARGUMENTS.OrderBy) LTE "0">
			<cfset ARGUMENTS.Orderby="CategoryPriority">
		</cfif>
		<cfset ThisParentID=this.GetProperty("ParentID")>
		<cfif ThisParentID LTE "0">
			<cfset ThisParentID="-1">
		</cfif>

		<cfquery name="GetSiblingQuery" datasource="#APPLICATION.DSN#" dbtype="ODBC">
			SELECT		*
			FROM		t_Category
			WHERE		ParentID=<cfqueryparam value="#Val(ThisParentID)#" cfsqltype="cf_sql_integer">
			ORDER BY	#ARGUMENTS.Orderby#
		</cfquery>
		<cfreturn GetSiblingQuery>
	</cffunction>

	<cffunction name="ValidateDelete" returnType="boolean" output="false">

		<!--- init variables --->
		<cfset var CheckIfContainContent = "">

		<cfif this.GetProperty("CategoryID") GT "0">
			<CF_getbranch item="#this.GetProperty('CategoryID')#" DataSource="#APPLICATION.DSN#" table="t_Category" Column="CategoryID" ParentColumn="ParentID">
			<cfquery name="CheckIfContainContent" datasource="#APPLICATION.DSN#">
				SELECT ContentID FROM qry_GetContentLocaleMeta
				WHERE
				CategoryID IN (<cfqueryparam value="#branch#" cfsqltype="cf_sql_integer" list="yes">) AND
				ContentPositionID <> <cfqueryparam value="403" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif CheckIfContainContent.RecordCount GT "0">
				<cfreturn false>
			<cfelse>
				<cfreturn true>
			</cfif>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="Delete" returnType="boolean" output="1">
		<cfargument name="TrashPath" required="true">
		<cfargument name="UserID" required="true">

		<!--- init variables --->
		<cfset var MyCategoryLocale = "">
		<cfset var DirDone = "">
		<cfset var DirectoryToCreate = "">
		<cfset var DestImages = "">
		<cfset var DestDocs = "">
		<cfset var SourceImages = "">
		<cfset var SourceDocs = "">
		<cfset var RemoteDirectories = "">
		<cfset var ThisDirectory = "">
		<cfset var ThisID = "">
		<cfset var i = "">
		<cfset var SelectCategory = "">
		<cfset var GetLocale = "">
		<cfset var deleteContent3 = "">
		<cfset var DeletePermissions = "">
		<cfset var CategoryImageOffssages = "">
		<cfset var DeleteArticleContributors = "">
		<cfset var DeleteArticles = "">
		<cfset var DeleteContentCategory = "">
		<cfset var DeleteProductAttributes = "">
		<cfset var GetPrevTextBlockStaging = "">
		<cfset var DeleteLanguageBlocks = "">
		<cfset var DeleteLanguageBlocksLanguages = "">
		<cfset var GetPrevResourceStaging = "">
		<cfset var DeleteResources = "">
		<cfset var DeleteResourcesLanguages = "">
		<cfset var GetPrevProductFamilyAttributeStaging = "">
		<cfset var DeleteProductFamilyAttributes = "">
		<cfset var DeleteProductFamilyAttributesLanguages = "">
		<cfset var sProductionSiteInformation = "">
		<cfset var success = "">
		<cfset var List = "">
		<cfset var connectionName = APPLICATION.utilsObj.createUniqueId()>

		<cfif this.ValidateDelete() and ARGUMENTS.TrashPath IS NOT "">
			<CF_getbranch item="#this.GetProperty('CategoryID')#" DataSource="#APPLICATION.DSN#" table="t_Category" Column="CategoryID" ParentColumn="ParentID">
			<cfquery name="SelectCategory" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_Category WHERE CategoryID IN (<cfqueryparam value="#branch#" cfsqltype="cf_sql_integer" list="yes">)
			</cfquery>
			<cfinvoke component="com.ContentManager.CategoryHandler"
				method="GetProductionSiteInformation"
				returnVariable="sProductionSiteInformation"
				CategoryID="#this.GetProperty('CategoryID')#">
			<cfloop index="ThisID" list="#ValueList(SelectCategory.CategoryID)#">
				<!--- First delete content locale records --->
				<cfquery name="GetLocale" datasource="#APPLICATION.DSN#">
					select CategoryLocaleID from t_CategoryLocale Where CategoryID=<cfqueryparam value="#Val(ThisID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfoutput query="GetLocale">
					<cfset MyCategoryLocale=CreateObject("component","com.ContentManager.CategoryLocale")>
					<cfset MyCategoryLocale.Constructor(Val(CategoryLocaleID))>
					<cfset MyCategoryLocale.Delete(ARGUMENTS.TrashPath,ARGUMENTS.UserID)>
				</cfoutput>
			</cfloop>

			<cftransaction>
				<cfoutput query="SelectCategory">
					<cfquery name="deleteContent3" datasource="#APPLICATION.DSN#">
						DELETE FROM t_properties WHERE PropertiesID=<cfqueryparam value="#PropertiesID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="DeletePermissions" datasource="#APPLICATION.DSN#">
						DELETE FROM t_Permissions WHERE CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="CategoryImageOffssages" datasource="#APPLICATION.DSN#">
						DELETE FROM t_Category WHERE CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="CategoryImageOffssages" datasource="#APPLICATION.DSN#">
						DELETE FROM t_CategoryLocaleMeta WHERE CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfset DirDone="">
					<cfloop index="i" from="1" to="#Len(CategoryID)#" step="1">
						<cfset DirectoryToCreate="#ARGUMENTS.TrashPath##APPLICATION.CategoryResourcesPath##DirDone##Mid(CategoryID,i,1)#">
						<cfset DirDone="#DirDone##Mid(CategoryID,i,1)#\">
						<cftry>
							<cfdirectory action="CREATE" directory="#DirectoryToCreate#">
							<cfdirectory action="CREATE" directory="#DirectoryToCreate#/images/">
							<cfdirectory action="CREATE" directory="#DirectoryToCreate#/documents/">
							<cfcatch></cfcatch>
						</cftry>
					</cfloop>
					<cfset DestImages="#DirectoryToCreate#\images\">
					<cfset DestDocs="#DirectoryToCreate#\documents\">
					<cfset DirDone="">
					<cfloop index="i" from="1" to="#Len(CategoryID)#" step="1">
						<cfset DirectoryToCreate="#APPLICATION.WebRootPath##APPLICATION.CategoryResourcesPath##DirDone##Mid(CategoryID,i,1)#">
						<cfset DirDone="#DirDone##Mid(CategoryID,i,1)#\">
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
				</cfoutput>
			</cftransaction>

			<cfif Val(ARGUMENTS.UserID) GT "0">
				<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
					UserID="#ARGUMENTS.UserID#"
					Entity="Category"
					KeyID="#this.GetProperty('CategoryID')#"
					Operation="delete"
					EntityName="#This.GetProperty('CategoryName')#">
			</cfif>

			<cfif IsStruct(sProductionSiteInformation)>
				<cftransaction>
					<cfquery name="SelectCategory" datasource="#sProductionSiteInformation.ProductionDBDSN#">
						SELECT * FROM t_Category WHERE CategoryID IN (<cfqueryparam value="#branch#" cfsqltype="cf_sql_integer" list="yes">)
					</cfquery>
					<cfoutput query="SelectCategory">
						<cfquery name="deleteContent3" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_properties WHERE PropertiesID=<cfqueryparam value="#PropertiesID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery name="DeleteContentCategory" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_Permissions WHERE CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery name="CategoryImageOffssages" datasource="#sProductionSiteInformation.ProductionDBDSN#">
							DELETE FROM t_Category WHERE CategoryID=<cfqueryparam value="#CategoryID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfoutput>
				</cftransaction>

				<cfif SelectCategory.recordcount>

					<!--- open the ftp connection to the production site --->
					<cfftp	action="open"
							username="#sProductionSiteInformation.ProductionFTPUserLogin#"
							password="#sProductionSiteInformation.ProductionFTPPassword#"
							server="#sProductionSiteInformation.ProductionFTPHost#"
							stoponerror="NO"
							connection="#connectionName#">

					<cfoutput query="SelectCategory">
						<cfmodule template="/common/modules/utils/ExplodeString.cfm" string="#CategoryID#" Delimiter="/" ReturnVarName="ThisPath">
						<cfset RemoteDirectories=ArrayNew(1)>
						<cfset RemoteDirectories[1]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('images')#">
						<cfset RemoteDirectories[2]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('documents')#">
						<cfset RemoteDirectories[3]="#sProductionSiteInformation.ProductionFTPRootPath##this.GetResourcePath('generated')#">
						<cfloop index="i" from="1" to="3" step="1">
							<cfset ThisDirectory=Replace(RemoteDirectories[i],"\","/","All")>
							<cfset ThisDirectory=Replace(ThisDirectory,"//","/","All")>

							<cfftp action="LISTDIR"
								stoponerror="NO"
								name="List"
								directory="#ThisDirectory#"
								connection="#connectionName#"
								Passive="NO">
							<cfloop query="List">
								<cfif NOT IsDirectory>
									<cfftp action="REMOVE"
									stoponerror="NO"
									item="#Path#"
									connection="#connectionName#"
									Passive="NO">
								</cfif>
							</cfloop>
						</cfloop>
					</cfoutput>

					<!--- close the connection --->
					<cfftp	action="close"
							stopOnError="NO"
							connection="#connectionName#">
				</cfif>
			</cfif>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="GetRestrictionsPropertyList" returnType="string" output="false">

		<!--- init variables --->
		<cfset var ReturnString = "">

		<cfif ListFindNoCase(StructKeyList(this),"CategoryTypeID")>
			<cfset ReturnString=this.sFields[this.CategoryTypeID]>
		<cfelse>
			<cfset ReturnString=this.sFields["-1"]>
		</cfif>
		<cfreturn ReturnString>
	</cffunction>

	<cffunction name="GetContent" returnType="Query" output="false">

		<!--- init variables --->
		<cfset var ThisCategoryID=this.GetProperty("CategoryID")>
		<cfset var GetContent = "">

		<cfquery name="GetContent" datasource="#APPLICATION.DSN#">
			SELECT * FROM qry_GetContent WHERE CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfreturn GetContent>
	</cffunction>

	<cffunction name="SaveToProduction" returntype="boolean" output="true">
		<cfargument name="WebrootPath" required="true">
		<cfargument name="UserID" required="true">

		<!--- init variables --->
		<cfset var sProductionSiteInformation = "">
		<cfset var ThisCategoryID = "">
		<cfset var ThisParentID = "">
		<cfset var ThisPropertiesID = "">
		<cfset var GetCategoryFromStaging2 = "">
		<cfset var UpdateCategoryOnProduction2 = "">
		<cfset var GetProps = "">
		<cfset var DeleteContentOnProduction2 = "">
		<cfset var UpdateContentOnProduction4 = "">
		<cfset var GetPermissions = "">
		<cfset var DeletePermissions = "">
		<cfset var Test = "">
		<cfset var UpdateCache = "">
		<cfset var success = "">
		<cfset var SaveResults = "">

		<cfinvoke component="com.ContentManager.CategoryHandler"
			method="GetProductionSiteInformation"
			returnVariable="sProductionSiteInformation"
			CategoryID="#this.GetProperty('CategoryID')#">

		<cfif IsCorrect() And IsStruct(sProductionSiteInformation)>
			<cfset ThisCategoryID=this.GetProperty("CategoryID")>
			<cfset ThisParentID=this.GetProperty("ParentID")>
			<cfset ThisPropertiesID=this.GetProperty("PropertiesID")>
			<cfquery name="GetCategoryFromStaging2" datasource="#APPLICATION.DSN#">
				SELECT * FROM t_Category Where ParentID=<cfqueryparam value="#ThisParentID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfinvoke component="com.PostToProduction.postToProduction" method="postLive">
			     <cfinvokeargument name="valueList" value="#ThisCategoryID#">
			     <cfinvokeargument name="columnList" value="CategoryID">
			     <cfinvokeargument name="tableName" value="t_Category">
			     <cfinvokeargument name="sourceDatabase" value="#APPLICATION.DSN#">
			     <cfinvokeargument name="sourceServer" value="#APPLICATION.SourceDBServer#">
			     <cfinvokeargument name="sourceLogin" value="#APPLICATION.SourceLogin#">
			     <cfinvokeargument name="sourcePassword" value="#APPLICATION.SourcePassword#">
				 <cfinvokeargument name="destinationDSN" value="#sProductionSiteInformation.ProductionDBName#">
			</cfinvoke>



			<cfoutput query="GetCategoryFromStaging2">
				<cfquery name="UpdateCategoryOnProduction2" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					UPDATE t_Category SET
					CategoryActive=<cfqueryparam value="#val(CategoryActive)#" cfsqltype="cf_sql_bit">,
					CategoryPriority=<cfqueryparam value="#val(CategoryPriority)#" cfsqltype="cf_sql_integer">,
					DisplayOrder=<cfqueryparam value="#Trim(DisplayOrder)#" cfsqltype="cf_sql_varchar">
					Where CategoryID=<cfqueryparam value="#val(CategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfoutput>

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
					<cfqueryparam value="#Trim(PropertiesPacket)#" cfsqltype="cf_sql_longvarchar">,
					<cfqueryparam value="#Val(PropertiesID)#" cfsqltype="cf_sql_integer">
					)
					SET IDENTITY_INSERT t_Properties OFF
				</cfquery>
			</cfoutput>

			<cfquery name="GetPermissions" datasource="#APPLICATION.DSN#">
				select * from t_Permissions where CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="DeletePermissions" datasource="#sProductionSiteInformation.ProductionDBDSN#">
				delete from t_Permissions where CategoryID=<cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfoutput query="GetPermissions">
				<cfquery name="Test" datasource="#sProductionSiteInformation.ProductionDBDSN#">
					insert into t_permissions (
					UserGroupID,
					CategoryID,
					pRead,
					pCreate,
					pEdit,
					pDelete,
					pSaveLive,
					pManage
					) VALUES (
					<cfqueryparam value="#UserGroupID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Val(thisCategoryID)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#pRead#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#pCreate#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#pEdit#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#pDelete#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#pSaveLive#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#pManage#" cfsqltype="cf_sql_bit">
					)
				</cfquery>
			</cfoutput>

			<!--- update lTopicID --->
			<cfinvoke component="com.Taxonomy.TopicHandler"
				method="InsertRelatedTopics"
				EntityID="#Val(ThisCategoryID)#"
				EntityName="t_Category"
				lTopicID="#this.GetProperty('lTopicID')#"
				DSN="#sProductionSiteInformation.ProductionDBDSN#">

			<!--- Create the directories on the production server --->
			<!--- Open connection to the ftp server --->
			<cfinvoke component="com.ContentManager.CategoryHandler" method="CreateRemoteFolders" returnVariable="success"
				CategoryID="#ThisCategoryID#"
				FTPHost="#sProductionSiteInformation.ProductionFTPHost#"
				FTPRootPath="#sProductionSiteInformation.ProductionFTPRootPath#"
				FTPUserLogin="#sProductionSiteInformation.ProductionFTPUserLogin#"
				FTPPassword="#sProductionSiteInformation.ProductionFTPPassword#">


			<cfinvoke component="com.utils.tracking" method="track" returnVariable="success"
				UserID="#ARGUMENTS.UserID#"
				Entity="Category"
				KeyID="#ThisCategoryID#"
				Operation="savelive"
				EntityName="#this.GetProperty('CategoryName')#">

			<cfinvoke component="com.ContentManager.CategoryHandler" method="GenerateDisplayOrderString"
				returnVariable="Success"
				SourceParentID="#Val(this.GetProperty('ParentID'))#"
				datasource="#sProductionSiteInformation.ProductionDBDSN#">

			<cfquery name="UpdateCache" datasource="#sProductionSiteInformation.ProductionDBDSN#">
				UPDATE t_Category SET
				CacheDateTime=getdate()
				Where CategoryID=<cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
</cfcomponent>