<div id="footer">
	<div id="copyr">&copy;
		<cfoutput>
			 #Year(now())# #APPLICATION.CompanyName# |
			#APPLICATION.CompanyStreet# #APPLICATION.CompanyCity# #APPLICATION.CompanyState# #APPLICATION.CompanyZip# | #APPLICATION.CompanyPhone# 
			</div>
            <ul>
        <li><a href="#REQUEST.GlobalNavURLPrefix##APPLICATION.contentPageInUrl#/terms">terms</a></li>
        <li><a href="#REQUEST.GlobalNavURLPrefix##APPLICATION.contentPageInUrl#/about-contact">contact</a></li>
        <li><a href="#REQUEST.GlobalNavURLPrefix##APPLICATION.contentPageInUrl#/faqs">faqs</a></li>
        <li><a href="#REQUEST.GlobalNavURLPrefix##APPLICATION.contentPageInUrl#/site-index">site index</a></li>
    </ul>
            
		</cfoutput>	
	</p>
</div>