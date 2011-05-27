function toggleCheckboxes() {
  	var inputlist = document.getElementsByTagName("input");
  	for (i = 0; i < inputlist.length; i++) {
   	if ( inputlist[i].getAttribute("type") == 'checkbox' ) {	// look only at input elements that are checkboxes
		if (inputlist[i].checked)
			inputlist[i].checked = false
		else
			inputlist[i].checked = true;
		}
	}
}
var tb_checkall=1;
function touchCheckboxes() {
  	var inputlist = document.getElementsByTagName("input");
  	for (i = 0; i < inputlist.length; i++) {
   	if ( inputlist[i].getAttribute("type") == 'checkbox' ) {	// look only at input elements that are checkboxes
		if (tb_checkall==1)
			inputlist[i].checked = true
		else
			inputlist[i].checked = false;
		}
	}
	tb_checkall=!tb_checkall;
}

function confirmDelete(DeleteLink) {
	if(confirm("Are you sure you want to delete this record?")) {
		window.location.href = DeleteLink;
	}
}