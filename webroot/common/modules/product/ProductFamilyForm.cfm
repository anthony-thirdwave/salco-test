<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="ProductFamilyBrochurePathOverride" default="0">

<cfparam name="FormMode" default="ShowForm">
<!--- Determine Domains --->
<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qLanguages">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="labelGroupID">
	<cfinvokeargument name="FieldValue" value="60">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>

<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qAttributeType">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="labelGroupID">
	<cfinvokeargument name="FieldValue" value="110">
	<cfinvokeargument name="SortFieldName" value="LabelPriority">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>

<cfinvoke component="/com/utils/database" method="GenericLookup" returnVariable="qSpecificationType">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="labelGroupID">
	<cfinvokeargument name="FieldValue" value="8000">
	<cfinvokeargument name="SortFieldName" value="LabelPriority">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>

<cfinvoke component="/com/Product/ProductFamilyHandler" 
	method="GetProductFamilyLanguages"
	returnVariable="qProductLanguages"
	CategoryID="#MyProductFamily.GetProperty('CategoryID')#">

<cfif SESSION.AdminUserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID>
	<cfset ShowAdmin="1">
<cfelse>
	<cfset ShowAdmin="0">
</cfif>

<cfif OpenAndCloseFormTables><table width="100%"></cfif>

<TR><TD colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0"><TR><TD></TD>

<TD align="right">
</TD></TR></table></TD></TR>
<cfif FormLanguageID IS NOT APPLICATION.DefaultLanguageID and qProductLanguages.RecordCount GTE "1">
	<TR><TD colspan="3" align="right">Load Product Family Data From: 
	<select name="plclid">
		<option value="-1">Select...</option>
		<cfoutput query="qProductLanguages">
			<cfif FormLanguageID IS NOT LanguageID>
				<option value="#REQUEST.SimpleEncrypt(LanguageID)#">#LanguageName#</option>
			</cfif>
		</cfoutput>
	</select> <!--- <input type="submit" name="ButLoad2" value="Load"> --->
	<input type="submit" name="ButLoad" value="Load"></TD></TR>
</cfif>


<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
	ObjectAction="#FormMode#"
	type="textarea"
	caption="Product Family Description" 
	ObjectName="MyProductFamily"
	PropertyName="ProductFamilyDescription"
	cols="60" rows="6"
	EscapeCRLF="No"
	Required="N">
	

<cfset sImageName=StructNew()>
<cfset StructInsert(sImageName,"ProductFamilyBrochurePath","Family Brochure File",1)>

<cfloop index="ThisImage" list="">
	<cfparam name="Delete#ThisImage#" default="0">
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="File"
		caption="#sImageName[ThisImage]#" 
		ObjectName="MyProductFamily"
		PropertyName="#ThisImage#"
		Required="N">
	<cfif MyProductFamily.GetProperty("#ThisImage#") is not "">
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="checkbox" 
			caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
			DefaultValue="#Val(evaluate('Delete#ThisImage#'))#"
			VarName="Delete#ThisImage#"
			Required="N">
	</cfif>
</cfloop>
	
<TR><TD colspan="3"><b>Key Features</b></TD></TR>
<TR><TD></TD><TD colspan="2">
<table width="100%"><TR><TD>
<cfset aProductFamilyFeature=MyProductFamily.GetProperty("aProductFamilyFeature")>
<TR><TD><strong>Text</strong></TD><TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD><TD><cfif ArrayLen(aProductFamilyFeature) GT "0" and FormMode IS "ShowForm" and ShowAdmin><strong>Remove?</strong></cfif></TD></TR>


