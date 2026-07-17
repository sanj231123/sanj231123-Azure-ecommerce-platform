variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
  default     = "rg-ecommerce-dev"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "Central India"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "azure-ecommerce"
}
