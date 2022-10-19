#!/usr/bin/env sh


aws eks update-kubeconfig --region ap-northeast-2 --name apne2-fastcampus --alias apne2-fastcampus
#클러스터에 대한 연결설정을 해당명령어로 진행,    콘트롤 플레인 구성후 해당명령어를 진행해야 EKS 접근가능 