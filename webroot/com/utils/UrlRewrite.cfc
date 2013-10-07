<cfcomponent output="false">


<cffunction name="init" returntype="UrlRewrite" output="false">
	<cfreturn this />
</cffunction>

<cfset variables.returnChr = chr(13) & chr(10) />



<!--- ########## .htaccess functions ########## --->

<!--- createHtaccess --->
<cffunction name="createHtaccess" returntype="boolean" output="false">

	<!--- keep variables local to this function --->
	<cfset var local = structNew() />

	<!--- read the .htaccess file --->
	<cffile action="read" file="#APPLICATION.WebRootPath#.htaccess" variable="local.theFile" />

	<!--- write a copy of the current .htaccess file --->
	<cffile action="write" file="#APPLICATION.WebRootPath#.htaccess.last" output="#local.theFile#" />

	<!--- init some container variables --->
	<cfset local.header = "" />
	<cfset local.dynamic = "" />
	<cfset local.footer = "" />
	<cfset local.thisSection = "header" />
	<cfset local.thisRewrite = "" />

	<!--- loop through the lines and parse out the header and footer --->
	<cfloop index="local.itr" list="#local.theFile#" delimiters="#variables.returnChr#">

		<!--- start the footer --->
		<cfif trim(local.itr) eq "##END_DYNAMIC_CONTENT">
			<cfset local.thisSection = "footer" />
		</cfif>

		<!--- depending on the section, write the file contents to a variable --->
		<cfif local.thisSection eq "footer" or local.thisSection eq "header">

			<!--- if there's a comment, add an extra line break before it --->
			<cfif left(trim(local.itr), 1) eq "##" and trim(local.itr) neq "##END_DYNAMIC_CONTENT">
				<cfset local[local.thisSection] = local[local.thisSection] & variables.returnChr />
			</cfif>
			<cfset local[local.thisSection] = local[local.thisSection] & local.itr & variables.returnChr />
		</cfif>

		<!--- end the header --->
		<cfif trim(local.itr) eq "##DYNAMIC_CONTENT">
			<cfset local.thisSection = "dynamic">
		</cfif>
	</cfloop>

	<!--- get the rewrites --->
	<cfinvoke method="getRewrites" returnvariable="local.rewrites">

	<!--- loop through the rewrites and add them to the dynamic section ---->
	<cfloop query="local.rewrites">

		<!--- if dateStart and dateEnd are ok --->
		<cfif (not isDate(local.rewrites.dateStart) and not isDate(local.rewrites.dateEnd))
				or (
					((isDate(local.rewrites.dateStart) and dateCompare(now(), local.rewrites.dateStart) gt 0)
						or not isDate(local.rewrites.dateStart))
					and
					((isDate(local.rewrites.dateEnd) and dateCompare(now(), local.rewrites.dateEnd) lt 0)
						or not isDate(local.rewrites.dateEnd))
					)>

			<!--- parse the rewrite --->
			<cfinvoke method="parseRewriteRule" returnvariable="local.thisRewrite">
				<cfinvokeargument name="sourceUrl" value="#local.rewrites.sourceUrl#">
				<cfinvokeargument name="destinationUrl" value="#local.rewrites.destinationUrl#">
				<cfinvokeargument name="dateStart" value="#local.rewrites.dateStart#">
				<cfinvokeargument name="dateEnd" value="#local.rewrites.dateEnd#">
				<cfinvokeargument name="sourcePrefix" value="#local.rewrites.sourcePrefix#">
				<cfinvokeargument name="sourceSuffix" value="#local.rewrites.sourceSuffix#">
				<cfinvokeargument name="allowSource" value="#local.rewrites.allowSource#">
				<cfinvokeargument name="destinationPrefix" value="#local.rewrites.destinationPrefix#">
				<cfinvokeargument name="destinationSuffix" value="#local.rewrites.destinationSuffix#">
				<cfinvokeargument name="allowDestination" value="#local.rewrites.allowDestination#">
				<cfinvokeargument name="flag" value="#local.rewrites.flag#">
			</cfinvoke>

			<!--- add this rewrite to the variable for the file write --->
			<cfset local.dynamic = local.dynamic & local.thisRewrite & variables.returnChr />
		</cfif>
	</cfloop>

	<!--- concatenate the sections --->
	<cfset local.fileContents = local.header & local.dynamic & local.footer />

	<cftry>

		<!--- write out the file --->
		<cffile action="write" file="#APPLICATION.WebRootPath#.htaccess" output="#local.fileContents#" />

		<!--- if write fails, return false --->
		<cfcatch>
			<cfreturn false>
		</cfcatch>
	</cftry>

	<!--- return success --->
	<cfreturn true>

