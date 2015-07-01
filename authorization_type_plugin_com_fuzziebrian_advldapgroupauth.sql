set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.0.00.31'
,p_default_workspace_id=>4175304812635751
,p_default_application_id=>231
,p_default_owner=>'BRONCO'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/authorization_type/com_fuzziebrian_advldapgroupauth
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(24705506700305701)
,p_plugin_type=>'AUTHORIZATION TYPE'
,p_name=>'COM.FUZZIEBRIAN.ADVLDAPGROUPAUTH'
,p_display_name=>'Advanced LDAP Group Authorization'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'FUNCTION is_user_in_group_fun (',
'    p_authorization IN apex_plugin.t_authorization,',
'    p_plugin        IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_authorization_exec_result',
'IS',
'  -- Internal use variables',
'  l_username           VARCHAR2 (30) := p_authorization.username; -- Current user',
'  l_user_search_filter VARCHAR2 (32767) ;',
'  l_group_dn           VARCHAR2 (32767) ;           -- Group DN to check',
'  l_retval pls_integer := 0;                        -- Return value 1=success,0=fail',
'  l_result apex_plugin.t_authorization_exec_result; -- Result object to return',
'  --',
'  -- Variables mapped to plugin',
'  l_host                 VARCHAR2 (200) := p_authorization.attribute_01;',
'  l_port                 NUMBER (5)     := p_authorization.attribute_02;',
'  l_use_ssl              VARCHAR2 (1)   := p_authorization.attribute_03;',
'  l_search_base          VARCHAR2 (200) := p_authorization.attribute_04;',
'  l_user_template        VARCHAR2 (200) := p_authorization.attribute_05;',
'  l_group_dn_template    VARCHAR2 (200) := p_authorization.attribute_06;',
'  l_group_attribute_name VARCHAR2 (100) := p_authorization.attribute_07;',
'  l_group_name           VARCHAR2 (100) := p_authorization.attribute_08;',
'  l_anonymous_bind       VARCHAR2 (1)   := p_authorization.attribute_09;',
'  l_bind_username        VARCHAR2 (100) := p_authorization.attribute_10;',
'  l_bind_pass            VARCHAR2 (100) := p_authorization.attribute_11;',
'  l_auth_base            VARCHAR2 (200) := p_authorization.attribute_12;',
'BEGIN',
'  --',
'  --',
'  l_user_search_filter := apex_escape.ldap_search_filter (REPLACE (',
'  l_user_template, ''%LDAP_USER%'', l_username)) ;',
'  l_group_dn := REPLACE (l_group_dn_template, ''%LDAP_GROUP%'', l_group_name) ;',
'  --',
'  --',
'  BEGIN',
'    SELECT',
'      1',
'    INTO',
'      l_retval',
'    FROM',
'      TABLE (apex_ldap.search (',
'               p_username         => l_bind_username, ',
'               p_pass             => l_bind_pass, ',
'               p_auth_base        => l_auth_base, ',
'               p_host             => l_host, ',
'               p_port             => l_port, ',
'               p_use_ssl          => l_use_ssl, ',
'               p_search_base      => l_search_base,',
'               p_search_filter    => l_user_search_filter, ',
'               p_attribute_names  => l_group_attribute_name))',
'    WHERE',
'      upper (val) = upper (l_group_dn) ;',
'  EXCEPTION',
'  WHEN no_data_found THEN',
'    l_retval := 0;',
'  END;',
'  --',
'  -- Set and return results',
'  IF l_retval               = 1 THEN',
'    l_result.is_authorized := true;',
'  ELSE',
'    l_result.is_authorized := false;',
'  END IF;',
'',
'  RETURN l_result;',
'END is_user_in_group_fun;'))
,p_execution_function=>'is_user_in_group_fun'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'2.0.0-beta'
,p_about_url=>'http://fuzziebrain.com/content/id/246'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24705778514305706)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Host'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>200
,p_is_translatable=>false
,p_examples=>'ldap.fuzziebrain.com'
,p_help_text=>'<p>Please enter the hostname/IP address of the LDAP server.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24706192122305707)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Port'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_max_length=>5
,p_is_translatable=>false
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<ul>',
'  <li>389</li>',
'  <li>636</li>',
'</ul>'))
,p_help_text=>'<p>Please enter the port number of the LDAP server.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24706588244305708)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Use SSL'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>true
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'<p>Indicate if SSL is to be used when communicating with the LDAP server.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24706971316305708)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>80
,p_prompt=>'Search Base'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>200
,p_is_translatable=>false
,p_examples=>'dc=fuzziebrain,dc=com'
,p_help_text=>'<p>Please enter the LDAP search base.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24707397115305708)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>90
,p_prompt=>'User Template'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'uid=%LDAP_USER%'
,p_max_length=>200
,p_is_translatable=>false
,p_examples=>'uid=%LDAP_USER%'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>Please enter the search filter template for searching a user by username.</p>',
'<p><em>Change the default filter if necessary, otherwise, this filter should work for most cases. The %LDAP_USER% is the place holder for the APP_USER (user currently logged on).</em></p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24707784591305708)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>100
,p_prompt=>'Group DN Template'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>200
,p_is_translatable=>false
,p_examples=>'cn=%LDAP_GROUP%,ou=groups,ou=applications,o=apex,dc=fuzziebrain,dc=com'
,p_help_text=>'<p>Please enter the template to be used for creating the group''s distinguished name (DN). The %LDAP_GROUP% is a place holder for the "Group Name" entered for this authorization scheme and will be substituted at runtime to form the group''s DN. The aut'
||'horization check result is determined using the Group DN.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24708157763305708)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>110
,p_prompt=>'Group Attribute Name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>100
,p_is_translatable=>false
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<ul>',
'  <li>groupMembership</li>',
'  <li>memberof</li>',
'</ul>'))
,p_help_text=>'<p>Please enter the attribute name to identify group memberships.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24715869448323328)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>120
,p_prompt=>'Group Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_max_length=>100
,p_is_translatable=>false
,p_examples=>'Users'
,p_help_text=>'The name of the group that the user must belong to.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24725626586744309)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>40
,p_prompt=>'Anonymous Bind'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'<p>Please indicate whether to bind to the LDAP server anonymously. If this is set to <em>No</em>, then please provide the <strong>Bind Username</strong>, <strong>Bind User Password</strong> and <strong>Authbase for Bind User</strong>.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24726543373754584)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>50
,p_prompt=>'Bind Username'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>100
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24725626586744309)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_help_text=>'<p>Please enter the username of the user that will be used for binding to the LDAP server.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24727536804773444)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>60
,p_prompt=>'Bind User Password'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>100
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24725626586744309)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_help_text=>'<p>Please provide the password for the user used for binding to the LDAP server.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(24728096248782467)
,p_plugin_id=>wwv_flow_api.id(24705506700305701)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>60
,p_prompt=>'Authentication Base'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>200
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(24725626586744309)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_examples=>'ou=People,dc=fuzziebrain,dc=com'
,p_help_text=>'<p>Please provide the authentication base for the user used for binding to the LDAP server.</p>'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
