# Azure Function Project Setup

## DEVELOPMENT ENVIRONMENT

- dotnet --version -> 6.0.106
- Visual Studio Code
- Azure Functions Extension
- Azure function core tools - https://docs.microsoft.com/en-us/azure/azure-functions/

## CREATE NEW PROJECT

1. Created new project in GitHub named BeskarFunctions
1. Added a README.md
1. Added a gitignore file
1. Cloned the new project down to local development machine

## INITIALIZE NEW FUNCTIONS PROJECT

1. Navigate into the BeskarFunctions directory
1. func init --force //The force flag is needed to overwrite the existing gitignore file.

> **NOTE**
> At this point I open VS Code. VS Code detects that the project is a Azure functions project.

## CREATE NEW HTTP FUNCTION

> **For Reference:** [Create Azure Function using az CLI](https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-csharp?tabs=azure-cli%2Cin-process)

1. func new --name SubmitTask --template "HTTP trigger" --authlevel "function"

## RUN FUNCTION LOCALLY

1. func start
