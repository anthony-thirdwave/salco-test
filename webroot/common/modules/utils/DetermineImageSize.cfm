<cfparam name="attributes.thisFile" default=""/>

<CFSET width=0> 
<CFSET height=0> 
<CFSET color=0> 
<cfif FileExists(Attributes.thisFile)>
	<CFX_DynamicImage
       NAME="ImageInfo"
       ACTION="ImageInfo"
	   SRC="#attributes.thisFile#">
	<cfset width=ImageInfo.Width>
	<cfset height=ImageInfo.height>
</cfif>

<cfset caller.thisWidth = #width#/>
<cfset caller.thisHeight = #height#/> 
<cfif 0>
	<cfif FileExists(Attributes.thisFile)>
		<cffile action="READ" file="#Attributes.thisFile#" variable="FileBytes"> 
		<cfset FirstThree = ""> 
		<cfloop index="x" from="1" to="3" step="1"> 
			<cfset FirstThree = #FirstThree# & #mid(FileBytes,x,1)#> 
		</cfloop>         
		<cfif #FirstThree# EQ "GIF"> <!--- gif ---> 
			<cfset width = (#asc(mid(FileBytes,8,1))#*256)+#asc(mid(FileBytes,7,1))#> 
			<cfset height = (#asc(mid(FileBytes,10,1))#*256)+#asc(mid(FileBytes,9,1))#>  
		<cfelseif mid(#FirstThree#,1,2) EQ "BM"> <!--- bmp ---> 
			<cfset width = (#asc(mid(FileBytes,20,1))#*256)+#asc(mid(FileBytes,19,1))#> 
			<cfset height = (#asc(mid(FileBytes,24,1))#*256)+#asc(mid(FileBytes,23,1))#>  
		<cfelseif #FirstThree# EQ "‰PN"> <!--- png ---> 
			<cfset width = (#asc(mid(FileBytes,19,1))#*256)+#asc(mid(FileBytes,20,1))#> 
			<cfset height = (#asc(mid(FileBytes,23,1))#*256)+#asc(mid(FileBytes,24,1))#>  
		<cfelse> 
			<cfset FileBytesSize = Len(FileBytes)> 
			<cfset FlagFound = 0> 
			<cfset FlagFound = Find(chr(255) & chr(216) & chr(255), #FileBytes#)> 
			<cfif #FlagFound# GT 0 > 
				<cfset Position = #Flagfound# + 2> 
				<cfset ExitLoop = FALSE> 
				<CFLOOP CONDITION = "((#Exitloop# EQ FALSE) AND (#Position# LT #FileBytesSize#))"> 
					<CFLOOP CONDITION = "(asc(mid(#FileBytes#,#Position#,1)) EQ 255) AND (#Position# LT #FileBytesSize#)"> 
						<CFSET Position = #Position# + 1> 
					</CFLOOP> 
					<CFIF ((asc(mid(FileBytes,Position,1)) LT 192) OR (#asc(mid(FileBytes,Position,1))# GT 195))> 
						<cfset MarkerSize = (#asc(mid(FileBytes,Position+1,1))#*256)+#asc(mid(FileBytes,Position+2,1))#> 
						<cfset Position = #Position#+#MarkerSize#+1> 
					<CFELSE>
						<cfset ExitLoop = TRUE> 
					</CFIF> 
				</CFLOOP> 
				<CFIF #Exitloop# EQ FALSE> 
					<cfset width = -1> 
					<cfset height = -1> 
				<CFELSE> <!--- jpg ---> 
					<cfset height = (#asc(mid(FileBytes,Position+4,1))#*256)+#asc(mid(FileBytes,Position+5,1))#> 
					<cfset width = (#asc(mid(FileBytes,Position+6,1))#*256)+#asc(mid(FileBytes,Position+7,1))#> 
				</CFIF> 
			<cfelse> 
				No GIF,BMP,PNG or JPG !!<BR><BR> 
			</cfif> 
		</cfif> 
	<cfelse>
		<cfoutput>#Attributes.thisFile#</cfoutput> does not exist!!<BR><BR>
	</cfif>
	
	<cfoutput>
		<cfset caller.thisWidth = #width#/>
		<cfset caller.thisHeight = #height#/> 
	</cfoutput> 


</cfif>