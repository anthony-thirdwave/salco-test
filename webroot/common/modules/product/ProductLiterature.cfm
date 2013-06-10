<cfparam name="ATTRIBUTES.FormAction" default="#CGI.REQUEST_URI#?#CGI.Query_String#">
<cfparam name="ActiveTab" default="ProductLiterature">
<cfparam name="ParamTopProductFamilyAlias" default="">

<cfset FormPath=GetToken(ATTRIBUTES.FormAction,1,"?")>
<cfset FormQueryString=GetToken(ATTRIBUTES.FormAction,2,"?")>

<cfif NOT IsDefined("StartRow")>
	<CFSET StartRow=1>
</cfif>
<cfif Val(StartRow) LTE "0">
	<CFSET StartRow=1>
</cfif>
<cfset SearchNUM="20">

<cfset lTab="ProductLiterature,Charts,Presentations,Instructions,E-Catalog">
<cfset sTabName=StructNew()>
<cfset StructInsert(sTabName,"ProductLiterature","Product Literature")>
<cfset StructInsert(sTabName,"Charts","Charts")>
<cfset StructInsert(sTabName,"Presentations","Presentations")>
<cfset StructInsert(sTabName,"Instructions","Instructions")>
<cfset StructInsert(sTabName,"E-Catalog","E-Catalog")>

<ul id="tabsDownloads" class="nav">
	<cfloop index="ThisTab" list="#lTab#">
		<cfoutput><li><a href="?ActiveTab=#ThisTab#" <cfif ThisTab IS ActiveTab>class="tabActive"</cfif>>#sTabName[ThisTab]#</a></li></cfoutput>
	</cfloop>
</ul>

