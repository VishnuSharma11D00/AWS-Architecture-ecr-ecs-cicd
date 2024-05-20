variable "bucket_name" {
  description = "Remote S3 Bucket name"
  type = string
  validation {
    condition = can(regex("^([a-z0-9]{1}[a-z0-9-]{1,61}[a-z0-9]{1})$",var.bucket_name))
    error_message = "Bucket name must not be empty and must follow S3 naming rules"
  }
}

variable "table_name" {
  description = "Remote Dynamodb Table Name"
  type = string
}