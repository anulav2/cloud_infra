variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "vpc_test_cidr" {
  default = "172.16.0.0/24"
}

variable "private-1a_cidr" {
  default = "172.16.1.0/24"
}

variable "private-1b_cidr" {
  default = "172.16.2.0/24"
}

variable "environment_map" {
  type = map(string)
  default = {
    "Dev"   = "Dev"
    "Stage" = "Stage",
    "Prod"  = "Prod"
  }
}

variable "environment_list" {
  type    = list(string)
  default = ["Dev", "Stage", "Prod"]
}

variable "instance_type" {
  type = map(string)
  default = {
    "Dev" = "t2.micro",
    #    "Stage" = "t2.micro"
    #    "Prod"  = "t2.micro"
  }
}

variable "env_instance_settings" {
  type = map(object({ instance_type = string, monitoring = bool }))
  default = {
    "Dev" = {
      instance_type = "t2.micro"
      monitoring    = false
    }
    "Stage" = {
      instance_type = "t2.micro"
      monitoring    = false
    }
    "Prod" = {
      instance_type = "t2.micro"
      monitoring    = true
    }
  }
}

variable "deploy_environment" {
  type    = string
  default = "Dev"
}

variable "instance_count" {
  default = 1
}