<cfsilent>
<cfparam name="ATTRIBUTES.ObjectAction" default="ShowForm">
<cfparam name="ATTRIBUTES.Caption" default="DefaultCaption">
<cfparam name="ATTRIBUTES.CaptionClass" default="allcaps">
<cfparam name="ATTRIBUTES.ObjectName" default="">
<cfparam name="ATTRIBUTES.VarName" default="">
<cfparam name="ATTRIBUTES.PropertyName" default="">
<cfif ATTRIBUTES.PropertyName IS NOT "" AND ATTRIBUTES.VarName IS "">
	<cfset ATTRIBUTES.VarName="#ATTRIBUTES.PropertyName#">
</cfif>
<cfif ATTRIBUTES.ObjectName Is "">
	<cfparam name="ATTRIBUTES.DefaultValue" default="">
<cfelse>
	<cfparam name="ATTRIBUTES.DefaultValue" default="#CALLER[ATTRIBUTES.ObjectName].GetProperty(ATTRIBUTES.PropertyName)#">
</cfif>
<cfparam name="ATTRIBUTES.Checked" default="1">
<cfparam name="ATTRIBUTES.Required" default="N">
<cfparam name="ATTRIBUTES.EmailAddress" default="N">
<cfparam name="ATTRIBUTES.Numeric" default="N">
<cfparam name="ATTRIBUTES.Money" default="N">
<cfif ATTRIBUTES.Money IS "Y">
	<cfset ATTRIBUTES.Numeric="y">
</cfif>
<cfparam name="ATTRIBUTES.Date" default="N">
<cfparam name="ATTRIBUTES.DateTime" default="N">
<cfparam name="ATTRIBUTES.ValidationMessage" default="Please enter a value.">
<cfparam name="ATTRIBUTES.EmailAddressValidationMessage" default="Please enter a valid email address.">
<cfparam name="ATTRIBUTES.DateValidationMessage" default="Please enter a valid date.">
<cfparam name="ATTRIBUTES.NumericValidationMessage" default="Please enter a valid number.">
<cfparam name="ATTRIBUTES.CreditCardValidationMessage" default="<font color=""White"">Please enter a valid credit card number.</font>">
<cfparam name="ATTRIBUTES.BlankMessage" default="">
<cfparam name="ATTRIBUTES.MaxChars" default="-1">
<cfparam name="ATTRIBUTES.MaxCharsValidationMessage" default="Please make your response shorter.">
<cfparam name="ATTRIBUTES.ValidationColor" default="bac0c9"><!--- cc0000 --->
<cfparam name="ATTRIBUTES.TDBGColor1" default="white"><!--- cc0000 --->
<cfparam name="ATTRIBUTES.TDBGColor2" default="white"><!--- cc0000 --->
<cfif IsDefined("APPLICATION.ValidationColor")>
	<cfset ATTRIBUTES.ValidationColor="#APPLICATION.ValidationColor#">
