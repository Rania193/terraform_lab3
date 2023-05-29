variable "created_vpc_id" {
  type = any
}

variable "ingress" {
  type = map(object({
    port         = number
    protocol     = string
    cidr_blocks  = list(string)
  }))
}

variable "egress" {
  type = object({
    port         = number
    protocol     = string
    cidr_blocks  = list(string)
  })
}

variable "sg_name" {
  type = string
}