<cfparam name="ATTRIBUTES.FormAction" default="#CGI.SCRIPT_NAME#?#CGI.Query_string#">
<cfparam name="ATTRIBUTES.ObjectAction" default="List">
<cfparam name="ATTRIBUTES.sCurrentCategoryPermissions">

<cfset FormPage=ListFirst(ATTRIBUTES.FormAction,"?")>
<cfset FormQueryString=ListLast(ATTRIBUTES.FormAction,"?")>

<cfparam name="HighlightID" default="-1">
<cfif IsDefined("URL.hlid")>
	<cftry><cfset HighlightID=Decrypt(URL.hlid,APPLICATION.Key)><cfcatch><cfset HighlightID="-1"></cfcatch></cftry>
</cfif>

<cfif Isdefined("URL.mvca")>
	<cfswitch expression="#URL.mvca#">
		<cfcase value="2">
			<cfset ATTRIBUTES.ObjectAction="UpdatePriorities">
		</cfcase>
	</cfswitch>
</cfif>
<cfif ATTRIBUTES.ObjectAction IS "UpdatePriorities">
	<cftransaction>
		<cfloop index="i" from="1" to="#NumItems#" step="1">
			<cftry>
				<cfset ThisCategoryID=Decrypt(URLDecode(Evaluate("EditCategoryid#i#")),APPLICATION.Key)>
				<cfcatch>
					<cfset ThisCategoryID="-1">
				</cfcatch>
			</cftry>
			<cfif ThisCategoryID GT "0">
				<cfif IsDefined("EditShowCategory#i#")>
					<cfset EditShowCategory="1">
				<cfelse>
					<cfset EditShowCategory="0">
				</cfif>
				<cfquery name="UpdateShowCategory" datasource="#Application.DSN#">
					UPDATE	t_Category
					SET		CategoryActive = <cfqueryparam value="#EditShowCategory#" cfsqltype="cf_sql_bit">,
							CacheDateTime = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> 
					WHERE	Categoryid = <cfqueryparam value="#val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		</cfloop>
		<cfloop index="j" from="1" to="#ListLen(lCategoryID)#" step="1">
			<cfset ThisCategoryID=ListGetAt(lCategoryID,j)>
			<cfif SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>
				<cfquery name="moveup" datasource="#Application.DSN#">
					UPDATE	t_Category
					SET		CategoryPriority = <cfqueryparam value="#j*10#" cfsqltype="cf_sql_integer"> 
					WHERE	CategoryID = <cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
			<cfquery name="moveup" datasource="#Application.DSN#">
				UPDATE	t_CategoryLocaleMeta
				SET		CategoryLocalePriority = <cfqueryparam value="#j*10#" cfsqltype="cf_sql_integer">
				WHERE	CategoryID = <cfqueryparam value="#Val(ThisCategoryID)#" cfsqltype="cf_sql_integer">
				AND		LocaleID = <cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfloop>
		<cfif SESSION.AdminCurrentAdminLocaleID IS APPLICATION.DefaultLocaleID>
			<cfinvoke component="com.ContentManager.CategoryHandler" method="GenerateDisplayOrderString" 
				returnVariable="Success"
				SourceParentID="#Val(ATTRIBUTES.CurrentCategoryID)#"
				datasource="#APPLICATION.DSN#">
		</cfif>
		<cfinvoke component="com.ContentManager.CategoryLocaleHandler" method="GenerateDisplayOrderString" 
			returnVariable="Success"
			SourceParentID="#Val(ATTRIBUTES.CurrentCategoryID)#"
			LocaleID="#Val(SESSION.AdminCurrentAdminLocaleID)#"
			datasource="#APPLICATION.DSN#">
	</cftransaction>
	<cf_AddToQueryString queryString="#FormQueryString#" OmitList="mvca">
	<cflocation url="#FormPage#?#QueryString#" addToken="no">
