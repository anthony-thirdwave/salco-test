<cfcomponent displayname="Application">
	
	<!--- the unique name used in database and directory defaults --->
	<cfset this.uniqueName = "cmsdemo" />

	<!--- this variable will override any server defined siteType
				* for cf8 sites, this is where the site type is set, leaving blank creates "dev" site type
				* for cf9 sites, if server.siteType is set, if this should be "" unless 
					a site type override is needed --->
	<cfset this.overrideSiteType="">

	<!--- figure out the siteType --->
	<cfinvoke method="determineSiteType" returnvariable="this.siteType">
		<cfinvokeargument name="overrideSiteType" value="#this.overrideSiteType#">
	</cfinvoke>
	
	<!--- default application settings --->
	<cfset this.name = "www.#this.uniqueName#.com" />
	<cfset this.applicationTimeout = createTimeSpan(1,0,0,0) />
	<cfset this.sessionManagement = true />
	<cfset this.sessiontimeout = createTimeSpan(0,1,0,0) />
	<cfset this.datasource="#this.uniqueName#_cms_#this.siteType#" />
	<cfset variables.botSessionInSeconds = 2 />

	<!--- bots don't keep cookies and we don't want to do this for valid users --->
	<cfif not structKeyExists(cookie, "CFID") or structKeyExists(url, "testShortSession")>
		
		<!--- if no user agent or test case, set the short session timeout --->
		<cfif not len(CGI.HTTP_USER_AGENT) or structKeyExists(url, "testShortSession")>
			<cfset this.sessionTimeout = createTimespan(0,0,0,variables.botSessionInSeconds) />
		<cfelse>
		
			<!--- get the userAgent as lowercase --->
			<cfset variables.botUserAgent = lCase(CGI.HTTP_USER_AGENT) />
			
			<!--- the lists of potential bots --->
			<cfset variables.findList = "crawl,feed,news,blog,reader,syndication,coldfusion,slurp,google,zyborg,emonitor,jeeves,yandex" />
			<cfset variables.reFindList = "bot\b,\brss" />
			<cfset variables.botFound = false />
			
			<!--- if this is a bot, set a short session timeout --->
			<cfloop list="#findList#" index="variables.bot" delimiters=",">
				<cfif find(variables.bot, variables.botUserAgent)>
					<cfset this.sessionTimeout = createTimespan(0,0,0,variables.botSessionInSeconds) />
					<cfset variables.botFound = true />
					<cfbreak />
				</cfif>
			</cfloop>
			<cfif not variables.botFound>
				<cfloop list="#reFindList#" index="variables.bot" delimiters=",">
					<cfif reFind(variables.bot, variables.botUserAgent)>
						<cfset this.sessionTimeout = createTimespan(0,0,0,variables.botSessionInSeconds) />
						<cfbreak />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
		
	<!--- this function gets the site type --->
	<cffunction name="determineSiteType" returntype="string">
		<cfargument name="overrideSiteType" default="" />
		
		<cfset var local = structNew() />
		
		<cfif arguments.overrideSiteType eq "production"
				or (trim(arguments.overrideSiteType) eq ""
					and structKeyExists(server, "siteType")
					and server.siteType eq "production")>
			<cfset local.siteType = "production" />
		
		<!--- else if staging --->
		<cfelseif arguments.overrideSiteType eq "staging"
				or (trim(arguments.overrideSiteType) eq ""
					and structKeyExists(server, "siteType")
					and server.siteType eq "staging")>
			<cfset local.siteType = "staging" />
		
		<!--- default to dev --->
		<cfelse>
			<cfset local.siteType = "dev" />
		</cfif>
		
		<cfreturn local.siteType />
	</cffunction>




	<!--- called when the application is created --->
	<cffunction name="onApplicationStart" returntype="boolean">
		
		<cfset var local = structNew() />
			
		<!--- initialize the application - we pass the directory path of this file, because it's always webroot --->
		<cfinvoke method="initializeApplication" component="com.application.ApplicationSettings">
			<cfinvokeargument name="pathPrefix" value="#getDirectoryFromPath( getCurrentTemplatePath())#" />
		</cfinvoke>

		<cfreturn true />
	</cffunction>







	<!--- called when session is created --->
	<cffunction name="OnSessionStart" returntype="void">

		<!--- initialize the session --->
		<cfinvoke method="initializeSession" component="com.application.SessionSettings" />		

		<cfreturn />
	</cffunction>






	<!--- called before request is processed --->
	<cffunction name="OnRequestStart" returntype="boolean">
		<cfargument name="targetPage" type="string" required="true" />

		<!--- check for an application reset --->
		<cfif structKeyExists(url, "resetApplication") and url.resetApplication eq "r3s3t">
			<cfset onApplicationStart() />
		</cfif>
		
		<!--- check for a session reset --->
		<cfif structKeyExists(url, "resetSession") and url.resetSession eq "r3s3t">
			<cfset onSessionStart() />
		</cfif>
		
		<!--- lock the session scope here to make sure session not accessed in odd state by asynchronous requests. --->
		<cflock scope="SESSION" type="exclusive" timeout="10">
		</cflock>
		
		<cfset REQUEST.GlobalNavURLPrefix = "">
		<!--- if in secure, make sure nav links exit secure --->
		<cfif (CGI.SERVER_PORT EQ 443 or CGI.HTTP_Host neq CGI.SERVER_NAME) and APPLICATION.Production>
			<cfset REQUEST.GlobalNavURLPrefix = "http://#CGI.SERVER_NAME#">
		</cfif>
		
		<!--- if this request is a .cfc, then delete the onRequest method from this instance
				- fixes a bug in CF8, not necessary for CF9 --->
		<cfif listLast(arguments.targetPage,".") eq "cfc">
			<cfset structDelete(this, "onRequest") />
			<cfset structDelete(variables,"onRequest") />
		</cfif>
		
		<cfreturn true />
	</cffunction>



	<!--- called after OnRequestStart, but before request is processed
			* see Application.cfc in /com for handing of webservices, flash remoting and event gateways --->
	<cffunction name="OnRequest" returntype="void">
		<cfargument name="targetPage" type="string" required="true" />

		<!--- set encoding for form and url variables --->
		<cfset setEncoding("Form", "UTF-8") />
		<cfset setEncoding("URL", "UTF-8") />
		
		<!--- some default values --->
		<cfparam name="REQUEST.ContentGenerateMode" default="DYNAMIC">
		<cfparam name="REQUEST.ReCache" default="1">
		
		<!--- make sure pages aren't caching in browser --->
		<cfheader name="Expires" value="Mon, 06 Jan 1990 00:00:01 GMT">
		<cfheader name="Pragma" value="no-cache">
		<cfheader name="cache-control" value="no-cache">

		<!--- Include the requested page. --->
		<cfinclude template="#arguments.targetPage#" />

		<cfreturn />
	</cffunction>


	<!--- called at end of request, after processing --->
	<cffunction name="OnRequestEnd" returntype="void">

		<cfreturn />
	</cffunction>

	
	
	<!--- called at the end of a session --->
	<cffunction name="OnSessionEnd" returntype="void">
		<cfargument name="sessionScope" type="struct" required="true" />
		<cfargument name="applicationScope" type="struct" default="#StructNew()#" />

		<cfreturn />
	</cffunction>




	<!--- called at the end of the application --->
	<cffunction name="OnApplicationEnd" returntype="void">
		<cfargument name="applicationScope" type="struct" default="#StructNew()#" />

		<cfreturn />
	</cffunction>

	
	
	
	<!--- called when an uncaught exception occurs --->
	<cffunction name="OnError" returntype="void">
		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" default="" />
		
		<cfset var local = structNew() />

		<!--- only email and go to error handling page from production --->
		<cfif not isDebugMode() and APPLICATION.production>

			<!--- Get the current time.  --->
			<cfset local.ts = Now()>
			<cfif findNoCase("slurp",CGI.HTTP_USER_AGENT,1) IS "0">
				
				<cfoutput>
				
					<!--- Send the error message to each address.  --->
					<cfloop list="#APPLICATION.ErrorMailTo#" index="local.toAddress" delimiters=";">
						
						<cfmail to="#Trim(local.toAddress)#"
								from="#APPLICATION.ErrorMailFrom#"
								subject="#CGI.HTTP_HOST# Error on #DateFormat(local.ts)#, #TimeFormat(local.ts)#."
								type="HTML">
							<p>
							There was an error that occurred on the #CGI.HTTP_HOST# website on #DateFormat(local.ts)#, #TimeFormat(local.ts)#.
							</p>
							
							<p>
							Browser - #CGI.HTTP_USER_AGENT#<br>
							IP Address - #CGI.REMOTE_HOST#<br>
							Referring Page - #CGI.HTTP_REFERER#<br>
							Page - #CGI.CF_TEMPLATE_PATH#<br>
							PATH_INFO - #CGI.SCRIPT_NAME#<br>
							Query String - #CGI.QUERY_STRING#<br>
							</p>
							
							<p>
							<cfdump var=#arguments# />
							<p>
		
						</cfmail>
					</cfloop>
				</cfoutput>
			</cfif>
		
			<!--- display the error page --->
			<cflocation url="/common/error/errorhandler.cfm" addtoken="false" />
		
		<cfelse>
			<cfthrow object="#arguments.exception#"><cfabort>
		</cfif>
		
		<cfreturn />
		
	</cffunction>


	<!--- return the site type --->
	<cffunction name="getSiteType" returntype="string">
		<cfreturn this.siteType />
	</cffunction>


	<!--- return the datasource --->
	<cffunction name="getDatasource" returntype="string">
		<cfreturn this.datasource />
	</cffunction>

	
	<!--- return the unique name --->
	<cffunction name="getUniqueName" returntype="string">
		<cfreturn this.uniqueName />
	</cffunction>

</cfcomponent>