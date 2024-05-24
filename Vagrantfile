# Vagrantfile

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 5432, host: 15432 

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y docker.io
    usermod -aG docker vagrant
    systemctl start docker
    systemctl enable docker
    systemctl restart docker
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name jenkins jenkins/jenkins:lts
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    su - vagrant -c 'bash /vagrant/run_containers.sh'
  SHELL

  config.vm.boot_timeout = 600 
end
