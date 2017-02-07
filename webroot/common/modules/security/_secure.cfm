<cfparam name="ATTRIBUTES.LocationURL" default="#CGI.Path_Info#?#CGI.Query_String#">
<cfparam name="ATTRIBUTES.AcceptGroupIDList" default="">

<!--- Subsequent access to other pages via cookie
	  This must be tested first since a federated site might have killed cookie via a logout and 
	  this site will still have SESSION variables setup and allow user to login
---->

<CFIF IsDefined("FORM.TryUserLogin") AND IsDefined("FORM.TryUserPassword")>
	<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
		<cfset SESSION.UserLogin=FORM.TryUserLogin>
		<cfset SESSION.UserPassword=FORM.TryUserPassword>
	</cflock>
	<cfinvoke component="com.utils.security" method="Authenticate" returnVariable="qUser">
		<cfinvokeargument name="username" value="#Trim(SESSION.UserLogin)#">
		<cfinvokeargument name="password" value="#trim(SESSION.UserPassword)#">
	</cfinvoke>
	<cfif qUser.RecordCount IS "0">
		<cfset FORM.TryUserPassword="">
		<cfset REQUEST.SecurityMessage="Incorrect Login">
	<cfelse>
		<!--- If the login was successfull, cflocation to the correct page so that
					you don't get the reload form popup when you refresh or hit the back button --->
		<cflocation url="#ATTRIBUTES.LocationURL#" addtoken="no">
	</cfif>
<!--- Subsequent access to other pages via SESSION---->
<CFELSEIF IsDefined("SESSION.UserLogin") AND IsDefined("SESSION.UserPassword") and SESSION.UserPassword IS NOT "">
	<cfinvoke component="com.utils.security" method="Authenticate" returnVariable="qUser">
		<cfinvokeargument name="username" value="#Trim(SESSION.UserLogin)#">
		<cfinvokeargument name="password" value="#trim(SESSION.UserPassword)#">
	</cfinvoke>
<cfelse>
<!--- Try to enter the update portion by not using form --->
	<cfinvoke component="com.utils.security" method="GetBlank" returnVariable="qUser">
	</cfinvoke>
</CFIF>

<cfif qUser.RecordCount IS NOT 0>
	<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
		<cfset SESSION.UserID="#qUser.UserID#">
		<cfinvoke component="com.utils.security" 
			method="GetUserGroupID"
			returnVariable="lUserGroupID"
			UserID="#Val(SESSION.UserID)#">
		<cfset SESSION.UserLogin="#qUser.UserLogin#">
		<cfset SESSION.UserPassword="#qUser.UserPassword#">
		<cfset SESSION.DisableRichControls=0>
	</cflock>
	<cfif IsDefined("SESSION.wCurrentUser") and IsWDDX(SESSION.wCurrentUser)>
		<CFWDDX action="wddx2cfml" input="#SESSION.wCurrentUser#" output="sCurrentUser">
		<cfif StructKeyExists(sCurrentUser,"UserLogin") AND sCurrentUser.UserLogin IS SESSION.UserLogin AND sCurrentUser.UserID IS qUser.UserID AND sCurrentUser.CFToken IS SESSION.CFToken AND sCurrentUser.CFID IS SESSION.CFID>
			<cfset CreateNew=0>
		<cfelse>
			<cfset CreateNew=1>
		</cfif>
	<cfelse>
		<cfset CreateNew=1>
	</cfif>
	
	<cfif CreateNew><!--- Instantiate new Client stucture --->
		<CFSCRIPT>
			sCurrentUser=StructNew();
			StructInsert(sCurrentUser, "CFToken", "#SESSION.CFToken#","1");
			StructInsert(sCurrentUser, "CFID", "#SESSION.CFID#","1");
			StructInsert(sCurrentUser, "UserID", qUser.UserID,"1");
			StructInsert(sCurrentUser, "UserLogin", qUser.UserLogin,"1");
			StructInsert(sCurrentUser, "UserGroupIDList", lUserGroupID,"1");
		</CFSCRIPT>
	</cfif>
	<cfwddx action="CFML2WDDX" input="#sCurrentUser#" output="SESSION.wCurrentUser">
	<CFLOCK TYPE="Exclusive" NAME="#Session.SessionID#" TIMEOUT="1">
		<cfset SESSION.UserGroupIDList="#lUserGroupID#">
	</cflock>
	<cfset CALLER.UserID="#qUser.UserID#">
	<cfset CALLER.UserLogin="#qUser.UserLogin#">
	<cfset CALLER.UserGroupIDList="#lUserGroupID#">
	<cfif ListLen(ATTRIBUTES.AcceptGroupIDList) GTE "1">
		<cfset DenyAccess="1">
		<cfloop index="ThisGroupID" list="#ATTRIBUTES.AcceptGroupIDList#">
			<cfif ListFind(lUserGroupID,ThisGroupID)>
				<cfset DenyAccess="0">
			</cfif>
		</cfloop>
	<cfelse>
		<cfset DenyAccess="0">
	</cfif>
<cfelse>
	<cfset DenyAccess="1">
</cfif>

<cfif DenyAccess>
	<cfset CALLER.UserID="">
	<cfset CALLER.UserLogin="">
	<cfset CALLER.UserGroupIDList="">
	<cfparam name="ATTRIBUTES.RelocateOnError" default="Yes">
	<cfif Left(CGI.SCRIPT_NAME,LEN("/common/admin/")) IS "/common/admin/">
		<cfinclude template="/common/admin/login.cfm">
		<cfabort>
	<cfelse>
		<cfif ATTRIBUTES.RelocateOnError>
			<cfparam name="ATTRIBUTES.LoginPage" default="/">
			<cflocation url="#ATTRIBUTES.LoginPage#" addtoken="No">
		</cfif>
	</cfif>
</cfif>
<Cfset CALLER.DenyAccess=DenyAccess>
