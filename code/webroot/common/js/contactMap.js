'use strict'

$(window).load(function() { 

    /****************************************
                Helper Data Start
    ****************************************/

    var regionHelper = {
        'region-1': [
            'nb-ns-ca', 'sydney-ca', 'nf-ca', 'hb-island-1', 'ai-ca', 'sum-char-ca', 'tui-ca',
            'bi-ca', 'vii-ca', 'kwi-ca', 'shi-ca', 'mi-ca', 'ni-ca', 'si-ca-3', 
            'pci-ca', 'pwi-ca', 'bai-ca', 'si-ca-2', 'on-ca', 'nl-ca', 'qc-ca',
            'yt-ca', 'unt-ca', 'lnt-ca', 'nu-ca', 'nu-u-ca', 'unu-ca', 'unu2-ca',
            'nb-ns-ca', 'sydney-ca', 'nf-ca', 'hb-island-1', 'ai-ca', 'sum-char-ca',
            'tui-ca', 'bi-ca', 'vii-ca', 'kwi-ca', 'shi-ca', 'mi-ca', 'ni-ca',
            'si-ca-3', 'pci-ca', 'pwi-ca', 'bai-ca', 'si-ca-2', 'on-ca', 'nl-ca',
            'qc-ca', 'yt-ca', 'unt-ca', 'lnt-ca', 'nu-ca', 'nu-u-ca', 'unu-ca', 
            'unu2-ca', 'pei-ca'
        ]
    }

    var contactHelper = {
        contacts: [
            'stoy-taylor', 'nathan-monico', 'scottie-primeaux', 'tyler-jepsen', 'dennis-rivardo', 'scott-swanson',
            'griffin-shiele', 'todd-waggoner', 'jim-mclaughlin', 'bill-dillon', 'andy-shelp', 'pete-petersen',
            'randy-bowman', 'tony-segovia', 'david-clugg', 'edwin-luper'
        ],
        us: {
            'fl-us': { 'contact': 'stoy-taylor', 'techSales': 'nathan-monico' },
            'sc-us': { 'contact': 'stoy-taylor', 'techSales': 'nathan-monico' },
            'ga-us': { 'contact': 'stoy-taylor', 'techSales': 'nathan-monico' },
            'al-us': { 'contact': 'stoy-taylor', 'techSales': 'nathan-monico' },
            'ms-us': { 'contact': 'stoy-taylor', 'techSales': 'nathan-monico' },
            'la-us': { 'contact': 'scottie-primeaux', 'techSales': 'tyler-jepsen' },
            'ar-us': { 'contact': 'scottie-primeaux', 'techSales': 'tyler-jepsen' },
            'ok-us': { 'contact': 'dennis-rivardo', 'techSales': 'tyler-jepsen' },
            'nm-us': { 'contact': 'scott-swanson', 'techSales': 'tyler-jepsen' },
            'az-us': { 'contact': 'scott-swanson', 'techSales': 'griffin-shiele' },
            'ca-us': { 'contact': 'todd-waggoner', 'techSales': 'griffin-shiele' },
            'or-us': { 'contact': 'todd-waggoner', 'techSales': 'griffin-shiele' },
            'wa-us': { 'contact': 'todd-waggoner', 'techSales': 'griffin-shiele' },
            'id-us': { 'contact': 'scott-swanson', 'techSales': 'griffin-shiele' },
            'mt-us': { 'contact': 'jim-mclaughlin', 'techSales': 'bill-dillon' },
            'nd-us': { 'contact': 'jim-mclaughlin', 'techSales': 'bill-dillon' },
            'mn-us': { 'contact': 'todd-waggoner', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'mi-up-us': { 'contact': 'jim-mclaughlin', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'wi-us': { 'contact': 'jim-mclaughlin', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'mi-us': { 'contact': 'jim-mclaughlin', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'oh-us': { 'contact': 'randy-bowman', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'ny-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'ct-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'vt-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'nh-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'me-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'ma-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'ri-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'nj-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'dl-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'va-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'wv-us': { 'contact': 'randy-bowman', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'md-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'nc-us': { 'contact': 'pete-petersen', 'techSales': 'nathan-monico' },
            'tn-us': { 'contact': 'randy-bowman', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'ky-us': { 'contact': 'randy-bowman', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'ks-us': { 'contact': 'edwin-luper', 'techSales': 'tyler-jepsen' },
            'co-us': { 'contact': 'jim-mclaughlin', 'techSales': 'bill-dillon' },
            'ut-us': { 'contact': 'scott-swanson', 'techSales': 'griffin-shiele' },
            'wy-us': { 'contact': 'jim-mclaughlin', 'techSales': 'bill-dillon' },
            'nv-us': { 'contact': 'scott-swanson', 'techSales': 'griffin-shiele' },
            'sd-us': { 'contact': 'jim-mclaughlin', 'techSales': 'bill-dillon' },
            'ia-us': { 'contact': 'todd-waggoner', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'ne-us': { 'contact': 'todd-waggoner', 'techSales': 'bill-dillon' },
            'in-us': { 'contact': 'randy-bowman', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'il-us': { 'contact': 'randy-bowman', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'mo-us': { 'contact': 'david-clugg', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'pa-us': { 'contact': 'pete-petersen', 'techSales': 'andy-shelp' },
            'tx-us': { 'contact': 'edwin-luper', 'techSales': 'tyler-jepsen' },
            'il-in-upper-us': { 'contact': 'jim-mclaughlin', 'techSales': ['andy-shelp', 'bill-dillon'] },
            'pa-western-us': { 'contact': 'randy-bowman', 'techSales': 'andy-shelp' },
            'tx-northern-us': { 'contact': 'tony-segovia', 'techSales': 'tyler-jepsen' }
        },
        mexico: { 'contact': 'tony-segovia' },
        canada: {
            'bc-ca': { contact: 'todd-waggoner', techSales: 'griffin-shiele' },
            'vi-ca': { contact: 'todd-waggoner', techSales: 'tyler-jepsen' },
            'ab-ca': { contact: 'todd-waggoner', techSales: 'tyler-jepsen' },
            'sk-ca': { contact: 'todd-waggoner', techSales: 'tyler-jepsen' },
            'mb-ca': { contact: 'todd-waggoner', techSales: 'tyler-jepsen' },
            'region-1': { contact: 'pete-petersen', techSales: 'griffin-shiele' }
        },
        alaska: { contact: 'scott-swanson', techSales: 'griffin-shiele' }
    }

    /****************************************
                Helper Data End
    ****************************************/

    /****************************************
            Helper Functions Start
    ****************************************/

    var resetMap = function() {
        $('.regions').attr('fill', '#959595')
        $('#il-mo-us-annex').attr('stroke', 'none')
        $('#il-upper-us').attr('stroke', 'none')
        $('#il-upper-border-us').attr('stroke', 'none')
        $('#il-in-upper-us').attr('fill', 'none')
        $('#il-in-upper-us').attr('stroke', 'none')
        $('#pa-western-us').attr('stroke', 'none')
        $('#tx-northern-us-line').attr('stroke', 'none')
        resetContactDisplay()
    }

    var handleRegionClick = function(idArray) {
        idArray.forEach(function(sectionId) {
            document.getElementById(sectionId).setAttribute('fill', '#C1272D')
        })
    }

    var handleRegionHighlight = function(elementId, idArray, action) {
        // Only handle highlights if this region is not in a clicked state
        if (document.getElementById(elementId).getAttribute('fill') !== '#C1272D') {
            var highlightColor = ''

            action === 'mouseEnter'
                ? highlightColor = '#E8858C'
                : highlightColor = '#959595'

            idArray.forEach(function(sectionId) {
                document.getElementById(sectionId).setAttribute('fill', highlightColor)
            })
        }
    }

    var handleIllinoisIndianaClick = function(elementId) {
        // Show Illinois/Indiana subsections, reset highlighting
        document.getElementById('il-us').setAttribute('fill', '#959595')
        document.getElementById('in-us').setAttribute('fill', '#959595')
        document.getElementById('il-in-upper-us').setAttribute('stroke', 'white')

        if (elementId === 'il-us' || elementId === 'il-mo-us-annex') {
            // Central Illinois
            document.getElementById('il-us').setAttribute('fill', '#C1272D')
            document.getElementById('il-mo-us-annex').setAttribute('fill', '#C1272D')
            document.getElementById('il-in-upper-us').setAttribute('fill', '#959595')
        }
        else if (elementId === 'il-in-upper-us') {
            // North Illinois/Indiana
            document.getElementById('il-in-upper-us').setAttribute('fill', '#C1272D')
        }
        else {
            // Indiana
            document.getElementById('il-mo-us-annex').setAttribute('stroke', 'none')
            document.getElementById('in-us').setAttribute('fill', '#C1272D')
            document.getElementById('il-in-upper-us').setAttribute('fill', '#959595')
        }
    }

    var handleIllinoisIndianaMouseEnter = function(elementId) {
        document.getElementById('il-in-upper-us').setAttribute('stroke', 'white')
        var northIllinoisHighlight = ''

        document.getElementById('il-in-upper-us').getAttribute('fill') === '#C1272D'
            ? northIllinoisHighlight = '#C1272D'
            : northIllinoisHighlight = '#959595'

        if (elementId === 'il-us' || elementId === 'il-mo-us-annex') {
            document.getElementById('il-us').setAttribute('fill', '#E8858C')
            document.getElementById('il-mo-us-annex').setAttribute('fill', '#E8858C')
            document.getElementById('il-in-upper-us').setAttribute('fill', northIllinoisHighlight)
        }

        if (elementId === 'il-in-upper-us') {
            if (northIllinoisHighlight !== '#C1272D') {
                document.getElementById('il-in-upper-us').setAttribute('fill', '#E8858C')       
            }
        }

        if (elementId === 'in-us') {
            document.getElementById('in-us').setAttribute('fill', '#E8858C')
            document.getElementById('il-in-upper-us').setAttribute('fill', northIllinoisHighlight)
        }
    }

    var handleIllinoisIndianaMouseLeave = function(elementId) {
        var clickedElement = ''

        var isAnyRegionClicked = function isAnyRegionClicked(element) {
            if (document.getElementById(element).getAttribute('fill') === '#C1272D') {
                clickedElement = element
            }
        };

        ['il-us', 'il-in-upper-us', 'in-us'].forEach(isAnyRegionClicked)

        if (clickedElement.length) {
            // If there is any region in Illinois/Indiana clicked, we need special highlight rules
            if (clickedElement === 'in-us') {
                document.getElementById('in-us').setAttribute('fill', '#C1272D')
                document.getElementById('il-us').setAttribute('fill', '#959595')
                document.getElementById('il-mo-us-annex').setAttribute('fill', '#959595')
            }
            else if (clickedElement === 'il-in-upper-us') {
                document.getElementById('in-us').setAttribute('fill', '#959595')
                document.getElementById('il-us').setAttribute('fill', '#959595')
                document.getElementById('il-mo-us-annex').setAttribute('fill', '#959595')
                document.getElementById('il-in-upper-us').setAttribute('fill', '#C1272D')
            }
            else {
                document.getElementById('in-us').setAttribute('fill', '#959595')
                document.getElementById('il-in-upper-us').setAttribute('fill', '#959595')
            }
        }
        else {
            // If no state is selected, this will handle mouse leave highlighting
            document.getElementById('il-in-upper-us').setAttribute('stroke', 'none')
            document.getElementById('il-us').setAttribute('fill', '#959595')
            document.getElementById('il-mo-us-annex').setAttribute('fill', '#959595')
            document.getElementById('in-us').setAttribute('fill', '#959595')
            $('#il-in-upper-us').attr('fill', 'none').fadeI
        }
    }

    var handlePennsylvaniaMouseEnter = function(elementId) {
        // Split Pennsylvania into subsections
        document.getElementById('pa-western-us').setAttribute('stroke', 'white')

        // Fill the subsection we are mousing over
        elementId === 'pa-western-us'
            ? document.getElementById('pa-western-us').setAttribute('fill', '#E8858C')
            : document.getElementById('pa-us').setAttribute('fill', '#E8858C')
    }

    var handlePennsylvaniaMouseLeave = function(elementId) {
        var isPaRegionClicked = false;

        // If a subsection is not in a clicked state, we highlight it
        ['pa-western-us', 'pa-us'].forEach(function(paElement) {
            document.getElementById(paElement).getAttribute('fill') !== '#C1272D'
                ? document.getElementById(paElement).setAttribute('fill', '#959595')
                : isPaRegionClicked = true
        })

        // If a Pennsylvania subsection is in a clicked state, we don't hide the subsections
        if (!isPaRegionClicked) document.getElementById('pa-western-us').setAttribute('stroke', 'none');
    }

    var handleTexasMouseEnter = function(elementId) {
        document.getElementById('tx-northern-us-line').setAttribute('stroke', 'white')

        elementId === 'tx-northern-us'
            ? document.getElementById('tx-northern-us').setAttribute('fill', '#E8858C')
            : document.getElementById('tx-us').setAttribute('fill', '#E8858C')
    }

    var handleTexasMouseLeave = function(elementId) {
        var isTexasRegionClicked = false;

        ['tx-us', 'tx-northern-us'].forEach(function(txElement) {
            document.getElementById(txElement).getAttribute('fill') !== '#C1272D'
                ? document.getElementById(txElement).setAttribute('fill', '#959595')
                : isTexasRegionClicked = true
        })

        if (!isTexasRegionClicked) document.getElementById('tx-northern-us-line').setAttribute('stroke', 'none')
    }

    var handleAlaskaClick = function() {
        for (var i = 1; i <= 20; i++) {
            document.getElementById('ak-' + i + '-us').setAttribute('fill', '#C1272D')
        }
    }

    var handleAlaskaHighlight = function(elementId, action) {
        // Only handle highlights if Alaska is not in a clicked state
        if (document.getElementById(elementId).getAttribute('fill') !== '#C1272D') {
            var highlightColor = ''

            action === 'mouseEnter'
                ? highlightColor = '#E8858C'
                : highlightColor = '#959595'

            for (var i = 1; i <= 20; i++) {
                document.getElementById('ak-' + i + '-us').setAttribute('fill', highlightColor)
            }
        }
    }

    var handleRegionClick = function(idArray) {
        idArray.forEach(function(sectionId) {
            document.getElementById(sectionId).setAttribute('fill', '#C1272D')
        })
    }

    var handleRegionHighlight = function(elementId, idArray, action) {
        // Only handle highlights if this region is not in a clicked state
        if (document.getElementById(elementId).getAttribute('fill') !== '#C1272D') {
            var highlightColor = ''

            action === 'mouseEnter'
                ? highlightColor = '#E8858C'
                : highlightColor = '#959595'

            idArray.forEach(function(sectionId) {
                document.getElementById(sectionId).setAttribute('fill', highlightColor)
            })
        }
    }

    var showContactDisplay = function(regionId) {
        var contactId

        if (regionId.includes('ak-')) {
            contactId = contactHelper.alaska
        }
        else if (regionId.includes('-us')) {
            if (regionId === 'il-mo-us-annex') contactId = contactHelper.us['il-us']
            else contactId = contactHelper.us[regionId]
        }
        else if (regionId === 'mx') {
            contactId = contactHelper.mexico
        }
        else {
            if (document.getElementById(regionId).classList.value === 'regions region-1') {
                contactId = contactHelper.canada['region-1']
            }
            else {
                contactId = contactHelper.canada[regionId]
            }
        }

        // Hide Contact Us Map Summary
        document.getElementById('region0').classList.add('hidden')

        // Reset Curent Shown Contacts
        contactHelper.contacts.forEach(function(contactId) {
            document.getElementById(contactId).classList.add('hidden')
        })

        // Show the contact of this state/region
        document.getElementById(contactId.contact).classList.remove('hidden')

        // If there are tech sales, seperate with a white border line
        if (contactId.hasOwnProperty('techSales')) {
            document.getElementById(contactId.contact).style.borderBottom = '1px solid #fff'
        }

        // If techSales is an array, show each tech sale person
        if (contactId.techSales && Array.isArray(contactId.techSales)) {
            contactId.techSales.forEach(function(tech, index) {
                document.getElementById(tech).classList.remove('hidden')
            })

            document.getElementById(contactId.techSales[1]).style.paddingTop = '20px'
            document.getElementById(contactId.techSales[0]).children[0].children[0].style.display = 'none'
        }
        else {
            if (contactId.techSales) {
                document.getElementById(contactId.techSales).classList.remove('hidden')
                document.getElementById(contactId.techSales).style.paddingTop = '20px'
            }
        }
    }

    var resetContactDisplay = function() {
        // Show Contact Us Map Summary
        document.getElementById('region0').classList.remove('hidden')

        // Make sure each state/region contact is hidden
        contactHelper.contacts.forEach(function(contactId) {
            document.getElementById(contactId).classList.add('hidden')
        })

        // Hide office contacts
        document.getElementById('region12').classList.add('hidden')
        document.getElementById('region13').classList.add('hidden')
        document.getElementById('region14').classList.add('hidden')
    }

    /****************************************
            Helper Functions End
    ****************************************/

    /****************************************
            Contact Map Start
    ****************************************/

    var contactUsMap = {
        init: function() {
            $('svg rect').bind('click', function() {
                resetMap()
            })

            // Office Dot Click/Mouse Enter/Mouse Leave
            $('.office-dot').click(function() {
                resetMap()
                $("#regoin14").addClass("hidden");
                var officeRegion = ''
                
                this.id === 'chicago-office' ? officeRegion = 'region13' : officeRegion = 'region12'

                document.getElementById(officeRegion).classList.remove('hidden')
                document.getElementById('region0').classList.add('hidden')

                var getOffice = '#' + $(this).attr('id') + '-selected';
            
                $('.office-circle').attr('class', 'office-circle');
                $('.office-circle').attr('stroke', 'transparent');
            
                $(getOffice).attr('class', 'office-circle office-active');
                $(getOffice).attr('stroke', '#000000');
            })
            .mouseenter(function() {
                $('.office-circle').each(function(index, element) {
                    if ($(this).attr('class') === 'office-circle') {
                        $(this).attr('stroke', 'transparent')
                    }
                })

                var getOffice = '#' + $(this).attr('id') + '-selected'
                $(getOffice).attr('stroke', '#000000')
            })
            .mouseleave(function() {
                $('.office-circle').each(function(index, element) {
                    if ($(this).attr('class') === 'office-circle') {
                        $(this).attr('stroke', 'transparent')
                    }
                })
            })
        
            // Contact Us Map Click/Mouse Enter/Mouse Leave
            $('.regions').click(function() {
                $("#regoin14").addClass("hidden");
                // Un-select states/regions/offices
                $('.regions').attr('fill', '#959595')
                $('.office-circle').attr('stroke', 'transparent')

                // Reset sales contacts display
                resetContactDisplay()

                // Fixes northern Illinois/Indiana border getting greyed out
                $('#il-in-upper-us').attr('fill', 'none').fadeI;

                document.getElementById('tony-segovia').style.borderBottom = 'none'

                // Handle Illinois/Indiana clicking
                if (['il-us', 'il-in-upper-us', 'il-mo-us-annex', 'in-us'].includes(this.id)) {
                    // Hide Pennsylvania/Texas subsection lines
                    document.getElementById('pa-western-us').setAttribute('stroke', 'none')
                    document.getElementById('pa-us').setAttribute('stroke', 'white')
                    document.getElementById('tx-northern-us-line').setAttribute('stroke', 'none')

                    handleIllinoisIndianaClick(this.id)
                }
                else {
                    // Hide Illinois/Indiana subsections when we click on a different state
                    document.getElementById('il-in-upper-us').setAttribute('stroke', 'none')
                    document.getElementById('il-mo-us-annex').setAttribute('stroke', 'none')

                    // If we are not clicking on Pennsylvania, hide its subsections
                    if (this.id !== 'pa-western-us' && this.id !== 'pa-us') {
                        document.getElementById('pa-western-us').setAttribute('stroke', 'none')
                        document.getElementById('pa-us').setAttribute('stroke', 'white')
                    }

                    // If we are not clicking on Texas, hide its subsections
                    if (this.id !== 'tx-us' && this.id !== 'tx-northern-us') {
                        document.getElementById('tx-northern-us-line').setAttribute('stroke', 'none')
                    }

                    // If we are clicking on any part of Alaska, highlight its 20 sections
                    if ((this.id).includes('ak-')) {
                        handleAlaskaClick()
                    }
                    // Handle British Columbia click
                    else if (['bc-ca', 'vi-ca', 'hg-ca', 'gi-ca'].includes(this.id)) {
                        handleRegionClick(['bc-ca', 'vi-ca', 'hg-ca', 'gi-ca'])
                    }
                    // Handle Big North Canada Region together
                    else if (document.getElementById(this.id).classList[1] === 'region-1') {
                        handleRegionClick(regionHelper['region-1'])
                    }
                    // Highlights selected state
                    else {
                        document.getElementById(this.id).setAttribute('fill', '#C1272D')
                    }
                }

                showContactDisplay(this.id)
            })
            .mouseenter(function() {
                // If a state/region is in a clicked state, we want to ignore mouse enter on it
                if ($(this).attr('fill') !== '#C1272D') {
                    if (['il-us', 'il-mo-us-annex', 'il-in-upper-us', 'in-us'].includes(this.id)) {
                        handleIllinoisIndianaMouseEnter(this.id)
                    }
                    else if (['pa-us', 'pa-western-us'].includes(this.id)) {
                        handlePennsylvaniaMouseEnter(this.id)
                    }
                    else if (['tx-us', 'tx-northern-us'].includes(this.id)) {
                        handleTexasMouseEnter(this.id)
                    }
                    else if ((this.id).includes('ak-')) {
                        handleAlaskaHighlight(this.id, 'mouseEnter')
                    }
                    else if (['bc-ca', 'vi-ca', 'hg-ca', 'gi-ca'].includes(this.id)) {
                        handleRegionHighlight(this.id, ['bc-ca', 'vi-ca', 'hg-ca', 'gi-ca'], 'mouseEnter')
                    }
                    else if (document.getElementById(this.id).classList[1] === 'region-1') {
                        handleRegionHighlight(this.id, regionHelper['region-1'], 'mouseEnter')
                    }
                    else {
                        document.getElementById(this.id).setAttribute('fill', '#E8858C')
                    }
                }
            })
            .mouseleave(function() {
                // If a state/region is in a clicked state, we want to ignore mouse leave on it
                if ($(this).attr('fill') !== '#C1272D') {
                    if (['il-us', 'il-in-upper-us', 'il-mo-us-annex', 'in-us'].includes(this.id)) {
                        handleIllinoisIndianaMouseLeave(this.id)
                    }
                    else if (['pa-us', 'pa-western-us'].includes(this.id)) {
                        handlePennsylvaniaMouseLeave(this.id)
                    }
                    else if (['tx-us', 'tx-northern-us'].includes(this.id)) {
                        handleTexasMouseLeave(this.id)
                    }
                    else if ((this.id).includes('ak-')) {
                        handleAlaskaHighlight(this.id, 'mouseLeave')
                    }
                    else if (['bc-ca', 'vi-ca', 'hg-ca', 'gi-ca'].includes(this.id)) {
                        handleRegionHighlight(this.id, ['bc-ca', 'vi-ca', 'hg-ca', 'gi-ca'], 'mouseLeave')
                    }
                    else if (document.getElementById(this.id).classList[1] === 'region-1') {
                        handleRegionHighlight(this.id, regionHelper['region-1'], 'mouseLeave')
                    }
                    else {
                        document.getElementById(this.id).setAttribute('fill', '#959595')
                    }
                }
            })
        }
    }

    /****************************************
                Contact Map End
    ****************************************/

    contactUsMap.init();

});
