terraform {    # 테라폼 워크스페이스에 대한 간략한 소개 
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "fastcampus-devops"

    workspaces {
      name = "aws-network-apne2-fastcampus"
    }
  }
}


###################################################
# Local Variables
###################################################

locals {
  aws_accounts = {
    fastcampus = {
      id     = "xxxxxxxxxx"
      region = "ap-northeast-2"
      alias  = "posquit0-fastcampus"
    },
  }
  context = yamldecode(file(var.config_file)).context              #1) variables.tf에서 선언된 var.config_file  을 file이라는 함수로 read하면  YAML -> HCL로 변환 , 일단 config.yaml 
                                                                   # 파일에서 context 값 만 가져옴 
  config  = yamldecode(templatefile(var.config_file, local.context)) #)이번엔 file함수가 아닌 templatefile 함수로 다시 읽는다.     templatefile함수는 읽을때 local.context 같이 불러와서 렌더링 
                                                                    # 즉 ${} 가 적용 
}


###################################################
# Providers
###################################################

provider "aws" {        # 한 워크스페이스에서 여러 프로바이더 실행 가능 
  region = local.aws_accounts.fastcampus.region

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [local.aws_accounts.fastcampus.id]

  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_accounts.fastcampus.id}:role/terraform-access"
    session_name = local.context.workspace
  }
}
