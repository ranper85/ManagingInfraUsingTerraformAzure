# This file contains the variables used in the main.tf file, if we need some output from the resources we created in the main.tf file.
  

output "vm_id" {
  value = azurerm_linux_virtual_machine.linuxvm.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.linuxvm.public_ip_address
}

output "tls_private_key" { 
  value = tls_private_key.example_ssh.private_key_pem 
  sensitive = true
}
