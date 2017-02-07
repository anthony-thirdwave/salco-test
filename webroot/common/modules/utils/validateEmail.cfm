<cfsilent>
<!--- 3W.ErrorCheck.ValidateEmail  --->
<!--- Makes sure an E-mail message is acceptable.  Before the @ sign,
	  there may be no spaces or commas.  After the @ sign, only
	  letters, numbers, hyphens and dots are okay.  There must be at
	  least one character before the first dot, and at least two
	  characters after.  (Top-level domains can not be E-mailed to,
	  and must have at least two characters.
--->
<!--- Attributes:
		Email		The E-mail address to validate.  Required.
--->
<!--- Return variables:
		ValidateEmailStatus
			A status code.  This is an HTTP/FTP style, three-digit code.
			DO NOT USE IT AS A BOOLEAN, AS IT WILL ALWAYS BE TRUE!
			Rather, you can use:
				<CFIF ValidateEmailStatus LT 200>
			The codes are as follows:

			Acceptable E-mails (100-199):
				100		The address was OK.
			General problems (200-299):
				200		There were control characters in the address.
				201		There was no @ sign.
				202		There was more than one @ sign.
			Username problems (300-399):
				300		There was no username.
				301		The username contained illegal characters.
			Hostname problems (400-499):
				400		There was no hostname.
				401		The hostname contained illegal characters.
				402		The hostname contained two periods in a row.
				403		The hostname started with a period.
						N.B.  Ending in a period is quite OK, contrary to popular belief!
				404		The hostname didn't have any periods.
				405		The top-level domain contained less than two letters.

		ValidateEmailMessage
			A human-readable message explaining what the problem was.
--->
<!--- Last modified 10/19/00 by PWK  --->

<!--- Invalid characters for the username.  --->
<CFSET badusernamechars = ' ",*():;<>'>

<!--- Get the E-mail address.  --->
<CFPARAM NAME="Attributes.email">
<CFSET email = Attributes.email>

<!--- It's innocent until proven guilty.  --->
<CFSET Caller.ValidateEmailStatus = 100>
<CFSET Caller.ValidateEmailMessage = "The E-mail message was OK.">

<!--- Make sure there is exactly one at sign.  --->
<CFSET atcount = 0>
<CFSET controls = 0>
<CFLOOP INDEX="i" FROM="1" TO="#Len(email)#">
	<CFSET char = Mid(email, i, 1)>
	<CFIF char EQ "@">
		<CFSET atcount = atcount + 1>
	<CFELSEIF Asc(char) LTE 31>
		<CFSET controls = controls + 1>
	</CFIF>
</CFLOOP>

<CFIF controls GT 1>
	<CFSET Caller.ValidateEmailStatus = 200>
	<CFSET Caller.ValidateEmailMessage = "There were control characters in the address.">
<CFELSEIF atcount LT 1>
	<CFSET Caller.ValidateEmailStatus = 201>
	<CFSET Caller.ValidateEmailMessage = "There was no at sign (@) in the address.">
<CFELSEIF atcount GT 1>
	<CFSET Caller.ValidateEmailStatus = 202>
	<CFSET Caller.ValidateEmailMessage = "There can only be one at sign (@) in the address.">
<CFELSEIF Left(email, 1) EQ "@">
	<CFSET Caller.ValidateEmailStatus = 300>
	<CFSET Caller.ValidateEmailMessage = "There was nothing to the left of the at sign.">
<CFELSEIF Right(email, 1) EQ "@">
	<CFSET Caller.ValidateEmailStatus = 400>
	<CFSET Caller.ValidateEmailMessage = "There was nothing to the right of the at sign.">
<CFELSE>
	<!--- There is one at sign, and it's in the middle.  Split the message on it.  --->
	<CFSET username = ListFirst(email, "@")>
	<CFSET hostname = ListRest(email, "@")>

	<!--- If the left side is encapsulated in quotes, there are no rules.  Otherwise,
		  it can't have certain characters.  --->
	<CFIF NOT REFind('^\"[^\"]*\"$', username) AND REFind("[#badusernamechars#]", username)>
		<CFSET Caller.ValidateEmailStatus = 301>
		<CFSET Caller.ValidateEmailMessage = "The user name has illegal characters in it.">
	<CFELSE>
		<!--- If it's a numeric IP address, just accept it.  --->
		<CFIF NOT REFind('\[[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\]', hostname)>
			<!--- Much stricter rules apply to the right side.  There can only be letters,
				  numbers, hyphens and periods.  Obviously, there must be letters before the
				  first period, and you can't put two periods in a row.  --->
			<CFIF NOT REFind("^[A-Za-z0-9.-]+$", hostname)>
				<CFSET Caller.ValidateEmailStatus = 401>
				<CFSET Caller.ValidateEmailMessage = "The host name can only contain letters, numbers, hyphens and periods.">
			<CFELSEIF Find("..", hostname)>
				<CFSET Caller.ValidateEmailStatus = 402>
				<CFSET Caller.ValidateEmailMessage = "The host name can not have two periods in a row.">
			<CFELSEIF Left(hostname, 1) EQ ".">
				<CFSET Caller.ValidateEmailStatus = 403>
				<CFSET Caller.ValidateEmailMessage = "The host name can not start with a period.">
			<CFELSEIF ListLen(hostname, ".") LT 2>
				<CFSET Caller.ValidateEmailStatus = 404>
				<CFSET Caller.ValidateEmailMessage = "The host name must have at least one period.">
			<CFELSE>		
				<!--- The top-level domain has special rules.  It must be at least two characters
					  long, and it can only contain letters.  --->
				<CFSET tld = ListLast(hostname, ".")>
				<CFIF NOT REFind("^[A-Za-z][A-Za-z]+$", tld)>
					<CFSET Caller.ValidateEmailStatus = 405>
					<CFSET Caller.ValidateEmailMessage = "The top-level domain must be two or more letters long.">
				</CFIF>  <!--- invalid top-level domain  --->
			</CFIF>  <!--- detailed checks on the hostname  --->
		</CFIF>  <!--- not a numeric IP  --->
	</CFIF>  <!--- bad characters in the username  --->
</CFIF>  <!--- very basic checks  --->
</cfsilent>