# LDAP Group Authorization Helper Plugin (Version 2.0) #
The LDAP Group Authorization Helper Plugin is a convenience tool for enabling access control using LDAP group assignments. 

This is a rewrite of the original plugin and now no longer uses the `DBMS_LDAP` and `DBMS_LDAP_UTL` packages for performing LDAP lookups. Instead, the plugin uses the `APEX_LDAP` API for interacting with the LDAP server. Hence, only a network ACL privilege is needed for the `APEX_05000` schema to communicate with the LDAP server.

_Please note that this version requires Oracle Application Express 5.0 or later._

# Supported LDAP Servers #
The plugin has been tested to work on the following LDAP Servers:
* Novell eDirectory
* Microsoft Active Directory

# Installation and Setup #
1. Import the plugin as described in the official documentation
2. The file you need to import is: `authorization_type_plugin_com_fuzziebrian_advldapgroupauth.sql`
3. Create an Authorization scheme and provide the necessary information based on the LDAP server used:
  * LDAP Server Host
  * LDAP Server Port
  * Whether to use SSL to bind with the LDAP server
  * Whether to perform an anonymous bind. If not, the additional information is required:
    * Username, the authentication base and password to perform the bind; or
    * User DN and password only to perform the bind
  * Search base
  * User template. For Active Directory, using the attribute `sAMAccountName` instead of CN is advised. This corresponds with the login name.
  * Group DN template
  * Group attribute name
  * Group name
  * Error message to display if authorization fails

# Change History #
* v0.1.0
 * First version.
* v0.1.1
 * Reorganized the file structure to avoid confusion.
 * Updated README with brief instructions on installing the plugin.
* v2.0.0-beta
 * Supports SSL and non-anonymous binds.
 * No longer relies on `DBMS_LDAP` and `DBMS_LDAP_UTL`.
* v2.0.0-beta.1
 * Updated component attribute settings
 * Plugin tested successfully to work with Microsoft Active Directory