<cfelse>
	<cfquery name="GetCategoryList" datasource="#Application.DSN#">
		SELECT		*
		FROM		qry_GetCategoryMeta 
		WHERE		ParentID = <cfqueryparam value="#Val(ATTRIBUTES.CurrentCategoryID)#" cfsqltype="cf_sql_integer">
		AND			LocaleID = <cfqueryparam value="#Val(SESSION.AdminCurrentAdminLocaleID)#" cfsqltype="cf_sql_integer">
		ORDER BY	CategoryLocalePriority
	</cfquery>
	<table width="100%" border="0" cellpadding="3">
	<cf_AddToQueryString queryString="#FormQueryString#" Name="mvca" value="2">
	<cfoutput><form action="#FormPage#?#QueryString#" method="post" name="subpageForm" id="subpageForm"></cfoutput>
	<cfset Counter="1">
	<TR>
	<td bgcolor="BAC0C9" width="20"><b>Active</b></TD>
	<TD bgcolor="BAC0C9" width="600"><b>Title</b></TD>
	<TD bgcolor="BAC0C9" width="1">
	<cfif ATTRIBUTES.sCurrentCategoryPermissions["pCreate"]>
	<cfoutput><a href="/common/admin/MasterView/CategoryModify.cfm?PageAction=add&lid=#URLEncodedFormat(Encrypt(SESSION.AdminCurrentAdminLocaleID,APPLICATION.Key))#&pid=#URLEncodedFormat(Encrypt(ATTRIBUTES.CurrentCategoryID,APPLICATION.Key))#"><b>Add</b></a>
	</cfoutput></cfif></TD>
	</TR>
	<cfif GetCategoryList.RecordCount IS NOT "0">
		<style type="text/css">
		#categoryList {
		  margin:0;
		  margin-top:10px;
		  padding:0;
		  list-style-type: none;
		  width:660px;
		}
		#categoryList li {
		  margin:0;
		  margin-bottom:4px;
		  padding:3px;
		  cursor:move;
		  background-color:#EAEAEA;
		}
		.clearit{
			display:block;/**/
			visibility:hidden;
			clear:both;
			width:1px;
			height:1px;
			overflow:hidden;
		}
		</style>

		<cfset CategoryList="">
		<cfoutput query="GetCategoryList">
			<cfsavecontent variable="ThisLI">
			<li id="#CategoryID#">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<input type="hidden" name="EditCategoryID#CurrentRow#" 
								value="#URLEncodedFormat(Encrypt(Categoryid,APPLICATION.Key))#">
							<input type="checkbox" name="EditShowCategory#CurrentRow#" 
								value="1" <cfif CategoryActive>checked</cfif>>
							#CategoryName# (#CategoryAlias#)
						</td>
						<td align="right">
							<a href="#APPLICATION.utilsObj.parseCategoryUrl(CategoryAlias)#" target="_blank" title="Preview in new window"><img src="/common/images/admin/icon_magnify.gif" border="0"></a>
							
							<cfset Location="/common/admin/MasterView/CategoryModify.cfm">
							<cfset querystring="">
							<cfset cid=encrypt(CategoryID,APPLICATION.KEY)>
							<cfif ATTRIBUTES.sCurrentCategoryPermissions["pEdit"]>
								<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
								<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="Edit">
								<a href="#Location#?#querystring#"><img src="/common/images/admin/icon_edit.gif" border="0"></A>
							</cfif>
							<cfif ATTRIBUTES.sCurrentCategoryPermissions["pDelete"]>
								<cf_AddToQueryString querystring="#QueryString#" name="cid" value="#cid#">
								<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="validatedelete">
								<a href="#Location#?#querystring#"><img src="/common/images/admin/icon_delete.gif" border="0"></a>
							</cfif>
						</td>
					</tr>
				</table>
			</li>
			</cfsavecontent>
			<cfset CategoryList = CategoryList & "#ThisLI#">
		</cfoutput>
		<tr><TD colspan="3">
		<ul id="categoryList"><cfoutput>#Trim(categoryList)#</cfoutput></ul>
		</TD></TR>
		<script src="/common/scripts/categorySelector.js" type="text/javascript"></script>
		<script type="text/javascript">
			document.getElementById('subpageForm').onsubmit = function (e) {setResults();return true;};
			function setResults(){
				document.getElementById('lCategoryID').value = getResults();
			} 
			<cfif categoryList NEQ "">
				// Sortable.create('categoryList',{ghosting:true,handle:'handle',constraint:false});
				Sortable.create("categoryList", {onUpdate:function(){new Ajax.Updater('list-info', '/ajax/order', {asynchronous:true, evalScripts:true, onComplete:function(request){new Effect.Highlight("list",{});}, parameters:Sortable.serialize("list")})}})
			</cfif>
		</script>
		<input type="hidden" name="lCategoryID" id="lCategoryID" />
		
		<cfif ATTRIBUTES.sCurrentCategoryPermissions["pEdit"]>
			<cfoutput>
				<input type="hidden" name="NumItems" value="#GetCategoryList.RecordCount#">
				<TR>
				<td colspan="3" align="right" bgcolor="##FFFFFF">
				<input type="image" src="/common/images/admin/button_update.png" name="ButtonSubmit2" border="0" tabindex="#Counter#">
				</td></form>
				<TD>&nbsp;</TD></tr>
			</cfoutput>
		</cfif>
	<cfelse>
		<TR><TD colspan="6" bgcolor="EAEAEA">No sub-categories at this level.</TD></TR>
	</cfif>
	</table>
</cfif>
<div id="debuggingfordraganddrop"></div>