<cfcomponent displayname="EmployeeHandler" output="true">
	
	<cffunction name="init" returntype="EmployeeHandler" output="false">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="qryEmployees" output="false" returntype="query">
		<cfargument name="departmentID" default="0" type="numeric" required="false">
		<cfargument name="employeeID" default="0" type="numeric" required="false">
		<cfargument name="searchTxt" default="" type="string" required="false">
		<cfargument name="orderBy" default="" type="string" required="false">
		
		<cfset VAR LOCAL=StructNew()>
		
		<cfinvoke component="com.ContentManager.EmployeeHandler"
			method="GetAllEmployees"
			returnVariable="GetAllEmployees">
			
		<cfquery name="LOCAL.qryEmployees" dbtype="query">
			SELECT	*
			FROM	GetAllEmployees
			WHERE	1=1
			<cfif val(ARGUMENTS.departmentID) gt 0>
				AND		departmentID=<cfqueryparam value="#val(ARGUMENTS.departmentID)#" cfsqltype="cf_sql_integer">
			<cfelse>
				AND		departmentID <> <cfqueryparam value="6098" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif val(ARGUMENTS.employeeID) gt 0>
				AND		employeeID=<cfqueryparam value="#val(ARGUMENTS.employeeID)#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif Len(Trim(ARGUMENTS.searchTxt))>
				AND		empFirstName like <cfqueryparam value="#UCASE(Trim(ARGUMENTS.searchTxt))#%" cfsqltype="cf_sql_varchar">
			</cfif>
			<cfif Len(Trim(ARGUMENTS.orderBy))>
				ORDER BY #ARGUMENTS.orderBy#
			</cfif>
		</cfquery>
		
		<cfreturn LOCAL.qryEmployees>
	</cffunction>
	
	<cffunction name="GetAllEmployees" output="false" returntype="query">
		<cfset VAR LOCAL=StructNew()>
		
		<cfquery name="GetLastCache" datasource="#APPLICATION.DSN#" maxrows="1">
			SELECT     MAX(CacheDateTime) AS CacheDateTime
			FROM         t_Category where
			CategoryTypeID=<cfqueryparam value="81" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif IsDefined("APPLICATION.EmployeeControl_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#")>
			<cfreturn APPLICATION.EmployeeQuery>
		<cfelse>
			<cfset LOCAL.qryGetEmployee=QueryNew("employeeID,empFirstName,empLastName,departmentID,empEmail,empTitle,empBirthDate,empBirthDate2,empJoinDate,empJoinDate2,empPhone,empPhoneExt,empCellPhone,empImage,empImagethumb,empAlias",
			"integer,varchar,varchar,integer,varchar,varchar,varchar,date,varchar,date,varchar,varchar,varchar,varchar,varchar,varchar") />
			
			<cfquery name="LOCAL.GetEmployee" datasource="#APPLICATION.DSN#">
				SELECT	c.categoryID,c.categoryAlias,c.parentID,c.categoryName,p.PropertiesPacket as CategoryLocalePropertiesPacket
				FROM	t_category c JOIN t_categoryLocale cl on c.categoryID=cl.categoryID
				JOIN t_Properties p ON  cl.PropertiesID=p.PropertiesID
				WHERE	c.CategoryTypeID=<cfqueryparam value="81" cfsqltype="cf_sql_integer">
				AND		c.categoryActive=<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<!--- Create a new query. --->
			<cfloop query="LOCAL.GetEmployee">
				<cfif IsWDDX(CategoryLocalePropertiesPacket)>
				
					<cfset QueryAddRow(qryGetEmployee)>
					
					<cfwddx action="WDDX2CFML" input="#LOCAL.GetEmployee.CategoryLocalePropertiesPacket#" output="sCategoryProperties">
					<cfif StructKeyExists(sCategoryProperties,"empFirstName") AND Trim(sCategoryProperties.empFirstName) IS NOT "">
						<cfset ThisEmpFirstName=Trim(sCategoryProperties.empFirstName)>
					<cfelse>
						<cfset ThisEmpFirstName="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empLastName") AND Trim(sCategoryProperties.empLastName) IS NOT "">
						<cfset ThisEmpLastName=Trim(sCategoryProperties.empLastName)>
					<cfelse>
						<cfset ThisEmpLastName="">
					</cfif>
					<cfset thisName=ThisEmpFirstName & ThisEmpLastName>
					
					<cfif StructKeyExists(sCategoryProperties,"empImage") AND Trim(sCategoryProperties.empImage) IS NOT "">
						<cfset ThisEmpImage=Trim(sCategoryProperties.empImage)>
					<cfelse>
						<cfset ThisEmpImage="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empEmail") AND Trim(sCategoryProperties.empEmail) IS NOT "">
						<cfset ThisEmpEmail=Trim(sCategoryProperties.empEmail)>
					<cfelse>
						<cfset ThisEmpEmail="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empBirthDate") AND Trim(sCategoryProperties.empBirthDate) IS NOT "">
						<cfset ThisEmpBirthdate=Trim(sCategoryProperties.empBirthDate)>
						<cfif ListLen(ThisEmpBirthdate,"/") IS "2">
							<!--- add the current year to the birthdate --->
							<cfset ThisEmpBirthdate2="#ThisEmpBirthdate#/#Year(now())#">
						</cfif>
					<cfelse>
						<cfset ThisEmpBirthdate="">
						<cfset ThisEmpBirthdate2="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empJoinDate") AND Trim(sCategoryProperties.empJoinDate) IS NOT "">
						<cfset ThisEmpJoindate=Trim(sCategoryProperties.empJoinDate)>
						<cfif IsDate(ThisEmpJoindate)>
							<!--- add the current year to the join date --->
							<cfset ThisEmpJoindate2="#DateFormat(CreateDate(year(Now()),month(ThisEmpJoindate),day(ThisEmpJoindate)),'mm/dd/yyyy')#">
						</cfif>
					<cfelse>
						<cfset ThisEmpJoindate="">
						<cfset ThisEmpJoindate2="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empPhone") AND Trim(sCategoryProperties.empPhone) IS NOT "">
						<cfset ThisEmpPhone=Trim(sCategoryProperties.empPhone)>
					<cfelse>
						<cfset ThisEmpPhone="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empPhoneExt") AND Trim(sCategoryProperties.empPhoneExt) IS NOT "">
						<cfset ThisEmpPhoneExt=Trim(sCategoryProperties.empPhoneExt)>
					<cfelse>
						<cfset ThisEmpPhoneExt="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empCellPhone") AND Trim(sCategoryProperties.empCellPhone) IS NOT "">
						<cfset ThisEmpCellPhone=Trim(sCategoryProperties.empCellPhone)>
					<cfelse>
						<cfset ThisEmpCellPhone="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empTitle") AND Trim(sCategoryProperties.empTitle) IS NOT "">
						<cfset ThisEmpTitle=Trim(sCategoryProperties.empTitle)>
					<cfelse>
						<cfset ThisEmpTitle="">
					</cfif>
					<cfif StructKeyExists(sCategoryProperties,"empImagethumb") AND Trim(sCategoryProperties.empImagethumb) IS NOT "">
						<cfset ThisEmpImagethumb=Trim(sCategoryProperties.empImagethumb)>
					<cfelse>
						<cfset ThisEmpImagethumb="">
					</cfif>
					
					<cfset thisEmployeeID=LOCAL.GetEmployee.categoryID>
					<cfset thisEmpAlias=LOCAL.GetEmployee.categoryAlias>
					<cfset thisDepartmentID=LOCAL.GetEmployee.ParentID>
					
					<cfif not len(ThisEmpFirstName) and not Len(ThisEmpLastName)>
						<cfset ThisEmpFirstName=LOCAL.GetEmployee.CategoryName>
					</cfif>
				
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"employeeID",thisEmployeeID)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empFirstName",ThisEmpFirstName)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empLastName",ThisEmpLastName)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empEmail",ThisEmpEmail)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empTitle",ThisEmpTitle)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empBirthDate",ThisEmpBirthdate)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empBirthDate2",ThisEmpBirthdate2)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empJoinDate",ThisEmpJoindate)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empJoinDate2",ThisEmpJoindate2)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empPhone",ThisEmpPhone)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empPhoneExt",ThisEmpPhoneExt)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empCellPhone",ThisEmpCellPhone)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empImage",ThisEmpImage)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empImagethumb",ThisEmpImagethumb)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"departmentID",thisDepartmentID)>
					<cfset QuerySetCell(LOCAL.qryGetEmployee,"empAlias",thisEmpAlias)>
				</cfif>
			</cfloop>
			
			<cfset SetVariable("APPLICATION.EmployeeControl_#DateFormat(GetLastCache.CacheDateTime,'yyyymmdd')##TimeFormat(GetLastCache.CacheDateTime,'HHmmss')#",Now())>
			<cfset APPLICATION.EmployeeQuery=LOCAL.qryGetEmployee>
			<cfreturn LOCAL.qryGetEmployee>
		</cfif>
	</cffunction>
	
	<cffunction name="GetDates" returntype="query" output="1">
		<cfargument name="SelectedDate" type="date" required="No" default="#Now()#">
		<cfargument name="Mode" type="string" required="Yes" default="future">
		<cfargument name="topicIDList" type="string" default="">
	
		<cfset VAR LOCAL=StructNew()>
	
		<cfif ARGUMENTS.topicIDList is "">
			<cfset LOCAL.lEntity="empBirthDate2,empJoinDate2">
		<cfelseif ARGUMENTS.topicIDList is "#APPLICATION.AnniversaryTopicID#"><!--- dev: 6277 --->
			<cfset LOCAL.lEntity="empJoinDate2">
		<cfelseif ARGUMENTS.topicIDList is "#APPLICATION.BirthdayTopicID#"><!--- dev: 6276 --->
			<cfset LOCAL.lEntity="empBirthDate2">
		</cfif>
		
		<cfif NOT IsDefined("REQUEST.GetAllEmployees")>
			<cfinvoke component="com.ContentManager.EmployeeHandler"
				method="GetAllEmployees"
				returnVariable="REQUEST.GetAllEmployees">
		</cfif>
		
		<cfset LOCAL.qReturn=QueryNew("EventType,DateStart,DateStartYearMonth,EmployeeID,EventTitle,Alias","varchar,date,varchar,integer,varchar,varchar,")>

		<cfloop index="LOCAL.ThisEntity" list="#LOCAL.lEntity#">
			<cfquery name="LOCAL.GetEmployeeDate" dbtype="query">
				select * from REQUEST.GetAllEmployees WHERE
				<cfif ARGUMENTS.Mode IS "displayMonth" and isDate(ARGUMENTS.SelectedDate)>
					#LOCAL.ThisEntity#>=<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.SelectedDate#"> and
					#LOCAL.ThisEntity#<<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',1,ARGUMENTS.SelectedDate)#">
				<cfelseif ARGUMENTS.Mode IS "displayDay" and isDate(ARGUMENTS.SelectedDate)>
					#LOCAL.ThisEntity#=<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.SelectedDate#">
				<cfelseif ARGUMENTS.Mode IS "Future">
					#LOCAL.ThisEntity#>=<cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.SelectedDate#"> 
				</cfif>
				order by #LOCAL.ThisEntity#
			</cfquery>
			<cfoutput query="LOCAL.GetEmployeeDate">
				<cfset LOCAL.ThisDate=Evaluate("LOCAL.GetEmployeeDate.#ThisEntity#")>
				<cfif IsDate(LOCAL.ThisDate)>
					<cfif LOCAL.ThisEntity IS "empBirthDate2">
						<cfset LOCAL.ThisCaption="Birthday">
					<cfelseif LOCAL.ThisEntity IS "empJoinDate2">
						<cfset LOCAL.ThisCaption="Anniversary Date">
					</cfif>
					<cfset QueryAddRow(LOCAL.qReturn)>
					<cfset QuerySetCell(LOCAL.qReturn,"EventType","Employee")>
					<cfset QuerySetCell(LOCAL.qReturn,"DateStart",LOCAL.ThisDate)>
					<cfset QuerySetCell(LOCAL.qReturn,"DateStartYearMonth","#DateFormat(LOCAL.ThisDate,'yyyy/mm')#")>
					<cfset QuerySetCell(LOCAL.qReturn,"EmployeeID",LOCAL.GetEmployeeDate.employeeID)>
					<cfset QuerySetCell(LOCAL.qReturn,"EventTitle","#LOCAL.GetEmployeeDate.empFirstName# #LOCAL.GetEmployeeDate.empLastName#'s #LOCAL.ThisCaption#")>
					<cfset QuerySetCell(LOCAL.qReturn,"Alias","#LOCAL.GetEmployeeDate.empAlias#")>
				</cfif>
			</cfoutput>
		</cfloop>
		<cfreturn LOCAL.qReturn>
	</cffunction>
</cfcomponent>