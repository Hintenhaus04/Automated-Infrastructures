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
