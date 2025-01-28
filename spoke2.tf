
#spoke2 vnet
resource "azurerm_virtual_network" "spoke2" {
  name                = "spoke2"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  address_space       = ["10.2.0.0/16"]
}

#spoke2 default subnet
resource "azurerm_subnet" "spoke2_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefixes     = ["10.2.0.0/24"]
}


#associate firewall route table to spoke2 subnet
resource "azurerm_subnet_route_table_association" "spoke2_rt_spoke2_vnet" {
  subnet_id      = azurerm_subnet.spoke2_subnet.id
  route_table_id = azurerm_route_table.rt.id
  depends_on     = [azurerm_subnet.spoke2_subnet]
}


#spoke2 vm nic
resource "azurerm_network_interface" "spoke2_vm_nic" {
  name                = "spoke2-vm-nic"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke2_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


#spoke2 vm
resource "azurerm_linux_virtual_machine" "spoke2_vm" {
  name                = "spoke2-machine"
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  location            = azurerm_resource_group.hub_spoke_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.spoke2_vm_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}