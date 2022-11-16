param location string = resourceGroup().location
@allowed([ 'windows', 'linux', 'functionApp', 'elastic', 'app' ])
param kind string
param name string
param sku object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: name
  location: location
  kind: kind
  sku: sku
  properties: {
    reserved: true
  }
}

output planId string = appServicePlan.id
