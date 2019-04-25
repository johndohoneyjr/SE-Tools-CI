# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.22.22"

  config.vm.synced_folder "./", "/opt/provisioning"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
  end

  # Install needed tools
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get -qq -y install curl jq unzip
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    service docker start
    docker run -d --name jenkins -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock johndohoney/jenkins-ci
    usermod -aG docker ubuntu
  SHELL
  config.vm.provision "shell", path: "install-tools.sh"
end
