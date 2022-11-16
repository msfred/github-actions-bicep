// az deployment group create -f ./main.bicep -g rg-name
// az deployment sub create -f ./main.bicep -l location

targetScope = 'subscription'

param appInsights object
@description('The environment that the resources are being deployed to.')
@allowed([ 'DEV', 'QA', 'PROD' ])
param environment string
param location string
param plan object
param resourceGroup object
param slotName string = 'stage'
param webApp object

// Resource Group is a dependency and will be created if it does not already exist
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroup.name
  location: location
}

// Deploy the Applications Insights
module appInsightsDeploy 'appInsights.bicep' = {
  name: appInsights.name
  params: {
    kind: appInsights.kind
    location: location
    name: appInsights.name
  }
  scope: rg
}

// Deploy the App Service Plan
module appServicePlanDeploy 'appPlan.bicep' = {
  name: 'appServicePlanDeploy'
  scope: rg
  params: {
    location: location
    kind: plan.kind
    name: plan.name
    sku: plan.sku
  }
}

// Deploy the Web App
module webAppDeploy 'webApp.bicep' = {
  dependsOn: [ appServicePlanDeploy ]
  name: 'webAppDeploy'
  scope: rg
  params: {
    appInsightsInstrumentationKey: appInsightsDeploy.outputs.InstrumentationKey
    location: location
    name: webApp.name
    planId: appServicePlanDeploy.outputs.planId
  }
}

// Deploy the Deployment Slot to the Web App
module slotDeploy 'slot.bicep' = if (environment == 'PROD') {
  dependsOn: [ webAppDeploy ]
  name: 'slotDeploy'
  scope: rg
  params: {
    location: location
    planId: appServicePlanDeploy.outputs.planId
    slotName: slotName
    webAppName: webApp.name
  }
}

output environmentId string = environment
output resourceGroupName string = resourceGroup.name
output webAppName string = webApp.name
