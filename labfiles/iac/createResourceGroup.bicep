// common
targetScope = 'subscription'

// parameters
////////////////////////////////////////////////////////////////////////////////

param rgLocation string = 'eastus'

// variables
////////////////////////////////////////////////////////////////////////////////

// rg for storage account, service bus, cosmos db & function app
var rgName = 'tailwind-traders-rg'

// tags
var rgTags = {
  Product: 'tailwind-traders'
  Environment: 'testing'
}

// resource groups
////////////////////////////////////////////////////////////////////////////////

resource tailwindTradersResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
  tags: rgTags
}

// outputs
////////////////////////////////////////////////////////////////////////////////

output outputRgName string = tailwindTradersResourceGroup.name
