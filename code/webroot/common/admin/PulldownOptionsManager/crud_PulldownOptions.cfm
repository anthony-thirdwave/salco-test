<!--- crud_MasterListItem.cfm  --->
<cfif not isdefined("attributes.labelGroupId")>
	<cfabort showerror="crud_PulldownOptions.cfm requires attributes.labelId">
<cfelse>
	<cfset labelGroupId = attributes.labelGroupId>
</cfif>

<cfparam name="bSubmit" default="false">
<cfparam name="labelId" default="">
<cfset bEdit = false>
<cfif labelId is not "">
	<cfset bEdit = true>
</cfif>

<!--- ########   FORM PROCESSING   ######## --->
<!--- add or update form params --->
<cfparam name="submit" default="">
<cfparam name="submitText" default="Add">
<cfparam name="LabelID" default="">
<cfparam name="LabelName" default="">
<cfparam name="LabelCode" default="">
<cfparam name="LabelGroupID" default="">

<!--- convert any form variables with dot notation into a struct for the auction object --->
<cfset form = APPLICATION.UtilsObj.formDotNotationToStruct(form) />

<cfif bSubmit>
	<cfif form.LabelGroupID IS "900">
		<cfif LabelName iS NOT "">
			<cfmodule template="/common/modules/utils/validateEmail.cfm" email="#LabelName#">
			<cfif ValidateEmailStatus GTE "200">
				<cfset LabelNAme="">
			</cfif>
		</cfif>
	</cfif>
	<cfif LabelName neq "">
		<!--- Add --->
		<cfif form.labelId is 0>
			<!--- Get the next labelId --->
			<cfquery datasource="#APPLICATION.DSN#" name="getNextID">
				SET NOCOUNT ON
				SELECT	MAX(LabelID) AS xID 
				FROM	t_Label
				SET NOCOUNT OFF
			</cfquery>
			<cfset xLabelID = getNextID.xID+1>
			<!--- Insert --->
			<cfquery name="GetMaxPriority" datasource="#APPLICATION.DSN#">
				SELECT	MAX(LabelPriority) AS p
				FROM	t_Label
				WHERE	LabelGroupID = <cfqueryparam value="#LabelGroupID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset NextPriority=GetMaxPriority.p+10>
			<cfquery datasource="#APPLICATION.DSN#" name="insertLabel">
				INSERT INTO t_Label
					(LabelID, LabelCode, LabelName, LabelGroupID, LabelPriority)
				values
					(
					<cfqueryparam value="#xLabelID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#trim(form.LabelCode)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#trim(form.LabelName)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Val(form.LabelGroupID)#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Val(NextPriority)#" cfsqltype="cf_sql_integer">
					)
			</cfquery>
		<!--- Edit --->	
		<cfelse>
			<cfif structKeyExists(form, "butup") or structKeyExists(form, "butdown")>
				<cfif structKeyExists(form, "butup")>
					<cfquery name="moveup" datasource="#APPLICATION.DSN#">
						UPDATE	t_Label
						SET		LabelPriority = LabelPriority-15,
								LabelName = <cfqueryparam value="#Trim(form.LabelName)#" cfsqltype="cf_sql_varchar">
						WHERE	LabelID = <cfqueryparam value="#Val(form.LabelID)#" cfsqltype="cf_sql_integer">
					</cfquery>
				<cfelseif structKeyExists(form, "butdown")>
					<cfquery name="movedown" datasource="#APPLICATION.DSN#">
						UPDATE	t_Label
						SET		LabelPriority = LabelPriority+15,
								LabelName = <cfqueryparam value="#Trim(form.LabelName)#" cfsqltype="cf_sql_varchar">
						WHERE	LabelID = <cfqueryparam value="#Val(form.LabelID)#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
				<cfquery name="Select" datasource="#APPLICATION.DSN#">
					SELECT		*
					FROM		t_Label
					WHERE		LabelGroupID = <cfqueryparam value="#FORM.labelGroupID#" cfsqltype="cf_sql_integer"> 
					ORDER BY	LabelPriority
				</cfquery>
				<cfoutput query="select">
					<cfset ThisNewPriority=10*CurrentRow>
					<cfquery name="Update" datasource="#APPLICATION.DSN#">
						UPDATE	t_Label
						SET		LabelPriority = <cfqueryparam value="#Val(ThisNewPriority)#" cfsqltype="cf_sql_integer"> 
						WHERE	LabelID = <cfqueryparam value="#LabelID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfoutput>
				<cflocation addtoken="no" url="index.cfm?LabelID=#FORM.LabelID#">
			</cfif>
			<cfquery datasource="#APPLICATION.DSN#" name="updateLabel">
				UPDATE	t_Label
				SET		LabelName = <cfqueryparam value="#Trim(form.LabelName)#" cfsqltype="cf_sql_varchar">
				WHERE	LabelID = <cfqueryparam value="#Val(form.LabelID)#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
	</cfif>
	<cflocation addtoken="no" url="index.cfm">
