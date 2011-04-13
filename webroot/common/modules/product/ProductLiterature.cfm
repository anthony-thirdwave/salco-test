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

<cfset lTab="ProductLiterature,Presentations,Charts,Brochures">
<cfset sTabName=StructNew()>
<cfset StructInsert(sTabName,"ProductLiterature","Product Literature")>
<cfset StructInsert(sTabName,"Presentations","Presentations")>
<cfset StructInsert(sTabName,"Charts","Charts")>
<cfset StructInsert(sTabName,"Brochures","Brochures")>


<ul id="tabsDownloads" class="nav">
	<cfloop index="ThisTab" list="#ListFirst(lTab)#">
		<cfoutput><li><a href="?ActiveTab=#ThisTab#" <cfif ThisTab IS ActiveTab>class="tabActive"</cfif>>#sTabName[ThisTab]#</a></li></cfoutput>
	</cfloop>
</ul>


<cfswitch expression="#ActiveTab#">
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