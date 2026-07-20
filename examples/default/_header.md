# Default example

This example creates an AKS cluster with the latest `Azure/avm-res-containerservice-managedcluster/azurerm` module and installs the Flux extension.

Before deployment, register the required resource providers:

```bash
az provider register --namespace Microsoft.ContainerService --wait
az provider register --namespace Microsoft.KubernetesConfiguration --wait
```
