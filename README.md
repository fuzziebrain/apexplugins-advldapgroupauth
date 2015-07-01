# LDAP Group Authorization Helper Plugin (Version 2.0) #
The LDAP Group Authorization Help Plugin is a convenience tool for enabling access control using LDAP group assignments. 

This is a rewrite of the original plugin and now no longer uses the DBMS_LDAP and DBMS_LDAP_UTL packages for performing LDAP lookups. Instead, the plugin uses the APEX_LDAP API for interacting with the LDAP server. Hence, only a network ACL privilege is needed for the APEX_05000 schema to communicate with the LDAP server.

_Please note that this version requires Oracle Application Express 5.0 or later._

# Requirements #
A LDAP Directory. **Note:** At this time, this plugin has been only been tested to work against Novell eDirectory.

# Installation #
1. Import the plugin as described in the official documentation.
2. The file you need to import is: authorization_type_plugin_com_fuzziebrian_advldapgroupauth.sql

# Change History #
* v0.1.0
 * First version.
* v0.1.1
 * Reorganized the file structure to avoid confusion.
 * Updated README with brief instructions on installing the plugin.
* v2.0.0-beta
 * Supports SSL and non-anonymous binds.
 * No longer relies on DBMS_LDAP and DBMS_LDAP_UTL.