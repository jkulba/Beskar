# Azurite Storage Emulator

## Description

When developing Azure functions that use Azure Storage: Queue, Blob, Table, the Azurite storage emulator allows development on your local computer. Installation is easy on whatever OS you are working on.

### Installation

- Please refer to the official Microsoft documentation for installation [instructions](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio).
- Azurite comes pre-bundled with Visual Studio 2022.
- I prefer the npm installation on both Linux and Windows 10.
- I tried the Visual Studio Code Azurite Extension and I prefer running Azurite in a PowerShell window.
- NodeJs is a prerequisite for all operating systems if you use the npm version.

On Linux - Create a new hidden directory to store the log and the storage files.

```shell
mkdir ~/.azurite
```

On Windows - Create a new hidden directory to store the log and the storage files.

```shell
mkdir ~/.azurite
```

### Run Azurite

```shell
azurite --location ~/.azurite --debug ~/.azurite/debug.log
```

## Azure Storage Explorer

The Azure Storage Explorer is a separate tool that
[Download Azure Storage Explorer](https://azure.microsoft.com/en-us/products/storage/storage-explorer/#overview)
