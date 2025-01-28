#spoke1 vnet
resource "azurerm_virtual_network" "spoke1" {
  name                = "spoke1"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  address_space       = ["10.1.0.0/16"]
}

#spoke1 default subnet
resource "azurerm_subnet" "spoke1_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.1.0.0/24"]
}

#associate firewall route table to spoke1 subnet
resource "azurerm_subnet_route_table_association" "spoke1_rt_spoke1_vnet" {
  subnet_id      = azurerm_subnet.spoke1_subnet.id
  route_table_id = azurerm_route_table.rt.id
  depends_on     = [azurerm_subnet.spoke1_subnet]
}


#spoke1 vm nic
resource "azurerm_network_interface" "spoke1_vm_nic" {
  name                = "spoke1-vm-nic"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


#spoke1 vm
resource "azurerm_linux_virtual_machine" "spoke1_vm" {
  name                = "spoke1-machine"
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  location            = azurerm_resource_group.hub_spoke_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.spoke1_vm_nic.id,
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


