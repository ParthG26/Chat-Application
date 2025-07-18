variable "region" {
type = string
default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnets" {
  default = {
    Public1  = { cidr = "10.0.1.0/24", az = "ap-south-1a" }
    Public2  = { cidr = "10.0.2.0/24", az = "ap-south-1b" }
    Private1 = { cidr = "10.0.3.0/24", az = "ap-south-1a" }
    Private2 = { cidr = "10.0.4.0/24", az = "ap-south-1b" }
  }
}

variable "tags" {
type = map(string)
default = {
    terraform  = "true"
    kubernetes = "Terraform-EKS-Cluster"
}
description = "Tags to apply to all resources"
}

variable "eks_version" {
type = string
default = "1.31"
description = "EKS version"
}

variable "cluster_name" {
type = string
default = "Terraform-EKS-Cluster"
description = "value of the EKS cluster name"
  
}
