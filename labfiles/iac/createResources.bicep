// common
targetScope = 'resourceGroup'

// parameters
////////////////////////////////////////////////////////////////////////////////

// common
@minLength(3)
@maxLength(6)
@description('A unique environment name (max 6 characters, alphanumeric only).')
param environment string

@secure()
@description('A password which will be set on all SQL Azure DBs.')
param sqlPassword string // @TODO: Obviously, we need to fix this!

param resourceLocation string = resourceGroup().location

// tenant
param tenantId string = subscription().tenantId

// aks
param aksLinuxAdminUsername string // value supplied via parameters file

param prefix string = 'contosotraders'

param prefixHyphenated string = 'contoso-traders'

// variables
////////////////////////////////////////////////////////////////////////////////

// key vault
var kvName = '${prefix}kv${environment}'
var kvSecretNameProductsApiEndpoint = 'productsApiEndpoint'
var kvSecretNameProductsDbConnStr = 'productsDbConnectionString'
var kvSecretNameProfilesDbConnStr = 'profilesDbConnectionString'
var kvSecretNameStocksDbConnStr = 'stocksDbConnectionString'
var kvSecretNameCartsApiEndpoint = 'cartsApiEndpoint'
var kvSecretNameCartsDbConnStr = 'cartsDbConnectionString'
var kvSecretNameImagesEndpoint = 'imagesEndpoint'

var kvSecretNameAppInsightsConnStr = 'appInsightsConnectionString'

// cosmos db (stocks db)
var stocksDbAcctName = '${prefixHyphenated}-stocks${environment}'
var stocksDbName = 'stocksdb'
var stocksDbStocksContainerName = 'stocks'

// cosmos db (carts db)
var cartsDbAcctName = '${prefixHyphenated}-carts${environment}'
var cartsDbName = 'cartsdb'
var cartsDbStocksContainerName = 'carts'

// sql azure (products db)
var productsDbServerName = '${prefixHyphenated}-products${environment}'
var productsDbName = 'productsdb'
var productsDbServerAdminLogin = 'localadmin'
var productsDbServerAdminPassword = sqlPassword



// azure container app (carts api)
var cartsApiAcaEnvName = '${prefix}acaenv${environment}'
var cartsApiAcaSecretAcrPassword = 'acr-password'
var cartsApiAcaContainerDetailsName = '${prefixHyphenated}-carts${environment}'

// storage account (product images)
var productImagesStgAccName = '${prefix}img${environment}'
var productImagesProductDetailsContainerName = 'product-details'
var productImagesProductListContainerName = 'product-list'

// storage account (old website)


// storage account (new website)


// storage account (image classifier)
var imageClassifierStgAccName = '${prefix}ic${environment}'
var imageClassifierWebsiteUploadsContainerName = 'website-uploads'

// cdn
var cdnProfileName = '${prefixHyphenated}-cdn${environment}'
var cdnImagesEndpointName = '${prefixHyphenated}-images${environment}'
var cdnUiEndpointName = '${prefixHyphenated}-ui${environment}'
var cdnUi2EndpointName = '${prefixHyphenated}-ui2${environment}'

// redis cache
var redisCacheName = '${prefixHyphenated}-cache${environment}'

// azure container registry
var acrName = '${prefix}acr${environment}'
// var acrCartsApiRepositoryName = '${prefix}apicarts' // @TODO: unused, probably remove later

// load testing service
var loadTestSvcName = '${prefixHyphenated}-loadtest${environment}'

// application insights
var logAnalyticsWorkspaceName = '${prefixHyphenated}-loganalytics${environment}'
var appInsightsName = '${prefixHyphenated}-ai${environment}'

// portal dashboard
var portalDashboardName = '${prefixHyphenated}-dashboard${environment}'

// aks cluster
var aksClusterName = '${prefixHyphenated}-aks${environment}'
var aksClusterDnsPrefix = '${prefixHyphenated}-aks${environment}'
var aksClusterNodeResourceGroup = '${prefixHyphenated}-aks-nodes-rg-801077'

// tags
var resourceTags = {
  Product: prefixHyphenated
  Environment: 'testing'
}

// resources
////////////////////////////////////////////////////////////////////////////////