</cfif>
<cfif IsDefined("URL.dlid")>
	<cftry>
		<cfset DeleteLabelID=Decrypt(URL.dlid,APPLICATION.Key)><cfcatch><cfset DeleteLabelID="-1"></cfcatch>
	</cftry>
	<cfoutput>DeleteLabelID: #DeleteLabelID#</cfoutput>
	<cfif DeleteLabelID GT "0">
		<cfset AllowDelete="no">
		<cfswitch expression="#labelGroupID#">
			<cfcase value="70">
				<cfquery name="TestSpec" datasource="#APPLICATION.DSN#">
					SELECT	*
					FROM	t_JobDepartment
					WHERE	JobDepartmentID = <cfqueryparam value="#val(DeleteLabelID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif TestSpec.RecordCount IS "0">
					<cfset AllowDelete="Yes">
				</cfif>
			</cfcase>
			<cfcase value="80">
				<cfquery name="TestStatus" datasource="#APPLICATION.DSN#">
					SELECT	* 
					FROM	t_job 
					WHERE	JobCategoryID = <cfqueryparam value="#val(DeleteLabelID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif TestStatus.RecordCount IS "0">
					<cfset AllowDelete="Yes">
				</cfif>
			</cfcase>
			<cfcase value="90">
				<cfquery name="TestStatus" datasource="#APPLICATION.DSN#">
					SELECT	*
					FROM	t_job
					WHERE	JobScheduleID = <cfqueryparam value="#val(DeleteLabelID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif TestStatus.RecordCount IS "0">
					<cfset AllowDelete="Yes">
				</cfif>
			</cfcase>
			<cfcase value="900">
				<cfquery name="TestStatus" datasource="#APPLICATION.DSN#">
					SELECT	*
					FROM	t_job
					WHERE	ContactEmailID = <cfqueryparam value="#val(DeleteLabelID)#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif TestStatus.RecordCount IS "0">
					<cfset AllowDelete="Yes">
				</cfif>
			</cfcase>
		</cfswitch>
		<cfif AllowDelete>
			<cfquery name="deleteLabel" datasource="#APPLICATION.DSN#">
				DELETE FROM	t_Label
				WHERE		LabelID = <cfqueryparam value="#val(DeleteLabelID)#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflocation url="index.cfm" addtoken="no">
		</cfif>
	</cfif>
</cfif>


<!--- Get the labelgroup name --->
<cfquery datasource="#APPLICATION.DSN#" name="getLabelGroupName">
	SELECT	TOP 1 LabelName AS labelGroupName, LabelCode AS labelGroupCode
	FROM 	t_Label
	WHERE	LabelID = <cfqueryparam value="#Val(labelGroupID)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Get the labels with labelgroupid --->
<cfquery datasource="#APPLICATION.DSN#" name="getLabels">
	SELECT		LabelName, LabelCode, LabelGroupID, LabelId, LabelPriority
	FROM		t_Label
	WHERE		LabelGroupID = <cfqueryparam value="#Val(labelGroupID)#" cfsqltype="cf_sql_integer">
	ORDER BY	LabelName
</cfquery>

