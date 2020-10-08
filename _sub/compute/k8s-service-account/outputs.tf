output "deploy_user_config" {
  value = data.external.get-token.result["kubeconfig_json"]
}

output "selfservice_deploy_config" {
  value = data.external.get-token-selfservice-deploy.result["kubeconfig_json"]
}

