#!/bin/bash


function jenkins_setup {

    sudo yum update -y
    sudo yum install java-17 -y

    sudo wget -O /etc/yum.repos.d/jenkins.repo \
        https://pkg.jenkins.io/redhat-stable/jenkins.repo

    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

    sudo yum clean all
    sudo yum makecache
    sudo yum install jenkins -y

    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins

    echo "Jenkins is installed!"
}


function ansible_setup {

    sudo yum install -y python3
    sudo python3 -m ensurepip --upgrade
    sudo pip3 install ansible

    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc

    echo "Ansible is installed!"
}


function terraform_setup {
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
}


function aws_setup {
    sudo yum install -y unzip curl

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
}

function ssm_agent_setup {
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
}


function main {
    jenkins_setup
    ansible_setup
    terraform_setup
    aws_setup
    ssm_agent_setup
}

main
