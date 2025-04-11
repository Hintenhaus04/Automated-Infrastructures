/*
This Bicep template deploys the following resources in Azure:

1. A Virtual Network (VNet) with a single subnet:
  - Address space: 10.0.0.0/16
  - Subnet: 10.0.0.0/24

2. A Network Security Group (NSG) with inbound rules to allow HTTP (port 80) and HTTPS (port 443) traffic.

3. Public IP addresses for each virtual machine, dynamically allocated.

4. Network Interfaces (NICs) for each virtual machine, associated with the NSG and VNet subnet.

5. Three Virtual Machines (VMs) with:
  - Ubuntu 18.04-LTS as the operating system.
  - Standard_B1s as the VM size.
  - Dynamic private and public IP allocation.
  - Admin credentials (ensure secure handling in production).

Note: Replace the hardcoded admin password with a secure method, such as Azure Key Vault or SSH keys, for production environments.
*/
param location string = resourceGroup().location
param baseName string = 'webserver'
param deploymentName string = 'Hintenhaus-webserver'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${baseName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${baseName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-HTTPS'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

var vmNames = [
  '${baseName}01'
  '${baseName}02'
  '${baseName}03'
]

resource publicIpAddresses 'Microsoft.Network/publicIPAddresses@2021-02-01' = [for name in vmNames: {
  name: '${name}-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}]

resource networkInterfaces 'Microsoft.Network/networkInterfaces@2021-02-01' = [for (name, i) in vmNames: {
  name: '${name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddresses[i].id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}]

resource virtualMachines 'Microsoft.Compute/virtualMachines@2021-03-01' = [for (name, i) in vmNames: {
  name: name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: name
      adminUsername: 'azureuser'
      adminPassword: 'Admin@root' // gebruik in productie SSH of Key Vault!
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces[i].id
        }
      ]
    }
  }
}]
