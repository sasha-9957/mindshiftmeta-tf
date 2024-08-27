variable "region" {
  default = "eu-central-1"
}

variable "vpc_id" {
  description = "MSM-DEV"
  type        = string
  default     = "vpc-0d0e29c7851a13c3b"
}

variable "public_subnet_1c" {
  description = "MSM-DEV-public-eu-central-1c"
  type        = string
  default     = "subnet-0dca0997fb6c828f5"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.medium"
}

variable "image_ami" {
  description = "Amazon Linux 2023"
  type        = string
  default     = "ami-0de02246788e4a354"
}

variable "allow_ports" {
  description = "List of ports to open"
  type        = list(any)
  default     = ["22", "80", "443"]
}

variable "enable_detailed_monitoring" {
  description = "Enable monitoring"
  default     = false
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(any)

  default = {
    "Environment" = "dev"
    "Provisioner" = "terraform"
    "Product"     = "web-landing"
  }
}
