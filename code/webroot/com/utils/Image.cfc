<cfcomponent>


	<cffunction name="GetImage" returntype="string" output="true">
		<cfargument name="TargetImageURL" required="1">
		<cfargument name="DestinationPath" required="1">

		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		
		<cfset local.TargetImageURL=ReplaceNoCase(arguments.TargetImageURL,"\","/","ALL")>
		<cfset local.DestinationPath=ReplaceNoCase(arguments.DestinationPath,"/","\","ALL")>
		<cfset local.thisFile = #ListLast(local.TargetImageURL, '/')#>

		<cfif (Right(local.thisFile, 3) EQ "jpg") OR (Right(local.thisFile, 3) EQ "jpeg") OR (Right(local.thisFile, 3) EQ "gif")>
			<cftry>
				<cfhttp url="#TargetImageURL#" method="GET" getasbinary="yes"></cfhttp>
				<cffile action="WRITE" file="#local.DestinationPath#\#local.thisFile#" output="#cfhttp.filecontent#">
				<cfcatch type="Any">
					<cfreturn "There was an error with your transfer - #cfcatch.message#">
				</cfcatch>
			</cftry>
			<cfreturn "The file has been transferred to:<BR> #local.DestinationPath#\#local.thisFile#">
		<cfelse>
			<cfreturn "The file was not transferred.  Please make sure paths are correct and the file is of type .jpg, .jpeg, or .gif.">
		</cfif>
	</cffunction>

	<cffunction name="Resize" output="false" returntype="string">
		<cfargument name="WebrootPath" type="string" required="true"/>
		<cfargument name="Source" type="string" required="true"/>
		<cfargument name="Width" type="string" required="true"/>
		<cfargument name="ForceToWidth" type="boolean" default="Yes" />
		
		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		
		<!--- init vars --->
		<cfset local.myimage3w = createObject("component", "com.utils.image3w")>


		<cfif ARGUMENTS.Source IS NOT "" AND Val(ARGUMENTS.Width) GT "0">
			<cfset local.ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset local.ThisSource=ReplaceNoCase(local.ThisSource,"/","\","ALL")>
			<cfset local.ThisSource=ReplaceNoCase(local.ThisSource,"\\","\","ALL")>

			<cfif FileExists(local.ThisSource)>
				
				<!--- read the image --->
				<cfinvoke method="readImg" component="#local.myimage3w#">
					<cfinvokeargument name="theImg" value="#local.ThisSource#">
				</cfinvoke>
				
				<!--- get the image info --->
				<cfinvoke method="getImgInfo" component="#local.myimage3w#" returnvariable="local.ImageInfo" />
		
				<cfset local.GoAhead="No">
				<cfif ARGUMENTS.ForceToWidth>
					<cfif local.ImageInfo.Width IS NOT Val(ARGUMENTS.Width) AND local.ImageInfo.Width GT "0">
						<cfset local.GoAhead="Yes">
					</cfif>
				<cfelse>
					<cfif local.ImageInfo.Width GT Val(ARGUMENTS.Width) AND local.ImageInfo.Width GT "0">
						<cfset local.GoAhead="Yes">
					</cfif>
				</cfif>

				<cfif local.GoAhead>
					<cfset local.ThisImageName=Reverse(ListRest(Reverse(local.ThisSource),"."))>
					<cfset local.ThisImageExt=ListLast(local.ThisSource,".")>
					<cfset local.NewImagePath="#local.ThisImageName#_resized#Val(ARGUMENTS.Width)#.#local.ThisImageExt#">
					<cfset local.NewImageURL=ReplaceNoCase(local.NewImagePath,ARGUMENTS.WebrootPath,"/","All")>
					<cfset local.NewImageURL=ReplaceNoCase(local.NewImageURL,"\","/","All")>
					<cfset local.NewImageURL=ReplaceNoCase(local.NewImageURL,"//","/","All")>
					
					<!--- resize the image --->
					<cfinvoke method="resizeImg" component="local.#myimage3w#">
						<cfinvokeargument name="width" value="#ARGUMENTS.Width#">
					</cfinvoke>
					
					<!--- write the image --->
					<cfinvoke method="writeImg" component="#local.myimage3w#">
						<cfinvokeargument name="path" value="#NewImagePath#">
					</cfinvoke>

					<cfreturn local.NewImageURL>
				<cfelse>
					<cfreturn ARGUMENTS.Source>
				</cfif>
			<cfelse>
				<cfreturn "">
			</cfif>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>


	<cffunction access="public" name="Desaturate" output="true" returntype="string">
		<cfargument name="WebrootPath" type="string" required="1"/>
		<cfargument name="Source" type="string" required="1"/>
		
		<!--- keep scope local to function --->
		<cfset var local = structNew() />

		<cfset local.myimage3w = createObject("component", "com.utils.image3w")>
		
		<cfif ARGUMENTS.Source IS NOT "">
			<cfset local.ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset local.ThisSource=ReplaceNoCase(local.ThisSource,"/","\","ALL")>
			<cfset local.ThisSource=ReplaceNoCase(local.ThisSource,"\\","\","ALL")>
		
			<cfif FileExists(local.ThisSource)>
				<cfset local.ThisImageName=Reverse(ListRest(Reverse(local.ThisSource),"."))>
				<cfset local.ThisImageExt=ListLast(local.ThisSource,".")>
				<cfset local.NewImagePath="#local.ThisImageName#_desat.#local.ThisImageExt#">
				<cfset local.NewImageURL=ReplaceNoCase(local.NewImagePath,ARGUMENTS.WebrootPath,"/","All")>
				<cfset local.NewImageURL=ReplaceNoCase(local.NewImageURL,"\","/","All")>
				<cfset local.NewImageURL=ReplaceNoCase(local.NewImageURL,"//","/","All")>
				
				<!--- read the image --->
				<cfinvoke method="readImg" component="#local.myimage3w#">
					<cfinvokeargument name="theImg" value="#local.ThisSource#">
				</cfinvoke>
				
				<!--- turn the image to grayscale --->
				<cfinvoke method="grayscaleImg" component="#local.myimage3w#" />
				
				<!--- write the image --->
				<cfinvoke method="writeImg" component="#local.myimage3w#">
					<cfinvokeargument name="path" value="#local.NewImagePath#">
				</cfinvoke>

				<cfreturn local.NewImageURL>
			<cfelse>
				<cfreturn "">
			</cfif>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>


	<cffunction access="public" name="GetImageInfo" output="false" returntype="struct">
		<cfargument name="WebrootPath" type="string" required="true"/>
		<cfargument name="Source" type="string" required="true"/>

		<!--- keep scope local to function --->
		<cfset var local = structNew() />
		
		<cfset local.myimage3w = createObject("component", "com.utils.image3w")>

		<cfif ARGUMENTS.Source IS NOT "">
			<cfset local.ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset local.ThisSource=ReplaceNoCase(local.ThisSource,"/","\","ALL")>
			<cfset local.ThisSource=ReplaceNoCase(local.ThisSource,"\\","\","ALL")>
			<cfif FileExists(local.ThisSource)>
			
				<!--- read the image --->
				<cfinvoke method="readImg" component="#local.myimage3w#">
					<cfinvokeargument name="theImg" value="#local.ThisSource#">
				</cfinvoke>
				
				<!--- read the image --->
				<cfinvoke method="getImgInfo" component="#local.myimage3w#" returnvariable="local.ImageInfo" />

				<cfset local.sInfo.width = local.ImageInfo.Width>
				<cfset local.sInfo.height = local.ImageInfo.Height>
			</cfif>
		</cfif>
		<cfreturn local.sInfo>
	</cffunction>

</cfcomponent>
