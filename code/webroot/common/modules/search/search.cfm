<cfparam name="URL.pageNum" default="1">
<cfif NOT IsNumeric(URL.pageNum) OR Val(URL.pageNum) LT 1>
	<cfset URL.pageNum = 1>
</cfif>
<cfset thisPageNum = Fix(URL.pageNum)>
<cfparam name="URL.searchTxt" default="">
<!--- START TOPIC --->
<cfparam name="URL.topicAlias" default="">
<cfset thisTopicID = "">
<cfset thisTopicName = "">
<cfif URL.topicAlias NEQ "">
	<cfquery name="GetTopicID" datasource="#APPLICATION.DSN#" maxrows="1">
		SELECT name,id FROM t_Topic
		WHERE topicAlias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.topicAlias#">
	</cfquery>
	<cfif GetTopicID.RecordCount EQ 1>
		<cfset thisTopicID = GetTopicID.id>
		<cfset thisTopicName = GetTopicID.name>
	</cfif>
</cfif>
<!--- END TOPIC --->

<cfset resultsPerPage = 9>
<cfset resultsStart = ((thisPageNum-1)*resultsPerPage)+1>
<cfset URL.searchTxt=Left(URL.searchTxt,35)>
<cfinvoke component="/com/UltraSeek/Search" 
	method="search" 
	SearchText="#URL.searchTxt#"
	Start="#resultsStart-1#"
	NumberOfResults="#resultsPerPage#"
	lCollection="#APPLICATION.UltraseekCollectionName#"
	TopicID="#thisTopicID#"
	returnvariable="sSearchResults"/>
<cfdump var="#sSearchResults#">
<cfset numResults = sSearchResults.TotalResults>
<!--- if page number is out of range, send to page 1 --->
<cfif resultsStart GT numResults AND numResults NEQ 0>
	<cf_AddToQueryString querystring="#CGI.QUERY_STRING#" Name="pageNum" value="1" omitList="x,y">
	<cflocation url="#CGI.REQUEST_URI#?#QueryString#" addtoken="no">
</cfif>


<cfset showFirst = 0>
<cfif thisPageNum GT 1>
	<cfset showFirst = 1>
</cfif>

<cfset lastPageNum = Ceiling(numResults/resultsPerPage)>
<cfset showLast = 0>
<cfif lastPageNum GT thisPageNum>
	<cfset showLast = 1>
</cfif>

<cfset resultsEnd = thisPageNum*resultsPerPage>
<cfif resultsEnd GT numResults>
	<cfset resultsEnd = numResults>
	<cfset numThisPage = (numResults-resultsStart)+1>
<cfelse>
	<cfset numThisPage = resultsPerPage>
