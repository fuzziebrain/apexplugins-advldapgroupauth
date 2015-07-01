FUNCTION is_user_in_group_fun (
    p_authorization IN apex_plugin.t_authorization,
    p_plugin        IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_authorization_exec_result
IS
  -- Internal use variables
  l_username           VARCHAR2 (30) := p_authorization.username; -- Current user
  l_user_search_filter VARCHAR2 (32767) ;
  l_group_dn           VARCHAR2 (32767) ;           -- Group DN to check
  l_retval pls_integer := 0;                        -- Return value 1=success,0=fail
  l_result apex_plugin.t_authorization_exec_result; -- Result object to return
  --
  -- Variables mapped to plugin
  l_host                 VARCHAR2 (200) := p_authorization.attribute_01;
  l_port                 NUMBER (5)     := p_authorization.attribute_02;
  l_use_ssl              VARCHAR2 (1)   := p_authorization.attribute_03;
  l_search_base          VARCHAR2 (200) := p_authorization.attribute_04;
  l_user_template        VARCHAR2 (200) := p_authorization.attribute_05;
  l_group_dn_template    VARCHAR2 (200) := p_authorization.attribute_06;
  l_group_attribute_name VARCHAR2 (100) := p_authorization.attribute_07;
  l_group_name           VARCHAR2 (100) := p_authorization.attribute_08;
  l_anonymous_bind       VARCHAR2 (1)   := p_authorization.attribute_09;
  l_bind_username        VARCHAR2 (100) := p_authorization.attribute_10;
  l_bind_pass            VARCHAR2 (100) := p_authorization.attribute_11;
  l_auth_base            VARCHAR2 (200) := p_authorization.attribute_12;
BEGIN
  --
  --
  l_user_search_filter := apex_escape.ldap_search_filter (REPLACE (
  l_user_template, '%LDAP_USER%', l_username)) ;
  l_group_dn := REPLACE (l_group_dn_template, '%LDAP_GROUP%', l_group_name) ;
  --
  --
  BEGIN
    SELECT
      1
    INTO
      l_retval
    FROM
      TABLE (apex_ldap.search (
               p_username         => l_bind_username, 
               p_pass             => l_bind_pass, 
               p_auth_base        => l_auth_base, 
               p_host             => l_host, 
               p_port             => l_port, 
               p_use_ssl          => l_use_ssl, 
               p_search_base      => l_search_base,
               p_search_filter    => l_user_search_filter, 
               p_attribute_names  => l_group_attribute_name))
    WHERE
      upper (val) = upper (l_group_dn) ;
  EXCEPTION
  WHEN no_data_found THEN
    l_retval := 0;
  END;
  --
  -- Set and return results
  IF l_retval               = 1 THEN
    l_result.is_authorized := true;
  ELSE
    l_result.is_authorized := false;
  END IF;

  RETURN l_result;
END is_user_in_group_fun;