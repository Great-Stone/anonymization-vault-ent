terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0.1"
    }
  }
}

provider "aws" {
  alias  = "seoul"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "usa"
  region = "us-east-1"
}

data "http" "myip" {
  url = "https://api.myip.com"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  myip_cidr = "${jsondecode(data.http.myip.response_body).ip}/32"
}

module "nomad_seoul" {
  source = "./nomad-module"
  providers = {
    aws = aws.seoul
  }
  myip_cidr = local.myip_cidr
}

module "nomad_usa" {
  source = "./nomad-module"
  providers = {
    aws = aws.usa
  }
  myip_cidr = local.myip_cidr
}

output "seoul_server" {
  value = "http://${module.nomad_seoul.server_ip}:4646"
}

output "seoul_clients" {
  value = module.nomad_seoul.client_ips
}

output "usa_server" {
  value = "http://${module.nomad_usa.server_ip}:4646"
}

output "usa_clients" {
  value = module.nomad_usa.client_ips
}