//
// key vault
//

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: kvName
  location: resourceLocation
  tags: resourceTags
  properties: {
    // @TODO: Hack to enable temporary access to devs during local development/debugging.
    accessPolicies: [
      {
        objectId: '31de563b-fc1a-43a2-9031-c47630038328'
        tenantId: tenantId
        permissions: {
          secrets: [
            'get'
            'list'
            'delete'
            'set'
            'recover'
            'backup'
            'restore'
          ]
        }
      }
    ]
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: tenantId
  }

  // secret
  resource kv_secretProductsApiEndpoint 'secrets' = {
    name: kvSecretNameProductsApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the products api'
      value: 'placeholder' // Note: This will be set via github worfklow
    }
  }

  // secret 
  resource kv_secretProductsDbConnStr 'secrets' = {
    name: kvSecretNameProductsDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the products db'
      value: 'Server=tcp:${productsDbServerName}.database.windows.net,1433;Initial Catalog=${productsDbName};Persist Security Info=False;User ID=${productsDbServerAdminLogin};Password=${productsDbServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;' // @TODO: hack, fix later
    }
  }

  // secret 
  resource kv_secretProfilesDbConnStr 'secrets' = {
    name: kvSecretNameProfilesDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the profiles db'
      value: 'Server=tcp:${profilesDbServerName}.database.windows.net,1433;Initial Catalog=${profilesDbName};Persist Security Info=False;User ID=${profilesDbServerAdminLogin};Password=${profilesDbServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;' // @TODO: hack, fix later
    }
  }


 
  }

  // secret
  resource kv_secretAppInsightsConnStr 'secrets' = {
    name: kvSecretNameAppInsightsConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the app insights instance'
      value: appinsights.properties.ConnectionString
    }
  }




// sql azure server
resource productsdbsrv 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: productsDbServerName
  location: resourceLocation
  tags: resourceTags
  properties: {
    administratorLogin: productsDbServerAdminLogin
    administratorLoginPassword: productsDbServerAdminPassword
    publicNetworkAccess: 'Enabled'
  }

  // sql azure database
  resource productsdbsrv_db 'databases' = {
    name: productsDbName
    location: resourceLocation
    tags: resourceTags
    sku: {
      capacity: 5
      tier: 'Basic'
      name: 'Basic'
    }
  }

  // sql azure firewall rule (allow access from all azure resources/services)
  resource productsdbsrv_db_fwlallowazureresources 'firewallRules' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }

  // @TODO: Hack to enable temporary access to devs during local development/debugging.
  resource productsdbsrv_db_fwllocaldev 'firewallRules' = {
    name: 'AllowLocalDevelopment'
    properties: {
      endIpAddress: '255.255.255.255'
      startIpAddress: '0.0.0.0'
    }
  }
}



//

// storage account (product images)
resource productimagesstgacc 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: productImagesStgAccName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  // blob service
  resource productimagesstgacc_blobsvc 'blobServices' = {
    name: 'default'

    // container
    resource productimagesstgacc_blobsvc_productdetailscontainer 'containers' = {
      name: productImagesProductDetailsContainerName
      properties: {
        publicAccess: 'Container'
      }
    }

    // container
    resource productimagesstgacc_blobsvc_productlistcontainer 'containers' = {
      name: productImagesProductListContainerName
      properties: {
        publicAccess: 'Container'
      }
    }
  }
}



resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: acrName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}

//

// log analytics workspace
resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: resourceLocation
  tags: resourceTags
  properties: {
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    sku: {
      name: 'PerGB2018' // pay-as-you-go
    }
  }
}

// app insights instance



//

resource aks 'Microsoft.ContainerService/managedClusters@2022-09-02-preview' = {
  name: aksClusterName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: aksClusterDnsPrefix
    nodeResourceGroup: aksClusterNodeResourceGroup
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: 0 // Specifying 0 will apply the default disk size for that agentVMSize.
        count: 3
        vmSize: 'standard_d2s_v3'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: aksLinuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: loadTextContent('rsa.pub') // @TODO: temporary hack, until we autogen the keys
          }
        ]
      }
    }
    // Note: Commented out due to github issue #84: https://github.com/CloudLabs-AI/ContosoTraders/issues/84
    
  }
}

// outputs
////////////////////////////////////////////////////////////////////////////////
