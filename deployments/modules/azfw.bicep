param prefix string
param hubId string
param utilSubnetCidr string

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: '${prefix}-azfw-ip'
  location: resourceGroup().location
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource fwl 'Microsoft.Network/azureFirewalls@2020-06-01' = {
  name: '${prefix}-azfw'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: '${prefix}-azfw-ipconf'
        properties: {
          subnet: {
            id: '${hubId}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    networkRuleCollections: [
      {
        name: 'test-collection'
        properties: {
          action: {
            type: 'Allow'
          }
          priority: 100
          rules: [
            {
              description: 'Allow outbound web traffic for util subnet'
              name: 'util-outbound-all'
              protocols: [
                'TCP'
              ]
              sourceAddresses: [
                utilSubnetCidr
              ]
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '80'
                '443'
              ]
            }
          ]
        }
      }

    ]
  }
}

output privateIp string = fwl.properties.ipConfigurations[0].properties.privateIPAddress