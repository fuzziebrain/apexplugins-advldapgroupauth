# Advanced LDAP Group Authorization #
The Advanced LDAP Group Authorization plugin is a convenience tool for enabling access control using LDAP group assignments. 

Unlike its sibling plugin *Simple LDAP Group Authorization* (unreleased), this plugin uses the DBMS_LDAP and DBMS_LDAP_UTL packages instead of APEX_LDAP. While it is easier to use the functions in APEX_LDAP, the API does not allow subtree searching.
# Requirements #
1. A LDAP Directory. **Note:** At this time, this plugin has been only been tested to work against Novell eDirectory.
2. To be completed.

# Installation #
# Change History #
* v0.1.0
 * First version.
