set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,1580418228149904));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,124);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/authorization_type/com_fuzziebrian_advldapgroupauth
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'AUTHORIZATION TYPE'
 ,p_name => 'COM.FUZZIEBRIAN.ADVLDAPGROUPAUTH'
 ,p_display_name => 'Advanced LDAP Group Authorization'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'FUNCTION IS_USER_IN_GROUP_FUN('||unistr('\000a')||
'    P_AUTHORIZATION IN APEX_PLUGIN.T_AUTHORIZATION,'||unistr('\000a')||
'    P_PLUGIN        IN APEX_PLUGIN.T_PLUGIN )'||unistr('\000a')||
'  RETURN APEX_PLUGIN.T_AUTHORIZATION_EXEC_RESULT'||unistr('\000a')||
'IS'||unistr('\000a')||
'  -- Internal use variables'||unistr('\000a')||
'  L_SESSION DBMS_LDAP.SESSION;                         -- Session variable'||unistr('\000a')||
'  L_USER_HD DBMS_LDAP_UTL.HANDLE;                      -- User handle'||unistr('\000a')||
'  L_GROUP_HD DBMS_LDAP_UTL.HANDLE;            '||
'         -- Group handle'||unistr('\000a')||
'  L_RETVAL PLS_INTEGER;                                -- Return value used frequently'||unistr('\000a')||
'  L_USER_DN  VARCHAR2(100);                            -- User''s DN'||unistr('\000a')||
'  L_GROUP_DN VARCHAR2(100);                            -- Group''s DN'||unistr('\000a')||
'  L_RES DBMS_LDAP.MESSAGE;                             -- LDAP search result(s)'||unistr('\000a')||
'  L_ATTR DBMS_LDAP.STRING_COLLECTION;                  -- Attributes to'||
' return'||unistr('\000a')||
'  L_USERNAME  VARCHAR2(30) := P_AUTHORIZATION.USERNAME; -- Current user'||unistr('\000a')||
'  L_IS_MEMBER BOOLEAN;'||unistr('\000a')||
'  L_RESULT APEX_PLUGIN.T_AUTHORIZATION_EXEC_RESULT; -- Result object to return'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Variables mapped to plugin'||unistr('\000a')||
'  L_LDAP_HOST      VARCHAR2(100) := P_AUTHORIZATION.ATTRIBUTE_01;'||unistr('\000a')||
'  L_LDAP_PORT      NUMBER        := P_AUTHORIZATION.ATTRIBUTE_02;'||unistr('\000a')||
'  L_GROUPNAME      VARCHAR2(30)  := P_AUTHORIZATI'||
'ON.ATTRIBUTE_03;'||unistr('\000a')||
'  L_USER_S_BASE    VARCHAR2(100) := P_AUTHORIZATION.ATTRIBUTE_04;'||unistr('\000a')||
'  L_USER_S_FILTER  VARCHAR2(100) := P_AUTHORIZATION.ATTRIBUTE_05;'||unistr('\000a')||
'  L_GROUP_S_BASE   VARCHAR2(100) := P_AUTHORIZATION.ATTRIBUTE_06;'||unistr('\000a')||
'  L_GROUP_S_FILTER VARCHAR2(100) := P_AUTHORIZATION.ATTRIBUTE_07;'||unistr('\000a')||
'BEGIN'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Substitute setting user and group names in filters'||unistr('\000a')||
'  L_USER_S_FILTER  := REPLACE(L_USER_S_FILTER, ''%LDA'||
'P_USER%'', L_USERNAME);'||unistr('\000a')||
'  L_GROUP_S_FILTER := REPLACE(L_GROUP_S_FILTER, ''%LDAP_GROUP%'', L_GROUPNAME);'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Initialize LDAP session'||unistr('\000a')||
'  L_SESSION := DBMS_LDAP.INIT(L_LDAP_HOST, L_LDAP_PORT);'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Retrieve all attributes'||unistr('\000a')||
'  L_ATTR(1) := ''*'';'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Create user handle'||unistr('\000a')||
'  L_RETVAL := DBMS_LDAP.SEARCH_S(L_SESSION, L_USER_S_BASE,'||unistr('\000a')||
'  DBMS_LDAP.SCOPE_SUBTREE, L_USER_S_FILTER, L_ATTR, 0, L_RES);'||unistr('\000a')||
'  L'||
'_USER_DN := DBMS_LDAP.GET_DN(L_SESSION, L_RES);'||unistr('\000a')||
'  L_RETVAL  := DBMS_LDAP_UTL.CREATE_USER_HANDLE(L_USER_HD,'||unistr('\000a')||
'  DBMS_LDAP_UTL.TYPE_DN, L_USER_DN);'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Create group handle'||unistr('\000a')||
'  L_RETVAL := DBMS_LDAP.SEARCH_S(L_SESSION, L_GROUP_S_BASE,'||unistr('\000a')||
'  DBMS_LDAP.SCOPE_SUBTREE, L_GROUP_S_FILTER, L_ATTR, 0, L_RES);'||unistr('\000a')||
'  L_GROUP_DN := DBMS_LDAP.GET_DN(L_SESSION, L_RES);'||unistr('\000a')||
'  L_RETVAL   := DBMS_LDAP_UTL.CREATE_GROUP_HANDLE('||
'L_GROUP_HD,'||unistr('\000a')||
'  DBMS_LDAP_UTL.TYPE_DN, L_GROUP_DN);'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Check group membership'||unistr('\000a')||
'  L_RETVAL := DBMS_LDAP_UTL.CHECK_GROUP_MEMBERSHIP( L_SESSION, L_USER_HD,'||unistr('\000a')||
'  L_GROUP_HD, DBMS_LDAP_UTL.DIRECT_MEMBERSHIP );'||unistr('\000a')||
'  L_IS_MEMBER := L_RETVAL = DBMS_LDAP_UTL.SUCCESS;'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Clean up resources'||unistr('\000a')||
'  L_RETVAL := DBMS_LDAP.MSGFREE(L_RES);'||unistr('\000a')||
'  L_RETVAL := DBMS_LDAP.UNBIND_S(L_SESSION);'||unistr('\000a')||
'  --'||unistr('\000a')||
'  -- Set and return resu'||
'lts'||unistr('\000a')||
'  L_RESULT.IS_AUTHORIZED := L_IS_MEMBER;'||unistr('\000a')||
'  RETURN L_RESULT;'||unistr('\000a')||
'END IS_USER_IN_GROUP_FUN;'
 ,p_execution_function => 'is_user_in_group_fun'
 ,p_substitute_attributes => true
 ,p_version_identifier => '0.1'
 ,p_about_url => 'http://fuzziebrain.com/content/id/246'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 373469900148865642 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'LDAP Host'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'ldap.example.org'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the LDAP host.</p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 374557007744109817 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'LDAP Port'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => true
 ,p_default_value => '389'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the LDAP port number.</p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 373470914000869654 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Group Name'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'MyGroup'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the LDAP group name.</p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 373471418848871078 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'User Search Base'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'ou=people,o=apex,dc=fuzziebrain,dc=com'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the user search base.</p>'||unistr('\000a')||