</cfif>

	<cfoutput>
	<h1>Results <cfif URL.searchTxt NEQ "" OR thisTopicName EQ "">for &##8220;<em>#URL.searchTxt#</em>&##8221; </cfif><cfif thisTopicName NEQ "">within topic &##8220;<em>#thisTopicName#</em>&##8221;</cfif></h1>
	
	<div class="results">
		<cfmodule template="/common/modules/utils/PaginationUL.cfm"
				QS="#CGI.QUERY_STRING#"
				showFirst="#showFirst#"
				showLast="#showLast#"
				CurrentPageNum="#thisPageNum#"
				LastPageNum="#lastPageNum#">
		<h4><cfif numResults GT 0>#resultsStart#&mdash;#resultsEnd# of </cfif>#numResults# results</h4>
	</div>
	<div style="text-align:right">
	<cfinvoke component="/com/Topic/TopicHandler" method="GetTopicQuery" returnvariable="qGetTopics">
	<!--- This method returns ALL topics, This should really return only relevant topics to search results.
	
	Ideally, the call instead would be:
	<cfinvoke component="/com/UltraSeek/Search" 
	method="GetTopicQuery" 
	SearchText="#URL.searchTxt#"
	lCollection="#APPLICATION.UltraseekCollectionName#"
	returnvariable="qGetTopics"/>
	
	
	--->
	<form action="#CGI.REQUEST_URI#" method="get" id="topicForm">
		<input type="hidden" name="searchTxt" value="#URL.searchTxt#">
		Narrow by Topic:
		<select name="topicAlias" onChange="document.getElementById('topicForm').submit();">
			<option value="">All</option>
			<cfloop query="qGetTopics"><option value="#qGetTopics.topicAlias#"<cfif URL.topicAlias EQ qGetTopics.topicAlias> selected</cfif>>#RepeatString("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",qGetTopics.level-1)#&mdash;#qGetTopics.name#</option></cfloop>
		</select>
	</form>
	</div>
	<dl class="search-results">
		<cfif ArrayLen(sSearchResults.results) GT 0>
		<cfloop from="1" to="#ArrayLen(sSearchResults.results)#" index="i">
			<cfset thisResult = sSearchResults.results[i]>
			<cfset thisAlias = ListFirst(ListLast(thisResult.url,"/"),"?")>
			<!--- START get journal or parent --->
			<cfset thisParentID = 0>
			<cfset parentLinkString = "">
			<cfif Trim(thisAlias) NEQ "">
				<cfquery name="getCategoryInfo" datasource="#APPLICATION.DSN#">
					SELECT CategoryTypeID, DisplayLevel, SourceID, ParentID FROM t_Category
					WHERE CategoryAlias = <cfqueryparam cfsqltype="cf_sql_varchar" value="#thisAlias#">
				</cfquery>
				<cfif getCategoryInfo.RecordCount EQ 1>
					<cfif getCategoryInfo.CategoryTypeID EQ 66><!--- article --->
						<cfquery name="getJournalID" datasource="#APPLICATION.DSN#">
							SELECT JournalCategoryID FROM t_Article
							WHERE ArticleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(getCategoryInfo.SourceID)#">
						</cfquery>
						<cfif getJournalID.RecordCount EQ 1 AND Val(getJournalID.JournalCategoryID) GT 0>
							<cfset thisParentID = getJournalID.JournalCategoryID>
						</cfif>
					</cfif>
					<cfif thisParentID EQ 0 AND getCategoryInfo.DisplayLevel GT 1>
						<cfset thisParentID = getCategoryInfo.ParentID>
					</cfif>
					<cfif thisParentID GT 0>
						<cfquery name="getParentInfo" datasource="#APPLICATION.DSN#">
							SELECT CategoryAlias,CategoryName FROM t_Category
							WHERE CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisParentID#">
							AND CategoryActive = 1
						</cfquery>
						<cfif getParentInfo.RecordCount EQ 1>
							<cfset parentLinkString = "<a href=""/content.cfm/#getParentInfo.CategoryAlias#"">#getParentInfo.CategoryName#</a>">
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			<!--- END get journal or parent --->
			
			<!--- create linked structs of topic name/id pairs
			<cfset sTopicName = StructNew()>
			<cfloop from="1" to="#ArrayLen(thisResult.stringAttributes)#" index="ii">
				<cfset thisString = thisResult.stringAttributes[ii]>
				<cfif Left(thisString.name,Len("category")) EQ "category">
					<cfset StructInsert(sTopicName,"#ListGetAt(thisString.name,2,".")#",thisString.value,1)>
				</cfif>
			</cfloop> --->
			<cfset sTopicID = StructNew()>
			<cfloop from="1" to="#ArrayLen(thisResult.longAttributes)#" index="iii">
				<cfset thisLong = thisResult.longAttributes[iii]>
				<cfif Left(thisLong.name,Len("category.")) EQ "category.">
					<cfset StructInsert(sTopicID,"#ListGetAt(thisLong.name,2,".")#",thisLong.value,1)>
				</cfif>
			</cfloop>
			<!---
			thisResult.url#
			thisResult.title
			thisResult.summary
			--->
			<dt><a href="#thisResult.url#">#thisResult.title#</a></dt>
			<cfif ParentLinkString NEQ ""><dd class="from">#ParentLinkString#</dd></cfif>
			<dd>#thisResult.summary#</dd>
			<cfif ListLen(StructKeyList(sTopicID)) GT 0>
				<dd class="topics">
					Topics:
					<cfset count = 1>
					<cfloop list="#StructKeyList(sTopicID)#" index="key">
						<cfset thisTopicID = StructFind(sTopicID,key)>
						<cfset thisLinkURL = "">
						<cfquery name="getTopic" datasource="#APPLICATION.DSN#">
							SELECT topicAlias,name FROM t_Topic 
							WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisTopicID#">
						</cfquery>
						<cfif getTopic.RecordCount EQ 1>
							<cfset thisLinkURL = "/content.cfm/search">
							<cfif getTopic.topicAlias NEQ "">
								<cfset thisLinkURL = thisLinkURL & "?topicAlias=#getTopic.topicAlias#">
							</cfif>
						</cfif>
						<cfif count GT 1>,</cfif> <a href="#thisLinkURL#">#getTopic.name#</a><Cfset count = count+1>
					</cfloop>
				</dd>
			<cfelse>
				<dd>&nbsp;</dd>
			</cfif>
		</cfloop>
		</cfif>
	</dl>
	<div class="results bottom">
		<cfmodule template="/common/modules/utils/PaginationUL.cfm"
				QS="#CGI.QUERY_STRING#"
				showFirst="#showFirst#"
				showLast="#showLast#"
				CurrentPageNum="#thisPageNum#"
				LastPageNum="#lastPageNum#">
	</div>
	</cfoutput>