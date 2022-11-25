// common
targetScope = 'subscription'

// parameters
////////////////////////////////////////////////////////////////////////////////

param rgLocation string = 'eastus'

// variables
////////////////////////////////////////////////////////////////////////////////

// rg for storage account, service bus, cosmos db & function app
var rgName = 'contoso-traders-rg'

// tags
var rgTags = {
  Product: 'contoso-traders'
  Environment: 'testing'
}

// resource groups
////////////////////////////////////////////////////////////////////////////////

resource contosoTradersResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
  tags: rgTags
}

// outputs
////////////////////////////////////////////////////////////////////////////////

output outputRgName string = contosoTradersResourceGroup.name
