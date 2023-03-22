variable "environment_suffix" {
  type        = string
  default     = "-dev"
  description = "procure le suffixe indiquant l'env. cible"
}

variable "location" {
  type = string
  default = "West Europe"
}

variable "project_name" {
  type = string
}
