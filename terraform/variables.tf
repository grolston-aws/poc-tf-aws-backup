# Input variable definitions

variable "aws_region" {
  description = "Name of AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cold_storage_after" {
  description = "Days in time to transfer to cold storage"
  type        = number
  default     = 21
}

variable "delete_after" {
  description = "Days in time to delete backup"
  type        = number
  default     = 111
}
