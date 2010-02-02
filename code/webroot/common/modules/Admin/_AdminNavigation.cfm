<cfset sMenu=StructNew()>
<cfset sMenuList="Dashboard,Content Manager,User Manager,Support,Url Manager">


<cfloop index="ThisElt" list="#sMenuList#">
	<cfset sMenuElt=StructNew()>
	<cfset StructInsert(sMenuElt,"name","#ThisElt#",1)>
	<cfswitch expression="#ThisElt#">
		<cfcase value="Dashboard">
			<cfset StructInsert(sMenuElt,"link","/common/admin",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","all",1)>
			<cfset StructInsert(sMenuElt,"Description","The site administration home page.",1)>
		</cfcase>
		<cfcase value="Content Manager">
			<cfset StructInsert(sMenuElt,"link","/common/admin/masterview/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","#APPLICATION.AdminUserGroupID#,#APPLICATION.ContentEditorUserGroupID#",1)>
			<cfset StructInsert(sMenuElt,"Description","The content manager is used to drive the navigation and add/edit/delete pages from the site.",1)>
		</cfcase>
		<cfcase value="User Manager">
			<cfset StructInsert(sMenuElt,"link","/common/admin/UserManager/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","#APPLICATION.AdminUserGroupID#",1)>
			<cfset StructInsert(sMenuElt,"Description","Add/edit/delete user accounts and groups for the live site.",1)>
		</cfcase>
		<cfcase value="Support">
			<cfset StructInsert(sMenuElt,"link","/common/admin/support/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","all",1)>
			<cfset StructInsert(sMenuElt,"Description","Send email to CMS support.",1)>
		</cfcase>
		<cfcase value="Url Manager">
			<cfset StructInsert(sMenuElt,"link","/common/admin/redirectManager/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","#APPLICATION.AdminUserGroupID#",1)>
			<cfset StructInsert(sMenuElt,"Description","Manage url redirects",1)>
		</cfcase>
	</cfswitch>
	<cfset StructInsert(sMenu,"#ThisElt#",sMenuElt,1)>
</cfloop>