<cfloop index="fi" from="1" to="#ArrayLen(aProductFamilyFeature)#" step="1">
	<cfif FormMode IS "ShowForm">
		<tr valign="top"><TD>
		<cfoutput><textarea cols="60" rows="3" name="KeyFeatureText_#fi#">#HTMLEditFormat(aProductFamilyFeature[fi].TextBlock)#</textarea></cfoutput>
		</TD><TD>
		<cfif ShowAdmin>
		<cfoutput><select name="KeyFeatureSpecificationSetID_#fi#"></cfoutput>
				<cfoutput query="qSpecificationType">
					<option value="#LabelID#" <cfif LabelID IS aProductFamilyFeature[fi].SpecificationSetID>selected</cfif>>#LabelName#</option>
				</cfoutput>
			</select>
		<cfelse>
			<cfoutput><input type="hidden" name="KeyFeatureSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductFamilyFeature[fi].SpecificationSetID)#"></cfoutput>
		</cfif>
		</TD><TD>
		<cfif ShowAdmin><cfoutput><input type="checkbox" name="KeyFeatureDelete_#fi#" value="1"></cfoutput></cfif>
		</TD>
		</TR>
		<cfoutput><input type="hidden" name="KeyFeatureID_#fi#" value="#URLEncodedFormat(Encrypt(aProductFamilyFeature[fi].TextBlockID,APPLICATION.Key))#"></cfoutput>
	<cfelse>
		<cfoutput><TR><TD>#aProductFamilyFeature[fi].TextBlock#</TD>
		<TD>
		<input type="hidden" name="KeyFeatureText_#fi#" value="#HTMLEditFormat(aProductFamilyFeature[fi].TextBlock)#">
		<input type="hidden" name="KeyFeatureID_#fi#" value="#URLEncodedFormat(Encrypt(aProductFamilyFeature[fi].TextBlockID,APPLICATION.Key))#">
		<input type="hidden" name="KeyFeatureSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductFamilyFeature[fi].SpecificationSetID)#">
		</TD>
		<TD><cfloop query="qSpecificationType"><cfif qSpecificationType.LabelID IS aProductFamilyFeature[fi].SpecificationSetID>#qSpecificationType.LabelName#</cfif></cfloop></TD>
		<TD></TD>
		</tR></cfoutput>
	</cfif>
</cfloop>
<cfoutput><input type="hidden" name="NumKeyFeatures" value="#fi#"></cfoutput>
<cfif FormMode IS "ShowForm">
	<TR><TD>
		<textarea cols="60" rows="3" name="KeyFeatureText_New"></textarea>
		</TD>
	<TD>
	<cfif ShowAdmin>
	<cfoutput><select name="KeyFeatureSpecificationSetID_new"></cfoutput>
	<cfoutput query="qSpecificationType">
		<option value="#LabelID#">#LabelName#</option>
	</cfoutput>
	</select>
	</cfif>
	</TD><TD>&nbsp;</TD></TR>
	<TR><TD colspan="3" align="right"><input type="submit" value="Update Key Features"></TD></TR>
</cfif>

</TD></TR></table>
</TD></TR>


<TR><TD colspan="3"><b>Images</b></TD></TR>

<TR><TD></TD><TD colspan="2">
<table width="100%"><TR><TD>
<cfset aProductFamilyView=MyProductFamily.GetProperty("aProductFamilyView")>
<TR>
<TD><strong>Name</strong></TD>
<TD><strong>Caption</strong></TD>
<TD><strong>File</strong></TD>
<TD></TD>
<TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD>
<TD><cfif ArrayLen(aProductFamilyView) GT "0" and FormMode IS "ShowForm" and ShowAdmin><strong>Remove?</strong></cfif></TD>
</TR>


