<cfparam name="ATTRIBUTES.InputText" default="">
<cfparam name="ATTRIBUTES.returnVariable" default="OutputText">

<cfset aTokens=ArrayNew(1)>

<cfloop index="ThisAttribute" list="#StructKeyList(ATTRIBUTES)#">
	<cfif Left(ThisAttribute,5) IS "Token">
		<cfset thisIndex=ReplaceNoCase(ThisAttribute,"Token","","All")>
		<cfif IsNumeric(thisIndex) AND Val(ThisIndex) GT "0">
			<cfset aTokens[ThisIndex]=Evaluate("ATTRIBUTES.#ThisAttribute#")>
			<cfset sToken=StructNew()>
			<cfset StructInsert(sToken,"Token",Evaluate("ATTRIBUTES.Token#thisIndex#"),1)>
			<cfif IsDefined("ATTRIBUTES.Value#thisIndex#") AND Evaluate("ATTRIBUTES.Value#thisIndex#") IS NOT "">
				<cfset StructInsert(sToken,"Value",Evaluate("ATTRIBUTES.Value#thisIndex#"),1)>
			<cfelse>
				<cfset StructInsert(sToken,"Value","",1)>
			</cfif>
			<cfset aToken[ThisIndex]=sToken>
		</cfif>
	</cfif>
</cfloop>

<cfloop index="i" from="1" to="#ArrayLen(aTokens)#" step="1">
	<cfif IsStruct(aToken[i]) And StructKeyExists(aToken[i],"Value")>
		<cfset ATTRIBUTES.InputText=ReplaceNoCase(ATTRIBUTES.InputText,aToken[i].Token,aToken[i].Value,"all")>
	</cfif>
</cfloop>

<cfset SetVariable("CALLER.#ATTRIBUTES.returnVariable#",ATTRIBUTES.InputText)>


