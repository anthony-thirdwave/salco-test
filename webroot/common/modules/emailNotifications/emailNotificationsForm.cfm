<link rel="stylesheet" type="text/css" href="/common/modules/emailNotifications/emailNotifications.css">
<!--- Declare values --->

<cfparam name="ATTRIBUTES.ToAddress" default="notifications@dev01.thirdwavellc.com">
<cfparam name="ATTRIBUTES.FromAddress" default="noreply@salcoproducts.com">

<cfparam name="notified" default="0">
<cfparam name="formsubmit" default="0">
<cfparam name="FormAction" default="#CGI.REQUEST_URI#?#CGI.QUERY_STRING#">
<cfparam name="form.email" default="">

<cfset Location=GetToken(FormAction,1,"?")>
<cfset querystring=GetToken(FormAction,2,"?")>

<cfset ErrorMessage="">

<cfset lSubject="Hopper Cars,Intermodal Containers,Rail/Yard Accessories,Tank Cars,Other">

<!---  set params ----> 
<cfset formFieldList="firstName,lastName,missive,company,manuals,changes,press,promotions">
<cfloop index="i" list="#formFieldList#">
  <cfparam name="form.#i#" default="">
</cfloop>

<cfset Mailer_Subject="Email Notifications to: #form.firstName# #form.lastName#">

<cfif APPLICATION.Production>
  <!--- live site --->
<cfelse>
  <cfset Mailer_Subject="#Mailer_Subject# TESTING ONLY!">
  <cfif 0>
    <cfset ATTRIBUTES.ToAddress="notifications@dev01.thirdwavellc.com">
  </cfif>
</cfif>

<cfif val(formsubmit) EQ 1>
  <!--- Form is submitted so lets process it --->
  <cfif Len(Trim(firstName)) Eq 0>
    <cfset ErrorMessage=ErrorMessage & "<li>Please enter your first name.</li>">
  </cfif>

  <cfif Len(Trim(lastName)) Eq 0>
    <cfset ErrorMessage=ErrorMessage & "<li>Please enter your last name.</li>">
  </cfif>

  <cfif Len(Trim(company)) Eq 0>
    <cfset ErrorMessage=ErrorMessage & "<li>Please enter your company name.</li>">
  </cfif>

  <!--- At least one checkbox should be checked --->

  <cfif val(manuals) Eq "0" AND val(changes) Eq "0" AND val(press) Eq "0" AND val(promotions) Eq "0">
    <cfset ErrorMessage=ErrorMessage & "<li>Please, check at least one option.</li>">
  </cfif>
    
  <!--- Missive == user submitted email --->
  <cfif Len(Trim(missive)) Eq 0>
    <cfset ErrorMessage=ErrorMessage & "<li>Please enter a value for email.</li>">
  <cfelse>
    <cfmodule name="3w.errorcheck.validateemail" email="#form.missive#">
    <cfif ValidateEmailStatus GTE "200">
      <cfoutput><p>Debug: #form.missive#</p></cfoutput>
      <cfset ErrorMessage=ErrorMessage & "<li>Email entered is not formatted correctly.</li>">
    </cfif>
  </cfif>

  <cfif len(trim(ErrorMessage)) EQ 0>
    <cfif Len(Trim(email)) GT 0>
      <!--- Honeypot fail, do not echo error message and drive through without processing --->
    <cfelse>
      <cfmail to="#ATTRIBUTES.ToAddress#" from="#form.missive#" type="html" subject="#Mailer_Subject#">
        <table>
          <tr>
            <td colspan="2">
              <p>#firstName# #lastName# from company #company#, and email #missive# requested email notifications for the following literature:</p>
              <ul>
                <cfif val(manuals) EQ "1">
                  <li>Manuals &amp; Instructions Updates</li>
                </cfif>

                <cfif val(changes) EQ "1">
                  <li>Design Changes or Improvements</li>
                </cfif>

                <cfif val(press) EQ "1">
                  <li>Press Releases</li>
                </cfif>

                <cfif val(promotions) EQ "1">
                  <li>Promotional Product Email Marketing</li>
                </cfif>
              </ul>
            </td>
          </tr>
        </table>
      </cfmail>
      <cfmail to="#form.missive#" from="#ATTRIBUTES.FromAddress#" type="html" subject="#Mailer_Subject#">
        <table>
          <tr>
            <td colspan="2">
              <p>Thank you! You have been signed up for email notifications on the following:</p>
              <ul>
                <cfif val(manuals) EQ "1">
                  <li>Manuals &amp; Instructions Updates</li>
                </cfif>

                <cfif val(changes) EQ "1">
                  <li>Design Changes or Improvements</li>
                </cfif>

                <cfif val(press) EQ "1">
                  <li>Press Releases</li>
                </cfif>

                <cfif val(promotions) EQ "1">
                  <li>Promotional Product Email Marketing</li>
                </cfif>
              </ul>
            </td>
          </tr>
        </table>
      </cfmail>

      <!--- redirect to itself --->
      <cflocation url="#Location#?#querystring#&notified=1" addtoken="No">
    </cfif>
  </cfif>

  <cfif len(trim(ErrorMessage)) gt 0>
    <p>
      <div class="red">
      <ul>
        <cfoutput>#ErrorMessage#</cfoutput>
      </ul>
    </div>
    </p>
  </cfif>
