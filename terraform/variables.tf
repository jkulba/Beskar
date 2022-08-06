variable "project" {
  type        = string
  description = "Project Name"
  default     = "beskar"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "westus"
}

variable "team" {
  type        = string
  description = "Engineering Team"
  default     = "DevOps"
}
