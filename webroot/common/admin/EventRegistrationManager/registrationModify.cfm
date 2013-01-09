<cfmodule template="/common/modules/admin/dsp_Admin.cfm"
	Page="Registration Manager"
	PageHeader="<a href=""/common/admin/"">Main Menu</A> | Event Registration Manager">

<cfparam name="PageAction" default="List">
<cfparam name="eventDatePublicId" default="">

<cfajaximport tags="cfdiv,cfform">

<!--- comes from the cfgrid on the user manager page --->
<cfif isDefined("cfgridkey")>
	<cfset eventDatePublicId = cfgridkey />
</cfif>

<cfoutput>
	<cfswitch expression="#PageAction#">
		<cfcase value="list">
			<cflocation url="/common/admin/EventRegistrationManager/index.cfm">
		</cfcase>
		<cfcase value="edit,add">

			<!--- this gets the info for this event date --->
			<cfinvoke method="getEvents" component="#APPLICATION.eventHandlerObj#" returnvariable="theEventDate">
				<cfinvokeargument name="eventDatePublicId" value="#eventDatePublicId#">
			</cfinvoke>

			<!--- this gets the info for this event date --->
			<cfinvoke method="getRegistrants" component="#APPLICATION.eventRegistrationObj#" returnvariable="theRegistrants">
				<cfinvokeargument name="eventDatePublicId" value="#eventDatePublicId#">
			</cfinvoke>
			<div class="box1">
				<div class="boxtop1"><div></div></div>
				<div class="ModuleTitle1">Registrants for #theEventDate.eventTitle# - #dateFormat(theEventDate.dateStart, "mm/dd/yyyy")#</div>
		    </div>

			<!--- loop through the registrants --->
			<cfloop query="theRegistrants">
				<cfinclude template="/common/admin/EventRegistrationManager/registrationForm.cfm">
			</cfloop>
		</cfcase>
	</cfswitch>
</cfoutput>
</cfmodule>