<cfoutput>
	<table cellspacing="0px" cellpadding="3px">
		<tr>
			<td colspan="3"><b>#getLabelGroupName.labelGroupName#</b></td>
		</tr>
		<cfloop from="1" to="#getLabels.recordcount#" index="labelindex">		
			<cfif labelindex mod 2 is 1>
				<cfset bgcolor = "##BAC0C9">
			<cfelse>
				<cfset bgcolor = "##FFFFFF">
			</cfif>
			<cfif labelId is getLabels.LabelId[labelindex]>
				<cfset AllowDelete="No">
				<cfswitch expression="#labelGroupID#">
					<cfcase value="70">
						<cfquery name="TestSpec" datasource="#APPLICATION.DSN#">
							SELECT	*
							FROM	t_JobDepartment
							WHERE	JobDepartmentID = <cfqueryparam value="#val(labelId)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif TestSpec.RecordCount IS "0">
							<cfset AllowDelete="Yes">
						</cfif>
					</cfcase>
					<cfcase value="80">
						<cfquery name="TestStatus" datasource="#APPLICATION.DSN#">
							SELECT	*
							FROM	t_job
							WHERE	JobCategoryID = <cfqueryparam value="#val(labelId)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif TestStatus.RecordCount IS "0">
							<cfset AllowDelete="Yes">
						</cfif>
					</cfcase>
					<cfcase value="90">
						<cfquery name="TestStatus" datasource="#APPLICATION.DSN#">
							SELECT	*
							FROM	t_job
							WHERE	JobScheduleID = <cfqueryparam value="#val(labelId)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif TestStatus.RecordCount IS "0">
							<cfset AllowDelete="Yes">
						</cfif>
					</cfcase>
					<cfcase value="900">
						<cfquery name="TestStatus" datasource="#APPLICATION.DSN#">
							SELECT	*
							FROM	t_job
							WHERE	ContactEmailID = <cfqueryparam value="#val(labelId)#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif TestStatus.RecordCount IS "0">
							<cfset AllowDelete="Yes">
						</cfif>
					</cfcase>
				</cfswitch>
				<form method="post" action="index.cfm" name="edit#labelGroupId#">
					<input type="hidden" name="bSubmit" value="true">
					<input type="hidden" name="labelGroupId" value="#labelGroupId#">
					<input type="hidden" name="labelCode" value="#getLabelGroupName.labelGroupCode#">
					<input type="hidden" name="labelId" value="#labelId#">
					<tr bgcolor="#bgcolor#">
						<td>
							<input type="text" size="24" maxlength="128" name="labelName" value="#htmleditformat(getLabels.LabelName[labelindex])#">
						</td>
						<td><cfif 0><cfif labelindex IS NOT "1"><input type="submit" name="butup" value="Move Up"></cfif><BR>
						<cfif labelindex IS NOT getLabels.recordcount><input type="submit" name="butdown" value="Move Down"></cfif></cfif>
						</TD><TD nowrap>
						<cfif ATTRIBUTES.AllowEdit>
							<input type="image" src="/common/images/admin/icon_edit.gif" name="butSub" value="Edit">
						</cfif>
						<cfif AllowDelete>
							<input type="button" value="Delete" onclick="window.location='index.cfm?dlid=#URLencodedFOrmat(Encrypt(LabelID,APPLICATION.Key))#&labelGroupID=#LabelGroupID#'">
						</cfif>
						</td>
					</tr>
				</form>
			<cfelse>
				<tr bgcolor="#bgcolor#">
					<td>
						#getLabels.LabelName[labelindex]# <cfif Right(getLabels.LabelCode[labelindex],2) IS "_S" AND getLabels.LabelGroupID[labelindex] IS "10">(System)</cfif>
					</td><TD>&nbsp;</TD>
					<td>
					<cfif (Right(getLabels.LabelCode[labelindex],2) IS "_S" AND getLabels.LabelGroupID[labelindex] IS "10")>
						<cfset bThisEdit="No">
					<cfelse>
						<cfif bEdit OR NOT ATTRIBUTES.AllowEdit>&nbsp;
						<Cfelse>
							<a href="index.cfm?labelId=#getLabels.LabelId[labelindex]#"><img border="0" src="/common/images/admin/icon_edit.gif"></a>
						</cfif>
					</cfif>
					</td>
				</tr>
			</cfif>			
		</cfloop>
		
		<!--- Add field --->
		<cfif bEdit OR NOT ATTRIBUTES.AllowEdit>
		<Cfelse>
			<form method="post" action="index.cfm" name="add#labelGroupId#">
				<input type="hidden" name="bSubmit" value="true">
				<input type="hidden" name="labelGroupId" value="#labelGroupId#">
				<input type="hidden" name="labelCode" value="#getLabelGroupName.labelGroupCode#">
				<input type="hidden" name="labelId" value="0">
				<tr>
					<td><input type="text" size="24" maxlength="128" name="labelName"></td><TD></TD>
					<td><input type="image" src="/common/images/admin/button_add.png" value="Add"></td>
				</tr>
			</form>
		</cfif>
	</table>
</cfoutput>