<cfloop index="fi" from="1" to="#ArrayLen(aProductFamilyView)#" step="1">
	<cfif FormMode IS "ShowForm"><cfoutput>
		<tr valign="top">
		<TD>
		<input type="text" name="ResourceName_Image_#fi#" value="#aProductFamilyView[fi].ResourceName#" size="20" maxlength="128">
		</TD>
		<TD>
		<textarea cols="60" rows="3" name="ResourceText_Image_#fi#">#aProductFamilyView[fi].ResourceText#</textarea>
		</TD>
		
		<TD>Main:<BR><cfif aProductFamilyView[fi].MainFilePath IS NOT ""><img src="#aProductFamilyView[fi].MainFilePath#" width="50"></cfif><input type="hidden" name="MainFilePath_Image_#fi#" value="#aProductFamilyView[fi].MainFilePath#"><BR>
		<input type="file" name="MainFilePath_Image_#fi#FileObject"><br>
		Thumbnail:<BR>
		<cfif aProductFamilyView[fi].ThumbnailFilePath IS NOT ""><img src="#aProductFamilyView[fi].ThumbnailFilePath#"></cfif><input type="hidden" name="ThumbnailFilePath_Image_#fi#" value="#aProductFamilyView[fi].ThumbnailFilePath#"><BR>
		<input type="file" name="ThumbnailFilePath_Image_#fi#FileObject">
		</TD>
		<!--- sort icons --->
		<TD nowrap>
			<!--- need put the sort module in here --->
			<cfif ArrayLen(aProductFamilyView) GT "1" and ShowAdmin> <!--- more views than 1 and user is master admin, show sort options --->
				<cfmodule template="/common/modules/product/ProductArraySort.cfm"
					ThisArray="#aProductFamilyView#"
					ThisFormID="views"
					IsDisplay="1"
					SortIndex="#fi#">
			</cfif>
		</TD><!--- end sort icons ---><TD>
		<cfif ShowAdmin>
			<cfoutput><select name="ResourceSpecificationSetID_Image_#fi#"></cfoutput>
			<cfloop query="qSpecificationType">
				<option value="#qSpecificationType.LabelID#" <cfif qSpecificationType.LabelID IS aProductFamilyView[fi].SpecificationSetID>selected</cfif>>#qSpecificationType.LabelName#</option>
			</cfloop></select>
		<cfelse>
			<cfoutput><input type="hidden" name="ResourceSpecificationSetID_Image_#fi#" value="#HTMLEditFormat(aProductFamilyView[fi].SpecificationSetID)#"></cfoutput>
		</cfif></TD>
		
		<TD><cfif ShowAdmin><cfoutput><input type="checkbox" name="ResourceDelete_Image_#fi#" value="1"></cfoutput></cfif>
		</TD></TR><input type="hidden" name="ResourceID_Image_#fi#" value="#URLEncodedFormat(Encrypt(aProductFamilyView[fi].ResourceID,APPLICATION.Key))#"></cfoutput>
	<cfelse>
		<cfoutput><TR>
		<TD>#aProductFamilyView[fi].ResourceName#</TD>
		<TD>#aProductFamilyView[fi].ResourceText#</TD>
		<TD>
		Main:<BR><img src="#aProductFamilyView[fi].MainFilePath#"><input type="hidden" name="MainFilePath_Image_#fi#" value="#aProductFamilyView[fi].MainFilePath#"><BR>
		Thumbnail:<BR><img src="#aProductFamilyView[fi].ThumbnailFilePath#"><input type="hidden" name="ThumbnailFilePath_Image_#fi#" value="#aProductFamilyView[fi].ThumbnailFilePath#"></TD>
		<TD></TD>
		<TD><cfloop query="qSpecificationType"><cfif qSpecificationType.LabelID IS aProductFamilyView[fi].SpecificationSetID>#qSpecificationType.LabelName#</cfif></cfloop></TD>
		<TD>
		<input type="hidden" name="ResourceSpecificationSetID_Image_#fi#" value="#HTMLEditFormat(aProductFamilyView[fi].SpecificationSetID)#">
		<input type="hidden" name="ResourceName_Image_#fi#" value="#HTMLEditFormat(aProductFamilyView[fi].ResourceName)#">
		<input type="hidden" name="ResourceText_Image_#fi#" value="#HTMLEditFormat(aProductFamilyView[fi].ResourceText)#">
		<input type="hidden" name="ResourceID_Image_#fi#" value="#URLEncodedFormat(Encrypt(aProductFamilyView[fi].ResourceID,APPLICATION.Key))#"></TD></tR></cfoutput>
	</cfif>