</cfif>
  


<cfoutput>  
<div class="news">  
  <cfif val(notified) EQ 1>
    <p class='bold'>Thank you! You have been added to our mailing list.</p>
  <cfelse>
    <p>Thank you for your interest in signing up for our email notification service.<br> Kindly fill out this form to be added to our mailing list.</p>
    <form action="#Location#?#querystring#" method="post" name="applicationForm" id="applicationForm" enctype="multipart/form-data">
    <input type="hidden" name="formsubmit" value="1" />
    <input name="email" type="text" class="hpfield" value=""/>
    <!--- ====================================================--->
    <!--- enter form fields here --->

      <div class="formRow<cfif val(formsubmit) EQ 1 and len(trim(firstName)) eq 0> errorTxt</cfif> wide">
        <label for='firstName' class='textarea-label'>First Name *</label>
        <input name='firstName' id="firstName" maxlength="50" type="text" value="#HTMLEditFormat(form.firstName)#">
      </div>

      <div class="formRow<cfif val(formsubmit) EQ 1 and len(trim(lastName)) eq 0> errorTxt</cfif> wide">
        <label for='lastName' class='textarea-label'>Last Name *</label>
        <input name="lastName" id="lastName" maxlength="50" type="text" value="#HTMLEditFormat(form.lastName)#">
      </div>

      <div class="formRow<cfif val(formsubmit) EQ 1 and len(trim(company)) eq 0> errorTxt</cfif> wide">
        <label for='company' class='textarea-label'>Company *</label>
        <input name="company" id="company" maxlength="50" type="text" value="#HTMLEditFormat(form.company)#">
      </div>

      <div class="formRow<cfif val(formsubmit) EQ 1 and len(trim(missive)) eq 0> errorTxt</cfif> wide">
        <label for='missive' class='textarea-label'>Email *</label>
        <input name="missive" id="missive" maxlength="50" type="text" value="#HTMLEditFormat(form.missive)#">
      </div>

      <p class='notifications-form'>Please select the emails you wish to receive:</p>

      <div>
        <input type="checkbox" name="manuals" id="manuals" value="1">
        <label for='manuals' class='email-options'>Manuals & Instructions Updates</label>
      </div>

      <div>
        <input type="checkbox" name="changes" id="changes" value="1">
        <label for='changes' class='email-options'>Design Changes or Improvements</label>
      </div>

      <div>
        <input type="checkbox" name="press" id="press" value="1">
        <label for='press' class='email-options'>Press Releases</label>
      </div>

      <div>
        <input type="checkbox" name="promotions" id="promotions" value="1">
        <label for='promotions' class='email-options'>Promotional Product Email Marketing</label>
      </div>
      
      <!--- ====================================================--->
      
      <div class="formRow submit rightSubmit">
        <cfset someStr="Submit" />
        <p class='footer'>Note that * indicates a required field</p>
        <input type="submit" name="submit" value="#someStr#" title="Send Suggestion"/>
      </div>

    </form>
  </cfif>
</div>
</cfoutput>
