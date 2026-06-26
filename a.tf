
#=========================2VMs LoadBalancer==========
# Internet
#     │
# Public IP
#     │
# Load Balancer
#     │
# Backend Pool
#     │
# NIC1   NIC2 
#  │      │     
# VM1    VM2  
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "rg" {
  name      = "demo-rg"
  location  = "Central India" 
}
resource "azurerm_virtual_network" "vnet" {
  name      = "demo-vnet"
  location  = azurerm_ressource_group.rg.location
  resource_group_name = azurerm_resource_group_rg.name 
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name = "dem-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azuurerm_resource_group.rg.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name = "demo-nsg"
  resource_group_name = azuurerm_resource_group.rg.name
  location = azuurerm_resource_group.rg.location
}

resource "azurerm_network_security_rule" "ssh" {
  name = "allow-ssh"
  direction = "Inbound"
  protocol = "Tcp"
  access = "Allow"
  priority = 100
  source_address_prefix = "*"
  destination_address_prefix = "*"
  source_port_range = "*"
  destination_port_range = 22 
}

resource "azurerm_network_security_rule" "http" {
  name = "allow-http"
  direction = "Inbound"
  protocol = "Tcp"
  access = "Allow"
  priority = 100
  source_address_prefix = "*"
  destination_address_prefix = "*"
  source_port_range = "*"
  destination_port_range = 80
}

resource "azurerm_subnet_network_security_group_assocaition" "asso" {
  subnet_id = azuremr_subnet.subnet.id
  network_security_group = azurerm_network_securit_group.nsg.id
}

resource "azurerm_public_ip" "lbpip" {
  name    = "demo-lbpip"
   location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
}
resource "azurerm_lb" "lb" {
  name = "dem-lb"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  frontend_ip_configuration {
    name = "frontend"
    public_ip_address_id = azurerm_public_ip.lbpip.id

  }
}

resource "azurerm_lb_backend_address_pool" "backend" {
  name = "backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
  
}


resource "azurerm_lb_probe" "probe" {
  name = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol = "Http"
  port = 80
  request_path = "/"
  
}

resource "azurerm_lb_rule" "rule" {
  loadbalancer_id = azurerm_lb.lb.id
  name = "http-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend.id]
  probe_id = azurerm_lb_probe.probe.id
  
}



resource "azurerm_network_interface" "nic1" {
  name = "dem-nic1"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  
}
resource "azurerm_network_interface" "nic2" {
  name                = "nic2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_ba" "name" {
  
}

resource "azurerm_network_interface_backend_address_pool_association" "nic1_assoc" {
  network_interface_id    = azurerm_network_interface.nic1.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic2_assoc" {
  network_interface_id    = azurerm_network_interface.nic2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend.id
}

# --------------------------------
# VM1
# --------------------------------
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "Password123!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic1.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# --------------------------------
# VM2
# --------------------------------
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "vm2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "Password123!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic2.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# --------------------------------
# Output
# --------------------------------
output "load_balancer_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}