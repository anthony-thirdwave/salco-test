<cfparam name="OpenAndCloseFormTables" default="Yes">
<cfparam name="FormMode" default="ShowForm">
<cfparam name="ProductPageMode" default="Product">

<cfset ProductFormLocation=GetToken(FormAction,1,"?")>
<cfset ProductFormQueryString=GetToken(FormAction,2,"?")>
			
<cfif SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID>
	<cfset ShowAdmin="1">
<cfelse>
	<cfset ShowAdmin="0">
</cfif>

<cfparam name="DeleteCategoryImageHeader" default="0">

<!--- Determine Domains --->
<cfinvoke component="/lifefitness/com/utils/database" method="GenericLookup" returnVariable="qLanguages">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="labelGroupID">
	<cfinvokeargument name="FieldValue" value="60">
	<cfinvokeargument name="SortFieldName" value="LabelName">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>

<cfinvoke component="/lifefitness/com/utils/database" method="GenericLookup" returnVariable="qSpecificationType">
	<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
	<cfinvokeargument name="TableName" value="t_Label">
	<cfinvokeargument name="FieldName" value="labelGroupID">
	<cfinvokeargument name="FieldValue" value="8000">
	<cfinvokeargument name="SortFieldName" value="LabelPriority">
	<cfinvokeargument name="SortOrder" value="Asc">
</cfinvoke>

<cfinvoke component="/lifefitness/com/Product/ProductHandler" 
	method="GetProductLanguages" 
	returnVariable="qProductLanguages" 
	ProductID="#MyProduct.GetProperty('ProductID')#">

<cfif OpenAndCloseFormTables><table width="100%"></cfif>
	

<TR><TD  colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="3"><TR>


<cfif MyProduct.GetConsoleProductFamilyID() gt "0">
	<cfif ProductPageMode IS NOT "Console">
		<TD bgcolor="bac0c9" style="padding-right:30px;"><b>Product Details</b></TD>
		<cf_AddToQueryString querystring="#ProductFormQueryString#" name="ReturnURL" value="#ReturnURL#">
		<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="#PageAction#">
		<cf_AddToQueryString querystring="#QueryString#" name="ProductPageMode" value="Console">
		<cfoutput><TD bgcolor="eaeaea" style="padding-left:30px;padding-right:30px;"><a href="#ProductFormLocation#?#querystring#">Console Details</A></TD></cfoutput>
	<cfelse>
		<cf_AddToQueryString querystring="#ProductFormQueryString#" name="ReturnURL" value="#ReturnURL#">
		<cf_AddToQueryString querystring="#QueryString#" name="PageAction" value="#PageAction#">
		<cf_AddToQueryString querystring="#QueryString#" name="ProductPageMode" value="Product">
		<cfoutput><TD bgcolor="eaeaea" style="padding-right:30px;"><a href="#ProductFormLocation#?#querystring#">Product Details</A></TD></cfoutput>
		<TD bgcolor="bac0c9" style="padding-left:30px;padding-right:30px;"><strong>Console Details</strong></TD>
	</cfif>
	<TD align="right" bgcolor="eaeaea"><cfoutput query="qLanguages"><cfif FormLanguageID IS LabelID>Product Language: #LabelName#</cfif></cfoutput></TD></TR>
	<TR bgcolor="bac0c9"><TD colspan="3">&nbsp;</TD></TR>
<cfelse>
	<TD bgcolor="bac0c9"><b>Product Details</b></TD>
	<TD align="right" bgcolor="bac0c9"><cfoutput query="qLanguages"><cfif FormLanguageID IS LabelID>Product Language: #LabelName#</cfif></cfoutput></TD>
</cfif>
</TR>


</table></TD></TR>