'<p><em>Sub-tree searching is currently enabled by default and it is not configurable. If users are located in different branches, enter a search base higher up the tree.</em></p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 373473716938182777 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'User Search Filter'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => '(&(objectclass=Person)(CN=%LDAP_USER%))'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the user search filter to use.</p>'||unistr('\000a')||
'<p><em>Change the default filter if necessary, otherwise, this filter should work for most cases. The %LDAP_USER% is the place holder for the APP_USER (user currently logged on).</em></p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 374538129945068897 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Group Search Base'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'ou=groups,ou=applications,o=apex,dc=fuzziebrain,dc=com'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the group search base.</p>'||unistr('\000a')||
'<p><em>Sub-tree searching is currently enabled by default and is not configurable. Unlike the user search base, it is recommended that the search scope be as narrow as possible. Application groups should be restricted to a single organizational unit (OU). However, if application groups are scattered across different OU, then enter a search base higher up the tree.</em></p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 374538800293069854 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 373468518567700627 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Group Search Filter'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => '(&(objectclass=groupOfNames)(CN=%LDAP_GROUP%))'
 ,p_is_translatable => false
 ,p_help_text => '<p>Please enter the group search filter to use.</p>'||unistr('\000a')||
'<p><em>Change the default filter if necessary, otherwise, this filter should work for most cases. The %LDAP_GROUP% is the place holder for the "Group Name" entered for this authorization scheme.</em></p>'
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
