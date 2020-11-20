variable "chart_version" {
  type        = string
  description = "Traefik helm chart version"
  default     = null
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy Traefik in"
}

variable "replicas" {
  type = number
  description = "Number of Traefik replicas"
}

variable "log_level" {
  type = string
  description = "Traefik log level"
  default = "ERROR"

  validation {
    condition = length(regexall("(ERROR|DEBUG|PANIC|FATAL|WARN|INFO)", var.log_level)) > 0
    error_message = "LOG LEVEL not a valid option. It should be either ERROR, DEBUG, PANIC, FATAL, WARN or INFO."
  }
}

variable "priority_class" {
  type = string
  description = "Traefik priority class"
}

variable "name" {
  type = string
  description = "Name of Traefik chart (deployment, service)"
  default = "traefik-v2"
}

variable "traefik_node_port" {
  type = number
  description = "Traefik/admin node port"
}

variable "web_node_port" {
  type = number
  description = "Traefik web traffic node port"
}
