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

resource "aws_instance" "private" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  subnet_id     = local.subnet_groups["private"].ids[0] # remote state 에서 가져온 local의 subnetgroup의 ids[0]   
  key_name      = "linux1" # pem 키 

  vpc_security_group_ids = [
    module.sg__ssh.id,  # -> security-group.tf에 sg__ssh 모듈
  ]

  tags = {
    Name = "${local.vpc.name}-private"
  }
}

locals {
  openvpn_userdata = templatefile("${path.module}/files/openvpn-userdata.sh", {           # templatefile 첫번쨰인자 파일경로, 두번쨰 인자 context값으로 userdata.sh에 사용,., 받아 렌더링  
    vpc_cidr  = local.vpc.cidr_block
    public_ip = aws_eip.openvpn.public_ip
  })
  common_tags = {
    "Project" = "openvpn"
  }
}

resource "aws_instance" "openvpn" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  subnet_id     = local.subnet_groups["public"].ids[0]
  key_name      = "linux1" #

  user_data = local.openvpn_userdata  # 유저데이터 구성 , 바로위 locals  openvpn_userdata 참조

  associate_public_ip_address = false
  vpc_security_group_ids = [
    module.sg__ssh.id,
    module.sg__openvpn.id,
  ]

  tags = {
    Name = "${local.vpc.name}-openvpn"
  }
}
