import json


with open("terraform/deploy-servers/scripts/outputs.json", "r", encoding="utf-8") as f:
    data = json.load(f)


with open("ansible/inventory.ini", "w") as f:
    f.writelines([
        "[all:vars]\n",
        "ansible_user=ec2-user\n",
        "ansible_port=22\n",
        "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostKeyAlgorithms=+ssh-rsa'\n\n"
    ])

    f.write("[database]\n")
    f.write(f"{data['database_private_ip']['value']}\n\n")
    
    f.write("[flask]\n")
    f.write(f"{data['flask-1_private_ip']['value']}\n")
    f.write(f"{data['flask-2_private_ip']['value']}\n\n")
    
    f.write("[loadbalancer]\n")
    f.write(f"{data['loadbalancer_private_ip']['value']}\n\n")
    
    f.write("[consul]\n")
    f.write(f"{data['consul_private_ip']['value']}\n")
