# to make sure the nodes are created in order, we
# have to force a --no-parallel execution.
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

$router_ip_address = '10.100.100.254'
$node_ip_addresses = [
  '10.100.100.200',
  '10.100.100.201',
]

Vagrant.configure(2) do |config|
  config.vm.box = 'debian-11-amd64'

  config.vm.provider 'libvirt' do |lv, config|
    lv.memory = 512
    lv.cpus = 2
    lv.cpu_mode = 'host-passthrough'
    lv.nested = false # nested virtualization.
    lv.keymap = 'pt'
    config.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: '4.2', nfs_udp: false
  end

  config.vm.define 'router' do |config|
    config.vm.hostname = 'router.test'
    config.vm.network :private_network,
      ip: $router_ip_address,
      libvirt__forward_mode: 'none',
      libvirt__dhcp_enabled: false
    config.vm.provision :shell, path: 'provision-base.sh'
    config.vm.provision :shell, path: 'provision-router.sh'
  end

  $node_ip_addresses.each_with_index do |ip_address, n|
    vm_name = "node#{n+1}"
    config.vm.define vm_name do |config|
      config.vm.hostname = "#{vm_name}.test"
      config.vm.network :private_network,
        ip: ip_address,
        libvirt__forward_mode: 'none',
        libvirt__dhcp_enabled: false
      config.vm.provision :shell, path: 'provision-default-gateway.sh', args: [$router_ip_address]
      config.vm.provision :shell, path: 'provision-base.sh'
    end
  end
end