</cffunction>




<!--- make an entry safe for .htaccess --->
<cffunction name="htaccessSafe" output="false" returntype="string">
	<cfargument name="theString" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- if string isn't null, replace special chars --->
	<cfif trim(theString) neq "">
		<cfset local.theString = replace(arguments.theString, "+", "\+", "all") />
		<cfset local.theString = replace(local.theString, "*", "\*", "all") />
		<cfset local.theString = replace(local.theString, "?", "\?", "all") />
		<cfset local.theString = replace(local.theString, ".", "\.", "all") />
		<cfset local.theString = replace(local.theString, "^", "\^", "all") />
		<cfset local.theString = replace(local.theString, "%", "\%", "all") />
	</cfif>

	<cfreturn trim(local.theString) />
</cffunction>


<!--- push .htaccess live --->
<cffunction name="pushHtaccessLive" output="false" returntype="struct">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	<cfset local.returnStruct = structNew() />

	<!--- set some return defaults --->
	<cfset local.returnStruct.source = "" />
	<cfset local.returnStruct.destination = "" />
	<cfset local.returnStruct.success = "no" />
	<cfset local.returnStruct.errorCode = "-1" />
	<cfset local.returnStruct.errorText = "Url Redirects can only be pushed live from the staging server" />


	<!--- 1 is the category of the website root --->
	<cfinvoke component="com.ContentManager.CategoryHandler"
		method="GetProductionSiteInformation"
		returnVariable="local.sProductionSiteInformation"
		CategoryID="1">

	<!--- only push from staging --->
	<cfif APPLICATION.Staging and IsStruct(local.sProductionSiteInformation)>

		<!--- open the ftp connection to the production site --->
		<cfftp action="open"
		   username="#local.sProductionSiteInformation.ProductionFTPUserLogin#"
		   password="#local.sProductionSiteInformation.ProductionFTPPassword#"
		   server="#local.sProductionSiteInformation.ProductionFTPHost#"
		   stopOnError="NO"
		   connection="FTP_#scrub(local.sProductionSiteInformation.ProductionFTPHost)#">

		<!--- set source and destination --->
		<cfset local.returnStruct.source= application.webrootPath & ".htaccess">
		<cfset local.returnStruct.destination=ReplaceNoCase("#local.sProductionSiteInformation.ProductionFTPRootPath#","//","/","All")>

		<!--- put the file --->
		<cfftp action="PUTFILE"
			stoponerror="No"
			localfile="#local.returnStruct.source#"
			remotefile="#local.returnStruct.destination#.htaccess"
			transfermode="Auto" connection="FTP_#scrub(local.sProductionSiteInformation.ProductionFTPHost)#" timeout="60"
			Passive="No">
			<cfdump var="#local#">

		<!--- return the status of the put --->
		<cfset local.returnStruct.success = cfftp.succeeded />
		<cfset local.returnStruct.errorCode = cfftp.errorCode />
		<cfset local.returnStruct.errorText = cfftp.errorText />

		<!--- close the connection --->
		<cfftp action="close"
		   stopOnError="NO"
		   connection="FTP_#scrub(local.sProductionSiteInformation.ProductionFTPHost)#">
	</cfif>

	<cfreturn local.returnStruct />
</cffunction>


<!--- this function was ripped from commonFunctions.cfm - used for ftp connection --->
<cffunction name="scrub" returntype="string" output="false">
	<cfargument name="strInput" type="string" required="yes">

	<cfset var local = structNew() />

	<cfset local.ReturnValue=lcase(ReReplace(arguments.strInput,"[�\!'/:"".+=;?&<>|,]","","all"))>
	<cfset local.ReturnValue=lcase(ReReplace(local.ReturnValue,"[ ]"," ","all"))>
	<cfset local.ReturnValue=lcase(ReReplace(local.ReturnValue,"[ ]","-","all"))>
	<cfreturn local.ReturnValue>
</cffunction>





<!--- ########## url rewrite functions ########## --->


