<cffunction name="GetDateByWeek" access="public" returntype="date" output="false" hint="Gets the first day of the week of the given year/week combo.">
	<!--- Define arguments. --->
	<cfargument name="Year" type="numeric" required="true" hint="The year we are looking at." />
	<cfargument name="Week" type="numeric" required="true" hint="The week we are looking at (1-53)."/>
	<!--- Define the local scope. --->
	<cfset var LOCAL = StructNew() />
<!---Get the first day of the year. This one is easy, we know it will always be January 1st of the given year. --->
<cfset LOCAL.FirstDayOfYear = CreateDate(ARGUMENTS.Year,1,1) /> 
<!---
Based on the first day of the year, let's
get the first day of that week. This will be
the first day of the calendar year.
--->
<cfset LOCAL.FirstDayOfCalendarYear = (
LOCAL.FirstDayOfYear -
DayOfWeek( LOCAL.FirstDayOfYear ) +
1
) />
 
<!---
Now that we know the first calendar day of
the year, all we need to do is add the
appropriate amount of weeks. Weeks are always
going to be seven days.
--->
<cfset LOCAL.FirstDayOfWeek = (
LOCAL.FirstDayOfCalendarYear +
(
(ARGUMENTS.Week - 1) *
7
)) />
 
 
<!---
Return the first day of the week for the
given year/week combination. Make sure to
format the date so that it is not returned
as a numeric date (this will just confuse
too many people).
--->
<cfreturn DateFormat( LOCAL.FirstDayOfWeek ) />
</cffunction>