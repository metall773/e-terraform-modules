# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
    template = file("${path.module}/user-data-azure-centos7.sh")
    vars = {
        storage_account    = azurerm_storage_account.mystorageaccount-files.primary_file_host
        share_name         = azurerm_storage_share.myfileshare.name
        share_login        = azurerm_storage_account.mystorageaccount-files.name
        share_pass         = azurerm_storage_account.mystorageaccount-files.primary_access_key

        share_disk_host  = var.shared_disk_storage_account.primary_file_host
        share_disk_name  = var.shared_disk_name
        share_disk_login = var.shared_disk_storage_account.name
        share_disk_pass  = var.shared_disk_storage_account.primary_access_key

        install_bitrix     = var.install_bitrix
        install_fail2ban   = var.install_fail2ban
        install_autoupdate = var.install_autoupdate
        admin-username     = var.web-linux-admin-username
        mount_point        = var.managed_disk_mount_point
        
        firewall_tcp_ports = jsonencode(var.firewall_tcp_ports)
        firewall_udp_ports = jsonencode(var.firewall_udp_ports)

    }
}