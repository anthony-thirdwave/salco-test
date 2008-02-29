<cfset thisMode = "view">
<cfif ListFind(SESSION.AdminUsergroupidlist,4)>
	<cfset thisMode = "edit">
</cfif>
<cfif thisMode EQ "edit">

	<script language="javascript" type="text/javascript">
		function editMsg(bulletinID){
			document.getElementById("bulletinMessageBox").value = document.getElementById("message_" + bulletinID).innerHTML;
			document.getElementById("bulletinID").value = bulletinID;
			document.getElementById("bulletinSubmitButton").value = "Edit Bulletin";
			document.getElementById("bulletinCancelButton").style.display = "block";
		}
		
		function deleteMsg(bulletinID){
			if(confirm('Are you sure you want to permanently delete this bulletin?')){
				document.getElementById("bulletinID").value = bulletinID;
				document.getElementById("isDelete").value = 1;
				document.getElementById("bulletinForm").submit();
			}
		}
		
		function cancelMsg(){
			document.getElementById("bulletinMessageBox").value = "";
			document.getElementById("bulletinID").value = "";
			document.getElementById("bulletinSubmitButton").value = "Post Bulletin";
			document.getElementById("bulletinCancelButton").style.display = "none";
		}
		
		function valBulletin(){
			if(document.getElementById("isDelete").value == "0" && document.getElementById("bulletinMessageBox").value == ""){
				alert("Please enter a message.");
				return false;
			}
		}
	</script>


	<cfoutput>
	Post a bulletin to the dashboards on other accounts.<br>
	
	<div class="RuleSolid1"></div>
	<form action="/common/modules/Admin/Bulletin/action.cfm" method="post" id="bulletinForm" onSubmit="return valBulletin();">
		<input type="hidden" name="returnURL" value="#CGI.REQUEST_URI#<cfif CGI.QUERY_STRING NEQ "">?#CGI.QUERY_STRING#</cfif>">
		<input type="hidden" name="bulletinID" value="" id="bulletinID">
		<input type="hidden" name="isDelete" value="0" id="isDelete">
		Enter a message:<br/>
		<textarea name="message" cols="37" rows="3" id="bulletinMessageBox"></textarea>
		<br/><br/>
		<input type="image" src="/common/images/admin/button_post.gif" name="submitButton" value="Post Bulletin" id="bulletinSubmitButton">
		<div id="bulletinCancelButton" style="display:none; padding-top:2px;"><a href="javascript:cancelMsg();"><img src="/common/images/admin/button_cancel_small.gif" border="0"/></a></div>
	</form>
	</cfoutput>
</cfif>
<div class="RuleDotted1"></div>

	<strong>CURRENT BULLETINS</strong>
	<div class="RuleSolid1"></div>
	<cfquery name="getBulletins" datasource="#APPLICATION.DSN#">
		SELECT * FROM t_Bulletin
		ORDER BY PostDate DESC
	</cfquery>
	<cfif getBulletins.RecordCount GT 0>
		<table border="0" cellpadding="0" cellspacing="0">
		<cfoutput query="getBulletins">
				<tr>
					<td style="font-size:11px;" width="80%" valign="top">#Replace(Message,"#Chr(13)##Chr(10)#","<br/>","all")#<div id="message_#bulletinID#" style="display:none; ">#Message#</div></td>
					<td style="font-size:10px; " valign="top">
						<span style="color:red;">#DateFormat(PostDate,'mm/dd/yyyy')#</span><br>
						<cfif thisMode EQ "edit">
							<a href="javascript:editMsg(#bulletinID#);"><img src="/common/images/admin/icon_edit.gif" border="0"/></a>&nbsp;
							<a href="javascript:deleteMsg(#bulletinID#);"><img src="/common/images/admin/icon_delete.gif" border="0"/></a>
						</Cfif>
					</td>
				</tr>	
				<cfif CurrentRow NEQ getBulletins.RecordCount>
				<tr><td colspan="2"><div class="RuleDotted1"></div></td></tr>
				</cfif>
		</cfoutput>
		</table>
	<cfelse>
		There are no current bulletins.
	</cfif>