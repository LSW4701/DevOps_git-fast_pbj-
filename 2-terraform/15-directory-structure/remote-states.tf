locals {  # multi workspace 관리 , 해당 워크스페이스가 어떤 워크스페이스에 의존되어있는지 확인하기 쉽도록 이렇게 remote-states.tf로 따로 빼 놓음 
  remote_states = {
    "domain-zone" = data.terraform_remote_state.this["domain-zone"].outputs
  }
  domain_zones = local.remote_states["domain-zone"]
}


###################################################
# Terraform Remote States (External Dependencies)
###################################################

data "terraform_remote_state" "this" {
  for_each = local.config.remote_states                 # for each문을 통해 config.yaml의 remote_states 값을 넣음.  지금은 1개지만 2개 이상일시 유용 

  backend = "remote"

  config = {
    organization = each.value.organization
    workspaces = {
      name = each.value.workspace
    }
  }
}
