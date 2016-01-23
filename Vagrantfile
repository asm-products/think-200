# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"
  config.vm.provision :shell, :path => "vagrant-provision.sh"

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # if Vagrant.has_plugin?("vagrant-cachier")
  #   # Configure cached packages to be shared between instances of the same base box.
  #   # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
  #   config.cache.scope = :box
  #   synced_folder_opts = { type: :nfs }
  #   config.vm.network "private_network", ip: "10.0.0.2"
  #
  #   # If you are using VirtualBox, you might want to use that to enable NFS for
  #   # shared folders. This is also very useful for vagrant-libvirt if you want
  #   # bi-directional sync
  #   config.cache.synced_folder_opts = {
  #     type: :nfs,
  #     # The nolock option can be useful for an NFSv3 client that wants to avoid the
  #     # NLM sideband protocol. Without this option, apt-get might hang if it tries
  #     # to lock files needed for /var/cache/* operations. All of this can be avoided
  #     # by using NFSv4 everywhere. Please note that the tcp option is not the default.
  #     mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
  #   }
  #   # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  # end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true
end