<!--- get the url rewrites --->
<cffunction name="getRewrites" output="false" access="remote">
	<cfargument name="page" default="">
	<cfargument name="pageSize" default="">
	<cfargument name="cfgridsortcolumn" default="">
	<cfargument name="cfgridsortdirection" default="">
	<cfargument name="sortType" default="htaccess" />
	<cfargument name="sourceUrl" type="string" default="">
	<cfargument name="destinationUrl" type="string" default="">
	<cfargument name="dateStart" type="string" default="">
	<cfargument name="dateEnd" type="string" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the rewrites --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT r.sourceUrl, r.destinationUrl, r.rewriteTypeId,
		CONVERT(VARCHAR(10), r.dateStart, 101) dateStart,
		CONVERT(VARCHAR(10), r.dateEnd, 101) dateEnd,
		r.publicId AS rewriteUrlPublicId, rt.name, rt.alias, rt.description, rt.sourcePrefix, rt.sourceSuffix, rt.allowSource,
		rt.sourceMustBeUnique, rt.destinationPrefix, rt.destinationSuffix, rt.allowDestination, rt.destinationMustBeUnique, rt.flag,
		rt.publicId AS rewriteTypePublicId, rt.priority,
		editUrl = '<img src="/common/images/admin/icon_edit.gif" width="12" height="12" />',
		deleteUrl = '<img src="/common/images/admin/icon_delete.gif" width="12" height="12" />'
		FROM t_rewriteUrl r
		JOIN t_rewriteType rt
		ON rt.rewriteTypeId = r.rewriteTypeId
		WHERE 1=1

		<!--- for searching from the admin page --->
		<cfif trim(arguments.sourceUrl) neq "">
			AND r.sourceUrl LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.sourceUrl#%">
		</cfif>
		<cfif trim(arguments.destinationUrl) neq "">
			AND r.destinationUrl LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.destinationUrl#%">
		</cfif>
		<cfif isDate(arguments.dateStart)>
			AND CONVERT(VARCHAR(10), r.dateStart, 101) >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateStart#">
		</cfif>
		<cfif isDate(arguments.dateEnd)>
			AND CONVERT(VARCHAR(10), r.dateEnd, 101) <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dateEnd#">
		</cfif>

		<!--- order is important when writing the .htaccess file, so if we're not in admin, we go by priority, then
		sourceUrl DESC - makes sure rules aren't skipped --->
		<cfif trim(arguments.sortType) eq "admin">
			<cfif trim(arguments.cfgridsortcolumn) neq "">
				ORDER BY #arguments.cfgridsortcolumn# #arguments.cfgridsortdirection#
			<cfelse>
				ORDER BY r.sourceUrl, r.destinationUrl
			</cfif>
		<cfelse>
			ORDER BY rt.priority, r.priority, r.sourceUrl DESC
		</cfif>
	</cfquery>

	<!--- if page and pageSize are numeric then return for cfgrid --->
	<cfif isNumeric(arguments.page) and isNumeric(arguments.pageSize)>
		<!--- return the results --->
		<cfreturn queryConvertForGrid(local.getResults, arguments.page, arguments.pageSize)>
	<cfelse>
		<!--- return the query results --->
		<cfreturn local.getResults>
	</cfif>
</cffunction>




<!--- get a rewrite by id --->
<cffunction name="getRewrite" output="false" returntype="query" access="public">
	<cfargument name="rewriteUrlId" default="">
	<cfargument name="publicId" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the type --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT r.rewriteUrlId, r.sourceUrl, r.destinationUrl, r.rewriteTypeId, r.dateStart, r.dateEnd,
		r.publicId AS rewriteUrlPublicId, r.priority, rt.rewriteTypeId, rt.name, rt.alias, rt.description, rt.sourcePrefix,
		rt.sourceSuffix, rt.allowSource, rt.sourceMustBeUnique, rt.destinationPrefix, rt.destinationSuffix,
		rt.allowDestination, rt.destinationMustBeUnique, rt.flag, rt.publicId AS rewriteTypePublicId,
		rt.priority AS rewriteTypePriority
		FROM t_rewriteUrl r
		JOIN t_rewriteType rt
		ON rt.rewriteTypeId = r.rewriteTypeId
		WHERE
			<cfif isNumeric(arguments.rewriteUrlId)>
				r.rewriteUrlId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rewriteUrlId#">
			<cfelse>
				r.publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.publicId)#">
			</cfif>
	</cfquery>

	<cfreturn local.getResults />
