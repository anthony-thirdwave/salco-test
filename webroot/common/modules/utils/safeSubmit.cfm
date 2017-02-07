<!--- SafeSubmit.cfm  Version 1.0, 8/5/98
	Usage:
		<CF_SafeSubmit 
			ATTRIBUTES.buttontext1 = "Click Here to Submit"
			ATTRIBUTES.buttontext2 = "Please Wait"
		>
--->
<CFPARAM NAME="ATTRIBUTES.buttontext1" DEFAULT="Submit">
<CFPARAM NAME="ATTRIBUTES.buttontext2" DEFAULT="Wait!">
<CFSET ID = RandRange(1,99999999)>
<CFOUTPUT>
<script language="javascript">
		function SafeSubmit#ID#(obj) {

			if(obj.value == "#ATTRIBUTES.buttontext1#") obj.form.submit();  // If the value of the button is submit, submit the form.
			obj.value = "#ATTRIBUTES.buttontext2#"; // This changes to button Label
		}
</Script>
<input type="Button" Name="Submit#ID#" Value="#ATTRIBUTES.buttontext1#" onClick="SafeSubmit#ID#(this)" class="button">
</CFOUTPUT>
