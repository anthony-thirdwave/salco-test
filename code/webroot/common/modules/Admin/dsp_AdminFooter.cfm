<p><hr size="1" noshade><small>If you are experiencing any problems with the Content Manager, you may contact Thirdwave, LLC., at (312) 329-1960.</small></p>
</TD>
</tr>
</table>
<P>&nbsp;</P>
<cfif IsDefined("CLIENT.wAdminCurrentUser") AND IsDebugMode() AND 0>
	<cfdump var="#CLIENT.wAdminCurrentUser#">
	<cfdump var="#session#">
</cfif>
</body>
</html>