<cffunction name="AddFile" output="false" returntype="query">
	<cfargument name="qSourceRow" type="query" required="true">
	<cfargument name="qDir" type="query" required="true">
	<cfargument name="rootDirectory" type="String" required="true">
	
	<cfset LOCAL=StructNew()>
	
	<cfif ListLast(ARGUMENTS.qSourceRow.Name,".") IS "pdf">
		<cfset QueryAddRow(ARGUMENTS.qDir)>
		
		<cfloop index="ThisCol" list="#ARGUMENTS.qSourceRow.ColumnList#">
			<cfset QuerySetCell(ARGUMENTS.qDir,ThisCol,ARGUMENTS.qSourceRow[ThisCol][1])>
		</cfloop>
		
		<cfif FindNoCase("spanish",ARGUMENTS.qSourceRow.Name)>
			<cfset QuerySetCell(ARGUMENTS.qDir,"Language","Spanish")>
		<cfelse>
			<cfset QuerySetCell(ARGUMENTS.qDir,"Language","English")>
		</cfif>
		
		<cfset LOCAL.ThisTitle=ARGUMENTS.qSourceRow.Name>
		<cfset LOCAL.ThisTitle=ListDeleteAt(ARGUMENTS.qSourceRow.Name,ListLen(ARGUMENTS.qSourceRow.Name,"."),".")>
		<cfset QuerySetCell(ARGUMENTS.qDir,"Title",LOCAL.ThisTitle)>
		<cfset QuerySetCell(ARGUMENTS.qDir,"Description","")>
		
		<cfset LOCAL.BaseName=ReplaceNoCase(LOCAL.ThisTitle,"_spanish","","all")>
		<cfset QuerySetCell(ARGUMENTS.qDir,"BaseName",LOCAL.BaseName)>
		
		<cfset LOCAL.ThisDirectory=ListLast(ARGUMENTS.qSourceRow.Directory,"\")>
		<cfset QuerySetCell(ARGUMENTS.qDir,"Folder",LOCAL.ThisDirectory)>
		<cfset QuerySetCell(ARGUMENTS.qDir,"URL","/resources/external/downloads/#LOCAL.ThisDirectory#/#ARGUMENTS.qSourceRow.Name#")>
		
		<cfif FileExists("#ARGUMENTS.qSourceRow.Directory#/#ARGUMENTS.qSourceRow.Name#") and ListLast(ARGUMENTS.qSourceRow.Name,".") IS "pdf">
			<cfpdf action="getInfo" name="LOCAL.sInfo" source="#ARGUMENTS.qSourceRow.Directory#/#ARGUMENTS.qSourceRow.Name#">
			<cfif LOCAL.sInfo.Title IS NOT "">
				<cfset QuerySetCell(ARGUMENTS.qDir,"Title",LOCAL.sInfo.Title)>
			</cfif>
			<cfif LOCAL.sInfo.Subject IS NOT "">
				<cfset QuerySetCell(ARGUMENTS.qDir,"Description",LOCAL.sInfo.Subject)>
			</cfif>
		</cfif>
	</cfif>
		
	<cfreturn ARGUMENTS.qDir>
</cffunction>

<cfswitch expression="#ActiveTab#">
	<cfcase value="ProductLiterature,Charts,Presentations,Instructions">
		<cfset DirectoryToRead=ExpandPath("/resources/external/downloads/#ActiveTab#")>
		<cfdirectory action="LIST" directory="#DirectoryToRead#" name="qDirPrime">
		<cfset qDir=QueryNew("#qDirPrime.ColumnList#,Language,Folder,URL,Title,Description,BaseName")>
		<cfloop query="qDirPrime">
			<cfif qDirPrime.type IS "dir">
				<cfdirectory action="LIST" directory="#DirectoryToRead#\#Name#" name="qDirPrime2">
				<cfoutput query="qDirPrime2">
					<cfif qDirPrime2.type IS "file">
						<cfset qRow=QueryNew(qDirPrime2.ColumnList)>
						<cfset QueryAddRow(qRow)>
						<cfloop index="ThisCol" list="#qDirPrime2.ColumnList#">
							<cfset QuerySetCell(qRow,ThisCol,qDirPrime2[ThisCol][qDirPrime2.currentrow])>
						</cfloop>
						<cfset qDir=AddFile(qRow,qDir,DirectoryToRead)>
					</cfif>
				</cfoutput>
			<cfelseif qDirPrime.type IS "file">
				<cfset qRow=QueryNew(qDirPrime.ColumnList)>
				<cfset QueryAddRow(qRow)>
				<cfloop index="ThisCol" list="#qDirPrime.ColumnList#">
					<cfset QuerySetCell(qRow,ThisCol,qDirPrime[ThisCol][qDirPrime.currentrow])>
				</cfloop>
				<cfset qDir=AddFile(qRow,qDir,DirectoryToRead)>
			</cfif>
		</cfloop>
		
		<cfquery name="qDir" dbtype="query">
			select * from qDir order by Folder, Title, BaseName, [Language]
		</cfquery>
		
		<cfif qDir.RecordCount GT "0">
			<div class="downloadContent" id="downloadContent1">
				<table class="featuredDownloads" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <thead>
                    <tr>
						<th align="left">Name</th>
						<th>Description</th>
						<th>Available Languages</th>
					</tr>
                    </thead>
					<tbody>
					<cfoutput query="qDir" group="Folder">
						<cfoutput group="BaseName">
							<cfset class="">
							<cfset classTR="">
							<cfif CurrentRow MOD 2 IS "0">
								<cfset class="grayCol">
								<cfset classTR="odd">
							</cfif>
							<tr class="#classTR#">
								<td valign="top" class="#class#">#Title#</td>
								<td valign="top" class="#class#">#Description#</td>
								<td valign="top" class="#class#" nowrap>
									<cfoutput group="Language">
										<a href="#URL#" target="_blank">#Language# #Round(Size/1024)#kb</a>
									</cfoutput>
								</td>
							</tr>
						</cfoutput>
					</cfoutput>
                    </tbody>
				</table>
			</div>
		</cfif>
	</cfcase>
	<cfcase value="E-Catalog">
		<cfset DirectoryToRead=ExpandPath("/resources/external/downloads/#ActiveTab#")>
		<cfdirectory action="LIST" directory="#DirectoryToRead#" name="qDirPrime">
		<cfset lLinks="">
		<cfloop query="qDirPrime">
			<cfif qDirPrime.type IS "dir" and FileExists("#DirectoryToRead#\#qDirPrime.Name#\index.html")>
				<cfset lLinks=ListAppend(lLinks,"#qDirPrime.Name#:/resources/external/downloads/#ActiveTab#/#qDirPrime.Name#/index.html")>
			</cfif>
		</cfloop>
		
		
		<cfif lLinks IS NOT "">
			<div class="downloadContent" id="downloadContent1">
				<table class="featuredDownloads" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <thead>
                    <tr>
						<th align="left">Catalog</th>
						<th></th>
						<th></th>
					</tr>
                    </thead>
					<tbody>
					<cfset CurrentRow="1">
					<cfloop index="ThisLink" list="#lLinks#">
						<cfset class="">
						<cfset classTR="">
						<cfif CurrentRow MOD 2 IS "0">
							<cfset class="grayCol">
							<cfset classTR="odd">
						</cfif>
						<cfoutput>
						<tr class="#classTR#">
							<td valign="top" class="#class#"><a href="#ListLast(ThisLink,":")#" target="_blank">#ListFirst(ThisLink,":")#</a></td>
							<td valign="top" class="#class#"></td>
							<td valign="top" class="#class#" nowrap><a href="#ListLast(ThisLink,":")#" target="_blank">View</a></td>
						</tr>
						</cfoutput>
						<cfset CurrentRow=CurrentRow+1>
					</cfloop>
                    </tbody>
				</table>
			</div>
		</cfif>
	</cfcase>
	<cfdefaultcase>
		<cfinvoke component="/com/product/producthandler" 
			method="GetPublicDrawing" 
			returnVariable="qGetPublicDrawing"
			TopProductFamilyAlias="#ParamTopProductFamilyAlias#">
		
		<cfif qGetPublicDrawing.RecordCount GT "0">
			<cfinvoke component="/com/product/producthandler" 
				method="GetTopProductFamily" 
				returnVariable="qGetTopProductFamily">
			<div class="downloadContent" id="downloadContent1">
				<table class="featuredDownloads" width="100%" border="0" cellspacing="0" cellpadding="0">
					<thead>
                    <tr>
						<th align="left">Product</th>
						<th>Part No</th>
						<th>File</th>
						<form action="#" method="post"><th>
						<select name="ParamTopProductFamilyAlias" onchange="this.form.submit()">
							<option value="">All</option>
							<cfoutput query="qGetTopProductFamily">
								<option value="#CategoryAlias#" <cfif ParamTopProductFamilyAlias IS CategoryAlias>selected</cfif>>#CategoryName#</option>
							</cfoutput>
						</select>
						</th></form>
					</tr>
                    </thead>
                    <tbody>
					<cfoutput query="qGetPublicDrawing" MAXROWS="#SearchNUM#" STARTROW="#StartRow#">
						<cfset class="">
						<cfset classTR="">
						<cfif CurrentRow MOD 2 IS "0">
							<cfset class="grayCol">
							<cfset classTR="odd">
						</cfif>
						<tr class="#classTR#">
							<td valign="top" class="#class#">#ProductName#</td>
							<td valign="top" class="#class#">#PartNumber#</td>
							<td valign="top" class="#class#" nowrap><a href="#APPLICATION.utilsObj.GetFreewheelLink(PublicDrawing)#" target="_blank">#ucase(ListLast(PublicDrawing,"."))# #Round(PublicDrawingSize/1024)#kb</a></td>
							<td valign="top" class="#class#">#TopProductFamilyName#</td>
						</tr>
					</cfoutput>
                    </tbody>
				</table>
				
				<cf_AddToQueryString QueryString="#FormQueryString#" name="ParamTopProductFamilyAlias" value="#ParamTopProductFamilyAlias#" OmitList="SearchNum,StartRow">
				<cfmodule template="/common/modules/utils/pagination.cfm"
					StartRow="#StartRow#" SearchNum="#SearchNum#"
					RecordCount="#qGetPublicDrawing.RecordCount#"
					FieldList="#QueryString#"
					Label="Search Results"
					Path="#FormPath#">
			</div>
		</cfif>
	</cfdefaultcase>
</cfswitch>