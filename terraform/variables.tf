variable "name" {
  type    = string
  default = "demo"
}

variable "subnet_names" {
  type    = list(string)
  default = ["demo"]
}

variable "address_space" {
  type    = string
  default = "10.42.0.0/16"
}

variable "subnet_prefixes" {
  type    = list(string)
  default = ["10.42.0.0/24"]
}

variable "resource_group_location" {
  type    = string
  default = "East US"
}

variable "cluster_version" {
  type    = string
  default = "1.21.2"
}

variable "pool_name" {
  type    = string
  default = "system"
}

variable "pool_size" {
  type    = number
  default = 1
}

variable "node_size" {
  type    = string
  default = "Standard_D2_v2"
}

variable "tags" {
  type    = map(string)
  default = {
    Environment = "demo"
  }
}

variable "net_profile_dns_service_ip" {
  type    = string
  default = "10.0.0.10"
}

variable "net_profile_docker_bridge_cidr" {
  type    = string
  default = "170.10.0.1/16"
}

variable "net_profile_service_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
