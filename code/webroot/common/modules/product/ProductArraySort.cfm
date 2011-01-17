<cfparam name="Attributes.ThisArray" type="array"/>
<cfparam name="Attributes.ThisFormID" type="string"/>
<cfparam name="Attributes.IsDisplay" type="numeric"/>
<cfparam name="Attributes.SortIndex" type="numeric" default="0"/>

<cfif Attributes.IsDisplay eq 0> <!--- process --->
	<!--- ordering logic (going to need ones for both the reviews and key features), or better, a function that handles this, takes an index, an arrayname --->
	<cfloop index="r" from="1" to="#ArrayLen(Attributes.ThisArray)#" step="1"> <!--- loop through array of items --->				
		<cfif isdefined("#Attributes.ThisFormID#_ButtonSubmit_up_#r#") OR isdefined("#Attributes.ThisFormID#_ButtonSubmit_down_#r#") OR isdefined("#Attributes.ThisFormID#_ButtonSubmit_bottom_#r#") OR isdefined("#Attributes.ThisFormID#_ButtonSubmit_top_#r#")> <!--- if submitted (up or down --->
			<cfif isdefined("#Attributes.ThisFormID#_ButtonSubmit_up_#r#")> <!--- up --->
				<cfset TempStruct=Attributes.ThisArray[r]> <!--- hold the one in r --->
				<cfset Attributes.ThisArray[r]=Attributes.ThisArray[r-1]> <!--- set r as the next one --->
				<cfset Attributes.ThisArray[r-1]=TempStruct> <!--- move the temp back in --->
			<cfelseif isdefined("#Attributes.ThisFormID#_ButtonSubmit_down_#r#")> <!--- down --->
				<cfset TempStruct=Attributes.ThisArray[r]>
				<cfset Attributes.ThisArray[r]=Attributes.ThisArray[r+1]>
				<cfset Attributes.ThisArray[r+1]=TempStruct>
			<cfelseif isdefined("#Attributes.ThisFormID#_ButtonSubmit_top_#r#")> <!--- top --->
			<!--- here we will need to hold everything on top of the moving one, or we just loop through moving one at a time --->
				<cfset thisTop = r-2/>
				<cfloop index="q" from="0" to="#thisTop#" step="1">
					<cfset thisItem = r - q/>
					<cfset TempStruct=Attributes.ThisArray[thisItem]>
					<cfset Attributes.ThisArray[thisItem]=Attributes.ThisArray[thisItem-1]>
					<cfset Attributes.ThisArray[thisItem-1]=TempStruct>
				</cfloop>
			<cfelseif isdefined("#Attributes.ThisFormID#_ButtonSubmit_bottom_#r#")> <!--- bottom --->
				<cfset thisbottom = #ArrayLen(Attributes.ThisArray)#-1/>
				<cfloop index="q" from="#r#" to="#thisbottom#" step="1">
					<cfset TempStruct=Attributes.ThisArray[q]>
					<cfset Attributes.ThisArray[q]=Attributes.ThisArray[q+1]>
					<cfset Attributes.ThisArray[q+1]=TempStruct>
				</cfloop>
			</cfif> <!--- up or down --->
		</cfif> <!--- end is submitted --->
	</cfloop> <!--- end loop through array of items --->
	<cfset CALLER.ReturnSortArray=Attributes.ThisArray>
<cfelse> <!--- is display --->
	<cfoutput>
		
			<cfif Attributes.SortIndex IS NOT "1"> <!--- not already first in the array --->
				<cfif ArrayLen(Attributes.ThisArray) gt "2">
					<input type="image" name="#Attributes.ThisFormID#_ButtonSubmit_top_#Attributes.SortIndex#" value="top_#Attributes.SortIndex#" src="/common/images/widget_arrow_top.gif">
				<cfelse>
					<img src="/common/images/widget_arrow_top_grey.gif">
				</cfif>
				<input type="image" name="#Attributes.ThisFormID#_ButtonSubmit_up_#Attributes.SortIndex#" value="up_#Attributes.SortIndex#" src="/common/images/widget_arrow_up.gif">
			<cfelse> <!--- is first in array --->
				<img src="/common/images/widget_arrow_top_grey.gif">
				<img src="/common/images/widget_arrow_up_grey.gif">
			</cfif> <!--- not already first in the array --->
			<cfif Attributes.SortIndex IS NOT ArrayLen(Attributes.ThisArray)> <!--- not last in array --->
				<input type="image" name="#Attributes.ThisFormID#_ButtonSubmit_down_#Attributes.SortIndex#" value="down_#Attributes.SortIndex#" src="/common/images/widget_arrow_down.gif">
				<cfif ArrayLen(Attributes.ThisArray) gt "2">
					<input type="image" name="#Attributes.ThisFormID#_ButtonSubmit_bottom_#Attributes.SortIndex#" value="bottom_#Attributes.SortIndex#" src="/common/images/widget_arrow_bottom.gif">
				<cfelse>
					<img src="/common/images/widget_arrow_bottom_grey.gif">
				</cfif>
			<cfelse> <!--- is last in array --->
				<img src="/common/images/widget_arrow_down_grey.gif">
				<img src="/common/images/widget_arrow_bottom_grey.gif">
			</cfif>  <!--- not last in array --->
		
	</cfoutput>
</cfif> <!--- end is process or display --->


