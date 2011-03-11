<cfsilent>
<cfparam name="ATTRIBUTES.ObjectAction" default="ShowForm">
<cfparam name="ATTRIBUTES.Caption" default="DefaultCaption">
<cfparam name="ATTRIBUTES.CaptionClass" default="allcaps">
<cfparam name="ATTRIBUTES.VarName" default="">
<cfparam name="ATTRIBUTES.DefaultValue" default="">
<cfparam name="ATTRIBUTES.Checked" default="1">
<cfparam name="ATTRIBUTES.Required" default="N">
<cfparam name="ATTRIBUTES.EmailAddress" default="N">
<cfparam name="ATTRIBUTES.Numeric" default="N">
<cfparam name="ATTRIBUTES.Money" default="N">
<cfif ATTRIBUTES.Money IS "Y">
	<cfset ATTRIBUTES.Numeric="y">
</cfif>
<cfparam name="ATTRIBUTES.Date" default="N">
<cfparam name="ATTRIBUTES.ValidationMessage" default="Please enter a value.">
<cfparam name="ATTRIBUTES.EmailAddressValidationMessage" default="Please enter a valid email address.">
<cfparam name="ATTRIBUTES.DateValidationMessage" default="Please enter a valid date.">
<cfparam name="ATTRIBUTES.NumericValidationMessage" default="Please enter a valid number.">
<cfparam name="ATTRIBUTES.CreditCardValidationMessage" default="<font color=""White"">Please enter a valid credit card number.</font>">
<cfparam name="ATTRIBUTES.BlankMessage" default="">
<cfparam name="ATTRIBUTES.MaxChars" default="-1">
<cfparam name="ATTRIBUTES.MaxCharsValidationMessage" default="Please make your response shorter.">
<cfparam name="ATTRIBUTES.ValidationColor" default="##BAC0C9"><!--- cc0000 --->
<cfparam name="ATTRIBUTES.TDBGColor1" default="##BAC0C9"><!--- cc0000 --->
<cfparam name="ATTRIBUTES.TDBGColor2" default="##EAEAEA"><!--- cc0000 --->
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
<cfparam name="ATTRIBUTES.DocumentExtensionList" default=".pdf,.doc,.txt,.rtf">
<cfparam name="ATTRIBUTES.FormEltOnly" default="N">
</cfsilent>
<cfoutput>
<cfsilent>
<cfset message="">
<cfset ShowForm="0">
<cfif NOT IsDefined("SESSION.CurrentBrowserApp")>
	<cfif CGI.HTTP_USER_AGENT CONTAINS "MSIE">
		<cfset SESSION.CurrentBrowserApp="IE">
	<cfelse>
		<cfset SESSION.CurrentBrowserApp="NS">
	</cfif>
</cfif>
<cfif SESSION.CurrentBrowserApp IS "NS">
	<cfparam name="ATTRIBUTES.Size" default="40">
	<cfparam name="ATTRIBUTES.Cols" default="30">
	<cfset ATTRIBUTES.Size=ATTRIBUTES.Size*0.60>
	<cfset ATTRIBUTES.Cols=ATTRIBUTES.Cols*0.60>
</cfif>
<cfif ATTRIBUTES.ObjectAction IS "ShowForm">
	<cfset ShowForm="1">
	<cfset Message="">
<cfelseif ATTRIBUTES.ObjectAction IS "Validate">
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
	<cfif ATTRIBUTES.Required IS "Y" and ATTRIBUTES.type IS "file" AND Trim(Evaluate("#ATTRIBUTES.varName#FileObject")) IS "">
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
	<cfif ATTRIBUTES.Date IS "Y" AND Trim(ATTRIBUTES.DefaultValue) IS NOT "" AND NOT IsDate(ATTRIBUTES.DefaultValue)>
		<cfset ShowForm="1">
		<cfset Message="#ATTRIBUTES.DateValidationMessage#">
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
		<cfset Result=Evaluate("#ATTRIBUTES.Required#")>
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
</cfsilent>
<cfif message IS NOT "">
	<!--- Throw error --->
	<cfif ATTRIBUTES.FormEltOnly IS "N">
		<cfset TRTag="<tr valign=""#ATTRIBUTES.valign#"" bgcolor=""#ATTRIBUTES.ValidationColor#"">">
		#TRTag#
	</cfif>
	<cfset Caller.ErrorField="#Trim(ATTRIBUTES.VarName)#">
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
			<cfif ATTRIBUTES.REQUIRED IS "Y" AND (ATTRIBUTES.ObjectAction IS "ShowForm" OR Message IS NOT "")>
				<cfset MarkPlaceHolder="#ATTRIBUTES.RequiredMark#">
			<cfelse>
				<cfset MarkPlaceHolder="">
			</cfif>
			<cfif ATTRIBUTES.Version IS "1">
				<TD bgcolor="#ATTRIBUTES.TDBGColor1#">#MarkPlaceHolder#</TD><TD nowrap <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif> bgcolor="#ATTRIBUTES.TDBGColor1#">#ATTRIBUTES.Caption#<img src="/common/images/spacer.gif" height="15" width="1">&nbsp;</TD></TR>#TRTag#<TD bgcolor="#ATTRIBUTES.TDBGColor2#">&nbsp;</TD>
			<cfelse>
				<TD nowrap colspan="3" <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif> bgcolor="#ATTRIBUTES.TDBGColor1#">#ATTRIBUTES.Caption#<img src="/common/images/spacer.gif" height="15" width="1">#MarkPlaceHolder#&nbsp;</TD></TR>#TRTag#
			</cfif>
			
		<cfelse>
			<TD bgcolor="#ATTRIBUTES.TDBGColor1#"><cfif ATTRIBUTES.REQUIRED IS "Y" OR (ATTRIBUTES.ObjectAction IS "ShowForm" AND message IS NOT "")>#ATTRIBUTES.RequiredMark#</cfif></TD><TD nowrap bgcolor="#ATTRIBUTES.TDBGColor1#" <cfif ATTRIBUTES.CaptionClass IS NOT "">class="#ATTRIBUTES.CaptionClass#"</cfif>>#Trim(ATTRIBUTES.Caption)#<img src="/common/images/spacer.gif" height="15" width="1">&nbsp;</TD>
		</cfif>
	</cfif>
	<cfif ATTRIBUTES.CaptionOnTop IS "Y">
		</TR>#TRTag#
	</cfif>