<cfif ProductPageMode IS NOT "Console">
	<cfif FormLanguageID IS NOT APPLICATION.DefaultLanguageID and qProductLanguages.RecordCount GTE "1">
		<TR><TD bgcolor="bac0c9" colspan="3" align="right">Load Product Data From: 
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
		type="text"
		caption="Product Long Name" 
		ObjectName="MyProduct"
		PropertyName="ProductLongName"
		size="128" maxlength="128"
		Required="N">
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Product Short Name" 
		ObjectName="MyProduct"
		PropertyName="ProductShortName"
		size="128" maxlength="128"
		Required="N">
		
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Positioning Sentence" 
		ObjectName="MyProduct"
		PropertyName="ProductPositioningSentence"
		size="128" maxlength="1000"
		Required="N">
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="textarea"
		caption="Product Description" 
		ObjectName="MyProduct"
		PropertyName="ProductDescription"
		cols="80" rows="10"
		EscapeCRLF="No"
		Required="N">
	
	<!--- <cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Call to Action URL (Deprecated)" 
		ObjectName="MyProduct"
		PropertyName="CallToActionURLDeprecated"
		size="80" maxlength="128"
		Required="N"> --->
	
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Video URL" 
		ObjectName="MyProduct"
		PropertyName="VideoURL"
		size="80" maxlength="256"
		Required="N">
		
	<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
		ObjectAction="#FormMode#"
		type="text"
		caption="Color Configurator URL" 
		ObjectName="MyProduct"
		PropertyName="ColorConfiguratorURL"
		size="80" maxlength="256"
		Required="N">
	
	<cfset sImageName=StructNew()>
	<cfset StructInsert(sImageName,"BrochurePath","Brochure File",1)>
	<cfset StructInsert(sImageName,"ProductImagePath","Product Image",1)>
	<cfset StructInsert(sImageName,"ProductThumbnailPath","Product Thumbnail Image",1)>
	<cfset StructInsert(sImageName,"ProductThumbnailHoverPath","Product Thumbnail Hover Image",1)>
	<cfset StructInsert(sImageName,"CompareGymBrochurePath","Compare Gym Brochure File",1)>
	<cfset StructInsert(sImageName,"ProductImageSourcePath","Image Source (500x420px)<br>Use this image to generate image for use in the LF Store and product configurator.",1)>
	<cfset StructInsert(sImageName,"ProductImageStorePath","Store Image ",1)>
	
	<cfloop index="ThisImage" list="BrochurePath,CompareGymBrochurePath,ProductThumbnailPath,ProductImageSourcePath,ProductThumbnailHoverPath,ProductImageStorePath">
		<cfparam name="Delete#ThisImage#" default="0">
		<cfif ListFindNoCase("ProductThumbnailHoverPath,ProductThumbnailPath,ProductImageSourcePath,ProductImageStorePath",ThisImage) and FormLanguageID IS NOT APPLICATION.DefaultLanguageID>
			<cfset ThisFormMode="validate">
		<cfelse>
		 	<cfset ThisFormMode="#FormMode#">
		</cfif>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#ThisFormMode#"
			type="File"
			caption="#sImageName[ThisImage]#" 
			ObjectName="MyProduct"
			PropertyName="#ThisImage#"
			Required="N">
		<cfif MyProduct.GetProperty("#ThisImage#") is not "">
			<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
				ObjectAction="#ThisFormMode#"
				type="checkbox" 
				caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
				DefaultValue="#Val(evaluate('Delete#ThisImage#'))#"
				VarName="Delete#ThisImage#"
				Required="N">
		</cfif>
	</cfloop>
	
	<TR><TD bgcolor="bac0c9" colspan="3"><b>Key Features</b></TD></TR>
	<TR><TD bgcolor="bac0c9"></TD><TD colspan="2" bgcolor="EAEAEA">
	<table width="100%"><TR>
	<cfset aProductFeature=MyProduct.GetProperty("aProductFeature")>
	<TD><strong>Text</strong></TD>
	<td></td>
	<TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD>
	<TD><cfif ArrayLen(aProductFeature) GT "0" and FormMode IS "ShowForm" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><strong>Remove?</strong></cfif></TD></TR>
	
	
	<cfloop index="fi" from="1" to="#ArrayLen(aProductFeature)#" step="1">
		<cfif FormMode IS "ShowForm">
			<TR><TD>
			<cfoutput><textarea cols="80" rows="3" name="KeyFeatureText_#fi#">#HTMLEditFormat(aProductFeature[fi].TextBlock)#</textarea></cfoutput>
			</TD>
			<!--- sort --->
			<TD nowrap>
				<!--- need put the sort module in here --->
				<cfif ArrayLen(aProductFeature) GT "1" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID> <!--- more views than 1 and user is master admin, show sort options --->
					<cfmodule template="/common/modules/product/ProductArraySort.cfm"
						ThisArray="#aProductFeature#"
						ThisFormID="keyfeature"
						IsDisplay="1"
						SortIndex="#fi#">
				</cfif>
			</TD> <!--- sort --->
			<TD>
			<cfif ShowAdmin>
			<cfoutput><select name="KeyFeatureSpecificationSetID_#fi#"></cfoutput>
					<cfoutput query="qSpecificationType">
						<option value="#LabelID#" <cfif LabelID IS aProductFeature[fi].SpecificationSetID>selected</cfif>>#LabelName#</option>
					</cfoutput>
				</select>
			<cfelse>
				<cfoutput><input type="hidden" name="KeyFeatureSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductFeature[fi].SpecificationSetID)#"></cfoutput>
			</cfif>
			</TD>
			<TD>
			<cfif SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><cfoutput><input type="checkbox" name="KeyFeatureDelete_#fi#" value="1"></cfoutput></cfif>
			</TD></TR>
			<cfoutput><input type="hidden" name="KeyFeatureID_#fi#" value="#URLEncodedFormat(Encrypt(aProductFeature[fi].TextBlockID,APPLICATION.Key))#"></cfoutput>
		<cfelse>
			<cfoutput><TR><TD>#aProductFeature[fi].TextBlock#</TD>
			<TD>
			<input type="hidden" name="KeyFeatureText_#fi#" value="#HTMLEditFormat(aProductFeature[fi].TextBlock)#">
			<input type="hidden" name="KeyFeatureID_#fi#" value="#URLEncodedFormat(Encrypt(aProductFeature[fi].TextBlockID,APPLICATION.Key))#">
			<input type="hidden" name="KeyFeatureSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductFeature[fi].SpecificationSetID)#">
			</TD><td></td>
			<TD><cfloop query="qSpecificationType"><cfif qSpecificationType.LabelID IS aProductFeature[fi].SpecificationSetID>#qSpecificationType.LabelName#</cfif></cfloop></TD>
			</tR></cfoutput>
		</cfif>
	</cfloop>
	<cfoutput><input type="hidden" name="NumKeyFeatures" value="#fi#"></cfoutput>
	<cfif FormMode IS "ShowForm" and showadmin>
		<TR><TD>
			<textarea cols="80" rows="3" name="KeyFeatureText_New"></textarea>
			</TD><td></td>
		<TD>
		<cfoutput><select name="KeyFeatureSpecificationSetID_new"></cfoutput>
		<cfoutput query="qSpecificationType">
			<option value="#LabelID#">#LabelName#</option>
		</cfoutput>
		</select>
		</TD>
		<TD>&nbsp;</TD></TR>
		<TR><TD colspan="4" align="right"><input type="submit" value="Update Key Features"></TD></TR>
	</cfif>
	
	</TD></TR></table>
	</TD></TR>
	
	<TR><TD bgcolor="bac0c9" colspan="3"><b>Overview Bullets</b></TD></TR>
	<TR><TD bgcolor="bac0c9"></TD><TD colspan="2" bgcolor="EAEAEA">
	<table width="100%"><TR>
	<cfset aProductBullet=MyProduct.GetProperty("aProductBullet")>
	<TD><strong>Text</strong></TD>
	<td></td>
	<TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD>
	<TD><cfif ArrayLen(aProductBullet) GT "0" and FormMode IS "ShowForm" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><strong>Remove?</strong></cfif></TD></TR>
	
	
	<cfloop index="fi" from="1" to="#ArrayLen(aProductBullet)#" step="1">
		<cfif FormMode IS "ShowForm">
			<TR><TD>
			<cfoutput><textarea cols="80" rows="2" name="BulletText_#fi#">#HTMLEditFormat(aProductBullet[fi].TextBlock)#</textarea></cfoutput>
			</TD>
			<!--- sort --->
			<TD nowrap>
				<!--- need put the sort module in here --->
				<cfif ArrayLen(aProductBullet) GT "1" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID> <!--- more views than 1 and user is master admin, show sort options --->
					<cfmodule template="/common/modules/product/ProductArraySort.cfm"
						ThisArray="#aProductBullet#"
						ThisFormID="Bullet"
						IsDisplay="1"
						SortIndex="#fi#">
				</cfif>
			</TD> <!--- sort --->
			<TD>
			<cfif ShowAdmin>
			<cfoutput><select name="BulletSpecificationSetID_#fi#"></cfoutput>
					<cfoutput query="qSpecificationType">
						<option value="#LabelID#" <cfif LabelID IS aProductBullet[fi].SpecificationSetID>selected</cfif>>#LabelName#</option>
					</cfoutput>
				</select>
			<cfelse>
				<cfoutput><input type="hidden" name="BulletSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductBullet[fi].SpecificationSetID)#"></cfoutput>
			</cfif>
			</TD>
			<TD>
			<cfif SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><cfoutput><input type="checkbox" name="BulletDelete_#fi#" value="1"></cfoutput></cfif>
			</TD></TR>
			<cfoutput><input type="hidden" name="BulletID_#fi#" value="#URLEncodedFormat(Encrypt(aProductBullet[fi].TextBlockID,APPLICATION.Key))#"></cfoutput>
		<cfelse>
			<cfoutput><TR><TD>#aProductBullet[fi].TextBlock#</TD>
			<TD>
			<input type="hidden" name="BulletText_#fi#" value="#HTMLEditFormat(aProductBullet[fi].TextBlock)#">
			<input type="hidden" name="BulletID_#fi#" value="#URLEncodedFormat(Encrypt(aProductBullet[fi].TextBlockID,APPLICATION.Key))#">
			<input type="hidden" name="BulletSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductBullet[fi].SpecificationSetID)#">
			</TD><td></td>
			<TD><cfloop query="qSpecificationType"><cfif qSpecificationType.LabelID IS aProductBullet[fi].SpecificationSetID>#qSpecificationType.LabelName#</cfif></cfloop></TD>
			</tR></cfoutput>
		</cfif>
	</cfloop>
	<cfoutput><input type="hidden" name="NumBullets" value="#fi#"></cfoutput>
	<cfif FormMode IS "ShowForm" and showadmin>
		<TR><TD>
			<textarea cols="80" rows="3" name="BulletText_New"></textarea>
			</TD><td></td>
		<TD>
		<cfoutput><select name="BulletSpecificationSetID_new"></cfoutput>
		<cfoutput query="qSpecificationType">
			<option value="#LabelID#">#LabelName#</option>
		</cfoutput>
		</select>
		</TD>
		<TD>&nbsp;</TD></TR>
		<TR><TD colspan="4" align="right"><input type="submit" value="Update Bullets"></TD></TR>
	</cfif>
	
	</TD></TR></table>
	</TD></TR>
	
	<TR><TD bgcolor="bac0c9" colspan="3"><b>Product Reviews</b></TD></TR>
	<TR><TD bgcolor="bac0c9"></TD><TD colspan="2" bgcolor="EAEAEA">
	<table width="100%">
	<cfset aProductReview=MyProduct.GetProperty("aProductReview")>
	<tr valign="top"><TD><strong>Source</strong></TD><TD><strong>Review Text</strong></TD><td></td><TD><cfif ArrayLen(aProductReview) GT "0" and FormMode IS "ShowForm" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><strong>Remove?</strong></cfif></TD></TR>
	
	
	<cfloop index="fi" from="1" to="#ArrayLen(aProductReview)#" step="1">
		<cfif FormMode IS "ShowForm">
			<tr valign="top"><TD>
			<cfoutput><input type="text" name="ReviewSource_#fi#" value="#HTMLEditFormat(aProductReview[fi].TextBlockName)#" size="20" maxlength="128"></cfoutput>
			</TD>
			<TD>
			<cfoutput><textarea cols="80" rows="3" name="ReviewText_#fi#">#HTMLEditFormat(aProductReview[fi].TextBlock)#</textarea></cfoutput>
			</TD>
			<!--- sort --->
			<TD nowrap>
				<!--- need put the sort module in here --->
				<cfif ArrayLen(aProductReview) GT "1" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID> <!--- more views than 1 and user is master admin, show sort options --->
					<cfmodule template="/common/modules/product/ProductArraySort.cfm"
						ThisArray="#aProductReview#"
						ThisFormID="review"
						IsDisplay="1"
						SortIndex="#fi#">
				</cfif>
			</TD> <!--- sort --->
			<TD><cfif SESSION.UserLocaleID IS "1">
			<cfoutput><input type="checkbox" name="ReviewDelete_#fi#" value="1"></cfoutput></cfif>
			</TD></TR>
			<cfoutput><input type="hidden" name="ReviewID_#fi#" value="#URLEncodedFormat(Encrypt(aProductReview[fi].TextBlockID,APPLICATION.Key))#"></cfoutput>
		<cfelse>
			<cfoutput><tr valign="top"><TD>#aProductReview[fi].TextBlockName#</TD><TD>#aProductReview[fi].TextBlock#</TD>
			<TD>
			<input type="hidden" name="ReviewText_#fi#" value="#HTMLEditFormat(aProductReview[fi].TextBlock)#">
			<input type="hidden" name="ReviewSource_#fi#" value="#HTMLEditFormat(aProductReview[fi].TextBlockName)#">
			<input type="hidden" name="ReviewID_#fi#" value="#URLEncodedFormat(Encrypt(aProductReview[fi].TextBlockID,APPLICATION.Key))#">
			</TD><td></td><TD></TD></tR></cfoutput>
		</cfif>
	</cfloop>
	<cfoutput><input type="hidden" name="NumReviews" value="#fi#"></cfoutput>
	<cfif FormMode IS "ShowForm" and ShowAdmin>
		<tr valign="top"><TD>
			<input type="text" name="ReviewSource_new" value="" size="20" maxlength="128">
			</TD>
			<TD>
			<textarea cols="80" rows="3" name="ReviewText_New"></textarea>
			</TD><td></td><TD>
		</TD><TD>&nbsp;</TD></TR>
		<TR><TD colspan="4" align="right"><input type="submit" value="Update Product Reviews"></TD></TR>
	</cfif>
	
	</TD></TR></table>
	</TD></TR>
	
	
	
	<TR><TD bgcolor="bac0c9" colspan="3"><b>Views</b></TD></TR>
	<TR><TD bgcolor="bac0c9"></TD><TD colspan="2" bgcolor="EAEAEA">
	<table width="100%"><TR><TD>
	<cfset aProductView=MyProduct.GetProperty("aProductView")>
	<TR><TD><strong>Name</strong></TD><TD><strong>Text</strong></TD><TD><strong>File</strong></TD><TD></TD>
	<TD><cfif ShowAdmin><strong>Spec Set</strong></cfif></TD>
	<TD><cfif ArrayLen(aProductView) GT "0" and FormMode IS "ShowForm" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><strong>Remove?</strong></cfif></TD></TR>
	
	
	<cfloop index="fi" from="1" to="#ArrayLen(aProductView)#" step="1">
		<cfif FormMode IS "ShowForm"><cfoutput>
			<tr valign="top">
			<TD>
			<input type="text" name="ResourceName_#fi#" value="#aProductView[fi].ResourceName#" size="20" maxlength="128">
			</TD>
			<TD>
			<textarea cols="20" rows="5" name="ResourceText_#fi#">#aProductView[fi].ResourceText#</textarea>
			</TD>
			
			<TD>Main:<BR><img src="#aProductView[fi].MainFilePath#"><input type="hidden" name="MainFilePath_#fi#" value="#aProductView[fi].MainFilePath#"><BR>
			<cfif FormLanguageID IS APPLICATION.DefaultLanguageID><input type="file" name="MainFilePath_#fi#FileObject"><br></cfif>
			Thumbnail:<BR>
			<cfif aProductView[fi].ThumbnailFilePath IS NOT ""><cfif ListLast(aProductView[fi].ThumbnailFilePath,".") is "swf"><a href="#aProductView[fi].ThumbnailFilePath#" target="_new">#ListLast(aProductView[fi].ThumbnailFilePath,"/")#</A><cfelse><img src="#aProductView[fi].ThumbnailFilePath#"></cfif></cfif><input type="hidden" name="ThumbnailFilePath_#fi#" value="#aProductView[fi].ThumbnailFilePath#"><BR>
			<cfif FormLanguageID IS APPLICATION.DefaultLanguageID><input type="file" name="ThumbnailFilePath_#fi#FileObject"></cfif>
			</TD>
			<!--- sort icons --->
			<TD nowrap>
				<!--- need put the sort module in here --->
				<cfif ArrayLen(aProductView) GT "1" and SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID> <!--- more views than 1 and user is master admin, show sort options --->
					<cfmodule template="/common/modules/product/ProductArraySort.cfm"
						ThisArray="#aProductView#"
						ThisFormID="views"
						IsDisplay="1"
						SortIndex="#fi#">
				</cfif>
			</TD>
			<!--- end sort icons --->
			<TD>
			<cfif ShowAdmin>
				<cfoutput><select name="ResourceSpecificationSetID_#fi#"></cfoutput>
				<cfloop query="qSpecificationType">
					<option value="#qSpecificationType.LabelID#" <cfif qSpecificationType.LabelID IS aProductView[fi].SpecificationSetID>selected</cfif>>#qSpecificationType.LabelName#</option>
				</cfloop></select>
			<cfelse>
				<cfoutput><input type="hidden" name="ResourceSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductView[fi].SpecificationSetID)#"></cfoutput>
			</cfif></TD>
			<TD><cfif SESSION.UserLocaleID IS "1" and FormLanguageID IS APPLICATION.DefaultLanguageID><cfoutput><input type="checkbox" name="ResourceDelete_#fi#" value="1"></cfoutput></cfif>
			</TD></TR><input type="hidden" name="ResourceID_#fi#" value="#URLEncodedFormat(Encrypt(aProductView[fi].ResourceID,APPLICATION.Key))#"></cfoutput>
		<cfelse>
			<cfoutput><TR>
			<TD>#aProductView[fi].ResourceName#</TD>
			<TD>#aProductView[fi].ResourceText#</TD>
			<TD>
			Main:<BR><img src="#aProductView[fi].MainFilePath#"><input type="hidden" name="MainFilePath_#fi#" value="#aProductView[fi].MainFilePath#"><BR>
			Thumbnail:<BR><img src="#aProductView[fi].ThumbnailFilePath#"><input type="hidden" name="ThumbnailFilePath_#fi#" value="#aProductView[fi].ThumbnailFilePath#"></TD><TD></TD>
			
			<TD><cfloop query="qSpecificationType"><cfif qSpecificationType.LabelID IS aProductView[fi].SpecificationSetID>#qSpecificationType.LabelName#</cfif></cfloop></TD>
			<TD>
			<input type="hidden" name="ResourceSpecificationSetID_#fi#" value="#HTMLEditFormat(aProductView[fi].SpecificationSetID)#">
			<input type="hidden" name="ResourceName_#fi#" value="#HTMLEditFormat(aProductView[fi].ResourceName)#">
			<input type="hidden" name="ResourceText_#fi#" value="#HTMLEditFormat(aProductView[fi].ResourceText)#">
			<input type="hidden" name="ResourceID_#fi#" value="#URLEncodedFormat(Encrypt(aProductView[fi].ResourceID,APPLICATION.Key))#"></TD></tR></cfoutput>
		</cfif>
	</cfloop>
	<cfoutput><input type="hidden" name="NumViews" value="#fi#"></cfoutput>
	<cfif FormMode IS "ShowForm" and ShowAdmin>
		<tr valign="top">
			<TD>
			<input type="text" name="ResourceName_New" value="" size="20" maxlength="128">
			</TD>
			<TD>
			<textarea cols="20" rows="5" name="ResourceText_New"></textarea>
			</TD>
			<TD>Main:<BR>
			<input type="file" name="MainFilePath_NewFileObject"><br>
			Thumbnail:<BR>
			<input type="file" name="ThumbnailFilePath_NewFileObject"></TD><TD></TD>
			
			<TD>
			<select name="ResourceSpecificationSetID_new">
			<cfoutput query="qSpecificationType">
				<option value="#LabelID#">#LabelName#</option>
			</cfoutput>
			</select>
			</TD>
			<TD></TD></TR>
		
		<TR><TD colspan="5" align="right"><input type="submit" value="Update Views"></TD></TR>
	</cfif>
	
	</table>
	</TD></TR>
	<cfinvoke component="/lifefitness/com/Product/ProductFamilyHandler" 
		method="GetProductFamilyAttributeStructure"
		returnVariable="sGetProductFamilyAttribute"
		CategoryID="#MyProduct.GetProductFamilyID()#"
		LanguageID="#FormLanguageID#">
	
	<cfinvoke component="/lifefitness/com/utils/database" method="GenericLookup" returnVariable="qOptions">
		<cfinvokeargument name="datasource" value="#APPLICATION.DSN#">
		<cfinvokeargument name="TableName" value="t_Label">
		<cfinvokeargument name="FieldName" value="labelGroupID">
		<cfinvokeargument name="FieldValue" value="120">
		<cfinvokeargument name="SortFieldName" value="LabelPriority">
		<cfinvokeargument name="SortOrder" value="Asc">
	</cfinvoke>
	<TR><TD bgcolor="bac0c9" colspan="3"><b>Attributes</b></TD></TR>
	<cfif FormLanguageID IS NOT APPLICATION.DefaultLanguageID and qProductLanguages.RecordCount GTE "1">
		<TR><TD bgcolor="bac0c9" colspan="3" align="right">Load Product Specifications Only From: 
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
	
	<TR><TD bgcolor="bac0c9"></TD><TD colspan="2" bgcolor="EAEAEA">
	<cfset aProductAttribute=MyProduct.GetProperty("aProductAttribute")>
	<table width="100%">
	
	<TR><TD><strong>Name</strong></TD><TD><strong>Value</strong></TD></TR>
	
	
	<cfloop index="fi" from="1" to="#ArrayLen(aProductAttribute)#" step="1">
		<cfif StructKeyExists(sGetProductFamilyAttribute,aProductAttribute[fi].ProductFamilyAttributeID)>
			<cfif FormMode IS "ShowForm">
				<tr valign="top"><TD>
				<cfswitch expression="#aProductAttribute[fi].ProductFamilyAttributeTypeID#">
					<cfcase value="600"><b></cfcase><cfcase value="601">&nbsp;&nbsp;</cfcase><cfdefaultcase>&nbsp;&nbsp;&nbsp;&nbsp;</cfdefaultcase>
				</cfswitch>
				<cfoutput>#sGetProductFamilyAttribute[aProductAttribute[fi].ProductFamilyAttributeID]#</cfoutput></TD>
				<TD>
				<cfif aProductAttribute[fi].ProductFamilyAttributeTypeID IS "603">
					<cfoutput><input type="text" name="AttributeValue_#fi#" value="#HTMLEditFormat(aProductAttribute[fi].AttributeValue)#" size="80" maxlength="1000"></cfoutput>
				<cfelseif aProductAttribute[fi].ProductFamilyAttributeTypeID IS "602">
					<cfoutput><select name="AttributeValueID_#fi#"></cfoutput>
						<cfoutput query="qOptions">
							<option value="#labelID#" <cfif aProductAttribute[fi].AttributeValueID IS LabelID>selected</cfif>>#LabelName#</option>
						</cfoutput>
					</select>
				</cfif></TD></TR>
			<cfelse>
				<TR><TD><cfswitch expression="#aProductAttribute[fi].ProductFamilyAttributeTypeID#">
					<cfcase value="600"></cfcase><cfcase value="601">&nbsp;&nbsp;</cfcase><cfdefaultcase>&nbsp;&nbsp;&nbsp;&nbsp;</cfdefaultcase>
				</cfswitch>
				<cfoutput>#sGetProductFamilyAttribute[aProductAttribute[fi].ProductFamilyAttributeID]#</cfoutput></TD>
				<TD>
				<cfif aProductAttribute[fi].ProductFamilyAttributeTypeID IS "603">
					<cfoutput>#aProductAttribute[fi].AttributeValue#</cfoutput>
				<cfelseif aProductAttribute[fi].ProductFamilyAttributeTypeID IS "602">
					<cfoutput query="qOptions">
						<cfif aProductAttribute[fi].AttributeValueID IS LabelID>#LabelName#</cfif>
					</cfoutput>
				</cfif>
				</TD></tR>
				<cfoutput><input type="hidden" name="AttributeValue_#fi#" value="#HTMLEditFormat(aProductAttribute[fi].AttributeValue)#" size="80">
				<input type="hidden" name="AttributeValueID_#fi#" value="#aProductAttribute[fi].AttributeValueID#"></cfoutput>
			</cfif>
			<cfoutput>
				<input type="hidden" name="ProductFamilyAttributeID_#fi#" value="#URLEncodedFormat(Encrypt(aProductAttribute[fi].ProductFamilyAttributeID,APPLICATION.Key))#">
				<input type="hidden" name="ProductFamilyAttributeTypeID_#fi#" value="#URLEncodedFormat(Encrypt(aProductAttribute[fi].ProductFamilyAttributeTypeID,APPLICATION.Key))#">
			</cfoutput>
		</cfif>
	</cfloop>
	<cfoutput><input type="hidden" name="NumAttributes" value="#ArrayLen(aProductAttribute)#"></cfoutput>
	</table>
	
	</TD></TR>

