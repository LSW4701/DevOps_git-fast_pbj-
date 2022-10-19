#!/bin/bash
sudo apt-get update
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ubuntu                         # 도커 설치

## Run openvpn-ldap-otp container  # 멀티팩터 및 LDAP인증도 되는 오픈소스 openvpn  https://github.com/wheelybird/openvpn-server-ldap-otp
docker run \
 --name openvpn \
 --volume openvpn-data:/etc/openvpn \
 --detach=true \
 -p 1194:1194/udp \
 --cap-add=NET_ADMIN \
 -e "OVPN_SERVER_CN=${public_ip}" \       # 환경변수를주입   -> 여기 $값이 templatefile의 두번째 인자값을 렌더링 하였음 
 -e "OVPN_ENABLE_COMPRESSION=false" \
 -e "OVPN_NETWORK=172.22.16.0 255.255.240.0" \
 -e "OVPN_ROUTES=172.22.16.0 255.255.240.0, ${split("/", vpc_cidr)[0]} ${cidrnetmask(vpc_cidr)}" \    # 테라폼 함수로 사용 가능,   vpc cidr 변수의 앞부분과 넷마스크를 가져옴 
 -e "OVPN_NAT=true" \
 -e "OVPN_DNS_SERVERS=${cidrhost(vpc_cidr, 2)}" \  #  vpc 10.222.0.0./24로 설정되어있는데    10.222.0.2   즉 2번째 IP는 내부 DNS 역할을 하며 , 내부DNS서버로 DNS 질의 가능 
 -e "USE_CLIENT_CERTIFICATE=true" \
 wheelybird/openvpn-ldap-otp:v1.6    # 1.4 였는데 버전업 해서 1.6,  깃주소에서 확인 가능 

## Wait to ready OpenVPN Server  # wile 문 돌면서 기다림 
until echo "$(docker exec openvpn show-client-config)" | grep -q "END PRIVATE KEY" ;
do
  sleep 1
  echo "working..."
done

## Generate OpenVPN client configuration file
docker exec openvpn show-client-config > fastcampus.ovpn
