# resource "saviynt_resource_ad_connection" "sample" {
#   connection_type         = "AD"
#   connection_name         = "YOUR_CONNECTION_NAME"
#   url                     = format("%s://%s:%d", "LSAP_PROTOCOL", "IP_ADDRESS", "LDAP_PORT")
#   password                = "PASSWORD"
#   username                = "BIND_USER"
#   ldap_or_ad              = "AD"
#   base                    = "BASE_CONTAINER"
# }
terraform {
  required_providers {
    saviynt = {
      source  = "registry.terraform.io/local/saviynt"
      version = "1.0.0"
    }
  }
}

provider "saviynt" {
  server_url = var.SAVIYNT_SERVER_URL
  username   = var.SAVIYNT_USERNAME
  password   = var.SAVIYNT_PASSWORD
}

resource "saviynt_ad_connection_resource" "sample19" {
  connection_type = "AD"
  connection_name = "ACME_Payroll_Operation19"
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

  pam_config = jsonencode({
    "Connection" : "AD",
    "encryptionMechanism" : "ENCRYPTED",
    "CONSOLE" : {
      "maxCredSessionRequestTime" : "36000",
      "maxCredlessSessionRequestTime" : "36000",
      "shareableAccounts" : {
        "IDQueryCredentials" : "acc.name in ('cpamuser1')",
        "IDQueryCredentialless" : "acc.name in ('cpamuser2', 'cpamuser3')",
        "IDQueryCredentiallessViewPwd" : "acc.name in ('cpamuser2')"
      },
      "endpointPamConfig" : { "maxConcurrentSession" : "50" }
    }
  })
}


# resource "saviynt_resource_ad_connection" "sample1" {
#   connection_type               = "AD"
#   connection_name               = "ACME_Payroll_Operation1"
#   url                           = format("%s://%s:%d", var.LDAP_PROTOCOL, var.IP_ADDRESS, var.LDAP_PORT)
#   password                      = var.PASSWORD
#   username                      = var.BIND_USER
#   vault_connection              = var.VAULT_CONNECTION
#   vault_configuration           = var.VAULT_CONFIG
#   save_in_vault                 = var.SAVE_IN_VAULT[\"top\",\"person\",\"organizationalPerson\",\"user\"
#   search_filter                 = var.BASE_CONTAINER
#   create_account_json           = "{\"cn\":\"${cn}\",\"displayname\":\"${user.displayname}\",\"givenname\":\"${user.firstname}\",\"mail\":\"${user.email}\",\"name\":\"${user.displayname}\",\"objectClass\":],\"userAccountControl\":\"544\",\"sAMAccountName\":\"${task.accountName}\",\"sn\":\"${user.lastname}\",\"title\":\"${user.title}\"}"
#   object_filter                 = "{\"full\":\"(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))\",\"incremental\":\"(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))\"}"
#   status_threshold_config       = "{\"statusAndThresholdConfig\":{\"statusColumn\":\"customproperty30\",\"activeStatus\":[\"512\",\"544\",\"66048\"],\"inactiveStatus\":[\"546\",\"514\",\"66050\"],\"deleteLinks\":false,\"accountThresholdValue\":1000,\"correlateInactiveAccounts\":true,\"inactivateAccountsNotInFile\":false,\"lockedStatusColumn\":\"\",\"lockedStatusMapping\":{\"Locked\":[\"\"],\"Unlocked\":[\"\"]}}}"
#   entitlement_attribute         = "memberOf"
#   group_search_base_dn          = var.BASE_CONTAINER
#   page_size                     = "1000"
#   base                          = var.BASE_CONTAINER
#   account_name_rule             = format("CN=task.accountName,%s###CN=task.accountName1,%s###CN=task.accountName2,%s", var.BASE_CONTAINER, var.BASE_CONTAINER, var.BASE_CONTAINER)
#   set_random_password           = "false"
#   reuse_inactive_account        = "false"
#   check_for_unique              = "{\"userAccountCorrelationRule\":\"{\"userAccountCorrelationRule\":\"(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))\",\"incremental\":\"(&(objectCategory=person)(objectClass=user)(sAMAccountName=*))\"}"
#   reset_and_change_passwrd_json = "{\"RESET\": {\"pwdLastSet\": \"0\",\"title\": \"password reset\"},\"CHANGE\": {\"pwdLastSet\": \"-1\",\"lockoutTime\": 0,\"title\": \"password changed\"}}"
#   password_min_length           = ""
#   password_max_length           = ""
#   password_no_of_caps_alpha     = ""
#   password_no_of_digits         = ""
#   password_no_of_spl_chars      = ""
#   unlock_account_json           = "{\"lockoutTime\":\"0\"}"
#   pam_config                    = "{\"Connection\":\"AD\",\"encryptionMechanism\":\"ENCRYPTED\",\"CONSOLE\":{\"maxCredSessionRequestTime\":\"36000\",\"maxCredlessSessionRequestTime\":\"36000\",\"shareableAccounts\":{\"IDQueryCredentials\":\"acc.name in ('cpamuser1')\",\"IDQueryCredentialless\":\"acc.name in ('cpamuser2', 'cpamuser3')\",\"IDQueryCredentiallessViewPwd\":\"acc.name in ('cpamuser2')\"},\"endpointAttributeMappings\":[{\"column\":\"accessquery\",\"value\":\"where users.USERNAME is not null\",\"feature\":\"endpointAccessQuery\"},{\"column\":\"customproperty43\",\"value\":\"PAMDefaultUserAccountAccessControl\",\"feature\":\"accountVisibilityControl\"}],\"endpointPamConfig\":{\"maxConcurrentSession\":\"50\"},\"accountVisibilityConfig\":{\"accountCustomProperty\":\"customproperty55\",\"accountMappingConfig\":[{\"accountPattern\":\"cpamuser*\",\"mappingData\":\"roletest1\",\"override\":\"false\"},{\"accountPattern\":\"cpamuser1,cpamuser2\",\"mappingData\":\"roletest2\",\"override\":\"false\"}]}}}"
# }

