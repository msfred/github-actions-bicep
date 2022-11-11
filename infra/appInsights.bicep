@allowed(['web', 'ios', 'other', 'store', 'java', 'phone'])
param kind string
param location string = resourceGroup().location
param name string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  kind: kind
  location: location
  name: name
}

output InstrumentationKey string = appInsights.properties.InstrumentationKey