</cffunction>



<!--- add a new rewrite --->
<cffunction name="addRewrite" returntype="struct" output="false">
	<cfargument name="sourceUrl" default="">
	<cfargument name="destinationUrl" default="">
	<cfargument name="dateStart" default="">
	<cfargument name="dateEnd" default="">
	<cfargument name="rewriteTypePublicId" default="">


	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- set some default return values --->
	<cfset local.returnStruct = structNew() />
	<cfset local.returnStruct.rewriteUrlId = 0>
	<cfset local.returnStruct.matchingId = 0>
	<cfset local.messageKey = "" />

	<!--- trim the user entered fields --->
	<cfset local.sourceUrl = trim(arguments.sourceUrl) />
	<cfset local.destinationUrl = trim(arguments.destinationUrl) />
	<cfset local.dateStart = trim(arguments.dateStart) />
	<cfset local.dateEnd = trim(arguments.dateEnd) />

	<!--- create a new publicId --->
	<cfset local.publicId = APPLICATION.utilsObj.createUniqueId()>

	<!--- get the rewriteType by publicId --->
	<cfinvoke method="getRewriteType" returnvariable="local.rewriteType">
		<cfinvokeargument name="publicId" value="#arguments.rewriteTypePublicId#">
	</cfinvoke>

	<!--- if there's no matching type, abort --->
	<cfif local.rewriteType.recordcount neq 1>
		<cfset local.messageKey = "urlRewrite-noRedirectType" />
	</cfif>

	<!--- validate that this rewrite can be added based upon rules of the type --->
	<cfinvoke method="rewriteIsAllowed" returnvariable="local.rewriteUnique">
		<cfinvokeargument name="sourceUrl" value="#local.sourceUrl#">
		<cfinvokeargument name="destinationUrl" value="#local.destinationUrl#">
		<cfinvokeargument name="rewriteType" value="#local.rewriteType#">
	</cfinvoke>

	<!--- if the rewrite is breaking rules, abort --->
	<cfif local.rewriteUnique.matchingId neq 0>
		<cfset local.returnStruct.matchingId = local.rewriteUnique.matchingId />
		<cfset local.messageKey = local.rewriteUnique.messageKey />
	</cfif>

	<!--- if no errors so far --->
	<cfif not len(trim(local.messageKey))>

		<cftry>
			<!--- insert the rewrite --->
			<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
				SET NOCOUNT ON
				INSERT INTO t_RewriteUrl
				(
					sourceUrl,
					destinationUrl,
					rewriteTypeId,
					dateStart,
					dateEnd,
					publicId
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.sourceUrl#" null="#not len(local.sourceUrl)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.destinationUrl#" null="#not len(local.destinationUrl)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.rewriteType.rewriteTypeId#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#local.dateStart#" null="#not isDate(local.dateStart)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.dateEnd#" null="#not isDate(local.dateEnd)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.publicId#">
				)

				SELECT SCOPE_IDENTITY() AS newId
				SET NOCOUNT OFF
			</cfquery>

			<!--- grab the new rewriteUrlId --->
			<cfset local.returnStruct.rewriteUrlId = local.getResults.newId />

			<cfcatch>
				<cfset local.messageKey = "urlRewrite-addFailed" />
			</cfcatch>
		</cftry>
	</cfif>

	<!--- get the message - will have blank values if no error --->
	<cfinvoke method="getMessage" component="#APPLICATION.messageObj#" returnvariable="local.returnStruct.errorMessage">
		<cfinvokeargument name="messageKey" value="#local.messageKey#">
		<cfinvokeargument name="returnAsStruct" value="true">
	</cfinvoke>

	<!--- return the rewriteUrlId --->
	<cfreturn local.returnStruct />
</cffunction>