</cfloop>
<cfoutput><input type="hidden" name="NumImages" value="#fi#"></cfoutput>
<cfif FormMode IS "ShowForm">
	<tr valign="top">
		<TD>
		<input type="text" name="ResourceName_image_New" value="" size="20" maxlength="128">
		</TD>
		<TD>
		<textarea cols="60" rows="3" name="ResourceText_image_New"></textarea>
		</TD>
		<TD>Main:<BR>
		<input type="file" name="MainFilePath_image_NewFileObject"><br>
		Thumbnail:<BR>
		<input type="file" name="ThumbnailFilePath_image_NewFileObject"></TD>
		<TD></TD>
		<TD><cfif ShowAdmin>
	<select name="ResourceSpecificationSetID_image_new">
	<cfoutput query="qSpecificationType">
		<option value="#LabelID#">#LabelName#</option>
	</cfoutput>
	</select></cfif>
	</TD>
	<TD></TD></TR>
	
	<TR><TD colspan="6" align="right"><input type="submit" value="Update Images"></TD></TR>
</cfif>

</table>
</TD></TR>

<TR><TD colspan="3"><b>Downloads</b></TD></TR>

<TR><TD></TD><TD colspan="2">
<table width="100%"><TR><TD>
<cfset aProductFamilyDownload=MyProductFamily.GetProperty("aProductFamilyDownload")>
<TR>
<TD><strong>Name</strong></TD>
<TD><strong>Caption</strong></TD>
<TD><strong>File</strong></TD>
<TD></TD>
<TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD>
<TD><cfif ArrayLen(aProductFamilyDownload) GT "0" and FormMode IS "ShowForm" and ShowAdmin><strong>Remove?</strong></cfif></TD>
</TR>