</cfif>
<cfparam name="ATTRIBUTES.Size" default="40">
<cfparam name="ATTRIBUTES.Cols" default="30">
<cfparam name="ATTRIBUTES.Rows" default="4">
<cfparam name="ATTRIBUTES.MaxLength" default="100">
<cfparam name="ATTRIBUTES.FormEltStyle" default="">
<cfparam name="ATTRIBUTES.FormEltJavaScript" default="">
<cfparam name="ATTRIBUTES.RequiredMark" default="<B>*</B>">
<cfparam name="ATTRIBUTES.CreditCard" default="N">
<cfparam name="ATTRIBUTES.CCType" default="">
<cfparam name="ATTRIBUTES.LongCaption" default="N">
<cfparam name="ATTRIBUTES.ForceError" default="N">
<cfparam name="ATTRIBUTES.ForceErrorMessage" default="">
<cfparam name="ATTRIBUTES.CaptionOnTop" default="N">
<cfparam name="ATTRIBUTES.SupressView" default="N">
<cfparam name="ATTRIBUTES.valign" default="top">
<cfparam name="ATTRIBUTES.EscapeCRLF" default="Y">
<cfparam name="ATTRIBUTES.ImageExtensionList" default=".jpg,.gif,.jpeg,.jpe,,.png">
<cfparam name="ATTRIBUTES.FormEltOnly" default="N">
<cfparam name="ATTRIBUTES.ForceShowForm" default="N">
<cfparam name="ATTRIBUTES.YesMark" default="Yes">
<cfparam name="ATTRIBUTES.NoMark" default="No">
</cfsilent>
<cfoutput>
<cfsilent>
<cfset message="">
<cfset ShowForm="0">
<cfif ATTRIBUTES.ObjectAction IS "ShowForm">
	<cfset ShowForm="1">
	<cfset Message="">
	<cfif ATTRIBUTES.Date IS "Y" and ATTRIBUTES.DefaultValue IS NOT "" AND IsDate(ATTRIBUTES.DefaultValue)>
		<cfset ATTRIBUTES.DefaultValue=DateFormat(ATTRIBUTES.DefaultValue,"mmmm d, yyyy")>
	</cfif>
	<cfif ATTRIBUTES.DateTime IS "Y" and ATTRIBUTES.DefaultValue IS NOT "" AND IsDate(ATTRIBUTES.DefaultValue)>
		<cfset ATTRIBUTES.DefaultValue="#DateFormat(ATTRIBUTES.DefaultValue,'mmmm d, yyyy')# #TimeFormat(ATTRIBUTES.DefaultValue)#">
	</cfif>
<cfelseif ATTRIBUTES.ObjectAction IS "Validate">
	<cfif ATTRIBUTES.ObjectName is not "">
		<cfif CALLER[ATTRIBUTES.ObjectName].IsInError(ATTRIBUTES.PropertyName)>
			<cfset ShowForm="1">
			<cfset Message=CALLER[ATTRIBUTES.ObjectName].getErrorMessage(ATTRIBUTES.PropertyName)>
		</cfif>
	<cfelse>
		<cfif ATTRIBUTES.ForceError IS "Y">
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.ForceErrorMessage#">
		</cfif>
		<cfif ATTRIBUTES.Required IS "Y" AND ATTRIBUTES.DefaultValue IS "-1" AND ATTRIBUTES.type IS "select">
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.ValidationMessage#">
		</cfif>
		<cfif ATTRIBUTES.Required IS "Y" AND ATTRIBUTES.DefaultValue IS "-1" AND ATTRIBUTES.type IS "MultiSelect">
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.ValidationMessage#">
		</cfif>
		<cfif ATTRIBUTES.Required IS "Y" AND Trim(ATTRIBUTES.DefaultValue) IS "" AND ATTRIBUTES.type IS NOT "file">
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.ValidationMessage#">
		</cfif>
		<cfif ATTRIBUTES.Required IS "Y" and ATTRIBUTES.type IS "file" AND Trim(FORM["#ATTRIBUTES.varName#FileObject"]) IS "">
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.ValidationMessage#">
		</cfif>
		<cfif ATTRIBUTES.EmailAddress IS "Y" AND Trim(ATTRIBUTES.DefaultValue) IS NOT "">
			<cfmodule name="3w.errorcheck.validateemail" email="#ATTRIBUTES.DefaultValue#">
			<cfif ValidateEmailStatus GTE "200">
				<cfset ShowForm="1">
				<cfset Message="#ATTRIBUTES.EmailAddressValidationMessage#">
			</cfif>
		</cfif>
		<cfif ATTRIBUTES.Numeric IS "Y" AND NOT IsNumeric(ATTRIBUTES.DefaultValue) AND ATTRIBUTES.DefaultValue GT "0">
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.NumericValidationMessage#">
		</cfif>
		<cfif ATTRIBUTES.Date IS "Y" AND Trim(ATTRIBUTES.DefaultValue) IS NOT "">
			<cfif IsDate(ATTRIBUTES.DefaultValue)>
				<cfset ATTRIBUTES.DefaultValue=DateFormat(ATTRIBUTES.DefaultValue,"mmm d, yyyy")>
			<cfelse>
				<cfset ShowForm="1">
				<cfset Message="#ATTRIBUTES.DateValidationMessage#">
			</cfif>
		</cfif>
		<cfif ATTRIBUTES.DateTime IS "Y" AND Trim(ATTRIBUTES.DefaultValue) IS NOT "">
			<cfif IsDate(ATTRIBUTES.DefaultValue)>
				<cfset ATTRIBUTES.DefaultValue="#DateFormat(ATTRIBUTES.DefaultValue,'mmm d, yyyy')# #TimeFormat(ATTRIBUTES.DefaultValue)#">
			<cfelse>
				<cfset ShowForm="1">
				<cfset Message="#ATTRIBUTES.DateValidationMessage#">
			</cfif>
		</cfif>
		<cfif Val(ATTRIBUTES.MaxChars) GT "0" AND Len(Trim(ATTRIBUTES.DefaultValue)) GT Val(ATTRIBUTES.MaxChars)>
			<cfset ShowForm="1">
			<cfset Message="#ATTRIBUTES.MaxCharsValidationMessage#">
		</cfif>
		<cfif ATTRIBUTES.CreditCard IS "Y">
			<cfif Len(Trim(ATTRIBUTES.DefaultValue)) IS NOT "0">
				<cfmodule name="mod10" CCType="#ATTRIBUTES.CCType#" CCNum="#ATTRIBUTES.DefaultValue#" expDate="">
				<cfif NOT Valid>
					<cfset ShowForm="1">
					<cfset Message="#ATTRIBUTES.CreditCardValidationMessage#">
				</cfif>
			</cfif>
		</cfif>
		<cfif Len(ATTRIBUTES.Required) GT "2"><!--- Expression rather than boolean --->
			<cfset Result=ATTRIBUTES.Required>
			<cfif ATTRIBUTES.type IS "select">
				<cfif Result>
					<cfif ATTRIBUTES.DefaultValue GT "0">
					<cfelse>
						<cfset ShowForm="1">
						<cfset Message="#ATTRIBUTES.ValidationMessage#">
					</cfif>
				</cfif>
			<cfelse>
				<cfif Result>
					<cfif ATTRIBUTES.DefaultValue IS NOT "">
					<cfelse>
						<cfset ShowForm="1">
						<cfset Message="#ATTRIBUTES.ValidationMessage#">
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	<cfif ATTRIBUTES.ForceShowForm IS "Y">
		<cfset ShowForm="1"><!--- Always show form --->
	</cfif>
