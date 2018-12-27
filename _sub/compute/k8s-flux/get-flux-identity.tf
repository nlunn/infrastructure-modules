resource "local_file" "get-flux-identity" {

    content = ""
    filename = "${pathexpand("~/flux_public_ssh")}"

    provisioner "local-exec" {
        command = "fluxctl --k8s-fwd-ns=${var.namespace} identity > ${pathexpand("~/flux_public_ssh")}"
        environment {
            USER = "root"
            KUBECONFIG =  "${pathexpand("~/.kube/config_${var.cluster_name}")}"
        }
    }

    depends_on = ["kubernetes_deployment.flux"]
}

data "local_file" "identity" {
    filename = "${pathexpand("~/flux_public_ssh")}"
    depends_on = ["local_file.get-flux-identity"]
}