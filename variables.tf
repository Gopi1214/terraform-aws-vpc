variable "cidr_block" {
  default = "10.0.0.0/16"  #users can override
  type = string
}

variable "enable_dns_hostnames" {
    default = true
    type  = bool
}

variable "commn_tags" {
    default = {}    #it is optional
    type = map
}

variable "vpc_tags" {
    default = {}
    type = map
}

variable "project_name" {
    type = string
}

variable "environment" {
   type = string
}
  
variable "igw_tags" {
    type = map
    default = {}
}

variable "public_subnets_tags" {
   default = {}
}

# variable "subnets" {
#     type = list
#     default = ["public", "private", "database"]
# } 

variable "public_subnets_cidr" {
    type = list
    validation {
      condition = length(var.public_subnets_cidr) == 2
      error_message = "please give 2 pulic valid subnet CIDR"
    }
}

variable "private_subnets_tags" {
   default = {}
}

variable "private_subnets_cidr" {
    type = list
    validation {
        condition = length(var.private_subnets_cidr) == 2
        error_message = "please give 2 private valid subnet CIDR"
    }
}

variable "database_subnets_tags" {
   default = {}
}

variable "database_subnets_cidr" {
    type = list
    validation {
        condition = length(var.database_subnets_cidr) == 2
        error_message = "please give 2 database valid subnet CIDR"
    }
}

variable "nat_gateway_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
    default = {}
}

variable "is_vpc_peering_required" {
    type = bool
    default = false
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags" {
    default = {}
}



