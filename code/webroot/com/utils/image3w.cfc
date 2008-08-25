<cfcomponent hint="Interface to cfimage" output="false">

	<!--- create a blank default image --->
	<cfset variables.myImg = ImageNew("", 25, 25, "rgb", "red") />

	<!--- read the image into memory --->
	<cffunction name="readImg" output="false">
		<cfargument name="theImg" required="true">
		
		<cfset var local = structNew()>
		
		<!--- read the file as binary to prevent bandOffsets.length bug --->
		<cffile action="readBinary" file="#arguments.theImg#" variable="local.theImage">
		<cfimage name="variables.myImg" action="read" source="#local.theImage#" isBase64="yes" />
	</cffunction>

	
	
	<!--- dumps image to the browser window --->
	<cffunction name="dumpImg" output="true">
		
		<!--- dump the image --->
		<cfimage action="writeToBrowser" source="#variables.myImg#" />
	</cffunction>

	
	
	
	<!--- rotates image by the passed number of degrees --->
	<cffunction name="rotateImg" output="false">
		<cfargument name="angle" type="numeric" default="90" />
		
		<!--- rotate the image by the passed angle --->
		<cfimage name="variables.myImg" action="rotate" source="#variables.myImg#" angle="#arguments.angle#" />
	</cffunction>
	
	
	
	
	<!--- resizes image to a specific height and keeps the scale --->
	<cffunction name="scaleImgToHeight" output="false">
		<cfargument name="height" type="numeric" />
		<cfargument name="setAntialiasing" default="true">
		<cfargument name="interpolation" default="highestQuality" />
		
		<!--- set antialiasing for better quality --->
		<cfif arguments.setAntialiasing>
			<cfset ImageSetAntialiasing(variables.myImg)>
		</cfif>
	</cffunction>
	
	
	
	
	<!--- resizes image to a specific width and keeps the scale --->
	<cffunction name="scaleImgToWidth" output="false">
		<cfargument name="width" type="numeric" />
		<cfargument name="setAntialiasing" default="true">
		<cfargument name="interpolation" default="highestQuality" />
		
		<!--- set antialiasing for better quality --->
		<cfif arguments.setAntialiasing>
			<cfset ImageSetAntialiasing(variables.myImg)>
		</cfif>
	</cffunction>
	
	
	
	
	
	<!--- resizes image  --->
	<cffunction name="resizeImg" output="false">
		<cfargument name="width" default="" />
		<cfargument name="height" default="" />
		<cfargument name="setAntialiasing" default="true" />
		<cfargument name="interpolation" default="highestQuality" />
		
		<!--- set antialiasing for better quality --->
		<cfif arguments.setAntialiasing>
			<cfset ImageSetAntialiasing(variables.myImg)>
		</cfif>
		
		<!--- based upon the passed dimensions, resize or rescale --->
		<cfif arguments.width neq "" and arguments.height eq "">
			
			<!--- scale the image to width --->
			<cfset imageScaleToFit(variables.myImg, arguments.width, "", arguments.interpolation) />
		<cfelseif arguments.height neq "" and arguments.width eq "">
			
			<!--- scale the image to height --->
			<cfset imageScaleToFit(variables.myImg, "", arguments.height, arguments.interpolation) />
		<cfelse>
			
			<!--- resize the image --->
			<cfset imageResize(variables.myImg, arguments.width, arguments.height, arguments.interpolation) />
		</cfif>
	</cffunction>
	
	
	
	<!--- converts image to grayscale  --->
	<cffunction name="grayscaleImg" output="false">
		<cfargument name="setAntialiasing" default="true">
		
		<!--- set antialiasing for better quality --->
		<cfif arguments.setAntialiasing>
			<cfset ImageSetAntialiasing(variables.myImg,"on")>
		</cfif>
		
		<!--- convert the image to grayscale --->
		<cfset imageGrayscale(variables.myImg) />
	</cffunction>

	
	
	
	<!--- writes the image  --->
	<cffunction name="writeImg" output="false">
		<cfargument name="path" type="string" required="true" />
		<cfargument name="overwrite" type="boolean" default="true" />
		
		<!--- write the image --->
		<cfimage action="write" destination="#arguments.path#" source="#variables.myImg#" overwrite="#arguments.overwrite#"/>
	</cffunction>
	
	
	
		
	<!--- return the image --->
	<cffunction name="getImg" output="false">
		<cfreturn variables.myImg />
	</cffunction>
	
	
	
	
	<!--- get the image info --->
	<cffunction name="getImgInfo" output="false">
		<!--- return the image info --->
		<cfreturn imageInfo(variables.myImg) />
	</cffunction>
	

</cfcomponent>