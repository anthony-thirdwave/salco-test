<cfif IsDefined("FORM.BulletinID")>
	<cfif IsNumeric(FORM.BulletinID)>
		<cfif FORM.isDelete EQ 1>
			<cfquery name="insertNewBulletin" datasource="#APPLICATION.DSN#">
				DELETE FROM t_Bulletin
				WHERE bulletinID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.bulletinID#">
			</cfquery>
			<cfinvoke component="#APPLICATION.Mapping#com/utils/tracking" method="track" returnVariable="success"
				UserID="#SESSION.AdminUserID#"
				Entity="Bulletin"
				KeyID="#FORM.bulletinID#"
				Operation="delete">
		<cfelse>
			<cfquery name="insertNewBulletin" datasource="#APPLICATION.DSN#">
				UPDATE t_Bulletin
					SET message = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.message#" maxlength="1000">
				WHERE bulletinID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.bulletinID#">
			</cfquery>
			<cfinvoke component="#APPLICATION.Mapping#com/utils/tracking" method="track" returnVariable="success"
				UserID="#SESSION.AdminUserID#"
				Entity="Bulletin"
				KeyID="#FORM.bulletinID#"
				Operation="modify">
		</cfif>
	<cfelse>
		<cfquery name="insertNewBulletin" datasource="#APPLICATION.DSN#">
			SET NOCOUNT ON
			INSERT INTO t_Bulletin (message) 
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.message#" maxlength="1000">)
			SELECT NewBulletinID=@@Identity
		</cfquery>
		<cfinvoke component="#APPLICATION.Mapping#com/utils/tracking" method="track" returnVariable="success"
			UserID="#SESSION.AdminUserID#"
			Entity="Bulletin"
			KeyID="#insertNewBulletin.NewBulletinID#"
			Operation="create">
	</cfif>
	<cflocation addtoken="no" url="#FORM.returnURL#">
</cfif>