<!--- update a rewrite --->
<cffunction name="updateRewrite" returntype="struct" output="false">
	<cfargument name="rewriteUrlPublicId" default="">
	<cfargument name="sourceUrl" default="">
	<cfargument name="destinationUrl" default="">
	<cfargument name="rewriteTypePublicId" default="">
	<cfargument name="dateStart" default="">
	<cfargument name="dateEnd" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- set some default return values --->
	<cfset local.returnStruct = structNew() />
	<cfset local.returnStruct.rewriteUrlId = 0 />
	<cfset local.returnStruct.matchingId = 0 />
	<cfset local.messageKey = "" />

	<!--- trim the user entered fields --->
	<cfset local.sourceUrl = trim(arguments.sourceUrl) />
	<cfset local.destinationUrl = trim(arguments.destinationUrl) />
	<cfset local.dateStart = trim(arguments.dateStart) />
	<cfset local.dateEnd = trim(arguments.dateEnd) />

	<!--- get the rewriteType by publicId --->
	<cfinvoke method="getRewriteType" returnvariable="local.rewriteType">
		<cfinvokeargument name="publicId" value="#arguments.rewriteTypePublicId#" />
	</cfinvoke>

	<!--- if there's no matching type --->
	<cfif not local.rewriteType.recordcount>
		<cfset local.messageKey = "urlRewrite-noRedirectType" />
	</cfif>

	<!--- get the rewrite by publicId --->
	<cfinvoke method="getRewrite" returnvariable="local.rewrite">
		<cfinvokeargument name="publicId" value="#arguments.rewriteUrlPublicId#" />
	</cfinvoke>

	<!--- if the rewrite doesn't exist and no errors so far --->
	<cfif not local.rewrite.recordcount and not len(trim(local.messageKey))>
		<cfset local.messageKey = "urlRewrite-noRedirect" />
	</cfif>

	<!--- if no errors so far --->
	<cfif not len(trim(local.messageKey))>
		<!--- validate that this rewrite can be updated based upon rules of the type --->
		<cfinvoke method="rewriteIsAllowed" returnvariable="local.rewriteUnique">
			<cfinvokeargument name="rewriteUrlId" value="#val(local.rewrite.rewriteUrlId)#" />
			<cfinvokeargument name="sourceUrl" value="#local.sourceUrl#" />
			<cfinvokeargument name="destinationUrl" value="#local.destinationUrl#" />
			<cfinvokeargument name="rewriteType" value="#local.rewriteType#" />
		</cfinvoke>

		<!--- if the rewrite is breaking rules --->
		<cfif local.rewriteUnique.matchingId neq 0>
			<cfset local.returnStruct.matchingId = local.rewriteUnique.matchingId />
			<cfset local.messageKey = local.rewriteUnique.messageKey />
		</cfif>
	</cfif>

	<!--- if no errors so far --->
	<cfif not len(trim(local.messageKey))>
		<cftry>

			<!--- insert the rewrite --->
			<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
				UPDATE t_RewriteUrl
				SET
					sourceUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.sourceUrl#" null="#not len(local.sourceUrl)#">,
					destinationUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.destinationUrl#" null="#not len(local.destinationUrl)#">,
					rewriteTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.rewriteType.rewriteTypeId#">,
					dateStart = <cfqueryparam cfsqltype="cf_sql_date" value="#local.dateStart#" null="#not isDate(local.dateStart)#">,
					dateEnd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.dateEnd#" null="#not isDate(local.dateEnd)#">
				WHERE
					rewriteUrlId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.rewrite.rewriteUrlId#">
			</cfquery>

			<!--- return the id if successful --->
			<cfset local.returnStruct.rewriteUrlId = local.rewrite.rewriteUrlId>

			<cfcatch>

				<cfset local.messageKey = "urlRewrite-updateFailed" />
			</cfcatch>
		</cftry>
	</cfif>

	<!--- get the message - will have blank values if no error --->
	<cfinvoke method="getMessage" component="#APPLICATION.messageObj#" returnvariable="local.returnStruct.errorMessage">
		<cfinvokeargument name="messageKey" value="#local.messageKey#">
		<cfinvokeargument name="returnAsStruct" value="true">
	</cfinvoke>

	<!--- return the rewriteUrlId --->
	<cfreturn local.returnStruct />
</cffunction>








