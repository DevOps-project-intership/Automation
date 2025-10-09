import json


def make_servers_inventory():
    try:
        with open("terraform/deploy-servers/outputs.json", "r", encoding="utf-8") as servers_file:
            data = json.load(servers_file)


        with open("ansible/inventories/inventory_servers.ini", "w") as servers_file:
            servers_file.writelines([
                "[all:vars]\n",
                "ansible_user=ec2-user\n",
                "ansible_port=22\n",
                "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostKeyAlgorithms=+ssh-rsa'\n\n"
            ])

            servers_file.write("[database]\n")
            servers_file.write(f"{data['database_private_ip']['value']}\n\n")
            
            servers_file.write("[flask]\n")
            servers_file.write(f"{data['flask-1_private_ip']['value']}\n")
            servers_file.write(f"{data['flask-2_private_ip']['value']}\n\n")
            
            servers_file.write("[loadbalancer]\n")
            servers_file.write(f"{data['loadbalancer_private_ip']['value']}\n\n")
    
    except FileNotFoundError or FileExistsError:
        raise "<---------------Servers instances not created--------------->"


def  make_consul_inventory():

    try:

        with open("terraform/deploy-consul/outputs.json", "r", encoding="utf-8") as consul_file:
            data = json.load(consul_file)


        with open("ansible/inventories/inventory_consul.ini", "w") as consul_file:
            consul_file.writelines([
                "[all:vars]\n",
                "ansible_user=ec2-user\n",
                "ansible_port=22\n",
                "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostKeyAlgorithms=+ssh-rsa'\n\n"
            ])

            consul_file.write("[consul]\n")
            consul_file.write(f"{data['consul_private_ip']['value']}\n")

    except FileNotFoundError or FileExistsError:
        raise "<---------------Consul instance not created--------------->"



if __name__ == "__main__":
    make_servers_inventory()
    make_consul_inventory()
