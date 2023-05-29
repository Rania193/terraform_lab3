variable "key_name" {
    type = any
}

variable "instance_type" {
  type = string
}

variable "pub_sg" {
  type = list
}

variable "priv_sg" {
  type = list
}

variable "instance_us" {
  type = any
}

variable "pub_associate_ip" {
  type = bool
}

variable "priv_associate_ip" {
  type = bool
}

variable "pub_instance_name" {
  type = list
}

variable "priv_instance_name" {
  type = list
}

variable "pub_sub" {
  type = list
}

variable "priv_sub" {
  type = list
}

variable "lb_dns" {
  type = any
}