<cfloop index="fi" from="1" to="#ArrayLen(aProductFamilyDownload)#" step="1">
	<cfif FormMode IS "ShowForm"><cfoutput>
		<tr valign="top">
		<TD>
		<input type="text" name="ResourceName_Download_#fi#" value="#aProductFamilyDownload[fi].ResourceName#" size="20" maxlength="128">
		</TD>
		<TD>
		<textarea cols="60" rows="3" name="ResourceText_Download_#fi#">#aProductFamilyDownload[fi].ResourceText#</textarea>
		</TD>
		
		<TD>Main:<BR><cfif aProductFamilyDownload[fi].MainFilePath IS NOT ""><a href="#aProductFamilyDownload[fi].MainFilePath#" target="_blank">#ListLast(aProductFamilyDownload[fi].MainFilePath,"/")#</a></cfif><input type="hidden" name="MainFilePath_Download_#fi#" value="#aProductFamilyDownload[fi].MainFilePath#"><BR>
		<input type="file" name="MainFilePath_Download_#fi#FileObject">
		</TD>
		<!--- sort icons --->
		<TD nowrap>
			<!--- need put the sort module in here --->
			<cfif ArrayLen(aProductFamilyDownload) GT "1" and ShowAdmin> <!--- more views than 1 and user is master admin, show sort options --->
				<cfmodule template="/common/modules/product/ProductArraySort.cfm"
					ThisArray="#aProductFamilyDownload#"
					ThisFormID="downloads"
					IsDisplay="1"
					SortIndex="#fi#">
			</cfif>
		</TD><!--- end sort icons ---><TD>
		<cfif ShowAdmin>
			<cfoutput><select name="ResourceSpecificationSetID_Download_#fi#"></cfoutput>
			<cfloop query="qSpecificationType">
				<option value="#qSpecificationType.LabelID#" <cfif qSpecificationType.LabelID IS aProductFamilyDownload[fi].SpecificationSetID>selected</cfif>>#qSpecificationType.LabelName#</option>
			</cfloop></select>
		<cfelse>
			<cfoutput><input type="hidden" name="ResourceSpecificationSetID_Download_#fi#" value="#HTMLEditFormat(aProductFamilyDownload[fi].SpecificationSetID)#"></cfoutput>
		</cfif></TD>
		
		<TD><cfif ShowAdmin><cfoutput><input type="checkbox" name="ResourceDelete_Download_#fi#" value="1"></cfoutput></cfif>
		</TD></TR><input type="hidden" name="ResourceID_Download_#fi#" value="#URLEncodedFormat(Encrypt(aProductFamilyDownload[fi].ResourceID,APPLICATION.Key))#"></cfoutput>
	<cfelse>
		<cfoutput><TR>
		<TD>#aProductFamilyDownload[fi].ResourceName#</TD>
		<TD>#aProductFamilyDownload[fi].ResourceText#</TD>
		<TD>
		Main:<BR><a href="#aProductFamilyDownload[fi].MainFilePath#" target="_blank">#ListLast(aProductFamilyDownload[fi].MainFilePath,"/")#</a><input type="hidden" name="MainFilePath_Download_#fi#" value="#aProductFamilyDownload[fi].MainFilePath#"></TD>
		<TD></TD>
		<TD><cfloop query="qSpecificationType"><cfif qSpecificationType.LabelID IS aProductFamilyDownload[fi].SpecificationSetID>#qSpecificationType.LabelName#</cfif></cfloop></TD>
		<TD>
		<input type="hidden" name="ResourceSpecificationSetID_Download_#fi#" value="#HTMLEditFormat(aProductFamilyDownload[fi].SpecificationSetID)#">
		<input type="hidden" name="ResourceName_Download_#fi#" value="#HTMLEditFormat(aProductFamilyDownload[fi].ResourceName)#">
		<input type="hidden" name="ResourceText_Download_#fi#" value="#HTMLEditFormat(aProductFamilyDownload[fi].ResourceText)#">
		<input type="hidden" name="ResourceID_Download_#fi#" value="#URLEncodedFormat(Encrypt(aProductFamilyDownload[fi].ResourceID,APPLICATION.Key))#"></TD></tR></cfoutput>
	</cfif>
</cfloop>
<cfoutput><input type="hidden" name="NumDownloads" value="#fi#"></cfoutput>
<cfif FormMode IS "ShowForm">
	<tr valign="top">
		<TD>
		<input type="text" name="ResourceName_Download_New" value="" size="20" maxlength="128">
		</TD>
		<TD>
		<textarea cols="60" rows="3" name="ResourceText_Download_New"></textarea>
		</TD>
		<TD>Main:<BR>
		<input type="file" name="MainFilePath_Download_NewFileObject"></TD>
		<TD></TD>
		<TD><cfif ShowAdmin>
	<select name="ResourceSpecificationSetID_Download_new">
	<cfoutput query="qSpecificationType">
		<option value="#LabelID#">#LabelName#</option>
	</cfoutput>
	</select></cfif>
	</TD>
	<TD></TD></TR>
	
	<TR><TD colspan="6" align="right"><input type="submit" value="Update Downloads"></TD></TR>
</cfif>

</table>
</TD></TR>

<!--- <TR><TD colspan="3"><b>
<cfdump var="#MyCategory.getAllErrorMessages()#">
</b></TD></TR> --->
<TR><TD colspan="3"><b>Product Family Comparison Chart</b></TD></TR>

<cfif FormLanguageID IS NOT APPLICATION.DefaultLanguageID and qProductLanguages.RecordCount GTE "1">
	<TR><TD colspan="3" align="right">Load Family Comparison Chart Only From: 
	<select name="plclid2">
		<option value="-1">Select...</option>
		<cfoutput query="qProductLanguages">
			<cfif FormLanguageID IS NOT LanguageID>
				<option value="#REQUEST.SimpleEncrypt(LanguageID)#">#LanguageName#</option>
			</cfif>
		</cfoutput>
	</select> <!--- <input type="submit" name="ButLoad2" value="Load"> --->
	<input type="submit" name="ButLoad3" value="Load"></TD></TR>
