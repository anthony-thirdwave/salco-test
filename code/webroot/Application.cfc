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
	<cfset this.clientManagement = true />
	<cfset this.setClientCookies = true />
	<cfset this.sessionManagement = true />
	<cfset this.sessiontimeout = createTimeSpan(0,1,0,0) />
	<cfset this.datasource="#this.uniqueName#_cms_#this.siteType#" />
	<cfset this.clientStorage="#this.uniqueName#_cms_#this.siteType#" />
		

		
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
			
		<!--- initialize the application --->
		<cfinvoke method="initializeApplication" component="com.application.ApplicationSettings">

		<cfreturn true />
	</cffunction>







	<!--- called when session is created --->
	<cffunction name="OnSessionStart" returntype="void">

		<!--- initialize the session --->
		<cfinvoke method="initializeSession" component="com.application.SessionSettings">		

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
		
		<Cfdump var=#exception#><cfabort>
<!---
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
							#ARGUMENTS.exception#
							<p>
		
						</cfmail>
					</cfloop>
				</cfoutput>
			</cfif>
		
			<!--- display the error page --->
			<cflocation url="/common/error/errorhandler.cfm" addtoken="false" />
		</cfif>
		--->
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