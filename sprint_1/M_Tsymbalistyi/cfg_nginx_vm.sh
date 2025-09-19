#!/bin/bash

function usage {
        echo "Usage: $0 branch pat_token"
}

function log {
        local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[${timestamp}]: LOG $*"
}

function error_log {
        local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo "[${timestamp}]: ERROR $*" >&2
}

function setup_packages {
        log "Updating apt"
        sudo apt update &> /dev/null

        sudo nginx -v &> /dev/null
        if [[ ! $? ]]; then
                log "Installing nginx"
                sudo apt install nginx &> /dev/null
        fi

        sudo python3 --version &> /dev/null
        if [[ ! $? ]]; then
                log "Installing python3"
                sudo apt install python3 &> /dev/null
        fi

        sudo flask --version &> /dev/null
        if [[ ! $? ]]; then
                log "Installing flask"
                sudo apt install python3-flask &> /dev/null
        fi

        sudo git --version &> /dev/null
        if [[ ! $? ]]; then
                log "Installing git"
                sudo apt install git &> /dev/null
        fi
}

function main {
        if [[ $# -ne 2 ]]; then
                usage
                exit 1
        fi

        branch=$1
        pat_token=$2
        repo_path="DevOps-project-intership/Hot-Peppers.git"
        folder_name="Hot-Peppers"

        setup_packages
        if [[ -e $folder_name ]]; then
                log "$folder_name already exists, it will be backuped"
                mv -f $folder_name $folder_name~ &> /dev/null
        fi
        sudo git clone -b $branch https://$pat_token@github.com/$repo_path $folder_name &> /dev/null

        if [[ -e /etc/nginx/nginx.conf ]]; then
                log "/etc/nginx/nginx.conf already exists, file will be backuped"
        fi
        sudo cp -fb $folder_name/nginx.conf /etc/nginx/nginx.conf

        if [[ -e /var/www/html/index.html ]]; then
                log "/var/www/html/index.html already exists, file will be backuped"
        fi
        sudo cp -fb $folder_name/index.html /var/www/html/index.html

        log "Reloading nginx"
        sudo nginx -s reload &> /dev/null
        log "Setup completed"
}

main "$@"
