#!/bin/sh

## Install Hashicorp repo
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

## Install Packages
apt update && apt install -y docker.io unzip nomad

## Install Nomad beta (1.4 is GA!)
# curl -O nomad.zip https://releases.hashicorp.com/nomad/1.4.0-beta.1/nomad_1.4.0-beta.1_linux_amd64.zip
# unzip -od /usr/bin/ nomad.zip 

# Configure a smaller range of ports for dynamic workloads in line with Vagrantfile
cat <<EOF > /etc/nomad.d/port_range.hcl
client {
  min_dynamic_port = 20000
  max_dynamic_port = 20030
}
EOF

systemctl daemon-reload
systemctl enable nomad --now
systemctl enable docker --now