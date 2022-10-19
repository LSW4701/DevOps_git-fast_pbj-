resource "aws_eip" "openvpn" {
  tags = merge(
    {
      "Name" = "${local.vpc.name}-openvpn"
    },
    local.common_tags,
  )
}

resource "aws_eip_association" "openvpn" {
  instance_id   = aws_instance.openvpn.id       # 2) openvpn.id 에 EIP 연결???  
  allocation_id = aws_eip.openvpn.id  #  1)  EIP를 할당  
}


 # EIP는 공인IP,   ec2 public IP는 ec2머신이 생성될떄 할당 -> ec2머신이 재시작시 갱신 -> 유지가안됨   -> 그러나 EIP(elastic IP/ 탄력적IP)는 갱신 안됨 