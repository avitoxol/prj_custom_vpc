variable "webports" {
  type = list
  default = [22, 80, 443]
}

variable "counting" {
  default = "2"
}

variable "instname" {
  type = list
  default = ["one", "two"]
}

locals {
  subs = concat([aws_subnet.primary.id], [aws_subnet.secondary.id])
}
