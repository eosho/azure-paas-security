param vaultName string
param tags object
param skuName string {
  allowed: [
    'standard'
    'premium'
  ]
  default: 'standard'
}
param objectId string
param keysPermissions array {
  default: [
    'list'
    'get'
  ]
}
param secretsPermissions array {
  default: [
    'list'
    'get'
  ]
}
param virtualNetworkRules array
var tenantId = subscription().tenantId

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: vaultName
  location: resourceGroup().location
  tags: tags
  properties: {
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: false
    createMode: 'default'
    enablePurgeProtection: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      virtualNetworkRules: virtualNetworkRules
    }
  }
}

output vaultName_output string = vaultName
output vaultResourceGroup string = resourceGroup().name