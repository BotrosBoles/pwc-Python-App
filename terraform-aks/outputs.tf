output "resource_group_name" {
  value = azurerm_resource_group.aks.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