<cfelse><!--- Console Options --->
	
	<cfif FormLanguageID IS NOT APPLICATION.DefaultLanguageID and qProductLanguages.RecordCount GTE "1">
		<TR><TD bgcolor="bac0c9" colspan="3" align="right">Load Console Data From: 
		<select name="plclid4">
			<option value="-1">Select...</option>
			<cfoutput query="qProductLanguages">
				<cfif FormLanguageID IS NOT LanguageID>
					<option value="#REQUEST.SimpleEncrypt(LanguageID)#">#LanguageName#</option>
				</cfif>
			</cfoutput>
		</select> <!--- <input type="submit" name="ButLoad2" value="Load"> --->
		<input type="submit" name="ButLoad4" value="Load"></TD></TR>
	</cfif>

	<cfloop index="PCI" from="1" to="#ArrayLen(aProductCombination)#" step="1">
		<input type="Hidden" name="CombinationID_#PCI#" value="#REQUEST.SimpleEncrypt(aProductCombination[pci].GetProperty('CombinationID'))#">
		<cfoutput><TR><TD colspan="3" bgcolor="bac0c9"><strong>Console: #aProductCombination[pci].GetProductName2()#</strong></TD></TR></cfoutput>
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="Product Combination Description" 
			DefaultValue="#aProductCombination[pci].GetProperty('ProductCombinationDescription')#"
			VarName="ProductCombinationDescription_#PCI#"
			cols="80" rows="7"
			EscapeCRLF="No"
			Required="N">
		
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="textarea"
			caption="Product Combination Detail" 
			DefaultValue="#aProductCombination[pci].GetProperty('ProductCombinationDetail')#"
			VarName="ProductCombinationDetail_#PCI#"
			cols="80" rows="7"
			EscapeCRLF="No"
			Required="N">
			
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Product Combination Price" 
			DefaultValue="#aProductCombination[pci].GetProperty('ProductCombinationPrice')#"
			VarName="ProductCombinationPrice_#PCI#"
			size="20" maxlength="20"
			Required="N">
			
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="text"
			caption="Call To Action URL" 
			DefaultValue="#aProductCombination[pci].GetProperty('ProductCombinationCallToActionURL')#"
			VarName="ProductCombinationCallToActionURL_#PCI#"
			size="80" maxlength="255"
			Required="N">
			
		<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
			ObjectAction="#FormMode#"
			type="checkbox"
			caption="Active" 
			VarName="ProductCombinationActive_#PCI#"
			DefaultValue="#aProductCombination[pci].GetProperty('ProductCombinationActive')#">
			
		<cfset sImageName=StructNew()>
		<cfset StructInsert(sImageName,"ProductCombinationThumbnailPath","Thumbnail Image",1)>
		<cfset StructInsert(sImageName,"ProductCombinationThumbnailHoverPath","Thumbnail Hover Image",1)>
		<cfset StructInsert(sImageName,"ProductCombinationImagePath","Image",1)>
		<cfset StructInsert(sImageName,"ProductCombinationOverheadImagePath","Overhead View",1)>
		<cfset StructInsert(sImageName,"ProductCombinationFlashPath","Flash",1)>
		<cfset StructInsert(sImageName,"ProductCombinationFlashZoomPath","Flash (Zoom)",1)>
		
		<cfloop index="ThisImage" list="ProductCombinationThumbnailPath,ProductCombinationImagePath,ProductCombinationFlashPath,ProductCombinationFlashZoomPath,ProductCombinationOverheadImagePath">
			<cfif ShowAdmin>
				<cfset ThisFormMode=FormMode>
			<cfelse>
				<cfset ThisFormMode="validate">
			</cfif>
			<cfparam name="Delete#ThisImage#_#PCI#" default="0">
			<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
				ObjectAction="#ThisFormMode#"
				type="File"
				caption="#sImageName[ThisImage]#" 
				DefaultValue="#aProductCombination[pci].GetProperty(ThisImage)#"
				VarName="#ThisImage#_#PCI#"
				Required="N">
			<cfif aProductCombination[pci].GetProperty("#ThisImage#") is not "" and ShowAdmin>
				<cfmodule template="/common/modules/utils/DisplayFormElt.cfm"
					ObjectAction="#FormMode#"
					type="checkbox" 
					caption="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete?"
					DefaultValue="#Val(evaluate('Delete#ThisImage#_#PCI#'))#"
					VarName="Delete#ThisImage#_#PCI#"
					Required="N">
			</cfif>
		</cfloop>
		
		<cfif 0>
			<TR><TD bgcolor="EAEAEA">&nbsp;</TD><Td colspan="2">
				<cfinclude template="/common/modules/product/_ProductCombinationFeatureForm.cfm">
			</TD></TR>
		</cfif>
	</cfloop>
	<cfoutput><input name="NumCombinations" value="#ArrayLen(aProductCombination)#" type="hidden"></cfoutput>

</cfif>


<cfif OpenAndCloseFormTables></table></cfif>