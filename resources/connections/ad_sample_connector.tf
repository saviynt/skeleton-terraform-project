resource "saviynt_ad_connection_resource" "sample" {
  connection_type = "AD"
  connection_name = "sample-ad-connector"
  url             = format("%s://%s:%d", var.LDAP_PROTOCOL, var.IP_ADDRESS, var.LDAP_PORT)
  password        = var.PASSWORD
  username        = var.BIND_USER
  searchfilter = var.BASE_CONTAINER

  create_account_json = jsonencode({
    "cn" : "$${cn}",
    "displayname" : "$${user.displayname}",
    "givenname" : "$${user.firstname}",
    "mail" : "$${user.email}",
    "name" : "$${user.displayname}",
    "objectClass" : ["top", "person", "organizationalPerson", "user"],
    "userAccountControl" : "544",
    "sAMAccountName" : "$${task.accountName}",
    "sn" : "$${user.lastname}",
    "title" : "$${user.title}"
  })
  objectfilter = replace(jsonencode({
    "full" : "(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))",
    "incremental" : "(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))"
  }), "\\u0026", "&")

  status_threshold_config = jsonencode({
    "statusAndThresholdConfig" : {
      "statusColumn" : "customproperty30",
      "activeStatus" : ["512", "544", "66048"],
      "inactiveStatus" : ["546", "514", "66050"],
      "deleteLinks" : false,
      "accountThresholdValue" : 1000,
      "correlateInactiveAccounts" : true,
      "inactivateAccountsNotInFile" : false
    }
  })

  entitlement_attribute  = "memberOf"
  group_search_base_dn   = var.BASE_CONTAINER
  page_size              = "1000"
  base                   = var.BASE_CONTAINER
  account_name_rule      = format("CN=task.accountName,%s###CN=task.accountName1,%s###CN=task.accountName2,%s", var.BASE_CONTAINER, var.BASE_CONTAINER, var.BASE_CONTAINER)
  set_random_password    = "false"
  reuse_inactive_account = "false"

  check_for_unique = replace(jsonencode({
    "userAccountCorrelationRule" : "(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))"
  }), "\\u0026", "&")

  reset_and_change_passwrd_json = jsonencode({
    "RESET" : { "pwdLastSet" : "0", "title" : "password reset" },
    "CHANGE" : { "pwdLastSet" : "-1", "lockoutTime" : 0, "title" : "password changed" }
  })


  unlock_account_json = jsonencode({
    "lockoutTime" : "0"
  })

  account_attribute = "[customproperty1::cn#String,customproperty30::userAccountControl#String,customproperty2::userPrincipalName#String,customproperty28::primaryGroupID#String,lastlogondate::lastLogon#millisec,displayname::name#String,customproperty25::company#String,customproperty20::employeeID#String,customproperty3::sn#String,comments::distinguishedName#String,customproperty4::homeDirectory#String,lastpasswordchange::pwdLastSet#millisec,customproperty5::co#String,customproperty6::employeeNumber#String,customproperty7::givenName#String,customproperty8::title#String,customproperty9::telephoneNumber#String,customproperty10::c#String,description::description#String,customproperty11::uSNCreated#String,validthrough::accountExpires#millisec,customproperty12::logonCount#String,customproperty13::physicalDeliveryOfficeName#String,updatedate::whenChanged#date,customproperty14::extensionAttribute1#String,customproperty15::extensionAttribute2#String,customproperty16::streetAddress#String,customproperty17::mailNickname#String,customproperty18::department#String,customproperty19::countryCode#String,name::sAMAccountName#String,customproperty21::manager#String,customproperty22::homePhone#String,customproperty23::mobile#String,created_on::whenCreated#date,accountclass::objectClass#String,accountid::objectGUID#Binary,customproperty24::userAccountControl#String,customproperty27::objectSid#Binary,RECONCILATION_FIELD::customproperty26,customproperty26::objectGUID#Binary,customproperty29::st#String]"

}


