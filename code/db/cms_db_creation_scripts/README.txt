1) Change each default instance of "cmsdemo_cms_dev" in CreateDatabase.sql to match the value of "ThisDSN" 
in ApplicationSetup.cfm

2) Run CreateDatabase.sql at the master level of the machine where you want to install the DB.

3) Run CreateSchema.sql in your newly created DB. You must be a member of the sysadmin fixed server role to set
all of the permissions properly through this script.

4) Run CreateStoredProcedures.sql in your newly created DB.

5) Run GrantPermissions.sql in your newly created DB.

5) Run LoadData.sql in your newly created DB.