</cfif>
</cfsilent>
<cfif message IS NOT "">
	<!--- Throw error --->
	<cfif ATTRIBUTES.FormEltOnly IS "N">
		<cfset TRTag="<tr valign=""#ATTRIBUTES.valign#"" bgcolor=""#ATTRIBUTES.ValidationColor#"">">
		#TRTag#
	</cfif>
	<cfset Caller.ErrorField="#Trim(ATTRIBUTES.VarName)#">
	<cfset Message="<span class=""error"" style=""color:red"">#Message#</span>">
<cfelse>
	<cfif ATTRIBUTES.FormEltOnly IS "N">
		<cfset TRTag="<tr valign=""#ATTRIBUTES.valign#"">">
		#TRTag#
	</cfif>
	<cfset Caller.ErrorField="">
</cfif>
<cfif ATTRIBUTES.FormEltOnly IS "N">
	<cfif Trim(ATTRIBUTES.type) IS NOT "checkbox2" AND ATTRIBUTES.Caption IS NOT "">
		<cfif ATTRIBUTES.LongCaption IS "Y">
			<cfif ATTRIBUTES.REQUIRED IS "Y" OR (ATTRIBUTES.ObjectAction IS "ShowForm" AND Message IS NOT "")>
				<cfset MarkPlaceHolder="#ATTRIBUTES.RequiredMark#">
			<cfelse>
				<cfset MarkPlaceHolder="">
			</cfif>
			<cfif ATTRIBUTES.Version IS "1">
				<TD bgcolor="#ATTRIBUTES.TDBGColor1#">#MarkPlaceHolder#</TD><TD nowrap <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif> bgcolor="#ATTRIBUTES.TDBGColor1#" colspan="2">#ATTRIBUTES.Caption#<cfif ATTRIBUTES.ObjectAction IS "ShowForm"><img src="/common/images/spacer.gif" height="15" width="1"></cfif>&nbsp;</TD></TR>#TRTag#<TD bgcolor="#ATTRIBUTES.TDBGColor1#">&nbsp;</TD>
				<cfset TDColspan="colspan=""2""">
			<cfelseif ATTRIBUTES.Version IS "2">
				<TD nowrap colspan="3" <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif> bgcolor="#ATTRIBUTES.TDBGColor1#">#ATTRIBUTES.Caption#<img src="/common/images/spacer.gif" height="15" width="1">#MarkPlaceHolder#&nbsp;</TD></TR>#TRTag#
			<cfelse>
				<TD bgcolor="#ATTRIBUTES.TDBGColor1#">#MarkPlaceHolder#</TD><TD nowrap <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif> bgcolor="#ATTRIBUTES.TDBGColor1#" colspan="2">#ATTRIBUTES.Caption#<cfif ATTRIBUTES.ObjectAction IS "ShowForm"><img src="/common/images/spacer.gif" height="15" width="1"></cfif>&nbsp;<br />
				<cfset TDColspan="colspan=""2""">
				<cfset BeginningTag="">
			</cfif>
		<cfelse>
			<TD bgcolor="#ATTRIBUTES.TDBGColor1#"><cfif ATTRIBUTES.ObjectAction IS "ShowForm" and (ATTRIBUTES.REQUIRED IS "Y" OR message IS NOT "")>#ATTRIBUTES.RequiredMark#</cfif></TD><TD nowrap bgcolor="#ATTRIBUTES.TDBGColor1#" <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif>>#Trim(ATTRIBUTES.Caption)#<cfif ATTRIBUTES.ObjectAction IS "ShowForm"><img src="/common/images/spacer.gif" height="15" width="1"></cfif>&nbsp;</TD>
		</cfif>
	</cfif>
	<cfif ATTRIBUTES.CaptionOnTop IS "Y">
		</TR>#TRTag#
	</cfif>
