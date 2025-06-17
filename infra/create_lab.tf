module "create_vm" {
  source = "github.com/alexeiev/proxmox_module?ref=v4.0.0"
  
  vm_template       = "ubuntu-2404-v20250616"
  site              = "192.168.1.20"
  srv_target_node   = "dellmini2"
  vm_qnt            = 4
  vm_name           = "k8s-lab-0"
  vm_id             = 801
  vm_memory         = 4096
  vm_cpu            = 4
  vm_disk           = 60
  vm_storage        = "nfs_dellmini2"
  vm_storage_type   = "qcow2"
  net               = "vmbr0"
  net_vlan          = 15
  vm_ip_address     = [                       
                      "ip=10.0.0.101/24,gw=10.0.0.1",
                      "ip=10.0.0.102/24,gw=10.0.0.1", 
                      "ip=10.0.0.103/24,gw=10.0.0.1", 
                      "ip=10.0.0.104/24,gw=10.0.0.1",
                      "ip=10.0.0.105/24,gw=10.0.0.1",
                    ]
  username-so       = "ubuntu"
  sshkeys           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDV+nBHjjcdivQnIYT24PyKEjBmD9tfhK+T0vjesbQRSclTVK+a3ZhuZ1JMt8T27pUKBYKnN5Wv7UXRq+rbLmuSdxzngcXCFNvpgL1lF9eektkFBmSgddIdp3j4qRdiI8TvGIoQ1w6gflEr99h9aFPnpbiTsTZLZ2HGuaYeNcakSIW4mLVWrwEhlksU7vA7fxlsjDt4DnTf/am9sFe3k3UTdFa0dizoPnPaWtfr8y8vwBYJGWhZeGOi617XiXgkq5y8GkYfVjjx4feUk6NtE/x4IfscR1RYmwkpTqEUp7B6yM5j/yg0xE+Cjk7fkJ+TIeulvW/JuuVHm+yoJBTx6zsBfCLAbmm1Im61NjAoA7Dvnr/0SrxqQ54Ms42mf0zezIUvpKnRsA44Bm70wLYRIpNfAaGv6dv2N73QHymfIeQIf+eJt5SgicYx+Ji37X2uve6UpIgofUaJxjFsOy9s+U9N1sZnxG3Y2j5ObsL4E6yZO+hKzy7KDc6ecAF0V4a5W4M= VMsProxMox"
  environment       = "prod"
}

output "vm_name" {
  value = module.create_vm.vm_name
}

output "ip_address" {
    value = module.create_vm.ip_address
}