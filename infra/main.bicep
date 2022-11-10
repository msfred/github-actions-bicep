// az deployment group create -f ./main.bicep -g rg-name
// az deployment sub create -f ./main.bicep -l location

targetScope = 'subscription'

@description('The environment that the resources are being deployed to.')
@allowed([
  'DEV'
  'QA'
  'PROD'
])
param environment string
param location string
param planName string
param rgName string
param slotName string = 'stage'
param webAppName string

// Resource Group is a dependency and will be created if it does not already exist
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

// Deploy the App Service Plan
module appPlanDeploy 'appPlan.bicep' = {
  name: 'appPlanDeploy'
  scope: rg
  params: {
    location: location
    planName: planName    
  }
}

// Deploy the Web App
module webAppDeploy 'webApp.bicep' = {
  name: 'webAppDeploy'
  scope: rg
  params: {
    location: location
    planId: appPlanDeploy.outputs.planId
    webAppName: webAppName
  }
}

// Deploy the Deployment Slot to the Web App
module slotDeploy 'slot.bicep' = if (environment == 'PROD') {
  name: 'slotDeploy'
  scope: rg
  params: {
    location: location
    planId: appPlanDeploy.outputs.planId
    slotName: slotName
    webAppName: webAppName
  }
}

output environmentId string = environment
output resourceGroupName string = rgName
output webAppName string = webAppName
