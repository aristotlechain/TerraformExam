resource "azurerm_resource_group" "rg" {
name = "terraform-lab-rg"
location = "Canada Central"
}

resource "azurerm_virtual_network" "vnet" {
name = "terraform-vnet"
address_space = ["10.0.0.0/16"]
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
name = "terraform-subnet"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
name = "terraform-nic"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.subnet.id
private_ip_address_allocation = "Dynamic"
}
}

resource "azurerm_linux_virtual_machine" "vm" {
name = "terraform-vm-final-exam-savvy"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
size = "Standard_B1s"
admin_username = "azureuser"
network_interface_ids = [
azurerm_network_interface.nic.id,
]
admin_password = "Terraform123!"
os_disk {
caching = "ReadWrite"
storage_account_type = "Standard_LRS"
}
source_image_reference {
publisher = "Canonical"
offer = "UbuntuServer"
sku = "18.04-LTS"
version = "latest"
}
disable_password_authentication = false
}