</cfif>


<TR><TD>&nbsp;</TD><TD colspan="2">
<cfset aAttr=MyProductFamily.GetProperty("aProductFamilyAttribute")>
<table width="100%">
<TR><TD>&nbsp;</TD>
<TD><cfif ArrayLen(aAttr) GT "0" and NOT ShowAdmin><strong>English</strong></cfif></TD>
<TD><strong>Name</strong></TD>
<TD><cfif ArrayLen(aAttr) GT "0" and ShowAdmin><strong>Type</strong></cfif></TD>
<TD><cfif ArrayLen(aAttr) GT "0" and ShowAdmin><strong>Order</strong></cfif></TD>
<TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD>
<TD><strong><cfif ArrayLen(aAttr) GT "0" and FormMode IS "ShowForm" and ShowAdmin>Master </cfif>Remove?</strong></TD></TR>
<cfloop index="i" from="1" to="#ArrayLen(aAttr)#" step="1">
	<cfif FormMode IS "ShowForm">
		<tr valign="top">
		<cfoutput><TD>#i#</TD>
		<TD style="color:##999999">
		<cfif NOT ShowAdmin>
			<cfquery name="GetThis" datasource="#APPLICATION.DSN#" maxrows="1">
				SELECT ProductFamilyAttributeName FROM qry_GetProductFamilyAttribute 
				WHERE LanguageID=#Val(APPLICATION.DefaultLanguageID)# and 
				ProductFamilyAttributeID=#Val(aAttr[i].ProductFamilyAttributeID)#
			</cfquery>
			<cfif GetThis.RecordCount IS "1">
				<span title="#aAttr[i].ProductFamilyAttributeID#">#GetThis.ProductFamilyAttributeName#</span>
			<cfelse>
				<span title="#aAttr[i].ProductFamilyAttributeID#">[deleted]</span>
			</cfif>
		</cfif></TD>
		<TD>
		<input type="text" name="AttributeName_#i#" value="#HTMLEditFormat(aAttr[i].ProductFamilyAttributeName)#" maxlength="255" size="80" <cfif StructKeyExists(aAttr[i],"ProductFamilyAttributeNameDefault")>title="#aAttr[i].ProductFamilyAttributeNameDefault#"></cfif></cfoutput>
		</TD><TD>
		<cfif ShowAdmin>
			<cfoutput><select name="AttributeTypeID_#i#"></cfoutput>
				<cfoutput query="qAttributeType">
					<option value="#LabelID#" <cfif LabelID IS aAttr[i].ProductFamilyAttributeTypeID>selected</cfif>>#LabelName#</option>
				</cfoutput>
			</select>
		<cfelse>
			<cfoutput><input type="hidden" name="AttributeTypeID_#i#" value="#HTMLEditFormat(aAttr[i].ProductFamilyAttributeTypeID)#"></cfoutput>
		</cfif>
		</TD><TD nowrap>
			<cfif ShowAdmin>
				<cfif 0>
					<cfoutput><cfif ArrayLen(aAttr) GT "1" and ShowAdmin>
					<cfif i IS NOT "1"><input type="image" name="ButtonSubmit_up_#i#" value="up_#i#" src="/common/images/widget_arrow_up.gif"><cfelse><img src="/common/images/widget_arrow_up_grey.gif"></cfif><cfif i IS NOT ArrayLen(aAttr)><input type="image" name="ButtonSubmit_down_#i#" value="down_#i#" src="/common/images/widget_arrow_down.gif"><cfelse><img src="/common/images/widget_arrow_down_grey.gif"></cfif>
					</cfif></cfoutput>
				<cfelse>
					<cfoutput><input type="text" size="3" name="AttributePriority_#i#" value="#i*10#"></cfoutput>
				</cfif>
			<cfelse>
				<cfoutput><input type="hidden" name="AttributePriority_#i#" value="#HTMLEditFormat(aAttr[i].ProductFamilyAttributePriority)#"></cfoutput>
			</cfif>
		</TD>
		<TD>
		<cfif ShowAdmin>
		<cfoutput><select name="AttributeSpecificationSetID_#i#"></cfoutput>
				<cfoutput query="qSpecificationType">
					<option value="#LabelID#" <cfif LabelID IS aAttr[i].SpecificationSetID>selected</cfif>>#LabelName#</option>
				</cfoutput>
			</select>
		<cfelse>
			<cfoutput><input type="hidden" name="AttributeSpecificationSetID_#i#" value="#HTMLEditFormat(aAttr[i].SpecificationSetID)#"></cfoutput>
		</cfif>
		</TD>
		<TD>
		<cfif ShowAdmin><cfoutput><input type="checkbox" name="AttributeDelete_#i#" value="1"></cfoutput>
		<cfelse><cfoutput><input type="checkbox" name="AttributeDeleteSoft_#i#" value="1"></cfoutput></cfif>
		</TD></TR>
		<cfoutput><input type="hidden" name="AttributeID_#i#" value="#URLEncodedFormat(Encrypt(aAttr[i].ProductFamilyAttributeID,APPLICATION.Key))#"></cfoutput>
	<cfelse>
		<cfoutput><TR><TD>#i#</TD><TD></TD><TD>#aAttr[i].ProductFamilyAttributeName#</TD></cfoutput>
		<TD>
		<cfoutput>
			<input type="hidden" name="AttributeName_#i#" value="#HTMLEditFormat(aAttr[i].ProductFamilyAttributeName)#">
			<input type="hidden" name="AttributeTypeID_#i#" value="#HTMLEditFormat(aAttr[i].ProductFamilyAttributeTypeID)#">
			<input type="hidden" name="AttributePriority_#i#" value="#HTMLEditFormat(aAttr[i].ProductFamilyAttributePriority)#">
			<input type="hidden" name="AttributeSpecificationSetID_#i#" value="#HTMLEditFormat(aAttr[i].SpecificationSetID)#">
		</cfoutput>
		<cfoutput query="qAttributeType">
			<cfif LabelID IS aAttr[i].ProductFamilyAttributeTypeID>#LabelName#</cfif>
		</cfoutput>
		</TD><TD></TD>
		
		<TD>
		<cfoutput query="qSpecificationType">
			<cfif LabelID IS aAttr[i].SpecificationSetID>#LabelName#</cfif>
		</cfoutput>
		</TD>
		<TD></TD></tR>
	</cfif>
</cfloop>
<cfoutput><input type="hidden" name="NumAttributes" value="#ArrayLen(aAttr)#"></cfoutput>
<cfif FormMode IS "ShowForm" and ShowAdmin>
	<TR><TD></TD><TD></TD><TD>
		<input type="text" name="AttributeName_New" value="" maxlength="255" size="80">
		</TD><TD>
		<select name="AttributeTypeID_New">
			<cfoutput query="qAttributeType">
				<option value="#LabelID#">#LabelName#</option>
			</cfoutput>
		</select>
	</TD><TD>&nbsp;</TD>
	
		<TD>
	<select name="AttributeSpecificationSetID_new">
	<cfoutput query="qSpecificationType">
		<option value="#LabelID#">#LabelName#</option>
	</cfoutput>
	</select>
	</TD>
	<TD></TD></TR>
	<TR><TD colspan="7" align="right"><input type="submit" value="Update Chart"></TD></TR>
</cfif>
</table>

</TD></TR>
<cfif OpenAndCloseFormTables></table></cfif>
