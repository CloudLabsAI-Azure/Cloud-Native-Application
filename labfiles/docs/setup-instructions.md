# Instructions

## Setting up ContosoTraders Infrastructure

1. You'll need a service principal in the `owner` role on the Azure subscription where the infrastructure is to be provisioned.
2. Git clone this repository to your machine.
3. Create the `SERVICEPRINCIPAL`, `ENVIRONMENT`, and `SQL_PASSWORD` github secrets ([instructions here](./github-secrets.md)).
4. Modify the source files mentioned [in the 'pre-deployment' section of this document](./manual-steps.md#pre-deployment). Replace `<ENVIRONMENT>` with the [value used above](./github-secrets.md).
5. Next, provision the infrastructure on Azure by running the `contoso-traders-infra-provisioning` github workflow. You can do this by going to the github repo's `Actions` tab, selecting the workflow, and clicking on the `Run workflow` button.
6. Next, set the `ACR_PASSWORD` github secret ([instructions here](./github-secrets.md)).
7. Next, deploy the apps, by running the `contoso-traders-app-deployment` workflow.

> To set up ContosoTrader in CloudLabs, you have create a fork of this github repository (one fork per lab). Then you have to repeat the same steps as above using the forked repo.

## Running ContosoTraders Locally

1. First ensure that the infrastructure setup has been completed as per steps above.
2. Ensure that you have the following installed:
   * [Node v16.18.0](https://nodejs.org/download/release/v16.8.0/)
   * [DOTNET 6 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
   * [AZ CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
3. Login to AZ CLI using the [service principal details](./github-secrets.md):
   * `az login --service-principal -u <clientId> -p <clientSecret> --tenant <tenantId>`
4. Run the Products API locally:
   * Open a cmd window and navigate to the `src/TailwindTraders.Api.Products` folder.
   * Run `dotnet user-secrets set "KeyVaultEndpoint" "https://tailwindtraderskv<ENVIRONMENT>.vault.azure.net/"`. Replace `<ENVIRONMENT>` with the [value used above](./github-secrets.md).
   * Run `dotnet build && dotnet run`. This will start the web API on `https://localhost:62300/swagger`.
   * Note that your browser may show you a warning about insecure connection which you can safely ignore.
5. Run the Carts API locally
   * Open a cmd window and navigate to the `src/TailwindTraders.Api.Carts` folder.
   * Run `dotnet user-secrets set "KeyVaultEndpoint" "https://tailwindtraderskv<ENVIRONMENT>.vault.azure.net/"`. Replace `<ENVIRONMENT>` with the [value used above](./github-secrets.md).
   * Run `dotnet build && dotnet run`. This will start the web API on `https://localhost:62300/swagger`.
   * Note that your browser may show you a warning about insecure connection which you can safely ignore.
6. Run the UI locally:
   * Open a cmd window and navigate to the `src/TailwindTraders.Ui.Website` folder.
   * Run `npm install`.
   * Run `npm run start`. This will start the UI on `http://localhost:3000`.