<!--- parse a rewrite --->
<cffunction name="parseRewriteRule" output="false" returntype="string" access="private">
	<cfargument name="sourceUrl" type="string" default="">
	<cfargument name="destinationUrl" type="string" default="">
	<cfargument name="dateStart" type="string" default="">
	<cfargument name="dateEnd" type="string" default="">
	<cfargument name="sourcePrefix" type="string" default="">
	<cfargument name="sourceSuffix" type="string" default="">
	<cfargument name="allowSource" type="numeric">
	<cfargument name="destinationPrefix" type="string" default="">
	<cfargument name="destinationSuffix" type="string" default="">
	<cfargument name="allowDestination" type="numeric">
	<cfargument name="flag" type="string" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<cfset local.rewrite = "RewriteRule " />

	<!--- strip leading "/" from sourceUrl and destinationUrl since "RewriteBase /" should be set in .htaccess --->
	<cfif left(arguments.sourceUrl, 1) eq "/">
		<cfset arguments.sourceUrl = replace(arguments.sourceUrl, "/", "", "one")>
	</cfif>
	<cfif left(arguments.destinationUrl, 1) eq "/">
		<cfset arguments.destinationUrl = replace(arguments.destinationUrl, "/", "", "one")>
	</cfif>

	<!--- prefix for the source url --->
	<cfif trim(arguments.sourcePrefix) neq "">
		<cfset local.rewrite = local.rewrite & trim(arguments.sourcePrefix) />
	</cfif>

	<!--- the source url --->
	<cfif arguments.allowSource and trim(arguments.sourceUrl) neq "">
		<cfset local.rewrite = local.rewrite & htaccessSafe(trim(arguments.sourceUrl)) />
	</cfif>

	<!--- suffix for the source url --->
	<cfif trim(arguments.sourceSuffix) neq "">
		<cfset local.rewrite = local.rewrite & trim(arguments.sourceSuffix) />
	</cfif>

	<!--- add a space --->
	<cfset local.rewrite = local.rewrite & " " />

	<!--- prefix for the destination url --->
	<cfif trim(arguments.destinationPrefix) neq "">
		<cfset local.rewrite = local.rewrite & trim(arguments.destinationPrefix) />
	</cfif>

	<!--- the destination url --->
	<cfif arguments.allowDestination and trim(arguments.destinationUrl) neq "">
		<cfset local.rewrite = local.rewrite & htaccessSafe(trim(arguments.destinationUrl)) />
	</cfif>

	<!--- suffix for the destination url --->
	<cfif trim(arguments.destinationSuffix) neq "">
		<cfset local.rewrite = local.rewrite & trim(arguments.destinationSuffix) />
	</cfif>

	<!--- flag --->
	<cfif trim(arguments.flag) neq "">

		<!--- add a space --->
		<cfset local.rewrite = local.rewrite & " " />

		<!--- add the flag --->
		<cfset local.rewrite = local.rewrite & "[" & trim(arguments.flag) & "]" />
	</cfif>

	<!--- return the rewriteRule --->
	<cfreturn local.rewrite />
</cffunction>