</cfif>
<cfif ATTRIBUTES.FormEltOnly IS "N">
	<cfset BeginningTag="<Td bgcolor=""#ATTRIBUTES.TDBGColor2#"">">
	<cfset EndTag="</TD>">
<cfelse>
	<cfset BeginningTag="">
	<cfset EndTag="">
</cfif>
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
				<input type="#Trim(ATTRIBUTES.type)#" name="#ATTRIBUTES.VarName#" value="#htmleditformat(ATTRIBUTES.DefaultValue)#" size="#ATTRIBUTES.Size#" maxlength="#ATTRIBUTES.MaxLength#" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"</cfif> class="textbox" <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>&nbsp;
				<cfif Len(trim(Message)) IS NOT "0"><BR>#Message#</cfif>
			<cfelse>
				<cfif ATTRIBUTES.CreditCard IS "Y">
					<cfif Len(trim(ATTRIBUTES.DefaultValue)) gt "5">#ReReplace(Mid(ATTRIBUTES.DefaultValue,1,Len(ATTRIBUTES.DefaultValue)-4),"[0-9]","##","All")##right(ATTRIBUTES.DefaultValue,4)#<br></cfif><cfset SESSION.FooBar=ATTRIBUTES.DefaultValue>
				<cfelse>
					<cfif TRim(ATTRIBUTES.DefaultValue) IS ""><cfif ATTRIBUTES.BlankMessage IS NOT "">#ATTRIBUTES.BlankMessage#</cfif><!--- --- ---><cfelse><cfif ATTRIBUTES.Money IS "N"><cfif ATTRIBUTES.type IS "Password"><cfloop index="i" from="1" to="#Len(ATTRIBUTES.DefaultValue)#">*</cfloop><cfelse>#ATTRIBUTES.DefaultValue#&nbsp;</cfif><cfelse>#DollarFormat(Val(ATTRIBUTES.DefaultValue))#&nbsp;</cfif></cfif><input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
				</cfif>
			</cfif>
		</cfif>
		#EndTag#
	</cfcase>
	<cfcase value="checkbox">
		#BeginningTag#
		<cfif ATTRIBUTES.ObjectAction IS "ShowForm">
			<input type="checkbox" name="#ATTRIBUTES.VarName#" value="1" <cfif (IsDefined("CALLER.#ATTRIBUTES.VarName#") AND Evaluate("CALLER.#ATTRIBUTES.VarName#")) OR ATTRIBUTES.DefaultValue>checked</cfif> <cfif ATTRIBUTES.FormEltStyle IS NOT ""> style="#ATTRIBUTES.FormEltStyle#"<cfelse> class="checkbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>
		<cfelse>
			<cfif IsDefined("CALLER.#ATTRIBUTES.VarName#")>
				<cfset CheckMe=Evaluate("CALLER.#ATTRIBUTES.VarName#")>
			<cfelse>
				<cfset CheckMe="0">
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
				<cfset CheckMe=Evaluate("#ATTRIBUTES.VarName#")>
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
				<cfif Len(trim(Message)) IS NOT "0"><BR>#Message#</cfif>
			<cfelse>
				<cfif Trim(ATTRIBUTES.DefaultValue) IS "">&nbsp;<cfelse>
				<cfif ATTRIBUTES.EscapeCRLF IS "Y">#Replace(ATTRIBUTES.DefaultValue,"#Chr(10)#", "<BR>","ALL")#<cfelse>#ATTRIBUTES.DefaultValue#</cfif></cfif><input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
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
						<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{">
							<option value="#GetToken(i,1,'|')#" <cfif ATTRIBUTES.DefaultValue IS GetToken(i,1,'|')>selected</cfif>>#GetToken(i,2,'|')#</option>
						</cfloop>
					</select><cfif Len(trim(Message)) IS NOT "0"><BR>#Message#</cfif>
				<cfelse>
					<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{">
						<cfif ATTRIBUTES.DefaultValue IS GetToken(i,1,'|')>#GetToken(i,2,'|')#</cfif>
					</cfloop>
					<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
				</cfif>
			<cfelse>
				<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{">
					<cfif ATTRIBUTES.DefaultValue IS GetToken(i,1,'|')>#GetToken(i,2,'|')#</cfif>
				</cfloop>
				<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
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
					<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{">
						<option value="#GetToken(i,1,'|')#" <cfif ListFindNoCase(ATTRIBUTES.DefaultValue,GetToken(i,1,'|'))>selected</cfif>>#GetToken(i,2,'|')#</option>
					</cfloop>
				</select><cfif Len(trim(Message)) IS NOT "0"><BR>#Message#</cfif>
			<cfelse>
			<cfloop index="i" list="#ATTRIBUTES.OptionValues#" delimiters="}^^{">
				<cfif ListFindNoCase(ATTRIBUTES.DefaultValue,GetToken(i,1,'|'))>#GetToken(i,2,'|')#</cfif>
			</cfloop>
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
				<cfif FileExists("#APPLICATION.WebrootPath##ATTRIBUTES.DefaultValue#")>
					<cfif ATTRIBUTES.SupressView IS "N">
						<cfif ListFindNoCase(ATTRIBUTES.DocumentExtensionList,".#ListLast(ATTRIBUTES.DefaultValue,'.')#") GT "0">
							<a target="_blank" href="#ATTRIBUTES.DefaultValue#">#ListLast(ATTRIBUTES.DefaultValue,"/")#</A><BR>
						<cfelse>
							<img src="#ATTRIBUTES.DefaultValue#"><BR>
						</cfif>
					</cfif>
				</cfif>
				<input type="file" name="#ATTRIBUTES.VarName#FileObject" <cfif ATTRIBUTES.FormEltStyle IS NOT "">style="#ATTRIBUTES.FormEltStyle#"<cfelse>class="textbox"</cfif> <cfif ATTRIBUTES.FormEltJavaScript IS NOT "">#ATTRIBUTES.FormEltJavaScript#</cfif>>
				<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
				<cfif Len(trim(Message)) IS NOT "0"><BR>#Message#</cfif>
			<cfelse>
				<cfparam name="#ATTRIBUTES.VarName#FileObject" default="">
				<cfif Trim(Evaluate("#ATTRIBUTES.VarName#FileObject")) IS "">
					<cfif FileExists("#APPLICATION.WebrootPath##ATTRIBUTES.DefaultValue#")>
						<cfif ATTRIBUTES.SupressView IS NOT "N">
							<cfif ListFindNoCase(ATTRIBUTES.DocumentExtensionList,".#ListLast(ATTRIBUTES.DefaultValue,'.')#") GT "0">
								<a target="_blank" href="#ATTRIBUTES.DefaultValue#">#ListLast(ATTRIBUTES.DefaultValue,"/")#</A><BR>
							<cfelse>
								<img src="#ATTRIBUTES.DefaultValue#"><BR>
							</cfif>
						</cfif>
					</cfif>
					<input type="hidden" name="#ATTRIBUTES.VarName#" value="#HTMLEditFormat(ATTRIBUTES.DefaultValue)#">
					<cfset CALLER.FileServerPath="">
				<cfelse>
					<cffile action="UPLOAD" 
						filefield="#ATTRIBUTES.VarName#FileObject"
						destination="#ATTRIBUTES.Tempdir#"
						nameconflict="OVERWRITE">
					<cfset FileServerPath=File.ServerDirectory & "/" & File.ServerFile>					
					<cfset FileServerPath=Replace(FileServerPath,"#ATTRIBUTES.WebRootPath#", "/", "ALL")>
					<cfset FileServerPath=Replace(FileServerPath,"//","/","All")>
					<cfif ListFindNoCase(ATTRIBUTES.DocumentExtensionList,".#ListLast(FileServerPath,'.')#") GT "0">
						<a target="_blank" href="#FileServerPath#">#ListLast(FileServerPath,"/")#</A><BR>
					<cfelse>
						<img src="#FileServerPath#"><BR>
					</cfif>
					<input type="hidden" name="#ATTRIBUTES.VarName#" value="#FileServerPath#">
					<cfset FileServerPath=Replace(File.ServerDirectory,"/","\","All")>
					<cfset FileServerPath=Replace("#FileServerPath#\#File.ServerFile#","\\","\","All")>
					<cfset CALLER.FileServerPath="#FileServerPath#">
				</cfif>
			</cfif>
		</cfif>
		#EndTag#
	</cfcase>
</cfswitch>
<cfif ATTRIBUTES.FormEltOnly IS "N"></TR></cfif>
</cfoutput>
