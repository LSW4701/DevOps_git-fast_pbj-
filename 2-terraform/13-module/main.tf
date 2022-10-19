provider "aws" {          # 1. 프로바이더 설정 
  region = "ap-northeast-2"
}

module "account" {    # 2. 모듈 블록 설정 
  source = "./account"  # 3. 로컬로 설정한것.    레지스트리 등 다르게 참조 가능  source  = "tedilabs/network/aws//modules/security-group"

  name = "lsw-acount"  # alias 설정 
  password_policy = {
    minimum_password_length        = 8
    require_numbers                = true
    require_symbols                = true
    require_lowercase_characters   = true
    require_uppercase_characters   = true
    allow_users_to_change_password = true
    hard_expiry                    = false
    max_password_age               = 0
    password_reuse_prevention      = 0
  }
}

output "id" {
  value = module.account.id  # 모듈 output으로 설정된 값만 가능 
}

output "account_name" {
  value = module.account.name
}

output "signin_url" {
  value = module.account.signin_url
}

output "account_password_policy" {
  value = module.account.password_policy
}
