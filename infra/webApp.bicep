@allowed([
  'app'
  'app,linux'
  'app,linux,container'
  'hyperV'
  'app,container,windows'
  'app,linux,kubernetes'
  'app,linux,container,kubernetes'
  'functionapp'
  'functionapp,linux'
  'functionapp,linux,container,kubernetes	'
  'functionapp,linux,kubernetes'
])
param kind string = 'app'
param location string = resourceGroup().location
param planId string
param webAppName string

resource webApp 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName
  location: location
  kind: kind
  properties: {
    enabled: true
    hostNameSslStates:[
      {
        name: '${webAppName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${webAppName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    httpsOnly: true
    serverFarmId: planId
    siteConfig: {
      alwaysOn: true
    }
  }
}
