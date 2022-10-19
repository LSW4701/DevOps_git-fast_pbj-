locals {
  remote_states = {
    "network" = data.terraform_remote_state.this["network"].outputs    # remote sate의 ouput을 가져온다. 
  }
  vpc           = local.remote_states["network"].vpc   # 로컬변수 'vpc' 선언하고 remote sate가져온 값을 넣어준다.   
  subnet_groups = local.remote_states["network"].subnet_groups
}


###################################################
# Terraform Remote States (External Dependencies)
###################################################

data "terraform_remote_state" "this" {
  for_each = local.config.remote_states

  backend = "remote"

  config = {
    organization = each.value.organization
    workspaces = {
      name = each.value.workspace
    }
  }
}
