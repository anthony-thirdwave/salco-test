<cfoutput>
	<div id="footer">
		<div id="copyr">&copy;
			#Year(now())# #APPLICATION.CompanyName# |
			#APPLICATION.CompanyStreet# #APPLICATION.CompanyCity# #APPLICATION.CompanyState# #APPLICATION.CompanyZip# | #APPLICATION.CompanyPhone#
		</div>
        <ul>
			<li><a href="#APPLICATION.utilsObj.parseCategoryUrl('terms')#">terms</a></li>
			<li><a href="#APPLICATION.utilsObj.parseCategoryUrl('about-contact')#">contact</a></li>
			<li><a href="#APPLICATION.utilsObj.parseCategoryUrl('faqs')#">faqs</a></li>
			<li><a href="#APPLICATION.utilsObj.parseCategoryUrl('site-index')#">site index</a></li>
    	</ul>
	</div>
</cfoutput>