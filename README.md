# Terrific TLS Tuning examples


## Preparations

1. Install [Homebrew](http://brew.sh/) 
1. Install Ansible: `brew install ansible`
1. Launch a EC2 Instance that is publicly available. The instance needs to run the lates
   Amazon Linux. Make sure you can ssh into the machine using your ssh key and ports 
   22,80,443 and 9000 are accessible.
1. Put your public aws hostname into the `inventory/hosts` file.
1. let a url of your choice point to the public IP of that instance. In our case this 
   is `wjax.terrific-tls-tuning-tips.com`. Configure that domain in the `all.yml`
   group var file.

## Provisioning

Check connection to the server by 

    $ ansible tls -m ping
    ec2-52-50-106-131.eu-west-1.compute.amazonaws.com | SUCCESS => {
      "changed": false, 
      "ping": "pong"
    }
    
Now, execute the Ansible playbooks in ascending order. Start with provisioning
a base system (`01-base-system.yml`) and make your way through HTTP2.

