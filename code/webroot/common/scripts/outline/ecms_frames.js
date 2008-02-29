/*
	*	File:		ecms_frames.js
	*	Name:		Expandable/Collapsible Menu System
	*	Date:		2001-06-22

	*	Author:		Ben Boyle
	*	Email:		bboyle@inspire.server101.com

	*	Platform:	Netscape Navigator 4.x (document.layers)

	Workaround for loading bug - use when putting the menu into frames

*/

// netscape resize bug
if (document.layers) {
	document.writeln('<p class="error"><strong>Netscape 4 users:</strong> if you do not see the menu, <a href="javascript:location.reload();" target="_self">reload this frame</a>.</p>');
}
