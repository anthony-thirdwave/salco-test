<!--- Document Information -----------------------------------------------------

Title:      index.cfm

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Captcha example

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		18/01/2006		Created

------------------------------------------------------------------------------->
<cfparam name="thisWord" default="">

<cfif not isdefined("attributes.thisWord")>
	<cfabort showerror="contact_captcha.cfm requires attributes.thisWord">
<cfelse>
	<cfset thisWord = attributes.thisWord>
</cfif>

<cfscript>
	//create the captcha cfc (could be singleton) 
	captcha = createObject("component", "/common/modules/utils/Captcha").init();
	
	//push to a file
	captcha.captchaToFile(expandPath("captcha.jpg"),
							"#thisWord#",
							200,
							50,
							30,
							10,
							35,
							45,
							60);
</cfscript>

<img src="captcha.jpg">



