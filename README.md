# Terrific TLS Tuning examples


## Preparations

1. Install [Homebrew](http://brew.sh/) 
1. Install Ansible: `brew install ansible`
1. Launch a EC2 Instance that is publicly available. The instnace needs to run the lates
   Amazon Linux. Make sure you can ssh into the machine using your ssh key and ports 
   22,80,443 and 9000 are accessible.
1. Put your hostname into the `inventory/hosts` file.
1. let a url of your choice point to the public IP of that instance. In our case this 
   is `wjax.terrific-tls-tuning-tips.com`.


## Provisioning

1. Check connection: `ansible tls -m ping`
1. Provision a base system: `ansible-playbook ansible/01-base-system.yml`

