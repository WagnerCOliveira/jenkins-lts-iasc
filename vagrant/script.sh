#!/bin/bash

cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
dnf install -y centos-release-ansible-29.noarch
dnf update -y
dnf -y install curl gcc libffi-devel openssl-devel python3 python3-pip ansible
