<cfif ATTRIBUTES.Action IS "GetVar">
	<cfset beginstring="<!-- ##BeginEditable ""#Attributes.VarName#"" -->">
	<cfset start=FindNoCase(beginstring, Attributes.String, "1")>
	<cfif start>
		<cfset start=Start + len(beginstring)>
		<cfset count=Find("<!-- ##EndEditable -->", "#Attributes.String#", "#start#")-start>
		<cfset TempString=mid(Attributes.String,start, count)>
		<!--- <cfset start2=Find(">--", "#reverse(TempString)#", "1")> --->
		<cfif len(TempString) IS NOT "0"><!--- The value is not empty --->
			<cfset thisvalue=TempString>
		<cfelse>
			<Cfset thisvalue="">
		</cfif>
	<cfelse>
		<cfset ThisValue="">
	</cfif>
	<cfset Caller.value=ThisValue>
	<!--- <cfset Caller.value=REReplaceNoCase(thisvalue,"[ ]+"," ","All")> --->
<cfelseif ATTRIBUTES.Action IS "GetFileList">
	<!--- Brian W. --->
	<cfsilent>
		<cfparam name="ATTRIBUTES.DetectLocalHTTPImages" default="No">
		<!--- Returns a ";" delimited list of files that are html attributes (with path and extension) in ATTRIBUTES.STRING in CALLER.FileList. Returns number of files in CALLER.NumFiles --->
		<cfif IsDefined("Attributes.FileExtensionList")>
			<cfset FileExtensionList=Attributes.FileExtensionList>
		<cfelse>
			<cfset FileExtensionList=".jpg;.gif;.jpeg;.jpe;.pdf">
		</cfif>
		<cfset invalidFileCharacters="=|'|""|\(|:">
		<cfset FileList = "">
		<cfset currentPosition = 1>
		<cfloop condition="currentPosition GT 0">
			<cfset aFileSearchResults = REFindNoCase('(' & #invalidFileCharacters# & ')([^(' & #invalidFileCharacters# & ')]*(?:\([A-Za-a0-9]*\)){0,1}(' & Replace(ListChangeDelims(FileExtensionList,'|',';'),".","\.","all") & '))',Attributes.String,currentPosition,True)>
			<cfif aFileSearchResults.pos[1] EQ 0>
				<cfset currentPosition = 0>
			<cfelse>
				<cfset currentPosition = aFileSearchResults.pos[3] + aFileSearchResults.len[3]>
				<cfset ThisGuy=trim(mid(Attributes.String,aFileSearchResults.pos[3],aFileSearchResults.len[3]))>
				<cfif Left(ThisGuy,2) IS NOT "//">
					<cfset FileList = listAppend(FileList,ThisGuy,";")>
				</cfif>
			</cfif>
		</cfloop>
		<cfset Caller.FileList=FileList>
		<cfset Caller.NumFiles=listLen(FileList,";")>
 	</cfsilent>
</cfif>
