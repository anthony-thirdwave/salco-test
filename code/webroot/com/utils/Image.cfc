<cfcomponent>

	<cffunction access="remote" name="test" output="false" returntype="string">
		<cfargument name="test" type="string" required="1"/>
		<cfreturn "asdfasdfasdf">
	</cffunction>

	<cffunction access="remote" name="Resize" output="false" returntype="string">
		<cfargument name="WebrootPath" type="string" required="1"/>
		<cfargument name="Source" type="string" required="1"/>
		<cfargument name="Width" type="string" required="1"/>
		<cfargument name="ForceToWidth" type="boolean" default="Yes" required="0"/>
		
		<!--- init variables --->
		<cfset var ThisSource = "">
		<cfset var GoAhead = "">
		<cfset var ThisImageName = "">
		<cfset var ThisImageExt = "">
		<cfset var NewImagePath = "">
		<cfset var NewImageURL = "">
		<cfset var ThisParameters = "">
		
		<cfif ARGUMENTS.Source IS NOT "" AND Val(ARGUMENTS.Width) GT "0">
			<cfset ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset ThisSource=ReplaceNoCase(ThisSource,"/","\","ALL")>
			<cfset ThisSource=ReplaceNoCase(ThisSource,"\\","\","ALL")>
			
			<cfif FileExists(ThisSource)>
				<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">
					<CFX_DynamicImage
				        NAME="ImageInfo"
				        ACTION="ImageInfo"
				        SRC="#ThisSource#">
				</cflock>
				<cfset GoAhead="No">
				<cfif ARGUMENTS.ForceToWidth>
					<cfif ImageInfo.Width IS NOT Val(ARGUMENTS.Width) AND ImageInfo.Width GT "0">
						<cfset GoAhead="Yes">
					</cfif>
				<cfelse>
					<cfif ImageInfo.Width GT Val(ARGUMENTS.Width) AND ImageInfo.Width GT "0">
						<cfset GoAhead="Yes">
					</cfif>
				</cfif>
				<cfif GoAhead>
					<!--- <cftry> --->
						<cfset ThisImageName=Reverse(ListRest(Reverse(ThisSource),"."))>
						<cfset ThisImageExt=ListLast(ThisSource,".")>
						<cfset NewImagePath="#ThisImageName#_resized#Val(ARGUMENTS.Width)#.#ThisImageExt#">
						<cfset NewImageURL=ReplaceNoCase(NewImagePath,ARGUMENTS.WebrootPath,"/","All")>
						<cfset NewImageURL=ReplaceNoCase(NewImageURL,"\","/","All")>
						<cfset NewImageURL=ReplaceNoCase(NewImageURL,"//","/","All")>
						<cfoutput>Source: #ThisSource#<BR>
						ThisImageName: #ThisImageName#<br>
						ThisImageExt: #ThisImageExt#<br>
						NewImagePath: #NewImagePath#<br>
						NewImageURL: #NewImageURL#<br>
						</cfoutput>
						<!--- <cftry> --->
						<cfset ThisParameters="#ARGUMENTS.Width#,0,0,1">
							
						<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">
							<cfoutput>[CFX_DynamicImage
						        NAME="IMAGE"
						        ACTION="Scale"
						        SRC="#ThisSource#"
						        DST="#NewImagePath#"
						        PARAMETERS="#ThisParameters#"]</cfoutput>
						
							<CFX_DynamicImage
						        NAME="IMAGE"
						        ACTION="Scale"
						        SRC="#ThisSource#"
						        DST="#NewImagePath#"
						        PARAMETERS="#ThisParameters#">
						</cflock>
							<!--- <cfcatch><cfreturn ARGUMENTS.Source></cfcatch>
						</cftry> --->
						<!--- <cflock timeout="60" throwontimeout="No" name="CFX_GIFGD" type="EXCLUSIVE">
						<CFX_GIFGD ACTION="RESIZE"
							FILE="#ThisSource#"
							OUTPUT="#NewImagePath#"
							X="#Val(ARGUMENTS.Width)#">
						<!---</cflock>---> --->
						<cfreturn NewImageURL>
					<!--- <cfcatch><cfreturn ARGUMENTS.Source></cfcatch>
					</cftry> --->
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
	
	<cffunction access="public" name="ResizeExact" output="false" returntype="string">
		<cfargument name="WebrootPath" type="string" required="1"/>
		<cfargument name="Source" type="string" required="1"/>
		<cfargument name="Width" type="string" required="1"/>
		<cfargument name="Height" type="string" required="1"/>
		
		<!--- init variables --->
		<cfset var ThisSource = "">
		<cfset var GoAhead = "">
		<cfset var ThisImageName = "">
		<cfset var ThisImageExt = "">
		<cfset var NewImagePath = "">
		<cfset var NewImageURL = "">
		<cfset var ThisParameters = "">
		
		<cfif ARGUMENTS.Source IS NOT "" AND Val(ARGUMENTS.Width) GT "0" AND Val(ARGUMENTS.Height) GT "0">
			<cfset ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset ThisSource=ReplaceNoCase(ThisSource,"/","\","ALL")>
			<cfset ThisSource=ReplaceNoCase(ThisSource,"\\","\","ALL")>
			<cfif FileExists(ThisSource)>
				<!---<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">--->
					<CFX_DynamicImage
				        NAME="ImageInfo"
				        ACTION="ImageInfo"
				        SRC="#ThisSource#">
				<!---</cflock>--->
				<cfset GoAhead="No">
				<cfif ImageInfo.Width IS ARGUMENTS.Width and ImageInfo.Height IS ARGUMENTS.Height>
					<cfset GoAhead="No">
				<cfelse>
					<cfset GoAhead="Yes">
				</cfif>
				<cfif GoAhead>
					<!--- <cftry> --->
					<cfset ThisImageName=Reverse(ListRest(Reverse(ThisSource),"."))>
					<cfset ThisImageExt=ListLast(ThisSource,".")>
					<cfset NewImagePath="#ThisImageName#_resized#Val(ARGUMENTS.Width)#x#Val(ARGUMENTS.Height)#.#ThisImageExt#">
					<cfset NewImageURL=ReplaceNoCase(NewImagePath,ARGUMENTS.WebrootPath,"/","All")>
					<cfset NewImageURL=ReplaceNoCase(NewImageURL,"\","/","All")>
					<cfset NewImageURL=ReplaceNoCase(NewImageURL,"//","/","All")>
					<cfoutput>Source: #ThisSource#<BR>
					ThisImageName: #ThisImageName#<br>
					ThisImageExt: #ThisImageExt#<br>
					NewImagePath: #NewImagePath#<br>
					NewImageURL: #NewImageURL#<br>
					</cfoutput>
					<!--- <cftry> --->
					<cfset ThisParameters="#Val(ARGUMENTS.Width)#,#Val(ARGUMENTS.Height)#,0,0">
					<!---<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">--->
						<CFX_DynamicImage
					        NAME="IMAGE"
					        ACTION="Scale"
					        SRC="#ThisSource#"
					        DST="#NewImagePath#"
					        PARAMETERS="#ThisParameters#"> 
					<!---</cflock>--->
							<!--- <cfcatch><cfreturn ARGUMENTS.Source></cfcatch>
						</cftry> --->
						<!--- <cflock timeout="60" throwontimeout="No" name="CFX_GIFGD" type="EXCLUSIVE">
						<CFX_GIFGD ACTION="RESIZE"
							FILE="#ThisSource#"
							OUTPUT="#NewImagePath#"
							X="#Val(ARGUMENTS.Width)#">
						<!---</cflock>---> --->
						<cfreturn NewImageURL>
					<!--- <cfcatch><cfreturn ARGUMENTS.Source></cfcatch>
					</cftry> --->
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
	
	<cffunction access="public" name="CropCenter" output="false" returntype="string">
		<cfargument name="WebrootPath" type="string" required="1"/>
		<cfargument name="Source" type="string" required="1"/>
		<cfargument name="Width" type="string" required="1"/>
		
		<!--- init variables --->
		<cfset var ThisSource = "">
		<cfset var ThisImageName = "">
		<cfset var ThisImageExt = "">
		<cfset var NewImagePath = "">
		<cfset var NewImageURL = "">
		<cfset var midX = "">
		<cfset var midY = "">
		<cfset var UpperX = "">
		<cfset var UpperY = "">
		<cfset var LowerX = "">
		<cfset var LowerY = "">
		
		<cfif ARGUMENTS.Source IS NOT "" AND Val(ARGUMENTS.Width) GT "0">
			<cfset ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset ThisSource=ReplaceNoCase(ThisSource,"/","\","ALL")>
			<cfset ThisSource=ReplaceNoCase(ThisSource,"\\","\","ALL")>
			<cfif FileExists(ThisSource)>
				<!---<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">--->
					<CFX_DynamicImage
				        NAME="ImageInfo"
				        ACTION="ImageInfo"
				        SRC="#ThisSource#">
				<!---</cflock>--->
				<cfif ImageInfo.Width GT Val(ARGUMENTS.Width)>
					<cftry>
						<cfset ThisImageName=Reverse(ListRest(Reverse(ThisSource),"."))>
						<cfset ThisImageExt=ListLast(ThisSource,".")>
						<cfset NewImagePath="#ThisImageName#_crop#Val(ARGUMENTS.Width)#.#ThisImageExt#">
						<cfset NewImageURL=ReplaceNoCase(NewImagePath,ARGUMENTS.WebrootPath,"/","All")>
						<cfset NewImageURL=ReplaceNoCase(NewImageURL,"\","/","All")>
						<cfset NewImageURL=ReplaceNoCase(NewImageURL,"//","/","All")>
						<cfoutput>Source: #ThisSource#<BR>
						ThisImageName: #ThisImageName#<br>
						ThisImageExt: #ThisImageExt#<br>
						NewImagePath: #NewImagePath#<br>
						NewImageURL: #NewImageURL#<br>
						</cfoutput>
						<cfset midX = ImageInfo.width/2>
						<cfset midY = ImageInfo.height/2>
						<cfset UpperX = midX-(ARGUMENTS.Width/2)>
						<cfset UpperY = midY-(ARGUMENTS.Width/2)>
						<cfset LowerX = midX+(ARGUMENTS.Width/2)>
						<cfset LowerY = midY+(ARGUMENTS.Width/2)>
						<cftry>
							<!---<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">--->
								<CFX_DynamicImage
							        NAME="IMAGE"
							        ACTION = "Crop"
							        SRC = "#ThisSource#"
									DST = "#NewImagePath#"
							        PARAMETERS = "#fix(UpperX)#,#fix(UpperY)#,#fix(LowerX)#,#fix(LowerY)#">
							<!---</cflock>--->
							<cfcatch type="Any"><!--- if can't crop from middle point, try upper left 88x88 quadrant --->
								<cftry>
									<!---<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">--->
										<CFX_DynamicImage
							        		NAME="IMAGE"
							        		ACTION = "Crop"
							        		SRC = "#ThisSource#"
											DST = "#NewImagePath#"
							        		PARAMETERS = "1,1,#ARGUMENTS.Width#,#ARGUMENTS.Width#">
									<!---</cflock>--->
									<cfcatch type="Any">
										<cfreturn "">
									</cfcatch>
								</cftry>
							</cfcatch>	
						</cftry>
						<cfreturn NewImageURL>
					<cfcatch><cfreturn ARGUMENTS.Source></cfcatch>
					</cftry>
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
	
	<cffunction access="public" name="Desaturate" output="false" returntype="string">
		<cfargument name="WebrootPath" type="string" required="1"/>
		<cfargument name="Source" type="string" required="1"/>
		
		<!--- init variables --->
		<cfset var ThisSource = "">
		<cfset var ThisImageName = "">
		<cfset var ThisImageExt = "">
		<cfset var NewImagePath = "">
		<cfset var NewImageURL = "">
		
		<cfif ARGUMENTS.Source IS NOT "">
			<cfset ThisSource="#ARGUMENTS.WebrootPath##ARGUMENTS.Source#">
			<cfset ThisSource=ReplaceNoCase(ThisSource,"/","\","ALL")>
			<cfset ThisSource=ReplaceNoCase(ThisSource,"\\","\","ALL")>
			<cfif FileExists(ThisSource)>
				<cfset ThisImageName=Reverse(ListRest(Reverse(ThisSource),"."))>
				<cfset ThisImageExt=ListLast(ThisSource,".")>
				<cfset NewImagePath="#ThisImageName#_desat.#ThisImageExt#">
				<cfset NewImageURL=ReplaceNoCase(NewImagePath,ARGUMENTS.WebrootPath,"/","All")>
				<cfset NewImageURL=ReplaceNoCase(NewImageURL,"\","/","All")>
				<cfset NewImageURL=ReplaceNoCase(NewImageURL,"//","/","All")>
				<cfoutput>Source: #ThisSource#<BR>
				ThisImageName: #ThisImageName#<br>
				ThisImageExt: #ThisImageExt#<br>
				NewImagePath: #NewImagePath#<br>
				NewImageURL: #NewImageURL#<br>
				</cfoutput>
				<!---<cflock type="Exclusive" name="CFX_DynamicImage" timeout="1">--->
					<CFX_DynamicImage
				        NAME="IMAGE"
				        ACTION="Modulate"
				        SRC="#ThisSource#"
				        DST="#NewImagePath#"
				        PARAMETERS="100,20,100">
				<!---</cflock>--->
				<cfreturn NewImageURL>
			<cfelse>
				<cfreturn "">
			</cfif>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
</cfcomponent>
