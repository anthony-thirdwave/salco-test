<cfmodule template="/common/modules/admin/dsp_AdminHeader.cfm" 
	PageTitle="Master View"
	PageHeader="<a href=""/common/admin/"" class=""white"">Main Menu</A> | Master View Search">
<cfinclude template="/common/admin/MasterView/_InitMasterView.cfm">


<cfset lid=Encrypt(SESSION.AdminCurrentAdminLocaleID,APPLICATION.Key)>
<table width="780" cellpadding="2" cellspacing="0" border="0">
 <tr valign="top"><cfoutput><form action="#MVPage#?#MVQueryString#" method="post"></cfoutput>
    <TD nowrap bgcolor="white" style="border-top:2px solid silver; border-left:2px solid silver; border-right:2px solid silver;">
		<cfif qLocale.RecordCount IS "1">
			<cfoutput query="qLocale"><strong>Locale: #LocaleName#</strong></cfoutput>
		<cfelse>
			<select name="NewAdminLocaleID">
		  	<cfoutput query="qLocale">
				<option value="#LocaleID#" <cfif SESSION.AdminCurrentAdminLocaleID IS LocaleID>selected</cfif>>#LocaleName#</option>
			</cfoutput>
	      </select>
	      <input class="button" name="submit" type="image" src="/common/images/admin/button_switchlocale.png" value="Switch Locale">
		</cfif>
   </TD> </form>
	<cfoutput>
    <TD bgcolor="white" style="border-bottom:2px solid silver;"><form action="#MVSearch#?#MVQueryString#" method="get">
      <div align="right">
        <input type="text" name="MVSearchTerms" value="#MVSearchTerms#">
        <input type="submit" value="Search">
      </div>
    </TD></form></cfoutput>
  </TR>
<tr valign="top">
<TD width="250" bgcolor="white" style="border-left:2px solid silver; border-bottom:2px solid silver;">

<cfinclude template="/common/modules/admin/masterview/dsp_Nav.cfm">
</TD><TD width="530" style="border-bottom:2px solid silver; border-right:2px solid silver;">

<table width="100%" border="0" cellpadding="3" bgcolor="white">
<TR><TD bgcolor="bac0c9" colspan="2"><b>Search Results</b></TD></TR>

<cfif Trim(MVSearchTerms) IS "">
	<TR><TD valign="center" colspan="2"><p>Please enter your search terms.</p></TD></TR>
<cfelse>
	<CFSEARCH NAME="ContentSearch"
	    COLLECTION="#APPLICATION.CollectionName##SESSION.AdminCurrentAdminLocaleID#"
	    TYPE="Simple"
	    CRITERIA="#MVSearchTerms#">
	<cfif ContentSearch.RecordCount IS "0">
		<TR><TD valign="center" colspan="2"><cfoutput><p>No results found for "#MVSearchTerms#"</p></cfoutput></TD></TR>
	<cfelse>
		<!--- Dump all categories into a structure  --->
		<cfquery name="GetAllCategory" datasource="#APPLICATION.DSN#">
			SELECT CategoryID, CategoryName FROM t_Category
		</cfquery>
		<cfset sCategory=StructNew()>
		<cfoutput query="GetAllCategory">
			<cfset Devnull=StructInsert(sCategory,"#CategoryID#","#CategoryName#","1")>
		</cfoutput><br>
		
		<TR><TD bgcolor="bac0c9" colspan="2"><b><cfoutput><p>#ContentSearch.RecordCount# records match "#MVSearchTerms#"</p></cfoutput></TD></TR>
		<cfoutput query="ContentSearch">
			<cf_AddToQueryString querystring="#MVQueryString#" name="MVCid" value="#Key#" OmitList="MVMode">
			<TR bgcolor="EAEAEA" valign="top"><TD><strong>#CurrentRow#</strong></TD><TD><a href="#MVIndex#?#QueryString#">#Title#</A> (#Round(DecimalFormat(Val(Score)*100))#%)<BR>
				<cfmodule template="/common/modules/Utils/TruncateText.cfm" Input="#REReplace(Custom1, '<[^>]*>','','All')#" NumChars="300">
			
			<cfif NOT IsDefined("IDListOf#Key#")>
				<cfmodule Template="/common/modules/utils/GetBranchFromRoot.cfm" ThisCategoryID="#Key#" NameList="" IDList="#Key#">
				<cfset DevNull=SetVariable("IDListOf#Key#","#IDList#")>
			</cfif>
			<cfset lURL="">
			<cfloop index="x" list="#ListRest(Evaluate('IDListOf#Key#'))#">
				<cfif StructKeyExists(sCategory,"#x#") and x is not ListLast(Evaluate("IDListOf#Key#"))>
					<!--- Build the list right to left without disturbing the rest of the logic  --->
					<cf_AddToQueryString querystring="#MVQueryString#" name="MVCid" value="#Key#" OmitList="MVMode">
					<cfset lURL=ListPrepend(lUrl,"<a href=""#MVIndex#?#QueryString#"">#sCategory['#x#']#</A>","|")>
				</cfif>
			</cfloop><br>
			#ReplaceNoCase(lURL,"|"," &lt;&lt; ","All")#</TD></TR>
		</cfoutput>
		</table>
	</cfif>
</cfif>
</TD></TR></table>

<cfinclude template="/common/modules/admin/dsp_AdminFooter.cfm">