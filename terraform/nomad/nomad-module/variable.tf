variable "myip_cidr" {
  description = "내 IP CIDR"
  default     = "0.0.0.0/0"
}

variable "client_count" {
  description = "Nomad Client Count"
  default     = 2
}