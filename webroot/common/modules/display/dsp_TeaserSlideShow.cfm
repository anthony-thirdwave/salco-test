<cfparam name="ATTRIBUTES.contentID" default="-1">
<cfparam name="ATTRIBUTES.localeID" default="#APPLICATION.localeID#">

<cfstoredproc procedure="sp_GetContent" datasource="#APPLICATION.DSN#">
	<cfprocresult name="GetContent">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="ContentID" value="#Val(ThisContentIDPrime)#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="LocaleID" value="#APPLICATION.LocaleID#" null="No">
	<cfprocparam type="In" cfsqltype="CF_SQL_BIT" dbvarname="ContentActiveDerived" value="1" null="No">
</cfstoredproc>

<cfif IsWDDX(GetContent.ContentBody)>
	<cfwddx action="WDDX2CFML" input="#GetContent.ContentBody#" output="sContentBody">
<cfelse>
	<cfset sContentBody=StructNew()>
</cfif>


<cfif StructKeyExists(sContentBody,"aFile") AND IsArray(sContentBody.aFile) AND ArrayLen(sContentBody.aFile) GT 0>
	<cfset aFile=sContentBody.aFile>
	<cfset RandomStart=RandRange(1,ArrayLen(aFile))>
	
	<cfoutput>
		<div id="bottom-prods">
		<div id="feat-prods">
		<h3>Featured Products</h3>
		<cfloop from="1" to="#ArrayLen(aFile)#" index="i">
			<cfset sFile=aFile[i]>
			<cfset thisCaption="">
			<cfset thisName="">
			<cfset thisImage="">
			<cfif StructKeyExists(sFile,"FileName") AND sFile.FileName NEQ "">
				<cfset thisName=sFile.FileName>
			</cfif>
			<cfif StructKeyExists(sFile,"FileCaption") AND sFile.FileCaption NEQ "">
				<cfset thisCaption=sFile.FileCaption>
			</cfif>
			<cfif StructKeyExists(sFile,"FilePath") AND sFile.FilePath NEQ "">
				<cfset thisImage=sFile.FilePath>
			</cfif>
			<div id="feat-prod-#i#" class="feat-prods<cfif i IS RandomStart> on</cfif>">
				<h4>#UCase(thisName)#</h4>
				<p>#thisCaption#</p>
				<img src="#thisImage#" alt="#thisName#"/>
			</div>
		</cfloop>
		
		<ul id="feature-prod-nav">
		<cfloop from="1" to="#ArrayLen(aFile)#" index="i">
			<cfset sFile=aFile[i]>
			<cfif StructKeyExists(sFile,"FileName") AND sFile.FileName NEQ "">
				<cfset thisName=sFile.FileName>
			<cfelse>
				<cfset thisName="">
			</cfif>
			<cfif StructKeyExists(sFile,"LinkURL") AND sFile.LinkURL NEQ "">
				<cfset thisURL=sFile.LinkURL>
			<cfelse>
				<cfset thisURL="">
			</cfif>
			<li<cfif i IS RandomStart> class="on"</cfif>><a href="##feat-prod-#i#" data-id="#thisURL#">#thisName#</a></li>
		</cfloop>
		</ul>
		</div>
		</div>
	</cfoutput>
</cfif>