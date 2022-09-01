#!/bin/bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository 'deb [arch=amd64] https://apt.releases.hashicorp.com bionic main'
sudo apt-get update && sudo apt-get -y install nomad

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt-get update
sudo apt-get install -y docker-ce openjdk-11-jdk

for SOLUTION in "nomad";
do
    sudo mkdir -p /var/lib/$SOLUTION/{data,plugins}
    sudo chown -R $SOLUTION:$SOLUTION /var/lib/$SOLUTION
done

sudo cat <<EOCONFIG > /etc/nomad.d/nomad.hcl
region = "${region}"
data_dir = "/var/lib/nomad/data"
bind_addr = "{{ GetInterfaceIP \"ens5\" }}"
advertise {
//  http = "{{ GetInterfaceIP \"ens5\" }}"
  rpc  = "{{ GetInterfaceIP \"ens5\" }}"
  serf = "{{ GetInterfaceIP \"ens5\" }}"
}

client {
  enabled = true
  network_interface = "ens5"
  servers = ["${server_ip}"]
  options = {
   "driver.raw_exec.enable" = "1"
  }
}

EOCONFIG

sudo systemctl enable nomad
sudo systemctl start nomad