</cfif>
<cfif ATTRIBUTES.FormEltOnly IS "N">
	<cfparam name="TDColspan" default="">
	<cfif ATTRIBUTES.LongCaption IS "Y" AND ATTRIBUTES.Version IS "3">
		<cfset BeginningTag="">
	<cfelse>
		<cfif ShowForm>
			<cfset BeginningTag="<Td bgcolor=""#ATTRIBUTES.TDBGColor2#"" #TDColspan# nowrap>">
		<cfelse>
			<cfset BeginningTag="<Td bgcolor=""#ATTRIBUTES.TDBGColor2#"" #TDColspan#>">
		</cfif>
	</cfif>
	<cfset EndTag="</TD>">
<cfelse>
	<cfset BeginningTag="">
	<cfset EndTag="">
</cfif>
<cfif NOT ShowForm>
	<cfset BeginningTag="#BeginningTag#[">
	<cfset EndTag="]#EndTag#">
</cfif>
<cfif ATTRIBUTES.ObjectAction IS "View">
	#BeginningTag# <cfif ATTRIBUTES.DefaultValue IS "">none<cfelse>#ATTRIBUTES.DefaultValue#</cfif> #EndTag#
<cfelse>
	<cfswitch expression="#Trim(ATTRIBUTES.type)#">
		<cfcase value="view">
		#BeginningTag##ATTRIBUTES.DefaultValue##EndTag#
		</cfcase>
		<cfcase value="viewYesNo">
		#BeginningTag##YesNoFormat(ATTRIBUTES.DefaultValue)##EndTag#
		</cfcase>
		<cfcase value="text,password" delimiters=",">
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ATTRIBUTES.ObjectAction IS "Validate">
				<!--- Show input only when: 1) ShowForm  or 2) value is not required
				or 3) when validating, required value is empty  --->
				<cfif ShowForm>
					<input type="#Trim(ATTRIBUTES.type)#" name="#ATTRIBUTES.VarName#" value="#htmleditformat(ATTRIBUTES.DefaultValue)#" size="#ATTRIBUTES.Size#" maxlength="#ATTRIBUTES.MaxLength#" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"</cfif><cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>&nbsp;<cfif Len(trim(Message)) IS NOT "0"><br />#Message#</cfif>
				<cfelse>
					<cfif ATTRIBUTES.CreditCard IS "Y">
						<cfif Len(trim(ATTRIBUTES.DefaultValue)) gt "5">#ReReplace(Mid(ATTRIBUTES.DefaultValue,1,Len(ATTRIBUTES.DefaultValue)-4),"[0-9]","##","All")##right(ATTRIBUTES.DefaultValue,4)#<br /></cfif><cfset SESSION.FooBar=ATTRIBUTES.DefaultValue>
					<cfelse>
						<cfif TRim(ATTRIBUTES.DefaultValue) IS ""><cfif ATTRIBUTES.BlankMessage IS NOT "">#ATTRIBUTES.BlankMessage#</cfif><cfelse><cfif ATTRIBUTES.Money IS "N"><cfif ATTRIBUTES.type IS "Password"><cfloop index="i" from="1" to="#Len(ATTRIBUTES.DefaultValue)#">*</cfloop><cfelse>#ATTRIBUTES.DefaultValue#</cfif><cfelse>#DollarFormat(Val(ATTRIBUTES.DefaultValue))#</cfif></cfif><input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
					</cfif>
				</cfif>
			</cfif>#EndTag#
		</cfcase>
		<cfcase value="checkbox">
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ShowForm>
				<input type="checkbox" name="#ATTRIBUTES.VarName#" value="1" <cfif (IsDefined("CALLER.#ATTRIBUTES.VarName#") AND Val(CALLER[ATTRIBUTES.VarName])) OR Val(ATTRIBUTES.DefaultValue)>checked</cfif> <cfif ATTRIBUTES.FormEltStyle IS NOT ""> style="#ATTRIBUTES.FormEltStyle#"<cfelse> class="checkbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>
			<cfelse>
				<cfif ATTRIBUTES.ObjectName is not "">
					<cfset CheckMe=CALLER[ATTRIBUTES.ObjectName].GetProperty(ATTRIBUTES.PropertyName)>
				<cfelse>
					<cfif IsDefined("CALLER.#ATTRIBUTES.VarName#")>
						<cfset CheckMe=CALLER[ATTRIBUTES.VarName]>
					<cfelse>
						<cfset CheckMe="0">
					</cfif>
				</cfif>
				#YesNoFormat(CheckMe)#<input type="hidden" name="#ATTRIBUTES.VarName#" value="#CheckMe#">
			</cfif>
			#EndTag#
		</cfcase>
		<cfcase value="YesNo">
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ShowForm>
				<cfif (IsDefined("CALLER.#ATTRIBUTES.VarName#") AND CALLER[ATTRIBUTES.VarName]) OR ATTRIBUTES.DefaultValue>
					<cfset Checked="1">
				<cfelse>
					<cfset Checked="0">
				</cfif>
				<input type="radio" name="#ATTRIBUTES.VarName#" value="1" <cfif Checked>checked</cfif> <cfif ATTRIBUTES.FormEltStyle IS NOT ""> style="#ATTRIBUTES.FormEltStyle#"<cfelse> class="checkbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>> <span style="width:40px;">#ATTRIBUTES.YesMark#</span>
				&nbsp;&nbsp;&nbsp; <input type="radio" name="#ATTRIBUTES.VarName#" value="0" <cfif NOT Checked>checked</cfif> <cfif ATTRIBUTES.FormEltStyle IS NOT ""> style="#ATTRIBUTES.FormEltStyle#"<cfelse> class="checkbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>> <span style="width:40px;">#ATTRIBUTES.NoMark#</span>
			<cfelse>
				<cfif ATTRIBUTES.ObjectName is not "">
					<cfset CheckMe=CALLER[ATTRIBUTES.ObjectName].GetProperty(ATTRIBUTES.PropertyName)>
				<cfelse>
					<cfif IsDefined("CALLER.#ATTRIBUTES.VarName#")>
						<cfset CheckMe=CALLER[ATTRIBUTES.VarName]>
					<cfelse>
						<cfset CheckMe="0">
					</cfif>
				</cfif>
				#YesNoFormat(CheckMe)#<input type="hidden" name="#ATTRIBUTES.VarName#" value="#CheckMe#">
			</cfif>
			#EndTag#
		</cfcase>

		<cfcase value="checkbox2">
			<TD bgcolor="#ATTRIBUTES.TDBGColor2#">
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm">
				<input type="checkbox" name="#ATTRIBUTES.VarName#" value="1" <cfif IsDefined("#ATTRIBUTES.VarName#") >checked</cfif> <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"<cfelse>class="checkbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>
			<cfelse>
				<cfif IsDefined("#ATTRIBUTES.VarName#")>
					<cfset CheckMe=variables[ATTRIBUTES.VarName]>
				<cfelse>
					<cfset CheckMe="0">
				</cfif>
				#YesNoFormat(CheckMe)#<input type="hidden" name="#ATTRIBUTES.VarName#" value="#CheckMe#">
			</cfif>
			</TD>
			<TD bgcolor="#ATTRIBUTES.TDBGColor2#">#ATTRIBUTES.Caption#</TD>
		</cfcase>
		<cfcase value="textarea">
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ATTRIBUTES.ObjectAction IS "Validate">
				<!--- Show input only when: 1) ShowForm  or 2) value is not required
				or 3) when validating, required value is empty  --->
				<cfif ShowForm>
					<textarea cols="#ATTRIBUTES.Cols#" rows="#ATTRIBUTES.Rows#" name="#ATTRIBUTES.VarName#" wrap="virtual" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"<cfelse>class="textarea"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>#HTMLEditFormat(ATTRIBUTES.DefaultValue)#</textarea>
					<cfif Len(trim(Message)) IS NOT "0"><br />#Message#</cfif>
				<cfelse>
					<cfif Trim(ATTRIBUTES.DefaultValue) IS "">&nbsp;<cfelse>
					<cfif ATTRIBUTES.EscapeCRLF IS "Y">#Replace(ATTRIBUTES.DefaultValue,"#Chr(10)#", "<br />","ALL")#<cfelse>#ATTRIBUTES.DefaultValue#</cfif></cfif><input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
				</cfif>
			</cfif>
			#EndTag#
		</cfcase>
		<cfcase value="select"><!--- single select --->
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ATTRIBUTES.ObjectAction IS "Validate">
				<!--- Show input only when: 1) ShowForm  or 2) value is not required
				or 3) when validating, required value is empty  --->
				<cfif ShowForm>
					<cfif ListLen(ATTRIBUTES.OptionValues,"}^^{") IS NOT "1" OR 1><!--- "or 1" Fix for one elt option lists --->
						<select name="#ATTRIBUTES.VarName#" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"<cfelse>class="select"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>
							<option value="-1">select...</option>
							<cfif ATTRIBUTES.Required IS NOT "Y">
								<option value="-1" <cfif ATTRIBUTES.DefaultValue IS "-1">selected</cfif>></option>
							</cfif>
							<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{"><option value="#GetToken(i,1,'|')#" <cfif ATTRIBUTES.DefaultValue IS GetToken(i,1,'|')>selected</cfif>>#GetToken(i,2,'|')#</option></cfloop>
						</select><cfif Len(trim(Message)) IS NOT "0"><br />#Message#</cfif>
					<cfelse>
						<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{"><cfif ATTRIBUTES.DefaultValue IS GetToken(i,1,'|')>#GetToken(i,2,'|')#</cfif></cfloop>
						<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
					</cfif>
				<cfelse>
					<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{"><cfif ATTRIBUTES.DefaultValue IS GetToken(i,1,'|')>#ReplaceNoCase(GetToken(i,2,'|'),"&nbsp;","","All")#</cfif></cfloop><input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
				</cfif>
			</cfif>
			#EndTag#
		</cfcase>
		<cfcase value="MultiSelect"><!--- Multiple select --->
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ATTRIBUTES.ObjectAction IS "Validate">
				<!--- Show input only when: 1) ShowForm  or 2) value is not required
				or 3) when validating, required value is empty  --->
				<cfif ShowForm>
					<select name="#ATTRIBUTES.VarName#" multiple size="#ATTRIBUTES.Size#" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>
						<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{"><option value="#GetToken(i,1,'|')#" <cfif ListFindNoCase(ATTRIBUTES.DefaultValue,GetToken(i,1,'|'))>selected</cfif>>#GetToken(i,2,'|')#</option></cfloop>
					</select><cfif Len(trim(Message)) IS NOT "0"><br />#Message#</cfif>
				<cfelse>
				<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{"><cfif ListFindNoCase(ATTRIBUTES.DefaultValue,GetToken(i,1,'|'))>#GetToken(i,2,'|')#</cfif></cfloop>
				<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
				</cfif>
			</cfif>
			#EndTag#
		</cfcase>
		<cfcase value="File">
			#BeginningTag#
			<cfif ATTRIBUTES.ObjectAction IS "ShowForm" OR ATTRIBUTES.ObjectAction IS "Validate">
				<!--- Show input only when: 1) ShowForm  or 2) value is not required
				or 3) when validating, required value is empty  --->
				<cfif ShowForm>
					<cfif FileExists(ExpandPath(ATTRIBUTES.DefaultValue)) and ATTRIBUTES.SupressView IS NOT "Y">
						<cfif ListFindNoCase(ATTRIBUTES.ImageExtensionList,".#ListLast(ATTRIBUTES.DefaultValue,'.')#") GT "0">
							<img src="#ATTRIBUTES.DefaultValue#"  border="1"><br />
						<cfelse>
							<a target="_blank" href="#ATTRIBUTES.DefaultValue#">#ListLast(ATTRIBUTES.DefaultValue,"/")#</a><br />
						</cfif>
					</cfif>
					<input type="file" name="#ATTRIBUTES.VarName#FileObject" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"<cfelse>class="textbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif> size="#ATTRIBUTES.Size#">
					<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
					<cfif Len(trim(Message)) IS NOT "0"><br />#Message#</cfif>
				<cfelse>
					<cfparam name="FORM.#ATTRIBUTES.VarName#FileObject" default="">
					<cfif Trim(FORM["#ATTRIBUTES.varName#FileObject"]) IS "" or ATTRIBUTES.ObjectName IS NOT "">
						<cfif FileExists(ExpandPath(ATTRIBUTES.DefaultValue)) and ATTRIBUTES.SupressView IS NOT "Y">
							<cfif ListFindNoCase(ATTRIBUTES.ImageExtensionList,".#ListLast(ATTRIBUTES.DefaultValue,'.')#") GT "0">
								<img src="#ATTRIBUTES.DefaultValue#"  border="1"><br />
							<cfelse>
								<a target="_blank" href="#ATTRIBUTES.DefaultValue#">#ListLast(ATTRIBUTES.DefaultValue,"/")#</a><br />
							</cfif>
						</cfif>
						<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
						<cfset CALLER.FileServerPath="">
					<cfelseif isdefined("ATTRIBUTES.Tempdir") and ATTRIBUTES.Tempdir IS NOT "">
						<cffile action="UPLOAD"
							filefield="#ATTRIBUTES.VarName#FileObject"
							destination="#ATTRIBUTES.Tempdir#"
							nameconflict="OVERWRITE">
						<cfset FileServerPath=application.utilsObj.ScrubUploadedFileName(File.ServerDirectory,File.ServerFile)>
						<cfset FileServerPath=Replace(FileServerPath,"#ATTRIBUTES.WebRootPath#", "/", "ALL")>
						<cfset FileServerPath=Replace(FileServerPath,"//","/","All")>
						<cfif ListFindNoCase(ATTRIBUTES.ImageExtensionList,".#ListLast(FileServerPath,'.')#") GT "0" and ATTRIBUTES.SupressView IS NOT "Y">
							<img src="#FileServerPath#" border="1"><br />
						<cfelse>
							<a target="_blank" href="#FileServerPath#">#ListLast(FileServerPath,"/")#</a><br />
						</cfif>
						<input type="hidden" name="#ATTRIBUTES.VarName#" value="#FileServerPath#">
						<cfset FileServerPath=Replace(File.ServerDirectory,"/","\","All")>
						<cfset CALLER.FileServerPath="#FileServerPath#\#File.ServerFile#">
					</cfif>
				</cfif>
			</cfif>
			#EndTag#
		</cfcase>
	</cfswitch>
</cfif>
<cfif ATTRIBUTES.FormEltOnly IS "N"></TR></cfif>
</cfoutput>
