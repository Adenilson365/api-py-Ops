variable "default_tags" {
  type        = map(string)
  description = "Tags Padrão para todos os recursos"
  default = {
  "ManegedBy" = "Terraform", 
  "Owner" = "Adenilson"}
}

variable "instance_master" {
  type    = string
  default = "t3.medium"
}
variable "instance_count_master" {
  type    = number
  default = 1
}
variable "instance_worker" {
  type    = string
  default = "t3.small"
}
variable "instance_count_worker" {
  type    = number
  default = 3
}

variable "ami_default" {
  type    = string
  default = "ami-064519b8c76274859"
}

variable "profile" {
  type = string
}

variable "default-region" {
  type    = string
  default = "us-east-1"
}

variable "key-name" {
  type = string

}


