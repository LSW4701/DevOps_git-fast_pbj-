terraform {
  required_version = ">= 0.15"

  required_providers {  # aws 모듈을 사용하고 있고 3.45 이상의 aws provider를 사용해야 정상적으로 사용 할 수 있음 
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45"
    }
  }
}
