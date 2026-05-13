variable "token" {
  type      = string
  sensitive = true
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vpc_name" {
  type    = string
  default = "develop"
}

variable "subnet_public" {
  type    = string
  default = "public"
}

variable "subnet_private" {
  type    = string
  default = "private"
}

variable "public_cidr" {
  type    = list(string)
  default = ["192.168.10.0/24"]
}

variable "private_cidr" {
  type    = list(string)
  default = ["192.168.20.0/24"]
}

variable "route_table" {
  type    = string
  default = "private-route-table"
}

variable "nat" {
  type = object({
    vm_name      = string
    platform_id  = string
    cpu          = number
    ram          = number
    core_fraction = number
    disk         = number
  })
  default = {
    vm_name       = "nat"
    platform_id   = "standard-v1"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk          = 10
  }
}

variable "vm_public" {
  type = object({
    vm_name      = string
    platform_id  = string
    cpu          = number
    ram          = number
    core_fraction = number
    disk         = number
  })
  default = {
    vm_name       = "test-public"
    platform_id   = "standard-v1"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk          = 10
  }
}

variable "vm_private" {
  type = object({
    vm_name      = string
    platform_id  = string
    cpu          = number
    ram          = number
    core_fraction = number
    disk         = number
  })
  default = {
    vm_name       = "test-private"
    platform_id   = "standard-v1"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk          = 10
  }
}
