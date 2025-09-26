#/bin/bash


function ansible_setup {
        echo "Checking is Ansible exist"
        ansible --version &> /dev/null
        if [[ $? -ne 0 ]]; then
                echo "Installing Ansible"
                sudo apt update &> /dev/null
                sudo apt install software-properties-common -y &> /dev/null
                sudo add-apt-repository --yes --update ppa:ansible/ansible &> /dev/null
                sudo apt install ansible -y &> /dev/null
        fi
        echo "Ansible installed"
}


function java_setup {
        echo "Checking is Java exist"
        java --version &> /dev/null
        if [[ $? -ne 0 ]]; then
                echo "Installing Java"
                sudo apt install -y wget apt-transport-https gpg &> /dev/null
                sudo wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
                sudo echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list &> /dev/null
                sudo apt update &> /dev/null
                sudo apt install temurin-21-jdk -y &> /dev/null
        fi
        echo "Java installed"
}


function jenkins_setup {
        echo "Checking is Jenkins exist"
        jenkins --version &> /dev/null
        if [[ $? -ne 0 ]]; then
                echo "Installing Jenkins"
                sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
                        https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key &> /dev/null
                echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
                        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                        /etc/apt/sources.list.d/jenkins.list &> /dev/null
                sudo apt-get update &> /dev/null
                sudo apt-get install jenkins -y &> /dev/null
        fi
        echo "Jenkins installed"
}


function additional_packages {
        echo "Checking is Python3 exist"
        sudo python3 --version &> /dev/null
        if [[ ! $? ]]; then
                log "Installing python3"
                sudo apt install python3 &> /dev/null
        fi
        echo "Python3 installed"
}


function main {
        additional_packages
        ansible_setup
        java_setup
        jenkins_setup
}


main