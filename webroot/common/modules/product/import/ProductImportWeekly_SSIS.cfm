
<cfset My_NewArray=ArrayNew(1)>
<cfset My_NewArray[1]="/FileName"/>
<!--- staging:  D:\websites.staging\salco\Resources\W\ProductUpdates --->
<!--- dev: 		D:\websites\Salco\resources\w\ProductUpdates --->
<cfset My_NewArray[2]="D:\websites.staging\salco\Resources\W\ProductUpdates\ChesserReport.xlsx"/>
<cfdump var="#My_NewArray#">
    
<cfset objConsole=CreateObject("java","com.mapforce.ProductsHierarchyData_ImportConsole")>
<cfdump var="#objConsole#"/>
<cfset result=objConsole.importStatus(My_NewArray)>
<cfoutput>The result is: #result#</cfoutput>


<cfset oThread = CreateObject("java", "java.lang.Thread") />
<cfset oThread.sleep(200000) />  <!--- Time in Milliseconds, 3min ---->
  

<cffunction name="ImportProductHierarchyData" output="yes" returntype="any" hint="Returns all the possible results for the passed values"> 
	<cfstoredproc procedure="usp_updateProductsHierarchyData" datasource="#APPLICATION.DSN#" returncode="yes">
		<cfprocresult name="result">   
		testtest
	</cfstoredproc>
	RESULTS ::<cfdump var="#result#"/><br/>
	 The SendMail task is completed.: 100% complete 
</cffunction> 

<cfinvoke method="ImportProductHierarchyData">
<cfdump var="End of Proc execution"/>

<!---Date/Time stamp to append to original file name--->
<cfset AppendStamp=DateFormat(Now(),"yyyymmdd") & "_" & TimeFormat(Now(),"HHmmss")>

<!---File that was already there before upload--->
<cfset existingfile="ChesserReport">

<!---Extension of file already there before upload--->
<cfset kindoffile=".xlsx">

<!---Rename the existing file by appending date/time stamp--->
<cfset renameexisting=existingfile & "_" & AppendStamp & kindoffile>

<cfset dir="D:\websites.staging\salco\Resources\W\ProductUpdates">

<!---Rename existing--->
<cffile action="rename" nameconflict="overwrite" source="#dir##existingfile##kindoffile#" destination="#dir##renameexisting#">

