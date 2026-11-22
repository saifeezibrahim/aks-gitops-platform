variable "prefix" {
  type        = string
  default     = "gitopslab"
  description = "Short name used in every resource name. Lowercase letters and numbers only."
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "AKS version. null = the current default version in the region."
}

variable "node_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "app_namespace" {
  type    = string
  default = "sample-app"
}

variable "tags" {
  type = map(string)
  default = {
    project = "aks-gitops-platform"
    owner   = "saifeezibrahim"
    purpose = "portfolio-lab"
  }
}

variable "admin_ip_cidrs" {
  type        = list(string)
  description = "Public IPs allowed to reach the AKS API server and Key Vault, e.g. [\"203.0.113.10/32\"]. Find yours with: curl -s ifconfig.me"
}
