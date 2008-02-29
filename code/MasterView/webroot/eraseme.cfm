<cfset hi = "yoyoy">

<cfset bye = "lssl#hi#">

<cfdump var=#bye#>

<!---
<cfinvoke webservice="https://reconnexmod.gmacm.com/PingService.asmx?wsdl"
            method="ping"
            returnVariable="serverInfo">

<cfxml variable="yoyoyo">
<GetListing>
  <GetListingRequest version="1.00">
    <RequestContext>
      <UserID>mfassio@pacunion.com</UserID>
      <Password>616</Password>
      <Reference name="1234">hi</Reference>
    </RequestContext>
    <ListingIDPayload payloadType="" payloadVersion="">
      <ListingID>334505</ListingID>
    </ListingIDPayload>
  </GetListingRequest>
</GetListing>
</cfxml>
--->


<!--- This is the struct for a particular MLS
<!--- define the arguments in a struct to represent the xml equivalents --->
<cfset GetListingRequest.RequestContext = structNew()>
<cfset GetListingRequest.RequestContext.UserID = "mfassio@pacunion.com">
<cfset GetListingRequest.RequestContext.Password = "616">
<cfset GetListingRequest.ListingIDPayload = structNew()>
<cfset GetListingRequest.ListingIDPayload.ListingID = "13500144103">

<!--- invoke the GetListing method in the webservice object --->
<cfinvoke webservice="#myWS#" method="GetListing" returnVariable="myListing">
	
	<!--- pass along the arguments --->
	<cfinvokeargument name="GetListingRequest" value="#GetListingRequest#">
</cfinvoke>

<!--- dump getResponseContext().getResult().toString() --->
<cfset propArray = myListing.getREPropertiesPayload().getREProperties().getResidentialProperty()>

<!--- loop through the properties --->
<cfloop from="1" to="#arrayLen(propArray)#" index="itr">
	<cfset myVar = propArray[itr].getYearBuilt()>
	<cfif isDefined("myVar")>
		<cfdump var=#myVar.toString()#>
	</cfif>
</cfloop>
<cfabort>
--->


<!---
<q0:FindListings>
  <q0:FindListingsRequest version="1.00">
    <q0:RequestContext/>
    <q0:RESearchCriteriaPayload payloadType="" payloadVersion="">
      <q0:RESearchCriteria>
        <q1:REPropertiesSearch>
          <q1:ResidentialPropertySearch>
            <q1:Listing>
              <q1:ListingIDs>
                <q1:ListingID>1234231</q1:ListingID>
                <q1:ListingID>1232132</q1:ListingID>
              </q1:ListingIDs>
            </q1:Listing>
            <q1:StreetAddress/>
          </q1:ResidentialPropertySearch>
        </q1:REPropertiesSearch>
      </q0:RESearchCriteria>
    </q0:RESearchCriteriaPayload>
  </q0:FindListingsRequest>
</q0:FindListings>
--->


<!--- create a MLSSearchServices webservice object --->
<cfobject webservice="https://reconnexmod.gmacm.com/MLSSearchServices.asmx?wsdl" name="myWS">

<!--- define the arguments in a struct to represent the xml equivalents --->
<cfset FindListingsRequest.RequestContext = structNew()>
<cfset FindListingsRequest.RequestContext.UserID = "mfassio@pacunion.com">
<cfset FindListingsRequest.RequestContext.Password = "616">
<!---
<cfset FindListingsRequest.RequestContext.Reference = structNew()>
<cfset FindListingsRequest.RequestContext.Reference.name = "yo">
<cfset thisRef = CreateObject("java","org.apache.axis.types.NMToken")>
<cfset FindListingsRequest.RequestContext.Reference.Reference = thisRef>--->
<cfset FindListingsRequest.RESearchCriteriaPayload = structNew()>
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria = structNew()>
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria.REPropertiesSearch = structNew()>
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria.REPropertiesSearch.ResidentialPropertySearch = structNew()>
<cfset Listing = structNew()>
<cfset Listing.ListingIDs = structNew()>
<cfset Listing.ListingIDs.ListingID = arrayNew(1)>
<cfset arrayAppend(Listing.ListingIDs.ListingID, "13500144103")>
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria.REPropertiesSearch.ResidentialPropertySearch.Listing = Listing>

<!---<cfset ResidentialPropertySearch.Listing.ListingIDs = arrayNew(1)>
<cfset ResidentialPropertySearch.SearchSort = "Date">
<cfset arrayAppend(ResidentialPropertySearch.Listing.ListingIDs, structNew())>
<cfset ResidentialPropertySearch.Listing.ListingIDs[1].ListingID = "13500144103">
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria = structNew()>
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria.REPropertiesSearch = structNew()>
<cfset FindListingsRequest.RESearchCriteriaPayload.RESearchCriteria.REPropertiesSearch.ResidentialPropertySearch = ResidentialPropertySearch>--->

<!--- invoke the FindListings method in the webservice object --->
<cfinvoke webservice="#myWS#" method="FindListings" returnVariable="myResults">
	
	<!--- pass along the arguments --->
	<cfinvokeargument name="FindListingsRequest" value="#FindListingsRequest#">
</cfinvoke>

<cfset propArray = myResults.getREPropertiesPayload().getREProperties().getResidentialProperty()>
<table>
<!--- loop through the properties --->
<cfloop from="1" to="#arrayLen(propArray)#" index="itr">
	<cfset myVar = propArray[itr].getListing()>
	<cfif isDefined("myVar")>
		<tr>
			<td style="border-style:solid;border-width:1px;"><cfoutput>#itr#</cfoutput></td>
			<td style="border-style:solid;border-width:1px;"><cfdump var=#myVar.getListingID()#></td>
			<td style="border-style:solid;border-width:1px;"><cfdump var=#dollarFormat(myVar.getListingData().getListPrice().toString())#></td>
		</tr>
	</cfif>
</cfloop>
</table>
<cfabort>