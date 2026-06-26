
terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.0"
      }
    }
}

provider "azurerm" {
    features {
      
    }
  
}

resource "azurerm_resource_group" "rg" {
    name        = var.rg_name
  location      = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
  name                  = var.vnet_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  address_space         = var.vnet_address_space 
}

resource "azurerm_subnet" "subnet" {
  name                  = var.subnet_name
  resource_group_name   = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = var.subnet_address_prefixes
    
}

resource "azurerm_public_ip" "pip" {
    name                = var.public_ip_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  allocation_method     = "Static"
  sku                   = "Standard"
  
}


resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location

  security_rule {
    name                        = "SSH"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "TCP"
    source_port_range           = "*" 
    destination_port_range      = "22"
    destination_address_prefix  = "*"
    source_address_prefix       = "*"
  }

   security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic" {
    name                        = var.nic_name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name

  ip_configuration {
    name                            = "internal"
    subnet_id                       = azurerm_subnet.subnet.id
    private_ip_address_allocation   = "Dynamic"
    public_ip_address_id            = azurerm_public_ip.pip.id
  }    
  
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  =  var.vm_size
  disable_password_authentication = false
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard-LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


