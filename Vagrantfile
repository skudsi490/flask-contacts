# Vagrantfile

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 5432, host: 15432
  config.vm.network "forwarded_port", guest: 8080, host: 8082

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y openjdk-11-jdk git docker.io dos2unix
    usermod -aG docker vagrant
    systemctl start docker
    systemctl enable docker
    systemctl restart docker

    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt-get update
    apt-get install -y jenkins
    systemctl start jenkins
    systemctl enable jenkins
    ufw allow 8080
  SHELL

  config.vm.provision "shell", inline: <<-SHELL
    dos2unix /vagrant/run_containers.sh
    su - vagrant -c 'bash /vagrant/run_containers.sh'
  SHELL

  config.vm.boot_timeout = 600
end
