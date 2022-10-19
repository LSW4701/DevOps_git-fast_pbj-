provider "aws" {
  region = "ap-northeast-2"
}

data "terraform_remote_state" "network" {  ## 1) remote state 값 참조하기 
  backend = "local"

  config = {
    path = "${path.module}/../network/terraform.tfstate"  # 해당 경로 
  }
}

locals {  
  vpc_name      = data.terraform_remote_state.network.outputs.vpc_name          # 2) 로컬변수를 생성하고 리모트스테이트에서 가져온 값을 넣어준다. 
  subnet_groups = data.terraform_remote_state.network.outputs.subnet_groups  # 해당 워크스페이스에서 output이 지정되어야 가져 올 수 있다. 
}                                                                           #  data.terraform_remote_state.network 참조 경로   .outputs     아웃풋  ,  그리고 output의 속성값들    

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  subnet_id     = local.subnet_groups["public"].ids[0]   # 3) 리모트 스테이트에서 가져온 값 ubnet_groups 에서 public 그룹을 찾고  
                                                         # 4) 그 그룹의 .ids[0]  첫번째 ids를 참조 

  tags = {
    Name = "${local.vpc_name}-ubuntu"
  }
}


########################################
# /network/main.tf의 output들 과 subnet_group 모듈   /

# output "vpc_name" {
#   value = module.vpc.name
# }

# output "vpc_id" {
#   value = module.vpc.id
# }

# output "vpc_cidr" {
#   description = "생성된 VPC의 CIDR 영역"
#   value = module.vpc.cidr_block
# }

# output "subnet_groups" {
#   value = {
#     public  = module.subnet_group__public
#     private = module.subnet_group__private
#   }
# }

# module "subnet_group__public" {                             # 5) 해당 모듈은 강사의 모듈일뿐 공식모듈이 아니다. 
#   source  = "tedilabs/network/aws//modules/subnet-group"
#   version = "0.24.0"

#   name                    = "${module.vpc.name}-public"
#   vpc_id                  = module.vpc.id
#   map_public_ip_on_launch = true

#   subnets = {
#     "${module.vpc.name}-public-001/az1" = {
#       cidr_block           = "10.0.0.0/24"
#       availability_zone_id = "apne2-az1"
#     }
#     "${module.vpc.name}-public-002/az2" = {
#       cidr_block           = "10.0.1.0/24"
#       availability_zone_id = "apne2-az2"
#     }
#   }

#   tags = local.common_tags
# }