<!--- check if a rewrite is ok based upon the type definition --->
<cffunction name="rewriteIsAllowed" output="false" returntype="struct">
	<cfargument name="rewriteUrlId" default="">
	<cfargument name="sourceUrl" type="string" required="true">
	<cfargument name="destinationUrl" type="string" required="true">
	<cfargument name="rewriteType" type="query" required="true">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	<cfset local.returnStruct = structNew() />
	<cfset local.returnStruct.matchingId = 0 />
	<cfset local.returnStruct.messageKey = "" />


	<!--- check first if the source or destination url is both null and restricted from being null
	- values should already be trimmed! --->
	<cfif trim(arguments.sourceUrl) eq "">
		<cfset local.returnStruct.messageKey = "urlRewrite-emptySourceUrl" />
	<cfelseif arguments.rewriteType.destinationNotNull and not len(trim(arguments.destinationUrl))>
		<cfset local.returnStruct.messageKey = "urlRewrite-emptyDestinationUrl" />
	</cfif>

	<!--- check if source or destination url must be a path and should start with a "/" --->
	<cfif not len(trim(local.returnStruct.messageKey)) and arguments.rewriteType.sourceIsPath and left(trim(arguments.sourceUrl), 1) neq "/">
		<cfset local.returnStruct.messageKey = "urlRewrite-noSourceSlash" />
	<cfelseif not len(trim(local.returnStruct.messageKey)) and arguments.rewriteType.destinationIsPath and left(trim(arguments.destinationUrl), 1) neq "/">
		<cfset local.returnStruct.messageKey = "urlRewrite-noDestinationSlash" />
	</cfif>

	<!--- if a rule has been broken, return failure --->
	<cfif len(trim(local.returnStruct.messageKey))>
		<cfset local.returnStruct.matchingId = -1 />
		<cfreturn local.returnStruct />
	</cfif>

	<!--- check if the passed params are unique enough for this type --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT rewriteUrlId
		FROM t_rewriteUrl
		WHERE
			<cfif arguments.rewriteType.sourceMustBeUnique and arguments.rewriteType.destinationMustBeUnique>
				(sourceUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.sourceUrl)#" />
				OR destinationUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.destinationUrl)#" />)
			<cfelseif arguments.rewriteType.sourceMustBeUnique>
				sourceUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.sourceUrl)#" />
			<cfelseif arguments.rewriteType.destinationMustBeUnique>
				destinationUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.destinationUrl)#" />
			</cfif>
		AND rewriteTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.rewriteType.rewriteTypeId)#" />

		<!--- if there is a passed rewriteUrlId, ignore it, because it's the same record we're checking to change --->
		<cfif isNumeric(trim(arguments.rewriteUrlId))>
			AND rewriteUrlId != <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(arguments.rewriteUrlId)#" />
		</cfif>
	</cfquery>

	<!--- if there's a record, this isn't unique enough for this type --->
	<cfif local.getResults.recordcount neq 0>
		<cfset local.returnStruct.matchingId = local.getResults.rewriteUrlId />

		<!--- return a message based up on type requirements --->
		<cfif arguments.rewriteType.sourceMustBeUnique and arguments.rewriteType.destinationMustBeUnique>
			<cfset local.returnStruct.messageKey = "urlRewrite-sourceOrDestinationNotUnique" />
		<cfelseif arguments.rewriteType.sourceMustBeUnique>
			<cfset local.returnStruct.messageKey = "urlRewrite-sourceNotUnique" />
		<cfelseif arguments.rewriteType.destinationMustBeUnique>
			<cfset local.returnStruct.messageKey = "urlRewrite-destinationNotUnique" />
		</cfif>
	</cfif>

	<cfreturn local.returnStruct />
</cffunction>




<!--- delete a rewrite --->
<cffunction name="deleteRewrite" output="false" returntype="struct" access="public">
	<cfargument name="rewriteUrlId" default="">
	<cfargument name="publicId" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />
	<cfset returnStruct = structNew() />

	<!--- get the type --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		DELETE
		FROM t_rewriteUrl
		WHERE
			<cfif isNumeric(trim(arguments.rewriteUrlId))>
				rewriteUrlId = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(arguments.rewriteUrlId)#">
			<cfelse>
				publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.publicId)#">
			</cfif>
	</cfquery>

	<cfset local.messageKey = "urlRewrite-redirectDeleted" />

		<!--- get the message - will have blank values if no error --->
	<cfinvoke method="getMessage" component="#APPLICATION.messageObj#" returnvariable="local.returnStruct.errorMessage">
		<cfinvokeargument name="messageKey" value="#local.messageKey#">
		<cfinvokeargument name="returnAsStruct" value="true">
	</cfinvoke>

	<cfreturn local.returnStruct />
</cffunction>




<!--- ########## rewrite type functions ########## --->


<!--- get a rewrite type --->
<cffunction name="getRewriteType" output="false" returntype="query" access="public">
	<cfargument name="rewriteTypeId" default="">
	<cfargument name="publicId" default="">
	<cfargument name="alias" default="">

	<!--- keep scope local to function --->
	<cfset var local = structNew() />

	<!--- get the type --->
	<cfquery name="local.getResults" datasource="#APPLICATION.DSN#">
		SELECT 	rewriteTypeId, name, alias, description, sourcePrefix, sourceSuffix, allowSource, sourceMustBeUnique,
		sourceIsPath, sourceNotNull, destinationPrefix, destinationSuffix, allowDestination, destinationMustBeUnique,
		destinationIsPath, destinationNotNull, flag, publicId, priority
		FROM t_rewriteType
		WHERE
			<cfif isNumeric(trim(arguments.rewriteTypeId))>
				rewriteTypeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(arguments.rewriteTypeId)#">
			<cfelseif trim(arguments.publicId) neq "">
				publicId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.publicId)#">
			<cfelse>
				alias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.alias)#">
			</cfif>
	</cfquery>

	<cfreturn local.getResults />
</cffunction>



</cfcomponent>