variable "name_prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}
