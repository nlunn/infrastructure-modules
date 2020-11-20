resource "helm_release" "traefik" {
  name          = var.name
  chart         = "traefik"
  repository    = "https://helm.traefik.io/traefik"
  version       = var.chart_version != null ? var.chart_version : null
  namespace     = var.namespace
  recreate_pods = true
  force_update  = false

  values = [
    templatefile("${path.module}/values/values.yaml", {
      name              = var.name
      replicas          = var.replicas
      log_level         = var.log_level
      priority_class    = var.priority_class
      traefik_node_port = var.traefik_node_port
      web_node_port     = var.web_node_port
    }),
  ]
}
