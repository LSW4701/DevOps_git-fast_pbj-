data "aws_caller_identity" "this" {}  # 해당 명령어로 account_id를 가져 올 수 있다. 


###################################################
# AWS Account Alias
###################################################

resource "aws_iam_account_alias" "this" {
  account_alias = var.name
}


###################################################
# Password Policy for AWS Account and IAM Users
###################################################

resource "aws_iam_account_password_policy" "this" {         #  variables.tf 에서 변수로 받았던 것을 policy의 값을 넣어준다.
  minimum_password_length        = var.password_policy.minimum_password_length
  require_numbers                = var.password_policy.require_numbers
  require_symbols                = var.password_policy.require_symbols
  require_lowercase_characters   = var.password_policy.require_lowercase_characters
  require_uppercase_characters   = var.password_policy.require_uppercase_characters
  allow_users_to_change_password = var.password_policy.allow_users_to_change_password
  hard_expiry                    = var.password_policy.hard_expiry
  max_password_age               = var.password_policy.max_password_age
  password_reuse_prevention      = var.password_policy.password_reuse_prevention
}
