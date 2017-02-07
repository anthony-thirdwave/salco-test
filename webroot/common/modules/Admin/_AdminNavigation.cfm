<cfset sMenu=StructNew()>
<cfset sMenuList="Dashboard,Content Manager,Product List,User Manager,Redirect Manager,Event Manager,Support">

<!--- <!--- add the event manager if the events module exists --->
<cfif structKeyExists(APPLICATION.modules, "event")>
	<cfset sMenuList = listAppend(sMenuList, "Event Manager")>
</cfif>
 --->
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
		<cfcase value="Product List">
			<cfset StructInsert(sMenuElt,"link","/common/admin/ProductManager/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","#APPLICATION.AdminUserGroupID#",1)>
			<cfset StructInsert(sMenuElt,"Description","View list of products in the system.",1)>
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
		<cfcase value="Redirect Manager">
			<cfset StructInsert(sMenuElt,"link","/common/admin/redirectManager/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","#APPLICATION.AdminUserGroupID#",1)>
			<cfset StructInsert(sMenuElt,"Description","Manage url redirects",1)>
		</cfcase>
		<cfcase value="Event Manager">
			<cfset StructInsert(sMenuElt,"link","/common/admin/EventManager/index.cfm",1)>
			<cfset StructInsert(sMenuElt,"lUserGroupID","#APPLICATION.AdminUserGroupID#",1)>
			<cfset StructInsert(sMenuElt,"Description","Manage events",1)>
		</cfcase>
	</cfswitch>
	<cfset StructInsert(sMenu,"#ThisElt#",sMenuElt,1)>
</cfloop>

